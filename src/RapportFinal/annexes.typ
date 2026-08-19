#text(fill: rgb("4a90e2"))[= Annexes]
== Annexe 1 : Bibliographie & Sources Techniques

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

== Annexe 2 : Tableau d'Analyse Réflexive des Compétences (Obligatoire UTBM)

Ce tableau met en correspondance les missions réalisées durant le stage avec les blocs de compétences du référentiel officiel du diplôme d'ingénieur UTBM, spécialité Informatique #footnote[UTBM, _Référentiel de compétences — Diplôme d'ingénieur, spécialité Informatique_, DFP_FISE-FISA_Informatique_Referentiel_Competences_29112024.].

#table(
  columns: (1.8fr, 1.9fr, 2.4fr),
  align: (left, left, left),
  [*Bloc de compétences (référentiel)*], [*Compétence(s) mobilisée(s)*], [*Mission / action concrète durant le stage*],
  [Bloc 1 — Identifier, modéliser et résoudre des problèmes informatiques], [Comp. 3 : concevoir et intégrer des algorithmes et structures de données optimisées], [Audit et profilage du cache Spring Boot pour réduire le temps de build local ; conception du pattern `GenericHydrator` pour unifier des services métier complexes.],
  [Bloc 1 — Identifier, modéliser et résoudre des problèmes informatiques], [Comp. 4 : reconnaître un problème du domaine de l'IA et mettre en œuvre les méthodes adaptées], [Identification des limites d'isolation des agents sous Open WebUI ; conception d'un prototype d'orchestration multi-agents pour y répondre.],
  [Bloc 2 — Concevoir, développer, mettre au point et conduire des projets d'application informatique], [Comp. 5 : appliquer les paradigmes de la programmation orientée objet en collaboration], [Architecture orientée objet des agents (classe abstraite `Agent`, registres de configuration) du workflow `TEST_COVERAGE`.],
  [Bloc 2 — Concevoir, développer, mettre au point et conduire des projets d'application informatique], [Comp. 6 : réaliser des études et développements informatiques en équipe], [Migration d'une partie des tests d'API vers Bruno, mise en place de tests E2E Playwright, rédaction de hooks Git `pre-commit`/`pre-push`.],
  [Bloc 3 — Concevoir, piloter, organiser, optimiser et gérer des systèmes d'information], [Comp. 9 : concevoir et administrer des bases de données], [Intégration de Qdrant (base vectorielle) pour la recherche sémantique du PoC RAG.],
  [Bloc 3 — Concevoir, piloter, organiser, optimiser et gérer des systèmes d'information], [Comp. 13 : auditer les systèmes d'information et préconiser des évolutions], [Audit des pipelines GitLab CI (temps de build, goulots d'étranglement) et mise en œuvre des optimisations retenues.],
  [Bloc 5 — Élaborer, concevoir et mener des stratégies d'intégration et d'évolution des installations matérielles et logicielles], [Comp. 24 : sélectionner, assembler et intégrer des composants informatiques], [Sélection et intégration raisonnée d'un outillage (LangGraph, MCP/FastMCP, Instructor, Docker) après benchmarks comparatifs (ex. Playwright vs Cypress).],
  [Bloc 6 — Définir, planifier, organiser et manager un projet d'ingénierie innovant face à des problèmes non familiers], [Comp. 28 : analyser un problème non familier selon une approche systémique], [Proposition, argumentation et conduite en autonomie de l'axe R&D IA agentique, non prévu au départ du stage.],
  [Bloc 6 — Définir, planifier, organiser et manager un projet d'ingénierie innovant face à des problèmes non familiers], [Comp. 29 : déployer une démarche d'innovation responsable], [Validation interne de l'axe IA sur la base de résultats concrets ; estimation chiffrée et mesurée (non extrapolée) du gain financier de l'optimisation CI/CD.],
  [Bloc 7 — Analyse systémique et critique des impacts environnementaux, sociétaux et humains], [Comp. 30 : identifier les enjeux liés au développement soutenable], [Réduction du temps de calcul des runners CI (empreinte de calcul) ; prise en compte de la souveraineté des données dans le choix d'une infrastructure IA locale plutôt qu'un SaaS externe.],
)

== Annexe 3 : Analyse Framework de test Frontend
#include("assets/AnalyseCypressPlaywright.typ")
#pagebreak()

== Annexe 4 : Analyse outils de pré-commit
#include("assets/PreCommitAnalyse.typ")

== Annexe 5 : Schémas techniques complémentaires

#figure(
  image("assets/WorkflowValidationAPI.png", width: 65%),
  caption: [Workflow de validation des contrats d'API via Bruno]
) <fig:bruno_workflow>

#figure(
  image("assets/BackEndSmokeTests.png", width: 100%),
  caption: [Quand est-ce qu'il s'agit d'un smoke test ?]
) <fig:backend_smoke_test>
