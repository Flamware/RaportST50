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

#text(size: 0.9em)[Date : 4 mars 2026]
]
)

#v(1em)
#line(length: 100%, stroke: 1pt)

#align(center)[
#text(weight: "bold", size: 1.5em)[Fiche d'Activité : Présentation des tests et correctifs API]
]

== Travaux réalisés
Aujourd'hui, j'ai travaillé sur la documentation visuelle de la stratégie de test et affiné le paramétrage des requêtes sur l'API.

=== Création de supports de présentation (PowerPoint)

* Conception des slides illustrant la stratégie des tests d'intégration et leur architecture.
* Mise en valeur de l'approche par scénarios métiers (Modulation, Ingestion) et de l'isolation des jeux de données (fichiers réels ZIP, environnements).

=== Ajustement des Smoke Tests et debug

* Nettoyage du contexte des rôles dans les smoke tests Bruno : les requêtes ne tournent plus qu'avec les rôles minimaux strictement nécessaires pour obtenir un retour HTTP 200.
* Résolution d'une erreur 400 (`HttpMessageNotReadableException`) sur la route `/fs-core/api/parcels/searchByFilter` en remplaçant un tableau par un objet JSON dans le corps de la requête pour matcher avec le DTO Spring.

== Analyse et plan d'action

* *Bilan* : Les tests d'API sont maintenant plus précis au niveau des droits d'accès, et le support visuel pour expliquer l'architecture de test est prêt.
* *Prochaine étape* : Présenter l'avancement sur la partie intégration et continuer à implémenter de nouveaux scénarios métiers dans Bruno.

#v(2em)
#line(length: 100%, stroke: 0.5pt)

#v(1fr)
#text(size: 0.8em, style: "italic")[Document technique - Journal de bord ST50 - Magellium]