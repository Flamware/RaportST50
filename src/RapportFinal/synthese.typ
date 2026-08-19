#text(fill: rgb("4a90e2"))[= Synthèse et Bilan]

== Bilan technique et résultats obtenus
L'ensemble des objectifs fixés au début du stage a été atteint, apportant des améliorations mesurables sur le projet Farmstar :
- *Intégration Continue (CI/CD) :* Temps d'exécution moyen du build backend réduit d'environ 51% sur GitLab CI (de 35 min à 17 min en moyenne), et build local accéléré de 17 min à 3 min grâce à un taux d'utilisation du cache Spring de 99,5%.
- *Tests Frontend :* Suite de smoke tests Playwright 3 fois plus rapide que Cypress (1 min 45 s vs 5 min 28 s).
- *Qualité du code :* Interception des régressions avant la CI via des hooks Git `pre-commit` et `pre-push` ciblés sur les fichiers modifiés.
- *R&D IA Agentique :* Prototype d'orchestrateur multi-agents fonctionnel (voir Axe 2), passé d'une expérimentation isolée sous Open WebUI à une architecture LangGraph coordonnée.

== Estimation des gains pour l'entreprise

=== Gain de temps sur l'intégration continue
La pipeline GitLab CI s'exécute en moyenne 2 fois par jour pour l'ensemble de l'équipe. Le gain de temps constaté sur le pipeline GitLab CI (voir ci-dessus) représente un gain brut de 18 minutes de temps d'attente par run. Ce temps n'étant pas intégralement improductif (les développeurs peuvent avancer sur d'autres tâches pendant l'exécution), un coefficient d'atténuation de 20 à 30% est appliqué, reflétant le coût résiduel de changement de contexte plutôt qu'une valorisation à 100% du temps d'attente.

#table(
  columns: (2fr, 1.5fr, 1.5fr),
  align: (left, left, left),
  [*Hypothèse*], [*Gain net/jour (équipe)*], [*Gain annuel estimé*],
  [Basse (20%)], [7,2 min], [≈ 811 €],
  [Haute (30%)], [10,8 min], [≈ 1216 €],
)

Calcul basé sur un coût horaire chargé moyen de 31 €/h (salaire brut annuel moyen de 35 000 €, un chiffre conservateur pour un ingénieur en développement logiciel/IA, coefficient de charges patronales de 1,42, base légale de 1607 h/an) et 218 jours ouvrés/an.

=== Coût d'exploitation vs abonnement IA classique
Sur la base d'une consommation électrique mesurée de 110 € sur 3 mois par personne (≈ 37 €/mois/personne, ≈ 220 €/mois pour l'équipe), le coût d'exploitation d'une infrastructure IA locale n'est *pas* inférieur à celui d'un abonnement SaaS équivalent. Tarifs officiels vérifiés en août 2026 (facturation annuelle, conversion 1€ ≈ 1,16\$) pour 6 sièges : GitHub Copilot Business à 19\$/utilisateur/mois (≈ 98 €/mois équipe), ChatGPT Business à 20\$/utilisateur/mois (≈ 104 €/mois équipe), Claude Team Standard à 20\$/siège/mois (≈ 104 €/mois équipe) — jusqu'à ≈ 129 €/mois équipe en facturation mensuelle pour ces deux derniers. L'électricité seule (≈ 220 €/mois) coûte donc plus cher que n'importe lequel de ces abonnements. L'argument économique en faveur de la solution locale ne repose donc pas sur le coût direct, mais sur la souveraineté des données (Farmstar étant un projet Airbus Defense and Space, incompatible avec l'envoi de code propriétaire vers un tiers externe), l'absence de coût marginal croissant avec le nombre d'utilisateurs, et la personnalisation complète de l'outillage (serveurs MCP internes, skills Farmstar) impossible avec un SaaS générique.

=== Axe R&D IA agentique
Sur la période dédiée à cet axe (24 avril – 24 juillet 2026, soit 91 jours), la consommation électrique de l'infrastructure IA locale est estimée entre 110 € et 150 €, soit entre 440 et 600 kWh (base 0,25 €/kWh) — entre 846 W et 1154 W en usage concentré sur les heures de bureau, ou entre 202 W et 275 W si le serveur tourne en continu. Le périmètre actuel du PoC ne permet pas encore une estimation financière fiable du gain de temps ; extrapoler un gain reviendrait à valoriser une solution encore expérimentale comme si elle était industrialisée. Cette mesure constitue l'un des axes de travail identifiés en perspectives.

=== Autres bénéfices qualitatifs
- *Réduction des coûts d'infrastructure :* La baisse de la durée des jobs GitLab CI réduit directement le temps de calcul des runners.
- *Pérennité du Code :* La standardisation des pratiques de tests et les guides rédigés sur le wiki garantissent une baisse durable de la dette technique.

== Bilan personnel
Ce stage de fin d'études a été une expérience d'ingénieur complète. Sur le plan technique, il m'a permis d'approfondir mes connaissances des entrailles de Spring Boot, du scripting CI/CD avancé, et des architectures émergentes d'IA agentique (LangGraph, MCP). Sur le plan méthodologique, j'ai développé ma capacité à mener des audits de performance, à prendre des décisions d'architecture en autonomie, et à communiquer mes choix à travers des présentations techniques et de la documentation.