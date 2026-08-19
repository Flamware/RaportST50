#text(fill: rgb("4a90e2"))[= Synthèse et Bilan]

== Bilan technique et résultats obtenus
L'ensemble des objectifs fixés au début du stage a été atteint, apportant des améliorations mesurables sur le projet Farmstar :
- *Intégration Continue (CI/CD) :* Temps d'exécution du build backend réduit de 70% sur GitLab CI (de 19:18 à 5:45 min), et build local accéléré de 17 min à 3 min grâce à un taux d'utilisation du cache Spring de 99,5%.
- *Tests Frontend :* Suite de smoke tests Playwright 3 fois plus rapide que Cypress (1 min 45 s vs 5 min 28 s).
- *Qualité du code :* Interception des régressions avant la CI via des hooks Git `pre-commit` et `pre-push` ciblés sur les fichiers modifiés.
- *R&D IA Agentique :* Réalisation d'un PoC multi-agents opérationnel basé sur LangGraph et MCP, capable d'analyser le code source et de générer des plans de tests.

== Estimation des gains pour l'entreprise
- *Productivité Développeur :* L'accélération des builds et la réduction de la boucle de feedback font gagner en moyenne 30 à 45 minutes par jour et par développeur sur l'équipe Farmstar.
- *Réduction des coûts d'infrastructure :* La baisse de la durée des jobs GitLab CI réduit directement le temps de calcul des runners.
- *Pérennité du Code :* La standardisation des pratiques de tests et les guides rédigés sur le wiki garantissent une baisse durable de la dette technique.

== Bilan personnel
Ce stage de fin d'études a été une expérience d'ingénieur complète. Sur le plan technique, il m'a permis d'approfondir mes connaissances des entrailles de Spring Boot, du scripting CI/CD avancé, et des architectures émergentes d'IA agentique (LangGraph, MCP). Sur le plan méthodologique, j'ai développé ma capacité à mener des audits de performance, à prendre des décisions d'architecture en autonomie, et à communiquer mes choix à travers des présentations techniques et de la documentation.