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
    #text(size: 0.9em)[Date : 16 mars 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tests de fumée frontend et comparatif Playwright]
]

== Travaux réalisés
Aujourd'hui, j'ai implémenté Playwright pour nos tests de fumée (Smoke Tests) frontend et tenter de régler des blocages réseau et j'ai mesuré concrètement les gains de performance face à Cypress.

=== Implémentation de Playwright et gestion du réseau
- Configuration du framework (`playwright.config.ts`) et migration d'une suite de 18 tests couvrant les vues principales (Identity, Agronomy, Parcel Management, Monitoring).
- Création d'un intercepteur réseau (`utils.ts`) pour injecter les headers d'authentification (`x-authenticated-user`, `x-authenticated-roles`) de manière dynamique.
- Résolution d'un problème de requêtes bloquées (CORS / erreur 403) en configurant Playwright pour ignorer les requêtes `OPTIONS` (Preflight) lors de l'injection des headers, fonctionnel pour l'instant uniquement sur chromium.

=== Comparatif de performance : Cypress vs Playwright
- Lancement de la suite de 18 tests dans les deux environnements pour comparer les temps d'exécution (headless, charge CPU, 1 seul worker).
- Le temps d'exécution global est passé de 5m 28s (Cypress) à 1m 45s (Playwright), avec un taux de succès qui passe à 100% (Cypress échouait sur un test à cause de délais).
- La charge processeur (User CPU time) a fondu de 1m 38s à 8,5s, confirmant l'avantage de l'architecture native de Playwright par rapport au système de proxy de Cypress.

== Analyse et plan d'action
- *Bilan* : Playwright ne contourne pas (encore) nos problèmes de blocage réseau avec WebKit et Firefox /CORS mais divise le temps d'exécution par 3. C'est exactement ce qu'il nous faut pour réduire le temps de feedback développeur.
- *Prochaine étape* : Nettoyer l'ancienne configuration et intégrer cette suite de tests ultra-rapide directement dans le hook Git (pre-push) pour bloquer les régressions avant la CI.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]