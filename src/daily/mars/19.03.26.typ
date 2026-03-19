#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(weight: "bold", size: 1.2em)[UTBM] \
    #text(size: 0.9em)[Stage de Fin d'Études (ST50)]
  ],
  align(right)[
    #text(weight: "bold", size: 1.1em)[Magellium] \
    #text(size: 0.9em)[Projet : Farmstar Core Service] \
    #text(size: 0.9em)[Date : 19/03/2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation CI GitLab et standards de test]
]

== Travaux réalisés
Aujourd'hui, j'ai corrigé plusieurs blocages sur les pipelines d'intégration continue et préparé le lexique pour une présentation technique.

=== Débogage et optimisation de la CI Frontend
- Correction d'une erreur 404 sur les tests Playwright : le script CI exécutait les tests unitaires mais ne compilait pas l'application Angular. Ajout de `npx serve -s` pour exposer le dossier `dist` et gérer le routage SPA.
- Résolution d'un problème de configuration d'environnement où les tests tapaient sur l'API de production au lieu de localhost. Création d'un environnement `ci` spécifique dans `angular.json` et `environment.ci.ts`.
- Réduction du temps de préparation du job Playwright (qui bloquait pendant 6 minutes). Le problème venait du dossier `node_modules` (220 Mo) passé en artefact. Passage exclusif par le système de cache GitLab pour les dépendances.

=== Scripting Bash pour les Cloud Functions
- Création du script `cloud-function-test.sh`.
- Ajout d'une logique conditionnelle pour vérifier l'existence des scripts `build` et `test` dans les `package.json` avant exécution, évitant ainsi les crashs npm sur les fonctions qui n'en ont pas besoin.
- Ajout de tests pour les cloud functions.
=== Préparation de la présentation sur les tests
- Rédaction de définitions courtes (CI, Mock, Boucle de feedback, Contexte Spring) pour vulgariser le vocabulaire technique de la présentation.
- Ajout de documentation dans les snippets de code Java de la présentation (ex: commentaire interdisant l'usage de `@SpringBootTest` sur les tests unitaires pour maintenir des temps d'exécution bas).

== Analyse et plan d'action
- *Bilan* : Les pipelines CI pour le frontend et les cloud functions sont repassés au vert.
- *Prochaine étape* : Configurer fs-core et gateway sur la CI pour qu'il run pendant les tests E2E de front-manager.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]