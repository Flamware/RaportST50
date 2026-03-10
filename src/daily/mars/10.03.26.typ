#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
columns: (1fr, 1fr),
align(left)[
#text(weight: "bold", size: 1.2em)[UTBM]

#text(size: 0.9em)[Stage de Fin d'Études (ST50)]
],
align(right)[
#text(weight: "bold", size: 1.1em)[Magellium]

#text(size: 0.9em)[Projet : Farmstar Core Service]

#text(size: 0.9em)[Date : 10 mars 2026]
]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
#text(weight: "bold", size: 1.5em)[Fiche d'Activité : Migration des tests API et débug environnement local]
]

== Travaux réalisés
Aujourd'hui, l'objectif principal était de migrer les tests d'API du format YAML vers Bruno et de stabiliser l'environnement de test local.

=== Migration des tests vers Bruno

Restauration de fichiers de tests YAML supprimés lors d'une première passe de migration en utilisant git checkout sur un commit spécifique.
(problème de tests)

Développement et affinage d'un script Node.js (migrate.js) pour automatiser la conversion des fichiers YAML (format opencollection) en .bru.

Résolution de plusieurs erreurs de parsing strict de l'outil Bruno CLI : protection des valeurs de headers contenant du JSON (avec des quotes simples), correction de la syntaxe des blocs query et body:json.

Refactoring des scripts de tests : passage d'assertions répétées dans chaque fichier à des tests de validation globaux (Collection-wise tests) via collection.bru pour les smoke tests et tests d'intégration.

== Analyse et plan d'action

Bilan : Le script de conversion gère désormais correctement les requêtes complexes (POST avec corps JSON, headers avec caractères spéciaux, mapping des assertions). Les erreurs de parsing HCL de Bruno ont été identifiées et corrigées.

Prochaine étape : Terminer l'exécution et la validation des tests d'intégration migrés, et vérifier que l'ensemble de la collection passe correctement en environnement de CI avec les bons jeux de données.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]