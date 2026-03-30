#set page(paper: "a4", margin: (x: 2cm, y: 2cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.")

#align(center)[
  #text(size: 18pt, weight: "bold")[Moteur de Validation et Mapping par Réflexion] \
  #text(size: 14pt)[Analyse procédurale et utilité architecturale]
]


= Le Workflow Procédural

Le fonctionnement du validateur générique se divise en deux phases distinctes : une phase de préparation à l'instanciation (statique du point de vue des requêtes) et une phase d'exécution (dynamique lors du traitement des données).

== Phase 1 : L'Initialisation (Au démarrage)

Lorsqu'un composant comme `StrategyValidator` est instancié par Spring, le constructeur parent `GenericValidator` est appelé. C'est ici que la réflexion prépare le terrain pour optimiser les futures exécutions.

+ *Résolution des types génériques :* Le validateur analyse sa propre signature de classe (`getGenericSuperclass()`) pour découvrir avec quelles classes il travaille (ex: `T = Strategy`, `D = StrategyPostDto`).
+ *Cartographie de la Source (Entité) :* Il scanne la classe cible (`T`) et stocke tous ses champs physiques dans un dictionnaire (`sourceFields`) où la clé est le nom exact du champ. Il force également l'accèsibilité (`setAccessible(true)`) pour contourner l'encapsulation.
+ *Cartographie du DTO :* Il scanne la classe d'entrée (`D`), filtre uniquement les champs annotés avec `@ValidationField`, et les stocke dans `dtoFields`. *Crucial :* La clé utilisée n'est pas le nom de la variable, mais la métadonnée `sourceField` (le lien logique).
+ *Cartographie des Règles Métier :* Il scanne ses propres méthodes (celles du `StrategyValidator`), filtre celles annotées avec `@ValidationMethod`, et les stocke dans `checkToExecute`. La clé est l'attribut `validationField` de l'annotation.

== Phase 2 : L'Exécution (`updateFromDto` / `constructFromDto`)

Lorsqu'une requête arrive et qu'on demande la mise à jour d'une entité à partir d'un DTO, le flux procédural suivant s'enclenche :

+ *Itération sur le mapping :* Le moteur boucle sur les entrées du dictionnaire `dtoFields`.
+ *Déclenchement du Validator (`checkField`) :* - Il cherche dans `checkToExecute` si une méthode correspond à la clé logique en cours (ex: "name").
  - Si une méthode est trouvée, elle est invoquée dynamiquement (`Method.invoke()`) en lui passant l'entité et le DTO.
  - Si la méthode lève une exception (ex: doublon détecté), le processus s'interrompt.
  - Si aucune méthode n'est trouvée (le bloc `catch` étouffe la `NullPointerException`), un contrôle de base (non-nullité du champ DTO) est effectué.
+ *Assignation de la valeur (Mapping) :* Si la validation passe, le moteur récupère le champ cible dans `sourceFields`, lit la valeur du DTO, et l'injecte dynamiquement dans l'entité (`Field.set()`).

== 1. Séparation des préoccupations (DRY & Découplage)
Sans la réflexion, il faudrait écrire manuellement chaque assignation (`entity.setName(dto.getName())`) et chaque appel de validation pour chaque DTO du système. Le `GenericValidator` centralise la mécanique "bête et méchante" du transfert de données. Les sous-classes (`StrategyValidator`) se concentrent *exclusivement* sur la logique métier intelligente.

== 2. Configuration par Métadonnées (Annotations)
La réflexion permet de créer un langage déclaratif. En utilisant `@ValidationField` et `@ValidationMethod`, le développeur décrit *l'intention* ("ce champ correspond à cette donnée et doit passer par ce test") plutôt que d'écrire *l'implémentation* impérative. Cela rend le code des DTOs et des validateurs extrêmement lisible et auto-documenté.

== 3. Souplesse d'évolution
Si un nouveau champ (ex: `description`) est ajouté à la stratégie, le développeur n'a pas à modifier l'algorithme principal. Il suffit de :
- Ajouter le champ dans le DTO avec `@ValidationField(sourceField = "description")`.
- Ajouter la méthode de contrôle annotée `@ValidationMethod(validationField = "description")`.
Le moteur générique le détectera et l'exécutera automatiquement grâce à la réflexion.

== 4. Résilience au Renommage
Puisque le pont entre le DTO, l'entité et la méthode de validation se fait via les chaînes de caractères définies dans les annotations, on peut renommer les variables Java ou les noms de méthodes (`validateName` en `checkNameValidity`) sans casser le processus de validation.