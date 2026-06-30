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
    #text(size: 0.9em)[Date : 30 juin 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Dockerisation du PoC]
]

= Travaux réalisés

== Création app streamlit pour conf le PoC
- Création d'une application Streamlit pour configurer le PoC et faciliter l'interaction avec les différents composants. Il est possible de definir le path du projet à ingerer et le nom de la collection.

== Ajout de LangFuse
- Intégration de LangFuse pour le suivi des performances et la traçabilité des interactions avec les modèles d'IA. A terme, Langfuse permettre de ne plus passer via Langsmith Studio. (Indépendance)

= Bilan et prochaines étapes

*Ce que j'ai fais* :
- Développement d'une application Streamlit pour la configuration du PoC, permettant de définir le chemin du projet à ingérer et le nom de la collection.
- Intégration de LangFuse pour le suivi des performances et la traçabilité des interactions avec les modèles d'IA, visant à réduire la dépendance à Langsmith Studio.
*À venir* :
- Solver soucis des venv python pour les differentes parties du PoC (MCP, Graph, Ingestion et Admin).
- Amélioration de l'interface Streamlit pour une meilleure expérience utilisateur et ajout de fonctionnalités supplémentaires pour la configuration du PoC.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]
