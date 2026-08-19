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



= Implémentation Technique et Connectivité

La performance de Gemma 4 dépend de la "proximité" de l'outil avec le code source. On distingue deux modes de connexion principaux :

== Intégration IDE : L'Assistant de Flux

Pour les cas d'usage nécessitant une réactivité instantanée (*Assistant de code, Génération de tests*), l'utilisation de plugins est impérative.

- *Outils types :* *Continue*, *Tabby*.
- *Mécanique d'indexation :* Ils créent un *index vectoriel local* (via une DB légère comme LanceDB) directement sur le poste du développeur.
- *Avantage :* Le plugin "voit" ce que l'on tape et indexe les fichiers ouverts en temps réel pour un RAG de proximité sans latence (la base locale est mise à jour à chaque sauvegarde de fichier).

#info-box(color: success-color, title: "Bénéfices de l'indexation locale")[
  ✓ Latence minimale (< 200ms) \
  ✓ Confidentialité des données (rien n'est envoyé vers le cloud) \
  ✓ Adaptation en temps réel aux modifications du code
]

== Interface Centralisée : Le Cerveau Partagé

Pour les tâches de plus haut niveau (*Workflow Jira, Aide à l'onboarding*), une interface Web (type *Open WebUI* ou *AnythingLLM*) serait à privilégier.

- *Le problème du contexte persistant :* On ne peut pas copier-coller des millions de lignes à chaque prompt.
- *La solution :* Coupler l'interface à une *base vectorielle centralisée* (ex: *Qdrant*) sur le serveur. Le modèle ne connaît pas le projet de mémoire, mais l'interface cherche les morceaux de code pertinents dans la base à chaque question de manière invisible. Il serait toujours possible de passer du context via document ou copié-collé classique pour les questions très spécifiques.

#callout(title: "Avantage du RAG centralisé", color: primary-color)[
  Une base vectorielle unique garantit que tous les développeurs interrogent une source de vérité commune. Cela évite les divergences d'interprétation et assure une cohérence métier maximale.
]

== Revue de Code et CI/CD

Pour la revue, le modèle doit être intégré dans GitLab.

- *Fonctionnement :* Un bot intercepte la Pull Request, récupère le "diff" (les modifications) et interroge Gemma 4 en fournissant ce différentiel et les règles de l'équipe.


= Contraintes Opérationnelles

#callout(title: "Ressources Matérielles", color: warning-color)[
  Le déploiement d'un modèle comme GEMMA 4 (8B à 31B) requiert une infrastructure GPU dimensionnée. Un minimum de *24Go de VRAM* (ex: RTX 3090 / 4090) est exigé pour garantir une inférence fluide en précision quantifiée, particulièrement avec de grands contextes.
]

#info-box(color: info-color, title: "Tableau de dimensionnement recommandé")[
  | Modèle | VRAM Min | Configuration Idéale |
  |---------|----------|----------------------|
  | Gemma 2B | 4 GB | RTX 3060 / RTX 4060 |
  | Gemma 7B | 8-12 GB | RTX 4070 / RTX 3080 |
  | Gemma 13B | 16-20 GB | RTX 4080 / RTX 3090 |
  | Gemma 31B | 24+ GB | RTX 6000 / Multi-GPU |
]
