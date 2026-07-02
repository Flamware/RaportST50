#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

#grid(
columns: (1fr, 1fr),
align(left)[
#text(weight: "bold", size: 1.2em)[UTBM]

#text(size: 0.9em)[Stage de Fin d'études (ST50)]
],
align(right)[
#text(weight: "bold", size: 1.1em)[Magellium]

#text(size: 0.9em)[Projet : Farmstar Core Service]

#text(size: 0.9em)[Date : 02 juillet 2026]
]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
#text(weight: "bold", size: 1.5em)[Fiche d'Activité : UI Ingestion]
]

= Synthèse des travaux

== Étude et implémentation de la bibliothèque Instructor
L'objectif est d'améliorer la fiabilité et la structure des données générées par l'IA.

Réalisations techniques :

Structuration des sorties : Mise en place de trois modèles fonctionnels (FinalOutput, ToolOutput, AnswerOutput).

Observabilité : Intégration de callbacks pour le suivi des exécutions via l'interface LangSmith.

Analyse du Tool Calling : Phase d'exploration en cours (implémentation actuelle en phase de débogage).

Valeur ajoutée par rapport à Pydantic seul :

Gestion dynamique des Unions : Permet à l'IA de choisir une structure spécifique (ex: FinalOutput vs ToolOutput), évitant ainsi le remplissage de champs superflus et optimisant la consommation de tokens.

Mécanisme de Retry intégré : Automatisation de la correction des erreurs de formatage ou des champs manquants via des appels récursifs, là où Pydantic nécessite une logique de gestion d'erreurs manuelle.

= Planning et perspectives

== Travaux à court terme

Correction : Résoudre les blocages rencontrés sur le tool calling avec Instructor.

Benchmark : Évaluer l'impact sur les performances (latence et précision) de l'utilisation de Instructor par rapport à une implémentation Pydantic native.

Documentation technique :

Détailler l'implémentation des solutions liées à l'Axe 1.

Rédiger le contexte et les objectifs de l'Axe 2.

== Rédaction du rapport de stage

Finalisation de l'organigramme et de la présentation des équipes techniques Magellium.

Rédaction exhaustive du rapport : analyse du besoin, choix d'architecture, phases d'implémentation, résultats obtenus et bilan de l'expérience.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]