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
    #text(size: 0.9em)[Date : 27 février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Préparation de la restitution et intégration CI]
]

== Travaux réalisés
Cette journée a été consacrée à la mise au propre du travail d'optimisation des tests pour présentation, à la configuration de la CI et à la documentation des standards.

=== Préparation de la présentation et exécution locale
- Création du support de présentation (8 slides) pour détailler le passage d'une CI de 40 minutes à un feedback rapide via un arbre de décision (Unitaires, Intégration Spring, E2E Bruno).
=== Configuration CI/CD et débogage
- Résolution des problèmes de ciblage de dossiers et d'environnements (admin vs intégration) liés à la structure en micro-collections de Bruno.
- Mise à jour du fichier `.gitlab-ci.yml` en ajoutant deux jobs distincts (`smoke-tests` et `integration-tests`) pour exécuter les tests d'API directement dans le pipeline.

=== Documentation des standards
- Rédaction d'un guide technique (format Typst) destiné à l'équipe, formalisant les bonnes pratiques de tests : interdiction du `@SpringBootTest` global, utilisation du Slice Testing (`@WebMvcTest`), et règles d'écriture des tests Bruno avec génération d'IDs dynamiques.

== Analyse et plan d'action
- *Bilan* : Les supports de présentation sont prêts, avec des résultats concrets à montrer. Le pipeline GitLab est configuré pour lancer les requêtes Bruno de manière automatisée. Le guide de standardisation permet de figer les règles pour éviter d'accumuler de la dette technique sur les tests.
- *Prochaine étape* :
 - Discuter de la présentation avec le tuteur pour affiner les messages clés, et préparer une session de partage avec l'équipe pour présenter les nouvelles pratiques et outils.
 - Commencer à mutualiser les contextes de test dans `AbstractIntegrationTest` pour les autres modules du projet.
 - Etudier quels autres test E2E pourraient être portés vers Bruno pour alléger la suite d'intégration Spring.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]