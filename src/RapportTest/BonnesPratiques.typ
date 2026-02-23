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
  *Auteur :* Étudiant Ingénieur 5A \
  *Date :* #datetime.today().display("[day] [month repr:long] [year]")
]
#pagebreak()

// --- Contenu ---

= Introduction

L'architecture distribuée (microservices) impose une rigueur accrue sur la stratégie de validation logicielle. La défaillance d'un service pouvant impacter la chaîne globale, ce document définit les standards de tests à appliquer au sein du projet Magellium. L'objectif est de réduire la boucle de feedback (Feedback Loop) et de garantir la non-régression.

= La Pyramide des Tests

Nous adoptons le modèle de la pyramide des tests pour optimiser le rapport coût/bénéfice.

== Répartition Cible

- *Unitaires (70%) :* Socle de la stabilité. Exécution instantanée.
- *Intégration (20%) :* Validation des interfaces et configurations.
- *E2E / API (10%) :* Validation des flux critiques (Happy Path).

= Implémentation Technique

== Tests Unitaires (Unit Tests)
*Périmètre :* Classes de service, utilitaires, règles métier.
*Contrainte :* Isolation totale (pas de contexte Spring).

L'erreur fréquente est d'utiliser `@SpringBootTest` pour des tests unitaires, ce qui ralentit considérablement l'exécution (plusieurs secondes au lieu de millisecondes).
#sourcecode[```typ
// MAUVAISE PRATIQUE : SpringBootTest (Lent)
@SpringBootTest // Charge tout le contexte application (Lourd !)
class CommandeServiceTest {

    @Autowired // Injection de dépendance réelle
    private CommandeService service;

    @MockBean // Mock géré par le contexte Spring (plus lent que Mockito pur)
    private Repository repo;

    @Test
    void calculTva_nominal() {
        // Le code du test est identique, mais l'exécution est 100x plus lente
        when(repo.getTaux()).thenReturn(20.0);
        // ... assertions
    }
}

// BONNE PRATIQUE : MockitoExtension (Rapide)
@ExtendWith(MockitoExtension.class)
class CommandeServiceTest {
    @Mock private Repository repo;
    @InjectMocks private Service service;

    @Test
    void calculTva_nominal() {
        when(repo.getTaux()).thenReturn(20.0);
        // ... assertions
    }
}
```]
== Tests d'Intégration (Integration Tests)
Périmètre : Couche de persistance (Repository), Contrôleurs REST.
Outils : Spring Boot Test, H2 (ou TestContainers).

Pour éviter de charger l'intégralité de l'application, nous privilégions le "Slice Testing".

== Tests de Bout en Bout (E2E / API)
Périmètre : Scénarios complets traversant plusieurs couches.
Outils : Bruno (Collections & Scripting).

Contrairement aux idées reçues, Bruno permet l'automatisation via sa CLI (bru run). Il ne doit pas être limité aux tests manuels.

Action requise : Versionner les collections Bruno (.bru) dans le dépôt Git du projet pour qu'elles soient exécutables par tous les développeurs.

= Performance et "Context Caching"

La lenteur des tests en environnement Spring provient souvent du rechargement du contexte (ApplicationContext).

Problème : L'utilisation abusive de MockBean ou DirtiesContext invalide le cache de Spring, forçant un redémarrage du serveur entre les tests.
Recommandation : Regrouper les configurations de tests dans une classe abstraite commune (ex: AbstractIntegrationTest) pour garantir la réutilisation du contexte.

= Conclusion

L'application de ces standards permettra de :

Sécuriser les refontes de code (Refactoring).

Documenter le comportement du code via les tests ("Documentation vivante").

Réduire le temps d'exécution de la CI/CD en limitant les tests lourds.
