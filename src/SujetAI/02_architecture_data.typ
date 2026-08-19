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

= Orchestration par Model Context Protocol (MCP)

L'architecture RAG décrite précédemment permet de fournir des faits à l'IA. Cependant, pour transformer Gemma 4 en un véritable assistant opérationnel pour Farmstar, nous devons passer d'une consommation passive de données à une capacité d'action dynamique. C'est ici qu'intervient le Model Context Protocol (MCP).

== Concept Fondamental : Du RAG Statique à l'Agent Actif

Le MCP permet de standardiser la manière dont le modèle interagit avec des outils tiers sans nécessiter de développements spécifiques pour chaque interface (Open WebUI, IDE, CLI).

#term[
  *Concept clé : Tool Calling* \
  Contrairement au RAG où le système injecte le contexte *avant* la question, le MCP permet au modèle de décider *pendant* son raisonnement s'il a besoin d'un outil (ex: `read_jira_ticket`, `exec_sql_query`) pour compléter sa tâche.
]

#info-box(title: "Synergie RAG + MCP", color: success-color)[
  Le RAG fournit la connaissance (recherche sémantique globale), tandis que le MCP fournit la capacité d'action (outils métier). Ensemble, ils permettent à Gemma 4 de ne plus seulement "répondre", mais de "résoudre".
]

== Architecture de Déploiement

Pour Farmstar, l'implémentation du MCP suivra une structure hybride adaptée aux contraintes de sécurité et de performance:

#styled-list(
  ("Transport stdio (Local) : Utilisé par les plugins d'IDE (Continue/Tabby). Le serveur MCP tourne sur le poste du développeur, permettant un accès direct au système de fichiers local et aux scripts de build.",
   "Transport SSE/HTTP (Centralisé) : Utilisé par l'interface Open WebUI. Les serveurs MCP sont hébergés sur l'infrastructure serveur, permettant d'interroger les API centralisées (Jira, GitLab, Qdrant) de manière unifiée.",
   "Sandboxing : Chaque outil critique (exécution de code, accès DB) doit s'exécuter dans un environnement isolé (Sandbox) pour éviter toute action destructive sur le projet."),
  color: primary-color
)

== Catalogue d'Outils Spécifiques (Farmstar Tools)

L'implémentation actuelle du serveur MCP Farmstar expose les outils suivants, organisés en quatre familles fonctionnelles :

=== Outils de Navigation et Structure (Project File Tools)

Ces outils permettent à l'IA de comprendre l'organisation générale du monorepo sans être submergée par des milliers de fichiers.

- `list_project_files()` : Liste les fichiers clés du projet (Python, YAML, Markdown) pour orienter les recherches ultérieures.
- `list_project_structure(depth: int)` : Fournit une arborescence simplifiée des dossiers jusqu'à une profondeur donnée, en excluant les répertoires non pertinents (.git, .venv, target, etc.).
- *`list_files_in_directory(dir_path: str)`* : Liste le contenu d'un dossier spécifique, utile après localisation d'un module intéressant.

=== Outils d'Accès au Code (File Analysis Tools)

Ces outils permettent à l'IA de consulter le code source en détail.

- *`read_project_file(file_path: str)`* : Lit le contenu complet d'un fichier du monorepo avec vérification de sécurité (confinement à l'intérieur du répertoire root).
- *`get_file_summary(file_path: str)`* : Fournit un résumé intelligent du contenu d'un fichier en utilisant le moteur RAG, utile pour les fichiers volumineux.

=== Outils de Recherche (Search Tools)

Deux modes de recherche complémentaires pour localiser du code :

- *`search_rag_code(query: str)`* : Recherche *sémantique* (conceptuelle) dans le codebase. À utiliser pour comprendre une logique métier globale quand on ne connaît pas le nom exact des fichiers (ex: "gestion de la biomasse", "flux de notification").
- *`search_by_regex(pattern: str, file_extension: str)`* : Recherche *technique* (exacte) utilisant les expressions régulières. Pour trouver des correspondances précises (ex: `public class .*Controller`).

=== Outils de Partage de Connaissances (Skills)

- *`list_and_read_skill(skill_name: str)`* : Liste et consulte les skills (fichiers Markdown) disponibles. Permet à l'IA de se référer à des guides ou des bonnes pratiques prédéfinis (ex: architecture, patterns de codage).

== Sécurité et Gouvernance

L'usage du MCP impose une gestion fine des droits d'accès. Un orchestrateur de contexte devra filtrer les outils disponibles en fonction du rôle de l'utilisateur (Développeur vs Tech Lead) et journaliser chaque appel d'outil pour assurer la traçabilité des modifications effectuées par l'IA.

== Orchestration Multi-Agent : Sortir des Silos

=== Le Défi de l'Implémentation Actuelle

L'implémentation actuelle via Open WebUI révèle une limite structurelle : les agents (Jira, Farmstar, Code) fonctionnent en *silos*. Un agent "Jira" ne peut pas transmettre de contexte directement à l'agent "Analyse de Code" sans intervention humaine.

Dans un workflow complexe (ex: "Résoudre le ticket FS-402"), l'IA doit :
1. Lire le ticket (Agent Jira).
2. Analyser les fichiers sources impactés (Agent Farmstar).
3. Proposer un correctif et vérifier les dépendances (Agent Code).

Actuellement, l'utilisateur doit effectuer manuellement le "copier-coller" du contexte entre chaque agent. Cela engendre une perte de cohérence et augmente le risque d'hallucination.

=== Solution : Orchestration par Graphe d'État (LangGraph)

Pour que le model devienne un véritable assistant autonome, nous devons déporter la logique d'orchestration de l'interface (Open WebUI) vers une *couche de logique métier (Middleware)*.

#term[
  *Orchestration par Graphe d'État* \
  L'utilisation de frameworks comme *LangGraph* permet de définir un "Cerveau Central" (Supervisor) qui :
  - Détient l'état global de la tâche (State).
  - Appelle dynamiquement les outils MCP nécessaires.
  - Oriente le flux de travail entre les différents "nœuds" de compétences sans perte de contexte.
]

== Architecture Complète :

L'architecture cible pour Farmstar repose sur la synergie de trois composantes :

- *RAG :* La mémoire sémantique (Connaissance globale et recherche contextuelle).
- *MCP :* Le bras opérationnel (Capacité d'action sur les outils métier Farmstar).
- *LangGraph :* Le chef d'orchestre (Planification, coordination et état global des tâches).

= Le Concept de Context Engineering

Le Context Engineering est l'ensemble des techniques permettant de transformer une masse de données brutes (le code source de Farmstar) en une sélection d'informations structurées et pertinentes pour le modèle de langage.

À l'échelle de plusieurs millions de tokens, le modèle ne peut pas "voir" tout le projet. L'ingénierie de contexte consiste donc à construire un *"résumé intelligent"* et dynamique du projet.

#callout(title: "Pourquoi est-ce indispensable pour Farmstar ?", color: accent-color)[
  Le projet Farmstar dépasse la capacité de mémoire immédiate de Gemma 4. Sans ingénierie, l'IA souffre de deux maux majeurs :
  - *Saturation :* Trop d'informations inutiles (bruit) masquent les informations vitales.
  - *Dilution (Lost in the Middle) :* Plus le contexte est long, plus le modèle a du mal à faire des liens précis entre des éléments éloignés.
]

== Les Stratégies d'Optimisation du Contexte

Le défi pour Farmstar n'est pas seulement de trouver l'information, mais de la compresser et de la prioriser pour que Gemma 4 reste performante malgré la masse de données.

=== Le "Chunking" Sémantique (Segmentation Logique)
Au lieu d'un découpage arbitraire par nombre de caractères, le RAG utilise une segmentation basée sur la structure du code.
- *Principe :* Utilisation de parseurs (ex: Tree-sitter) pour isoler des unités logiques complètes.

#term[
  *Exemple :* Plutôt que de couper le fichier `BiomasseService.java` tous les 1000 caractères, le RAG extrait la méthode `public double calculerIndiceVegetation(...)` dans son intégralité, du début de la signature jusqu'à l'accolade fermante.
]

=== L'Enrichissement par Métadonnées (Metadata Injection)
Chaque fragment récupéré par le RAG est "augmenté" par un préfixe textuel avant d'être soumis à l'IA.
- *Principe :* On injecte des informations de contexte global (chemin, branche, module) en haut du fragment.

#term[
  *Exemple de préfixe injecté :* \
  `[FILE: agri-frontend/src/components/MapScale.ts | MODULE: geo-view | BRANCH: develop]` \
  `export const updateScale = (zoom: number) => { ... }`
]

=== La Recherche Hybride (Dense & Sparse Retrieval)
La recherche hybride combine deux méthodes de récupération pour compenser leurs limites respectives. Elle assure que l'IA dispose à la fois d'une compréhension conceptuelle et d'une précision lexicale.

*Recherche Dense (Vectorielle) :* Cette méthode convertit le texte en coordonnées mathématiques (embeddings). Elle permet de saisir l'intention derrière une question.

*Avantage :* Elle gère les synonymes et les concepts proches. Une requête sur la "santé des cultures" pourra identifier des segments traitant de "l'indice de végétation".

*Recherche Sparse (Mots-clés / BM25) :* C'est la méthode de recherche traditionnelle par indexation de termes précis.

*Avantage :* Elle est indispensable pour le code source. Elle garantit que les noms techniques exacts (ex: FSAgriCultureValidator) soient trouvés, là où une recherche vectorielle pourrait proposer un validateur générique par simple ressemblance sémantique.

#term[
  *Application au projet Farmstar*

  Le monorepo contient des milliers de classes aux noms très spécifiques. La recherche hybride permet de répondre à une question métier floue ("Comment traiter les anomalies de surface ?") tout en restant capable de pointer immédiatement un fichier technique précis si son nom est mentionné.
]

=== Le Re-ranking (Filtrage de Haute Précision)
Le processus de récupération initial (RAG classique) extrait souvent une cinquantaine de fragments pour maximiser les chances de trouver l'information. Cependant, injecter 50 fragments dans le modèle génère du bruit et réduit la précision. Le Re-ranker intervient comme un second filtre expert.

Le fonctionnement : Contrairement à la recherche initiale qui est rapide mais superficielle, le Re-ranker utilise un modèle dit "Cross-Encoder". Il analyse la relation directe entre la question posée et chaque fragment trouvé pour leur attribuer un score de pertinence réel.

L'utilité : Il permet de classer les résultats du plus pertinent au moins pertinent.

#term[
  *Lutter contre le phénomène "Lost in the Middle"*

  Les modèles de langage, y compris Gemma 4, perdent en attention sur les informations situées au centre d'un contexte volumineux. Le Re-ranking garantit que les trois fragments de code les plus critiques sont placés au sommet du contexte, là où le modèle exerce sa capacité de raisonnement maximale.
]

=== La "Skeletonization" Dynamique (Architecture à la demande)
Utilisée pour donner une "carte" à l'IA sans saturer sa mémoire.
- *Principe :* Injection des signatures sans le corps des fonctions.

#term[
  *Exemple :* Pour comprendre une dépendance, on fournit le code complet du service appelant, mais seulement la signature du client appelé : \
  `public class SatelliteClient {` \
  `  public Image getImageByCoord(double lat, double lon); // Corps masqué` \
  `}`
]

== L'Ingénierie des Instructions (Prompting)
Le Context Engineering inclut également la structuration des consignes pour garantir la fiabilité des réponses :

#styled-list(
  ("*Balisage (Tagging) :* Utilisation de balises structurées (XML/Markdown) pour délimiter les fichiers et aider l'IA à se repérer géographiquement dans le monorepo.",
   "*Ancrage et Traçabilité (Source Grounding) :* Obligation faite au modèle de citer les fichiers sources utilisés pour chaque affirmation, permettant un audit rapide et limitant les hallucinations.",
   "*Few-Shot Contextualisation :* Injection d'exemples de \"résultats types\" (ex: tests unitaires validés) pour aligner la génération sur les standards de qualité de Farmstar."),
  color: primary-color
)

== Synthèse : Passer du Brut à l'Ingénierie
#align(center)[
  #table(
    columns: (1fr, 1.5fr, 1.5fr),
    inset: 10pt,
    fill: (col, row) => if row == 0 { primary-color } else if calc.odd(row) { secondary-color } else { white },
    align: horizon,
    stroke: 0.5pt + white,
    [*Méthode*], [*Donnée Brute*], [*Ingénierie de Contexte*],
    [*Volume*], [Tout le code source (Millions)], [Sélection ciblée (Kilos)],
    [*Précision*], [Risque élevé d'hallucinations], [Réponses basées sur des faits extraits],
    [*Performance*], [Lenteur (sature la VRAM)], [Inférence fluide et rapide]
  )
]#v(1em)


= Stratégie d'Alimentation du RAG (Ingestion des Données)

Une base vectorielle n'est pertinente que si la donnée qui l'alimente est qualifiée. Pour un écosystème de l'envergure de Farmstar, l'indexation ne se limite pas à un simple "copier-coller" du code. On met en place un véritable pipeline d'ingestion de connaissances.

== Les Sources de Données (Le "Quoi")

Pour obtenir une IA capable de faire le lien entre un besoin métier et une fonction technique, le RAG doit agréger trois typologies de documents :

- *Le Code Source Structuré (Java, TypeScript, SQL) :*
  Il ne doit pas être ingéré comme du texte brut. Il est "parsé" (souvent via un Abstract Syntax Tree) pour que la base de données comprenne où commence et où s'arrête une méthode ou une classe.

- *La Documentation Technique (Markdown, Swagger) :*
  Les fichiers `README` et les contrats d'API (JSON/YAML). Ils sont cruciaux car ils expliquent les "règles" du projet que le code seul ne décrit pas toujours.

- *Le Contexte Métier et Fonctionnel (PDF, Jira) :*
  Les spécifications (PDF/Word) et l'historique des tickets Jira. C'est cette couche qui permet à l'IA de comprendre le *pourquoi* d'une implémentation.

== Le Pipeline de Transformation (Le "Comment")

On ne "jette" pas un PDF de 50 pages ou une classe Java de 2000 lignes directement dans la base. Avant de devenir un vecteur mathématique, la donnée subit trois étapes :

#align(center)[
  #table(
    columns: (1fr, 2fr, 1.5fr),
    inset: 10pt,
    fill: (col, row) => if row == 0 { primary-color } else if calc.odd(row) { secondary-color } else { white },
    align: horizon,
    stroke: 0.5pt + white,
    [*Étape de l'ETL*], [*Action sur la donnée*], [*Exemple concret*],
    [*1. Nettoyage*], [Exclusion systématique du bruit : fichiers compilés (`.class`), dossiers de dépendances, ou logs applicatifs.], [Le RAG ignore automatiquement le dossier `node_modules/`.],
    [*2. Chunking Intelligent*], [Le code est découpé par "bloc logique". Les PDF/Docs métiers sont découpés avec un chevauchement (overlap) de 15%.], [Un chunk = la méthode Java entière `calculBiomasse()`.],
    [*3. Enrichissement (Métadonnées)*], [On attache des "tags" invisibles à chaque vecteur pour forcer la recherche dans un périmètre précis.], [Ajout des tags `[Module: fs-core]` et `[Type: Spec]`.]
  )
]


#callout(title: "Le Risque du \"Garbage In, Garbage Out\"", color: accent-color)[
  Si le RAG ingère de vieux documents PDF obsolètes ou du code mort, l'IA les utilisera comme source de vérité. L'indexation d'un projet comme Farmstar demande une gouvernance stricte de la donnée : l'index vectoriel doit être synchronisé avec une branche pré-determinée et mis à jour régulièrement.
]

