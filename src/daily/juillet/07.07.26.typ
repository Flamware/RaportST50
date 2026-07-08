#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(weight: "bold", size: 1.2em)[UTBM]
    #text(size: 0.9em)[Stage de Fin d'études (ST50)]
  ],
  align(right)[
    #text(weight: "bold", size: 1.1em)[Magellium]
    #text(size: 0.9em)[Projet : Farmstar Core Service]
    #text(size: 0.9em)[Date : 07 juillet 2026]
  ]
)
#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Refonte des Schémas de Sortie des Agents]
]

= Synthèse des travaux

== Refonte de l'architecture de sortie structurée des agents Analyzer

Objectif : généraliser et factoriser la définition des schémas Pydantic de sortie, jusqu'ici dupliqués et statiques par mode de tâche, afin de les rendre réutilisables et génériques pour tout type d'agent Analyzer du monorepo.

Réalisations techniques :

- *Base générique commune* : extraction d'une classe `AnalyzerAgent` factorisant les branches de sortie communes à tous les analyseurs (`needs_tools`, `needs_gatherer`, `report`), via des modèles Pydantic imbriqués et une union discriminée sur le champ `kind`.
- *Schéma de rapport dynamique* : remplacement des modèles de rapport statiques par une génération dynamique via `pydantic.create_model`, permettant d'adapter les champs du rapport selon le type de tâche (`AUDIT`, `EXPLAIN`, `CREATE`) sans dupliquer la logique d'union ni la structure de base.
- *Property overriding pattern* : mise en place d'un système de propriétés (`report_schema` / `output_schema`) permettant à chaque sous-agent (ex: `CodeAnalyzerAgent`) de ne surcharger que la partie spécifique du schéma (les sections du rapport), tout en héritant automatiquement de la logique d'union et de validation depuis la classe de base.
- *Validation défensive* : ajout d'une vérification explicite du type retourné par `report_schema` (doit être une sous-classe `BaseModel`), pour lever une erreur claire et exploitable en cas de mauvaise surcharge côté sous-classe, plutôt qu'une erreur `typing` cryptique.

Débogage :

- Correction d'un bug de correspondance de clés : le typage du champ `task_type` (enum `CodeTaskType`) ne correspondait pas aux clés du dictionnaire de sections (`str`), nécessitant l'ajout explicite de `.value` lors du lookup.

Valeur ajoutée de cette refonte :

- Réduction de la duplication de code entre les différents agents Analyzer (Gatherer/Analyzer/Solver partagent désormais le même pattern de base).

= Planning et perspectives

== Travaux à court terme

- Appliquer le même pattern générique (`report_schema`/`output_schema`) aux agents Gatherer et Solver, pour homogénéiser l'ensemble des sous-graphes.

#v(2em)
#line(length: 100%, stroke: 0.5pt)
#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]