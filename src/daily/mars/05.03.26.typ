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
    #text(size: 0.9em)[Date : 05/03/2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation de la CI et Présentation]
]

== Travaux réalisés
Aujourd'hui, j'ai préparé la fusion de mes optimisations de tests sur Git et finalisé les slides de ma présentation.

=== Préparation de la présentation
- Intégration des métriques finales dans les slides : réduction du temps de build CI de 70% (de 19:18 à 5:45) et hit rate du cache Spring à 99,5%.
- Reformatage de la présentation en suivant le template de Mathieu NIORD pour assurer une cohérence visuelle.
- Ajout d'une slide détaillée sur l'utilisation de l'outil Spring Test Profiler pour l'étape d'audit.
- Rédaction d'une slide de conclusion structurée en 4 axes (Diagnostic, Performance, Productivité, Standardisation) et correction d'un problème de numérotation de pages dans le masque du document.

=== Nettoyage et préparation de la branche Git
- Création d'une nouvelle branche de travail propre (`test-optimisations-standardisation`) basée sur la version la plus récente de `develop`.
- Utilisation de la commande `git cherry-pick b750099240^..e58efee970` pour transférer une vingtaine de commits ciblés (tests Bruno, AbstractIntegrationTest, configuration de la CI) vers la nouvelle branche.

=== Tests E2E & Smoke Tests
- Exécution d'une série de tests E2E sur la branche de travail pour valider la stabilité des optimisations avant la fusion.
- Correction de multiple erreur (500,400,403) sur les tests d'intégration en ajustant les rôles et les payloads des requêtes pour correspondre aux nouvelles configurations de sécurité et de validation.
- Correction de quelques requêtes sur le flow User n'ayant pas de ID dynamique. (coopId, parcelId etc.)

== Analyse et plan d'action
- *Bilan* : La présentation est prête. (en attente de validation par Mathieu NIORD)
- *Prochaine étape* : Faire le push de la branche , ouvrir la Merge Request et rédiger sa description technique.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]