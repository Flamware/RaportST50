#set document(title: "Audit de Performance des Tests - fs-core", author: "Ingénieur 5A")
#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1/1")
#set text(font: "Linux Libertine", lang: "fr", size: 11pt)
#set heading(numbering: "1.")

// Couleurs
#let corporate-blue = rgb("#004C97") // Bleu type Airbus/Corp
#let alert-red = rgb("#D32F2F")
#let success-green = rgb("#388E3C")

// Styles des titres
#show heading: set text(fill: corporate-blue)
#show heading.where(level: 1): it => [
  #v(0.5em)
  #line(length: 100%, stroke: 1pt + corporate-blue)
  #text(1.2em, weight: "bold", it.body)
  #v(0.5em)
]

// Titre du document
#align(center)[
  #text(1.5em, weight: "bold", fill: corporate-blue)[Audit de Performance & Dette Technique] \
  #text(1.2em)[Module : `fs-core` (Architecture Monorepo)] \
  #v(1em)
  #text(size: 10pt, style: "italic")[Généré le #datetime.today().display()]
]

= Contexte et Objectifs

Dans le cadre de l'optimisation de la chaîne CI/CD du projet `agri-monorepo`, un audit de performance a été mené sur la suite de tests d'intégration du service critique `fs-core`.

L'objectif est d'identifier les goulots d'étranglement ralentissant le build (actuellement > 17 minutes en local) et de proposer des solutions d'architecture logicielle.

*Outil utilisé :* `spring-test-profiler` (v0.0.15) configuré avec un Initializer manuel pour supporter Spring Boot 3 / Jakarta EE.

= Analyse Quantitative (Métriques)

L'exécution de la suite de tests via Maven a révélé une lourdeur excessive du contexte applicatif.

== Temps de "Cold Start"
Le démarrage à froid du contexte Spring (chargement des Beans, Hibernate, Connexions BDD) représente le coût fixe majeur.

#align(center)[
  #rect(fill: luma(240), stroke: (left: 4pt + alert-red), inset: 10pt, width: 80%)[
    *Mesure critique :* 44.7 secondes
    \
    _Temps nécessaire pour exécuter un seul test (`NdoseControllerTest`) isolé._
  ]
]

== Fragmentation du Contexte (Context Thrashing)
Le rapport du profiler a mis en évidence que le contexte n'est pas réutilisé efficacement. Au lieu d'un contexte unique, *3 configurations distinctes* ont été détectées, forçant le framework à redémarrer l'application plusieurs fois.

#table(
  columns: (auto, auto, auto, 2fr),
  fill: (col, row) => if row == 0 { corporate-blue.lighten(80%) } else { white },
  inset: 10pt,
  [*ID Contexte*], [*Beans*], [*Statut*], [*Classes de Test Concernées*],
  [`context-1`], [1999], [Base], [Standard (7 classes dont `UserServiceIntegrationTest`)],
  [`context-0`], [2006], [Deviant A], [`ModulationRequestTest`],
  [`context-2`], [2006], [Deviant B], [`NdoseControllerTest`, `UserControllerTest`, etc.],
)

= Analyse des Causes Racines

L'analyse différentielle des configurations (`Context Customizers`) a permis d'isoler la cause exacte de la rupture de cache entre `context-1` (Base) et `context-0`.

*Cause identifiée :* `org.springframework.boot.test.context.ImportsContextCustomizer`

Le test `ModulationRequestTest` utilise l'annotation `@Import(...)` pour charger des beans spécifiques. Cette modification de configuration invalide le cache du `TestContextFramework` de Spring, obligeant la JVM à recharger les 1999 autres beans et à réinstancier la base de données.

*Impact chiffré :*
$ "Nombre de ruptures" times "Temps de démarrage" = "Temps perdu" $
$ 10 "misses" times 45 "secondes" approx 7.5 "minutes de temps machine gaspillé" $

= Plan d'Action et Recommandations

Pour réduire le temps de feedback développeur (Feedback Loop), les actions suivantes sont recommandées :

== Refactoring : Classe Mère "Golden Config" (Court Terme)
Fusionner les contextes fragmentés en créant une classe de base abstraite.
- Déplacer les `@Import` spécifiques de `ModulationRequestTest` vers une classe `AbstractIntegrationTest`.
- Faire hériter tous les tests `@SpringBootTest` de cette classe unique.
- *Gain espéré :* Réduction de 10 démarrages à 1 seul démarrage unique.

== Migration vers le "Slice Testing" (Moyen Terme)
Le rapport montre que 2006 beans sont chargés pour tester un contrôleur REST.
- Remplacer `@SpringBootTest` par `@WebMvcTest` pour les tests de contrôleurs (`NdoseControllerTest`).
- *Gain espéré :* Chargement de ~100 beans au lieu de 2006. Démarrage en < 5s.

== Externalisation vers Bruno (Cible)
Pour les tests de bout en bout (E2E) impliquant la sécurité et les requêtes HTTP réelles, migrer vers des collections *Bruno*.
- *Avantage :* Exécution instantanée contre un environnement local lancé, sans coût de compilation/démarrage JVM à chaque run.

= Conclusion

L'audit technique confirme que la lenteur du module `fs-core` n'est pas due à la complexité métier, mais à une *dette de configuration des tests*. La correction de l'héritage des tests (Action 4.1) permettra de diviser par deux le temps d'exécution de la CI sur ce module.