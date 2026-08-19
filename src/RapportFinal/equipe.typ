#text(fill: rgb("4a90e2"))[= Analyse du Fonctionnement et du Management de l'équipe]

== Structure de l'équipe
Le département CNAPPS (Cloud, Network, Architecture, Performance, Security & Software) de Magellium est organisé en plusieurs pôles d'expertise, chacun dédié à un domaine technologique spécifique. Ces pôles sont structurés de manière à favoriser la collaboration interdisciplinaire tout en permettant une spécialisation approfondie dans les domaines clés de l'entreprise. Parmi ces pôles, on trouve notamment l'expertise en ingénierie logicielle, le pôle infrastructure et Cloud, ainsi que les unités dédiées à l'intelligence artificielle.

== Organisation de l'équipe
L'équipe au sein de laquelle j'ai évolué est structurée de manière à favoriser la collaboration et l'efficacité opérationnelle. Elle est composée de plusieurs membres aux compétences complémentaires, répartis selon les rôles suivants :

- *Chef de projet* : Responsable de la coordination globale, de la planification des tâches et de la communication avec les parties prenantes. Il joue un rôle clé dans la gestion des ressources et la prise de décision stratégique.
- *Développeurs* : Chargés de la conception, du développement et de la maintenance des solutions logicielles. Ils travaillent en étroite collaboration pour assurer la cohérence et la qualité du code produit.

Afin de coordonner les efforts et de garantir une progression fluide, des réunions quotidiennes (Daily Scrum) sont organisées. Ces échanges permettent de synchroniser l'avancement des tâches, d'identifier les obstacles et de réaligner les objectifs. Par ailleurs, des outils de gestion de projet comme Jira sont utilisés pour le suivi des tickets, l'assignation des responsabilités et la transparence de l'information.

La gestion du versionnage est assurée par Git, structuré autour de branches dédiées par fonctionnalité. Cette approche permet de maintenir un historique clair et de faciliter les revues de code, lesquelles sont systématiques pour garantir la qualité et favoriser le partage des connaissances.

== Place occupée dans le service

=== Responsabilités et positionnement

En tant qu'étudiant ingénieur en dernière année, ma mission au sein du projet Farmstar s'est articulée autour de deux axes majeurs : l'optimisation des performances de l'infrastructure existante et la conception R&D d'un système d'intelligence artificielle autonome.

Ce double positionnement m'a conféré des responsabilités techniques importantes. Je rendais compte de mes avancées à mon tuteur technique (Mathieu NIORD), avec qui je validais les choix architecturaux critiques. Mon rôle consistait non seulement à implémenter des solutions, mais également à auditer le code existant, identifier les goulots d'étranglement (tels que les temps de build CI) et proposer des refontes en vue d'améliorer les performances. Les propositions que je développais devaient ainsi être validées pour leur faisabilité, leur sécurité et leur adéquation avec les standards de Magellium.

=== Rôle et périmètre d'intervention

Mon périmètre d'action s'est étendu sur l'ensemble du cycle de vie logiciel, allant du backend jusqu'à l'orchestration de modèles de langage :

- *DevOps et Qualité logicielle* : J'ai mené des audits de performance sur les pipelines d'intégration continue (CI/CD) sous GitLab, intégrant des hooks de pré-commit et pré-push (SonarLint, Checkstyle, Spotless) pour garantir la robustesse du code.
- *Ingénierie Backend et Tests* : J'ai travaillé sur la refactorisation de composants en Java (via de la réflexion) et contribué à la migration d'une partie des tests d'API vers Bruno (base d'intégration déjà existante) ainsi qu'à des tests E2E frontend avec Playwright.
- *R&D en IA Agentique* : J'ai conçu de bout en bout une infrastructure locale d'agents orchestrés (LangGraph, Model Context Protocol), depuis l'expérimentation initiale jusqu'au prototype fonctionnel (détails en section Travail Réalisé).

=== Autonomie et force de proposition technique

L'une des caractéristiques principales de ce stage a été la grande autonomie qui m'a été accordée dans mes recherches. Cette liberté s'est traduite par des prises de décision impactantes :

- *Benchmark et migration d'outils* : Face aux lenteurs des tests End-to-End côté frontend, j'ai initié des benchmarks de divers framework de tests frontend. Ce choix a permis de diviser le temps d'exécution par trois (de 5m28s à 1m45s) et d'améliorer la stabilité de la suite de tests.
- *Choix architecturaux en IA* : Lors du développement de l'assistant IA, j'ai identifié les limites d'isolation des agents sous Open WebUI. J'ai alors proposé et implémenté une migration vers LangGraph, introduisant un superviseur centralisé et un routage dynamique orienté objet (POO) pour permettre une communication fluide entre agents.
- *Optimisation des ressources* : Mes initiatives sur le profilage du cache Spring Boot ont permis de réduire le temps de build local de 17 minutes à seulement 3 minutes, améliorant ainsi considérablement la vélocité des pipelines de l'équipe.

=== Standardisation et transmission des connaissances

Ne me limitant pas à l'écriture de code, j'ai pris le rôle de facilitateur technique. J'ai rédigé des guides de bonnes pratiques (au format Typst et Markdown) et enrichi le wiki du projet sur les standards d'implémentation des tests et l'utilisation des outils d'analyse statique.

La restitution a été une composante essentielle de ma mission. J'ai conçu et animé plusieurs présentations techniques formelles (notamment 28 slides sur la transformation de l'IA vers l'agentique et une restitution sur l'optimisation de la CI et de la rédaction de tests), permettant d'évangéliser ces nouvelles pratiques architecturales auprès de l'équipe.

=== Dynamique collaborative et rituels agiles

La réussite de ces chantiers repose sur une communication transparente :
- Des points de synchronisation réguliers pour remonter les blocages techniques et valider les Proof of Concept (PoC).
- Une démarche d'intégration continue stricte via GitLab, où chaque évolution faisait l'objet de revues de code.
- Une approche itérative orientée "Fast-Fail", permettant d'ajuster rapidement l'architecture logicielle en fonction des contraintes de sécurité et des retours terrains.