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

L'objectif de cette période était d'organiser et de scripter la collection de requêtes de l'API REST `fs-core` sur l'outil Bruno, afin de constituer une suite de Smoke Tests robuste.

=== Restructuration de la collection Bruno
L'architecture de la collection a été remaniée par domaines fonctionnels métier pour faciliter la maintenance et le diagnostic ciblé ("Fast-Fail") :
- **01-Identity-Security** : Contrôle du périmètre d'accès de l'utilisateur.
- **02-Agronomy & References** : Validation des dictionnaires de références (sols, cultures, PRO) et des moteurs de calcul (Azote, Phénologie, LAI).
- **03-Parcel Management** : Gestion des objets géospatiaux (GeoJSON) et des flux asynchrones du système (Exports, Journaux).

=== Implémentation des scripts de test
Les assertions de test ont été codées pour valider les contrats d'interface sans dépendre d'un jeu de données figé :
- **Validation de la structure** : Vérification systématique du standard HATEOAS (contrôle de la pagination, nœuds `_links` et conteneurs `_embedded`).
- **Robustesse d'environnement** : Acceptation des listes paginées vides comme cas nominaux pour garantir le succès des tests sur des environnements vierges.
- **Formats hétérogènes** : Validation du typage des données agronomiques et contrôle de la bonne réception des flux binaires (raster pour les couches cartographiques).

== Analyse et plan d'action
- **Caractère itératif de l'organisation** : Il est important de préciser que l'architecture actuelle de la collection n'est pas définitive. Ces choix ont été effectués de manière temporaire, en tenant compte de ma connaissance actuelle du projet. Ils seront très certainement amenés à évoluer à mesure que ma compréhension des enjeux métiers et techniques s'affinera.
- **Couverture des tests** : Poursuivre la création et l'implémentation des Smoke Tests pour les endpoints restants de l'API `fs-core`.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]