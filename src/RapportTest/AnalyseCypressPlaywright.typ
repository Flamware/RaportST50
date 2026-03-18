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
  #text(1.5em, weight: "bold", fill: corporate-blue)[Analyse Framework de Tests] \
  #text(1.2em)[Module : `fs-front-manager` (Framework de Tests E2E & Smoke Tests)] \
  #v(1em)
  #text(size: 10pt, style: "italic")[Généré le #datetime.today().display()]
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

= Analyse des Outils d'Analyse Statique Java (Pre-commit)
L'intégration de "Pre-commit hooks" permet de garantir que tout code commité respecte les standards de qualité avant même l'entrée dans la pipeline CI/CD. Voici une comparaison des outils standards de l'écosystème Java.

#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr),
  fill: (col, row) => if row == 0 { corporate-blue.lighten(80%) } else { white },
  inset: 10pt,
  [*Outil*], [*Type d'analyse*], [*Adéquation Pre-commit*], [*Performance*], [*Complexité Config.*],
  [Checkstyle], [Style et conventions (indentation, nommage)], [Excellente (agit sur les sources, très léger)], [Très rapide], [Moyenne (Fichier XML standard)],
  [PMD], [Bonnes pratiques, Code mort, Complexité cyclomatique], [Très bonne (agit sur les sources)], [Rapide], [Moyenne (Règles intégrées)],
  [SpotBugs], [Détection de bugs (NullPointer, ressources non fermées)], [Moyenne (Nécessite la compilation des classes)], [Moins rapide (Analyse du bytecode)], [Élevée (Plugins Gradle/Maven)],
  [SonarLint], [Qualité globale et Sécurité (Hotspots)], [Faible (Conçu pour IDE ou mode connecté)], [Lente pour un hook], [Élevée (Nécessite contexte projet)]
)
