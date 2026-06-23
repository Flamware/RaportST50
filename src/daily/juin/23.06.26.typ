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
    #text(size: 0.9em)[Date : 23 juin 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Dockerisation du PoC]
]

= Travaux réalisés

== Création de Dockerfiles pour Ingestion, MCP, LangGraph et chainlit
- Création de Dockerfiles pour chaque composant du PoC afin de faciliter le déploiement et l'exécution dans des environnements isolés.
== Création de Docker Compose pour orchestrer les conteneurs
- Mise en place d'un fichier Docker Compose pour orchestrer les conteneurs et simplifier le processus de démarrage et d'arrêt des services.
== Tests et validation des conteneurs
- Tests de bon fonctionnement des conteneurs et validation de leur interopérabilité.
= Bilan et prochaines étapes

*Ce que j'ai fais* :
- Création de Dockerfiles pour Ingestion, MCP, LangGraph et chainlit
- Création de Docker Compose pour orchestrer les conteneurs
- Tests et validation des conteneurs

*À venir* :
- Rédaction de l'organigramme de l'entreprise et de la section sur les équipes techniques
- Finalisation du rapport de stage avec les sections sur l'analyse du besoin, les choix d'architecture technique, les phases d'implémentation, les résultats obtenus et le bilan technique et personnel de cette expérience.
- Poursuite du développement du module d'ingestion générique avec l'ajout de nouveaux formats de fichiers et l'amélioration de ses fonctionnalités en vue du workshop technique.
- Refacto legère : load des tools en async afin de résoudre les conflits liés au MCP.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]
