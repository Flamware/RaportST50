= Retour d'Expérience (REX) : Optimisation sur `fs-core`

== Le transfert des tests d'intégration vers le E2E (Bruno)
Historiquement, de nombreux tests métier étaient exécutés via `@SpringBootTest`, provoquant des dépassements de mémoire (Out Of Memory) et des temps de CI de 20 à 30 minutes.

La stratégie mise en place a consisté à soulager la JVM en externalisant les validations d'API vers la CLI Bruno :
- *Structuration métier :* Découpage en 26 sous-domaines (Agronomie, Sols, Cultures...).
- *Variables d'environnement :* Séparation stricte des UUIDs statiques (`opencollection.yml`) et des URLs dynamiques (`environments/`).
- *Intégration Continue :* Ajout d'un _stage_ `validation` dans GitLab CI exécutant `bru run` sur un serveur distant, validant le contrat HATEOAS et la pagination en quelques secondes.

== Standardisation des assertions (Best Practices)
La fiabilisation de ces tests a mis en évidence des règles d'or pour éviter les _flaky tests_ (tests instables) :
1. *Ne jamais tester des compteurs absolus* : Préférer `expect(data.length).to.be.at.most(100)` à `expect(data.length).to.equal(4977)` (gestion de la pagination).
2. *Protection des listes vides* : Toujours vérifier `if (array.length > 0)` avant d'évaluer les propriétés des objets imbriqués.