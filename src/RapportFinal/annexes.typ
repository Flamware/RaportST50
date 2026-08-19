#text(fill: rgb("4a90e2"))[= Annexes]
== Annexe 1 : Tableau d'Analyse Réflexive des Compétences (Obligatoire UTBM)

#table(
  columns: (1.5fr, 2fr, 2fr),
  align: (left, left, left),
  [*Domaine de Compétence*], [*Compétences Mobilisées / Développées*], [*Projets / Actions Concrètes*],
  [Ingénierie Logicielle & Architecture], [Conception orientée objet, design patterns (Factory, Hydrator, Observer), refactoring de code legacy Java/Spring Boot.], [Développement du `GenericHydrator`, unification des contextes de test Spring (`AbstractIntegrationTest`).],
  [DevOps & Qualité Logicielle], [Optimisation de chaînes CI/CD, métrologie/profiling, écriture de hooks Git (`pre-commit`/`pre-push`), conteneurisation Docker.], [Réduction du temps de build GitLab CI de 70%, benchmark Playwright vs Cypress, dockerisation du PoC IA.],
  [Intelligence Artificielle & R&D], [Orchestration d'agents LLM, protocole MCP, RAG (Vector DB Qdrant), typage strict des sorties (Instructor/Pydantic).], [Conception de l'architecture multi-agents LangGraph et du serveur FastMCP pour le projet Farmstar.],
  [Gestion de Projet & Posture], [Autonomie, démarche "Fast-Fail", animation de présentations techniques, rédaction de documentation et wiki.], [Animation de la restitution technique (28 slides) et rédaction des guides de bonnes pratiques de test.]
)

== Annexe 2 : Bibliographie & Sources Techniques (Indispensable UTBM)

*Axe 1 — Ingénierie logicielle & CI/CD*
- *Spring Framework Documentation* – Spring Test Context Management & Caching, 2026.
- *Checkstyle Documentation* – Static Code Analysis Rules for Java, 2026.
- *Spotless (Diffplug) Documentation* – Automated Code Formatting, 2026.
- *SonarSource* – SonarLint & SonarQube Documentation, Static Analysis and Code Quality Gates, 2026.
- *GitLab Documentation* – CI/CD Pipelines Configuration Reference, 2026.
- *Docker Documentation* – Docker Compose Multi-Container Orchestration, 2026.
- *JUnit 5 User Guide* – Parameterized Tests and Extension Model, 2026.
- *Mockito Documentation* – Framework de mock pour Java, 2026.
- *Playwright Frontend Testing* – Network Interception and Mocking Strategies, Fast End-to-End Execution, 2026.
- *Cypress Documentation* – End-to-End Testing Framework, 2026.
- *Bruno Documentation* – Git-friendly API Client, 2026.

*Axe 2 — IA agentique, RAG & Orchestration*
- *LangChain & LangGraph Documentation* – Multi-Agent Orchestration & State Management, 2026.
- *Model Context Protocol (MCP) Specification* – Anthropic Open Standard for AI Tool Integration, 2025-2026.
- *Instructor Python Library* – Structured Outputs for LLMs via Pydantic Validation, 2026.
- *Pydantic Documentation* – Data Validation Using Python Type Hints, 2026.
- *Qdrant Documentation* – Vector Database for Semantic Search, 2026.
- *LangFuse Documentation* – LLM Observability and Tracing Platform, 2026.
- *Tree-sitter Documentation* – Incremental Parsing Library, 2026.
- *Google* – Gemma Model Documentation (ai.google.dev/gemma), 2026.
- *Streamlit Documentation* – Framework Python pour interfaces d'administration, 2026.
- Robertson, S. & Zaragoza, H. – *The Probabilistic Relevance Framework: BM25 and Beyond*, Foundations and Trends in Information Retrieval, 2009.
- Nogueira, R. & Cho, K. – *Passage Re-ranking with BERT*, arXiv:1901.04085, 2019.
- Wei, J. et al. – *Chain-of-Thought Prompting Elicits Reasoning in Large Language Models*, NeurIPS, 2022.

*Sources entreprise*
- *Chiffres clefs* - https://www.pappers.fr/entreprise/magellium-450550991
- Le Journal des Entreprises – *Le groupe Artal reprend Magellium*, 2016, lejournaldesentreprises.com.
- Le Journal des Entreprises – *Magellium Artal fait évoluer son capital pour devenir un leader européen*, 2025, lejournaldesentreprises.com.
- Magellium Artal Group – *Qui sommes-nous*, magellium.com/en/qui-sommes-nous, 2026.

*Sources tarifaires (comparatif abonnements IA, consultées le 19/08/2026)*
- GitHub – *Copilot Business Pricing & AI Credits*, docs.github.com/en/copilot/concepts/billing/organizations-and-enterprises, 2026.
- OpenAI – *Business Pricing (ChatGPT Business)*, openai.com/business/chatgpt-pricing, 2026.
- Anthropic – *Claude Team Plan Pricing*, claude.com/pricing, 2026.

== Annexe 3 : Analyse Framework de test Frontend
#include("assets/AnalyseCypressPlaywright.typ")
#pagebreak()

== Annexe 4 : Analyse outils de pré-commit
#include("assets/PreCommitAnalyse.typ")
