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
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation du Cache Spring et Refactoring des Tests]
]

== Travaux réalisés

L'objectif de la journée était de valider la stratégie d'unification des contextes Spring initiée la veille, de nettoyer les configurations conflictuelles et de résoudre les problématiques de sécurité liées à ce refactoring.

=== Validation de l'optimisation du cache Spring
Analyse du nouveau rapport généré par `spring-test-profiler` confirmant le succès de la mutualisation des contextes.
- **Métriques clés** : Réduction du temps de build de 17 minutes à **3,6 minutes**.
- **Stabilité du cache** : Atteinte d'un *Cache Hit Rate* de 99,4 % (1001 hits pour 6 misses).
- **Unification** : 14 classes de tests tournent désormais sur un contexte unique (`context-0`) contenant 2011 beans, validant l'approche par classe mère (`AbstractIntegrationTest`).

=== Refactoring architectural et nettoyage des configurations
Migration des classes de tests (`ParcelControllerTest`, `InputToolsParcelTest`, `InputToolsCollectProInputTest`) vers la nouvelle architecture centralisée.
- **Élimination des redondances** : Suppression des annotations écrasant le contexte hérité (annotations `@SpringBootTest` redondantes, `@ContextConfiguration`).
- **Suppression des destructeurs de cache** : Retrait des attributs `webEnvironment = RANDOM_PORT` et de l'annotation `@DirtiesContext` qui forçaient le redémarrage du serveur web et de la JVM.
- **Centralisation** : Déplacement des déclarations de mocks partagés (`@MockBean`, `@SpyBean`) directement dans la classe `AbstractIntegrationTest`.

=== Résolution des blocages de sécurité (Spring Security)
Analyse et correction des exceptions `AccessDeniedException` levées par le `RepositoryFilterAdvisor` lors de l'exécution sur le contexte global.
- **Diagnostic** : L'annotation `@WithMockAdmin` s'est avérée insuffisante ou conflictuelle avec le cycle de vie `PER_CLASS` et la base de données de test (erreur `Unknown idp identifier`).
- **Correction** : Implémentation d'une méthode d'authentification manuelle (`setAuth`) centralisée dans la classe mère, forçant l'injection d'un `PreAuthenticatedAuthenticationToken` avec un UUID (`IDP`) existant en base de données et les autorités requises (`backofficeUser`, `operator`, etc.).

=== Analyse et plan d'action
- **Profiling CPU** : Utilisation du **Flame Graph** (IntelliJ Profiler) pour analyser les "hotspots" sur les 3,6 minutes d'exécution restantes.
- **Stratégie cible** :
  - Poursuivre l'analyse des méthodes les plus lourdes pour cibler l'optimisation.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]