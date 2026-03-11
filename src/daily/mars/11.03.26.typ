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
    #text(size: 0.9em)[Date : 11 Mars 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Migration et fiabilisation des tests d'intégration Bruno]
]

== Travaux réalisés
Migration technique des tests vers le format natif Bruno et nettoyage de l'infrastructure de test.

=== Migration et standardisation des tests
- Conversion des tests E2E et des smoke tests du format YAML vers le format `.bru`.
- Mise à jour du `CooperativeControllerTest` (structure des requêtes et chemins de fichiers).
- Ajout de scripts post-réponse pour la validation automatique des codes de statut HTTP.

=== Configuration technique et maintenance
- Nettoyage des URLs API : suppression du préfixe `/fs-core` et mise à jour des hôtes.
- Correction d'un typo dans l'URL du registre Docker pour l'image de la base de données.
- Merge de la branche `develop` pour synchroniser le travail sur la branche actuelle.

== Analyse et plan d'action
- *Bilan* : En local, les tests sont tous au vert. Sur la CI, ça bloque encore à cause de la détection d'environnement (erreurs 403) et de certains chemins de fichiers qui sont restés en absolu.
- *Prochaine étape* : Passer tous les chemins de fichiers en relatif et corriger le script de lancement pour l'agent CI.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]