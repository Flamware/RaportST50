#set text(
  font: "linux libertine",
  size: 10pt,
  lang: "fr"
)

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
  header: align(right, text(gray)[Étude Technique : Modèles de Nettoyage Locaux]),
)

#show heading: set block(above: 1.4em, below: 1em)

#align(center)[
  #text(size: 18pt, weight: "bold")[Sélection de Modèles pour la "Moulinette"]) \
  #v(0.2em)
  #text(size: 12pt, fill: blue.darken(30%))[SLM et SSM : Analyse des solutions d'anonymisation]
]

#v(1.5em)

== 1. Panorama des Modèles Envisageables

Pour le module de gommage des données, nous distinguons deux architectures : les **Transformers compressés (SLM)** pour leur précision, et les **State Space Models (SSM)** pour leur rapidité sur les gros volumes de code.

#table(
  columns: (1.2fr, 1fr, 1.5fr, 1fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { rgb("#edf2f7") },
  [*Modèle*], [*Type*], [*Usage Spécifique*], [*Consommation*],
  [Phi-4 Mini], [SLM], [Anonymisation logique complexe.], [~2.5 GB RAM],
  [Gemma 3 (2B)], [SLM#footnote[
*SLM*: Small Language Model, une version allégée d'un modèle de langage optimisé pour les tâches spécifiques
  ]], [Détection de PII et entités.], [~1.5 GB RAM],
  [Mamba-2], [SSM#footnote[
*SSM*: State Space Model, une architecture de modèle de langage optimisée pour les longues séquences
  ]], [Traitement de fichiers très longs.], [Faible (Linéaire)],
  [Jamba], [Hybride], [Analyse de dépôts complets.], [Moyenne],
)

== 2. Pourquoi choisir un SSM (State Space Model) ?

Si ta moulinette doit traiter des fichiers de code de plusieurs milliers de lignes, l'architecture **SSM** (comme *Mamba*) présente des avantages majeurs par rapport aux Transformers classiques :

- *Complexité Linéaire :* Contrairement aux Transformers (où le calcul augmente au carré de la longueur du texte), les SSM traitent 10 000 tokens presque aussi vite que 100.
- *Mémoire Fixe :* Le "cache" du modèle ne sature pas, ce qui évite les plantages sur les gros fichiers de données.
- *Vitesse d'inférence :* Idéal pour un prétraitement "transparent" qui ne doit pas ralentir le workflow du développeur.

== 3. Critères de sélection pour le gommage

Pour que la "moulinette" soit efficace, le modèle choisi doit exceller sur trois points :

1. Le respect strict du format : Le modèle ne doit pas inventer de code, mais uniquement remplacer les termes sensibles par des placeholders (ex: `IDENTIFIER_1`).
2. La fenêtre de contexte : Capacité à comprendre que `user_id` à la ligne 10 et à la ligne 500 désigne la même entité.
3. La Tokenisation : Le modèle doit avoir un tokenizer capable de lire du code sans créer trop de fragments (tokens) inutiles.

== 4. Comparatif de Performance (Inférence Locale)

#table(
  columns: (1.5fr, 1fr, 1fr),
  inset: 10pt,
  align: center,
  [*Critère*], [*SLM (ex: Phi-4)*], [*SSM (ex: Mamba)*],
  [Précision sémantique], [Excellent], [Très bon],
  [Vitesse (Long contexte)], [Moyenne], [Exceptionnelle],
  [Stabilité du format], [Très haute], [Haute],
  [Facilité de déploiement], [Simple (Ollama)], [Complexe (Librairies spécifiques)],
)

== 5. Recommandation Initiale (MVP)

#block(
  fill: luma(245),
  inset: 12pt,
  radius: 6pt,
  stroke: 0.5pt + silver,
)[
  Pour le prototype, la recommandation est d'utiliser **Gemma 3 (2B)** en mode quantizé (Q4_K_M).
  - *Pourquoi :* Il offre le meilleur compromis entre "intelligence" pour repérer les données sensibles et légèreté pour tourner en tâche de fond sur le poste du développeur.
]

#v(2em)
#line(length: 100%, stroke: 0.5pt + gray)
#align(center, text(size: 8pt, gray)[Note de travail - Optimisation du Processus de Développement - 2026])