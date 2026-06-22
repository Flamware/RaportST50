#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(weight: "bold", size: 1.2em)[UTBM] \
    #text(size: 0.9em)[Stage de Fin d'études (ST50)]
  ],
  align(right)[
    #text(weight: "bold", size: 1.1em)[Magellium] \
    #text(size: 0.9em)[Projet : Farmstar Core Service] \
    #text(size: 0.9em)[Date : 22 juin 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Rapport ST50 et Generic Ingestion]
]

= Travaux réalisés

== Création du rapport de stage
- Début du rapport de stage : structuration, rédaction de l'introduction et du remerciement.
- Rédaction de la section "Présentation de l'entreprise Magellium" : description de l'entreprise, de son positionnement stratégique et de l'agence de Ramonville-Saint-Agne.
== Generic Ingestion
- Conception et développement d'un service d'ingestion générique en vue d'un workshop technique présentant le fonctionnement du PoC Farmstar Agentic AI.
- Actuellement 3 types de fichiers supportés : .java, .py et .txt.
- Le service est conçu pour être facilement extensible à d'autres formats de fichiers à l'avenir.
= Bilan et prochaines étapes

*Ce que j'ai fais* :
- Rédaction de la première partie du rapport de stage
- Conception et développement du service d'ingestion générique pour le workshop technique

*À venir* :
- Rédaction de l'organigramme de l'entreprise et de la section sur les équipes techniques
- Finalisation du rapport de stage avec les sections sur l'analyse du besoin, les choix d'architecture technique, les phases d'implémentation, les résultats obtenus et le bilan technique et personnel de cette expérience.
- Poursuite du développement du service d'ingestion générique avec l'ajout de nouveaux formats de fichiers et l'amélioration de ses fonctionnalités en vue du workshop technique.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]
