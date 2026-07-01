#text(fill: rgb("4a90e2"))[= 3. Travail Réalisé : Optimisation et R&D Agentique]

== Contexte technique, investigation et définition des objectifs

À mon arrivée au sein des équipes travaillant sur le projet Farmstar, le cycle de développement logiciel était ralenti par une infrastructure de tests manquant de standardisation et d'optimisation structurelle. Bien que la base de code soit fonctionnelle et réponde aux exigences métiers, la validation de nouvelles fonctionnalités souffrait de goulots d'étranglement techniques affectant directement la productivité et la boucle de feedback des développeurs.

=== Les symptômes initiaux
Lors de mes premières semaines de prise en main du projet, trois problématiques majeures se sont dégagées :

- *Lenteur critique de l'Intégration Continue (CI) :* Le temps d'exécution des tests du module `fs-core` s'avérait particulièrement long, s'étalant de 17 à 20 minutes en local, et atteignant jusqu'à 40 minutes sur les pipelines GitLab CI.
- *Complexité et effet "boîte noire" :* Les tests d'intégration backend étaient utilisés de manière indifférenciée, à la fois pour valider la logique métier complexe et pour vérifier de simples contrats d'API (tests End-to-End). Cette confusion des périmètres rendait la suite de tests verbeuse, difficile à maintenir et complexe à déboguer en cas d'échec.
- *Fragilité de l'environnement frontend :* Les tests de fumée (*smoke tests*) permettant de valider l'état de l'application Front Manager après déploiement étaient inexistants, exposant le projet à des risques de régressions non détectées lors des mises en production.

=== Phase d'audit et analyse des goulots d'étranglement
Pour comprendre l'origine exacte de ces lenteurs, notamment sur la partie backend, une phase d'investigation technique a été initiée. Il était nécessaire de dépasser le simple constat de lenteur pour diagnostiquer le comportement de la JVM durant l'exécution des suites de tests.

J'ai procédé au déploiement d'outils d'audit de performance de l'application, et plus particulièrement de l'outil de métrologie `spring-test-profiler`. L'analyse minutieuse des rapports générés a mis en lumière une anomalie architecturale majeure : une défaillance critique dans la gestion du cache Spring (Context Cache Miss).

Les métriques ont révélé que chaque classe de test provoquait la destruction et le redémarrage complet du contexte applicatif. Au lieu de réutiliser un environnement partagé, la JVM était forcée de recharger un monolithe de plus de 2000 beans à chaque itération. Cette "fuite de contexte" imposait une pénalité systématique d'environ 45 secondes par démarrage. Il est alors apparu évident que la source principale de l'effondrement des performances de la CI n'était pas liée à la complexité des tests eux-mêmes, mais bien à la charge d'initialisation répétée du framework.

=== Définition des objectifs
Suite à ce diagnostic précis, les objectifs de cette première phase de mission ont été définis afin de restructurer la stratégie de test en profondeur. L'enjeu était de résoudre les anomalies identifiées sans altérer la couverture fonctionnelle du code. Les axes d'amélioration ont été fixés ainsi :

*1. Résolution des anomalies de performance*
- Identifier et éliminer les configurations provoquant la fuite de contexte Spring mise en évidence lors de l'audit.
- Centraliser le chargement de l'environnement applicatif pour garantir un *Cache Hit Rate* maximal et réduire le temps d'exécution global à quelques minutes.

*2. Clarification de l'architecture de test*
- Séparer strictement les responsabilités : isoler la validation de la logique métier interne de la validation des points de terminaison HTTP.
- Déporter la vérification des contrats d'API vers un outillage externe dédié, léger et exempt du coût de démarrage du backend.
- Combler le déficit de couverture frontend en déployant une infrastructure de tests de non-régression rapide et isolée des problématiques réseau.

*3. Sécurisation "Shift-Left" et Standardisation*
- Déplacer la vérification de la qualité et de la sécurité du code au plus près du développeur, en interceptant les anomalies avant même le déclenchement de la CI.
- Rédiger un référentiel technique documentant ces nouvelles normes afin de standardiser l'écriture des tests au sein de l'équipe et de prévenir l'accumulation future de dette technique.
== Axe 1: Refonte de la stratégie de tests et optimisation CI/CD
== Axe 2: R&D et Implémentation d'une IA Agentique Autonome

