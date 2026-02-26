// --- Configuration du document ---
#set page(
  paper: "a4",
  margin: (x: 2.5cm, y: 2.5cm),
  numbering: "1",
)
#set text(
  font: "New Computer Modern",
  lang: "fr",
  size: 11pt
)
#set par(justify: true)
#set heading(numbering: "1.1.")

// --- Macros pour le style ---
#let code-block(body) = block(
  fill: luma(240),
  inset: 10pt,
  radius: 4pt,
  width: 100%,
  body
)

#let note(body) = block(
  fill: rgb("#e8f4fd"),
  stroke: (left: 2pt + blue),
  inset: 10pt,
  width: 100%,
  [*Note technique :* #body]
)
#import "@preview/codelst:2.0.2": sourcecode

// --- Page de Titre ---
#align(center + horizon)[
  #text(size: 20pt, weight: "bold")[Standardisation et Optimisation\ de la Stratégie de Test]

  #v(1cm)
  #text(size: 14pt)[Projet Farmstar 4 - Stack Java Spring Boot]

  #v(2cm)
  *Auteur :* Étudiant Ingénieur 5A \
  *Date :* #datetime.today().display("[day] [month repr:long] [year]")
]
#pagebreak()

// --- Contenu ---

= Introduction et État des Lieux

Sur le projet Farmstar 4, l'utilisation systématique de tests lourds (via `@SpringBootTest`) a entraîné une forte perte de performance lors de l'intégration continue (CI).

Le contexte Spring et l'infrastructure sous-jacente sont fréquemment rechargés entre les classes de tests, créant une "taxe de démarrage" qui allonge inutilement la boucle de feedback des développeurs. Ce document définit la nouvelle doctrine de test pour fiabiliser, alléger et accélérer nos développements.

= La Nouvelle Doctrine : L'Arbre de Décision

Afin d'optimiser le rapport coût/bénéfice et de garantir une exécution rapide, chaque nouveau test doit suivre cet arbre de décision formel :

- *Je teste un calcul complexe, une règle métier ou un Mapper ?* \
  $=>$ *Test Unitaire Pur (Mockito).* Exécution en millisecondes, aucune dépendance au framework Spring.
- *Je teste une requête en base de données ou un service d'infrastructure ?* \
  $=>$ *Test d'Intégration Mutualisé.* Héritage obligatoire de la classe abstraite pour réutiliser le contexte Spring existant.
- *Je vérifie le contrat d'interface (Statut HTTP, format JSON, Sécurité) d'une API ?* \
  $=>$ *Smoke Test / Validation d'API (Bruno).* Délégation de la validation (disponibilité et contrats) hors du code Java pour ne pas alourdir la compilation.

= Les Templates de Code (Standards de l'équipe)

== Le Test Unitaire Pur (80% des cas)
*Objectif :* Isolation totale. Le contexte Spring *ne doit pas* être chargé.

#sourcecode[```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

@ExtendWith(MockitoExtension.class) // AUCUN @SpringBootTest ici
class ParcelRecommendationServiceTest {

    @Mock
    private ParcelRepository repository; // Dépendance simulée par Mockito

    @InjectMocks
    private ParcelRecommendationService service; // Classe réelle à tester

    @Test
    void shouldCalculateRecommendation() {
        // Arrange, Act, Assert (Exécution ultra rapide, < 50ms)
    }
}
```]

== Le Test d'Intégration Mutualisé (20% des cas)
*Objectif :* Éviter le rechargement du contexte (`ApplicationContext`). Tous les tests d'intégration partagent désormais la même configuration d'infrastructure gelée.

#sourcecode[```java
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;

// On hérite de la classe mère, on ne déclare PLUS de @MockBean spécifiques ici
class ParcelRepositoryIntegrationTest extends AbstractIntegrationTest {

    @Autowired
    private ParcelRepository repository; // Vraie interaction avec la BDD

    @Test
    void shouldSaveAndRetrieveParcel() {
        // Le contexte Spring est déjà "chaud", le test s'exécute immédiatement.
    }
}
```]

#note[
  L'utilisation de la classe `AbstractIntegrationTest` permet de geler l'arbre des dépendances. Toute altération du contexte dans une classe fille (ex: ajout d'un `@MockBean` ou d'un `@DirtiesContext`) cassera le cache Spring et forcera un redémarrage complet, pénalisant toute la suite de tests.
]

== Validation de surface (Smoke Testing avec Bruno)
*Périmètre actuel :* Validation de la disponibilité et des contrats d'interface (139 Smoke Tests existants). \
*Outil :* Bruno (Collections versionnées).

La stratégie adoptée consiste à utiliser Bruno comme premier filet de sécurité. Ces tests garantissent instantanément que les endpoints répondent et respectent le format JSON attendu, sans lancer de contexte Java.

*Roadmap et bonnes pratiques :*
1. Lors du développement d'un nouveau contrôleur, il est désormais demandé d'ajouter les requêtes correspondantes dans la collection Bruno du projet.
2. À moyen terme, l'objectif est de remplacer une grande partie des tests d'intégration Java (historiquement réalisés avec `MockMvc`) par des tests Bruno. Cela permettra de décharger le monolithe au profit de tests de type "boîte noire", plus rapides et totalement indépendants du code métier.

= Conclusion et Perspectives

L'application stricte de ces templates permet de transformer l'environnement de test en une constante prévisible et rapide.

Pour les mois à venir, l'évolution technique majeure consistera à intégrer des *Testcontainers* (ex: images éphémères de PostgreSQL ou Fake-GCS) directement dans l'`AbstractIntegrationTest`. Cela permettra aux tests d'intégration de monter et démonter leur propre infrastructure à la volée, supprimant ainsi toute dépendance à l'état des conteneurs locaux (Docker Compose) de la machine du développeur.