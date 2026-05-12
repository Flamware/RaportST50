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
    #text(size: 0.9em)[Date : 12 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Évolution architecturale du système de supervision]
]

= Travaux réalisés

== Itération 2 : Affinement de l'orchestration du graphe

Amélioration majeure de l'architecture LangGraph en passant d'une architecture hiérarchique simple à un système superviseur intelligent avec routage dynamique :

=== Architecture précédente (11 mai)
- Routage statique via `Main Router` vers sous-graphes dédiés
- Pipeline linéaire : `Gatherer` → `Analyzer` → `Solver`
- Génération conditionnelle de rapports par nœud

=== Architecture nouvelle (12 mai)
- *Superviseur centralisé* : Classification intelligente basée sur le contenu du prompt
- *Détection dynamique* : Analyse de la présence de code ou gaps dans `state["messages"]`
- *Points d'entrée multiples* : Routage flexible permettant bypass de nœuds

== Points d'entrée stratégiques
Le système supporte désormais 4 niveaux d'entrée :

1. **Flux Standard** (SEARCH, EXPLAIN, AUDIT, CREATE, METRICS)
   - Entrée : `Gatherer` → pipeline complet
   - Cas d'usage : Aucune donnée fournie en prompt

2. **Flux Court-circuit** (EXPLAIN_WITH_CODE, AUDIT_WITH_CODE, QUICK_CREATE)
   - Entrée : `Analyzer` (bypass `Gatherer`)
   - Cas d'usage : Code ou gaps fournis directement

3. **Flux Ultra-rapide** (SOLVER_ONLY)
   - Entrée : `Solver` (bypass `Gatherer` + `Analyzer`)
   - Cas d'usage : Gap report déjà généré

4. **Métriques** (METRICS)
   - Entrée : `Gatherer` → `Analyzer` avec skill spécifique

== Communication bidirectionnelle
- `Analyzer` ↔ `Gatherer` : Feedback loop pour demander contexte supplémentaire
- Impact : Plus grande flexibilité et adaptation aux requêtes incomplètes

== Modularité accrue
- Superviseur : Détermination automatique du type de tâche
- Chaque agent charge son skill correspondant de manière indépendante
- Réduction des dépendances inter-nœuds

= Analyse et plan d'action

*Bilan* : L'architecture évolue vers un système où chaque requête prend le chemin optimal. La détection intelligente de contexte (code/gaps) réduira les appels coûteux et améliore la latence globale.

*Prochaine étape* : Implementer la detection de code/gaps dans le `Superviseur` pour activer le routage conditionnel. Tester avec des requêtes variées pour valider les différents flux d'exécution.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]

