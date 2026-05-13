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
    #text(size: 0.9em)[Date : 13 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Refactorisation orientée objet]
]

= Travaux réalisés

== Restructuration profonde du framework d'Agents
Passage d'une orchestration fonctionnelle à une architecture **orientée objet (POO)** pour accroître la robustesse et la maintenabilité du projet :

- *Classe Abstraite `Agent` (ABC)* : Mise en place d'une classe mère gérant de manière générique le cycle de vie des agents (initialisation, chargement des prompts, gestion des outils).
- *Découverte Dynamique de Ressources* : Implémentation de la logique `inspect.getfile(self.__class__)` permettant à chaque agent de localiser automatiquement ses fichiers de configuration (`prompts/` et `skills/`) selon sa position dans l'arborescence.
- *Système de Mise en Cache* : Optimisation du chargement des prompts via un `_prompt_cache` pour réduire les accès disque lors des appels récurrents du graphe.

== Typage fort et Registry Centralisé
Sécurisation des échanges entre le Superviseur et les sous-graphes :

- *Énumérations de routage (`SubGraphType`, `SubAgentType`)* : Remplacement des chaînes de caractères brutes par des Enums pour garantir l'intégrité du routage et faciliter la détection d'erreurs au build.
- *Tool Registry Type-safe* : Centralisation du catalogue d'outils MCP (Search, Read, Class Usage, etc.) et mapping explicite des capacités autorisées (`ALLOWED_TOOLS`) par agent.

== Optimisation de la Supervision (Main Graph)

- *Routage par Contrat* : Mise à jour du `SupervisorAgent` pour utiliser des sorties structurées (Pydantic) indexées sur les Enums.
- *Externalisation des Prompts* : Migration des instructions du superviseur vers des fichiers Markdown (`PROMPT_SUPERVISOR.md`).

= Analyse et plan d'action

*Bilan* : L'architecture est posée et respecte des exigences de qualité logicielle (Clean Code). La séparation claire entre la structure (classes), les contrats (enums) et les ressources (markdown) permet d'envisager l'ajout de nouveaux agents sans complexité linéaire.

*Prochaine étape* : Implementer la detection de code/gaps dans le `Superviseur` pour activer le routage conditionnel. Tester avec des requêtes variées pour valider les différents flux d'exécution. Finaliser le sous-graphe `DOC_GENERATOR` en suivant ce nouveau standard.


#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]