Les tenants dans la solution logicielle Vitam
===
La solution logicielle Vitam permet de cloisonner la plate-forme pour séparer les données de façon stricte et sécuriser les accès, de même que, dans un bâtiment d’archives, on peut choisir d’attribuer des magasins à des producteurs ou à des documents en particulier (fonds précieux, données sensibles) pour limiter physiquement les accès à ces archives. Ce cloisonnement s’opère en créant des espaces distincts appelés « tenants ».


Présentation du tenant
---
Un tenant correspond à une partition étanche de la plate-forme d’archivage. Les données conservées sur un tenant ne sont consultables que par les applications disposant de droits d’accès à ce tenant  (cf. contexte et contrat d’accès). De même, seules les applications habilitées peuvent réaliser une entrée sur un tenant donné (cf. contexte et contrat d’entrée).
Le tenant permet un cloisonnement (ou séparation logique) des archives. Ce n’est pas une séparation physique des offres de stockage.
Pour permettre une gestion fine adaptée aux besoins des utilisateurs, chaque tenant est paramétrable indépendamment des autres tenants de la plate-forme sur les aspects suivants :
- données de référence concernant les services ayant des droits sur les archives (référentiel des services agents),
- données de gestion du cycle de vie (référentiel des règles de gestion),
- paramétrage des entrées (contrat d’entrée),
- paramétrage des accès (contrat d’accès),
- paramétrage de gestion (contrat de gestion),
- modalités de structuration de l’information (arbre de positionnement),
- modalités de contrôle de la structure et de la description des archives transférées (référentiel des profils d’archivage, référentiel des profils d’unité archivistique*),
- modalités de mise en œuvre de la politique de préservation (référentiel des scénarios de préservation).

Configuration des tenants
----
Une plate-forme utilisant la solution logicielle Vitam peut fonctionner en mode mono-tenant ou multi-tenant. À l’installation de la plate-forme, l’administrateur fonctionnel doit donc décider le nombre de tenants à configurer.
Pour cela, il doit s’interroger sur ses besoins :
- aura-t-il besoin de disposer d’un « bac à sable » pour tester ou contrôler des entrées ?
- des garanties spécifiques doivent-elles être apportées à certains producteurs ou clients en termes d’isolation de leurs archives sur la plate-forme d’archivage ?
- des données sensibles seront-elles versées sur la plate-forme ? Si oui, nécessiteront-elles un cloisonnement d’avec les autres archives ?
- souhaitera-t-il séparer les archives intermédiaires des archives définitives en distinguant par exemple un tenant auxquels les services producteurs pourront se connecter en versement et en accès et un tenant où les accès ne se feront qu’à travers l’application des archivistes ?

L’utilisation de plusieurs tenants est recommandée dans les cas suivants :
- besoin de séparation des données des différents clients, par exemple pour un tiers-archiveur,
- besoin de cloisonnement de certaines catégories de données,
- besoin de cloisonnement fonctionnel entre la pré-production et la production.

Il est recommandé de disposer sur une plate-forme multi-tenant d’un tenant dédié à l’administration des habilitations et des référentiels valables sur toute la plate-forme (référentiels trans-tenants comme le référentiel des formats, l’ontologie ou le référentiel des griffons). Les opérations de mise à jour de ces référentiels seront valables pour toute la plate-forme, mais ne seront journalisées que sur ce tenant d’administration.
Cela permet de restreindre les modifications impactant toute la plate-forme aux seuls utilisateurs applicatifs accédant au tenant d’administration.


Inconvénients de la gestion d’un trop grand nombre de tenants sur une même plate-forme
---
La configuration de plusieurs tenants a des conséquences techniques et organisationnelles à évaluer avant de fixer le nombre de tenants à configurer.

### Conséquences techniques
- performance : il y aura autant d’opérations de sécurisation sur la plate-forme que de tenants, ce qui peut ralentir les performances ;
- stockage : multiplier les tenants multiplie le nombre de conteneurs créés sur les offres de stockage.
Ces conséquences techniques sont valables même en l’absence d’entrée d’archives sur le tenant.

### Conséquences organisationnelles
- administration fonctionnelle : certains référentiels n’étant valables que sur un tenant donné, il conviendra de gérer autant de ces référentiels mono-tenants qu’il y a de tenants, tout en veillant à la cohérence globale des référentiels trans-tenants (cas de l’ontologie qui doit référencer l’ensemble des vocabulaires utilisés sur les différents tenants) ;
- capacité des utilisateurs applicatifs à verser et à accéder aux données : les interactions d’une application avec la plate-forme en versement et en accès sont limitées aux tenants qui sont autorisés dans son contexte ; ainsi, si une application doit pouvoir accéder aux archives de plusieurs tenants, il lui faudra autant de contrats d’accès que de tenants auxquels elle doit accéder et il en va de même pour les contrats d’entrée pour réaliser des versements ; c’est pourquoi il est conseillé de ne pas séparer plus que strictement nécessaire les archives d’un même producteur sur plusieurs tenants si on ne souhaite pas devoir gérer pour ce producteur un trop grand nombre de contrats.

Dans un contexte où de nombreuses applications sont connectées à la solution logicielle Vitam, il est recommandé de n’associer qu’un seul tenant au contexte applicatif de chaque application pour éviter de démultiplier les tenants auxquels elle a accès et ainsi préserver le cloisonnement des données.


Formalisation des tenants
---
Les tenants se configurent à l’installation de la plate-forme. Cette opération est réalisée par l’administrateur technique.
Il sera possible par la suite d’ajouter des tenants, mais il s’agit d’un acte d’exploitation technique qui nécessitera un arrêt des opérations en cours (versements, éliminations, transferts…).

Pour en savoir plus, consulter la [documentation d’installation](http://www.programmevitam.fr/ressources/DocCourante/html/installation/).