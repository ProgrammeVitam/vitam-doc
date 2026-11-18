Le registre des fonds dans la solution logicielle Vitam
====


Le registre des fonds fournit une vision globale des archives sous la responsabilité des services producteurs.
Il permet également de suivre les évolutions des archives prises en charge, en fonction des traitements qui sont effectués sur celles-ci (élimination).


Présentation du registre des fonds
---

### Périmètre du registre des fonds
Le registre des fonds est constitué par tenant.

Si un même service producteur effectue des entrées sur plusieurs tenants, il aura un registre des fonds sur chacun des tenants concernés.

### Constitution du registre des fonds
Dès lors qu’une opération d’entrée de plan de classement ou d’unités archivistiques standard a été effectuée au nom d’un service producteur, un registre des fonds est créé pour ce service producteur.

Le service producteur pris en compte est celui qui est déclaré dans le bloc <ManagementMetadata> pour l’ensemble du versement.

Les services producteurs déclarés dans la description des unités archivistiques ne sont pas pris en compte pour alimenter le registre des fonds.

### Structuration du registre des fonds
Le registre des fonds est structuré en trois parties :
- un état global actualisé des fonds sous la responsabilité directe du service producteur,
- un état périodique global des fonds qui lui ont été rattachés,
- une liste des entrées effectuées par le service producteur et des opérations de préservation effectuées sur les archives prises en charge, actualisée à la suite des traitements effectués.


Distinction entre fonds propres et fonds symboliques
---
La solution logicielle Vitam distingue les fonds propres, c’est-à-dire les entrées faites par un service producteur, des fonds symboliques, c’est-à-dire les unités archivistiques qui lui ont été rattachées, que ce soit au moment du transfert ou par suite d’une modification d’arborescence.

En cas de rattachement d’une unité archivistique, le ou les services producteurs des unités auxquelles elle est rattachée sont propagés dans les métadonnées de l’unité archivistique rattachée, ce qui permet de leur donner des droits d’accès sur cette unité archivistique (cf. contrat d’accès).

Ainsi, en cas de transfert par un bureau d’unités archivistiques qui doivent être rattachées au plan de classement de sa direction, seront mis à jour dans le registre des fonds à la fois le fonds du bureau et celui de la direction. Le bureau ayant effectué l’entrée sera cependant considéré comme le seul service producteur responsable des archives transférées.


Suivi des fonds propres dans le registre des fonds
---
### Vue générale
Le registre des fonds permet de disposer d’un état global actualisé des fonds propres d’un producteur.
Sont indiqués :
- le nombre total d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie transférés au titre de ce service producteur,
- le nombre d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie ayant été supprimés (en raison d’une opération d’élimination),
- le nombre d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie restant.

### Vue détaillée par entrée
Le registre des fonds offre également une vue par entrées, actualisées en fonction des traitements effectués.
Pour chaque entrée, sont présents :
- la date du premier transfert, la date du dernier transfert, la date de dernière modification de l’entrée,
- les identifiants du service producteur et du service versant,
- le statut juridique des archives et les modalités juridiques du transfert,
- l’identifiant du contrat d’entrée et du profil d’archivage éventuellement utilisé,
- le nombre d’unités archivistiques, de groupes d’objets techniques et d’objets techniques et la volumétrie pour cette entrée, avec indication du nombre et de la volumétrie :
- des entités prises en charge lors du transfert initial,
- des entités de cette entrée sorties de la responsabilité de la solution logicielle Vitam depuis leur prise en charge (en raison d’une opération d’élimination par exemple),
- des entités actuellement sous la responsabilité de la solution logicielle Vitam,
- le statut de l’entrée (en stock et complète, en stock et mise à jour, sortie du stock),
- les identifiants des opérations ayant eu un impact sur l’entrée,
- le détail des opérations ayant eu un impact sur l’entrée avec la volumétrie associée.


Suivi des fonds symboliques dans le registre des fonds
---
### Vue générale
Le registre des fonds permet de disposer d’un état global périodique des fonds symboliques d’un service producteur.

Sont indiqués :
- le nombre total d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie transférés au titre de ce service producteur,
- le nombre d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie ayant été supprimés (en raison d’une opération d’élimination),
- le nombre d’unités archivistiques, de groupes d’objets techniques, d’objets techniques et leur volumétrie restant.

L’état global est calculé toutes les vingt-quatre heures, sauf paramétrage différent de la plate-forme.

### Historique des rattachements
La solution logicielle Vitam offre la possibilité de consulter les états des fonds symboliques sur une période donnée, pour suivre les variations de ces fonds.

Si entre deux calculs de l’état global des fonds symboliques pour un service producteur trois unités archivistiques sont rattachées au service producteur considéré, une est éliminée et deux sont détachées, l’état global calculé suivant ignorera ces variations qui n’apparaîtront pas dans l’historique des rattachements.


Pour en savoir plus, consulter le [document VITAM. Services producteurs](./services_prod.md).