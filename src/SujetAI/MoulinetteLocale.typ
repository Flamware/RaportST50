#set text(
  font: "linux libertine",
  size: 10pt,
  lang: "fr"
)

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
  header: align(right, text(gray)[Étude Comparative : Stratégies d'Anonymisation]),
)

#show heading: set block(above: 1.4em, below: 1em)

#align(center)[
  #text(size: 18pt, weight: "bold")[Analyse des Options de "Moulinette" Locale] \
  #v(0.2em)
  #text(size: 12pt, fill: blue.darken(30%))[Sécurisation des flux de données vers les LLMs]
]

#v(1.5em)

== 1. Analyse des Approches Techniques

=== A. Approche par Analyse Syntaxique (AST)
L'outil déconstruit le code en un arbre logique. Idéal pour le code source pur.
- *Mécanisme :* Parcours des nœuds `FunctionDef`, `ClassDef` et `Name`.
- *Force :* Garantie de couverture. Si un nom est dans l'AST#footnote[
*AST*: Abstract Syntax Tree, une représentation arborescente de la structure syntaxique du code
], il peut être renommé.
- *Faiblesse :* Perte potentielle de la sémantique métier (ex: `calculer_tva` devient `func_123`).

=== B. Reconnaissance d'Entités Nommées (NLP)
Utilisation de modèles de traitement du langage naturel (ex: Microsoft Presidio).
- *Mécanisme :* Détection statistique de patterns (Noms, Lieux, Organisations).
- *Force :* Très efficace pour les commentaires de code et la documentation.
- *Faiblesse :* Peut être sujet à des faux positifs/négatifs (incertitude statistique).

=== C. Détection par Patterns & Entropie
Approche "Brute" basée sur des expressions régulières (Regex).
- *Mécanisme :* Recherche de chaînes à haute entropie (Clés API, Hashs, Tokens).
- *Force :* Performance quasi-instantanée. Crucial pour la cybersécurité.
- *Faiblesse :* Ne comprend pas le contexte, uniquement le format.

=== D. Small Language Model (SLM) Local
Un mini-modèle (ex: Phi-3 ou Gemma 2B) qui réécrit le code.
- *Mécanisme :* Le modèle reçoit le code et le "neutralise" avant envoi au Cloud.
- *Force :* Préserve la logique métier en utilisant des synonymes génériques.
- *Faiblesse :* Consommation de ressources GPU/RAM locale non négligeable.

== 2. Tableau Comparatif des Solutions

#table(
  columns: (1.5fr, 1fr, 1fr, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { rgb("#eeeeee") },
  [*Méthode*], [*Performance*], [*Confidentialité*], [*Utilité IA*],
  [Analyse AST], [Élevée], [Maximale], [Moyenne],
  [NLP (Presidio)], [Moyenne], [Élevée], [Élevée],
  [Regex / Secrets], [Optimale], [Ciblée], [N/A],
  [SLM Local], [Faible], [Élevée], [Maximale],
)

#line(length: 100%, stroke: 0.5pt + gray)
#align(center, text(size: 8pt, gray)[Propriété Technique - Projet d'Optimisation SDLC 2026])