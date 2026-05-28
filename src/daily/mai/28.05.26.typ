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
    #text(size: 0.9em)[Date : 28 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Présentation "Agentic AI Farmstar" — 28 slides finalisés]
]

= Travaux réalisés

== Présentation Agentic AI Farmstar (28 slides)

Production d'une présentation complète montrant la transformation de Farmstar vers une IA autonome et opérationnelle.

*Structure et contenu* :

1. *Introduction* : Le constat (ChatBots passifs, mémoire fragmentée, exécution séquentielle). La rupture agentique : passage de l'interlocuteur passif à l'agent opérationnel.

2. *Connaissance (RAG)* : Context Engineering et stratégies d'optimisation (chunking sémantique, enrichissement par métadonnées, recherche hybride, re-ranking, skeletonization).

3. *Action (MCP)* : Orchestration via Model Context Protocol. Catalogue d'outils Farmstar (navigation, accès au code, recherche, skills). Concept Tool Calling.

4. *Orchestration (LangGraph)* : Coordination multi-agents, gestion d'état global, le Supervisor comme cerveau central.

5. *Conclusion* : Les trois piliers (RAG + MCP + LangGraph) permettent à Gemma 4 de transformer "répondre" en "résoudre". Perspectives.

*Cas d'usage* : Assistant de code, analyse Jira, revue de code, génération de tests, rétro-engineering.

= Bilan et prochaines étapes

*Ce qu'on a fait* : Une présentation claire et structurée (28 slides) montrant comment transformer Farmstar en assistant IA autonome et opérationnel. Elle synthétise le travail technique et propose une vision cohérente de la rupture agentique.

*À venir* :
- Éventuels ajustements suite à feedback
- Présentation auprès de l'équipe Magellium


#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]
