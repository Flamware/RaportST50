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
    #text(size: 0.9em)[Date : 24 Avril 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Infrastructure IA locale et connectivité MCP]
]

== Travaux réalisés
Mise en place de l'interface de discussion et développement des premières briques d'interopérabilité pour l'assistant Farmstar.

=== Setup de l'environnement et création du serveur MCP
- Installation et configuration d'Open WebUI pour servir d'interface aux modèles locaux.
- Développement d'un serveur FastMCP complet intégrant des outils de recherche (Search), d'analyse de fichiers et un moteur de RAG.
- Rédaction de "Skills" (fichiers de contexte structurés) pour guider l'IA sur l'architecture, la documentation et les dépendances du projet.

=== Création des agents spécialisés
- Configuration de trois agents distincts : Farmstar MCP (code), Jira MCP (gestion de tickets) et un Ticket Solver global.
- Test des outils d'analyse de code sur le monorepo Airbus pour valider la récupération de contexte.

== Analyse et plan d'action
- *Bilan* : Les outils et les compétences (skills) fonctionnent bien séparément. Cependant, j'ai identifié une limitation majeure : dans Open WebUI, les agents sont isolés et ne peuvent pas s'échanger d'informations. Une tâche complexe comme la résolution de ticket nécessite de faire communiquer l'agent Jira et l'agent Farmstar, ce qui est impossible en l'état.
- *Prochaine étape* : Étudier l'utilisation de LangGraph pour créer un orchestrateur capable de faire le pont entre les différents serveurs MCP et gérer des workflows multi-agents.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]