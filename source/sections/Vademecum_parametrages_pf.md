Le paramétrage fonctionnel d’une plate-forme utilisant la solution logicielle Vitam
====

Pour pouvoir utiliser une plate-forme fonctionnant avec la solution logicielle Vitam, l’équipe chargée de son administration doit choisir ses orientations fonctionnelles et définir un certain nombre de paramètres qui sont enregistrés au moment du déploiement.
Cette fiche mentionne les points à étudier par l’administrateur fonctionnel et renvoie vers les fiches détaillées qui présentent les différents concepts et la formalisation attendue.


Définition du niveau de protection de la plate-forme (recommandé)
----
La solution logicielle Vitam permet de gérer des archives déclarant un niveau de protection au titre du secret de la défense nationale et de contrôler que des archives d’un niveau non autorisé ne lui sont pas transférées, afin de réduire tout risque de compromission.

Au moment du déploiement de la solution logicielle Vitam, il est recommandé de définir les niveaux de protection acceptés sur la plate-forme, notamment si celle-ci ne doit pas pouvoir prendre en charge des archives classifiées, afin de garantir une adéquation entre le niveau de protection de la plate-forme et le niveau de protection déclaré par les unités archivistiques.

La liste des niveaux de protection acceptés pourra être modifiée par la suite, mais il s’agira alors d’un acte d’exploitation technique nécessitant un arrêt des opérations en cours (entrées, éliminations, transferts…).

Vademecum lié : [La gestion des archives classifiées avec la solution logicielle Vitam](./Vademecum_classification.md)


Identification des besoins de cloisonnement des archives au sein de la plate-forme (recommandé)
----
La solution logicielle Vitam permet de cloisonner les archives prises en charge via des « espaces » distincts appelés « tenant ». Elle peut être utilisée sans cloisonnement (on parle alors de plate-forme « mono-tenant ») ou avec cloisonnements (on parle alors de plate-forme « multi-tenant »).

Il est recommandé de définir à l’installation de la plate-forme ce paramétrage. Il sera possible de rajouter des tenants par la suite, mais il s’agira alors d’un acte d’exploitation technique nécessitant un arrêt des opérations en cours (entrées, éliminations, transferts…).
Vademecum lié : [Les tenants dans la solution logicielle Vitam](./Vademecum_tenant.md)


Définition des stratégies de stockage (recommandé)
----
La stratégie de stockage est une configuration définissant le nombre de copies et les offres de stockage sur lesquelles ces copies seront faites.

La solution logicielle Vitam est déployée par défaut avec une seule stratégie de stockage et au moins deux offres de stockage.
Il est également possible de définir plusieurs stratégies de stockage pour répondre à des besoins spécifiques :
- proposer un nombre de copies à réaliser et donc des qualités de service différenciées en fonction d’une typologie (archives numérisées versus archives nativement numériques, archives d’un cabinet ministériel à conserver définitivement versus archives comptables à éliminer rapidement) ou d’un utilisateur applicatif dans le cas d’une plate-forme mutualisée ;
- isoler sur des offres spécifiques des archives en fonction de leur sensibilité (cas de l’hébergement des données de santé) ;
- stocker les fichiers numériques peu communiquées sur des offres dites « froides » (stockage sur bande par exemple) dans une optique de rationalisation des coûts.
L’utilisation de la solution logicielle Vitam en mode multi-stratégies nécessite :
- de déployer les stratégies additionnelles sur la plate-forme (acte technique d’exploitation),
- de définir les contrats de gestion déclarant les stratégies à utiliser
- d’associer ces contrats de gestion aux contrats d’entrée.
Vademecum lié : [Le contrat de gestion dans la solution logicielle Vitam](./Vademecum_contrat_gestion.md)


Définition des modalités de gestion des données de référence (obligatoire)
---
La solution logicielle Vitam utilise des données de référence afin de mettre en œuvre ses services en toute sécurité et de garantir une cohérence interne des données.
L’administrateur fonctionnel doit :
- identifier les sources des données de référence déjà administrées dans son environnement ou les outils métier déjà présents lui permettant d’élaborer ces référentiels ;
- dès lors qu’un référentiel externe est utilisé pour alimenter la solution logicielle Vitam (référentiels gérés dans le front-office commun aux archives physiques et électroniques ou dans des outils extérieurs à la plate-forme), définir avec l’administrateur technique les modalités de synchronisation de ces données entre la source externe et la version utilisée dans la plate-forme ;
- définir les modalités de gestion des identifiants des données de référence utilisées, sachant que la solution logicielle Vitam peut être paramétrée pour attribuer automatiquement un identifiant à certaines d’entre elles et que ce paramétrage n’est ensuite pas modifiable ;
- définir, pour les règles de gestion, une durée minimale acceptée pour chaque catégorie de règles, afin d’éviter des modifications malveillantes qui déclencheraient des actions indésirables sur la plate-forme.
Vademecum liés : [L’attribution des identifiants dans la solution logicielle Vitam](./Vademecum_identifiants.md), [Le référentiel des règles de gestion dans la solution logicielle Vitam](./Vademecum_referentiel_rg.md), [Le référentiel des services agents dans la solution logicielle Vitam](./Vademecum_referentiel_sa.md), [Le référentiel des formats dans la solution logicielle Vitam](./Vademecum_referentiel_formats.md), [L’ontologie dans la solution logicielle Vitam](./Vademecum_ontologie.md)


Définition de la structuration de l’information (recommandé)
----
La solution logicielle Vitam offre la possibilité de structurer de plusieurs manières l’information dans chaque espace cloisonné (tenant), afin de permettre un accès aux archives par une navigation dans une arborescence à laquelle sont rattachées les archives transférées : structuration thématique des archives produites par plusieurs services producteurs (« arbre de positionnement »), structuration organique des archives d’un service producteur (« plan de classement »). Ces deux types de structure peuvent se combiner.

Il est recommandé à l’administrateur fonctionnel de définir avant les premiers transferts la structuration qu’il compte adopter pour chacun des tenants : présence/absence de structuration, une seule structuration/plusieurs structurations, utilisation exclusive des arbres ou des plans/utilisation combinée des arbres et des plans.

Il est possible par la suite de modifier la structuration choisie au fur et à mesure de l’utilisation de la plate-forme, mais cette opération de modification de l’arborescence peut être lourde.
Vademecum liés : [L’arbre de positionnement dans la solution logicielle Vitam](./Vademecum_arbre.md), [Le plan de classement dans la solution logicielle Vitam](./Vademecum_plan.md)


Définition des habilitations (obligatoire)
---
La solution logicielle Vitam n’est accessible et utilisable que par des applications informatiques qui constituent ses seuls utilisateurs, même pour son administration. Il est obligatoire que ces applications soient authentifiées et habilitées pour interagir avec la plate-forme.

Au démarrage, la solution doit avoir un contexte applicatif et un profil de sécurité pour son administration (installation par défaut).

L’administrateur fonctionnel doit définir les droits des différentes applications, y compris l’application d’administration, en termes de fonctionnalités de la solution logicielle Vitam qu’elles seront autorisées à mobiliser (réaliser des entrées, réaliser des accès, réaliser des modifications de métadonnées, réaliser des éliminations, réaliser des actions de préservation, administrer les données de référence, réaliser des audits, accéder aux journaux, accéder au registre des fonds…). Ces droits seront formalisés dans un profil de sécurité.

Pour réaliser des entrées et des accès, chaque application devra en outre disposer de contrats d’entrée et d’accès dans lesquels l’administrateur fonctionnel pourra paramétrer finement les contrôles et les périmètres autorisés.

Les habilitations pourront évoluer (modification des paramètres, import de nouvelles habilitations…).

Vademecums liés : [La gestion des droits et permissions des utilisateurs applicatifs dans la solution logicielle Vitam](./Vademecum_habilitations.md), [Le contrat d’entrée dans la solution logicielle Vitam](./Vademecum_contrat_entree.md), [Le contrat d’accès dans la solution logicielle Vitam](./Vademecum_contrat_acces.md)


Définition de la fréquence de calcul de l’état des fonds symboliques* (facultatif)
----
La solution logicielle Vitam permet d’accéder à un état périodique des unités archivistiques, groupes d’objets techniques et objets techniques ayant été rattachés à un service producteur.

Par défaut, cet état est produit toutes les vingt-quatre heures.

Si l’administrateur fonctionnel souhaite suivre plus précisément les évolutions des fonds symboliques, il peut choisir de configurer la plate-forme pour produire plus fréquemment cet état.

Vademecum lié : [Le registre des fonds dans la solution logicielle Vitam](./Vademecum_registre_fonds.md)


Définition du niveau de contrôle des archives prises en charge (facultatif)
----
La solution logicielle Vitam permet de contrôler plus ou moins finement la structure et la description des archives qui lui sont transférées, afin de garantir la qualité des données et de permettre une restitution plus ou moins riche à l’accès. Par défaut, elle effectue un contrôle en utilisant les outils définis par le Standard d’échanges de données pour l’archivage (SEDA).

L’administrateur fonctionnel peut souhaiter décliner ou renforcer les contrôles minimaux des archives garantis par le SEDA en utilisant des outils de contrôle plus restrictifs (profil d’unité archivistique, profil d’archivage).

Ces contrôles peuvent être définis au démarrage de la plate-forme ou par la suite.

Vademecum liés : [L’ontologie dans la solution logicielle Vitam](./Vademecum_ontologie.md), [Le profil d’archivage dans la solution logicielle Vitam](./Vademecum_pa.md), [Le profil d’unité archivistique dans la solution logicielle Vitam](./Vademecum_pua.md)


Définition des modalités de mise en œuvre de la politique de préservation (facultatif)
-----
La solution logicielle Vitam permet de mettre en œuvre la politique de préservation d’une entité en définissant des stratégies de préservation qui mobiliseront des outils spécifiques en lien avec la solution logicielle Vitam (griffons).

L’administrateur fonctionnel peut définir des scénarios de préservation en fonction des formats de départ, des formats cibles, des actions à mettre en œuvre et des outils à utiliser. Il peut également lister les outils (griffons) à installer et à référencer dans le référentiels des griffons. L’installation de ces outils est un acte d’administration technique.

Vademecum liés : [La préservation dans la solution logicielle Vitam](./Vademecum_preservation.md), [Le référentiel des griffons dans la solution logicielle Vitam](./Vademecum_referentiel_griffons.md), [Le référentiel des scénarios de préservation dans la solution logicielle Vitam](./Vademecum_referentiel_preservation.md)

Définition de stratégies d’identification pérenne (facultatif)
----
Il est possible de définir des stratégies d’identification pérenne (type ARK uniquement) dans les contrats de gestion.

L’utilisation de ces stratégies nécessite d’associer ces contrats de gestion aux contrats d’entrée.

Vademecum lié : [Le contrat de gestion dans la solution logicielle Vitam](./Vademecum_contrat_gestion.md)

Définition des modalités d’indexation des règles de gestion des unités archivistiques (recommandé)
----
La solution logicielle Vitam permet d’indexer, sur demande, les règles de gestion applicables à une unité archivistique, qu’elle porte ces règles en propre ou qu’elle en hérite, afin de permettre aux plate-formes d’archivage de filtrer l’accès aux unités archivistiques en fonction des échéances des règles de gestion.

Cette indexation peut être plus ou moins riche en fonction du paramétrage adopté.

Par défaut, elle comprend :
- pour chaque catégorie de règle de gestion :
    - les propriétés associées à la catégorie de règle ;
    - l’échéance maximale applicable en application de la règle concernée. Par exemple, si une unité archivistique hérite de quatre règles de communicabilité et/ou les déclare, avec des échéances différentes (la 1ere ayant une échéance au 31/12/2010, la 2e au 31/12/2025, la 3e au 31/12/2025 et la 4e au 31/12/2050), l’échéance maximale pour le délai de communicabilité sera le 31/12/2050 ;
- la propriété relative au besoin d’autorisations pour gérer l’unité archivistique (champ NeedAuthorization du SEDA) ;
- la date de l’indexation.

Dans le cas où les paramétrages correspondants sont activés, l’indexation peut également comprendre :
- pour chaque catégorie de règles, les règles applicables et les échéances maximales applicables ;
- toutes les règles retournées en cas de demande d’accès à l’unité archivistique, avec notamment l’indication des unités archivistiques par lesquelles ces règles sont héritées.

Vademecum liés : [Positionner des règles de gestion dans la solution logicielle Vitam](./Vademecum_reglesgestion_fonctionnement.md), [Le calcul des héritages des règles de gestion et l’indexation des échéances dans la solution logicielle Vitam](./Vademecum_echeances.md)


Définition des modalités de versement des archives (facultatif)
----
La solution logicielle Vitam permet de verser des archives sous la forme de SIP structurés conformément au SEDA ou sous une forme plus ouverte au moyen du module de collecte, qui servira à structurer les archives en SIP et à les verser.

L’utilisation du module doit être définie à l’installation de la plate-forme. Son installation a posteriori relèvera d’un acte d’exploitation technique. En plus de cette action, il est possible de configurer la fréquence de suppression des archives versées depuis le module vers la solution logicielle Vitam, qui intervient par défaut toutes les heures.


Définition de services de recherche (facultatif)
----
La solution logicielle Vitam propose des services spécifiques liés à la recherche dans les archives :
- un service permettant de restituer le nombre exact d’archives correspondant à une recherche dans la solution logicielle Vitam ou dans le module de collecte, si ce nombre est supérieur à 10 000 éléments. Il est recommandé d’activer ce service au moment de l’installation de la plate-forme ;
- un service autorisant d’afficher des informations enregistrées dans certaines métadonnées. Par défaut, le nom des fichiers numériques est masqué ;
- un service permettant de rechercher des archives sur des seuils dépassant les seuils autorisés (mode « stream »). Par défaut, ce service ne peut être utilisé que :
    - trois fois par jour sur 1 million d’unités archivistiques ;
    - trois fois par jour sur 1 million de groupes d’objets techniques.

La modification des paramètres par défaut passe par un acte d’exploitation.

Définition des modalités d’export des DIP et SIP de transfert (facultatif)
----
La solution logicielle Vitam permet de générer des DIP et des SIP de transfert. Par défaut, ces exports sont purgés :
- au bout de sept jours si l’espace libre représente plus de 25% de l’espace de stockage,
- au bout d’une journée si l’espace libre de stockage représente moins de 25 % de l’espace de stockage.

Une limite en termes de taille d’export peut également être définie, pour l’ensemble de la plate-forme ou par tenant. Lors de l’installation de la plate-forme, elle est par défaut de 1 Go.

Il est possible de modifier ces paramètres au moyen d’un acte d’exploitation.

Vademecum lié : [Structuration de l’information](./Vademecum_structuration_information.md)

Personnalisation des rapports d’élimination (facultatif)
---
Il est possible d’ajouter des informations complémentaires dans les rapports d’élimination (identifiants métier, informations système) au moyen d’un paramétrage. Il est recommandé de les définir au moment du déploiement de la solution logicielle Vitam.

Vademecum lié : [Réaliser des éliminations avec la solution logicielle Vitam](./Vademecum_eliminations.md)