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
    #text(size: 0.9em)[Date : 26 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tests des workflows, sous-graphe TEST_COVERAGE & Tweaks]
  ]

= Travaux réalisés

== Test de la sous-tache `Audit`
Validation du flux `Audit` du sous-graphe `TEST_COVERAGE`. Le système a correctement identifié l'absence de code, puis a utilisé `Gatherer` pour récupérer les fichiers pertinents et `Analyzer` pour générer l'analyse. Résultat : ✓ fonctionnel.

== Tweak du `TestGatherer`
Amélioration de la logique de recherche des fichiers de tests associés. Ajustement du prompt system pour mieux analyser les dépendances. Résultat : identification plus exhaustive des fichiers.

== Tweak du `TestAnalyzerOutput`
Restructuration de l'output : passage d'une structure simple à une structure typée `Dict[typeTask, Dict[str, Any]]` avec champs spécifiques. Résultat : réponses mieux structurées et respectées par le LLM.

*Bilan* : La sous-tache `Audit` fonctionne correctement. Les tweaks du `TestGatherer` et du `TestAnalyzerOutput` améliorent la pertinence des résultats et la structuration des réponses, rendant le pipeline plus fiable.

*Prochaine étape* : Tester en conditions réelles avec des cas d'usage plus complexes et affiner si besoin.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]