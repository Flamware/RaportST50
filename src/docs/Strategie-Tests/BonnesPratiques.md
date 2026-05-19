Standardisation des Tests Logiciels en Architecture Microservices
---

## 1. Introduction

Ce document définit les standards à appliquer pour réduire la boucle de feedback (Feedback Loop)[1] et optimiser la consommation des ressources.

[1]: **Feedback Loop :** Délai entre l'écriture du code et le retour d'information du test. Plus ce délai est court, plus la correction est efficace.

---

## 2. La Pyramide des Tests

Nous adoptons le modèle de la pyramide des tests.

### 2.1. Répartition Cible

- **Unitaires (70%) :** Socle de la stabilité. Exécution la plus rapide. (de l'ordre de la milliseconde)
- **Intégration (20%) :** Validation des interfaces internes et configurations (BDD, mutualisation Spring). Exécution lente. (de l'ordre de la seconde, dépend de la logique métier)
- **E2E / Smoke (10%) :** Validation des flux critiques, répartie entre API backend (Bruno) et UI frontend (Playwright).

---

## 3. Implémentation Technique

### 3.1. Tests Unitaires (Unit Tests)

**Rôle et Utilité :**  
Validation de la logique algorithmique interne de manière isolée. L'exécution doit s'effectuer en quelques millisecondes.

**Périmètre (Algorithme Primaires) :**  
Algorithmes purs et règles de calcul isolées. Ces functions se suffisent à elles-mêmes. Leur scope se limite aux paramètres fournis et leurs corps.

**Méthode (Données Primaires) :**  
Privilégier l'injection de données brutes via des générateurs statiques ou des "Data Providers" (ex: tests paramétrés) pour valider de multiples scénarios métier rapidemment.
Les data providers doivent être composés de données primaires.

**Contrainte :**  
Isolation totale. Interdiction stricte de charger un contexte Spring.

```java
// MAUVAISE PRATIQUE : SpringBootTest (Lourd et inadapté pour du calcul pur)
@SpringBootTest // Charge tout le contexte applicatif inutilement
class DiscountCalculatorTest {
    @Autowired private DiscountCalculator calculator;

    @Test
    void calculate_nominal() {
        // ...
    }
}

// PRATIQUE ACCEPTABLE : Isolation pure avec Mockito (si dépendances)
@ExtendWith(MockitoExtension.class)
class OrderValidationServiceTest {
    @Mock private UserRepository repository;
    @InjectMocks private OrderValidationService service;

    @Test
    void verify_ShouldReturnTrue() {
        when(repository.existsByStatus("ACTIVE")).thenReturn(true);
        assertTrue(service.verify("ACTIVE"));
    }
}

// BONNE PRATIQUE : "Data-Driven Testing" pour les classes primaires
@ParameterizedTest(name = "Statut: {0}, Montant: {1}€ => Remise attendue: {2}€")
@CsvSource({
        "PREMIUM,  100.0,  20.0", // Injection des données primaires
        "STANDARD, 200.0,  10.0",
        "GUEST,     50.0,   0.0"
})
void calculateDiscount_ShouldReturnCorrectValue(String status, double amount, double expected) {
    // Action sur une classe primaire pure
    double result = DiscountCalculator.calculate(status, amount);

    // Vérification instantanée
    assertEquals(expected, result);
}

// BONNE PRATIQUE (ALTERNATIVE) : via DataProvider
private static Object[][] discountCalculatorDataProvider(){
    return new Object[][]{
            {"PREMIUM",  100.0,  20.0},
            {"STANDARD", 200.0,  10.0},
            {"GUEST",     50.0,   0.0}
    };
}

@ParameterizedTest(name = "Statut: {0}, Montant: {1}€ => Remise attendue: {2}€")
@MethodSource("discountCalculatorDataProvider")
void calculateDiscount_ShouldReturnCorrectValue(String status, double amount, double expected) {
    // Action sur une classe primaire pure
    double result = DiscountCalculator.calculate(status, amount);

    // Vérification instantanée
    assertEquals(expected, result);
}
```

### 3.2. Tests d'Intégration (Integration Tests)

**Rôle et Utilité :**  
Vérification des interactions entre les composants logiciels internes et l'infrastructure (Base de données, connecteurs externes).

**Attention au Périmètre :**  
L'utilisation de `MockMvc` pour tester les contrôleurs et les flux HTTP est désormais proscrite en Java. Ces validations sont entièrement déléguées à l'outil Bruno. Les tests d'intégration Java se concentrent exclusivement sur les couches inférieures (Services et Repositories).

**Contrainte :**  
Utilisation fortement conseillée du contexte mutualisé (voir section "Performance et Context Caching") pour éviter la "taxe de démarrage" (Cold Start) qui allongeait le temps de build.

### 3.3. Tests API avec Bruno/Postman (Smoke Tests & E2E)

**Rôle et Utilité :**  
Validation du système du point de vue d'un client externe en condition réelle (boîte noire). C'est le remplacement complet des anciens tests `MockMvc`. L'objectif est de s'affranchir du contexte Java (JVM) pour valider les contrats HTTP et les scénarios métiers de bout en bout.

Nous divisons ces tests en deux catégories distinctes, s'exécutant sur des environnements isolés via Bruno/Postman.

#### 3.3.1. Les Smoke Tests (Tests de Surface)

**Objectif :**  
Vérifier instantanément la disponibilité des endpoints et la conformité des contrats de données sans altérer l'état de la base de données.

**Périmètre :**  
Essentiellement des requêtes `GET` classées par domaines (ex: `01-Identity-Security`, `02-XXXX`).

**Environnement cible :** `admin, user etc.`

#### 3.3.2. Les Tests d'Intégration End-to-End (E2E)

**Objectif :**  
Valider des cycles de vie complets (ex: Création d'une entitée "contrat" → Ajout d'un utilisateur → Login).

**Environnement cible :** `integration` (Jeu de données isolé).

**Stratégie "Zéro-Nettoyage" (Clean-First) :**  
Pour garantir la rejouabilité infinie sur la CI sans générer de conflits en base de données (ex: erreurs `Duplicate Key`), chaque exécution doit générer ses propres identifiants uniques via les scripts `Pre Request` de Bruno/Postman.

```js
// PRATIQUE REQUISE : Script Pre-Request Bruno/Postman (Génération dynamique)
const uuid = require("uuid");
bru.setVar("dynamicEmail", `user-${Date.now()}@mail.fr`);
bru.setVar("contractId", uuid.v4());
```

```js
// PRATIQUE REQUISE : Requête et Assertions robustes
post {
  url: {{baseUrl}}/api/users
  body: json {
    {
      "email": "{{dynamicEmail}}",
      "contractId": "{{contractId}}"
    }
  }
}

assert {
  res.status: in [200, 201]
  res.body.id: isDefined
  res.body.email: eq {{dynamicEmail}}
}
```

> **Note technique :** L'exécution dans la CI s'effectue à la racine des collections "Smoke-Tests" et "Intégration" via la commande : `bru run --env 'fichier-conf'`

### 3.4. Tests Frontend avec Playwright (Smoke Tests & E2E UI)

**Rôle et Utilité :**  
Validation des parcours utilisateur réels côté navigateur (boîte noire UI), incluant rendu, interactions et navigation. Playwright complète Bruno : Bruno valide les contrats HTTP, Playwright valide l'expérience utilisateur de bout en bout.

**Contrainte de maintenance :**  
À chaque modification d'une route du front, ou à chaque ajout, suppression ou modification d'un appel API côté front, la suite de tests Playwright doit être mise à jour puis relancée afin de régénérer les fichiers HAR utilisés pour mocker l'API.

#### 3.4.1. Smoke UI (Tests de Surface Frontend)

**Objectif :**  
Détecter rapidement une régression bloquante sur les écrans critiques (chargement page, authentification, navigation principale).

**Périmètre :**  
Un parcours minimal par domaine fonctionnel, sans dépendance à des données fragiles.

**Environnement cible :** `front-manager build`.

**Contrainte :**  
Exécution rapide, assertions robustes (éviter les sélecteurs CSS volatils), usage prioritaire de `data-testid`.

```ts
import { test, expect } from "@playwright/test";

test("smoke: login utilisateur", async ({ page }) => {
  await page.goto("/login");
  await page.getByTestId("email").fill("user@example.com");
  await page.getByTestId("password").fill("password");
  await page.getByRole("button", { name: "Se connecter" }).click();

  // Assertion fonctionnelle stable: vérifier un élément métier visible
  await expect(page.getByTestId("dashboard-title")).toBeVisible();
});
```

> **Note technique :** En CI, exécuter les tests Playwright sur un environnement déterministe, publier le rapport HTML et les traces en artefacts pour faciliter le diagnostic des échecs intermittents.

---

## 4. Performance et "Context Caching"

La lenteur des suites de tests Java provient de la fragmentation du contexte Spring. L'outil `spring-test-profiler` a démontré que des variations de configuration forcent Spring à redémarrer le contexte applicatif plusieurs fois.

**Problème :**  
L'utilisation de `@MockBean`, `@SpyBean`, `@DirtiesContext` ou `@Import` dans des classes de test individuelles modifie la signature du contexte. Le cache est invalidé, causant des "Cache Misses".

**Solution :**  
Centraliser la configuration dans une classe parente abstraite pour mutualiser le démarrage.

```java
// BONNE PRATIQUE : Contexte Partagé via héritage
@SpringBootTest(classes = FarmstarCoreApplication.class)
public abstract class AbstractIntegrationTest {
    // Les définitions spécifiques qui brisent le cache
    // doivent être centralisées ici une seule fois.
    @MockBean
    protected ModulationRequestSource modulationRequestSource;

    @SpyBean
    protected ModulationService modulationService;
}

// Les tests héritent de la configuration, garantissant un "Cache Hit" (99%+)
class ModulationRequestTest extends AbstractIntegrationTest {
    // Le test utilise le contexte existant sans déclencher de redémarrage.
}
```

---
## 5. Outils et Frameworks Recommandés

- **Tests Unitaires :** JUnit 5, Mockito, AssertJ pour une syntaxe fluide et expressive.
- **Tests d'Intégration :** Spring Boot Test (sans `MockMvc`).
- **Tests API backend :** Bruno pour les scénarios E2E et Smoke Tests HTTP.
- **Tests frontend web :** Playwright pour les smoke tests UI et parcours E2E critiques.
- **Analyse Statique :** SonarLint intégré dans les pre-commit hooks pour garantir la qualité du code avant même qu'il n'entre dans la pipeline CI/CD.

##6. Documentation installtion Git Pré-Commit
- **Installation package Python :** `pip install pre-commit`
- **Activation du hook :** : `pre-commit install --hook-type commit-msg --hook-type pre-commit --hook-type pre-push`
- **Commandes utiles au quotidien :**
  - `pre-commit run --all-files` : Exécute tous les hooks sur tous les fichiers (utile pour un nettoyage global).
  - `pre-commit run <hook_id>` : Exécute un hook spécifique sur tous les fichiers (ex: `pre-commit run checkstyle`).
  - `git push --no-verify` : Contourne les hooks (à utiliser avec précaution, uniquement en cas de besoin urgent).
  - `git commit --no-verify` : Contourne les hooks pour un commit spécifique (à utiliser avec précaution).
---