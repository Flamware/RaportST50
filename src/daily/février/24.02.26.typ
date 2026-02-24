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
    #text(size: 0.9em)[Date : 24 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Finalisation de l'arborescence des tests]
]

== Travaux réalisés

La journée a été consacrée à création et à la réorganisation définitive des 139 requêtes de la collection Bruno. Le tri a permis de structurer la suite de tests en 26 répertoires distincts, facilitant ainsi la maintenance et l'exécution ciblée des scripts.

=== Structure finale de la collection

L'organisation validée des dossiers et sous-dossiers est la suivante :

- *Connector-Arvalis*
- *Connector-Fertiweb*
- *Core-Service*
  - *01-Identity-Security*
    - Audit
    - Cooperatives
    - Support
    - Users
  - *02-Agronomy & References*
    - Campaigns-Offers
    - Computation
    - Crops
    - Deliverables-Channels
    - Fertilization
    - Geography
    - Grasslands
    - Intermediate-Crops
    - Markets
    - Previous-Crops
    - Soils
  - *03-Parcel Management*
  - *04-Parcel Insights & Monitoring*
    - Agronomy
    - Details
- *environments*

== Analyse et plan d'action
- **Bilan** : La restructuration est achevée. (En attente de retour de Mathieu NIORD pour valider la pertinence de l'architecture choisie).
- **Prochaine étape** : Élaboration du script d'exécution automatique (? via le CLI Bruno ?) pour préparer l'intégration continue (CI).

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]