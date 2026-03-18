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
    #text(size: 0.9em)[Date : 25 janvier 2025]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Refactoring de la chaîne pre-commit et ajout de tests end-to-end]
]

== Travaux réalisés
Reorganisation des hooks pre-commit pour corriger des problèmes de modifications involontaires de fichiers, et intégration de tests Playwright pour le frontend.

=== Réorganisation de la chaîne pre-commit
- Déplacement du hook `checkstyle` avant `spotless` dans `".pre-commit-config.yaml"` pour éviter que Spotless efface les modifications locales non committées
- Ajout du hook `sonarlint` dans la configuration pour analyser les fichiers modifiés (Java, TypeScript, JavaScript)
- Création du script `"./tools/sh/sonarlint-modified-files.sh"` pour exécuter SonarLint sur les fichiers staged uniquement

=== Intégration des tests Playwright pour le frontend
- Création du job GitLab CI `🎭 front-manager--playwright-test` dans `.gitlab-ci.yml` pour exécuter les tests end-to-end avec Playwright
- Configuration du job pour dépendre des builds `✅ core--build` et `✅ front-manager--build`
- Mise en place du cache des dépendances Node.js (`fs-front-manager/node_modules/`) en mode lecture seule
- Configuration de Chromium comme navigateur d'exécution via la variable `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH`
- Activation des tests Smoke sur le projet Chromium avec génération de rapports HTML et JUnit XML
- Définition des règles de déclenchement : manuel sur develop, automatique sur merge_request avec changements détectés, manuel sur les tags
- Artifacts configurés pour conserver les rapports Playwright et résultats des tests pendant 30 jours
