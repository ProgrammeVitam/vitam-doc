L’attribution des identifiants dans la solution logicielle Vitam
====
Les données de référence utilisées dans la solution logicielle Vitam peuvent être identifiées de deux façons différentes :
- les données de référence peuvent disposer d’une identification fournie par un système externe lors de leur import dans la solution logicielle Vitam. Ces identifications sont prises en compte par la solution logicielle Vitam qui gère alors ces données de référence en mode « esclave » ;
- les données de référence ne disposent pas d’une identification fournie par un système externe lors de leur import dans la solution logicielle Vitam. Des identifications sont alors attribuées par la solution logicielle Vitam qui gère alors ces données de référence en mode « maître ».

Gestion des identifiants pour les différents référentiels
----
Certaines données de référence sont obligatoirement gérées en mode « esclave », d’autres en mode « maître ». Pour d’autres enfin, le choix est laissé à l’administrateur fonctionnel.
Le tableau ci-dessous présente les modes de gestion autorisés.

|Référentiels|Vitam en mode « Maître »|Vitam en mode « Esclave »|
|:----|:-----:|:-----:|
|Formats||X|
|Règles de gestion||X|
|Contextes applicatifs|X|X|
|Profils de sécurité|X|X|
|Contrats d’entrée|X|X|
|Contrats d’accès|X|X|
|Profils d’unité archivistique|X|X|
|Ontologies||X|
|Profils d’archivage|X|X|
|Services agents||X|
|Griffons||X|
|Scénarios de préservation||X|
|Contrats de gestion|X|X|

Pour sept référentiels, le choix est donc laissé à l’administrateur de la solution logicielle Vitam de gérer les données de référence en mode « maître » ou « esclave ».


Critères de choix du mode « maître » ou « esclave » quand un choix est possible
---
Un référentiel doit être utilisé en mode « esclave » lorsque l’identification des objets métier (service agent, règle de gestion, contrat d’entrée ou d’accès…) qu’il référence est opérée à l’extérieur du système, par exemple dans un référentiel commun à plusieurs systèmes ou dans un référentiel commun aux archives physiques et électroniques.

Les informations transmises à la solution logicielle Vitam sont alors pilotées par le système externe qui attribue les identifiants aux divers objets métier.

Ce mode « esclave » permet à un service de conserver la main sur les identifiants des objets métier pour utiliser des identifiants normés au niveau de l’institution et/ou à un niveau national ou international.

Un référentiel doit être utilisé en mode « maître » lorsqu’il n’y a pas de besoin de coordination des informations des référentiels utilisés par la solution logicielle Vitam avec des référentiels externes. C’est alors la solution logicielle Vitam qui donne ses identifiants aux divers objets métier.


Configuration du mode « maître » ou « esclave » quand un choix est possible
---
La configuration des référentiels en mode « maître » ou « esclave » doit être faite par l’administrateur technique à l’installation de la plate-forme.

Le choix se fait tenant par tenant pour chacun des référentiels pour lequel un choix est possible.
Le fichier de configuration se présente comme suit (exemple fictif) :
```
#  ExternalId configuration

listEnableExternalIdentifiers :
0 : 
- INGEST_CONTRACT
- ACCESS_CONTRACT
1 :
- INGEST_CONTRACT
- ACCESS_CONTRACT
- PROFILE
- SECURITY_PROFILE
- CONTEXT
```
Dans cet exemple, sur le tenant 0 les contrats d’entrée et les contrats d’accès sont en mode « esclave », sur le tenant 1, les contrats d’entrée, les contrats d’accès, les profils d’archivage, les profils de sécurité et les contextes sont en mode « esclave ».

Un exemple du fichier de configuration se trouve dans la documentation d’exploitation au chapitre « Exploitation des composants de la solution logicielle Vitam ».


Mise à jour des référentiels en mode « esclave »
---
Lorsque le référentiel utilisé dans la solution logicielle Vitam n’est qu’un extrait d’un référentiel plus riche piloté depuis un autre outil (ex. : référentiel producteurs d’un système d’information archivistique), il convient de penser les modalités de répercussion des mises à jour du référentiel « maître » sur le référentiel « esclave » de la solution logicielle Vitam : ces mises à jour seront-elles déclenchées automatiquement à chaque mise à jour du référentiel « maître » ? Par l’administrateur fonctionnel en réponse à une alerte quotidienne ou hebdomadaire ?

Dans certains cas (référentiel des services agents, référentiel des règles de gestion, ontologie, griffons, scénarios de préservation, services agents), la mise à jour dans la solution logicielle Vitam se fait par un ré-import du référentiel complet et non une mise à jour unitaire.