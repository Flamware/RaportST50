#text(fill: rgb("4a90e2"))[= Conclusion]

== Synthèse globale
Ce projet de fin d'études au sein de l'agence Magellium s'inscrit dans une démarche globale d'optimisation de l'ingénierie logicielle. Qu'il s'agisse de résoudre les problématiques de performance de la CI/CD ou de concevoir l'architecture IA de demain, l'approche retenue a toujours privilégié la rigueur architecturale, la qualité de code et l'autonomie des développeurs. Sur le plan financier, l'optimisation de la CI/CD représente un gain estimé entre 610 € et 915 € par an pour l'équipe (voir section Estimation des gains), un chiffre volontairement conservateur et mesuré plutôt qu'extrapolé.

== Analyse réflexive des compétences développées
Ce stage a mobilisé et développé des compétences sur trois plans distincts.

Sur le plan *technique*, j'ai appris à concevoir des architectures robustes dans deux contextes très différents : un backend legacy contraint (Java/Spring), où la difficulté est de refactorer sans casser l'existant, et un système multi-agents non déterministe, où la difficulté est d'imposer des garanties structurelles (typage, schémas, tests) sur un composant dont le comportement varie d'une exécution à l'autre. J'ai également appris à choisir l'outil pertinent plutôt que l'outil par défaut (Bruno plutôt que MockMvc pour les contrats d'API, Playwright plutôt que Cypress pour l'E2E, Instructor plutôt que Pydantic seul pour les sorties LLM), en justifiant chaque choix par un audit ou un benchmark plutôt que par habitude.

Sur le plan *méthodologique*, j'ai renforcé une discipline d'audit avant action : profiler avant d'optimiser, mesurer avant de conclure. Cette rigueur, appliquée d'abord à la CI/CD, m'a servi de référence lorsqu'il a fallu l'appliquer à un domaine bien moins mature : évaluer un système à base de LLM impose d'accepter l'incertitude (voir la section Limites identifiées) plutôt que de la masquer, et de refuser d'extrapoler un gain au-delà de ce qui est réellement mesurable (voir la section Estimation des gains).

Sur le plan de la *posture professionnelle*, l'axe R&D en IA agentique n'était pas le sujet initial du stage : je l'ai proposé, argumenté et fait valider en interne après avoir stabilisé l'axe CI/CD. Cette capacité à identifier une opportunité, à la défendre avec des résultats concrets, puis à la mener en autonomie jusqu'à un prototype fonctionnel, constitue à mes yeux l'apport le plus structurant de ce stage pour la suite de ma carrière — d'autant qu'elle a directement contribué à l'obtention de mon premier CDI dans le domaine de l'intelligence artificielle.

== Perspectives
Plusieurs axes d'évolution peuvent prolonger ces travaux :
1. *Industrialisation du PoC IA :* Connecter l'orchestrateur LangGraph directement aux pipelines GitLab de Magellium pour automatiser les revues de code et l'audit de sécurité sur chaque Merge Request
.
2. *Extension des Serveurs MCP :* Ajouter des intégrations directes vers les APIs Jira et SonarQube pour permettre à l'agent de résoudre des tickets de bout en bout.
3. *Généralisation du pattern Hydrateur :* Étendre le `GenericHydrator` aux autres microservices du projet Farmstar.