#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.")

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
    #text(size: 0.9em)[Date : 27 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Présentation : Refonte de la Stratégie de Tests] \
  #text(size: 1.2em, style: "italic")[Optimisation CI & Déploiement des Tests d'API avec Bruno]
]

#v(1em)

= Le Constat Initial (Pourquoi changer ?)
- *Lenteur de la CI* : Le module `fs-core` mettait entre 20 et 30 minutes à s'exécuter.
- *Effet "Boîte Noire"* : Des tests d'intégration lourds via `MockMvc`, difficiles à lire et à maintenir pour valider de simples contrats d'API.
- *Couverture inégale* : Apparition de régressions métiers à cause de failles dans le maillage des tests (Unitaires, Intégration, Security Matrix).
- *Objectif* : Optimiser drastiquement l'existant avant d'étendre la couverture.

= Phase 1 : L'Optimisation Spring Boot (Sous le capot)
*Problème identifié avec un Profiler* : Chaque classe de test redémarrait le contexte Spring (chargement d'un monolithe de plus de 2000 beans = ~45 secondes de pénalité par démarrage).

- *La solution : Centralisation et Mutualisation*
  - Création de la classe mère `AbstractIntegrationTest`.
  - Suppression des "tueurs de cache" (`@DirtiesContext`, `@Import` spécifiques, `@SpringBootTest` redondants).
  - Centralisation de la sécurité (`SecurityTestUtils`) pour en finir avec les conflits d'authentification asynchrones et les fausses données (`@WithMockAdmin`).
- *L'Exploit (Le Résultat)* :
  - Passage d'un temps de build local de *~20 minutes à 3,0 minutes*.
  - Cache Hit Rate de *99,5 %* (1 seul contexte Spring chargé pour toute la suite).

= Phase 2 : Les tests d'API avec Bruno
*Problème* : Les tests `MockMvc` sont trop lents à écrire pour du test End-to-End.
*Solution* : Extraction des tests de contrôleurs vers Bruno pour une validation HTTP réelle.

- *Une architecture claire (160+ requêtes réorganisées)* :
  - `Smoke Tests` : Validation rapide des endpoints vitaux en lecture (Fast-Fail).
  - `Intégration` : Scénarios complexes avec écriture en base (ex: Cycle de vie Utilisateur, Modulation complète).
- *La Configuration centralisée (`integration.env`)* :
  - Fini les variables en dur. Un seul fichier gère les UUIDs, IDP Admin, et IDP Agriculteur. (Protégeable via `.gitignore` pour la sécurité).

= Phase 3 : Bruno (Tests Autonomes en 2 minutes)
Comment s'assurer que les tests API ne plantent jamais la base de données CI à cause de doublons ?

- *La stratégie "Zéro Nettoyage" (Clean-First / Dynamic IDs)* :
  - Au lieu de lutter contre les contraintes d'unicité SQL avec des `DELETE` (souvent interdits par l'architecture métier), on contourne le problème.
  - Utilisation de scripts Javascript en "Pre-request" dans Bruno.
  - Génération de suffixes dynamiques (`Date.now()`) et d'UUIDs (`uuidv4()`) à la volée. Ex: `MOCK_COOP_1709028...`
- *Le Résultat* : Une suite de tests d'intégration complète (Création de coop, utilisateurs, liens, modulation) qui s'exécute de bout en bout en *moins de 2 minutes*, rejouable à l'infini sans jamais polluer la CI avec des erreurs 500.

= Synthèse des Bonnes Pratiques pour l'Équipe
1. *Ne cassez plus le cache Spring* : Toute nouvelle classe d'intégration doit hériter de `AbstractIntegrationTest` sans ajouter de `@MockBean` sauvages.
2. *L'API dicte sa loi* : Le Swagger/OpenAPI est la seule source de vérité (il nous a prouvé que les requêtes de `DELETE` utilisateur n'existaient pas côté client).
3. *Tests API = Données dynamiques* : Aucun test Bruno ne doit dépendre d'une donnée créée "en dur" lors d'un test précédent sans utiliser de variables d'environnement.

= Prochaines Étapes
- *Couverture* : Utiliser SonarQube pour combler les trous sur les tests purement unitaires (logique métier interne).
- *Automatisation* : Intégrer l'exécution CLI de Bruno (via `bru run`) directement dans le pipeline GitLab CI de `fs-core`.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Préparation de présentation ST50]