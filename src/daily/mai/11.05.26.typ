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
    #text(size: 0.9em)[Date : 11 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Optimisation du workflow de test coverage]
]

== Travaux réalisés

=== Affinement du sous-graphe "Test Coverage"
Amélioration de la flexibilité du pipeline de test pour supporter des requêtes partielles :
- **Execution conditionnelle** : Le pipeline n'exécute que les nœuds pertinents selon le type de requête. Les requêtes simples peuvent se terminer au niveau `Analyzer` sans passer par le `Solver` (génération de code).
- **Routage interne optimisé** : Réduction des appels coûteux au LLM en évitant les étapes superflues.

=== Focalisation sur la couche Service
- **Scope limité** : La collecte et l'analyse du code cible désormais uniquement la couche service (ex: `*Service.java`).
- **Gain de pertinence** : Réduit le bruit de l'analyse et améliore la qualité des rapports générés, en écartant les dépendances externes non pertinentes.
- **Filtrages appliqués** : Mise à jour du `Gatherer` pour utiliser des patterns de recherche spécifiques aux classes de service.

=== Système de rapports modulaire
Implémentation d'un système de génération de rapports granulaire :
- **Rapports par composant** : Chacun des trois nœuds (`Gatherer`, `Analyzer`, `Solver`) peut indépendamment générer ou non un rapport technique.
- **Déterminé par la tâche** : Un champ `generate_reports` dans l'état de la tâche (`TestCoverageState`) définit lesquels des trois rapports doivent être produits.
- **Flexibilité accrue** : Les utilisateurs peuvent demander un rapport du `Gatherer` uniquement (sources découvertes), ou du `Gatherer` + `Analyzer` (analyse sans code généré), etc.

== Analyse et plan d'action
- *Bilan* : Le workflow est à présent plus réactif et économe en ressources. La focalisation sur la couche service améliore significativement la pertinence des analyses. Le système de rapports modulaires offre une granularité inédite.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]

