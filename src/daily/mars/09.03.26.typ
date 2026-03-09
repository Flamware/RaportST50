#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

#grid(
columns: (1fr, 1fr),
align(left)[
#text(weight: "bold", size: 1.2em)[UTBM]

#text(size: 0.9em)[Stage de Fin d'Études (ST50)]
],
align(right)[
#text(weight: "bold", size: 1.1em)[Magellium]

#text(size: 0.9em)[Projet : Farmstar Core Service]

#text(size: 0.9em)[Date : 09/03/2026]
]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
#text(weight: "bold", size: 1.5em)[Fiche d'Activité : Migration des tests API vers Bruno et mise à jour de la CI]
]

== Travaux réalisés
Aujourd'hui, j'ai basculé les anciens tests d'API vers le format natif de Bruno et corrigé le script de la CI pour qu'il les exécute correctement, ce qui clôture les objectifs d'intégration continue de mon rapport hebdomadaire.

=== Conversion des tests et environnements

Conversion en masse de plus de 195 fichiers .yml (intégration et smoke-tests) vers le format natif .bru à l'aide d'un script Node.js.

Génération des fichiers bruno.json pour rendre les dossiers reconnaissables par l'outil en ligne de commande.

Transformation des fichiers de configuration conf.yml en véritables environnements Bruno (local-var.bru et local-core.bru) pour gérer les variables et IDs complexes.

=== Fiabilisation du script de CI (bruno.sh)

Modification de la commande find pour exclure le dossier environments de la liste des tests à exécuter.

Implémentation d'une logique de détection automatique permettant de trouver et d'injecter le bon fichier d'environnement via le flag --env du CLI.

== Analyse et plan d'action

Bilan : Le script trouve maintenant les bonnes collections, charge les variables correctement et n'échoue plus sur des erreurs d'arguments. L'historique Git a été conservé propre via un commit --amend groupant tests et script.

Prochaine étape : Lancer le pipeline sur GitLab CI pour valider l'exécution en conditions réelles.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]