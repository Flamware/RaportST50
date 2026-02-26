#set page(paper: "a4", margin: (x: 2cm, y: 2.5cm))
#set text(font: "Linux Libertine", size: 11pt, lang: "fr")
#set heading(numbering: "1.1.")

// --- En-tête Institutionnel ---
#grid(
  columns: (1fr, 1fr),
  align(left)[
    #text(weight: "bold", size: 1.2em)[UTBM] \
    #text(size: 0.9em)[Stage de Fin d'Études (ST50)]
  ],
  align(right)[
    #text(weight: "bold", size: 1.1em)[Magellium] \
    #text(size: 0.9em)[Projet : Farmstar Core Service] \
    #text(size: 0.9em)[Date : 26 Février 2026]
  ]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
  #text(weight: "bold", size: 1.5em)[Fiche d'Activité : Tests d'intégration et restructuration Bruno]
]

== Travaux réalisés
Aujourd'hui, j'ai continué le portage des tests d'intégration Java vers Bruno en finalisant la gestion des utilisateurs et la modulation, tout en réorganisant proprement notre arborescence de fichiers de test.

=== Tests d'API pour UserController
- Création d'une requête "Setup" pour générer une coopérative avec un identifiant dynamique (via un timestamp) afin d'éviter les erreurs de doublons en base de données.
- Portage des requêtes pour créer, modifier et authentifier un utilisateur. J'ai dû ajuster le JSON (ajout de `type: basicUser` et de valeurs par défaut) pour corriger une erreur 500 renvoyée par la base de données.
- Utilisation de scripts dans Bruno pour récupérer l'ID de l'utilisateur tout juste créé (`createdUserId`) et le réutiliser automatiquement dans la requête de mise à jour (PUT).
- Ajout des tests de login complets (cas passant, mauvais identifiant, mauvais mot de passe).

=== Tests d'API pour ModulationController
- Création des requêtes Bruno pour tester le module de modulation de (récupération, création, partage, mise à jour des statuts).
- Ajout des requêtes pour tester volontairement les erreurs (cas "KO") : champs manquants, erreurs de zonage, et offres inadaptées.

=== Restructuration de l'architecture Bruno
- Nettoyage des dossiers : j'ai séparé les anciens `smoke-tests` de la nouvelle suite de tests d'intégration.
- Création d'un dossier dédié `intégration` avec des sous-dossiers par contrôleur (`Modulation`, `NDoseController`, `User`). La hiérarchie est maintenant claire et permet de lancer les tests par module ciblé.

== Analyse et plan d'action
- *Bilan* : L'utilisation de variables dynamiques (timestamps, génération d'UUID en JS) rend nos tests autonomes. On peut les rejouer sans avoir à nettoyer la base de données manuellement. La nouvelle structure de dossiers rend le projet Bruno bien plus lisible (je l'espère) pour l'équipe.
- *Prochaine étape* : Continuer le portage pour les contrôleurs restants et s'assurer que ces dossiers d'intégration fonctionnent bien avec le nouveau fichier de configuration "integration.env" qui concentre tous les rôles.
#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]