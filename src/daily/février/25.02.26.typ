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
    #text(size: 0.9em)[Date : 25 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Checkstyle et tests d'API avec Bruno]
]

== Travaux réalisés

Aujourd'hui, j'ai travaillé sur deux sujets principaux : faire passer le build Maven en corrigeant les règles de formatage du code, et commencer à traduire certains tests d'intégration Java vers le client d'API Bruno.

=== 1. Corrections Checkstyle sur le build
Pour que l'intégration continue (CI) accepte le code du module `fs-core`, j'ai dû nettoyer plusieurs fichiers de test (notamment `AbstractIntegrationTest`) :
- Mise aux normes du nommage des constantes (majuscules).
- Remplacement des imports statiques qui étaient interdits par les règles du projet.
- Ajout de getters pour corriger les problèmes de visibilité des variables (passage en `private`/`protected`).
- Réduction de la taille des lignes et du nombre de méthodes pour respecter les limites de Checkstyle.

=== 2. Portage des tests MockMvc vers Bruno
Pour faciliter le test des APIs sans avoir à lancer toute la suite de tests Java, j'ai commencé à recréer nos appels HTTP directement dans Bruno (format YAML) :
- *Authentification (`UserController`) :* Création des requêtes pour tester le login (succès, mauvais identifiant, mauvais mot de passe). Il a fallu ajuster les chemins d'URL (`/fs-core`) et bien passer les paramètres pour éviter les erreurs 400.
- *Requêtes complexes (`NdoseController`) :* Traduction d'un test POST avec un corps en JSON. Ajout du header `Content-Type` pour régler les erreurs 415, et du header `X-Authenticated-User` pour passer la sécurité (erreur 403).
- *Scripts de test :* Ajout de petits scripts JavaScript dans Bruno pour vérifier automatiquement que le code HTTP retourné est le bon (200, 403, 404) et que les données JSON correspondent à ce qu'on attend.

== Analyse et plan d'action
- *Bilan* : Le build passe enfin l'étape Checkstyle sans erreur. Les premières requêtes Bruno fonctionnent bien et prouvent qu'on peut remplacer une partie des tests `MockMvc` pour rendre l'API plus facile à tester par l'équipe.
- *Prochaine étape* : Continuer le portage d'autres contrôleurs vers Bruno (par exemple l'ingestion de parcelles) et réfléchir à l'automatisation de ces tests.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]