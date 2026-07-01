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
    #text(size: 0.9em)[Date : 01 juillet 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : UI Ingestion]
]

= Travaux réalisés

== Ajout logging ingestion
- Ajout d'un système de logging pour l'ingestion afin de faciliter le suivi des opérations et le débogage en cas de problème. Le logging permet de capturer quels fichiers ont étés ingérés.

== Fix environnement requirements.txt Python
- Correction des problèmes liés à l'environnement Python et au fichier requirements.txt pour assurer le build et le run des images docker de streamlit (Admin) et de l'API d'ingestion.

== Ajout de sections dans le rapport de stage
- Rédaction du contexte du premier Axe du stage.
- Ajout section :
    - Travail Réalisé :
        - Axel 1 Optimisation
            - Contexte technique, investigation et définition des objectifs
            - Implémentation des solutions
        - Axel 2 R&D Agentique
            - Contexte technique, investigation et définition des objectifs
            - Implémentation des solutions
    - Synthèse
    - Conclusion et perspectives
    - Annexe
Toutes les sections sont en cours de rédaction et seront finalisées dans les prochains jours.

*Ce que j'ai fais* :
- Ajout d'un système de logging pour l'ingestion afin de faciliter le suivi des opérations et le débogage en cas de problème.
- Correction des problèmes liés à l'environnement Python et au fichier requirements.txt pour assurer le build et le run des images docker de streamlit (Admin) et de l'API d'ingestion.
- Rédaction du contexte du premier Axe du stage et ajout des sections dans le rapport de stage.
*À venir* :
- Rédaction de l'organigramme de l'entreprise et de la section sur les équipes techniques
- Finalisation du rapport de stage avec les sections sur l'analyse du besoin, les choix d'architecture technique, les phases d'implémentation, les résultats obtenus et le bilan technique et personnel de cette expérience.
- Detailler l'implémentation des solutions de l'Axe 1.
- Rédaction contexte et objectifs de l'Axe 2.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]
