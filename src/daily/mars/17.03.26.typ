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
    #text(size: 0.9em)[Date : 17 mars 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Finalisation des smoke tests Playwright]
]

== Travaux réalisés
J'ai terminé la rédaction de tous les smoke tests du front-manager en Playwright et corrigé les configurations d'authentification.

=== Finition des tests e2e Playwright
- Migration complète de 18 tests smoke Cypress vers Playwright (.spec.ts)
- Création de la structure `playwright/smoke/` avec 4 répertoires thématiques
- Implémentation de la fonction `injectAuthHeaders()` pour l'injection d'en-têtes custom (X-Authenticated-User, X-Authenticated-Roles)

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]