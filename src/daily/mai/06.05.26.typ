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
    #text(size: 0.9em)[Date : 6 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Orchestration multi-agents sous LangGraph]
]

== Travaux réalisés
Pour dépasser les limites d'Open WebUI (agents isolés), l'infrastructure a migré vers **LangGraph**. L'objectif est de permettre la communication entre les agents et le partage d'états globaux.

=== Orchestrateur Principal (Main Graph)
- **Point d'entrée global** : Création d'un graphe principal (`build_main_graph`).
- **Parser Agent** : Premier nœud du graphe. Il analyse la requête brute de l'utilisateur et la convertit en une tâche structurée (via Pydantic).
- **Routage dynamique** : Mise en place d'un `main_router` conditionnel pour diriger la requête vers le sous-graphe compétent (ex: `TEST_COVERAGE_AGENT` ou `DOC_GENERATOR_AGENT`).

=== Sous-Graphe "Test Coverage"
Création d'un pipeline séquentiel (`TestCoverageState`) divisé en trois étapes :
- **Gatherer** : Cherche le code source et les tests existants via les outils MCP.
- **Analyzer** : Évalue la couverture et rédige un plan de test.
- **Solver** : Génère le code des tests manquants (JUnit/Mockito).
- **Boucle d'outils** : Utilisation de `tools_condition` et `ToolNode` pour forcer le LLM à attendre le résultat d'un outil de recherche avant de poursuivre.

=== Sécurisation et Prompt Engineering
- **Anti-hallucination** : Ajout d'un "coupe-circuit" qui bloque les réponses inventées et force le LLM à utiliser ses outils de recherche.
- **Extraction Structurée** : Utilisation de `with_structured_output` pour garantir que les données extraites respectent un format strict (ex: `TestGathererOutput`).
- **Correction de parsing** : Échappement des accolades dans les prompts Markdown (Skills) pour éviter les conflits avec les f-strings Python.

== Analyse et plan d'action
- *Bilan* : La prise en main de LangGraph est complexe et requiert beaucoup d'ajustements pour fluidifier la communication inter-agents. Cependant, cette architecture est indispensable pour des tâches avancées (comme créer un workflow de résolution de ticket impliquant à la fois l'agent Jira et l'agent Farmstar).
- *Prochaine étape* : Rendre le routeur interne des sous-graphes autonome (modèle ReAct). Il doit pouvoir sauter des étapes inutiles selon le contexte (ex: ignorer le `Solver` si un test existe déjà, ou n'appeler que le `Gatherer` pour une simple recherche).

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]