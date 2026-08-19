#text(fill: rgb("4a90e2"))[= Annexes]
== Annexe 1 : Tableau d'Analyse Réflexive des Compétences (Obligatoire UTBM)

#table(
  columns: (1.5fr, 2fr, 2fr),
  align: (left, left, left),
  [*Domaine de Compétence*], [*Compétences Mobilisées / Développées*], [*Projets / Actions Concrètes*],
  [Ingénierie Logicielle & Architecture], [Conception orientée objet, design patterns (Factory, Hydrator, Observer), refactoring de code legacy Java/Spring Boot.], [Développement du `GenericHydrator`, unication des contextes de test Spring (`AbstractIntegrationTest`).],
  [DevOps & Qualité Logicielle], [Optimisation de chaînes CI/CD, métrologie/profiling, écriture de hooks Git (`pre-commit`/`pre-push`), conteneurisation Docker.], [Réduction du temps de build GitLab CI de 70%, benchmark Playwright vs Cypress, dockerisation du PoC IA.],
  [Intelligence Artificielle & R&D], [Orchestration d'agents LLM, protocole MCP, RAG (Vector DB Qdrant), typage strict des sorties (Instructor/Pydantic).], [Conception de l'architecture multi-agents LangGraph et du serveur FastMCP pour le projet Farmstar.],
  [Gestion de Projet & Posture], [Autonomie, démarche "Fast-Fail", animation de présentations techniques, rédaction de documentation et wiki.], [Animation de la restitution technique (28 slides) et rédaction des guides de bonnes pratiques de test.]
)

== Annexe 2 : Bibliographie & Sources Techniques (Indispensable UTBM)

- *Spring Framework Documentation* – Spring Test Context Management & Caching, 2026.
- *LangChain & LangGraph Documentation* – Multi-Agent Orchestration & State Management, 2026.
- *Model Context Protocol (MCP) Specification* – Anthropic Open Standard for AI Tool Integration, 2025-2026.
- *Playwright Frontend Testing* – Network Interception and Mocking Strategies, Fast End-to-End Execution, 2026.
- *Instructor Python Library* – Structured Outputs for LLMs via Pydantic Validation, 2026.
- *Chiffres clefs* - https://www.pappers.fr/entreprise/magellium-450550991

== Annexe 3 : Analyse Framework de test Frontend
#include("assets/AnalyseCypressPlaywright.typ")
#pagebreak()

== Annexe 4 : Analyse outils de pré-commit
#include("assets/PreCommitAnalyse.typ")
#pagebreak()

= Sources :
