#text(fill: rgb("4a90e2"))[= Travail Réalisé : Optimisation, Design Pattern et R&D Agentique]


== Axe 1 : Refonte de la stratégie de tests et optimisation CI/CD


=== Contexte technique, investigation et définition des objectifs

À mon arrivée au sein des équipes travaillant sur le projet Farmstar, le cycle de développement logiciel était ralenti par une infrastructure de tests manquant de standardisation et d'optimisation structurelle. Bien que la base de code soit fonctionnelle et réponde aux exigences métiers, la validation de nouvelles fonctionnalités souffrait de goulots d'étranglement techniques affectant directement la productivité et la boucle de feedback des développeurs.

=== Les symptômes initiaux
Lors de mes premières semaines de prise en main du projet, trois problématiques majeures se sont dégagées :

- *Lenteur prononcée de l'Intégration Continue (CI) :* Le temps d'exécution des tests du module principal s'avérait particulièrement long, s'étalant de 17 à 20 minutes en local, et atteignant jusqu'à 40 minutes sur les pipelines GitLab CI.
- *Complexité et effet "boîte noire" :* Les tests d'intégration backend étaient utilisés de manière indifférenciée, à la fois pour valider la logique métier complexe et pour vérifier de simples contrats d'API (tests End-to-End). Cette confusion des périmètres rendait la suite de tests verbeuse, et il était difficile de distinguer les tests réellement critiques des tests de "surface".
- *Fragilité de la suite de tests du backend :* Il n'existait pas de stratégie de tests de fumée (*smoke tests*) pour les routes backend empruntés par le frontend. Ainsi, une modification du backend pouvait passer inaperçue si elle n'était pas couverte par un test d'intégration, exposant le projet à des risques de régressions non détectées lors des mises en production.
- *Fragilité de l'environnement frontend :* Les tests de fumée (*smoke tests*) permettant de valider l'état de des routes utilisés côté frontend après déploiement étaient inexistants, exposant le projet à des risques de régressions non détectées lors des mises en production.

=== Phase d'audit et analyse des goulots d'étranglement
Pour comprendre l'origine exacte de ces lenteurs, notamment concernant la partie backend, une phase d'investigation technique a été initiée. Il était nécessaire de dépasser le simple constat de lenteur pour diagnostiquer le comportement de la JVM durant l'exécution des suites de tests.

J'ai procédé au déploiement d'outils d'audit de performance de l'application, et plus particulièrement de l'outil de métrologie "spring-test-profiler". L'analyse attentive des rapports générés a mis en lumière une anomalie architecturale : un manquement dans la gestion du cache Spring.

Les métriques ont révélé que chaque classe de test provoquait la destruction et le redémarrage complet du contexte applicatif. Au lieu de réutiliser un environnement partagé, la JVM était forcée de recharger un monolithe de plus de 2000 beans à chaque itération. Cette "fuite de contexte" imposait une pénalité systématique d'environ 45 secondes par démarrage. Il est alors apparu évident que la source principale de l'effondrement des performances de la CI n'était pas liée à la complexité des tests eux-mêmes, mais bien à la charge d'initialisation répétée du framework.

=== Définition des objectifs
Suite à ce diagnostic, les objectifs de cette première phase de mission ont été définis afin de restructurer la stratégie de test en profondeur. L'enjeu était de résoudre les anomalies identifiées sans altérer la couverture fonctionnelle du code (éviter les régressions).
#linebreak()
Les axes d'amélioration ont été fixés ainsi :

*1. Résolution des anomalies de performance*
- Identifier et éliminer les configurations provoquant la fuite de contexte Spring mise en évidence lors de l'audit.
- Centraliser le chargement de l'environnement applicatif pour garantir un *Cache Hit Rate* #footnote[Le *Cache Hit Rate* représente le pourcentage de requêtes où les données ont été trouvées dans le cache, évitant ainsi un accès plus lent à la source originale. Un taux élevé indique une meilleure performance.] maximal et réduire le temps d'exécution global à quelques minutes.

*2. Clarification de l'architecture de test*
- Séparer strictement les responsabilités : isoler la validation de la logique métier interne de la validation des points de terminaison HTTP.
- Déporter la vérification des contrats d'API vers un outillage externe dédié, léger et exempt du coût de démarrage du backend. (Tests d'intégration vs Tests End-to-End vs Smoke Tests)
- Combler le déficit de couverture frontend en déployant une infrastructure de tests de non-régression rapide et isolée des problématiques réseau. (Smoke Tests Frontend)

*3. Sécurisation "Shift-Left" #footnote[Le "Shift-Left" est une approche de développement logiciel qui consiste à déplacer les activités de test et de qualité vers les premières étapes du cycle de développement, afin de détecter et de corriger les défauts plus tôt et à moindre coût.] et Standardisation*
- Déplacer la vérification de la qualité et de la sécurité du code au plus près du développeur, en interceptant les anomalies avant même le déclenchement de la CI. (Pré-commit et pré-push Git Hooks)
- Rédiger un référentiel technique documentant ces nouvelles normes afin de standardiser l'écriture des tests au sein de l'équipe et de prévenir l'accumulation future de dette technique. (Guide de bonnes pratiques, Wiki interne)

Pour répondre aux objectifs fixés, la refonte s'est articulée autour de trois chantiers techniques majeurs, allant du cœur du backend jusqu'à la chaîne d'intégration continue.

=== Centralisation et optimisation du contexte Spring Boot
Le premier défi consistait à endiguer la "fuite de contexte" identifiée lors de l'audit. J'ai conçu et mis en place une classe mère globale, "AbstractIntegrationTest", dont héritent désormais toutes les classes de test. Cette architecture a permis de mutualiser les configurations complexes ("MockBean", "SpyBean") et d'éliminer les annotations destructrices de cache, telles que "DirtiesContext".

Parallèlement, la gestion de la sécurité asynchrone levait fréquemment des exceptions ("AccessDeniedException"). J'ai développé un utilitaire centralisé ("SecurityTestUtils") pour forcer l'injection de contextes de sécurité fiables et liés à la base de données utilisée.

*Résultat :* Le temps de build local est passé de 17 minutes à 3 minutes, avec un taux d'utilisation du cache (*Cache Hit Rate*) stabilisé à 99,5%. Sur la CI GitLab, le temps d'exécution a été réduit de 70%, passant de 19:18 à 5:45.

#figure(
    image("assets/BeforeOptimization.png", width: 100%),
    caption: [Avant Optimisation : Chaque classe de test réinitialise le contexte Spring Boot, entraînant des pénalités de performance.]
) <fig:integration_test_legacy>

#figure(
  image("assets/AbstractIntegrationTest.png", width: 100%),
  caption: [Après Optimisation : Mutualisation du contexte Spring Boot pour tous les tests d'intégration.]
) <fig:integration_test_optimized>

=== Externalisation des contrats d'API avec Bruno
Pour désengorger les tests d'intégration Spring, j'ai migré des tests de validation HTTP ("MockMvc") vers le client d'API Bruno. Afin de rendre ces tests de bout en bout autonomes et rejouables sans polluer la base de données de la CI, une génération d'IDs dynamiques via des scripts JavaScript pré-requêtes est utilisée (génération de timestamps et UUID). Enfin, j'ai mis à jour le script Bash d'exécution des tests Bruno sur la CI, afin qu'il exécute cette nouvelle suite de tests.

#figure(
  image("assets/WorkflowValidationAPI.png", width: 65%),
  caption: [Workflow de validation des contrats d'API via Bruno]
) <fig:bruno_workflow>

#linebreak()

J'ai créé une suite de smoke tests couvrant l'intégralité des routes API backend sollicitées par le frontend lors de son chargement.

*Objectif* : Vérifier que chaque point d'entrée métier (Identité, Agronomie, Gestion de parcelles) répond aux attentes contractuelles du frontend. Ces tests agissent comme une sentinelle : ils permettent de détecter immédiatement si une modification backend "casse" la communication avec l'interface.

#figure(
  image("assets/BackEndSmokeTests.png", width: 100%),
  caption: [Quand est-ce qu'il s'agit d'un smoke test ?]
) <fig:backend_smoke_test>

#pagebreak()

=== Fiabilisation Frontend
Côté frontend, j'ai mis en place une suite de tests de fumée (*Smoke Tests*) pour valider les routes critiques utilisées par l'interface utilisateur. Afin de choisir quel framework de tests automatisés utiliser, j'ai mené un benchmark technique comparant Cypress et Playwright (*en annexe*). Les résultats ont montré que l'infrastructure existante sous Cypress serait trop lourde pour les besoins du projet.
 Une fois le choix de Playwright validé, j'ai réécrit les tests de fumée pour qu'ils soient plus rapides et plus fiables.
 En cours de développement, il s'est avéré que la dépendances de ces tests au lancement du backend ralentissait considérablement le cycle de la CI. Ainsi, j'ai mis en place un mock du backend pour isoler les tests frontend et réduire le temps d'exécution. Cette approche a permis de diviser le temps d'exécution des Smoke Tests par trois (de 5m 28s à 1m 45s).
 === Benchmark Technique : Cypress vs Playwright
 Pour valider l'architecture de tests de fumée du frontend, une étude comparative (*en annexe*) a été menée sur une suite représentative de 18 parcours utilisateurs critiques (Identity, Agronomy, Parcel Management, Monitoring).



 L'avantage de Playwright réside dans sa capacité à intercepter nativement le réseau via une fonction dédiée ("injectAuthHeaders"), injectant de manière dynamique les en-têtes d'authentification ("x-authenticated-user", "x-authenticated-roles") sans dépendre d'un sous-système complexe. De plus, le découplage des tests frontend vis-à-vis du backend via un système de moquage par fichiers ".har" a permis de sécuriser le build sur la CI GitLab.

=== Stratégie "Shift-Left"
Pour garantir la pérennité de ces optimisations, j'ai mis en place une stratégie "Shift-Left" via des hooks Git. J'ai configuré des scripts "pre-commit" (exécutant Spotless, Checkstyle et SonarLint uniquement sur les fichiers modifiés) et "pre-push" (lançant les Smoke Tests impactés). Cela permet d'intercepter les régressions directement sur le poste du développeur, avant de solliciter la CI.

== Axe Transverse : Industrialisation et Pattern GenericHydrator
En parallèle des chantiers de CI et d'IA, un travail d'architecture logicielle a été mené sur le backend Java (`fs-core`) pour simplifier les services métier complexes (tels que `StrategyService`).

=== Conception du GenericHydrator
La création et la mise à jour d'entités JPA complexes nécessitaient une vérification répétitive des DTOs. J'ai développé un composant générique `GenericHydrator` s'appuyant sur la réflexion Java :
- `@HydrationField` : Définie sur les DTOs pour automatiser le mapping vers les entités.
- `@HydrationGuard` : Placé sur les méthodes de validation métier (ex: vérification des doublons de noms, règles d'intervalles de dates).

=== Fiabilisation et Testabilité
Pour valider ce composant sans dupliquer de code de test, j'ai mis en place une classe abstraite de test (`AbstractGenericHydratorTest`) exploitant la puissance des tests paramétrés JUnit 5 (`@ParameterizedTest`, `@MethodSource`). Cette approche a permis de couvrir l'intégralité des cas aux limites (*edge cases*) et d'assurer une remontée propre des exceptions métier (converties en erreurs HTTP 400).

=== Chronologie et Planning de la Mission
#table(
  columns: (1.5fr, 2fr, 2fr),
  align: (left, left, left),
  [*Période*], [*Planning Prévisionnel*], [*Réalisation Réelle*],
  [Février 2026], [Prise en main fs-core & audit des builds], [Refactoring `AbstractIntegrationTest` & profilage Spring],
  [Mars 2026], [Migration des tests API & CI], [Portage Bruno, Playwright Frontend & Hooks Git],
  [Avril 2026], [R&D IA & FastMCP], [Setup Open WebUI, FastMCP & Pattern `GenericHydrator`],
  [Mai 2026], [Orchestration LangGraph], [Migration Multi-agents POO & Subgraphs],
  [Juin - Juillet 2026], [Industrialisation PoC & Rédaction], [Module Ingestion générique, Dockerisation & Rapport ST50]
)