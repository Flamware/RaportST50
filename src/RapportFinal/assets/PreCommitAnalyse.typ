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
