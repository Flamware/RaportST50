#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
columns: (1fr, 1fr),
align(left)[
#text(weight: "bold", size: 1.2em)[UTBM]

#text(size: 0.9em)[Stage de Fin d'Études (ST50)]
],
align(right)[
#text(weight: "bold", size: 1.1em)[Magellium]

#text(size: 0.9em)[Projet : Farmstar Core Service]

#text(size: 0.9em)[Date : 3 mars 2026]
]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
#text(weight: "bold", size: 1.5em)[Fiche d'Activité : Correction CI et tests de sécurité API]
]

== Travaux réalisés
Aujourd'hui, j'ai corrigé des tests unitaires défaillants, nettoyé le code pour passer la CI et automatisé la génération de jeux de données pour les tests d'API.

=== Qualité de code et tests unitaires

Connexion à la base de données locale PostgreSQL (fs-db-ci-1) pour faciliter le debug.

Résolution de 102 violations Checkstyle (visibilité des variables, longueur de ligne, espaces) et application du formatage Spotless sur le projet.

Réparation du test GapFillingRequestServiceTest : correction d'une NullPointerException en injectant le LogbookService et résolution d'un problème de décalage horaire en forçant la JVM en UTC pour valider les assertions JSON.

=== Automatisation des tests de sécurité API (Bruno)

Développement d'un script Bash pour parser la matrice de sécurité CSV du projet (fs-core-secu-matrix.csv).

Génération automatique de fichiers de données CSV par route, isolant les rôles devant retourner une erreur HTTP 403.

Configuration du client Bruno pour faire du data-driven testing : injection dynamique du header X-Authenticated-Roles et vérification globale des codes de retour HTTP via le Runner.

== Analyse et plan d'action

Bilan : Les tests unitaires du service de gapfilling passent sans problème de fuseau horaire. Le script Bash est opérationnel et évite de dupliquer manuellement les requêtes dans Bruno pour tester les permissions.

Prochaine étape : Déployer ces tests paramétrés sur les autres routes de l'API pour couvrir l'intégralité de la matrice de sécurité.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]