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
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Ajout Hook Pre-commit/push]
]

== Travaux réalisés


=== Update de la documentation readme/wiki
- Ajout dans readme de la section "SonarQube for Ide" pour mentionner les bonnes pratiques à avoir lors d'un commit.
- Ajout dans le wiki "git" de la section "Installation de SonarLint" pour expliquer comment installer et configurer SonarLint dans les IDEs.

=== Upadate de la documentation "Bonne Pratiques"
- Ajout d'une section Smoke Tests et tests E2E pour le FrontEnd. (outil Playwright)

=== Ajout hook de pré-push
- Création du script sécumatrix-local-diff-check permettant de vérifier que les modifications locales ne font pas sauter les règles de la security matrix.
- Ajout du hook de pré-push dans ".pre-commit-config.yaml" pour exécuter le script de vérification avant chaque push.

== Analyse et plan d'action
- *Bilan* : La documentation a été mise à jour pour inclure les nouvelles sections sur SonarLint et les bonnes pratiques de test. Le hook de pré-push a été ajouté pour renforcer la sécurité du code avant qu'il ne soit poussé dans le dépôt.
- *Prochaine étape* : Ajouter au hook de pré-push le run de smoke-tests concernant les modules impactés par les modifications locales. Cela permettra de détecter les problèmes d'intégration plus tôt dans le processus de développement.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]

