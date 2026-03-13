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
    #text(size: 0.9em)[Date : 13/03/2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Déploiement de l'infrastructure de tests Cypress]
]

== Travaux réalisés
Mise en place complète du framework de tests E2E Cypress sur le Front Manager, incluant la configuration d'environnement et une première couverture de tests de non-régression (smoke tests).

=== Installation et Configuration de Cypress
- Initialisation du projet Cypress sur `fs-front-manager` (`cypress.config.ts`) avec définition des variables d'environnement (Base URL, IDs de test).
- Configuration de la structure des dossiers pour les tests (`cypress/e2e`), basé sur la même structure que les tests Bruno pour faciliter la transition.
- Création de test pour quelques pages clés du Front Manager (Dashboard, Gestion des utilisateurs) pour valider la configuration.

== Analyse et plan d'action
- *Bilan* : L'infrastructure de tests Cypress est opérationnelle en local, avec une première suite de tests de non-régression fonctionnelle. Cependant, l'intégration dans la pipeline CI/CD n'est pas encore réalisée.
- *Prochaines étapes* :
 - Completer les smoke tests pour couvrir l'ensemble des routes du Front Manager.
 - Intégrer l'exécution des tests Cypress dans la pipeline CI/CD de Farmstar.