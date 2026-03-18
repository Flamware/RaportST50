#set document(title: "Analyse des Outils d'Analyse Statique Java - Pre-commit", author: "Ingénieur 5A")
#set page(paper: "a4", margin: (x: 2cm, y: 2cm), numbering: "1/1")
#set text(font: "Linux Libertine", lang: "fr", size: 11pt)
#set heading(numbering: "1.")

// Couleurs
#let corporate-blue = rgb("#004C97") // Bleu type Airbus/Corp
#let alert-red = rgb("#D32F2F")
#let success-green = rgb("#388E3C")
#let warning-orange = rgb("#F57C00")

// Styles des titres
#show heading: set text(fill: corporate-blue)
#show heading.where(level: 1): it => [
  #v(0.5em)
  #line(length: 100%, stroke: 1pt + corporate-blue)
  #text(1.2em, weight: "bold", it.body)
  #v(0.5em)
]

// Titre du document
#align(center)[
  #text(1.5em, weight: "bold", fill: corporate-blue)[Analyse des Outils d'Analyse Statique Java] \
  #text(1.2em)[Integration dans les Pre-commit Hooks] \
  #v(1em)
  #text(size: 10pt, style: "italic")[Généré le #datetime.today().display()]
]

= Contexte et Objectifs
L'intégration de "Pre-commit hooks" permet de garantir que tout code commité respecte les standards de qualité avant même son entrée dans la pipeline CI/CD. Ces outils d'analyse statique aident à détecter les bugs potentiels, les violations de style et les mauvaises pratiques dès le développement.

Ce document présente une analyse comparative des outils d'analyse statique Java les plus populaires et adaptés à une utilisation en pre-commit hooks.

= Critères d'Évaluation
Les critères retenus pour comparer les outils sont :

- *Type d'Analyse* : Nature des problèmes détectés (style, bugs, sécurité, etc.).
- *Adéquation Pre-commit* : Capacité à s'exécuter rapidement et sans dépendances complexes.
- *Performance* : Temps d'exécution et impact sur le processus de commit.
- *Complexité de Configuration* : Facilité de mise en place et de maintenance.
- *Intégration IDE* : Support intégré dans les IDEs populaires (IntelliJ, Eclipse, VS Code).

= Tableau Comparatif des Outils d'Analyse Statique Java

#table(
  columns: (auto, 1fr, 1fr, 1fr, 1fr, 1fr),
  fill: (col, row) => if row == 0 { corporate-blue.lighten(80%) } else { white },
  inset: 10pt,
  [*Outil*], [*Type d'analyse*], [*Adéquation Pre-commit*], [*Performance*], [*Complexité Config.*], [*Intégration IDE*],
  [PMD], [Bonnes pratiques, code mort], [#text(fill: success-green)[Très bonne]], [Rapide], [Moyenne], [Excellente],
  [SpotBugs], [Détection de bugs], [#text(fill: warning-orange)[Moyenne]], [Moins rapide], [Élevée], [Bonne],
  [SonarLint], [Qualité globale et Sécurité], [#text(fill: alert-red)[Faible]], [Lente], [Élevée], [Excellente],
  [ArchUnit], [Architecture et dépendances], [#text(fill: warning-orange)[Bonne]], [Rapide], [Moyenne], [Bonne],
)

= Analyse Détaillée des Outils

== PMD (Programming Mistake Detector)
*Type d'analyse :* Bonnes pratiques, code mort, complexité cyclomatique

*Description :* PMD est un analyseur statique qui détecte les bugs potentiels, le code mort, et les violations de bonnes pratiques sans nécessiter la compilation.

*Avantages :*
- Détecte le code mort et les patterns problématiques
- Règles préconfigurées et personnalisables
- Analyse les sources directement
- Performance acceptable

*Inconvénients :*
- Peut générer des faux positifs
- Configuration XML parfois complexe
- Moins complet que SpotBugs pour les bugs critiques

*Configuration Pre-commit :*
```xml
<ruleset name="PMD Rules">
  <rule ref="category/java/bestpractices.xml"/>
  <rule ref="category/java/codestyle.xml"/>
  <rule ref="category/java/design.xml"/>
</ruleset>
```


== SpotBugs (anciennement FindBugs)
*Type d'analyse :* Détection de bugs potentiels

*Description :* SpotBugs analyse le bytecode compilé pour détecter des patterns suspects (NullPointerException, ressources non fermées, etc.).

*Avantages :*
- Détecte les bugs sérieux (NullPointer, ressources non fermées, etc.)
- Analyse précise du bytecode
- Moins de faux positifs que PMD

*Inconvénients :*
- Nécessite la compilation des classes (plus lent)
- Moins adapté aux pre-commit hooks
- Configuration Gradle/Maven requise
- Performance moins bonne

*Configuration Gradle :*
```gradle
plugins {
  id 'com.github.spotbugs' version '5.0.0'
}

spotbugs {
  excludeFilter = file('spotbugs-exclude.xml')
}
```


== SonarLint
*Type d'analyse :* Qualité globale, sécurité, hotspots de sécurité

*Description :* SonarLint est une extension de SonarQube pour l'analyse locale. Elle détecte les bugs, les vulnérabilités de sécurité, et les problèmes de qualité du code.

*Avantages :*
- Très complet (bugs, sécurité, qualité)
- Hotspots de sécurité bien identifiés
- Excellente intégration IDE

*Inconvénients :*
- Moins approprié pour pre-commit (trop complet et lent)
- Conçu plutôt pour l'analyse en CI/CD ou IDE
- Nécessite souvent une connexion au serveur SonarQube


== ArchUnit
*Type d'analyse :* Architecture et contraintes de dépendances

*Description :* ArchUnit vérifie que l'architecture du projet respecte les règles définies (isolation des packages, dépendances circulaires, etc.).

*Avantages :*
- Détecte les violations architecturales
- Exécution rapide
- Configuration en code Java (plus lisible que XML)
- Intégration facile avec les frameworks de test

*Inconvénients :*
- Moins connu que les autres outils
- Nécessite la compilation des classes
- Configuration en code (moins standard)

*Configuration Test :*
```java
ArchTests.in(classesDir).ensureFreeOfCycles();
ArchTests.in(classesDir).check(
  classes().that().resideInAPackage("..controller..")
    .should().dependOnClassesThat().resideInAPackage("..service..")
);
```
= Conclusion

Pour une integration optimale en pre-commit hooks, privilegier :
- #text(fill: success-green)[*PMD*] pour completer les controles source deja en place
- #text(fill: warning-orange)[*SpotBugs*] si le temps d'execution reste acceptable
- #text(fill: warning-orange)[*ArchUnit*] selon les besoins d'architecture
- #text(fill: alert-red)[*SonarLint*] en IDE/CI-CD pour une analyse plus lourde