#set page(paper: "a4", margin: (x: 2cm, y: 2cm))
#set text(font: "Linux Libertine", size: 10pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- HEADER ---
#grid(
  columns: (1fr, 1fr),
  align(left)[#text(size: 8pt, gray)[Guide des Bonnes Pratiques]],
  align(right)[#text(size: 8pt, gray)[Magellium]]
)
#line(length: 100%, stroke: 0.5pt + gray)

#v(1cm)

#align(center)[
  #block(inset: 15pt, fill: rgb("#f4f4f4"), radius: 4pt, stroke: rgb("#dddddd"))[
    #text(size: 18pt, weight: "bold")[Mapping & Validation] \
    #v(0.5em)
    #text(size: 12pt, style: "italic", gray)[Pattern GenericHydrator : Réflexivité au service du Clean Code]
  ]
]

#v(1.5cm)


== La Problématique du Code "Boilerplate"
Dans un flux standard de mise à jour (`PATCH` / `PUT`), nous observons souvent une accumulation de code répétitif :
- Vérification systématique des nullités (`if (dto.getProp() != null)`).
- Appels manuels aux setters de l'entité.
- Mélange de la logique de validation et de la logique de transfert.

Cette approche génère des services "obèses", difficiles à tester unitairement et possiblement sujets aux régressions lors de l'ajout de nouveaux champs.
Manque de lisibilité. (plus de codes -> plus de complexité cognitive)
== Solution : Le Framework GenericHydrator
Le `GenericHydrator` centralise la mécanique de transfert de données en utilisant la **réflexion Java** pour automatiser les tâches à faible valeur ajoutée.

=== Workflow Procédural de Traitement
Le moteur fonctionne en deux phases distinctes :

+ #strong[Phase Statique (Initialisation) :] Lors du chargement du contexte Spring, le hydrateur cartographie les types génériques (`T` et `D`). Il pré-indexe les champs physiques (`Field`) et les méthodes de validation spécifiques (`@ValidationMethod`) dans des Maps.
+ #strong[Phase Dynamique (Exécution) :] 
  - #underline[Itération] : Le moteur parcourt les champs du DTO annotés `@ValidationField`.
  - #underline[Validation] : Il invoque la règle métier dédiée si elle existe.
  - #underline[Mapping] : Si la validation est un succès (retour `true`), la valeur est injectée dynamiquement dans l'entité source via `Field.set()`.

=== Intérêts pour l'Équipe de Développement
- **Respect du principe DRY (Don't Repeat Yourself)** : La mécanique de mapping est codée une seule fois.

