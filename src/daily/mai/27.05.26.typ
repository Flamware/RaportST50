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
    #text(size: 0.9em)[Date : 27 Mai 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tests des workflows, sous-graphe TEST_COVERAGE & Tweaks]
  ]

= Travaux réalisés

== Tweak de l'architecture du `TestGatherer`

*Problème* : La phase 1 recevait *tous* les messages du `ToolNode` (appels + résultats), polluant le contexte et perturbant la structuration de la réponse.

*Solution* : Découpler les contextes → phase 1 reçoit *uniquement les résultats*, phase 2 reçoit *calls + résultats*. Élimine le bruit sans perdre d'information.

*Résultats* :
- Performance : -50% (1min20 → 40s)
- Qualité : résultats plus pertinents, structuration respectée
- Traçabilité : logs plus clairs pour le debug
== Tweak du `TestAnalyzer`

*Problème* : Contexte trop riche (calls + résultats) et lecture automatique de *tous* les fichiers, même non pertinents → bruit et erreurs d'analyse.

*Solution* :
- Phase 1 reçoit uniquement les résultats, phase 2 reçoit le contexte complet
- Ne lire que les fichiers explicitement identifiés comme pertinents (déterminé via les skills + system prompt)

*Résultats* : Analyse plus ciblée, réduction du bruit et de l'overhead
== Tweak Général : séparation Skills ↔ Prompts

*Problème* : Prompts et skills étaient mélangés → conflits entre la logique de workflow et celle de structuration.

*Solution* : Clarifier les rôles
- **System prompts** : utilisés en phase 1 (structuration) pour guider la génération de réponses bien formatées
- **Skills** : utilisés en phase 2 (tool-calling) pour guider le workflow et la sélection des outils

*Résultats* : Workflows plus cohérents, réponses mieux structurées, workflow guidé et pertinent
*Bilan* : Architecture allégée, plus lisible et performante. Contextes séparés par phase + rôles clairs (skills/prompts) = pipelines plus robustes et maintenables.

*Prochaine étape* : Valider ces améliorations en conditions réelles sur le sous-graphe complet.


#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]