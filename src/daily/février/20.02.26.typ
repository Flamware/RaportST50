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
    #text(size: 0.9em)[Date : 20 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Finalisation du Cache Spring, Centralisation de la Sécurité et Smoke Tests]
]

== Travaux réalisés

L'objectif de la journée était de finaliser la mutualisation des contextes de tests, de centraliser la gestion des identités de test et d'initier la mise en place de Smoke Tests via Bruno.

=== Optimisation finale du cache Spring
Élimination du dernier "Cache Miss" (`context-1`) pour stabiliser le temps de build.
- **Suppression des configurations locales** : Retrait des annotations `@Configuration` et `@Import` statiques (ex: `IrrigationPeriodTestConfiguration`) dans les tests d'intégration, évitant la recréation inutile de beans.
- **Unification du contexte** : Remontée des composants transverses (`StorageService`, `InterserviceFactory`) dans `AbstractIntegrationTest`.
- **Performance** : Stabilisation du temps d'exécution à **3,0 minutes** avec un *Cache Hit Rate* de **99,5 %**.

=== Centralisation de la Sécurité (SecurityTestUtils)
Création d'une classe utilitaire dédiée, `SecurityTestUtils`, pour harmoniser l'authentification à travers toute la suite de tests.
- **Définition des constantes** : Centralisation des UUIDs (`ADMIN_IDP`, `USER_ID`, etc.) et des listes de rôles par profil (Admin, Coordinator, Farmer).
- **Abstractions HTTP** : Implémentation de la méthode `createAuthHeaders` pour générer dynamiquement les en-têtes `x-authenticated-user` et `x-authenticated-roles` de manière cohérente avec le `ServiceAccountManager`.
- **Assertions de sécurité** : Ajout de méthodes de validation pour les flux asynchrones (`assertPubSubAuthentication`).

=== Résolution d'instabilités techniques
- **Contexte Asynchrone** : Sécurisation des Sinks PubSub (`PdfCreationSink`) en forçant l'authentification via `serviceAccountManager.setPubsubAuthentication` pour éviter les `AccessDeniedException`.


=== Analyse et plan d'action
- **Exécution Bruno** : Valider les premiers appels réels sur les endpoints.
- **Couverture** : Utiliser les métriques SonarQube pour prioriser les prochains tests unitaires à développer via le pattern.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]