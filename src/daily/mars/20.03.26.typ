
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
    #text(size: 0.9em)[Date : #datetime.today().display()]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation des tests unitaires et d'intégration - Standardisation des pratiques de test
]

== Travaux réalisés

=== Presentation Optimisations et Standardisation des Tests
- J'ai éffectué une présentation sur les optimisations possibles pour les tests unitaires et d'intégration, ainsi que sur la standardisation des pratiques de test au sein de l'équipe. J'ai abordé les points suivants :
  - Les bonnes pratiques pour maintenir des tests rapides et fiables.
  - L'importance de la séparation entre tests unitaires et d'intégration.
  - Les outils et frameworks recommandés pour chaque type de test.
  - Des exemples concrets de refactoring de tests pour améliorer leur performance.

== Analyse et plan d'action
- *Bilan* : La présentation a été bien reçue par l'équipe, avec des discussions constructives sur les défis actuels et les solutions possibles pour améliorer la qualité et la performance des tests.
- *Prochaine étape* :
    - Application de SonarLint dans les pre-commit hooks pour renforcer la qualité du code avant même qu'il n'entre dans la pipeline CI/CD. Je vais également travailler sur la documentation des standards de test pour assurer une adoption uniforme au sein de l'équipe.
    - Lancement de fs-core lors du job smoke-test de front-manager pour détecter les problèmes d'intégration plus tôt dans le processus de développement.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]

