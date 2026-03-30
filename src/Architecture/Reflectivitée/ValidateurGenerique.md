# Industrialisation du Mapping & Validation

## Guide des Bonnes Pratiques (Magellium)

---

## Introduction : Entité vs DTO

| Critère           | Classe (Entité)                                 | DTO (Data Transfer Object)           |
|-------------------|------------------------------------------------|--------------------------------------|
| **Responsabilité**| Modèle de données métier (Base de données).    | Contrat d'échange API (JSON/Réseau). |
| **Contenu**       | Logique métier, relations JPA/Hibernate.       | Propriétés "plates".                |
| **Cycle de vie**  | Persistant et géré par l'EntityManager.        | Éphémère, lié à la requête HTTP.     |
| **Mapping**       | Destination finale du flux.                    | Source de données entrante.          |

## La Problématique du Code "Boilerplate"

Dans un flux standard de mise à jour (`PATCH` / `PUT`), nous observons souvent une accumulation de code répétitif :
- Vérification systématique des nullités (`if (dto.getProp() != null)`).
- Appels manuels aux setters de l'entité.
- Mélange de la logique de validation et de la logique de transfert.

Cette approche génère des services "obèses", difficiles à tester unitairement et possiblement sujets aux régressions lors de l'ajout de nouveaux champs.

## Solution : Le Framework GenericValidator

Le `GenericValidator` centralise la mécanique de transfert de données en utilisant la **réflexion Java** pour automatiser les tâches à faible valeur ajoutée.

### Workflow Procédural de Traitement

Le moteur fonctionne en deux phases distinctes :

- **Phase Statique (Initialisation) :** Lors du chargement du contexte Spring, le validateur cartographie les types génériques (`T` et `D`). Il pré-indexe les champs physiques (`Field`) et les méthodes de validation spécifiques (`@ValidationMethod`) dans des Maps.
- **Phase Dynamique (Exécution) :**
    - _Itération_ : Le moteur parcourt les champs du DTO annotés `@ValidationField`.
    - _Validation_ : Il invoque la règle métier dédiée si elle existe.
    - _Mapping_ : Si la validation est un succès (retour `true`), la valeur est injectée dynamiquement dans l'entité source via `Field.set()`.

### Intérêts pour l'Équipe de Développement

- **Respect du principe DRY (Don't Repeat Yourself)** : La mécanique de mapping est codée une seule fois.

