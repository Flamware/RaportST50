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
    #text(size: 0.9em)[Date : 18 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tests d'Intégration et Audit de Performance]
]

== Travaux réalisés

L'objectif de la journée était de commencer les recherches d'outils de profiling pour diagnostiquer les lenteurs du build Maven et d'initier une réflexion sur les bonnes pratiques liées aux tests.


=== Audit de performance (Context Caching)
Mise en place d'un outil de mesure pour diagnostiquer les lenteurs du build Maven (durée locale > 17 minutes).
- **Intégration technologique** : Déploiement de `spring-test-profiler`. Résolution de l'incompatibilité avec Spring Boot 3 (Jakarta EE) par l'ajout manuel de l'initialiseur `ContextDiagnosticApplicationInitializer`.
- **Mesures clés** :
  - Un démarrage à froid du contexte de test prend environ 45 secondes.
  - Chaque contexte charge un monolithe de **2006 beans**.
  - Identification de ruptures de cache évitables (ex. l'annotation `@Import` spécifique dans `ModulationRequestTest` force le redémarrage complet de l'application).

=== Formalisation et documentation
- **Guide des bonnes pratiques** : Rédaction d'un document au format Typst synthétisant les standards d'implémentation et d'architecture des tests.
- **Rapport de profiling** : Création d'un rapport technique concis formalisant les conclusions et les métriques extraites du rapport HTML généré par le profiler.

=== Analyse et plan d'action
Échange technique avec Mathieu NIORD concernant l'impact potentiel d'une mutualisation des contextes.
- **Constat** : Réduire le nombre de contextes de 3 à 1 n'apportera qu'un gain marginal. Le véritable problème de performance est la charge d'initialisation (2006 beans) pour valider des logiques isolées.
- **Stratégie cible** :
  - À court terme : Créer une classe `AbstractIntegrationTest` pour unifier les configurations (`@MockBean`, `@Import`) et éviter les redémarrages inutiles de la JVM.
  - À moyen terme : Migrer vers une approche *Slice Testing* (`@WebMvcTest`) pour diviser le nombre de beans instanciés ou déporter les validations HTTP vers des collections de tests de bout en bout (E2E) via Bruno.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]