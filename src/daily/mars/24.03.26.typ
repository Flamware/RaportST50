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
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation des Hooks de pré-commit et pré-push, et fiabilisation des smokes tests de front-manager]
]

== Travaux réalisés
Ajourd'hui, j'ai travaillé sur la fiabilisation et l'optimisation des hooks (commit et push).
J'ai également travaillé les smokes tests de front-manager afin de les rendres non des api.

=== Hook de pré-push : Smoke tests
- Création d'un script runnant seulement les smokes tests des modules impactés par les modifications locales.
- Ajout de ce script dans le hook de pré-push pour renforcer la sécurité du code

=== Hook de pré-commit : Checkstyle Diff
- Création d'un script permettant de run Checkstyle uniquement sur les modifications locales.
(gain de temps significatif)

=== Mock des API de front-manager
- Utilisation de fichier .har pour mock les API de front-manager et rendre les smokes tests plus rapides et stables.

== Mise à jour de la CI
- Suppression du Job playwright test qui ne depend plus des differents services.
- Modification de front-manager --build afin de run les smokes tests en local et dans la CI.

== Analyse et plan d'action
- *Bilan* : Les hooks de pré-commit et pré-push ont été optimisés pour ne cibler que les modifications locales, ce qui a considérablement réduit le temps d'exécution. Les smokes tests de front-manager ont été rendus plus rapides et stables grâce au mock des API. La CI a été mise à jour pour refléter ces changements, avec la suppression du job Playwright et l'ajout des smokes tests dans le processus de build.
- *Prochaine étape* : Explorer differentes piste d'optimisation notamment concernant le job de build de front-manager qui reste assez long. Je vais notamment regarder du côté de l'optimisation du build et du caching des dépendances pour réduire le temps d'exécution.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]

Voici mes notes pour aujourd'hui :
[INSÈRE TES NOTES EN VRAC ICI]