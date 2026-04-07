# Automatisation du Mapping & Validation

## Guide des Bonnes Pratiques (Magellium)

---

## La Problématique du Code "Boilerplate"

Dans un flux standard de mise à jour (`PATCH` / `PUT`), nous observons souvent une accumulation de code répétitif :

- Vérification systématique des nullités (`if (dto.getProp() != null)`).
- Appels manuels aux setters de l'entité.
- Divers autres validations "custom".

Cette approche génère des services "obèses", difficiles à tester unitairement et possiblement sujets aux régressions
lors de l'ajout de nouveaux champs.

## Solution : Le Framework GenericHydrator

Le `GenericHydrator` centralise la mécanique de transfert de données en utilisant la **réflexion Java** pour automatiser
les tâches de validation et de peuplement des entités.

### Workflow Procédural de Traitement

Le moteur fonctionne en deux phases distinctes :

- **Phase Statique (Initialisation) :** Lors du chargement du contexte Spring, l'hydrateur cartographie les types
  génériques (`T` et `D`). Il pré-indexe les champs physiques (`Field`) et les méthodes de validation spécifiques (
  `@ValidationMethod`) dans des Maps.
- **Phase Dynamique (Exécution) :**
    - _Itération_ : Le moteur parcourt les champs du DTO annotés `@ValidationField`.
    - _Validation_ : Il invoque la règle métier dédiée si elle existe.
    - _Mapping_ : Si la validation est un succès (retour `true`), la valeur est injectée dynamiquement dans l'entité
      source via `Field.set()`.

### Intérêts pour l'Équipe de Développement

- **Respect du principe DRY (Don't Repeat Yourself)** : La mécanique de mapping est codée une seule fois.

