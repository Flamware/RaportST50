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
    #text(size: 0.9em)[Date : 19 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Plan de Présentation : Bonnes Pratiques de Tests & Application]
]

== Introduction
- **Constat initial :** Des temps de build trop longs, une architecture de test fragmentée, et une frontière floue entre tests d'intégration et tests End-to-End (E2E).
- **Objectif de la mission :** Standardiser les pratiques de tests, réduire la boucle de feedback pour les développeurs, et outiller le projet pour l'avenir.

== 1. Théorie : Les Fondations des Bonnes Pratiques


[Image of software testing pyramid]

- **La Pyramide des Tests :** Rappel des proportions idéales (beaucoup d'unitaires, quelques intégrations, peu d'E2E).
- **Définition stricte des périmètres :**
  - *Test Unitaire :* Isolé, exécution en millisecondes, sans contexte Spring.
  - *Test d'Intégration (Slice / Global) :* Validation des interactions entre composants (Base de données, Sécurité, Services).
  - *Test E2E / API :* Validation du contrat d'interface depuis l'extérieur.

== 2. Application n°1 : Optimisation des Tests d'Intégration (Spring Boot)

- **Problématique :** La multiplication des contextes Spring (et des beans chargés) détruit les performances de la CI.
- **La solution mise en place :** L'approche par `AbstractIntegrationTest`.
  - Mutualisation des configurations (`@MockBean`, `@SpyBean`, Security).
  - Élimination des "destructeurs de cache" (`@DirtiesContext`, redondances `@SpringBootTest`).
- **Résultat concret sur le projet :** Réduction du temps de build de 17 minutes à 3,6 minutes (Cache Hit Rate > 99%).
- **Gestion de la Sécurité :** Remplacement des annotations magiques (`@WithMockAdmin`) par l'injection de contextes de sécurité fiables et liés à la base de données de test.

== 3. Application n°2 : Tests API et E2E avec Bruno

- **Pourquoi Bruno ?** Transition d'une validation HTTP lourde (via Spring) vers un outil de test d'API léger, versionnable en texte brut (contrôle de source) et collaboratif.
- **Mise en œuvre :**
  - Structuration des collections et des environnements (Dev, CI, Prod).
  - Écriture de scripts de validation (assertions) et chaînage de requêtes.
- **Intégration Continue :** Comment exécuter ces tests Bruno dans la pipeline CI/CD de Farmstar pour valider les déploiements.

== Conclusion et Prochaines Étapes
- **Bilan :** Une architecture de test plus propre, des builds plus rapides, et des outils adaptés à chaque couche de la pyramide.
- **Guidelines pour l'équipe :**
  - Règle n°1 : Ne plus altérer le contexte Spring partagé sans justification majeure.
  - Règle n°2 : Privilégier l'injection par constructeur plutôt que `@Autowired` par champ.
  - Règle n°3 : Les contrats d'API se valident avec Bruno, la logique métier complexe avec JUnit/Spring.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Préparation de présentation ST50]