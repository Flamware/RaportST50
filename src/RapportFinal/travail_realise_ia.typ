== Axe 2 : R&D et implémentation d’une IA agentique autonome

La seconde partie majeure de mon stage a porté sur l'étude et l'implémentation
d'un système d'intelligence artificielle agentique destiné à assister les
développeurs du projet Farmstar. Contrairement aux travaux présentés dans
l'axe précédent, qui concernaient principalement la fiabilisation de
l'infrastructure logicielle existante, cette partie du stage s'inscrivait dans
une démarche de recherche et développement.

L'objectif n'était pas simplement d'intégrer un modèle de langage dans
l'environnement de développement, mais d'étudier dans quelle mesure un système
capable de raisonner sur le code source, d'utiliser des outils métier et de
coordonner plusieurs agents spécialisés pouvait apporter une assistance
pertinente aux développeurs.

Cette problématique soulevait plusieurs difficultés. Le premier enjeu était
celui de la confidentialité du code source : les données manipulées par
l'agent concernent directement le patrimoine logiciel de l'entreprise et ne
pouvaient donc pas être transmises à des services d'intelligence artificielle
externes. Le second enjeu concernait la quantité d'information disponible.
Le monorepo Farmstar contient une quantité de code largement supérieure à ce
qu'un modèle de langage peut raisonnablement traiter dans un seul contexte. (code source de + 3 Millions de tokens, documentation interne, conventions de codage, etc.)
Enfin, certaines tâches ne peuvent pas être réalisées à partir des seules
connaissances du modèle : elles nécessitent d'explorer le dépôt, de rechercher
des fichiers, de lire du code ou encore de consulter des conventions internes.

L'architecture finalement retenue repose ainsi sur trois briques
complémentaires : un modèle de langage exécuté localement, un mécanisme de
construction dynamique du contexte et un catalogue d'outils accessibles à
l'agent. L'orchestration de ces différents composants a ensuite constitué
l'objet principal du travail réalisé avec LangGraph.


=== Contexte technique, modèles locaux et cas d'usage ciblés

==== Contraintes liées aux données et à l'exécution locale

La première contrainte identifiée concernait la confidentialité du code de
l'entreprise. Une utilisation directe d'API cloud propriétaires aurait impliqué
de transmettre à un service externe des portions potentiellement sensibles du
code source et de la documentation interne.

Pour cette raison, l'expérimentation s'est orientée vers l'utilisation de
modèles open-source exécutés localement. Le moteur d'inférence retenu est
Ollama, permettant de déployer les modèles sur l'infrastructure disponible
sans dépendre d'une API externe.

Le choix étudié s'est porté sur la famille Gemma 4 ainsi que QWen, avec plusieurs tailles de
modèles correspondant à des profils d'utilisation différents. Les modèles de
petite taille sont adaptés aux usages interactifs nécessitant une faible
latence, tandis que les modèles disposant d'un nombre plus important de
paramètres sont davantage adaptés aux tâches de raisonnement et d'orchestration
plus complexes.

Le choix d'un modèle local ne résout cependant pas à lui seul la problématique.
Même lorsqu'un modèle dispose d'une fenêtre de contexte importante, il reste
impossible de lui transmettre systématiquement l'intégralité du monorepo
Farmstar. Une telle approche entraînerait une consommation excessive de
mémoire et dégraderait fortement les temps de réponse.

Le problème était donc le suivant :

- le modèle doit disposer des informations nécessaires pour résoudre une
  tâche ;
- il ne doit pas recevoir l'ensemble du dépôt ;
- les informations transmises doivent être pertinentes pour la requête ;
- le système doit pouvoir récupérer de nouvelles informations au cours de son
  exécution.

Cette contrainte a conduit à dissocier le raisonnement du modèle de la
construction de son contexte.

==== Cas d'usage étudiés

L'intégration de l'intelligence artificielle dans le projet Farmstar a été
envisagée autour de plusieurs activités susceptibles d'assister les
développeurs :

- assistance au codage en temps réel ;
- analyse de tickets Jira ;
- revue automatisée de code ;
- génération de tests unitaires ;
- rétro-engineering de modules existants.

Ces usages ont en commun de nécessiter un accès à des informations propres au
projet. Un modèle généraliste peut connaître Java, Spring Boot, JUnit ou
Mockito, mais il ne connaît pas les conventions spécifiques de Farmstar, la
structure du monorepo ou le contenu d'une classe particulière.

L'enjeu du projet n'était donc pas seulement de produire du texte ou du code,
mais de construire un système permettant au modèle d'accéder de manière
contrôlée aux informations nécessaires à la résolution de la tâche.


=== Le concept de Context Engineering

==== Limites de l'injection brute du contexte

La première approche envisageable consiste à fournir directement au modèle
les fichiers nécessaires à la tâche. Cette solution devient rapidement
impraticable lorsque le nombre de fichiers augmente.

Une tâche portant sur une classe Java peut par exemple nécessiter :

- la classe elle-même ;
- les interfaces qu'elle implémente ;
- les services qu'elle utilise ;
- les objets métier manipulés ;
- les tests déjà présents ;
- certaines conventions du projet.

Une simple recherche par mots-clés peut donc produire trop de résultats. À
l'inverse, une recherche trop restrictive peut supprimer une information
importante.

Il existe ainsi un compromis permanent entre la quantité d'informations
fournies au modèle et leur pertinence. Cette problématique a été abordée dans
le projet sous l'angle du *Context Engineering*.

L'objectif n'est plus seulement de rechercher des documents, mais de construire
dynamiquement un contexte adapté à la tâche en cours.

==== Découpage sémantique du code

Une première étape consiste à ne pas découper le code uniquement selon une
taille arbitraire en caractères ou en tokens.

Des parseurs syntaxiques tels que Tree-sitter peuvent être utilisés afin
d'identifier des unités logiques du code, par exemple des classes ou des
méthodes Java ou TypeScript.

Ce découpage permet de conserver une cohérence syntaxique. Un fragment
correspond ainsi davantage à une unité compréhensible par le modèle qu'à une
portion arbitraire d'un fichier.

Cette approche est particulièrement importante dans le contexte de
l'analyse de code source. Un découpage effectué au milieu d'une méthode ou
entre deux éléments syntaxiquement liés peut supprimer une partie du sens
nécessaire au raisonnement.

==== Enrichissement par les métadonnées

Les fragments récupérés sont également associés à des informations permettant
de conserver leur contexte d'origine.

Par exemple, un fragment peut être associé à :

- son chemin de fichier ;
- son module ;
- sa branche ;
- son emplacement dans le projet.

Le modèle ne reçoit donc pas uniquement le contenu du fragment. Il reçoit
également des informations permettant de comprendre où celui-ci se situe dans
l'architecture globale.

Cette distinction est importante dans un monorepo, où plusieurs modules peuvent
contenir des classes ayant des noms similaires.

==== Recherche hybride

La recherche utilisée ne repose pas uniquement sur la similarité vectorielle.
Deux types de recherche complémentaires sont utilisés.

La recherche dense par embeddings permet de retrouver des éléments présentant
une proximité sémantique avec la requête. Elle est particulièrement utile
lorsque la demande est formulée de manière conceptuelle.

À l'inverse, une recherche lexicale de type BM25 est pertinente lorsqu'un
identifiant exact doit être retrouvé. Dans du code source, les noms de classes,
méthodes ou variables constituent souvent des éléments déterminants.

La combinaison de ces deux approches permet donc de limiter une faiblesse
importante des systèmes de recherche reposant uniquement sur les embeddings :
une similarité sémantique élevée ne signifie pas nécessairement que le
fragment contient l'identifiant exact recherché.

==== Re-ranking et skeletonization

Une étape de re-ranking permet ensuite de réévaluer la pertinence des premiers
résultats obtenus.

Le principe est de ne pas transmettre au modèle l'ensemble des résultats
trouvés, mais de sélectionner les fragments les plus pertinents.

Une autre stratégie étudiée consiste à utiliser une représentation
*skeletonisée* des dépendances. Le code complet de la classe directement
analysée peut être conservé tandis que le corps des méthodes de certaines
classes dépendantes est masqué, en conservant leurs signatures.

Cette représentation permet de fournir au modèle une vision de l'architecture
sans augmenter inutilement la taille du contexte.

L'ensemble de ces mécanismes constitue donc une chaîne de préparation du
contexte. Le modèle de langage ne travaille pas directement sur le monorepo :
il travaille sur une représentation sélectionnée et organisée des
informations pertinentes.


=== Le Model Context Protocol : un catalogue d'outils métier

==== Du modèle de langage à l'agent

La construction du contexte ne suffit cependant pas à résoudre toutes les
tâches. Dans certaines situations, le système doit pouvoir effectuer une
action pendant son raisonnement.

Par exemple, lorsqu'un développeur demande d'analyser un fichier précis,
l'agent doit pouvoir :

- identifier le fichier ;
- parcourir l'arborescence ;
- lire son contenu ;
- rechercher des éléments similaires ;
- consulter certaines connaissances ou conventions du projet.

Le Model Context Protocol (MCP) a été utilisé pour répondre à cette
problématique.

L'idée est de fournir au modèle un ensemble d'outils clairement définis qu'il
peut invoquer lorsque la tâche le nécessite. Le modèle n'accède donc pas
directement au système de fichiers : il passe par une interface d'outils
contrôlée.

==== Conception du serveur FastMCP

Un serveur FastMCP a été développé pour exposer les principales opérations
nécessaires à l'exploration du projet.

Les outils développés couvrent plusieurs catégories :

- navigation dans la structure du projet avec `list_project_structure` et
  `list_project_files` ;
- lecture et synthèse du code avec `read_project_file` et
  `get_file_summary` ;
- recherche sémantique et recherche exacte avec
  `search_rag_code` et `search_by_regex` ;
- accès aux connaissances spécifiques du projet avec
  `list_and_read_skill`.

Cette organisation permet de distinguer clairement les capacités de
l'agent de son raisonnement.

Le LLM décide qu'une information lui est nécessaire, mais l'accès effectif
à cette information est réalisé par un outil contrôlé.

==== Complémentarité entre RAG et MCP

Le RAG et le MCP répondent ainsi à deux besoins différents.

Le RAG permet de retrouver les informations pertinentes à partir d'une base
indexée. Il constitue principalement un mécanisme de récupération de contexte.

Le MCP fournit quant à lui une interface permettant à l'agent d'effectuer
des opérations explicites sur son environnement.

Cette distinction devient importante dans l'architecture finale. Le modèle
peut utiliser le contexte fourni par le système de recherche, mais peut
également demander une nouvelle information via un outil MCP lorsqu'il
constate que son contexte est insuffisant.

L'objectif est donc de construire un agent qui ne soit ni limité à un contexte
statique, ni autorisé à accéder directement et sans contrôle à l'ensemble du
système.


=== Expérimentation sous Open WebUI et motivation de la migration

==== Une première validation fonctionnelle

Avant de développer un orchestrateur spécifique, une première expérimentation
a été réalisée avec Open WebUI.

Le prototype comportait trois agents principaux :

- un agent Farmstar MCP ;
- un agent Jira MCP ;
- un agent Ticket Solver.

Cette première architecture avait un objectif essentiellement exploratoire :
vérifier la pertinence du concept et valider que les modèles pouvaient
effectivement utiliser les outils MCP.

Cette étape a permis de confirmer la faisabilité technique de l'approche.
Cependant, elle a également mis en évidence une limite importante qui ne
concernait pas les capacités individuelles des agents, mais leur coordination.

==== Le problème de l'isolation des agents

Chaque agent disposait de son propre contexte de conversation. Les agents
étaient donc capables de réaliser individuellement leurs tâches, mais ils ne
formaient pas réellement un système collaboratif.

Cette différence est importante.

Considérons par exemple une demande telle que :

#quote[
Analyser le ticket FS-402 et modifier le service Java impacté.
]

Cette tâche combine plusieurs opérations :

1. comprendre le ticket ;
2. identifier le module concerné ;
3. rechercher le code correspondant ;
4. analyser son fonctionnement ;
5. éventuellement identifier les tests existants ;
6. proposer ou générer une modification.

Avec une architecture composée de chatbots isolés, l'utilisateur doit assurer
lui-même le passage d'une étape à l'autre. Les informations produites par un
agent doivent être copiées vers le suivant.

Cette organisation présente deux problèmes.

Le premier est opérationnel : elle demande une intervention humaine
importante.

Le second est qualitatif : lors du transfert manuel, une partie du contexte
peut être oubliée ou reformulée. Le résultat produit par le second agent
dépend alors de la manière dont l'utilisateur a retranscrit le travail du
premier.

L'expérimentation Open WebUI a donc validé le concept d'agent individuel mais
a montré que cette solution ne répondait pas complètement au besoin
d'orchestration.

==== Reformulation du problème

La question n'était donc plus :

#quote[
Comment faire fonctionner plusieurs agents ?
]

mais plutôt :

#quote[
Comment coordonner plusieurs agents spécialisés autour d'un état partagé,
tout en permettant au système de choisir dynamiquement quelles étapes sont
nécessaires ?
]

Cette reformulation a conduit à abandonner le rôle d'Open WebUI comme couche
principale d'orchestration au profit d'un middleware dédié.

Le choix s'est porté sur LangGraph.


=== Problématique d'orchestration

La migration vers LangGraph répond à plusieurs besoins identifiés lors de
l'expérimentation précédente.

Premièrement, les informations produites par les différents agents doivent
être conservées dans un état commun.

Deuxièmement, l'ordre d'exécution ne doit pas nécessairement être fixe. Une
requête fournissant déjà le code à analyser ne nécessite pas forcément une
nouvelle phase de collecte.

Troisièmement, certaines tâches peuvent être terminées plus tôt. Une simple
demande d'analyse n'a par exemple pas nécessairement besoin de déclencher une
génération de tests.

Enfin, les différentes capacités doivent pouvoir être regroupées dans des
unités fonctionnelles indépendantes afin de faciliter l'évolution du système.

L'architecture devait donc répondre simultanément à quatre exigences :

- partager l'état entre les différentes étapes ;
- contrôler explicitement les transitions ;
- permettre des branches conditionnelles ;
- conserver une structure suffisamment modulaire pour ajouter de nouveaux
  agents et de nouveaux cas d'usage.

C'est précisément dans cette logique que le graphe d'agents a été conçu.


=== Conception de l'orchestrateur avec LangGraph

==== Principe du graphe d'état

LangGraph a été utilisé comme couche d'orchestration.

L'idée centrale est de représenter le workflow sous la forme d'un graphe
composé de nœuds et de transitions.

Chaque nœud représente une étape de traitement. Il peut correspondre à un
agent, à une opération de préparation ou à une fonction de routage.

Les transitions définissent quant à elles les étapes pouvant être exécutées
ensuite.

L'intérêt de cette représentation est de rendre explicite le déroulement de
la tâche. Contrairement à un simple enchaînement de fonctions, le système
peut prendre des décisions intermédiaires et revenir vers certaines étapes
lorsque le contexte le nécessite.

Le graphe constitue donc une représentation de l'organisation du raisonnement
plutôt qu'une simple succession d'appels à un modèle de langage.

==== L'état partagé

L'élément central de l'orchestration est l'état partagé.

Chaque étape du graphe peut lire les informations nécessaires à son traitement
et produire de nouvelles informations destinées aux étapes suivantes.

Dans le cas du workflow de couverture de tests, l'état peut notamment
représenter :

- la demande initiale de l'utilisateur ;
- les informations identifiées lors de la collecte ;
- le code source pertinent ;
- les tests déjà présents ;
- les informations relatives aux écarts de couverture ;
- le plan de tests ;
- les résultats intermédiaires produits par les agents ;
- les éléments nécessaires à la génération finale.
- autres informations utiles à la tâche.

Cette organisation évite le transfert manuel du contexte entre les agents.

Un agent ne doit plus transmettre lui-même l'ensemble de son historique au
suivant. Il met à jour l'état du graphe, et le nœud suivant récupère les
informations dont il a besoin.

Cette séparation améliore également la lisibilité de l'architecture : les
données partagées sont définies au niveau du workflow et non implicitement
dans les prompts.

==== Le superviseur central

Le graphe principal est piloté par un agent Superviseur.

Celui-ci constitue le point d'entrée du système. Son rôle n'est pas de
résoudre directement la tâche métier, mais de déterminer quelle capacité doit
être mobilisée.

La requête utilisateur est donc d'abord analysée afin d'identifier son
intention.

La sortie du superviseur est structurée avec Pydantic. Le système ne dépend
ainsi pas uniquement d'une réponse textuelle telle que :

#quote[
Je pense qu'il faudrait utiliser le module de couverture.
]

Il attend une structure correspondant à un ensemble de valeurs autorisées par
l'architecture.

Cette contrainte permet de transformer une décision produite par le LLM en
information exploitable par le programme.

Le superviseur joue ainsi un rôle comparable à celui d'un contrôleur dans une
architecture logicielle classique : il ne réalise pas toutes les opérations,
mais détermine quelle partie du système doit être appelée.

==== Routage dynamique

Une caractéristique importante de l'architecture est que le chemin
d'exécution peut dépendre du contenu de la requête.

Le système analyse notamment si des informations importantes sont déjà
présentes dans le prompt.

Par exemple, lorsqu'un utilisateur fournit directement du code ou des
informations relatives aux écarts de couverture, le système peut éviter une
phase de collecte qui serait redondante.

Ce mécanisme est appelé dans l'implémentation un routage court-circuit.

Il répond à un principe simple : une architecture agentique ne doit pas
exécuter systématiquement toutes ses capacités lorsque certaines étapes sont
inutiles.

Cette optimisation présente deux intérêts.

Le premier est la réduction du nombre d'appels au modèle de langage.

Le second concerne la pertinence du résultat. Chaque étape supplémentaire
introduit potentiellement du bruit ou une transformation intermédiaire de
l'information. Éviter une étape inutile permet donc également de conserver
plus directement le contexte fourni par l'utilisateur.

==== Sous-graphes

Afin de conserver une architecture modulaire, les workflows métier sont
organisés sous forme de sous-graphes.

Le graphe principal reste responsable de l'orientation générale de la requête,
tandis qu'un sous-graphe prend en charge un cas d'usage particulier.

Cette organisation permet de séparer deux niveaux de raisonnement :

- le raisonnement global : *quelle capacité faut-il utiliser ?* ;
- le raisonnement métier : *comment réaliser cette capacité ?*.

Cette séparation est particulièrement utile lorsque plusieurs cas d'usage
doivent coexister.

L'ajout d'un nouveau workflow ne nécessite alors pas de transformer
l'intégralité du graphe principal. Il peut être développé comme une nouvelle
unité fonctionnelle et raccordé au mécanisme de routage du superviseur.


// Insérer ici la figure du graphe principal LangGraph.
// La figure doit montrer au minimum :
// Superviseur -> sous-graphe TEST_COVERAGE -> Gatherer -> Analyzer -> Solver
// ainsi que les routages conditionnels et les retours éventuels.


=== Mise en œuvre du workflow TEST_COVERAGE

Le premier cas d'usage structurant de l'orchestrateur concerne l'analyse de la
couverture des tests.

Ce choix est particulièrement intéressant pour valider l'architecture
multi-agents car la tâche nécessite plusieurs étapes complémentaires. Elle
combine en effet l'exploration du code, l'analyse des tests existants et la
génération de nouveaux tests.

Le workflow a donc été décomposé en trois rôles :

- `Gatherer` ;
- `Analyzer` ;
- `Solver`.

Cette décomposition permet de distinguer la collecte de l'information, son
analyse et la production du résultat.
==== Les types de tâches :
Afin de mieux partitionner le workflow, une requête utilisateur est toujours associées à un type de tâche.
Quelques exemples de types de tâches sont :
- `EXPLAIN`: l'utilisateur demande une explication sur un élément du code de test d'une feature.
- `ANALYZE`: l'utilisateur demande une analyse de la couverture des tests pour un élément du code.
- `GENERATE`: l'utilisateur demande la génération de tests pour un élément du code.
- `AUDIT`: l'utilisateur demande un audit complet de la couverture des tests pour un élément du code.

Ainsi, en fonction de la tâche détectée, l'exécution du graphe diffère. Par exemple, si la tâche est de type `EXPLAIN`, le graphe ne passera pas par l'Agent `Solver`, mais uniquement par l'Agent `Gatherer` pour récupérer le contexte nécessaire et par l'Agent `Analyzer` pour analyser le contexte et produire une explication. (Voir ci-dessous le comportement des Agents)

==== Le Gatherer : constitution du contexte technique

Le `Gatherer` constitue le point d'entrée métier du sous-graphe
`TEST_COVERAGE`.

Son rôle est de rassembler les informations nécessaires à l'analyse.

C'est via cet Agent que le RAG est majoritairement utilisé.

Il identifie notamment le code source concerné et les tests déjà existants.
Pour cela, il utilise les outils exposés par le serveur MCP.

La recherche peut donc combiner la navigation dans l'arborescence, la lecture
de fichiers et la recherche ciblée dans le code.

Cette étape est importante car le modèle de langage ne doit pas être obligé de
deviner quelles informations sont pertinentes. Le `Gatherer` transforme la
demande générale en un contexte exploitable par les étapes suivantes.

Le résultat de cette phase alimente ensuite l'état partagé du graphe.

Il peut notamment contenir :

- les fichiers identifiés comme pertinents ;
- le contenu du code à analyser ;
- les tests déjà présents ;
- les informations permettant de comprendre le périmètre fonctionnel.

Le `Gatherer` réalise donc principalement un travail de récupération
d'informations et non de génération.

==== L'Analyzer : identification des écarts

Le deuxième rôle est assuré par l'`Analyzer`.

À partir du contexte produit par le `Gatherer`, il cherche à expliquer, auditer ou encore analyser la couverture des tests.

Cette étape constitue la transition entre la collecte et la génération dans le cas d'une requête de type `GENERATE`.

L'`Analyzer` ne doit pas simplement demander au modèle de produire
immédiatement du code. Il établit d'abord un plan de test.

Cette séparation permet de rendre le raisonnement plus explicite :

#quote[
1. Qu'est-ce qui existe ?
2. Qu'est-ce qui n'est pas suffisamment couvert ?
3. Quels scénarios doivent être testés ?
4. Quels tests sont nécessaires pour couvrir ces scénarios ?
5. Seulement ensuite : comment générer ces tests ?
]

L'utilisation d'une étape d'analyse intermédiaire permet ainsi de réduire le
risque de produire directement des tests sans avoir correctement identifié le
besoin.

==== Le Solver : génération des tests

Le `Solver` intervient après l'analyse.

Son rôle est de transformer le plan de test en suites de tests unitaires
concrètes.

Dans le périmètre étudié, les technologies ciblées sont notamment JUnit 5 et
Mockito.

Le `Solver` dispose donc des informations collectées par le `Gatherer` et du
plan établi par l'`Analyzer`.

Cette organisation évite de demander au générateur de tests de reconstruire
lui-même l'ensemble du contexte.

La génération devient alors une étape spécialisée dans un workflow plus large.

==== Pourquoi trois agents ?

La séparation `Gatherer / Analyzer / Solver` n'a pas été réalisée uniquement
pour multiplier le nombre d'agents.

Elle répond à une séparation fonctionnelle.

Le `Gatherer` répond à la question :

#quote[
Quelles informations sont disponibles ?
]

L'`Analyzer` répond à :

#quote[
Que faut-il faire à partir de ces informations ?
]

Le `Solver` répond enfin à :

#quote[
Comment produire concrètement le résultat demandé ?
]

Cette séparation rend les responsabilités plus faciles à comprendre et permet
également d'améliorer indépendamment chaque étape.

Elle permet notamment de faire évoluer la méthode de recherche sans modifier
la génération des tests, ou d'améliorer l'analyse sans modifier les outils
MCP.


=== Exécution conditionnelle et optimisation du workflow

L'un des enseignements de l'expérimentation a été que la présence de plusieurs
agents ne signifie pas que tous doivent être exécutés à chaque requête.

Un workflow strictement linéaire du type :

#quote[
Gatherer -> Analyzer -> Solver
]

est simple à comprendre mais devient inefficace lorsqu'une partie des
informations est déjà disponible.

Une requête peut par exemple fournir directement le code à analyser. Dans ce
cas, exécuter une nouvelle collecte complète est inutile.

De même, certaines requêtes peuvent demander uniquement une analyse de la
couverture. Dans ce cas, le `Solver` n'a pas besoin d'être appelé.

L'architecture a donc été affinée afin de supporter des requêtes partielles.

Le sous-graphe peut ainsi adapter son exécution au contexte disponible.

Cette évolution est importante du point de vue de l'ingénierie. Elle montre
que l'objectif du projet n'est pas de construire un pipeline fixe, mais un
système capable d'adapter son parcours à la tâche.

L'exécution conditionnelle permet également de limiter les appels au LLM.
Ce point est particulièrement important avec des modèles locaux, pour lesquels
les temps d'inférence peuvent devenir significatifs lorsque plusieurs étapes
de raisonnement sont enchaînées.

=== Routage et boucles de rétroaction

Le graphe ne se limite pas à une succession de nœuds.

L'intérêt de l'approche réside également dans la possibilité de représenter
des transitions conditionnelles et des boucles.

Dans un pipeline traditionnel, une erreur ou une information manquante doit
souvent être traitée explicitement dans chaque fonction.

Dans une architecture orientée graphe, la logique de contrôle peut être
représentée directement dans les transitions.

Par exemple, si l'étape d'analyse détecte que le contexte fourni par la
collecte est insuffisant, le workflow peut être conçu pour retourner vers une
étape de récupération d'informations plutôt que de poursuivre directement
vers la génération.

Cette possibilité est particulièrement intéressante pour un système agentique.
Le raisonnement peut produire une nouvelle information sur les besoins du
workflow.

L'agent n'est donc plus seulement un composant de calcul placé dans une
pipeline fixe : il participe indirectement au choix du chemin d'exécution.

Cette logique a également conduit à envisager un routage interne plus
autonome des sous-graphes, capable de supprimer certaines étapes lorsqu'elles
ne sont pas pertinentes.


=== Architecture orientée objet et robustesse des agents

La mise en place de LangGraph ne constituait pas à elle seule une architecture
suffisamment maintenable.

Un premier risque identifié était de multiplier les classes d'agents contenant
chacune une logique différente de chargement des prompts, de configuration et
d'accès aux outils.

Pour éviter cette duplication, le framework d'agents a été refactorisé autour
d'une architecture orientée objet.

==== Classe abstraite Agent

Une classe abstraite `Agent` sert de base commune aux différents agents.

Elle encapsule notamment :

- le cycle de vie d'un agent ;
- le chargement des configurations ;
- les prompts ;
- les compétences ou *skills* ;
- l'accès au registre des outils MCP.

Les agents spécialisés peuvent ainsi se concentrer sur leur comportement
métier plutôt que de réimplémenter les mécanismes communs.

Cette approche rapproche l'architecture du graphe d'une architecture logicielle
classique : chaque agent possède une responsabilité identifiée et repose sur
un contrat commun.

Cela permet une prise en main plus rapide pour un développeur qui souhaiterait ajouter un nouveau cas d'usage.

==== Séparation des configurations

Les prompts et les *skills* ont été séparés du code de l'agent.

Cette séparation présente plusieurs avantages.

Elle permet d'abord de modifier le comportement attendu d'un agent sans
modifier sa logique d'exécution.

Elle facilite ensuite les expérimentations. Dans un projet R&D, les prompts
sont susceptibles d'évoluer fréquemment. Les maintenir dans des fichiers
dédiés évite donc de mélanger les réglages expérimentaux avec le code
structurel du framework.

Enfin, cette organisation rend plus simple la comparaison de plusieurs
configurations.

==== Typage et registres

Le routage repose également sur des types explicites.

Des énumérations telles que `SubGraphType`, `SubAgentType` et `AgentTool`
permettent d'éviter l'utilisation dispersée de chaînes de caractères.

Cette décision peut sembler secondaire, mais elle devient importante lorsque
le nombre d'agents augmente.

Un routage fondé sur des chaînes libres peut conduire à des erreurs difficiles
à détecter :

#quote[
"test_coverage"
"TEST_COVERAGE"
"test-coverage"
]

représenteraient potentiellement la même intention mais constitueraient trois
valeurs différentes.

L'utilisation de types explicites réduit ce risque et centralise les valeurs
autorisées.


=== Sorties structurées et validation des décisions du LLM

Un autre problème rencontré dans une architecture agentique concerne la
fiabilité des sorties du modèle.

Un LLM produit naturellement du texte. Or le programme d'orchestration attend
des informations structurées.

Le superviseur doit par exemple retourner une décision de routage exploitable
par le graphe.

Il n'est donc pas suffisant de demander au modèle de répondre sous la forme
d'un JSON dans son prompt. Le système doit également vérifier que la réponse
respecte réellement le schéma attendu.

==== Pydantic

Pydantic est utilisé pour définir les structures attendues.

Le modèle doit ainsi produire des données correspondant à des types précis.

Cette approche permet de rapprocher le comportement probabiliste du LLM des
contraintes déterministes du programme.

Le modèle reste responsable de la décision, mais la structure de cette
décision est contrôlée par l'application.

==== Instructor et mécanisme de retry

La bibliothèque Instructor a également été étudiée afin de renforcer cette
gestion des sorties structurées.

L'intérêt recherché est notamment de pouvoir gérer les erreurs de formatage ou
les champs manquants avec une logique de correction automatique.

Dans le contexte de l'orchestration, ce mécanisme est particulièrement utile
car une sortie invalide du superviseur peut empêcher le graphe de poursuivre
son exécution.

La validation structurée constitue donc une forme de frontière entre la
partie probabiliste du système et sa partie logicielle déterministe.


=== Déploiement et industrialisation du prototype

==== Conteneurisation

Une fois les différents composants assemblés, l'architecture devait pouvoir
être exécutée de manière reproductible.

L'ensemble du prototype a donc été conteneurisé avec Docker.

Docker Compose permet d'orchestrer les différents services nécessaires :

- l'API d'ingestion ;
- le serveur FastMCP ;
- le moteur LangGraph ;
- l'interface Streamlit ;
- l'API et moteur LangFuse : qui fournit les métriques et la traçabilité.

Les composants peuvent ainsi être lancés dans un environnement isolé et
communiquer sur un réseau interne.

Cette organisation réduit la dépendance à l'environnement de développement
local, aux APIs externes (LangSmith) et facilite la reproduction du PoC.

Elle constitue également une première étape vers une éventuelle intégration
plus large dans l'environnement de développement de l'équipe.

==== Interface d'ingestion et administration

Une interface Streamlit complète le système afin de faciliter certaines
opérations d'administration et d'ingestion.

Cette interface ne constitue pas le cœur du raisonnement agentique. Elle sert
principalement de couche d'interaction avec les composants du prototype.

La séparation entre l'interface, le moteur d'orchestration et les outils MCP
permet ainsi de conserver une architecture modulaire.

Le remplacement de l'interface utilisateur ne nécessite pas de modifier le
fonctionnement interne du graphe.

==== Validation et tests automatisés

Un système multi-agents non déterministe (appels LLM réels) ne peut pas être
validé de la même manière qu'un service backend classique. Une suite de
tests dédiée a donc été mise en place pour chaque sous-graphe, structurée
en deux niveaux complémentaires.

Le premier niveau regroupe des tests unitaires strictement isolés : aucun
appel LLM ni réseau n'est effectué. Ils valident les composants
déterministes du système (parsing, valeurs par défaut de l'état, logique
de routage) et s'exécutent instantanément.

Le second niveau regroupe des tests d'intégration effectuant de véritables
appels (LLM, serveurs MCP, base vectorielle Qdrant). Plutôt que de mocker
le modèle de langage, ce qui masquerait son comportement réel, la
validation repose sur des invariants structurels : conformité du schéma
Pydantic retourné par chaque agent, présence des champs attendus selon le
type de tâche, cohérence de l'état partagé après exécution. Cette approche
absorbe le non-déterminisme du LLM tout en garantissant que le contrat de
sortie de chaque agent est respecté.

Ces tests d'intégration sont eux-mêmes déclinés sur trois granularités :

- *Nœud isolé* : invocation directe d'un nœud du graphe (ex. `gatherer_node`)
  pour vérifier son comportement de routage sans exécuter l'ensemble du
  graphe.
- *Tâche de bout en bout* : exécution complète du graphe compilé pour un
  type de tâche donné (`AUDIT`, `AUDIT_WITH_CODE`, `EXPLAIN`, `SEARCH`),
  avec validation du schéma de sortie de l'agent Analyzer correspondant.
- *Scénario de workflow* : validation des interactions entre agents (ex.
  l'Analyzer interroge le Gatherer et récupère sa réponse, ou le Gatherer
  route correctement vers un outil lorsque des appels d'outils sont
  présents). Ces scénarios s'appuient sur les mécanismes `interrupt_before`
  et `interrupt_after` de LangGraph pour figer l'exécution à un point
  précis et inspecter l'état intermédiaire du graphe.

Cette suite couvre actuellement les sous-graphes `code_companion` et
`test_coverage`, les deux workflows les plus avancés du prototype. Son
extension aux sous-graphes restants (`doc_generator`,
`functional_companion`) fait partie des travaux à poursuivre.

=== Observabilité et traçabilité

Un système multi-agents est difficile à déboguer si l'on ne peut pas observer
les étapes intermédiaires de son exécution, ainsi que sa réflexion (CoT).

Une requête peut en effet provoquer plusieurs appels au LLM, plusieurs appels
MCP et plusieurs décisions de routage, voir même boucler sur certaines étapes.

Lorsqu'un résultat est incorrect, il est donc nécessaire de savoir quelle
étape a produit l'information problématique.

LangFuse a été intégré au prototype afin d'apporter cette observabilité.

L'objectif est notamment de pouvoir suivre :

- les différentes étapes d'exécution ;
- les appels aux outils ;
- la latence ;
- l'utilisation des tokens ;
- les interactions entre les composants.
- posséder une solution Open Source pour la traçabilité des requêtes et des résultats.

Cette instrumentation est particulièrement importante dans une démarche R&D.
Elle permet de distinguer une erreur provenant du modèle, du contexte, du
routage ou d'un outil.

Elle fournit également les éléments nécessaires à de futurs benchmarks.

Il existait bien une solution "clefs en main" (LangSmith créer par l'équipe de developpeurs de LangGraph) mais elle n'était pas Open Source et demandais une connexion à un compte externe type Github, Google, etc.

Dans une architecture agentique, la qualité d'un système ne peut donc pas
être évaluée uniquement à partir de sa réponse finale. Il faut également
pouvoir analyser le chemin qui a conduit à cette réponse.


=== Déroulement d'une requête complète

Afin de mieux comprendre l'architecture, il est possible de suivre le
traitement d'une requête de couverture de tests.

Supposons qu'un développeur demande au système d'améliorer les tests d'un
service Java.

1) La première étape consiste à transmettre cette requête au superviseur.

2) Le superviseur analyse l'intention et identifie le workflow
`TEST_COVERAGE`.

3) Le graphe transfère alors l'exécution vers le sous-graphe correspondant.

4) Le `Gatherer` examine le contexte disponible. Si le développeur n'a fourni
aucun code pertinent, il utilise les outils MCP afin d'identifier le service
concerné, retrouver son fichier source et rechercher les tests existants.

5) Les informations obtenues sont ensuite ajoutées à l'état partagé.

6) L'`Analyzer` récupère cet état et analyse le code ainsi que les tests
existants. Il identifie les scénarios insuffisamment couverts et construit un
plan de test.

7) Ce plan est à son tour ajouté à l'état du workflow.

8) Le `Solver` peut alors utiliser les informations précédentes pour générer les
tests correspondants en JUnit 5 et Mockito.

10) Le résultat final est produit à partir de l'ensemble du contexte construit
progressivement.

Aucun agent
n'a besoin de posséder individuellement l'intégralité de la tâche et on évite ainsi les problèmes de transfert manuel d'informations, d'hallucinations ou de perte de contexte.

Chaque agent réalise une partie spécialisée du travail et communique son
résultat par l'intermédiaire de l'état du graphe.


=== Bilan de l'architecture

La migration d'Open WebUI vers LangGraph n'a donc pas constitué un simple
changement de bibliothèque.

Elle correspond à une évolution du modèle d'architecture.

Dans la première approche, plusieurs agents spécialisés étaient juxtaposés.
La coordination dépendait en grande partie de l'utilisateur.

Dans la seconde approche, les agents deviennent des composants d'un système
orchestré.

Le superviseur détermine le workflow approprié, l'état partagé conserve les
résultats intermédiaires, les sous-graphes organisent les capacités métier et
les transitions conditionnelles permettent d'adapter l'exécution au contexte.

Cette évolution apporte plusieurs bénéfices.

Premièrement, elle réduit la dépendance aux manipulations manuelles entre
agents.

Deuxièmement, elle rend explicite le chemin d'exécution.

Troisièmement, elle facilite l'ajout de nouveaux workflows.

Enfin, elle permet d'introduire progressivement des mécanismes plus avancés
de routage et de contrôle.


=== Limites identifiées

Malgré ces résultats, le système développé reste un prototype de R&D et ne
doit pas être présenté comme un système complètement industrialisé.

La première limite concerne la dépendance aux performances du modèle local.
La qualité du routage, de l'analyse et de la génération reste liée aux
capacités du modèle utilisé.

La seconde concerne le coût d'un workflow multi-agents. Chaque étape
supplémentaire peut nécessiter une nouvelle inférence et donc augmenter la
latence globale.

Cette contrainte justifie les travaux réalisés sur les routages
court-circuits et l'exécution conditionnelle.

Une troisième limite concerne la fiabilité du raisonnement. Même lorsqu'une
sortie respecte correctement son schéma Pydantic, son contenu peut rester
incorrect. La validation structurelle garantit donc la forme de la réponse,
mais pas sa pertinence métier.

Enfin, les mécanismes de génération de code nécessitent toujours une
validation par le développeur. Le rôle du système est d'assister le
développeur et de réduire le travail de recherche et de préparation, et non
de supprimer les mécanismes classiques de revue et de validation du code.


=== Résultats et perspectives

Le travail réalisé a permis d'obtenir un PoC multi-agents opérationnel basé
sur LangGraph et MCP, capable d'analyser du code source et de construire des
plans de tests.

La principale contribution du travail réside toutefois dans l'architecture
mise en place.

Le prototype permet désormais de considérer l'IA comme un système composé de
plusieurs capacités spécialisées plutôt que comme une succession de
conversations indépendantes.

Cette architecture fournit également une base pour de futures extensions.

Un premier axe consiste à rendre le routage des sous-graphes davantage
autonome afin que les étapes inutiles soient automatiquement évitées.

Un second axe concerne l'intégration de nouveaux outils métier. Les serveurs
MCP pourraient notamment être étendus afin d'interagir directement avec Jira
ou SonarQube.

Un troisième axe consiste à intégrer l'orchestrateur dans les chaînes de
développement existantes. À terme, le système pourrait par exemple être
déclenché automatiquement lors de certaines étapes d'une Merge Request afin
d'assister la revue de code ou l'analyse de tests.

Une première base de validation automatisée existe déjà (voir section
Validation et tests automa/sttisés), mais elle porte sur la conformité
structurelle des sorties, pas sur leur pertinence métier. Ces évolutions
devront donc être accompagnées d'une évaluation plus systématique de la
qualité fonctionnelle des résultats, de la latence et du coût d'exécution.

L'enjeu de la suite du projet n'est donc plus uniquement de démontrer qu'un
LLM peut produire une réponse pertinente. Il consiste à déterminer dans
quelles conditions une architecture agentique peut être suffisamment fiable,
observable et reproductible pour être intégrée dans les pratiques quotidiennes
des développeurs.
