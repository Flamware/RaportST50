#import "style.typ": *

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
  header: align(right, text(gray, size: 9pt)[Étude technique : IA locale et Context Engineering]),
  footer: context [
    #set text(8pt, fill: gray)
    #line(length: 100%, stroke: 0.5pt + gray)
    #grid(
      columns: (1fr, 1fr),
      [Projet Farmstar - ANTUNES Axel],
      align(right, counter(page).display("1 / 1", both: true))
    )
  ]
)

// --- Configuration de la Table des Matières ---
#show outline.entry.where(
  level: 1
): it => {
  v(12pt, weak: true)
  strong(it)
}

#set outline(indent: 2em)

#set text(font: "Linux Libertine", size: 10pt, lang: "fr")
#set heading(numbering: "1.1.")
#show heading: set block(above: 1.5em, below: 1em)
#show heading.where(level: 1): set text(fill: primary-color, weight: "bold", size: 16pt)
#show heading.where(level: 2): set text(fill: dark-color, weight: "bold", size: 13pt)
#show heading.where(level: 3): set text(fill: dark-color, size: 11pt)

// --- En-tête du document ---
#align(center)[
  #block(
    fill: secondary-color,
    inset: 20pt,
    radius: 8pt,
    stroke: 1.5pt + primary-color,
    [
      #text(size: 24pt, weight: "bold", fill: primary-color)[Analyse Stratégique de l'Usage d'IA Locale]
      #v(0.3em)
      #text(size: 18pt, weight: "bold", fill: dark-color)[(Gemma 4)]
      #v(0.8em)
      #line(length: 60%, stroke: 1pt + accent-color)
      #v(0.8em)
      #text(size: 12pt, style: "italic", fill: gray.darken(30%))[Optimisation de la fenêtre de contexte pour les projets de grande envergure]
      #v(0.5em)
      #text(size: 9pt, fill: gray)[Projet Farmstar • 2026]
    ]
  )
]

#v(3em)

// --- Table des matières ---
#outline(
  title: [Table des matières],
  depth: 3,
)

#pagebreak()

// --- INCLUSION DES SOUS-FICHIERS ---
#include "01_concepts_usages.typ"
#pagebreak()
#include "02_architecture_data.typ"
#pagebreak()
#include "03_implementation.typ"
#pagebreak()
#include "04_annexes_glossaire.typ"