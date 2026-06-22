Le contrat d’entrée dans la solution logicielle Vitam
===

Le contrat d’entrée permet d’octroyer sur un tenant des droits aux utilisateurs applicatifs habilités pour transférer des arbres de positionnement, des plans de classement et des archives dans la solution logicielle Vitam et de paramétrer les contrôles attendus à l’entrée.

Ce contrat d’entrée est obligatoirement déclaré dans le bordereau de transfert accompagnant les plans de classement et les archives.

En fonction des services producteurs et des objets à transférer, diverses configurations du contrat d’entrée sont possibles qui imposeront ou non des contrôles spécifiques sur les archives transférées.

Présentation du contrat d’entrée
---

### Périmètre du contrat d’entrée
Un contrat est propre au tenant sur lequel il a été importé.

Une application qui serait amenée à effectuer des entrées sur plusieurs tenants devrait disposer d’un contrat pour chaque tenant.

### Paramétrage des modalités de contrôle de la structure des entrées
Un ou plusieurs profils d’archivage peuvent être associés au contrat d’entrée. La déclaration du profil d’archivage se fait sur la base de l’identifiant du profil dans le référentiel des profils d’archivage.


### Paramétrage des objets techniques acceptés
Obligation de présence d’un objet technique déclaré comme « Master » dans le SIP qui crée le groupe d’objets techniques
Le contrat d’entrée prévoit une option permettant d’autoriser ou non le transfert de groupes d’objets techniques ne contenant pas d’objet déclaré comme « Master », qu’il s’agisse d’un original physique ou binaire.

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Contrôle activé (valeur « true »)|Chaque groupe d’objets techniques devra nécessairement contenir des objets déclarés comme « Master », qu’ils soient binaires (usage « BinaryMaster ») ou physiques (usage « PhysicalMaster »)|
|Contrôle désactivé (valeur « false »)|Les groupes d’objets techniques seront autorisés à ne pas contenir d’objet déclaré comme « Master »|
|Contrôle indéterminé (valeur par défaut « true »)|Chaque groupe d’objets techniques devra nécessairement contenir des objets déclarés comme « Master », qu’ils soient binaires (usage « BinaryMaster ») ou physiques (usage « PhysicalMaster »)|

#### Restriction des possibilités d’ajout d’un objet technique à un groupe d’objets existant
La solution logicielle Vitam offre la possibilité de compléter un groupe d’objets techniques déjà existant dans le système en y ajoutant un nouvel usage ou une nouvelle version d’un usage déjà existant.

Toutefois, comme l’ajout d’objets depuis l’extérieur peut faire peser un risque sur la valeur probante des objets conservés, cette possibilité doit être expressément autorisée par le contrat d’entrée.

Par défaut, un contrat d’entrée ne permet pas l’ajout d’un objet à un groupe d’objets existants. Si l’option d’ajout est activée, elle peut l’être pour tous les usages, ou pour certains usages seulement (exemple : une vignette peut être ajoutée, mais pas un fichier d’usage « BinaryMaster »).

Seul le service producteur ayant provoqué la création du groupe d’objets techniques dans la plate-forme utilisant la solution logicielle Vitam a le droit de rajouter des objets à ce groupe d’objets.

### Paramétrage des formats acceptés
Lors de l’import d’un SIP dans la solution logicielle Vitam, le processus d’entrée comprend une étape d’identification du format des objets techniques (fichiers). Selon les options retenues dans le contrat d’entrée, le résultat de l’identification pourra conduire à refuser en entrée certains formats ou les objets techniques dont le format est non identifiable.

#### Définition des formats d’objet technique attendus
La solution logicielle Vitam offre la possibilité de déterminer dans le contrat d’entrée quel(s) format(s) d’objet technique sont attendus dans les bordereaux de transfert.

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Tous les formats autorisés|Le bordereau de transfert peut contenir des objets de n’importe quel format possible|
|Liste blanche des formats autorisés|Le bordereau de transfert ne peut contenir que des objets conformes au(x) format(s) déclaré(s)|
|Contrôle indéterminé (valeur par défaut « tous les formats autorisés »)|Le bordereau de transfert peut contenir des objets de n’importe quel format possible|

Les formats déclarés dans le contrat d’entrée doivent l’être sur la base de leur identifiant (PUID) dans le référentiel des formats de la solution logicielle Vitam.

#### Acceptation des formats d’objets techniques non identifiables
La solution logicielle Vitam offre la possibilité d’autoriser dans le contrat d’entrée le transfert d’objets techniques dont le format n’est pas identifiable par un outil d’identification.

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Objets non identifiables autorisés|Le bordereau de transfert peut contenir des objets dont le format est non identifiable|
|Objets non identifiables interdits|Le bordereau de transfert ne peut contenir que des objets dont le format est identifiable|
|Contrôle indéterminé (valeur par défaut « objets non identifiables interdits »)|Le bordereau de transfert ne peut contenir que des objets dont le format est identifiable|

### Utilisation des services de rattachement

#### Déclaration d’un nœud de rattachement systématique
La solution logicielle Vitam offre la possibilité de déclarer dans le contrat d’entrée un nœud de rattachement qui s’appliquera à toutes les unités archivistiques racines des SIP qui utilisent ce contrat.
Le rattachement se fait sur la base de l’identifiant système (GUID) d’une unité archivistique déjà présente dans le système. Cette unité archivistique peut être de type « arbre de positionnement », « plan de classement » ou « standard ». Les rattachements qui seront effectués à l’entrée doivent cependant respecter la structuration de l’information dans la solution logicielle Vitam : une unité archivistique d’arbre ne peut être rattachée qu’à une unité archivistique d’arbre, une unité archivistique de plan ne peut être rattachée qu’à une unité archivistique d’arbre ou de plan.

Il est recommandé de créer autant de contrats d’entrée qu’il y aura de nœuds de rattachement auxquels rattacher les archives transférées. Lors de l’entrée, les unités archivistiques à la racine du SIP seront automatiquement rattachées à l’unité archivistique déclarée dans le contrat d’entrée.
Si on souhaite ne pas multiplier les contrats d’entrée pour cette seule raison, il est recommandé de gérer les rattachements au niveau des unités archivistiques dans chaque bordereau de transfert.

#### Acceptation ou non de la présence de rattachements dans le bordereau de transfert
La solution logicielle Vitam permet de contrôler la présence d’un rattachement déclaré dans le bordereau de transfert :

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Rattachements interdits|Le bordereau de transfert ne doit déclarer aucun rattachement|
|Rattachements autorisés|Le bordereau de transfert peut déclarer ou non un rattachement|
|Rattachements obligatoires|Le bordereau de transfert doit déclarer au moins un rattachement|
|Contrôle indéterminé (valeur par défaut « autorisé »)|Le bordereau de transfert peut déclarer ou non un rattachement|

Lors du processus d’entrée, si le bordereau de transfert n’est pas conforme à ce qui est attendu, l’entrée est rejetée.

Cas d’usage : une application de type GED verse annuellement des documents à rattacher à un plan de classement déjà présent dans la solution logicielle Vitam. En rendant obligatoire la présence d’au moins un rattachement dans le bordereau de transfert, le service d’archives peut contrôler que les transferts issus de l’application GED portent bien au moins un rattachement.

#### Activation d’un contrôle sur nœud de rattachement
La solution logicielle Vitam permet de contrôler le positionnement des rattachements demandés dans les bordereaux de transfert dans la descendance d’un ou plusieurs nœuds déclarés dans le contrat :
- Si le contrôle est activé, seuls les rattachements au(x) nœud(s) déclaré(s) ou à des unités archivistiques filles du ou des nœuds déclarés dans le contrat seront autorisés. Si le rattachement déclaré dans le bordereau de transfert n’est pas positionné correctement dans l’arborescence, le transfert sera rejeté ;
- Si le contrôle n’est pas activé, les unités archivistiques pourront être rattachées à n’importe quel nœud, tant que cela ne crée pas de récursivité dans le système et respecte la structuration de l’information. La solution logicielle Vitam n’empêchera pas le transfert.

Cas d’usage : un service dispose dans la solution logicielle Vitam de son plan de classement et souhaite effectuer ensuite des entrées des documents produits annuellement en les classant automatiquement dans les bonnes rubriques de ce plan de classement. Il est possible de déclarer dans le bordereau de transfert pour chaque unité archivistique un rattachement et de contrôler que tous ces rattachements sont bien situés sous la racine du plan de classement à utiliser.

L’unité archivistique déclarée peut être de type « arbre de positionnement », « plan de classement » ou « standard ».
Les rattachements effectués à l’entrée doivent respecter la structuration de l’information dans la solution logicielle Vitam, sinon le transfert sera rejeté.

Pour en savoir plus, consulter le [vademecum Faire un rattachement dans la solution logicielle Vitam](./Vademecum_rattachement.md)

### Paramétrage du calcul des héritages de règles et de l’indexation des échéances
La solution logicielle Vitam permet d’indexer sur les unités archivistiques les échéances maximales applicables par catégorie de règle de gestion, que ces règles soit portées en propre par l’unité archivistique ou héritées.

Si ce paramétrage est activé, les unités archivistiques seront marquées à l’entrée comme ayant une indexation des échéances non valide, ce qui permettra de les prendre en compte dans un processus automatique de calcul déclenché périodiquement (batch).

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Contrôle activé (valeur « true »)|Les unités archivistiques seront indexées à l’entrée avec une indexation déclarée invalide pour faire l’objet d’un calcul par batch|
|Contrôle désactivé (valeur « false »)|Aucune indexation des échéances des règles de gestion ne sera faite|
|Contrôle indéterminé (valeur par défaut « false »)|Aucune indexation des échéances des règles de gestion ne sera faite|

Cette fonctionnalité est un complément de l’enregistrement en base des règles de gestion portées en propre par une unité archivistique. Cet enregistrement est mis en œuvre systématiquement dans le cadre du processus d’entrée, que l’indexation des échéances soit ou non activée.

Pour en savoir plus, consulter le [vademecum Calcul des héritages de règles et indexation des échéances dans la solution logicielle Vitam](./Vademecum_echeances.md).

### Utilisation d’un contrat de gestion spécifique
La solution logicielle Vitam permet d’indiquer dans le contrat d’entrée le contrat de gestion à utiliser pour le stockage des métadonnées et des objets techniques.

Si aucun contrat n’est renseigné, c’est la stratégie de stockage par défaut qui s’appliquera.

Pour en savoir plus, consulter le [vademecum Le contrat de gestion dans la solution logicielle Vitam](./Vademecum_contrat_gestion.md).

### Paramétrage sur les archives signées électroniquement
Le contrat d’entrée prévoit une option permettant d’autoriser ou non le transfert d'archives signées électroniquement, et de vérifier la présence de leurs pièces pièces annexes (jeton d'horodatage, signature, preuves complémentaires).

|Option retenue dans le contrat d’entrée|Comportement à l’entrée|
|:----|:---|
|Archives signées autorisées (valeur « MANDATORY »)|Chaque unité d'archives devra nécessairement contenir des documents signés et, le cas échéant, devra ou non contenir une signature (rôle « DeclaredSignature »), un jeton d'horodatage (rôle « DeclaredTimestamp ») et/ou des preuves complémentaires (rôle « DeclaredAdditionnalProof »)|
|Archives signées obligatoires (valeur « MANDATORY »)|Chaque unité d'archives seront autorisés à contenir des documents signés et, le cas échéant, devra ou non contenir une signature (rôle « DeclaredSignature »), un jeton d'horodatage (rôle « DeclaredTimestamp ») et/ou des preuves complémentaires (rôle « DeclaredAdditionnalProof »)|
|Archives signées interdites (valeur par défaut « FORBIDDEN »)|Les archives ne devront pas contenir d'archives signées électroniquement|

Configuration du contrat d’entrée
----

### Constitution du contrat d’entrée
Pour constituer un contrat d’entrée, l’administrateur fonctionnel recense les règles et contraintes pour une filière de versement (versements manuels, entrées de vrac numérique) ou pour une application :
- y a-t-il des attentes en matière de formalisation des bordereaux de transfert qui conduiront à l’utilisation d’un profil d’archivage pour contrôler la structure du bordereau ?
- voudra-t-on positionner systématiquement les unités archivistiques racine des SIP versés dans cette filière au même niveau d’une arborescence ?
- souhaitera-t-on contrôler le format des objets versés ?
- souhaitera-t-on imposer certains formats pour les fichiers reçus en entrée ?
- l’ajout d’un objet technique (nouvelle version ou nouvel usage) à un groupe d’objets techniques existant sera-t-il autorisé ? Si oui, pour tous les usages ?
En fonction des réponses à ces questions, l’administrateur fonctionnel pourra créer un ou plusieurs contrats d’entrée et définir les options de contrôle à activer dans chaque contrat d’entrée.

S’il y a très peu de contrôles à faire et aucun rattachement systématique à prévoir, il est tout à fait possible de n’avoir qu’un seul contrat d’entrée commun à toutes les filières de versement (manuel et applicatif).  
Il devient intéressant d’avoir plusieurs contrats lorsque l’on veut par exemple avoir une filière de versement applicatif acceptant les formats non identifiés et une filière les refusant.  
Si l’on souhaite utiliser le rattachement par contrat d’entrée pour positionner les entrées dans l’arborescence du service d’archives, il conviendra de prévoir autant de contrats d’entrée que de nœuds de rattachement différents.

Une application versante peut générer des données nécessitant plus d’un profil d’archivage :
- ces profils peuvent être déclarés dans un même contrat d’entrée. Il reviendra au bordereau de transfert de signaler le profil qu’il utilise pour décrire le versement ;
- il est également possible de créer un contrat d’entrée par profil utilisé.
Dans le cas où l’on souhaiterait combiner profil et rattachement, il est recommandé de créer un contrat d’entrée par profil. En effet, un contrat d’entrée unique ne permettrait pas a posteriori, s’il déclare plusieurs profils, de déclarer pour chacun d’eux un nœud de rattachement particulier.

Il est recommandé d’indiquer dans le contrat d’entrée quel(s) est(sont) le(s) format(s) des archives à transférer par une application versante, si ce(s) format(s) sont connus ou si l’on souhaite imposer une liste de formats propre à l’archivage.
Par exemple :
- une chaîne de numérisation pourrait ne devoir verser que des objets au format JPEG ;
- un système d’archivage électronique ne souhaitant garantir la conservation d’objets qu’aux formats ODT, ODS, ODP, PDF, TIFF pourrait ne déclarer que des contrats d’entrée n’acceptant que ces seuls formats.
Quand on ne connaît pas les formats des archives qui pourraient être transférées dans la solution logicielle ou quand on ne souhaite pas imposer des formats pour les archives à transférer et quand on souhaite n’effectuer aucun contrôle d’identification de format au moment de leur transfert dans la solution logicielle Vitam, il est recommandé d’autoriser le transfert de groupes d’objets contenant tous les formats possibles et de désactiver le contrôle d’identification des objets.

### Gestion de l’identifiant du contrat d’entrée
À l’installation de la plate-forme Vitam, l’administrateur technique peut configurer le tenant pour que les identifiants des contrats d’entrée soient générés par Vitam (mode « maître ») ou par le front-office (mode « esclave »).
Le mode « esclave » permet à un service de conserver la main sur les identifiants des contrats d’entrée pour utiliser des identifiants normés au niveau de l’institution et/ou à un niveau national ou international.

### Formalisation du contrat d’entrée
Un contrat d’entrée prend la forme d’un fichier JSON, pouvant contenir 1 à n contrat(s) d’entrée.
Un contrat d’entrée donné doit obligatoirement comporter les informations suivantes :
- identifiant signifiant. Ce champ est obligatoire seulement s’il est généré par l’application à l’origine de sa création. Si cet identifiant est généré par la solution logicielle Vitam, il n’est pas nécessaire de le renseigner dans le fichier JSON ;
- nom du contrat.
D’autres informations, facultatives, peuvent venir compléter ces informations.

Le contrat d’entrée est composé des éléments suivants :

- Éléments obligatoires
    - identifiant unique donné au contrat, sauf s’il est généré automatiquement par le système
    - nom du contrat
    - statut « Actif » ou « Inactif » ; par défaut, la valeur est « INACTIVE »
    - option permettant d’accepter ou non la présence de rattachements dans le bordereau de transfert (obligatoire, valeur par défaut « AUTHORIZED »)
    - option permettant de rendre obligatoire ou non la présence d’un objet déclaré comme « Master » dans un transfert (obligatoire, valeur par défaut : « true »)
        - usage(s) autorisé(s) dans le cas de l’ajout d’un objet à un groupe d’objets existant. Il peut s’agir de :
            - tous les usages (obligatoire, valeur par défaut : « false »)
            - une sélection d’usages (facultatif)
        - format(s) des objets autorisé(s) dans un bordereau de transfert. Il peut s’agir de :
            - tous les formats (obligatoire, valeur par défaut : « true »)
            - une sélection de formats (facultatif)
    - option autorisant le transfert d’objets dont le format n’est pas identifié (obligatoire, valeur par défaut : « false »)
    - option demandant l’indexation des échéances des règles de gestion applicables aux unités archivistiques transférées (obligatoire, valeur par défaut : « false »)
- Éléments facultatifs
    - description du contrat
    - si le contrat est inactif, date de désactivation du contrat
    - date d’activation
    - identifiant du profil d’archivage associé au contrat
    - identifiant du nœud auquel on souhaite rattacher les SIP versés
    - identifiant(s) des noeud(s) de rattachement autorisé(s)
    - sélection d’usages autorisés pour l’ajout d’un objet technique à un groupe d’objets existant
    - sélection de formats autorisés en entrée
    - contrat de gestion applicable aux métadonnées et objets techniques
	- contrôle sur les archives signées électroniquement.

Pour plus d’informations, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).

Il est possible d’importer, en une seule fois, un référentiel complet, comprenant plusieurs notices décrivant chacune un contrat d’entrée. La solution logicielle Vitam ne comptabilisera qu’une seule opération et ne prendra pas en compte dans le journal des opérations la création unitaire des différents items compris dans le référentiel importé.

Afin d’optimiser la traçabilité de la création des différents contrats d’entrée, il est recommandé de créer ces derniers un par un.

### Activation/désactivation du contrat d’entrée
Un contrat d’entrée peut être importé avec un statut inactif ou être désactivé lors d’une mise à jour du contrat.
Cette fonctionnalité est utile quand on souhaite créer un contrat d’entrée et l’importer avant d’autoriser des applications à l’utiliser ou lorsqu’on souhaite désactiver temporairement ou définitivement un contrat d’entrée.

Un contrat au statut inactif ne permet pas de réaliser une entrée.

### Modification d’un contrat d’entrée

Les contrats d’entrée peuvent être modifiés unitairement pour permettre d’activer ou de désactiver certaines options.
Cette action provoque la création d’une nouvelle version du contrat d’entrée. Les différentes versions font l’objet d’une sauvegarde sur les offres de stockage utilisées par la solution logicielle Vitam.
Les champs « Identifiant », « Date de création », « Dernière modification » et « Tenant » ne sont pas modifiables.

Il est possible de modifier un contrat d’entrée utilisé dans un contexte applicatif particulier. Il est conseillé de suivre les étapes suivantes en fonction du contexte d’utilisation du contrat :
|Contexte|Action|
|:----|:---|
|Avec un contrat d’entrée|Désactivation du contexte applicatif ou du seul contrat d’entrée, le temps de procéder à la modification|
|Avec un contrat d’entrée et un contrat d’accès|Désactivation du seul contrat d’entrée, le temps de procéder à la modification, de manière à ne pas interrompre l’accès associé au contexte applicatif.|
|Avec plusieurs contrats d’entrée|Désactivation d’un seul contrat d’entrée, le temps de procéder à la modification, de manière à ne pas interrompre l’utilisation des autres contrats d’entrée associés au contexte applicatif.|
|Avec un ou plusieurs contrats d’entrée|Création d’un nouveau contrat d’entrée contenant les modifications à apporter.<br>Association de ce contrat d’entrée au contexte applicatif.<br>Activation de ce contrat d’entrée.<br>Déclaration de ce nouveau contrat d’entrée dans les bordereaux de transfert.<br>Désactivation de l’ancien contrat d’entrée.<br>Suppression du lien entre l’ancien contrat d’entrée et le contexte applicatif.|

Pour aller plus loin, consulter le [document VITAM. Gestion des habilitations](./gestion_habilitations.md).