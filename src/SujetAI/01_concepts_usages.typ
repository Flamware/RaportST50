#import "style.typ": *

#let term(content) = {
  return align(
    left, 
    box(
      width: 100%,
      stack(
        dir: ttb,
        block(
          width: 100%,
          fill: secondary-color,
          inset: 10pt,
          radius: 4pt,
          stroke: 0.5pt + primary-color,
          content
        )
      )
    )
  )
}

= Contexte Technique en 2026

L'arrivée de **Gemma 4** (2.3B à 31B) marque un tournant pour le développement "on-premise". Avec une fenêtre de contexte native de **128k tokens**, ces modèles permettent d'analyser des structures de code complexes.

Toutefois, le projet Farmstar nécessite évidemment bien plus que 128k tokens de code source, d'où la nécessité d'adopter des stratégies de **Context Engineering** pour maximiser l'efficacité de l'IA locale sans saturer la mémoire.

= Cas d'Usage

#info-box(title: "Les 5 axes d'implémentation", color: info-color)[
  Les points suivants couvrent les intégrations prioritaires pour Farmstar en 2026, constituant un véritable pipeline IA du développement dès la conception jusqu'à la validation.
]

#block(fill: secondary-color, inset: 12pt, radius: 4pt)[
  *1. Assistant de Code* \
  L'IA intervient comme un "binôme" de programmation en temps réel. Elle ne se contente pas de compléter la syntaxe, mais suggère des implémentations basées sur les patterns spécifiques de Farmstar (Clean Code).
  
  *2. Workflow Ticket Jira* \
  L'IA analyse le ticket, identifie les modules impactés (Front/Back), génère la spécification et propose un plan d'action d'implémentation.
  
  *3. Revue de Code* \
  L'IA agit comme un premier filtre lors des Pull Requests. Elle vérifie la conformité du code par rapport aux standards de l'entreprise avant que le développeur humain n'intervienne.
  
  *4. Génération de Tests* \
  L'IA automatise la tâche chronophage de l'écriture des tests unitaires et d'intégration (JUnit/Mockito), en simulant des cas aux limites souvent oubliés.
  
  *5. Aide au "Retro-Engineering"* \
  L'IA sert de guide interactif pour analyser un code existant, reconstituer son architecture, identifier ses dépendances et comprendre sa logique métier sans documentation complète.
]