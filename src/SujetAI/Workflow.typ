#set text(
  font: "linux libertine",
  size: 10pt,
  lang: "fr"
)

#set page(
  paper: "a4",
  margin: (x: 2cm, y: 2.5cm),
  header: align(right, text(gray)[Architecture Écosystème IA - Workflow]),
)

#show heading: set block(above: 1.4em, below: 1em)

#align(center)[
  #text(size: 18pt, weight: "bold")[Workflow de l'Assistant IA Multi-Agents] \
  #v(0.2em)
  #text(size: 12pt, fill: blue.darken(30%))[Cycle de vie d'une requête : Local vs Déporté]
]

#v(1.5em)

== 1. Vue d'ensemble du Pipeline
Le processus garantit que l'intelligence des agents (Cloud/Serveur) est consommée sans jamais exposer la propriété intellectuelle du projet Java/Angular.

#v(1em)
#table(
  columns: (1.2fr, 2fr, 1.2fr),
  inset: 8pt,
  align: horizon,
  fill: (x, y) => if y == 0 { rgb("#edf2f7") },
  [*Étape*], [*Action Technique*], [*Localisation*],
  [1. Intention], [Saisie du développeur (Prompt métier).], [IDE Local],
  [2. Contexte], [Récupération via RAG Local (Code source).], [Poste Dev],
  [3. Anonymisation], [Passage dans la moulinette AST (Mapping).], [Poste Dev],
  [4. Inférence], [Appel API sécurisé vers les Agents.], [Cloud / Proxy],
  [5. Reconstruction], [Ré-injection des noms via Mapping inverse.], [Poste Dev],
  [6. Validation], [Analyse de conformité (Standardisation).], [Poste Dev],
)

== 2. Détail des opérations critiques

=== A. Phase de "Sanitization" (Locale)
L'orchestrateur Python utilise **Tree-sitter** ou **JavaParser** pour transformer le code :
- Extraction des entités sensibles (Classes, Methods, Variables).
- Création d'une table de correspondance (HashMap) en mémoire volatile.
- Génération d'un code "technique pur" dépourvu de sens métier.

=== B. Dialogue avec les Agents (Déporté)
Les agents reçoivent une mission spécifique. Puisqu'ils sont déclarés en mode *Stateless*, ils ne conservent aucune donnée après la réponse.
- *Agent Backend :* Travaille sur le squelette Spring Boot anonymisé.
- *Agent Frontend :* Adapte les composants Angular en fonction des interfaces modifiées.

=== C. Phase de Standardisation (Locale)
Une fois le code reçu et "dé-moulé", l'assistant effectue une vérification finale :
- *Linter local :* Vérifie que les règles Checkstyle (Java) et ESLint (TS) sont respectées.
- *Check de Sécurité :* Vérifie l'absence de secrets ou de mauvaises pratiques (ex: injections SQL).

== 3. Schéma Logique de l'Orchestrateur

#v(1em)
#block(
  fill: luma(250),
  inset: 15pt,
  radius: 8pt,
  stroke: 1pt + silver,
)[
  *Flux de données :*
  `Développeur` $arrow.r$ `Orchestrateur (Python)` $arrow.r$ `AST Parser` $arrow.r$ #text(red)[`[ PROXY / CLOUD ]`] $arrow.r$ `IA (Agents)` \
  #v(0.5em)
  #align(right)[
    #text(blue)[`[ RETOUR ]`] $arrow.l$ `AST Inverse` $arrow.l$ `hydrateur Standards` $arrow.l$ `IDE`
  ]
]

== 4. Garanties de l'Assistant IA
- Confidentialité : Le modèle distant ne voit que des jetons (`Entity_A`, `Service_1`).
- Performance : L'usage de l'API permet d'utiliser des modèles de 175B+ paramètres.
- Conformité : L'humain valide chaque proposition via un système de "Diff" avant intégration.

#v(2em)
#line(length: 100%, stroke: 0.5pt + gray)
#text(size: 8pt, gray,)[
  Rapport technique - Optimisation et Standardisation via IA Assistive - 2026
]