Le contrat de gestion dans la solution logicielle Vitam
=======


Le contrat de gestion permet de définir sur un tenant* une stratégie de stockage spécifique, voire de mettre en place une stratégie différenciée pour les unités archivistiques, les groupes d’objets techniques et les objets techniques (fichiers numériques), ainsi qu’une stratégie d’identification pérenne.

Le contrat de gestion est déclaré dans un contrat d’entrée* et s’applique aux objets métiers entrés en déclarant ce contrat d’entrée.


Présentation du contrat de gestion
-----

### Périmètre du contrat de gestion
Un contrat de gestion est propre au tenant* sur lequel il a été importé.

### Paramétrage du contrat de gestion
Un contrat de gestion permet de déclarer une stratégie de stockage spécifique.

Si le système utilise plusieurs stratégies de stockage, il est obligatoire de créer autant de contrats de gestion qu’il y a de stratégies envisagées.

Il est recommandé de déclarer la même stratégie de stockage pour les métadonnées des unités archivistiques et des groupes d’objets techniques, afin de ne pas rompre la cohérence du stockage des données.

Il est possible de déclarer une stratégie différente pour, d’un côté, les métadonnées des unités archivistiques et des groupes d’objets techniques et, de l’autre, les objets binaires.

Le contrat de gestion permet également de déclarer des stratégies d’identification pérenne, de type ARK uniquement.

### Association du contrat de gestion à un contrat d’entrée
Un contrat de gestion peut être déclaré dans un contrat d’entrée pour être utilisé lors de l’exécution d’un processus d’entrée dans la solution logicielle Vitam.

Si les stratégies spécifiques définies dans le contrat de gestion sont valides, ces stratégies seront utilisées lors du stockage des métadonnées des unités archivistiques et des groupes d’objets techniques et de leur journal du cycle de vie et des objets techniques (fichiers).

Si le contrat de gestion déclare une stratégie d’identification pérenne, alors cette stratégie sera appliquée aux unités archivistiques et/ou aux objets versés.

La déclaration d’un contrat de gestion dans un contrat d’entrée n’est pas obligatoire dès lors que l’on ne souhaite pas utiliser une stratégie de stockage spécifique pour les unités archivistiques, groupes d’objets techniques et objets techniques entrés en déclarant ce contrat d’entrée ou une stratégie d’identification pérenne. Par défaut, c’est la stratégie configurée lors de l’installation de la plate-forme qui sera utilisée.


Configuration du contrat de gestion
----

### Définition d’une ou plusieurs stratégies de stockage et constitution du contrat de gestion
La solution logicielle Vitam est déployée par défaut avec une seule stratégie de stockage et au moins deux offres de stockage.
Cependant, l’administrateur fonctionnel peut souhaiter définir des stratégies de stockage différenciées pour répondre à des considérations :
- de coûts en limitant le nombre de copies et d’offres,
- de gestion des risques en mettant à disposition davantage de copies pour des données dont on veut garantir à tout prix la pérennité et moins de copies pour des documents éliminables à court terme,
- de sensibilité des fichiers, par exemple en orientant les données de santé vers une offre de stockage spécifique,
Il est ainsi possible d’offrir une qualité de service différente en fonction :
- des besoins d’accès (déporter sur des offres froides des objets binaires peu consultés et conserver les objets très consultés sur des offres chaudes),
- des typologies d’archives, en proposant par exemple moins de copies pour les archives numérisées que pour les archives nativement numériques,
- des contrats passés avec les utilisateurs dans un contexte de tiers-archivage.

L’administrateur fonctionnel doit ainsi définir ses besoins en termes de stockage (quelles offres de stockage utiliser ? combien d’offres ? de copies ? de stratégies de stockage ?) pour permettre, le cas échéant, à l’administrateur technique de configurer une à plusieurs stratégies de stockage.

Pour en savoir plus sur la définition des stratégies de stockage, consulter le document Vitam. Gestion de multiples stratégies de stockage.

### Constitution du contrat de gestion
La création d’un contrat de gestion n’est pas obligatoire quand une seule stratégie de stockage est utilisée au sein de la solution logicielle Vitam.
En revanche, quand on souhaite assurer un stockage particulier, différent de la stratégie par défaut, pur un type d’archives en particulier, que ce soit des unités archivistiques, des groupes d’objets techniques et/ou des objets techniques, il est nécessaire de créer un contrat de gestion.

La création de contrats de gestion peut intervenir à différents moments :
- lors de l’initialisation de la plate-forme : 
    - si l’on souhaite mettre en place différents niveaux de service de stockage en définissant plusieurs stratégies de stockage, en plus de la stratégie par défaut, il est recommandé de créer des contrats de gestion utilisant ces différentes stratégies de stockage, correspondant à autant de niveaux de service ;
    - si l’on souhaite définir une à plusieurs stratégies d’identification pérennes, il est recommandé de  créer des contrats de gestion utilisant ces différentes stratégies ;
- lors de l’intégration d’une nouvelle application requérant un stockage particulier, différent de la stratégie de stockage par défaut, et/ou une stratégie d’identification pérenne spécifique.

### Gestion de l’identifiant du contrat de gestion
À l’installation de la plate-forme Vitam, l’administrateur technique peut configurer le tenant pour que les identifiants des contrats de gestion soient générés par Vitam (**mode « maître* »**) ou par le front-office (**mode « esclave* »**).

Le mode « esclave » permet à un service de conserver la main sur les identifiants des contrats d’entrée pour utiliser des identifiants normés au niveau de l’institution et/ou à un niveau national ou international.

### Formalisation du contrat de gestion
Un contrat de gestion prend la forme d’un fichier JSON, pouvant contenir 1 à n contrat(s) de gestion.

Un contrat de gestion donné doit **obligatoirement** comporter les informations suivantes :
- identifiant signifiant. Ce champ est obligatoire seulement s’il est généré par l’application à l’origine de sa création. Si cet identifiant est généré par la solution logicielle Vitam, il n’est pas nécessaire de le renseigner dans le fichier JSON ;
- nom du contrat.
D’autres informations, facultatives, peuvent venir compléter ces informations.

Le contrat de gestion est composé des éléments suivants :

- Éléments obligatoires
    - identifiant unique donné au contrat, sauf s’il est généré automatiquement par le système
    - nom du contrat
    - statut « Actif » ou « Inactif » ; par défaut, la valeur est « INACTIVE »
- Éléments facultatifs
    - description du contrat
    - statut du contrat
    - si le contrat est inactif, date de désactivation du contrat
    - date d’activation
    - définition de la gestion du stockage
    - définition de la stratégie d’identification pérenne

Pour plus d’informations, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).

Il est possible d’importer en une seule fois un référentiel complet, comprenant plusieurs notices décrivant chacune un contrat de gestion. La solution logicielle Vitam ne comptabilisera qu’une seule opération et ne prendra pas en compte dans le journal des opérations la création unitaire des différents items compris dans le référentiel importé.

Afin d’optimiser la traçabilité de la création des contrats de gestion, il est recommandé de les importer un par un.

### Activation/désactivation du contrat de gestion
Un contrat de gestion peut être importé avec un statut inactif ou être désactivé lors d’une mise à jour du contrat.

Cette fonctionnalité est utile quand on souhaite créer un contrat de gestion et l’importer avant d’autoriser des applications à l’utiliser ou lorsqu’on souhaite désactiver temporairement ou définitivement un contrat de gestion.

Un contrat de gestion au statut inactif ne permet pas de réaliser une entrée avec le contrat d’entrée auquel il est associé.


### Modification d’un contrat de gestion

Les contrats de gestion peuvent être modifiés unitairement pour permettre d’activer ou de désactiver certaines options. Cette action provoque la création d’une nouvelle version du contrat de gestion. Les différentes versions font l’objet d’une sauvegarde sur les offres de stockage utilisées par la solution logicielle Vitam.
Les champs modifiables sont :
- le nom du contrat de gestion,
- sa description,
- son statut actif ou inactif,
- les dates d’activation et de désactivation.

En ce qui concerne les options, il est possible de :
- ajouter, modifier ou supprimer une stratégie de stockage appliquée aux unités archivistiques,
- ajouter, modifier ou supprimer une stratégie de stockage appliquée aux groupes d’objets techniques ;
- ajouter, modifier ou supprimer une stratégie de stockage appliquée aux objets binaires ;
- ajouter, modifier ou supprimer une stratégie d’identification pérenne

En cas d’ajout d’une stratégie de stockage, la mise à jour sera en échec si cette stratégie n’est pas référencée par la solution logicielle Vitam.

Si le contrat de gestion à modifier est utilisé dans au moins un contrat d’entrée, il est recommandé de désactiver le ou les contrats d’entrée déclarant le contrat de gestion, le temps de procéder à la modification du contrat de gestion.


Pour aller plus loin, consulter le [document VITAM. Gestion des habilitations](./gestion_habilitations).