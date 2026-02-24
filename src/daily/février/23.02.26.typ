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
    #text(size: 0.9em)[Date : 23 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Structuration et implémentation des Smoke Tests]
]

== Travaux réalisés

L'objectif de cette période était d'organiser et de scripter la collection de requêtes de l'API REST `fs-core` sur l'outil Bruno, afin de constituer une suite de *Smoke Tests* robuste.

=== Restructuration de la collection Bruno
L'architecture de la collection a été organisée par domaines fonctionnels métier pour faciliter la maintenance et le diagnostic ciblé (*Fast-Fail*) :
- **01-Identity-Security** : Contrôle du périmètre d'accès de l'utilisateur.
- **02-Agronomy & References** : Ce dossier contient les données universelles du projet.
- **03-Parcel Management** : Ce dossier contient les données opérationnelles liées à la gestion des parcelles.

=== Implémentation des scripts de test
Les assertions ont été codées pour valider les contrats d'interface sans dépendre d'un jeu de données figé :
- **Validation de la structure** : Vérification systématique du standard *HATEOAS* (pagination, nœuds `_links` et conteneurs `_embedded`).
- **Robustesse d'environnement** : Gestion des listes paginées vides comme cas nominaux.

== Analyse et plan d'action
- **Caractère itératif de l'organisation** : L'architecture actuelle est temporaire. Compte tenu de ma connaissance encore partielle du projet, ces choix de structuration sont sujets à modification à mesure que ma compréhension des enjeux métiers s'affinera.
- **Couverture des tests** : Poursuivre l'implémentation des tests pour les endpoints restants de l'API.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

// --- Glossaire des termes techniques ---
#text(size: 0.9em, weight: "bold")[Glossaire technique :]
#text(size: 0.85em)[
  / Smoke Tests: Tests de "fumée" visant à vérifier la stabilité basique des services critiques après un build.
  / HATEOAS: Principe d'architecture REST où la réponse contient des liens permettant de découvrir les ressources liées.
  / Fast-Fail: Stratégie d'arrêt immédiat d'un processus dès qu'une erreur critique est détectée.
]

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]