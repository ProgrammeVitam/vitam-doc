Le calcul des héritages des règles de gestion et l’indexation des échéances dans la solution logicielle Vitam
===

La solution logicielle Vitam offre des fonctionnalités de calcul des règles de gestion applicables à une unité archivistique, que celle-ci porte la règle en propre ou en hérite, et d’indexation des échéances calculées par catégorie de règles.

L’indexation des échéances facilite les recherches d’unités archivistiques en fonction des règles qui leur sont applicables.


Présentation du calcul des héritages des règles de gestion
---
### L’enregistrement à l’entrée des échéances applicables à une unité archivistique
Lors du processus d’entrée, la solution logicielle Vitam enregistre en base les règles portées en propre par une unité archivistique (c’est-à-dire les règles déclarées pour cette unité archivistique dans le bordereau de transfert) et l’échéance de cette règle si la date de départ de son calcul est connue.

Les unités archivistiques qui ne déclarent pas de règle de gestion n’ont pas de règles en base.

Lorsque les règles applicables à un transfert ont été déclarées dans le bloc ManagementMetadata, seules les unités archivistiques à la racine du bordereau de transfert porteront ces règles en base.


### Le calcul à la consultation des règles et des échéances applicables à une unité archivistique
Lors d’une demande de consultation des métadonnées d’une unité archivistique, la solution logicielle Vitam retourne :
- les règles déclarées par cette unité archivistique, y compris l’échéance de la règle si la date de départ de son calcul est connue ;
- toutes les règles que l’unité archivistique hérite de ses parents, dans toutes les catégories de règles, avec leur échéance, sauf si l’héritage de ces règles a été bloqué, à l’entrée ou à l’occasion d’une modification des métadonnées de gestion.


### Le calcul à la mise en œuvre d’une opération de gestion des règles et des échéances applicables à une unité archivistique : le cas de l’élimination
Lors du lancement d’une analyse d’élimination ou d’une opération d’élimination, la solution logicielle Vitam calcule les règles de durée d’utilité administrative applicables aux unités archivistiques faisant l’objet de l’opération, que ces unités archivistiques portent ces règles en propre ou en hérite.
Les conflits (héritage de sorts finaux contradictoires) sont retournés à l’utilisateur applicatif pour permettre un traitement humain.

Pour en savoir plus, consulter le [vademecum Réaliser des éliminations avec la solution logicielle Vitam](./Vademecum_eliminations.md).


### Le calcul sur un ensemble donné avec indexation des résultats
La solution logicielle Vitam offre la possibilité d’indexer les résultats du calcul des règles applicables à un ensemble d’unités archivistiques donné.
Selon le paramétrage de la plate-forme, cette indexation sera plus ou moins riche (cf. fiche Le paramétrage fonctionnel d’une plate-forme utilisant la solution logicielle Vitam).

#### Indexation des échéances par catégorie de règles
Pour chaque unité archivistique, sont indexées :
- les propriétés de chaque catégorie de règle (ex : sort final, niveau de classification) ;
- les attributs propres au gel (ex : date de réévaluation du gel) ;
- l’échéance maximale applicable à chaque catégorie de règle (ex : la date de libre communicabilité la plus éloignée dans le temps) ;
- les propriétés globales de gestion applicables à l’unité archivistique (nécessité ou non de demander une autorisation pour effectuer des actions de gestion).

Si une unité archivistique hérite de propriétés contradictoires (par exemple, une de ses unités archivistiques parentes a déclaré comme sort final « conserver » et une autre « détruire »), les deux valeurs héritées seront présentes dans l’indexation.
Si une unité archivistique déclare ou hérite une règle sans date de départ associée pour le calcul de l’échéance, la solution logicielle ne pourra pas indexer d’échéance pour cette catégorie de règle.

#### Indexation des échéances par règle au sein de chaque catégorie
Pour chaque unité archivistique, sont indexées :
- les propriétés de chaque catégorie de règle (ex : sort final, niveau de classification) ;
- les attributs propres au gel (ex : date de réévaluation du gel) ;
- l’échéance maximale applicable à chaque catégorie de règle (ex : la date de libre communicabilité la plus éloignée dans le temps) ;
- les échéances maximales applicables, dans chaque catégorie de règle, à chaque règle en particulier (ex. : la date de libre communicabilité en fonction de la règle A et celle en fonction de la règle B) ;
- les propriétés globales de gestion applicables à l’unité archivistique (nécessité ou non de demander une autorisation pour effectuer des actions de gestion).

Si une unité archivistique déclare ou hérite une règle sans date de départ associée pour le calcul de l’échéance, la solution logicielle ne pourra pas indexer d’échéance pour cette catégorie de règle.

#### Indexation de toutes les informations disponibles concernant les règles de gestion applicables
Pour chaque unité archivistique, sont indexées, en plus de l’indexation des échéances par règle, l’ensemble des informations relatives aux règles de gestion qui lui sont applicables : 
- pour chaque catégorie de règle, les règles applicables, le cas échéant avec leur date de départ et leur date de fin, le chemin d’héritage de la règle (les nœuds par lesquels la règle est héritée) et les propriétés associées ;
- les propriétés globales de gestion (nécessité ou non de demander une autorisation pour effectuer des actions de gestion).

Si une unité archivistique déclare ou hérite une règle sans date de départ associée pour le calcul de l’échéance, cette règle sera indexée.


Modalités de calcul des héritages avec indexation des échéances
---
### À la demande
La solution logicielle Vitam permet de calculer les règles applicables à une ou plusieurs unités archivistiques et d’indexer les échéances associées à la demande.
Le résultat des l’indexation à la demande est immédiatement disponible.


### En entrée
La solution logicielle Vitam permet de paramétrer le contrat d’entrée pour spécifier si les unités archivistiques entrées en déclarant ce contrat doivent faire l’objet d’un calcul des héritages avec indexation des échéances.
Si ce paramétrage est activé, les unités archivistiques sont marquées lors du processus d’entrée pour que l’indexation de leurs échéances soit réalisée par traitement automatique programmé (batch). Le résultat de l’indexation n’est donc pas immédiatement disponible.


Utilisation de l’indexation des échéances en recherche et en accès
---
### Recherche
L’indexation des échéances permet de faire des requêtes sur les unités archivistiques en fonction des règles qui leur sont applicables.
On peut par exemple rechercher :
- toutes les unités archivistiques qui deviendront librement communicables entre telle date et telle date ;
- toutes les unités archivistiques librement réutilisables à une date donnée ;
- toutes les unités archivistiques auxquelles s’applique une règle donnée (si l’indexation a été faite par règle au sein de chaque catégorie).


### Accès
L’indexation des échéances peut être utilisée en accès si le paramétrage correspondant est activé dans le contrat d’accès.
En ce cas, les résultats remontés à l’utilisateur sont filtrés pour ne lui donner accès qu’aux unités archivistiques dont l’échéance pour la(les) catégorie(s) de règle de gestion concernée(s) est dans le passé par rapport à la date de la requête.

Le filtre s’applique uniquement aux échéances indexées. Ainsi, si une unité archivistique porte en propre une règle de communicabilité échue, mais qu’elle n’a pas fait l’objet d’une indexation des échéances, elle ne sera pas accessible avec un contrat d’accès filtrant sur la règle de communicabilité.
Les unités archivistiques d’arbre, qui ne portent pas de règles de gestion, ne sont pas consultables si ce filtre est utilisé.


Invalidation des échéances calculées
---
L’indexation des échéances est automatiquement invalidée dans les cas suivant :
- mise à jour des métadonnées de gestion d’une unité archivistique ;
- mise à jour du référentiel des règles de gestion ;
- reclassement (modification d’arborescence) d’une unité archivistique.

Dans le cas de la mise à jour d’une unité archivistique, l’invalidation la concerne, ainsi que toutes les unités archivistiques situées dans sa descendance et ayant fait l’objet d’une indexation.
Dans le cas de la mise à jour du référentiel des règles de gestion, seules sont concernées par l’invalidation les unités archivistiques indexées déclarant une règle modifiée, ainsi que toutes les unités archivistiques situées dans leur descendance et ayant fait l’objet d’une indexation.
Dans le cas du reclassement d’une unité archivistique, l’invalidation concerne l’unité détachée ou rattachée à un nouveau parent, ainsi que toutes les unités archivistiques situées dans sa descendance et ayant fait l’objet d’une indexation.

L’indexation invalidée sera recalculée par traitement automatique programmé (batch).


Suppression des échéances calculées
---
La suppression de l’indexation des unités archivistiques peut être lancée sur requête par une application utilisant la solution logicielle Vitam.


Pour en savoir plus, consulter le [document VITAM. Règles de gestion](./regles_gestion.md).