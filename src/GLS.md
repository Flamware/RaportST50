## 1. Mes Expériences Professionnelles et Associatives

### Projet Magellium (Stage Actuel - 2 Etapes cles)

#### Etape 1 : Qualite, Tests et DevOps (Sujet propose par l'entreprise)

* **Contexte (C) :**
  * Intégration au sein de l'équipe travaillant sur une WebApp d'agriculture de précision.
  * Architecture micro-services Java/Angular sur GCP.
  * PAS DE PROBLEMATIQUE CEST MOI QUI CHERCHAIT A AMELIORER LES STANDARDS DE TEST ET LA QUALITE DU CODE.
  * Problématique : Pipelines de CI/CD trop longs (30 minutes), ce qui ralentissait fortement le rythme des déploiements de l'équipe.

* **Action (A) :**
  * Reprise en main des standards de tests automatisés et optimisation de bout en bout des pipelines GitLab CI/CD.
  * Utilisation d'outils de profiling de tests pour identifier les goulots d'étranglement.
  * Ajout de deux suites de tests : smoke-tests pour le service principal (backend) et pour le frontend.
  * Refactorisation des tests d'intégration en mettant en place du partage de contexte pour accélérer l'exécution.
  * Ajout de hooks de pre-commit et pre-push pour garantir la qualité du code localement.
  * Rédaction d'un guide de bonnes pratiques de test et de clean code pour l'équipe.
  * Refactorisation de runs GitLab pour utiliser efficacement le cache et optimiser le processus.
  * Animation d'ateliers techniques (workshops) pour présenter mes avancées et partager les bonnes pratiques avec l'équipe.

* **Resultat (R) :**
  * Temps d'exécution des pipelines divisé par deux (de 30 à 15 minutes en moyenne).
  * Gain de productivité et de fluidité dans les déploiements de l'équipe.
  * Montée en compétences de l'équipe sur les standards DevOps, de test et de clean code en général.

* **Stack technique :**
  * Java Spring Boot, Angular, GCP, Docker, Kubernetes, GitLab CI/CD.

* **Competences developpees :**
  * Rigueur et Qualité : Standardisation des processus de test et de validation avant livraison en production.
  * Communication et Pédagogie : Animation de workshops d'équipe pour l'alignement technique.
  * Autonomie : Capacité à s'approprier et à refondre rapidement une infrastructure CI/CD existante.

#### Etape 2 : IA Agentique et R&D (Sujet propose par moi-meme suite a l'Etape 1)

* **Contexte (C) :**
  * Identification d'une opportunité d'améliorer la productivité de l'équipe grâce à l'IA générative une fois la CI/CD stabilisée.
  * Proposition proactive à la hiérarchie d'un sujet de R&D : conception d'un assistant technique local et souverain pour aider à la génération de tests et automatiser les revues de code.

* **Action (A) :**
  * Conception et développement en totale autonomie de workflows d'agents autonomes via LangGraph.
  * Implémentation du protocole MCP (Model Context Protocol) pour connecter les LLMs aux outils internes.
  * Déploiement d'une architecture RAG avec la base vectorielle Qdrant pour contextualiser les réponses de l'IA.

* **Resultat (R) :**
  * Livraison d'un PoC fonctionnel d'IA locale souveraine validé en interne.
  * Démonstration de la faisabilité d'une assistance technique automatisée sécurisée au quotidien.

* **Stack technique :**
  * LangGraph, MCP (Model Context Protocol), Qdrant (base vectorielle RAG), Chainlit, LLMs locaux.

* **Competences developpees :**
  * Force de proposition : Capacité à transformer une idée technologique en projet validé par la hiérarchie.
  * R&D et Veille technologique : Auto-formation et intégration rapide de technologies émergentes (MCP, LangGraph).
  * Autonomie technique : Conception d'une architecture IA de bout en bout sans encadrement dédié.

---

### Mission Technopure (Junior UTBM) - Ton atout GoLang et DevOps



* **Contexte (C) :**
  * Besoin de Technopure d'une plateforme web pour superviser, monitorer et configurer en temps réel des purificateurs d'air industriels connectés.
  * Contraintes : Ingestion sécurisée de flux massifs de données toutes les 15 secondes et isolation des données (RGPD).
  * Volume de travail réel : Projet mené sur une durée de 8 mois, à raison de 20 heures par semaine.

    
* **Action (A) :**
  * Conception d'une architecture micro-services en GoLang avec isolation stricte des flux temps réel.
  * Implémentation d'un broker MQTT (Mosquitto) pour découpler l'ingestion de données des terminaux IoT.
  * Intégration d'un décodage de signatures matérielles TPM 2.0 pour la sécurité et l'intégrité des payloads.
  * Conteneurisation globale avec Docker et orchestration via Kubernetes sur GCP.




* **Resultat (R) :**
  * Mise en production d'une solution stable, résiliente et sécurisée.
  * Automatisation à 100% du pipeline CI/CD, permettant l'ingestion temps réel et la configuration à distance sans latence.

* **Stack technique :**
  * GoLang, React (Vite), MQTT (Mosquitto), InfluxDB, GCP Pub/Sub, Docker, Kubernetes, GitHub.

* **Competences developpees :**
  * Architecture IoT et Micro-services : Gestion d'ingestion de flux asynchrones haute fréquence.
  * Sécurité par Design : Implémentation de protocoles matériels (TPM 2.0) et conformité réglementaire.
  * Compétences DevOps : Déploiement cloud, orchestration de conteneurs et CI/CD.
  * Gestion du temps et Résilience : Conduite d'un projet de fond sur le long terme parallèlement aux études d'ingénieur.

---

### NoMi Foundation (Projet Mobile et Web Associatif)

* **Contexte (C) :**
  * Reprise d'une application mobile et web (iOS, Android, WebApp) destinée à améliorer le quotidien des enfants hospitalisés.

  * État initial : Problèmes majeurs de performance, fuites de mémoire et crashs fréquents sur les stores.

* **Action (A) :**
  * Rôle double de Scrum Master et de développeur fullstack au sein de l'équipe.
  * Audit et refactorisation du code natif Kotlin et Swift pour éliminer les fuites de mémoire.
  * Réorganisation des flux de travail en méthodologie agile (rituels, planification des sprints).
  * Développement de trois fonctionnalités majeures : espace parents, module de statistiques d'utilisation et forum communautaire.

* **Resultat (R) :**
  * Réduction drastique du taux de crash applicatif sur iOS et Android.
  * Livraison et mise en production réussie des trois nouveaux espaces applicatifs.


* **Stack technique :**
  * NextJS, Firebase, React Native, Kotlin, Swift, GitHub, VPC.

* **Competences developpees :**
  * Agilité et Leadership : Coordination d'équipe et animation des rituels Scrum.
  * Savoir-faire Legacy : Analyse, stabilisation et reprise d'un projet existant complexe.
  * Optimisation technique : Profiling mémoire et fiabilisation de code applicatif natif.
  * Itération rapide : Capacité à délivrer rapidement de nouvelles fonctionnalités.

---

### Projet GreenWits (Filiale IFPEN) - Stage



* **Contexte (C) :**
  * Besoin de concevoir rapidement un prototype fonctionnel (PoC) pour monitorer les données physiques et énergétiques de parcs éoliens.

* **Action (A) :**
  * Prise en charge autonome de la conception de l'architecture technique et du développement complet du MVP.

* **Resultat (R) :**
  * Livraison et validation du prototype fonctionnel dans les délais (5 mois).
  * Adoption du PoC comme base de référence technique pour la future solution commerciale.

* **Stack technique :**
  * FastAPI (Python), React, MongoDB, GitLab.

* **Competences developpees :**
  * Autonomie et Prise de décision : Capacité à mener seul des choix technologiques et architecturaux.
  * Force de proposition : Capacité à transformer un besoin métier en prototype concret.
  * Itération rapide : Livraison d'un produit exploitable en un temps restreint.

---

## 2. Mes Expériences Académiques et Personnelles

### Projet Java/Spring Boot - Laboratoire de recherche CIAD (UTBM)

* **Contexte (C) :**
  * Refonte complète du backend du site web des chercheurs du laboratoire de recherche CIAD de l'UTBM.

* **Action (A) :**
  * Développement de l'architecture backend et d'une interface front-end, à raison de 10 heures par semaine en parallèle du cursus universitaire.

* **Resultat (R) :**
  * Plateforme moderne et fonctionnelle livrée dans les temps, répondant aux contraintes d'organisation des chercheurs.

* **Stack technique :**
  * Java Spring Boot, React.

* **Competences developpees :**
  * Organisation personnelle : Gestion de l'emploi du temps en parallèle d'un cursus exigeant.
  * Rigueur technique : Respect d'un cahier des charges académique spécifique.

---

### Projet Personnel - CLundi (Reseau Social)

* **Contexte (C) :**
  * Concevoir et déployer un réseau social complet de bout en bout.
    
* **Action (A) :**
  * Initialisation en PHP, puis refonte complète vers une architecture micro-services GoLang et VueJS.
  * Migration vers CockroachDB, conteneurisation via Docker et automatisation des déploiements sur VPS via des pipelines GitHub Actions.

* **Resultat (R) :**
  * Mise en production d'une application performante servant d'environnement de test pour de nouvelles technologies.

* **Stack technique :**
  * PHP vers FastAPI + VueJS vers GoLang + React, CockroachDB, Docker, VPS, GitHub Actions.

* **Competences developpees :**
  * Auto-formation : Apprentissage autonome de nouvelles stacks (GoLang, CI/CD).
  * Vision fullstack et infrastructure : Maîtrise de la chaîne complète, du code au déploiement d'infrastructure.
  * Curiosité technique : Recherche continue d'optimisation et de modernisation des architectures.


| Concept | React | Angular |
| :--- | :--- | :--- |
| **Nature** | Bibliothèque : tu choisis tes outils (routeur, state, etc.) | Framework complet "batteries incluses" (routeur, formulaires, HTTP intégrés) |
| **Data Binding** | Unidirectionnel : les données descendent via les *props* | Bidirectionnel : *Two-way data binding* (ex: `[(ngModel)]`) |
| **Architecture** | Libre, basée sur des Hooks (`useState`, `useEffect`) | Très structurée, basée sur l'injection de dépendances et RxJS |

| Aspect | Go (Golang) | Java (Spring Boot) |
| :--- | :--- | :--- |
| **Performance** | Temps de démarrage quasi instantané, faible latence. | Temps de démarrage plus long (dû à la JVM). |
| **Déploiement** | Binaire statique unique (facile à copier/exécuter). | Nécessite une JVM installée (plus lourd). |
| **Concurrency** | Goroutines (très légères, milliers possibles). | Threads système (plus lourds, consommation mémoire). |
| **Verbosité** | Minimaliste, syntaxe simple, focus sur le code. | Verbeuse, beaucoup d'annotations, très riche. |
| **Gestion mémoire** | Très optimisé pour le Cloud/IoT. | Garbage Collector puissant mais gourmand en RAM. |
| **Usage idéal** | Micro-services, IoT, temps réel, outils système. | Applications d'entreprise complexes, gros systèmes transactionnels. |

Quels sont les plus gros challenges techniques actuels de l'équipe de développement chez GLS ?
Comment gérez-vous la dette technique sur vos projets actuels ?
Sur quoi devrais-je me concentrer en priorité durant mes premiers jours ?
Dev fullstack à quel niveuax ? Touche à la CI/CD, DevOps, tests automatisés, micro-services, cloud (GCP/AWS), conteneurisation (Docker/Kubernetes), et éventuellement IA générative si le projet le permet ?
Quel temps alloué à la veille technologique et à l'auto-formation sur les nouvelles technologies émergentes ?