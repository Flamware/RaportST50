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

L'analyse de performance récente sur le module `fs-core` a mis en évidence des temps de build excessifs (supérieurs à 6 minutes) dus à une mauvaise gestion du cycle de vie des tests. Ce document définit les standards à appliquer pour réduire la boucle de feedback (Feedback Loop)#footnote[Feedback Loop : Délai entre l'écriture du code et le retour d'information du test. Plus ce délai est court, plus la correction est efficace.] et optimiser la consommation des ressources.

= La Pyramide des Tests

Nous adoptons le modèle de la pyramide des tests.

== Répartition Cible

- *Unitaires (70%) :* Socle de la stabilité. Exécution instantanée en millisecondes.
- *Intégration (20%) :* Validation des interfaces internes et configurations (BDD, mutualisation Spring).
- *E2E / API (10%) :* Validation des flux HTTP critiques par un client externe (Bruno).

= Implémentation Technique

== Tests Unitaires (Unit Tests)

*Rôle et Utilité :*
Validation de la logique algorithmique interne de manière isolée. L'exécution doit s'effectuer en quelques millisecondes.

*Périmètre (Classes Primaires) :* DTOs, Entités, mappers, algorithmes purs et règles de calcul isolées. Ces classes se suffisent à elles-mêmes et ne dépendent d'aucun framework lourd.
*Méthode (Données Primaires) :* Privilégier l'injection de données brutes via des générateurs statiques ou des "Data Providers" (ex: tests paramétrés) pour valider de multiples scénarios métier instantanément.
*Contrainte :* Isolation totale. Interdiction stricte de charger un contexte Spring.

#sourcecode[```java
// MAUVAISE PRATIQUE : SpringBootTest (Lourd et inadapté pour du calcul pur)
@SpringBootTest // Charge tout le contexte applicatif inutilement
class DosageCalculatorTest {
    @Autowired private DosageCalculator calculator;

    @Test
    void calculate_nominal() {
        // ...
    }
}

// BONNE PRATIQUE n°1 : Isolation pure avec Mockito (si dépendances)
@ExtendWith(MockitoExtension.class)
class EligibilityServiceTest {
    @Mock private CropRepository repository;
    @InjectMocks private EligibilityService service;

    @Test
    void verify_ShouldReturnTrue() {
        when(repository.existsByName("WHEAT")).thenReturn(true);
        assertTrue(service.verify("WHEAT"));
    }
}

// BONNE PRATIQUE n°2 : "Data-Driven Testing" pour les classes primaires
@ParameterizedTest(name = "Culture: {0}, Surface: {1}ha => Dose attendue: {2}L")
@CsvSource({
    "WHEAT,  10.0,  400.0", // Injection des données primaires
    "CORN,   20.0, 1000.0",
    "BARLEY,  5.0,  150.0"
})
void calculateTotalDose_ShouldReturnCorrectValue(String type, double area, double expected) {
    // Action sur une classe primaire pure
    double result = DosageCalculator.calculate(type, area);

    // Vérification instantanée
    assertEquals(expected, result);
}
```]

== Tests d'Intégration (Integration Tests)

*Rôle et Utilité :*
Vérification des interactions entre les composants logiciels internes et l'infrastructure (Base de données, connecteurs externes).

*Attention au Périmètre :* L'utilisation de `MockMvc` pour tester les contrôleurs et les flux HTTP est désormais proscrite en Java. Ces validations sont entièrement déléguées à l'outil Bruno. Les tests d'intégration Java se concentrent exclusivement sur les couches inférieures (Services et Repositories).

*Contrainte :* Utilisation obligatoire du contexte mutualisé (voir section "Performance et Context Caching") pour éviter la "taxe de démarrage" (Cold Start) qui allongeait le temps de build.

== Tests API avec Bruno (Smoke Tests & E2E)

*Rôle et Utilité :*
Validation du système du point de vue d'un client externe en condition réelle (boîte noire). C'est le remplacement complet des anciens tests `MockMvc`. L'objectif est de s'affranchir du contexte Java (JVM) pour valider les contrats HTTP et les scénarios métiers de bout en bout.

Nous divisons ces tests en deux catégories distinctes, s'exécutant sur des environnements isolés via Bruno.

=== Les Smoke Tests (Tests de Surface)
*Objectif :* Vérifier instantanément la disponibilité des endpoints et la conformité des contrats de données sans altérer l'état de la base de données.
*Périmètre :* Essentiellement des requêtes `GET` classées par domaines (ex: `01-Identity-Security`, `02-Agronomy`).
*Environnement cible :* `admin, farmer etc.` (à discuter).

=== Les Tests d'Intégration End-to-End (E2E)
*Objectif :* Valider des cycles de vie complets (ex: Création d'une coopérative -> Ajout d'un utilisateur -> Login).
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

L'application de ces standards d'architecture de test permet de résoudre les anomalies de performance identifiées lors de l'analyse. La limitation stricte des redémarrages de contexte (via `AbstractIntegrationTest`) couplée à la délégation totale des flux HTTP à Bruno garantissent un pipeline CI plus optimal et plus efficace pour l'ensemble de l'équipe.