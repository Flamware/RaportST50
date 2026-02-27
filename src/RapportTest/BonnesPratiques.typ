// --- Configuration du document ---
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)
#set text(
  font: "New Computer Modern",
  lang: "fr",
  size: 11pt
)
#set par(justify: true)
#set heading(numbering: "1.1.")

// --- Macros pour le style ---
#let code-block(body) = block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  body
)

#let note(body) = block(
  fill: rgb("#e8f4fd"),
  stroke: (left: 2pt + blue),
  inset: 10pt,
  width: 100%,
  [*Note technique :* #body]
)
#import "@preview/codelst:2.0.2": sourcecode

// --- Page de Titre ---
#align(center + horizon)[
  #text(size: 20pt, weight: "bold")[Standardisation des Tests Logiciels\ en Architecture Microservices]

  #v(1cm)
  #text(size: 14pt)[Projet Magellium - Stack Java Spring Boot]

  #v(2cm)
  *Auteur :* ANTUNES Axel\
  *Date :* #datetime.today().display("[day] [month repr:long] [year]")
]
#pagebreak()

// --- Contenu ---

= Introduction

L'analyse de performance récent sur le module `fs-core` a mis en évidence des temps de build excessifs (supérieurs à 6 minutes) dus à une mauvaise gestion du cycle de vie des tests. Ce document définit les standards à appliquer pour réduire la boucle de feedback (Feedback Loop)#footnote[Feedback Loop : Délai entre l'écriture du code et le retour d'information du test. Plus ce délai est court, plus la correction est efficace.] et optimiser la consommation des ressources.

= La Pyramide des Tests

Nous adoptons le modèle de la pyramide des tests.

== Répartition Cible

- *Unitaires (70%) :* Socle de la stabilité. Exécution instantanée en millisecondes.
- *Intégration (20%) :* Validation des interfaces et configurations (BDD, mutualisation Spring).
- *E2E / API (10%) :* Validation des flux critiques par un client externe hors JVM.

= Implémentation Technique

== Tests Unitaires (Unit Tests)

*Rôle et Utilité :*
Validation de la logique algorithmique interne de manière isolée. L'exécution doit s'effectuer en quelques millisecondes.

*Périmètre :* Classes de service, utilitaires, règles métier.
*Contrainte :* Isolation totale. Aucun contexte Spring ne doit être chargé.

#sourcecode[```java
// MAUVAISE PRATIQUE : SpringBootTest (Lourd et inadapté)
@SpringBootTest // Charge tout le contexte applicatif inutilement
class CommandeServiceTest {
    @Autowired private CommandeService service;
    @MockBean private Repository repo;

    @Test
    void calculTva_nominal() {
        when(repo.getTaux()).thenReturn(20.0);
        // ...
    }
}

// BONNE PRATIQUE : MockitoExtension (Rapide et isolé)
@ExtendWith(MockitoExtension.class)
class CommandeServiceTest {
    @Mock private Repository repo;
    @InjectMocks private Service service;

    @Test
    void calculTva_nominal() {
        when(repo.getTaux()).thenReturn(20.0);
        // ...
    }
}
```]

== Tests d'Intégration (Integration Tests) et "Slice Testing"

*Rôle et Utilité :*
Vérification des interactions entre les composants logiciels et l'infrastructure (Base de données, API externes, requêtes HTTP).

*L'écueil du Monolithe de Test :*
L'utilisation systématique de `@SpringBootTest` charge l'intégralité de l'application (plus de 2000 beans constatés lors de l'audit de `fs-core`). Le temps de "Cold Start" atteint environ 45 secondes pour un seul test.

*Solution :* Le "Slice Testing"#footnote[Slice Testing : Technique consistant à ne charger qu'une "tranche" du contexte Spring (ex: uniquement la couche Web avec `@WebMvcTest`) pour réduire le nombre de beans, abaissant ainsi le temps de démarrage.].

#sourcecode[```java
// MAUVAISE PRATIQUE : Chargement complet pour un contrôleur
@SpringBootTest
@AutoConfigureMockMvc
class NdoseControllerTest {
    @Autowired MockMvc mockMvc;
    // Démarrage : ~45 secondes (2006 beans chargés)
}

// BONNE PRATIQUE : "Slice Test" Web
@WebMvcTest(NdoseController.class)
class NdoseControllerTest {
    @Autowired MockMvc mockMvc;
    @MockBean NdoseService service;
    // Démarrage : ~3 secondes (Uniquement la couche HTTP/Sécurité)
}
```]

== Tests API avec Bruno (Smoke Tests & E2E)

*Rôle et Utilité :*
Validation du système du point de vue d'un client externe en condition réelle (boîte noire). L'objectif est de s'affranchir du contexte Java (JVM) pour valider les contrats HTTP et les scénarios métiers complexes de bout en bout.

Nous divisons ces tests en deux catégories distinctes, s'exécutant sur des environnements isolés via Bruno.

=== 1. Les Smoke Tests (Tests de Surface)
*Objectif :* Vérifier instantanément la disponibilité des endpoints et la conformité des contrats de données (HATEOAS, formats JSON) sans altérer l'état de la base de données.
*Périmètre :* Essentiellement des requêtes `GET` classées par domaines (ex: `01-Identity-Security`, `02-Agronomy`).
*Environnement cible :* `admin, farmer etc.` (à discutter avec Mathieu).

=== 2. Les Tests d'Intégration End-to-End (E2E)
*Objectif :* Valider des cycles de vie complets (ex: Création d'une coopérative -> Ajout d'un utilisateur -> Login ).
*Environnement cible :* `integration` (Jeu de données isolé).

*Stratégie "Zéro-Nettoyage" (Clean-First) :*
Pour garantir la rejouabilité infinie sur la CI sans générer de conflits en base de données (ex: erreurs `Duplicate Key`), chaque exécution doit générer ses propres identifiants uniques via les scripts `Pre Request` de Bruno.

#sourcecode[```js
// PRATIQUE REQUISE : Script Pre-Request Bruno (Génération dynamique)
const uuid = require("uuid");
bru.setVar("dynamicEmail", `user-${Date.now()}@agri.fr`);
bru.setVar("coopId", uuid.v4());
```]

#sourcecode[```js
// PRATIQUE REQUISE : Requête et Assertions robustes
post {
  url: {{baseUrl}}/api/users
  body: json {
    {
      "email": "{{dynamicEmail}}",
      "cooperativeId": "{{coopId}}"
    }
  }
}

assert {
  res.status: in [200, 201]
  res.body.id: isDefined
  res.body.email: eq {{dynamicEmail}}
}
```]

#note[L'exécution dans la CI s'effectue à la racine des collections "Smoke-Tests" et "Intégration" via les commandes : `bru run --env "roleSouhaité"` (smoke tests) et `bru run --env integration` (tests d'intégration).]

= Performance et "Context Caching"

La lenteur des suites de tests Java provient de la fragmentation du contexte Spring. L'outil `spring-test-profiler` a démontré que des variations de configuration forcent Spring à redémarrer le contexte applicatif plusieurs fois.

*Problème :* L'utilisation de `@MockBean`, `@SpyBean`, `@DirtiesContext` ou `@Import` dans des classes de test individuelles modifie la signature du contexte. Le cache est invalidé, causant des "Cache Misses".

*Solution :* Centraliser la configuration dans une classe parente abstraite pour mutualiser le démarrage.

#sourcecode[```java
// BONNE PRATIQUE : Contexte Partagé via héritage
@SpringBootTest(classes = FarmstarCoreApplication.class)
@AutoConfigureMockMvc
public abstract class AbstractIntegrationTest {
    // Les définitions spécifiques qui brisent le cache
    // doivent être centralisées ici une seule fois.
    @MockBean
    protected ModulationRequestSource modulationRequestSource;

    @SpyBean
    protected ModulationService modulationService;
}

// Les tests héritent de la configuration, garantissant un "Cache Hit" (99%+)
class ModulationRequestTest extends AbstractIntegrationTest {
    // Le test utilise le contexte existant sans déclencher de redémarrage.
}
```]

= Conclusion

L'application de ces standards d'architecture de test pourrait permetre de résoudre les anomalies de performance identifiées lors de l'analyse des tests. La limitation stricte des redémarrages de contexte (via `AbstractIntegrationTest`) couplée à la réduction du poids d'initialisation (via `@WebMvcTest` et Bruno) pourrait aider à avoir un pipeline CI + optimal et + efficace pour l'ensemble de l'équipe.