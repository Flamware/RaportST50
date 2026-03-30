#set page(paper: "a4", margin: 2cm)
#set text(font: "Linux Libertine", size: 11pt)
#set heading(numbering: "1.")

#align(center)[
  #block(inset: 10pt, fill: rgb("#eeeeee"), radius: 5pt)[
    #text(size: 20pt, weight: "bold")[Architecture Logicielle : Entités, DTOs et Validation]
  ]
]

#v(1cm)

== Concept : Entité vs DTO
La séparation des responsabilités est cruciale pour maintenir une application sécurisée et évolutive.

#table(
  columns: (1fr, 2fr, 2fr),
  inset: 10pt,
  align: horizon,
  fill: (x, y) => if y == 0 { rgb("#cccccc") },
  [*Caractéristique*], [*Classe (Entité)*], [*DTO (Data Transfer Object)*],
  [**Rôle**], [Représente le modèle de données (Base de données).], [Transporte les données (API / Réseau).],
  [**Contenu**], [Données + Logique métier + Relations.], [Données simples (Propriétés "plates").],
  [**Sécurité**], [Contient des données sensibles (ex: Password).], [Masque les détails internes.],
  [**Cycle de vie**], [Persistant (stocké via ORM).], [Éphémère (temps d'une requête).]
)

== La Problématique : Le code "Boilerplate"
Dans une architecture classique, la mise à jour d'une entité à partir d'un DTO crée souvent des méthodes volumineuses :
- *Extraction* répétitive des champs du DTO.
- *Validation* manuelle avec de nombreuses conditions (`if != null`).
- *Mapping* (transfert de valeur) champ par champ.

C'est ce qu'on appelle le "syndrome de la méthode géante", difficile à maintenir et source d'erreurs.

== Solution : Le Generic Validator
Le `GenericValidator` est une couche d'abstraction utilisant la **réflexion Java** pour automatiser la synchronisation entre le DTO et l'Entité.


=== Objectifs principaux
- *Centralisation* : Les règles de validation sont regroupées dans une classe dédiée plutôt que dans le service métier.
- *Automatisation* : Le validateur parcourt dynamiquement les propriétés du DTO.
- *Découplage* : La logique de "comment mettre à jour" est séparée de la logique de "quoi mettre à jour".

=== Fonctionnement technique
1. **Introspection** : Le validateur identifie les champs communs entre `T` (Entité) et `D` (DTO).
2. **Validation conditionnelle** : Il cherche si une méthode spécifique de validation existe pour un champ donné (via des annotations comme `@Value`).
3. **Mapping automatique** : Si la validation est validée, la valeur est injectée directement dans l'entité source, supprimant ainsi les appels manuels aux `setters`.

#v(1cm)
#line(length: 100%, stroke: 0.5pt + gray)
#align(center)[
  #text(style: "italic", size: 9pt)[Résumé technique - Architecture Java & Pattern de Validation]
]