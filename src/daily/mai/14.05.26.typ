#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(weight: "bold", size: 1.2em)[UTBM] \
    #text(size: 0.9em)[Stage de Fin d'études (ST50)]
  ],
  align(right)[
    #text(weight: "bold", size: 1.1em)[Magellium] \
    #text(size: 0.9em)[Projet : Farmstar Core Service] \
    #text(size: 0.9em)[Date : 13 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tweak et Presentation du PoC]
]

= Travaux réalisés

== Petit tweak de l'architecture
- *Correction de bugs* : Ajustement du `TestSupervisor` pour corriger le routage ves 'End'.
== Tweak document BonnesPratiques.md
- *Ajout de sections* : Introduction d'une section "Installation" pour le hook de pré-commit/push et d'une petites sections spécifiant les commandes utiles.
== Présentation du PoC à l'équipe
- *PoweerPoint * : Création du template de présentation et structuration du contenu pour présenter l'architecture du PoC et les prochaines étapes du projet.
= Analyse et plan d'action

*Bilan* : Le template de présentation est prêt et le PoC est fonctionnel pour les cas d'usage de base. Cependant, il reste encore du travail pour implémenter la détection de code/gaps dans le `Superviseur` et activer le routage conditionnel vers les différentes taches.

*Prochaine étape* : Implémenter la détection de code/gaps dans le `Superviseur` pour activer le routage conditionnel. Tester avec des requêtes variées pour valider les différents flux d'exécution. Finaliser le sous-graphe `DOC_GENERATOR` en suivant ce nouveau standard. Finaliser la présentation et la partager avec l'équipe pour recueillir des feedbacks et ajuster le plan d'action en conséquence.


#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]