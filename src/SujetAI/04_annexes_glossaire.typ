#import "style.typ": *

= Glossaire Technique

#table(
  columns: (1fr, 3fr),
  inset: 10pt,
  fill: (col, row) => if row == 0 { primary-color } else if calc.odd(row) { secondary-color } else { white },
  align: (left, left),
  stroke: 0.5pt + white,
  [*Terme*], [*Définition*],
  [*LLM*], [Large Language Model. Modèle de langage de grande taille (ex: Gemma 4) capable de comprendre et générer du texte ou du code.],
  [*RAG*], [Retrieval-Augmented Generation. Architecture qui permet à l'IA de consulter une base de connaissances externe avant de répondre.],
  [*Token*], [Unité de base traitée par l'IA. 1000 tokens correspondent environ à 750 mots. C'est la mesure de la "mémoire" immédiate du modèle.],
  [*Embedding*], [Représentation mathématique d'un texte sous forme de vecteur. Deux textes ayant un sens proche auront des vecteurs proches.],
  [*VRAM*], [Mémoire vidéo du GPU. Elle détermine la taille du modèle et la longueur du contexte que l'on peut charger localement.],
  [*Inférence*], [Processus de génération d'une réponse par le modèle à partir d'une requête donnée.],
  [*Chunking*], [Action de découper un document volumineux en segments plus petits pour faciliter leur indexation et leur recherche.],
  [*On-Premise*], [Installation logicielle sur les serveurs physiques de l'entreprise, garantissant une souveraineté totale des données.],
  [*BM25*], [Algorithme de recherche textuelle basé sur la fréquence des mots, utilisé pour la recherche de termes techniques précis.],
  [*Cross-Encoder*], [Modèle spécialisé dans le calcul de similarité entre deux textes. Utilisé en Re-ranking pour scorer la pertinence.],
  [*Tree-Sitter*], [Parser générique permettant d'analyser le code source et de construire un arbre syntaxique abstrait (AST).],
  [*Model Context Protocol (MCP)*], [Standard open-source (initié fin 2024) permettant de standardiser la communication entre les LLMs et des sources de données ou outils externes, remplaçant les intégrations API codées en dur.],
  [*Tool Calling*], [Mécanisme par lequel l'IA génère une commande structurée pour solliciter un outil externe via MCP, au lieu de générer du texte libre.],
   [*Agent Orchestrateur*], [IA capable de coordonner plusieurs outils et sources de données en temps réel pour accomplir une tâche complexe, dépassant la simple génération de texte.],
   [*Semantic Routing (Routage Sémantique)*], [Processus par lequel le système comprend l'intention de la requête de l'utilisateur et décide de la stratégie de recherche ou d'action à adopter (ex: RAG documentaire vs RAG code).],
   [*Sandbox (Bac à Sable)*], [Environnement d'exécution sécurisé dans lequel l'IA peut tester du code ou exécuter des commandes sans risque pour le système hôte. Utilisé pour valider les générateurs de code avant de les intégrer au projet.]
)

#v(2em)

#info-box(title: "🔄 Mise à jour continue du glossaire", color: info-color)[
  Ce glossaire est évolutif. À mesure que de nouvelles briques technologiques (comme les agents autonomes, MCP) seront intégrées au projet Farmstar, les définitions seront complétées pour assurer un niveau de compréhension optimal au sein de l'équipe.
]

#v(2em)

#callout(title: "Pour approfondir", color: primary-color)[
  Consultez la documentation officielle de Gemma : https://ai.google.dev/gemma \
  Plus d'infos sur Qdrant : https://qdrant.tech \
  Explorer le Model Context Protocol : https://modelcontextprotocol.io
]