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

= Contexte et Objectifs
Dans le cadre de l'amélioration de la couverture des tests du project Farmstar, il a été décidé d'adopter un framework de tests E2E afin de compléter les tests d'intégration existants.
Ce document présente une analyse comparative entre plusieurs frameworks populaires (Cypress, Playwright, Selenium) pour déterminer la solution la plus adaptée aux besoins du projet.

= Analyse Comparative des Frameworks de Tests E2E
Les critères d'évaluation retenus sont les suivants :
- *Facilité d'Intégration* : Capacité à s'intégrer dans la pipeline CI/CD existante.
- *Performance* : Temps d'exécution des tests et consommation de ressources.
- *Facilité d'Écriture des Tests* : Simplicité de la syntaxe et des outils de développement.
- *Support et Communauté* : Disponibilité de ressources, documentation et support communautaire.

#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  fill: (col, row) => if row == 0 { corporate-blue.lighten(80%) } else { white },
  inset: 10pt,
  [*Framework*], [*Facilité d'Intégration*], [*Performance*], [*Facilité d'Écriture*], [*Support et Communauté*],
    [Cypress], [Excellente (Plugins CI/CD disponibles)], [Moyenne (exécution parallèle locale possible mais non recommendée)], [Très simple (interface User Friendly, outils de développement intégrés)], [Large et active (nombreux plugins et ressources)],
    [Playwright], [Bonne (Support CI/CD en développement)], [Rapide (exécution parallèle)], [Simple (outils de développement intégrés)], [En croissance rapide (soutenu par Microsoft)],
    [Selenium], [Moyenne (Intégration possible mais plus complexe)], [Moins rapide (exécution plus lente, moins d'optimisations modernes)], [Verbeux (API explicite mais lourde)], [Immense (Standard de l'industrie, mais en déclin)]
)

 #table(
   columns: (2fr, 1.5fr, 1.5fr, 1.5fr),
   align: (left, center, center, center),
   [*Métrique / Critère*], [*Cypress (Existant)*], [*Playwright (Cible)*], [*Gain / Impact*],
   [Temps d'exécution global], [5 min 28 s], [1 min 45 s], [Temps divisé par 3],
   [Consommation CPU (User time)], [1 min 38 s], [8.5 s], [Réduction de 91%],
   [Taux de succès de la suite], [88,8 % (flaky tests)], [100 %], [Stabilité maximale],
   [Architecture d'exécution], [Proxy réseau lourd], [Protocole DevTools natif], [Faible empreinte CI]
 )
