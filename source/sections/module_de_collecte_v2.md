Module de collecte
==================

Introduction
------------

### Documents de référence

|Document |Date de la version|Remarques|
|:---------------:|:-----:|:-----:|
|NF Z 44022 – MEDONA – Modélisation des données pour l’archivage|18/01/2014||
|Standard d’échange de données pour l’archivage – SEDA – v. 2.1|06/2018||
|Standard d’échange de données pour l’archivage – SEDA – v. 2.2|02/2022|Cette nouvelle version du SEDA est intégrée à la solution logicielle Vitam à partir de la V6.RC.|
|[Vitam – Structuration des *Submission Information Package* (SIP)](./SIP.md)|||           
|[Vitam – Modèle de données](./modele_de_donnees.md)|||
|[Vitam – Ontologie](./ontologie.md)|||
|[Vitam – Schéma](./schema.md)|||           
|[Vitam – Profils d’archivage](./profil_archivage.md)|||
|[Vitam – Profils d’unité archivistiques](./profil_unite_archivistique.md)|||

### Présentation du document

Le document présente les fonctionnalités associées à l’utilisation du module de collecte dans la solution logicielle Vitam.

Il s’articule autour des axes suivants :
-   une présentation du module de collecte ;
-   une présentation des mécanismes mis en œuvre dans la solution logicielle Vitam pour prendre en compte les opérations de collecte, en application du SEDA ;
-   des conseils de mise en œuvre.

Le présent document décrit les fonctionnalités qui sont offertes par la solution logicielle Vitam au terme de la version 8.1 (printemps 2025). Il a vocation à être amendé, complété et enrichi au fur et à mesure de la réalisation de la solution logicielle Vitam et des retours et commentaires formulés par les ministères porteurs et les partenaires du programme.

Présentation du module de collecte
----------------------------------

### Qu’est-ce que la collecte d’archives ?

La **collecte** d’archives désigne l’ensemble des opérations qui vont conduire au **transfert** d’un ensemble d’archives :

-   d’un service producteur à un service d’archives,
-   d’un service d’archives intermédiaires à un service d’archives définitives.

Un **versement** correspond à un ensemble d’archives faisant l’objet du transfert.

Le **transfert** matérialise l’opération visant à transférer la responsabilité de la conservation des archives d’un service à un autre.

La collecte d’archives peut intervenir à plusieurs occasions :

-   Un service producteur soumet un versement à un service d’archives ;
-   La collecte peut être à l’initiative d’un service d’archives, dans le cadre d’une campagne de collecte d’archives ;
-   Des règles de gestion associées à des archives arrivent à échéance et impliquent un transfert de responsabilité en termes de conservation de ces dernières et, de fait, un transfert vers un autre service d’archivage.

La manière de procéder au transfert d’archives est définie dans la norme NF Z 44-022 et dans sa déclinaison pour les acteurs du service public, le Standard d’échanges de données pour l’archivage (SEDA).

Le versement, pouvant également être nommé transfert ou **transaction**, s’effectue en deux temps :

-   la soumission d’un ensemble d’archives à verser en vue de :

    -   vérifier son contenu et, le cas échéant, procéder à des traitements (ex. suppression de documents, renommage, etc.) ;
    -   documenter et contextualiser le versement, par l’ajout d’informations sur le service producteur, son contenu, ses règles de gestion ;

-   après validation de l’ensemble d’archives candidates à l’archivage par les parties concernées, transfert des archives en vue d’en assurer leur conservation et transfert de la responsabilité liée à leur conservation.

Au préalable de versements, une politique ou stratégie de versement est définie par le service d’archives, en termes de rôles et responsabilités, mais aussi de contenu attendu. Elle est définie dans un contrat de versement, dont une partie est matérialisée dans un projet de versement et un contrat d’entrée.


### Qu’est-ce que le module de collecte ?

La solution logicielle Vitam met à disposition un **module de collecte** en vue de recevoir des ensembles hétérogènes d’archives, de paramétrer leur réception, de procéder à des traitements sur ces archives et de les transférer pour conservation dans le système d’archivage électronique. Ce module :

-   constitue un service du back-office de la solution logicielle Vitam ;
-   est utilisé par l’APP « Collecte et préparation des versements » du front-office VitamUI.

Ce module intervient en amont du transfert (ou versement) d’archives dans la solution logicielle Vitam. Son installation, ainsi que son utilisation, sont optionnelles.

  *Positionnement du module de collecte en amont du versement*
  
  ![](medias/module_collecte/Pictures/100002010000028D000001AB99F8EB7026B5C8F3.png)

Il permet de :

| | |
|:-: |--- |
| **Configurer des versements**     | Définir un projet de versement et paramétrer :<br>- acteurs et références génériques,<br>- un rattachement automatisé à une position dans l’arborescence, avec ou sans paramétrages de conditions de rattachement,<br>- une clôture automatique après validation du versement,<br>- le formatage des données entrantes.| 
| **(Pré-)Verser les archives**     | Collecter depuis l’extérieur un ensemble d’archives, caractérisées par des métadonnées et des fichiers numériques, et constituer :<br>- des (pré-)versements (ou transactions) automatisés émanant d’un système d’information externe <br>- des (pré-)versements (ou transactions) manuels et unitaires : <br>a) constitués par exemple d’arborescences bureautiques ou de messageries,<br>b) réalisés depuis des interfaces, notamment celles de l’APP « Collecte et préparation des versements » du front-office VitamUI.|
| **Consulter les (pré-)versement** | Consulter :<br>- la liste des projets de versement et des (pré-)versements (ou transactions) en attente,<br>- un projet de versement en particulier, c’est-à-dire sa description, les informations contextuelles et la position de rattachement dans le tenant de destination,<br>- le contenu d’un (pré-)versement (ou transaction), c’est-à-dire la liste des archives associées, une unité archivistique en particulier et, le cas échéant, l’objet numérique associé.|
| **Traiter les archives**          | Procéder à des traitements archivistiques tels que :<br>- définition de métadonnées contextuelles,<br>- identification de format,<br>- calcul d’empreintes,<br>- calcul du poids de l’objet numérique,<br>- réorganisation d’arborescence,<br>- ajout de dossiers et d'objets numériques,<br>- mise à jour de métadonnées descriptives et de gestion,<br>- suppression d'arborescences et/ou d'objets numériques,<br>- tri, dédoublonnage *(services non implémentés),*<br>- gestion de statuts (ex. réouverture d’un (pré-)versement en erreur),<br>- suppression de projets et de (pré-)versements,<br>- etc.|
| **Transférer les archives**       | - Générer un SIP conforme au Standard d’échanges de données pour l’archivage (SEDA) et le transférer dans le système d’archivage électronique pour conservation.<br>- Suppression  automatisée d’un (pré-)versement |

### Pourquoi, quand et comment utiliser le module de collecte ?

Le module de collecte permet de :

-   faciliter, voire automatiser, les versements (ou transactions) d’archives, depuis un service externe vers la solution logicielle Vitam ;
-   le cas échéant, effectuer un contrôle supplémentaire sur les projets de versement et leur contenu, en vue de vérifier la qualité des données, en amont de leur transfert dans un système d’archivage électronique ;
-   enrichir les métadonnées (notamment par l’identification de formats, le calcul d’empreintes et du poids de l’objet numérique, ou encore la mise à jour des métadonnées descriptives et de gestion) ;
-   proposer un format pivot et générique pour les services externes souhaitant verser des archives au sein de la solution logicielle Vitam ;
-   améliorer l’interopérabilité entre les systèmes d’information.

L’utilisation du module de collecte peut être envisagée dans les cas suivants :

-   versements de flux applicatifs, afin de les automatiser ;
-   versements de dossiers ou de documents dits « sériels », obéissant *strictement* à des règles de nommage et de description uniformes (par exemple, des images numérisées par un service d’archives) ;
-   versements réguliers et récurrents d’un même type d’archives par différents services producteurs et donc répondant à la volonté de disposer d’une description homogène, y compris pour faciliter les recherches sur celles-ci ;
-   versements ponctuels d’archives hétérogènes, quel que soit leur type (bureautique, audiovisuel, etc.).

En outre, il peut être utilisé de manière différente en permettant de :

-   en faisant appel uniquement à ses services back-office et ses API, automatiser des flux de versements émanant de systèmes d’information ;
-   construire des interfaces, en appelant ses API permettant de générer un SIP, en vue de faciliter la saisie d’un bordereau de transfert et la préparation d’un versement ;
-   utiliser les interfaces de l’APP « Collecte et préparation des versements » du front-office VitamUI.

Mécanismes mis en œuvre dans la solution logicielle Vitam
---------------------------------------------------------

La solution logicielle Vitam offre à un service d’archives plusieurs fonctionnalités lui permettant de **collecter des archives** au moyen du module de collecte :

-   la **configuration** des (pré-)versements (ou transactions) au moyen de la définition d’un projet de versement ;
-   leur **(pré-)versement** (ou collecte) dans le module ;
-   leur **recherche** et leur consultation ;
-   leur **gestion** et leur traitement ;
-   leur **transfert** vers les espaces de conservation pérennes de la solution logicielle Vitam.

### Configuration

#### Définitions

Dans la solution logicielle Vitam, il est possible de configurer le versement de un à plusieurs SIP conforme(s) au Standard d’échanges des données pour l’archivage (SEDA) en initialisant un **projet de versement** au sein du module de collecte.

Un projet de versement est propre à chaque tenant de la solution logicielle Vitam.

Il permet de préconfigurer dans une base de données dédiée, sous forme d’enregistrements JSON, les informations relatives à :

-   des métadonnées correspondant à l’en-tête du message ArchiveTransfer (Base Collect &gt; Collection Project),
-   le rattachement automatisé à :

    -   une position dans le tenant de destination,
    -   une à plusieurs position(s) en fonction de la définition de conditions à respecter dans le versement,

-   les métadonnées descriptives et de gestion attendues dans le cas d’un versement en lot d’archives,
-   la gestion automatisée des transactions,
-   la fréquence des transferts vers la solution logicielle Vitam, etc. (*service non implémenté*).

Les fonctionnalités ont été conçues et réalisées de manière à prendre en compte 1 à n transaction(s) pour un projet de versement.

![](medias/module_collecte/Pictures/ProjetEtTransactions.png)

Un projet de versement est modifiable.

***Point d’attention :***

-   La création et la modification d’un projet de versement dans le module de collecte ne sont pas journalisées dans le journal des opérations.
-   Il est recommandé d’avoir une seule transaction en cours d’alimentation pour un projet de versement.
-   Il n'est pas recommandé de modifier un projet de versement lorsqu'une transaction est en cours d'alimentation.

#### Création d'un projet de versement

##### Utilisation des API

L’envoi et l’enregistrement d’un projet de versement dans le module de collecte s’effectue au moyen d’une commande de création d’un projet de versement.

***Point d’attention :*** la création d’un projet de versement est un prérequis à la création des transactions (ou versements).

Lors de la création d’un projet de versement sont envoyées :

-   les métadonnées correspondant aux informations dites d’en-tête du bordereau telles que l’identifiant du message ou le contrat d’entrée ;
-   le cas échéant, les paramètres suivants :
    -   position de rattachement et/ou paramètres de rattachement automatisés,
	-   gestion automatisée des transactions,
	-   transformation des données entrantes.

Un projet de versement peut comporter les éléments suivants[^1] :

| **Champ**                        | **Description** |
| --- | --- |
|  Name                         | Intitulé du projet de versement (champ facultatif)[^2].|
|  ArchivalAgreement            | Identifiant du contrat d’entrée utilisé pour réaliser l’entrée, destiné à alimenter le champ ArchivalAgreement du message ArchiveTransfer (champ facultatif).|
|  MessageIdentifier            | Identifiant du lot d’objets, utilisé pour identifier les versements, destiné à alimenter le champ MessageIdentifier du message ArchiveTransfer (champ facultatif).|
|  Comment                      | Précisions sur la demande de transfert destiné à alimenter le champ Comment du message ArchiveTransfer (champ facultatif).|
|  OriginatingAgencyIdentifier  | Identifiant du service producteur, destiné à alimenter le champ OriginatingAgencyIdentifier du message ArchiveTransfer (champ facultatif).|
|  SubmissionAgencyIdentifier   | Identifiant du service versant, destiné à alimenter le champ SubmissionAgencyIdentifier du message ArchiveTransfer (champ facultatif).|
|  ArchivalAgencyIdentifier     | Identifiant du service d’archivage, destiné à alimenter le champ Identifier du bloc ArchivalAgency du message ArchiveTransfer (champ facultatif).|
|  TransferringAgencyIdentifier | Identifiant du service de transfert, destiné à alimenter le champ Identifier du bloc TransferringAgency du message ArchiveTransfer (champ facultatif).|
|  ArchivalProfile              | Identifiant du profil d’archivage utilisé pour réaliser l’entrée, destiné à alimenter le champ ArchivalProfile du message ArchiveTransfer (champ facultatif).|
|  UnitUp                       | Identifiant de l’unité archivistique à laquelle rattacher automatiquement la ou les unité(s) racine(s) des transactions associées au projet de versement (champ facultatif).|
|  UnitUps                      | Liste de conditions permettant un rattachement automatisé de l’(des) unité(s) racine(s).<br> A une métadonnée (MetadataKey) définissant une valeur spécifique (MetadataValue) peut être associée une unité archivistique de rattachement (UnitUp) (champs facultatifs).|
|  AcquisitionInformation       | Modalité d’entrée.<br>  Champ destiné à alimenter le champ AcquisitionInformation du message ArchiveTransfer (champ facultatif).|
|  LegalStatus                  | Statut légal des archives, destiné à alimenter le champ LegalStatus du message ArchiveTransfer (champ facultatif). <br> Si le champ est renseigné, les valeurs attendues sont : « Public Archive », « Private Archive », « Public and Private Archive ».|
|  AutomaticIngest              | Paramètre permettant d'automatiser l'envoi de transaction(s) vers la solution logicielle Vitam (champ facultatif).|
|  TransformationRules          | Paramètre permettant de lister des règles de transformation à opérer sur les données entrantes (champ facultatif).|

***Point d’attention :*** Au terme de la version 8.1 :

-   on ne peut pas inclure de règles de gestion dans un projet de versement ;
-   aucun contrôle n’est effectué avec les référentiels et unités archivistiques de rattachement présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de :

    -   veiller à inclure des références (ex. service producteur, contrat d’entrée, etc.) existant dans la solution, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

-   la plupart des champs d’un projet de versement sont facultatifs. Néanmoins, il est recommandé d’indiquer un intitulé (Name) et les éléments obligatoires à la génération d’un SIP :

    -   le contrat d’entrée (champ ArchivalAgreement),
    -   l’identifiant du message (champ MessageIdentifier),
    -   le service producteur (champ OriginatingAgencyIdentifier),
    -   le service d’archivage (champ Identifier du bloc ArchivalAgency),
    -   le service responsable du transfert (champ Identifier du bloc TransferringAgency).

*Exemple : requête de création d’un projet de versement*
``` 
  POST {{url}}/collect-external/v1/projects
  accept: application/json
  content-type: application/json
  Content-Length: 401
  X-Tenant-Id: {{tenant}}
  
  {
   "Name": "Versements du SG",
   "ArchivalAgencyIdentifier": "Vitam",
   "TransferringAgencyIdentifier": "RATP",
   "OriginatingAgencyIdentifier": "RATP",
   "SubmissionAgencyIdentifier": "RATP",
   "MessageIdentifier": "20200131-000013",
   "ArchivalAgreement":"IC-000001",
   "Comment": "SG – bureautique",
   "UnitUp": "aeaqaaaaaehedmpfaay5gambwxsspviaaaba"
  }

```

Cette action provoque :

-   la création d’un enregistrement dans la base de données MongoDB, dans la collection « Project » (base *Collect*) ;
-   l’ajout des informations suivantes, associées à cet enregistrement :

    -   un statut (champ « Status ») dont la valeur est égale à « OPEN »,
    -   une date de création (champ « CreationDate ») dont la valeur est égale à la date de création de l’enregistrement,
    -   une date de dernière modification (champ « LastUpdate ») dont la valeur est égale à la date de création de l’enregistrement.

*Exemple : enregistrement du projet de versement dans la collection « Project »*
```
  {
   _id: 'aeeaaaaaaghj3m7nabjocamcdqvqqviaaaaq',
   Name: 'Versements du SG',
   Context: {
   ArchivalAgreement: 'IC-000001',
   MessageIdentifier: '20200131-000013',
   ArchivalAgencyIdentifier: 'Vitam',
   TransferirngAgencyIdentifier: 'RATP',
   OriginatingAgencyIdentifier: 'RATP',
   SubmissionAgencyIdentifier: 'RATP',
   Comment: 'SG - bureautique',
   UnitUp: 'aeaqaaaaaehedmpfaay5gambwxsspviaaaba'
   },
   CreationDate: '2022-08-23T09:05:52.242',
   LastUpdate: '2022-08-23T09:05:52.242',
   Status: 'OPEN',
   _tenant: 1
  }
``` 

Lors de cette action, non journalisée, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | Présence d’un champ inconnu dans la requête. |

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet de créer un projet de versement au moyen d’un wizard ou boîte de dialogue. Il peut s’agir d’un projet de versement pour :

-   un versement manuel. Ce projet de versement donne lieu au renseignement :

    -   d’un possible rattachement à un nœud d’arbre de positionnement ou de plan de classement,
    -   d’un possible rattachement automatique en fonction de conditions devant être respectées dans les unités racines envoyées dans le module de collecte,
    -   d’informations décrivant le versement (intitulé du message, description, service producteur et service versant),
    -   d’informations contextuelles (service d’archives et service responsable du transfert des archives, contrat d’entrée, profil d’archivage, modalité d’entrée, statut légal des versements).

    La création du projet dans l’APP entraîne la création d’une unique transaction.

-   des versements de flux automatisé. Ce projet de versements donne lieu au renseignement :

    -   d’un possible rattachement à un nœud d’arbre de positionnement ou de plan de classement,
    -   d’un possible rattachement automatique en fonction de conditions devant être respectées dans les unités racines envoyées dans le module de collecte,
	-   d’un possible envoi automatique des transactions associées au projet après leur validation,
    -   d'un possible paramétrage de règles de transformations des données entrantes. Ce service passe par l'import d'un fichier au format JSLT,
	-   d’informations décrivant le versement (intitulé du message, description, service producteur et service versant),
    -   d’informations contextuelles (service d’archives et service responsable du transfert des archives, contrat d’entrée, profil d’archivage, modalité d’entrée, statut légal des versements).

    La création du projet de versements de flux automatisé dans l’APP n’entraîne pas la création de transaction.

L’APP « Collecte et préparation des versements » permet également de :

-   rechercher un projet de versement,
-   accéder à la liste des projets de versement,
-   accéder au détail d’un projet de versement en particulier,
-   modifier un projet de versement.

***Point d’attention :*** Au terme de la version 8.1 :

-   l’intitulé saisi dans le wizard ou boîte de dialogue incrémente à la fois l’identifiant du message (MessageIdentifier) et l’intitulé du projet (Name) ;
-   on ne peut pas inclure de règles de gestion dans un projet de versement ;
-   aucun contrôle n’est effectué avec les référentiels présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de :

    -   veiller à inclure des références (ex. service producteur, contrat d’entrée, etc.) existant dans le tenant (coffre), de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

-   il n’est pas possible de modifier les paramétrages liés au rattachement automatique ou via conditions depuis les interfaces. De fait, il est recommandé de veiller à ne pas faire d’erreurs lors de la saisie des informations.
-   Au terme de la version 8.1, le paramétrage permettant de définir des règles de transformation n’est pas accessible depuis les interfaces. De fait, il est recommandé de veiller à ne pas faire d’erreurs lors de la saisie des informations.

#### Accès

##### Utilisation des API

La solution logicielle Vitam permet de :

-   accéder à la liste des projets de versement créés sur un tenant donné ;
-   consulter les informations d’un projet en particulier sur un tenant donné ;
-   rechercher un à plusieurs projets de versement par rapport à certains critères (recherche approchante) :

    -   un intitulé,
    -   un identifiant du message,
    -   un service producteur ;
-  rechercher les projets de versement d'un service producteur en particulier.


  *Exemple : requête en vue d’obtenir l’ensemble des projets de versement disponibles sur un tenant donné*
```  
  @tenant = 1
  
  GET {{url}}/collect-external/v1/projects
  accept: application/json
  X-Tenant-Id: {{tenant}}
```  
  
  *Exemple : requête en vue d’obtenir les informations relatives à un projet donné dont l’identifiant est « aeeaaaaaaghpmborabjyyambxjekiyyaaaaq »** **sur un tenant donné.*
```  
  @project-id = **aeeaaaaaaghpmborabjyyambxjekiyyaaaaq**
  @tenant = 1
  
  GET {{url}}/collect-external/v1/projects/{{project-id}}
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
```  
  
  *Exemple : requête en vue d’obtenir les projets de versement dont l’intitulé et/ou le service producteur contient le terme « Versement » sur un tenant donné.*
```  
  @tenant = 1
  
  GET {{url}}/collect-external/v1/projects
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143
  
  {
   "$query":"Versement"
  }
```

  *Exemple : requête en vue d’obtenir les projets de versement dont le service producteur est égal à « Vitam » sur un tenant donné.*
```  
  @tenant = 1
  
  GET {{url-collect}}/collect-external/v1/projects
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143

 {
   "originatingAgencies": ["Vitam"]
 }
```  

***Point d’attention :*** 
En résultats, la solution logicielle renvoie systématiquement l’ensemble des métadonnées relatives au(x) projet(s) de versement. Au terme de la version 8.1, il n’est pas possible de récupérer une sélection de métadonnées.

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet d’accéder à la liste des projets de versement préalablement créés et de les rechercher au moyen de :

-   leur intitulé (champ MessageIdentifier),
-   leur service versant (champ SubmissionAgencyIdentifier).

***Point d’attention :***
La recherche est approchante.

  *Exemple : champ de recherche dans l’APP « Collecte et préparation des versements »*
  
  ![](medias/module_collecte/Pictures/ListeProjets.png)

Par ailleurs, pour un projet donné, il est possible de :

-   consulter son détail ;
-   consulter les transactions associées ;
-   consulter les archives associées.

L'accès aux projets de versement peut être restreint via l'utilisation d'un contrat d'accès. Ainsi, un utilisateur du front-office VitamUI devant accéder aux projets de versement
d'un service en particulier pourra ne voir que ceux-là si son profil utilisateur est associé à un contrat d'accès lui permettant d'accéder uniquement aux archives de ce service.

***Point d’attention :***
Au terme de la version 8.1, ce filtre n'est disponible que depuis le front-office VitamUI.

#### Modification d'un projet de versement

##### Utilisation des API

La solution logicielle Vitam permet de modifier un projet de versement, et plus précisément de :

-   modifier ses métadonnées,
-   lui ajouter des métadonnées,
-   supprimer des métadonnées.

  *Exemple : requête en vue de modifier des métadonnées d’un projet de versement dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*
``` 
  @tenant = 1
  
  PUT {{url}}/collect-external/v1/projects/
  accept: application/json
  content-type: application/json
  Content-Length: 401
  X-Tenant-Id: {{tenant}}
  
  {
    "#id": "**aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq**",
    "ArchivalAgencyIdentifier": "Vitam",
    "TransferringAgencyIdentifier": "RATP",
    "OriginatingAgencyIdentifier": "RATP",
    "SubmissionAgencyIdentifier": "RATP",
    "MessageIdentifier": "20200131-000006",
    "ArchivalAgreement":"IC-000001",
    "Comment": "Bulletins de salaire - Janvier 2020"
  }
``` 

***Points d’attention :***

-   Le service de mise à jour d’un projet de versement fonctionne en mode « annule et remplace ».
-   La plupart des champs d’une transaction étant facultatifs, il est recommandé d’indiquer les éléments obligatoires à la génération d’un SIP :

    -   le contrat d’entrée (champ « ArchivalAgreement »),
    -   l’identifiant du message (champ « MessageIdentifier),
    -   le service producteur (champ « OriginatingAgencyIdentifier »),
    -   le service d’archivage (champ « ArchivalAgencyIdentifier »),
    -   le service responsable du transfert (« TransferringAgencyIdentifier »)

-   Au terme de la version 8.1 :

    -   le module de collecte permet de modifier un rattachement ainsi que les conditions de rattachement. Néanmoins, il n'est pas recommandé de les modifier si une transaction contenant des archives a été créée, car la modification n'est pas répercutée dans cette transaction ;
    -   ce service ne vérifie pas le caractère obligatoire d’un champ. Il est fortement recommandé de veiller à ne pas supprimer un champ obligatoire, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   on ne peut pas ajouter de règles de gestion dans un projet de versement ;
    -   aucun contrôle n’est effectué avec les référentiels et unités archivistiques de rattachement présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de :

        -   veiller à inclure des références (ex. service producteur, contrat d’entrée, etc.) existant dans la solution, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
        -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

Cette action, non journalisée, provoque la mise à jour du projet.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | Présence d’un champ inconnu dans la requête. <br>Le projet n’existe pas. |

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet de modifier un projet de versement, avec, le cas échéant, la(les) transaction(s) associée(s) si elle(s) a(ont) un statut égal à « OPEN ».

***Point d’attention :***
Au terme de la version 8.1, il n’est pas possible, depuis les interfaces, de modifier :

-   les paramètres de rattachement ;
-   les conditions de rattachement ;
-   la gestion automatique des transactions ;
-   les règles de transformation.

#### Suppression d'un projet de versement

##### Utilisation des API

La solution logicielle Vitam permet de supprimer un projet de versement.

***Point d’attention :*** En prérequis à cette action, il faut avoir au préalable créé un projet de versement et le signaler dans l’API, pour une suppression de projet.

  *Exemple : requête en vue de supprimer un projet de versement dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*
```  
  @project-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
  DELETE {{url}}/collect-external/v1/projects/{{project-id}}
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
```  

Cette action provoque la suppression de l’enregistrement dans la base de données MongoDB, dans la collection « Project » (base *Collect*).
Si le projet de versement est associé à une transaction qui, elle-même contient des archives (unités archivistiques, objets techniques), l’ensemble des archives sont supprimées de la base de données et des offres de stockage :

    -   les unités archivistiques sont supprimées de la collection « Unit » (base *MetadataCollect*) ;
    -   les groupes d’objets techniques sont supprimées de la collection « ObjectGroup » (base *MetadataCollect*).
    -   les objets sont supprimés des offres de stockage ;

Lors de cette action, non journalisée, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | Le projet n’existe pas.<br>Le projet n’est pas reconnu dans la requête.|

##### Utilisation dans VitamUI

Au terme de la version 8.1, il n'est pas possible de supprimer un projet de versement depuis l'APP « Collecte et préparation des versements » du front-office VitamUI.

######################################################################################################
##### VERSEMENT ######################################################################################
######################################################################################################

### Versement

#### Définitions

Dans la solution logicielle Vitam, il est possible de préparer le versement d’un SIP conforme au Standard d’échanges des données pour l’archivage (SEDA) au moyen du module de collecte.

Ce module est propre à chaque tenant de la solution logicielle Vitam.

Il permet de recevoir dans un espace de stockage et des bases de données dédiés :

-   sous forme d’enregistrements JSON les informations relatives à :
    -   des métadonnées correspondant à l’en-tête du message ArchiveTransfer (Base Collect, Collection Transaction),
    -   des métadonnées descriptives et de gestion associées à des unités archivistiques (Base MetadataCollect, Collection Unit),
    -   le cas échéant, des métadonnées techniques (Base MetadataCollect, Collection ObjectGroup),

-   les objets associés.

À l’étape d’ajout des objets, la solution logicielle Vitam réalise une mise à jour des métadonnées techniques, qui inclut :

-   un calcul d’empreinte de l’objet,
-   un calcul du poids de l’objet (exprimé en octets),
-   une identification de format.

L’envoi des métadonnées et des objets peut s’effectuer de deux manières :

-   en mode « unitaire » : pour chaque type de métadonnées et pour chaque objet à collecter, le module de collecte reçoit une requête d’envoi ;
-   en mode « lot » : pour un ensemble d’unités archivistiques et d’objets, le module de collecte reçoit une unique requête lui faisant parvenir l’ensemble.

![](medias/module_collecte/Pictures/ImportsUnitairesOuLots.png)

Les fonctionnalités ont été conçues et réalisées de manière à prendre en compte :

-   1 à n unités archivistiques pour une transaction, correspondant à un ensemble de métadonnées d’en-tête,
-   0 à n parents pour les unités archivistiques,
-   1 groupe d’objets techniques par unité archivistique,
-   1 objet binaire pour une version d’usage de l’objet pour un groupe d’objets techniques donné.

***Point d’attention :*** Le versement des métadonnées et des objets dans le module de collecte n’est pas journalisé dans le journal des opérations.

#### Création d'une transaction

#### Utilisation des API

À un projet de versement peu(ven)t être associée(s) 1 à n transaction(s) (ou versement(s)).

Dans la transaction sont :

-   héritées des métadonnées correspondant aux informations dites d’en-tête préalablement définies dans le projet de versement, si elles ne sont pas définies dans la transaction ;
-   envoyées les métadonnées correspondant aux informations dites d’en-tête du bordereau telles que l’identifiant du message, qui sont spécifiques à la transaction.

***Point d’attention :***

-   En prérequis à la création d’une transaction, il faut avoir au préalable créé un projet de versement et le signaler dans l’API.
-   La création d’une transaction est un prérequis à l’ajout d’archives en mode « unitaire » ou en mode « lot ».

La transaction peut comporter les éléments suivants[^3] :

|  Champ                        |  Description|
| --- | --- |
|  Name                         |  Intitulé de la transaction (champ facultatif).|
|  ArchivalAgreement            |  Identifiant du contrat d’entrée utilisé pour réaliser l’entrée, destiné à alimenter le champ ArchivalAgreement du message ArchiveTransfer (champ facultatif).|
|  MessageIdentifier            |  Identifiant du lot d’objets, utilisé pour identifier les versements, destiné à alimenter le champ MessageIdentifier du message ArchiveTransfer (champ facultatif).|
|  Comment                      |  Précisions sur la demande de transfert destiné à alimenter le champ Comment du message ArchiveTransfer (champ facultatif).|
|  OriginatingAgencyIdentifier  |  Identifiant du service producteur, destiné à alimenter le champ OriginatingAgencyIdentifier du message ArchiveTransfer (champ facultatif).|
|  SubmissionAgencyIdentifier   |  Identifiant du service versant, destiné à alimenter le champ SubmissionAgencyIdentifier du message ArchiveTransfer (champ facultatif). <br>S’il est absent ou vide à l’initialisation de la transaction, alors la valeur contenue dans le champ OriginatingAgencyIdentifier est reportée dans ce champ.|
|  ArchivalAgencyIdentifier     |  Identifiant du service d’archivage, destiné à alimenter le champ ArchivalAgencyIdentifier du message ArchiveTransfer (champ facultatif).|
|  TransferringAgencyIdentifier |  Identifiant du service de transfert, destiné à alimenter le champ TransferringAgencyIdentifier du message ArchiveTransfer (champ facultatif).|
|  ArchivalProfile               |  Identifiant du profil d’archivage utilisé pour réaliser l’entrée, destiné à alimenter le champ ArchivalProfile du message ArchiveTransfer (champ facultatif).|
|  AcquisitionInformation       |  Modalité d’entrée.<br>Champ destiné à alimenter le champ AcquisitionInformation du message ArchiveTransfer (champ facultatif).|
|  LegalStatus                  |  Statut légal des archives, destiné à alimenter le champ LegalStatus du message ArchiveTransfer (champ facultatif).<br>Si le champ est renseigné, les valeurs attendues sont : « Public Archive », « Private Archive », « Public and Private Archive ».|

***Point d’attention :*** Au terme de la version 8.1 :

-   on ne peut pas inclure de règles de gestion dans la partie transactionnelle ;
-   aucun contrôle n’est effectué avec les référentiels et unités archivistiques de rattachement présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de :

    -   veiller à inclure des références (ex. service producteur, contrat d’entrée, etc.) existant dans la solution, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés ;
    -   renseigner les valeurs attendues par le SEDA pour le statut légal des archives, à savoir : « Public Archive », « PrivateArchive » ou « Public and Private Archive ».

-   la plupart des champs d’une transaction sont facultatifs. Néanmoins, il est recommandé d’indiquer les éléments obligatoires à la génération d’un SIP, soit dans le projet de versement, soit dans la transaction :

    -   le contrat d’entrée (champ « ArchivalAgreement »),
    -   l’identifiant du message (champ « MessageIdentifier),
    -   le service producteur (champ « OriginatingAgencyIdentifier »),
    -   le service d’archivage (champ « ArchivalAgencyIdentifier »),
    -   le service responsable du transfert (« TransferringAgencyIdentifier »)

-   s'ils ne sont pas renseignés dans la transaction, les champs suivants peuvent être hérités du projet de versement s'ils y ont été renseignés :

    -   le contrat d’entrée (champ « ArchivalAgreement »),
    -   l’identifiant du message (champ « MessageIdentifier),
	-   les précisions sur la demande de transfert (« Comment »),
    -   le service producteur (champ « OriginatingAgencyIdentifier »),
    -   le service versant (champ « SubmissionAgencyIdentifier »),
    -   le service d’archivage (champ « ArchivalAgencyIdentifier »),
    -   le service responsable du transfert (« TransferringAgencyIdentifier »),
	-   le profil d'archivage (« ArchivalProfile »),
	-   le statut légal des archives (« LegalStatus »),
	-   les modalités d'entrée (« AcquisitionInformation »),
	-   le profil d'archivage (« ArchivalProfile »),

  *Exemple : requête de création d’une transaction pour le projet de versement préalablement créé dont l’identifiant est aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq.*
  
```
  @project-id = **aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq**
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/projects/{{project-id}}/transactions
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  
  {
    "ArchivalAgencyIdentifier": "Vitam",
    "TransferringAgencyIdentifier": "AN",
    "OriginatingAgencyIdentifier": "MICHEL_MERCIER",
    "SubmissionAgencyIdentifier": "MICHEL_MERCIER",
    "MessageIdentifier": "20220302-000005",
    "ArchivalAgreement":"IC-000001",
    "Comment": "Archives bureautiques du cabinet de Michel Mercier"
  }
```

Cette action provoque la création d’un enregistrement dans la base de données MongoDB, dans la collection « Transaction »[^4] (base *Collect*).

À cet enregistrement, est associé :

-   un statut (champ « Status ») dont la valeur est égale à « OPEN »,
-   l’identifiant du projet de versement à l’origine de la création de la transaction (champ « ProjectId »),
-   une date de création (champ « CreationDate ») dont la valeur est égale à la date de création de l’enregistrement,
-   une date de dernière modification (champ « LastUpdate ») dont la valeur est égale à la date de création de l’enregistrement.

 *Exemple : enregistrement de la transaction dans la collection « Transaction »*
  
```
{
    "_id": "aeeaaaaaacecwapyabsgsamwiiin6eaaaaaq",
    "Name: "Archives bureautiques du cabinet de Michel Mercier",
    "Context: {
        "AcquisitionInformation": "Versement",
        "LegalStatus": "Private Archive",
		"ArchivalAgencyIdentifier": "Vitam",
    	"TransferringAgencyIdentifier": "AN",
    	"OriginatingAgencyIdentifier": "MICHEL_MERCIER",
    	"SubmissionAgencyIdentifier": "MICHEL_MERCIER",
    	"MessageIdentifier": "20220302-000005",
    	"ArchivalAgreement":"IC-000001",
    	"Comment": "Archives bureautiques du cabinet de Michel Mercier"
    },
    "Status": "OPEN",
    "CreationDate": "2025-04-17T04:45:24.115",
    "LastUpdate": "2025-04-17T04:45:24.296",
    "ProjectId": "aeaaaaaaaaecwapyabsgsamwiiin35iaaaaq",
    "_tenant": 0,
    "_v": 1
}
```

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - Présence d’un champ inconnu dans la requête.<br> - Le projet associé à la transaction n’existe pas.|

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam ne permet pas à l'utilisateur de créer une transaction.

Néanmoins, La création d'un projet de versement manuel entraîne la création d’une unique transaction qui hérite des informations saisies dans le projet :
-  description du versement (intitulé du message, description, service producteur et service versant),
-  contexte du versement (service d’archives et service responsable du transfert des archives, contrat d’entrée, profil d’archivage, modalité d’entrée, statut légal des versements).

***Point d’attention :*** La création du projet de versement de flux automatisé dans l’APP n’entraîne pas la création de transaction.

#### Alimentation d'une transaction en mode « unitaire »

L’envoi et l’enregistrement des archives dans le module de collecte s’effectue au moyen de trois commandes distinctes :

-   création unitaire des unités archivistiques,
-   création unitaire des groupes d’objets techniques,
-   ajout des objets.

***Points d’attention :***

-   En prérequis à la création d’une unité archivistique, il faut avoir au préalable créé une transaction et le signaler dans l’API.
-   L’ordre d’utilisation des API doit être respecté en vue d’enregistrer avec succès l’ensemble des métadonnées et objets constituant un versement (ou transaction).

##### Envoi d’unités archivistiques

###### Utilisation des API

À une transaction peu(ven)t être associée(s) 1 à n unité(s) archivistique(s).

Chaque unité archivistique :

-   doit définir un titre (Title) et un niveau de description (DescriptionLevel), qui sont des éléments rendus obligatoires en entrée de la solution logicielle Vitam ;
-   peut inclure :

    -   des règles de gestion ;
    -   des métadonnées descriptives supplémentaires ;
    -   un lien vers une unité archivistique de niveau supérieur.

***Points d’attention :***

-   En prérequis à la création d’une unité archivistique, il faut avoir au préalable créé une transaction et la signaler dans l’API. En outre, la transaction associée doit avoir un statut « OPEN »[^5] ;
-   Au terme de la version 8.1, aucun contrôle n’est effectué avec les référentiels présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de veiller à :

    -   inclure les métadonnées obligatoires attendues par la solution logicielle Vitam, à savoir un titre (Title) et un niveau de description (DescriptionLevel) ;
    -   inclure des règles de gestion existant dans la solution, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   veiller au bon nommage des éléments (ou vocabulaires internes), tout en respectant leurs caractéristiques (s’il s’agit d’une chaîne de caractères, d’une date, etc.), et à leur insertion dans l’ontologie, s’il s’agit de vocabulaires externes ;
    -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

 *Exemple : requête de création d’une unité archivistique pour la transaction préalablement créée dont l’identifiant est aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq.*

```
  @transaction-id = **aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq**
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/transactions/{{transaction-id}}/units
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  {
      "DescriptionLevel": "RecordGrp",
      "Title": "Discours du ministre",
      "#management": {
        "AccessRule": {
              "Rules": [
                  {
                      "Rule": "ACC-00001",
                      "StartDate": "2000-01-01"
                  }
              ]
          }
        }
  }
```

***Points d’attention :***

-   L’élément **#management** doit **toujours** être présent dans la requête, même si aucune règle de gestion n’est définie pour une unité archivistique donnée ;

 *Exemple : requête de création d’une unité archivistique qui ne définit pas de règle de gestion.*
 
``` 
  POST  {{url}}/collect-external/v1/transactions/{{transaction-id}}/units
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  {
      "DescriptionLevel": "RecordGrp",
      "Title": "Discours de Michel Mercier",
      **"#management": {
      }**
  }
``` 

-   Pour **associer une unité archivistique à une autre unité archivistique**, de niveau supérieur, il est recommandé de :

    -   créer en premier lieu l’unité archivistique de niveau supérieur et de récupérer son identifiant technique,
    -   ajouter parmi les métadonnées de l’unité archivistique de niveau inférieur le paramètre #unitups avec pour valeur l’identifiant de(s) unité(s) archivistique(s) de niveau supérieur.

 *Exemple : requête de création d’une unité archivistique incluant un rattachement à une unité archivistique de niveau supérieur.*
```  
  POST  {{url}}/collect-external/v1/transactions/{{transaction-id}}/units
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  {
      "DescriptionLevel": "Item",
      "Title": "Discours prononcé à l'occasion de l'audition devant la commission des lois relative à la proposition de loi constitutionnelle relative à la fonction de représentation par le Sénat des collectivités locales",
      "TransactedDate":"2010-12-08",
      **"#unitups": ["aeeaaaaaaghiyso4ablmyal74smvqcqaaaaq"]**,
      "#management": {
      }
  }
```  
Cette action provoque la création d’un enregistrement dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect*)[^6].
À cet enregistrement, sont associés :
- l’identifiant de la transaction (_opi),
- l'identifiant du service producteur (_sp et _sps).

Le cas échéant, l'action provoque également :
    - si le projet de versement déclarait un rattachement unique, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « STATIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation);
    - si le projet de versement déclarait un rattachement par clé / valeur, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « DYNAMIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation).

 *Exemple : enregistrement de l’unité archivistique dans la collection « Unit » de la base « MetadataCollect ».*
```
  {
   "_id": "aeeaaaaaaghdvam4abgoyambfxvoaoiaaaaq",
   "DescriptionLevel": "RecordGrp",
   "Title": "Discours du ministre",
   "_mgt": {
   "AccessRule": {
   "Rules": [
   {
   "Rule": "ACC-00001",
   "StartDate": "2000-01-01"
   }
   ]
   }
   },
   "_opi": "aeeaaaaaaghdvam4abgoyambfxnhd6aaaaaq",
   "_unitType": "INGEST",
   "_up": [],
   "_us": [],
   "_graph": [],
   "_sps": ["MICHEL_MERCIER"],
   "_sp": ["MICHEL_MERCIER"],
   "_uds": {},
   "_min": 1,
   "_max": 1,
   "_glpd": "2022-06-04T08:52:56.689",
   "_acd": "2022-06-04T08:52:56.689",
   "_aud": "2022-06-04T08:52:56.689",
   "_v": 0,
   "_av": 0,
   "_tenant": 1
  }
```

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | - L’unité archivistique n’a pas été associée à une transaction ; <br>- La transaction associée à l’unité archivistique n’existe pas ; <br> - La transaction associée à l’unité archivistique a été clôturée; <br> - L'unité archivistique n'est pas conforme au profil d'unité archivistique qu'elle déclare. |

###### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam ne permet pas à l'utilisateur d'utiliser ce mode pour alimenter une transaction.

##### Envoi des métadonnées techniques

###### Utilisation des API

À une unité archivistique donnée peut être associé un groupe d’objets techniques, dans lequel on peut ajouter unitairement une version d’objet d’un usage particulier.

Il est possible d’associer plusieurs usages à un groupe d’objets techniques :

-   original numérique (BinaryMaster),
-   original physique (PhysicalMaster),
-   copie numérique (Dissemination),
-   vignette (Thumbnail),
-   texte brut (TextContent).

***Point d’attention :***

-   En prérequis à la création de métadonnées techniques, il faut avoir au préalable créé :

    -   une transaction et la signaler dans l’API. En outre, la transaction associée doit avoir un statut « OPEN »[^7] ;
    -   une unité archivistique et la signaler dans l’API.

-   À cette étape, il n’est pas nécessaire d’envoyer les métadonnées correspondant à l’empreinte d’un fichier numérique, à l’identification de son format ou à son poids, dans la mesure où ce type de métadonnées est calculé lors de l’envoi du fichier numérique ;
-   Au terme de la version 8.1, il n’est pas possible de modifier les informations envoyées dans le module de collecte. De fait, il est fortement recommandé de veiller au bon nommage des éléments (ou vocabulaires internes), tout en respectant leurs caractéristiques (s’il s’agit d’une chaîne de caractères, d’une date, etc.), et à leur insertion dans l’ontologie, s’il s’agit de vocabulaires externes.
-   Par ailleurs, certains contrôles, disponibles au moment du transfert dans la solution logicielle Vitam n’ont pas été implémentés. Il est fortement recommandé de ne créer dans le module de collecte que des versions initiales d’objet numérique pour un usage donné.

 *Exemple : requête d’association d’un groupe d’objets techniques, et plus exactement une version initiale d’un original numérique, à une unité archivistique dont l’identifiant est aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq.*

```
  @transaction-id = aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq
  @unit-id = **aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq**
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/units/{{unit-id}}/objects/**BinaryMaster/1**
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  {
    "FileInfo": {
      "Filename": "Test01.jpeg"
    }
  }
```

Cette action provoque la création d’un enregistrement dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^8]*).
À cet enregistrement, sont associés :
-  l’identifiant de la transaction (_opi),
-  l’identifiant du service producteur (_sp).

 *Exemple : enregistrement des métadonnées techniques dans la collection « ObjectGroup » de la base « MetadataCollect ».*
  
```
  {
   "_id": "aeeaaaaaaghdvam4abgoyambfxzdbviaaaaq",
   "_tenant": 1,
   "FileInfo": {
   "Filename": "Test01.jpeg"
   },
   "_nbc": 2,
   "_opi": "aeeaaaaaaghdvam4abgoyambfxnhd6aaaaaq",
   "_sp": "MICHEL_MERCIER",
   "_qualifiers": [
   {
   "qualifier": "BinaryMaster",
   "_nbc": 1,
   "versions": [
   {
   "_id": "aeeaaaaaaghdvam4abgoyambfxzdbvyaaaaq",
   "DataObjectVersion": "BinaryMaster_1",
   "FileInfo": {
   "Filename": "Test01.jpeg"
   },
   "Size": 0
   }
   ]
   }
   ],
   "_v": 1,
   "_av": 1,
   "_acd": "2023-01-02T12:01:34.629",
   "_aud": "2023-01-02T12:01:34.629"
  }
```

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | - L’ unité archivistique n’existe pas ou est erronée ; <br>- L’objet technique n’a pas été associé à une unité archivistique ; <br>- La requête renvoie une deuxième fois une demande de création d’un usage d’objet ayant déjà été versé dans le module de collecte ;<br>- La transaction associée n’existe pas ;<br> - La transaction associée a été clôturée.<br>

###### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam ne permet pas à l'utilisateur d'utiliser ce mode pour alimenter une transaction.

##### Envoi des objets

###### Utilisation des API

À une unité archivistique associée à un groupe d’objets techniques et pour un usage et une version d’objet donné, on peut ajouter unitairement un objet numérique.

***Point d’attention :***

-   En prérequis à l’envoi d’un objet, il faut avoir au préalable créé :

    -   une transaction et la signaler dans l’API. En outre, la transaction associée doit avoir un statut « OPEN »[^9] ;
    -   une unité archivistique et la signaler dans l’API.

 *Exemple : requête d’association d’un fichier numérique, et plus exactement une version initiale d’un original numérique, à une unité archivistique dont l’identifiant est aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq.*
```  
  @transaction-id = aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq
  @unit-id = **aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq**
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/units/{{unit-id}}/objects/**BinaryMaster/1/binary**
  Accept: application/json
  Content-Type: application/octet-stream
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  < /MichelMercier/Discours/Test01.jpeg
```  

Cette action provoque :

-   l’enregistrement de l’objet numérique sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec, calculés lors de l’envoi de l’objet numérique :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets.

 *Exemple : ajout de l’empreinte du fichier et de son identification de format et mise à jour du poids dans la collection « ObjectGroup » de la base « MetadataCollect ».*
```  
  {
   "_id": "aeeaaaaaaghdvam4abgoyambfxzdbviaaaaq",
   "_tenant": 1,
   "FileInfo": {
   "Filename": "Test01.jpeg"
   },
   "_nbc": 2,
   "_opi": "aeeaaaaaaghdvam4abgoyambfxnhd6aaaaaq",
   "_sp": "MICHEL_MERCIER",
   "_qualifiers": [
   {
   "qualifier": "BinaryMaster",
   "_nbc": 1,
   "versions": [
   {
   "_id": "aeeaaaaaaghdvam4abgoyambfxzdbvyaaaaq",
   "DataObjectVersion": "BinaryMaster_1",
   **"FormatIdentification": {**
   "FormatLitteral": "JPEG File Interchange Format",
   "MimeType": "image/jpeg",
   "FormatId": "fmt/43"
  ** }**,
   "FileInfo": {
   "Filename": "Test01.jpeg"
   },
   ** "Size": 7702,**
   "Uri": "Content/Test01.jpeg",
   "MessageDigest": "0e0cec05a1d72ee5610eaa5afbc904c012d190037cbc827d08272102cdecf0226efcad122b86e7699f767c661c9f3702379b8c2cb01c4f492f69deb200661bb9",
   "Algorithm": "SHA-512"
   }
   ]
   }
   ],
   "_v": 1,
   "_av": 1,
   "_acd": '"023-01-02T12:01:34.629",
   "_aud": "2023-01-02T12:01:34.965"
  }
```

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | - L’ unité archivistique n’existe pas ou est erronée ;<br>- Le groupe d’objets techniques n’existe pas ;i<br>- La transaction associée n’existe pas ;<br>- La transaction associée a été clôturée. |

***Point d’attention :*** Certains contrôles, disponibles au moment du transfert dans la solution logicielle Vitam n’ont pas été implémentés. Il est fortement recommandé de ne pas envoyer dans le module de collecte plusieurs objets numériques pour un usage et une version donnée.

###### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam ne permet pas à l'utilisateur d'utiliser ce mode pour alimenter une transaction.

#### Alimentation d'une transaction en mode « lot »

L’envoi et l’enregistrement des données dans le module de collecte peut s’effectuer en lot au moyen d’une commande pouvant fonctionner de deux façons :

-   envoi sous forme de zip d’une arborescence bureautique,
-   envoi sous forme de zip d’une arborescence bureautique et d’un fichier annexe intitulé « metadata.csv » ou « metadata.jsonl » référençant des métadonnées descriptives et de gestion.

***Point d’attention :*** Pour ces deux envois, la commande est unique. Seule l’association d’un fichier annexe « metadata.csv » ou « metadata.jsonl », optionnelle, diffère.

##### Envoi d’une arborescence bureautique

###### Utilisation des API

Pour une transaction donnée est envoyée une arborescence bureautique sous forme de zip.

***Point d’attention :***

-   En prérequis à l’envoi d’une arborescence bureautique, il faut avoir au préalable créé une transaction et le signaler dans l’API.

 *Exemple : requête d’envoi d’une arborescence bureautique stream.zip pour la transaction préalablement créée dont l’identifiant est aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq.*
 
``` 
  @transaction-id = **aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq**
  @tenant = 1
  
  POST {{url}}/collect-external/v1/transactions/{{transaction-id}}/upload
  Accept: application/json
  Content-Type: application/zip
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
  
  < /path_tozip/**stream.zip**
```

Cette action provoque :

-   la création des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement[^11] :

    -   un niveau de description (DescriptionLevel) dont la valeur est :

        -   « RecordGrp » pour une unité archivistique référençant un répertoire,
        -   « Item » pour une unité archivistique référençant un objet numérique ;

    -   un intitulé (Title), correspondant au nom d’un répertoire ou d’un objet binaire présent dans l’arborescence bureautique.

    À chaque enregistrement, est associé :
		-   l’identifiant de la transaction (_opi),
        -   l'identifiant du service producteur (_sp et _sps);

-   la création de métadonnées techniques dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^12]*) ;

    À chaque enregistrement, est associé :
		-   l’identifiant de la transaction (_opi),
        -   l'identifiant du service producteur (_sp);

-   l’enregistrement des objets numériques sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec, calculés lors de l’envoi du fichier numérique :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets.

-   le cas échéant :

    - si le projet de versement déclarait un rattachement unique, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « STATIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation);
    - si le projet de versement déclarait un rattachement par clé / valeur, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « DYNAMIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation).

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec |  Le fichier .zip n’a pas été téléchargé pour cause de nom erroné ou de chemin introuvable<br> La transaction n’existe pas ou est erronée.<br>La transaction a été clôturée. |

Elle n’est pas journalisée dans le journal des opérations.

Point d’attention :

-   Aucun fichier ne doit avoir un poids équivalent à 0 octet.
-   Au terme de la V.8.1, il est recommandé que les noms de répertoires et de fichiers ne contiennent ni caractère accentué, ni virgule, ni apostrophe, ni parenthèse, ni espace, ni élément de ponctuation, ou tout autre caractère spécial. Ne sont à privilégier que l’underscore et le tiret comme séparateurs.
    Néanmoins, s’ils en contiennent et si l’arborescence bureautique émane d’un environnement Windows, il est recommandé d’utiliser l’outil Winzip pour la zipper, afin d’éviter des problèmes d’encodage.

###### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet de verser une arborescence bureautique, le cas échéant accompagnée d’un fichier « metatadata.csv », lors de la création d’un projet de versement manuel au moyen d’un wizard ou boîte de dialogue.

Le détail du projet de versement, ainsi que les archives qui lui sont associées sont par ailleurs accessibles depuis l’APP.

##### Envoi d’une arborescence bureautique avec fichier .csv de métadonnées

###### Utilisation des API

Pour une transaction donnée peut être envoyé sous forme de zip en plus d’une arborescence bureautique[^13] un fichier .csv contenant des métadonnées détaillant unitairement les unités archivistiques.

Le fichier .csv, obligatoirement intitulé « metadata.csv », est composé de x colonnes[^14] :

-   File : chemin relatif à partir de l’emplacement où est enregistré le fichier .csv (colonne obligatoire) ;
-   ObjectFiles : chemin relatif des fichiers numériques dont certains peuvent être rattachés à des répertoires déclarés dans la colonne File (colonne facultative) ;
-   DescriptionLevel : niveau de description de l’unité archivistique (colonne facultative) ;
-   Title : intitulé de l’unité archivistique (colonne facultative) ;
-   toute colonne correspondant à un champ du standard SEDA (colonnes facultatives).

 *Exemple : contenu d’un fichier « metadata.csv ».*

```csv  
  "File";"Content.DescriptionLevel";"Content.Title";"Content.FilePlanPosition";"Content.ArchivalAgencyArchiveUnitIdentifier";"Content.Description";"Content.CustodialHistory.CustodialHistoryItem.0";"Content.CustodialHistory.CustodialHistoryItem.1";"Content.CustodialHistory.CustodialHistoryItem.2";"Content.DocumentType";"Content.Language";"Content.DescriptionLanguage";"Content.Version";"Content.Tag.0";"Content.Tag.1";"Content.Tag.2";"Content.Tag.3";"Content.Tag.4";"Content.Keyword.0.KeywordContent";"Content.Keyword.0.KeywordType";"Content.Keyword.1.KeywordContent";"Content.Keyword.1.KeywordType";"Content.Keyword.2.KeywordContent";"Content.Keyword.2.KeywordType";"Content.Keyword.3.KeywordContent";"Content.Keyword.3.KeywordType";"Content.Keyword.4.KeywordContent";"Content.Keyword.4.KeywordType";"Content.Coverage.Spatial.0";"Content.Coverage.Spatial.1";"Content.Coverage.Spatial.2";"Content.Coverage.Spatial.3";"Content.Coverage.Temporal";"Content.Coverage.Juridictional.0";"Content.Coverage.Juridictional.1";"Content.Coverage.Juridictional.2";"Content.Coverage.Juridictional.3";"Content.OriginatingAgency.Identifier";"Content.SubmissionAgency.Identifier";"Content.StartDate";"Content.EndDate";"Management.AccessRule.Rule";"Management.AccessRule.StartDate"
  "AU1\27juillet1888\5FI6\_5FI6\_16";"RecordGrp";"Brantes. Combe de la Mure.";"instrument_recherche/5FI6/5FI6_16";"5 Fi 6/16";"Dim. 18x24 cm.";;;;;"fre";"fre";"Original";"Combe de la Mure (Brantes, Vaucluse, France)";"Brantes (Vaucluse, France)";;;;"Combe de la Mure (Brantes, Vaucluse, France)";"geogname";"Brantes (Vaucluse, France)";"geogname";;;;;;;"Combe de la Mure (Brantes, Vaucluse, France)";"Brantes (Vaucluse, France)";;;1888;"Combe de la Mure (Brantes, Vaucluse, France)";"Brantes (Vaucluse, France)";;;;;;"1888-12-30T00:00:00";"ACC-00001";"1888-12-30"
  "AU1\27juillet1888";"RecordGrp";"Clichés du 27 juillet 1888";;;;;;;;"fre";"fre";;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
```

 *Exemple : contenu d’un fichier « metadata.csv » décrivant un contexte de signature détachée.*

```csv  
  "File";"ObjectFiles";"Content.DescriptionLevel";"Content.Title";"Content.Description";"Content.DocumentType";"Content.Tag";"Content.EndDate";"Content.SigningInformation.SigningRole.0";"Content.SigningInformation.SigningRole.1";"Content.SigningInformation.SigningRole.2";"Content.SigningInformation.SignatureDescription.0.Signer.FullName";"Content.SigningInformation.SignatureDescription.0.Signer.SigningTime";"Content.SigningInformation.TimestampingInformation.TimeStamp";"Content.SigningInformation.AdditionalProof.0.AdditionalProofInformation.0";"Content.SigningInformation.AdditionalProof.0.AdditionalProofInformation.1";"Management.AppraisalRule.Rule";"Management.AppraisalRule.StartDate";"Management.AppraisalRule.FinalAction";"Management.AccessRule.Rule";"Management.AccessRule.StartDate"
  "**Parapheur**";"Parapheur\20230615_note_Vu AB.pdf";"Item";"20230615_note_Vu AB.pdf";"Parapheur créé par Al Capone. Note";"Document signé";"Note";"2023-06-15";"SignedDocument";"Signature";"Timestamp";"Al Capone";"2023-06-15T11:18:12";"2023-06-15T11:18:12";"EvidenceRecords";"Report";"APP-00003";"2023-06-15";"Keep";"ACC-00020";"2023-06-15"
  "Parapheur\aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq-evidenceRecord.pdf";"**Parapheur\aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq-evidenceRecord.pdf**";"Item";"aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq-evidenceRecord.pdf";;"Fichier de preuve";;;"AdditionalProof";;;;;;;;;;;;
  "Parapheur\report_aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq.pdf";"**Parapheur\report_aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq.pdf**";"Item";"report_aeaaaaaaaaecb7ovabhryamreeao2oyaaaaq.pdf";;"Rapport";;;"AdditionalProof";;;;;;;;;;;;```
```

 *Exemple : contenu d’un fichier « metadata.csv » déclarant un rattachement.*

```csv  
  "File";"Content.DescriptionLevel";"Content.Title";**"Management.UpdateOperation.ArchiveUnitIdentifierKey.MetadataName**";"**Management.UpdateOperation.ArchiveUnitIdentifierKey.MetadataValue**"
  "Discours hors parlement";"RecordGrp";"Discours hors parlement";"**ArchivalAgencyArchiveUnitIdentifier**";"**20130456/3**"
  "Discours hors parlement\Discours d'inauguration";"RecordGrp";"Discours d’inauguration";;
  "Discours hors parlement\Discours d'inauguration\Inauguration de Notre-Dame.odt";"Item";"Inauguration de Notre-Dame";;
```

***Points d’attention :***

-   la colonne File doit toujours être placée en première position ;
-   une première ligne d’en-tête donnant le nom des colonnes doit être présente, chaque ligne décrivant ensuite une unité archivistique ;
-   le séparateur entre les colonnes est le *point-virgule*, le séparateur de texte les guillemets doubles et l’encodage est « *UTF-8* » ;
-   le fichier .csv ne référence que des métadonnées propres aux unités archivistiques (métadonnées descriptives et de gestion). Il ne supporte pas les métadonnées techniques propres aux fichiers numériques ;
-   seul un objet peut être associé à un enregistrement. Ce format d’import ne permet pas de facto de gérer l’import de groupe d’objets techniques disposant de plusieurs objets aux usages différents devant être référencés par la même unité archivistique.
-   le fichier .csv à importer doit se trouver dans le même répertoire que le répertoire correspondant à la racine de la structure arborescente de fichiers à importer.
-   chaque répertoire et objet numérique devant contenir des métadonnées particulières doit être référencé dans le fichier .csv ;
-   si le fichier .csv déclare un rattachement à une unité archivistique, il doit matérialiser cette unité archivistique par une ligne dédiée correspondant à un dossier dans l'arborescence bureautique. 
    Dans cette ligne :
    -   Ne devront être renseignées que les informations suivantes : 
	    -  DescriptionLevel, 
		-  Title,
		-  UpdateOperation.ArchiveUnitIdentifierKey.MetadataName et Management.UpdateOperation.ArchiveUnitIdentifierKey.MetadataValue OU UpdateOperation.SystemId.
    -   Un rattachement ne peut être déclaré que dans un répertoire racine.

-   concernant le nommage des colonnes :

    -   pour les colonnes correspondant à des champs du standard SEDA, l’intitulé de la colonne doit correspondre à celui du champ dans le standard SEDA, précédé de « Management. » s’il s’agit d’une métadonnée de gestion (ex. « Management.AccessRule.Rule » pour une règle de communicabilité) ou de « Content » s’il s’agit d’une métadonnée descriptive (ex. « Content.DocumentType ») ;
    -   quand le schéma XML du standard SEDA propose une structure complexe de balises (par exemple pour décrire un auteur via l’objet XML &lt;Writer&gt; qui contient plusieurs balises XML comme FullName ou BirthName), il convient d’intituler la colonne de la manière suivante : Content.Writer.FullName ou Content.Writer.BirthName ;
    -   quand un champ ou un objet XML est multivalué dans le standard SEDA (et qu’il est possible d’en décrire plusieurs dans le bordereau comme c’est le cas pour l’objet Writer par exemple), il convient de numéroter la colonne de la manière suivante : Content.Writer.0.FullName, Content.Writer.1.FullName ;

-   concernant le contenu des colonnes :

    -   la colonne File :

        -   ne doit pas comprendre d’espace avant ou après les « \\ » ;
        -   doit correspondre à un chemin tel que décrit par l’explorateur de fichiers (avec des « \\ » et non des « / ») ;

    -   la colonne DescriptionLevel ne doit comprendre que les valeurs autorisées par le standard SEDA : Collection, Fonds, Series, SubSeries, RecordGrp, File, Item ;
    -   les colonnes correspondant à des champs Date dans le standard SEDA doivent être formatées conformément à la norme ISO 8601 (AAAA-MM-JJ) ;
    -   les références à des règles de gestion et à des profils d’unité archivistique doivent se conformer aux identifiants de règles présents dans le SAE

-   Aucun fichier ne doit avoir un poids équivalent à 0 octet.
-   Les dates de début (Content.StartDate) doivent être antérieures aux dates de fin (Content.EndDate).
-   Au terme de la V.8.1, il est recommandé que les noms de répertoires et de fichiers ne contiennent ni caractère accentué, ni virgule, ni apostrophe, ni parenthèse, ni espace, ni élément de ponctuation, ou tout autre caractère spécial. Ne sont à privilégier que l’underscore et le tiret comme séparateurs.

    Néanmoins, s’ils en contiennent et si l’arborescence bureautique émane d’un environnement Windows, il est recommandé d’utiliser l’outil Winzip pour la zipper, afin d’éviter des problèmes d’encodage.

L’import du fichier .zip incluant un fichier .csv et une arborescence bureautique provoque :

-   la création des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^15]*). Sont enregistrées automatiquement les valeurs portées dans le fichier .csv si l’enregistrement ne contient pas d’erreur.

    À chaque enregistrement, est associé :
	
	-   l’identifiant de la transaction (_opi) ;
	-   un identifiant de batch (_batchId) ;
	-   la localisation initiale du dossier ou du fichier dans l'arborescence (_uploadPath),
	-   l'identifiant du service producteur (_sp et _sps) ;

-   la création de métadonnées techniques dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^16]*).

    À chaque enregistrement, est associé :
	-  l’identifiant de la transaction (_opi) ;
    -   un identifiant de batch (_batchId) ;
	-  l'identifiant du service producteur (_sp) ;

-   l’enregistrement des objets numériques sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets, calculés lors de l’envoi du fichier numérique ;
	
-   le cas échéant :

    - si le projet de versement déclarait un rattachement unique, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « STATIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation);
    - si le projet de versement déclarait un rattachement par clé / valeur, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « DYNAMIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation).

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | Le fichier .zip n’a pas été téléchargé pour cause de nom erroné ou de chemin introuvable ; Le fichier .csv contient au moins une erreur ; La transaction n’existe pas ou est erronée ; La transaction est clôturée. |

Cette action n’est pas journalisée dans le journal des opérations.

***Point d’attention :*****

-   Au terme de la V.8.1, le module de collecte peut :

	-  bloquer l'import de l’arborescence bureautique accompagnée d’un fichier CSV si ce dernier comporte les erreurs suivantes :
	   -   il ne contient pas au moins la colonne obligatoire File ;
	   -   au moins un fichier référencé dans le fichier .csv n'est pas présent dans l'arborescence bureautique,
	   -   il ne contient aucune information ;
	   -   il ne contient pas de séparateurs de champs ;
	   -   il contient des virgules, des espaces, des pipes comme séparateurs de champs ;
	   -   le fichier contient des simples guillemets comme séparateurs de texte ;
	   -   etc.
	   L'API peut :
	       - soit renvoyer une seule erreur, si cette erreur est bloquante,
		   - soit renvoyer jusqu'à 20 erreurs, si ces erreurs sont cumulables.
	   L'arborescence bureautique ne sera pas importée.
	
	-  ne pas bloquer l'import de l’arborescence bureautique accompagnée d’un fichier CSV si ce dernier comporte les erreurs suivantes :
       -   il dispose d’un champ dont le contenu est mal formaté (ex. ReceivedDate écrite en chaîne de caractères) ;
    Une erreur est alors renvoyée par l’API, le contenu du fichier CSV sera ignoré et seule l’arborescence bureautique sera téléchargée selon le comportement décrit dans la sous-section précédente.

-   Aucun contrôle n’est effectué entre le nombre de répertoires et d’objets binaires présents dans l’arborescence bureautique et les éléments décrits dans le fichier .csv. Il est recommandé de veiller à ne pas ajouter de niveaux intermédiaires dans l’arborescence bureautique non référencés dans le fichier .csv, car ils seront automatiquement créés dans le module de collecte selon le comportement décrit dans la sous-section précédente.

###### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet de verser une arborescence bureautique, le cas échéant accompagnée d’un fichier « metadata.csv », lors de la création d’un projet de versement manuel au moyen d’un wizard ou boîte de dialogue.

Le détail du projet de versement, ainsi que les archives qui lui sont associées sont par ailleurs accessibles depuis l’APP.

***Point d’attention :***

-   Si un fichier metadata.csv est associé à une arborescence bureautique, il faut d’abord télécharger cette dernière dans le wizard ou boîte de dialogue, puis faire de même avec le fichier « metadata.csv » ;
-   Si le nom du fichier .csv est erroné, l’interface VitamUI l’interprétera comme un fichier numérique à collecter au même titre que l’arborescence bureautique associée ;
-   Au terme de la V.8.1, l’APP « Collecte et préparation des versements » ne renvoie pas d'erreurs lors de l’import de l’arborescence bureautique accompagnée d’un fichier CSV si ce dernier comporte les erreurs suivantes.

##### Envoi d’une arborescence bureautique avec fichier .jsonl de métadonnées

###### Utilisation des API

Pour une transaction donnée peut être envoyé sous forme de zip en plus d’une arborescence bureautique[^13] un fichier .jsonl contenant des métadonnées détaillant unitairement les unités archivistiques.

Le fichier .jsonl, obligatoirement intitulé « metadata.jsonl », est composé de :

-   File : chemin relatif à partir de l’emplacement où est enregistré le fichier .jsonl (champ obligatoire) ;
-   Selector : liste de conditions permettant l'enregistrement des métadonnées dans une unité archivistique correspond à ces conditions (champ obligatoire) ;
-   ObjectFiles : chemin relatif des fichiers numériques dont certains peuvent être rattachés à des répertoires déclarés dans la colonne File (champ facultatif) ;
-   UnitContent : bloc dans lequel sont insérées les métadonnées descriptives et de gestion d'une unité archivistique (champ obligatoire), dont :
    -   DescriptionLevel : niveau de description de l’unité archivistique (champ facultatif) ;
    -   Title : intitulé de l’unité archivistique (champ facultatif) ;
    -   tout champ correspondant à un champ du standard SEDA (champs facultatifs).

 *Exemple : contenu d’un fichier « metadata.jsonl ».*

```
{ "File": "File", "UnitContent": { "DescriptionLevel": "Collection", "Title": "File", "Description": "Ceci est un versement de bulletins de paie", "StartDate": "2023-01-01", "EndDate": "2023-01-31", "Tag": [ "Paie", "Bulletin" ] } }
{ "File": "File/BP_123456_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123456_20230131.pdf", "OriginatingSystemId": [ "BP_123456_20230131" ], "Agent": [ { "FirstName": "DUPONT", "BirthName": "Charles", "Identifier": [ "123456" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00001", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } }
{ "File": "File/BP_123463_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123463_20230131.pdf", "OriginatingSystemId": [ "BP_123463_20230131" ], "Agent": [ { "FirstName": "DUPOND", "BirthName": "Victor", "Identifier": [ "123463" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00002", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } }
{ "File": "File/BP_123464_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123464_20230131.pdf", "OriginatingSystemId": [ "BP_123464_20230131" ], "Agent": [ { "FirstName": "CHARLES", "BirthName": "Ray", "Identifier": [ "123464" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00002", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } } 
```

 *Exemple : contenu d’un fichier « metadata.jsonl » décrivant un contexte de signature détachée.*

```  
{ "File" : "My Root Folder", "ObjectFiles": "SomeFile.xml", "UnitContent": { "Title": "My Root Folder (with attached SomeFile.xml)" } }
{ "File" : "My Root Folder/MyFile1.txt", "ObjectFiles": null, "UnitContent": { "Title": "My Root Folder/MyFile1.txt" } }
{ "File" : "My Root Folder/MyFile2.txt", "ObjectFiles": "My Root Folder/MyFile2.txt", "UnitContent": { "Title": "My Root Folder/MyFile2.txt" } }
{ "File" : "My Root Folder/SubFolder", "ObjectFiles": "My Root Folder/SubFolder/MyFile3.txt", "UnitContent": { "Title": "My Root Folder/SubFolder (with attached MyFile3.txt)" } }
{ "Selector" : { "#uploadPath" : "Yet Another Folder" }, "ObjectFiles": "My Root Folder/SubFolder/MyFile4.txt", "UnitContent": { "Title": "Yet Another Folder (with attached MyFile4.txt)" } }
```

 *Exemple : contenu d’un fichier « metadata.jsonl » déclarant un rattachement.*

```
{ "File": "Discours hors parlement", "UnitContent": { "DescriptionLevel": "RecordGrp", "Title": "Discours hors parlement", "#management": { "UpdateOperation": { "ArchiveUnitIdentifierKey" : { "MetadataName" : "ArchivalAgencyArchiveUnitIdentifier", "MetadataValue" : "20130456/3"} }  } } }
{ "File": "Discours hors parlement/Discours d'inauguration", "UnitContent": { "DescriptionLevel": "RecordGrp", "Title": "Discours d’inauguration" } }
{ "File": "Discours hors parlement/Discours d'inauguration/Inauguration de Notre-Dame.odt", "UnitContent": { "DescriptionLevel": "Item", "Title": "Inauguration de Notre-Dame" } }
 
```

***Points d’attention :***

-   le fichier .jsonl doit toujours contenir un champ File *ou* un champ Selector. Celui-ci doit toujours être placée en première position ;
-   les métadonnées pouvant être utilisées comme conditions dans le champ Selector doivent des éléments simples de type string, boolean, long ou double.
-   le fichier .jsonl ne référence que des métadonnées propres aux unités archivistiques (métadonnées descriptives et de gestion). Il ne supporte pas les métadonnées techniques propres aux fichiers numériques ;
-   seul un objet peut être associé à un enregistrement. Ce format d’import ne permet pas de facto de gérer l’import de groupe d’objets techniques disposant de plusieurs objets aux usages différents devant être référencés par la même unité archivistique.
-   le fichier .jsonl à importer doit se trouver dans le même répertoire que le répertoire correspondant à la racine de la structure arborescente de fichiers à importer.
-   chaque répertoire et objet numérique devant contenir des métadonnées particulières doit être référencé dans le fichier .jsonl ;
-   si le fichier .jsonl déclare un rattachement à une unité archivistique, il doit matérialiser cette unité archivistique par une ligne dédiée correspondant à un dossier dans l'arborescence bureautique. 
    Dans cette ligne :
    -   Ne devront être renseignées que les informations suivantes : 
	    -  DescriptionLevel, 
		-  Title,
		-  UpdateOperation.ArchiveUnitIdentifierKey.MetadataName et Management.UpdateOperation.ArchiveUnitIdentifierKey.MetadataValue OU UpdateOperation.SystemId.
    -   Un rattachement ne peut être déclaré que dans un répertoire racine.

-   le nommage des champs et leur structuration en JSON doivent se conformer au modèle de données de la solution logicielle Vitam.

-   concernant le contenu des champs :

    -   la colonne File :

        -   ne doit pas comprendre d’espace avant ou après les « \\ » ;
        -   doit correspondre à un chemin tel que décrit par l’explorateur de fichiers (avec des « \\ » et non des « / ») ;

    -   le champ DescriptionLevel ne doit comprendre que les valeurs autorisées par le standard SEDA : Collection, Fonds, Series, SubSeries, RecordGrp, File, Item ;
    -   les champs correspondant à des champs Date dans le standard SEDA doivent être formatés conformément à la norme ISO 8601 (AAAA-MM-JJ) ;
    -   les références à des règles de gestion et à des profils d’unité archivistique doivent se conformer aux identifiants de règles présents dans le SAE

-   Aucun fichier ne doit avoir un poids équivalent à 0 octet.
-   Les dates de début (Content.StartDate) doivent être antérieures aux dates de fin (Content.EndDate).
-   Au terme de la V.8.1, il est recommandé que les noms de répertoires et de fichiers ne contiennent ni caractère accentué, ni virgule, ni apostrophe, ni parenthèse, ni espace, ni élément de ponctuation, ou tout autre caractère spécial. Ne sont à privilégier que l’underscore et le tiret comme séparateurs.

    Néanmoins, s’ils en contiennent et si l’arborescence bureautique émane d’un environnement Windows, il est recommandé d’utiliser l’outil Winzip pour la zipper, afin d’éviter des problèmes d’encodage.

L’import du fichier .zip incluant un fichier .jsonl et une arborescence bureautique provoque :

-   la création des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^15]*). Sont enregistrées automatiquement les valeurs portées dans le fichier .csv si l’enregistrement ne contient pas d’erreur.

    À chaque enregistrement, est associé :
	
	-   l’identifiant de la transaction (_opi) ;
	-   un identifiant de batch (_batchId) ;
	-   la localisation initiale du dossier ou du fichier dans l'arborescence (_uploadPath),
	-   l'identifiant du service producteur (_sp et _sps) ;

-   la création de métadonnées techniques dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^16]*).

    À chaque enregistrement, est associé :
	-  l’identifiant de la transaction (_opi) ;
    -   un identifiant de batch (_batchId) ;
	-  l'identifiant du service producteur (_sp) ;

-   l’enregistrement des objets numériques sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets, calculés lors de l’envoi du fichier numérique ;
	
-   le cas échéant :

    - si le projet de versement déclarait un rattachement unique, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « STATIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation);
    - si le projet de versement déclarait un rattachement par clé / valeur, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « DYNAMIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation).

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | Le fichier .zip n’a pas été téléchargé pour cause de nom erroné ou de chemin introuvable ; Le fichier .jsonl contient au moins une erreur ; La transaction n’existe pas ou est erronée ; La transaction est clôturée. |

Cette action n’est pas journalisée dans le journal des opérations.

***Point d’attention :*****

-   Au terme de la V.8.1, le module de collecte peut :

	-  bloquer l'import de l’arborescence bureautique accompagnée d’un fichier .jsonl si ce dernier comporte les erreurs suivantes :
	   -   il ne contient pas au moins le champ obligatoire File ;
	   -   au moins un bloc UnitContent ne contient aucune information ;
	   -   au moins un fichier référencé dans le fichier .jsonl n'est pas présent dans l'arborescence bureautique,
	   -   il ne contient aucune information ;
	   -   une date de fin de règle a été intégrée dans le fichier .jsonl ;
	   -   il dispose d’un champ dont le contenu est mal formaté (ex. ReceivedDate écrite en chaîne de caractères) ;
    
	   -   etc.
	   L'API peut :
	       - soit renvoyer une seule erreur, si cette erreur est bloquante,
		   - soit renvoyer jusqu'à 20 erreurs, si ces erreurs sont cumulables.
	   L'arborescence bureautique ne sera pas importée.

-   Aucun contrôle n’est effectué entre le nombre de répertoires et d’objets binaires présents dans l’arborescence bureautique et les éléments décrits dans le fichier .jsonl. Il est recommandé de veiller à ne pas ajouter de niveaux intermédiaires dans l’arborescence bureautique non référencés dans le fichier .jsonl, car ils seront automatiquement créés dans le module de collecte selon le comportement décrit dans la sous-section précédente.

###### Utilisation dans VitamUI

Il n'est pas possible d'importer une arborescence bureautique accompagnée d'un fichier .jsonl depuis l’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam.


######################################################################################################
##### ACCES ##########################################################################################
######################################################################################################

### Accès

#### Définitions

Après versement d'archives dans le module de collecte, il est possible de rechercher et de consulter :

-  les informations ayant trait au versement,
-  les archives associées à un versement.

Cette recherche et consultation est propre à chaque tenant de la solution logicielle Vitam.

#### Accès aux informations du versement

##### Utilisation des API

Pour un projet donné, la solution logicielle Vitam permet de :

-   accéder à la liste des transactions associées créées sur un tenant donné,
-   consulter les informations d’une transaction en particulier sur un tenant donné.

  *Exemple : requête en vue d’obtenir l’ensemble des transactions d’un projet de versement disponibles sur un tenant donné*
``` 
  @tenant = 1
  @project-id = aeeaaaaaaghpmborabjyyambxjekiyyaaaaq
  
  GET {{url}}/collect-external/v1/projects/{{project-id}}/transactions
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
``` 

Cette action peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - Un paramètre (identifiant du projet) contient une mauvais valeur.<br> - Le projet associé à la transaction n’existe pas.|

  
  *Exemple : requête en vue d’obtenir les informations relatives à une transaction donnée dont l’identifiant est « aeeaaaaaaghpmborabjyyambxjekiyyaaabcdef » sur un tenant donné*
``` 
  @tenant = 1
  @transaction-id = *aeeaaaaaaghpmborabjyyambxjekiyyaaabcdef*
  
  GET {{url}}/collect-external/v1/transactions/{{transaction-id}}
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  
  {
  }
```

Cette action peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - Un paramètre (identifiant de la transaction) contient une mauvais valeur.<br> - La transaction n’existe pas.|

***Point d’attention :*** 
-   En résultats, la solution logicielle renvoie systématiquement l’ensemble des métadonnées relatives au(x) transaction(s). Au terme de la version 8.1, il n’est pas possible de récupérer une sélection de métadonnées.
-   Si la transaction a été envoyée dans la solution logicielle Vitam, l'API renverra également l'identifiant de l'opération de versement (champ "VitamOperationId").

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet à l'utilisateur de consulter :
-   la liste des transactions associées à un projet de versement.
    Au terme de la version 8.1, elle ne permet pas de consulter le détail des informations d'une transaction.
-   les archives associées à une transaction donnée.

L'accès aux transactions d'un projet de versement peut être restreint via l'utilisation d'un contrat d'accès. Ainsi, un utilisateur du front-office VitamUI devant accéder aux projets de versement
d'un service en particulier, et à ses transactions, pourra ne voir que ceux-là si son profil utilisateur est associé à un contrat d'accès lui permettant d'accéder uniquement aux archives de ce service.

***Point d’attention :***
Au terme de la version 8.1, ce filtre n'est disponible que depuis le front-office VitamUI.

#### Accès aux unités archivistiques

##### Utilisation des API

L’utilisateur peut rechercher :

-   une unité archivistique en particulier et accéder à son détail,
-   une unité archivistique pour une transaction donnée.

Il est possible de :

-   limiter le nombre de résultats retournés au moyen d’un seuil de requête ;
-   obtenir :

    -   une liste de résultats, incluant l’ensemble des métadonnées des unités archivistiques ou une sélection,
    -   le nombre exact de résultats, s’il dépasse les 10 000 unités d’archives, au moyen d’un paramétrage de la plate-forme.
    -   un résultat par facettes (nombre d’occurrences pour une métadonnée donnée).

***Point d’attention :*** 
le seuil de résultats supporté par le moteur d’indexation Elastic Search est de 10 000 unités archivistiques. Il est de fait recommandé d’utiliser des requêtes ne dépassant pas les 10 000 résultats.

  *Exemple : requête en vue d’obtenir l’unité archivistique dont l’identifiant est "aeeaaaaaaceezldyaamscambcvdf6zyaaaaq"*
```  
  @tenant = 1
  @unit-id= ***aeeaaaaaaceezldyaamscambcvdf6zyaaaaq***
  GET {{url}}/collect-external/v1/units/{{unit-id}}
  
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143
  
  {
  }
```  
  
  *Exemple : requête en vue d’obtenir les unités archivistiques de la transaction dont l’identifiant est "aeeaaaaaaceezldyaamscambcvdf6zyaaaaq"*
```  
  @tenant = 1
  @transaction-id=* **aeeaaaaaaceezldyaamscambcvdf6zyaaaaq***
  
  GET {{url}}/collect-external/v1/transactions/{{transaction-id}}/units
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143
  {
   "$roots": [],
   "$query": [ {
   "$eq": {
   "#unitType": "INGEST"
   }
   }],
   "$filter": {},
   "$projection": {}
  }
```  
  
  *Exemple : requête en vue d’obtenir les unités archivistiques de la transaction dont l’identifiant est "aeeaaaaaaceezldyaamscambcvdf6zyaaaaq" et ayant pour tout ou partie du champ Title la valeur « Bulletin »*
  
```  
  @tenant = 1
  @transaction-id=* **aeeaaaaaaceezldyaamscambcvdf6zyaaaaq***
  
  GET {{url}}/collect-external/v1/transactions/{{transaction-id}}/units
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143
  
  {
   "$roots": [],
   "$query": [ { "$match": { "Title": "Bulletins" } } ],
   "$filter": {},
   "$projection": {}
  }
```  

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet d'accéder aux unités archivistiques d'une transaction.

Ce service est disponible :

-   depuis la page permettant de visualiser l’ensemble des projets de versement,

-   depuis la page permettant de visualiser l’ensemble des transactions (ou versements) 

Ces deux accès mènent à une page permettant de visualiser l’ensemble des unités archivistiques d'une transaction ainsi que de rechercher dans cette liste selon de nombreux critères. 

#### Accès aux groupes d'objets techniques

##### Utilisation des API

L’utilisateur peut récupérer :

-   les métadonnées techniques d’un groupe d’objets techniques donné,
-   l’objet numérique associé à une unité archivistique donnée.

  *Exemple : requête en vue d’obtenir le groupe d’objets techniques dont l’identifiant est "aeeaaaaaaceezldyaamscambcvdf6zyaaaaq"*
``` 
  @tenant = 1
  @got-id= ***aeeaaaaaaceezldyaamscambcvdf6zyaaaaq***
  
  GET {{url}}/collect-external/v1/objects/{{got-id}}
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  Content-Length: 143
  
  {
  }
``` 
  
  *Exemple : requête en vue d’obtenir l’objet technique d’usage « BinaryMaster » et de version « 1 » associé à l’unité archivistique dont l’identifiant est "aeeaaaaaaceezldyaamscambcvdf6zyaaaaq"*
``` 
  
  @tenant = 1
  @unit-id=* **aeeaaaaaaceezldyaamscambcvdf6zyaaaaq***
  
  GET {{url}}/collect-external/v1/units/{{unit-id}}/objects/BinaryMaster/1/binary
  Accept: application/json
  Content-Type: application/octet-stream
  X-Tenant-Id: {{tenant}}
  
  {
  }
```

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet d'accéder aux métadonnées techniques d'un groupe d'objets techniques ainsi qu'aux différents usages et versions d'un objet technique.

Ce service est disponible depuis la page permettant de visualiser l’ensemble des unités archivistiques d'une transaction au sein de l'onglet "Objet" du panneau latéral d'une unité archivistique. Il est également possible d'y télécharger les différents objets techniques. 


######################################################################################################
##### GESTION DES TRANSACTIONS #######################################################################
######################################################################################################

### Gestion des transactions

#### Définitions

Le module de collecte a vocation à permettre d’effectuer un certain nombre de traitement en amont du versement au niveau de la transaction.

Au terme de la V8.1, il est possible de réaliser les actions suivantes :

-   modification des informations relatives à l'en-tête du versement,
-   suppression d'une transaction et de son contenu,
-   abandon d'une transaction et de son contenu,
-   réouverture d'une transaction (ou versement),
-   clôture et validation de la transaction (ou versement),
-   transfert de la transaction (ou versement) depuis le module de collecte vers le back-office sous la forme d’un SIP conforme au SEDA 2.2.,
-   si le transfert est en succès ou en avertissement, suppression automatique des archives qui sont associées à la transaction.

Ces actions sont propres à chaque tenant de la solution logicielle Vitam.

Elles ne sont pas journalisées dans le journal des opérations. 
Seule l’opération de transfert des archives sous la forme d’un SIP, envoyée par le module de collecte, est tracée dans le journal des opérations (opération de type « INGEST »).

***Point d’attention :***
L’ordre d’utilisation des API doit être respecté, notamment en vue de transférer avec succès l’ensemble des métadonnées et objets constituant un versement vers la solution logicielle Vitam pour conservation.

#### Modification d'une transaction

##### Utilisation des API

La solution logicielle Vitam permet de modifier une transaction, et plus précisément de :

- modifier ses métadonnées,
- lui ajouter des métadonnées,
- supprimer des métadonnées.

  *Exemple : requête en vue de modifier des métadonnées d’une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*
```  
  @tenant = 1
  
  PUT {{url}}/collect-external/v1/transactions
  accept: application/json
  content-type: application/json
  Content-Length: 401
  X-Tenant-Id: {{tenant}}
  
  {
   "#id": "**aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq**",
   "ArchivalAgencyIdentifier": "Vitam",
   "TransferringAgencyIdentifier": "RATP",
   "OriginatingAgencyIdentifier": "RATP",
   "SubmissionAgencyIdentifier": "RATP",
   "MessageIdentifier": "20200131-000001",
   "ArchivalAgreement":"IC-000001",
   "Comment": "RH - bulletins de salaire (février 2020)",
   "AcquisitionInformation":"Versement",
   "LegalStatus":"Public Archive"
  }
  
```  

***Points d’attention :***

-   Le service de mise à jour d’une transaction fonctionne en mode « annule et remplace ».
-   La plupart des champs d’une transaction étant facultatifs, il est recommandé d’indiquer les éléments obligatoires à la génération d’un SIP :
    -   le contrat d’entrée (champ « ArchivalAgreement »),
    -   l’identifiant du message (champ « MessageIdentifier),
    -   le service producteur (champ « OriginatingAgencyIdentifier »),
    -   le service d’archivage (champ « ArchivalAgencyIdentifier »),
    -   le service responsable du transfert (« TransferringAgencyIdentifier »)
-   Au terme de la version 8.1 :
    -   ce service ne vérifie pas le caractère obligatoire d’un champ. Il est fortement recommandé de veiller à ne pas supprimer un champ obligatoire, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
    -   on ne peut pas ajouter de règles de gestion dans une transaction ;
    -   aucun contrôle n’est effectué avec les référentiels et unités archivistiques de rattachement présents dans la solution logicielle Vitam. De fait, il est fortement recommandé de :
        -   veiller à inclure des références (ex. service producteur, contrat d’entrée, etc.) existant dans la solution, de manière à éviter de possibles échecs lors des étapes de contrôles des données référentielles du processus d’entrée (opération « INGEST ») ;
        -   ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

Cette action provoque la mise à jour du projet.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | - Présence d’un champ inconnu dans la requête ;<br>- La transaction n’existe pas. |

##### Utilisation dans VitamUI

TO DO 

#### Suppression d'une transaction

##### Utilisation des API

La solution logicielle Vitam permet de supprimer une transaction.

***Point d’attention :*** En prérequis à cette action, il faut avoir au préalable créé :

-   un projet de versement et le signaler dans l’API, pour une suppression de projet ;
-   une transaction et le signaler dans l’API, pour une suppression de transaction.


  *Exemple : requête en vue de supprimer une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*

```  
  @transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
  DELETE {{url}}/collect-external/v1/transactions/{{transaction-id}}
  accept: application/json
  content-type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
  
```  

Ces actions provoquent :

-   la suppression de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*).

-    si la transaction contient des archives (unités archivistiques, objets techniques), la suppression de l’ensemble des données associées à cette transaction de la base de données et des offres de stockage :

    -   les unités archivistiques sont supprimées de la collection « Unit » (base *MetadataCollect*) ;
    -   les groupes d’objets techniques sont supprimés de la collection « ObjectGroup » (base *MetadataCollect*).
    -   les objets sont supprimés des offres de stockage.

Mais le projet de versement ne sera pas supprimé.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - La transaction n’existe pas.<br>- La transaction n’est pas reconnue dans la requête.|

##### Utilisation dans VitamUI

TO DO

#### Abandon d'une transaction

##### Utilisation des API

La solution logicielle Vitam permet également d’abandonner une transaction.

***Point d’attention :*** 
En prérequis à cette action, il faut avoir au préalable créé une transaction et le signaler dans l’API.

  *Exemple : requête en vue d’abandonner une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*

```  
  @transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
  PUT {{url}}/collect-external/v1/transactions/{{transaction-id}}/abort
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  
  {}
```

Cette action provoque :

-   la modification de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*) : la valeur du champ « Status » devient « ABORTED » ;
-   la purge des données associées à la transaction, enregistrées dans les collections « Unit » et « ObjectGroup » (base *MetadataCollect*) et sur les offres de stockage, passé un certain délai configurable par tenant (60 minutes par défaut)[^19].

***Point d’attention :***

-   Une transaction peut être abandonnée uniquement lorsque son statut est égal à « OPEN », « READY », « ACK_KO », « KO ».

    Si elle a un statut égal à « SENDING », « SENT », « ACK_OK », « ACK_WARNING », elle ne peut pas l’être.

-   La différence avec l’action de suppression est que l’abandon :

    -   ne purge pas les archives directement, mais de manière automatisée, passé un certain délai ;
    -   donne lieu à une mise à jour du statut de la transaction.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - La transaction n’existe pas.<br>- La transaction n’est pas reconnue dans la requête.<br>- La transaction a un statut égal à « SENDING », « SENT », « ACK_OK », « ACK_WARNING ».|


##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet d'abandonner une transaction. Son statut passe alors à "ABORTED".

Ce service est disponible depuis la page permettant de visualiser l’ensemble des transactions (ou versements) via un bouton d'actions secondaires.

Des droits utilisateurs sont par ailleurs définis :

| Profil utilisateur | Suppression d'archives |
|---|---|
| Administrateur     | oui |
| Archiviste         | non |
| Service producteur | non |

#### Réouverture d'une transaction

##### Utilisation des API

La solution logicielle Vitam permet également de rouvrir (ou rééditer) une transaction.

***Point d’attention :*** En prérequis à cette action, il faut avoir au préalable créé une transaction et le signaler dans l’API.

  *Exemple : requête en vue de réouvrir une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*
```  
  @transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
  PUT {{url}}/collect-external/v1/transactions/aeeaaaaabohhxsvcaaxnqamfooffxkqaaaaq/reopen
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
  
  {}
```  

Cette action provoque la modification de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*) : la valeur du champ « Status » devient « OPEN ».

Dès lors, il est à nouveau possible de :

-   associer à la transaction rouverte des unités archivistiques, ainsi que des groupes d’objets techniques et des objets numériques ;
-   modifier des unités archivistiques.

***Point d’attention :***
-   Une transaction peut être rouverte uniquement lorsque son statut est égal à « READY », « ACK_KO », « KO ».
-   Si elle a un statut égal à « OPEN », « SENDING », « SENT », « ACK_OK », « ACK_WARNING », « ABORTED », elle ne peut pas l’être.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec  | - La transaction n’existe pas.<br>- La transaction n’est pas reconnue dans la requête.<br>- La transaction a un statut égal à « OPEN », « SENDING », « SENT », « ACK_OK », « ACK_WARNING », « ABORTED ».|

##### Utilisation dans VitamUI

TO DO

#### Validation d'une transaction

##### Utilisation des API

La solution logicielle permet de clôturer une transaction, une fois l’ensemble des archives liées à cette transaction envoyées dans la solution logicielle Vitam.

***Points d’attention :***

-   Cette action est un prérequis à l’envoi d’un SIP depuis le module de collecte vers la solution logicielle Vitam.
-   Il faut avoir au préalable créé une transaction et la signaler dans l’API.

 *Exemple : requête de clôture*
```  
  @transaction-id = **aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq**
  @unit-id = aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/transactions/**{{transaction-id}}**/close
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  {}
```  

Cette action provoque la modification de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*) : la valeur du champ « Status » est désormais « READY ».

 *Exemple : enregistrement de la transaction dans la collection « Transaction »*
  
```  
  {
   "_id": "aeeaaaaaaghdvam4abgoyambfxnhd6aaaaaq",
   "Status": "READY",
   "Context": {
   "ArchivalAgreement": "IC-000001",
   "MessageIdentifier": "20220302-000005",
   "ArchivalAgencyIdentifier": "Vitam",
   "TransferringAgencyIdentifier": "AN",
   "OriginatingAgencyIdentifier": "MICHEL_MERCIER",
   "SubmissionAgencyIdentifier": "MICHEL_MERCIER",
   "Comment": "Versement du service producteur : Cabinet de Michel Mercier"
   },
   "CreationDate": "2022-10-15T15:50:06.153",
   "LastUpdate": "2022-11-15T15:50:06.153",
   "ProjectId": "aeaaaaaaaaha7iacabzrsamepp45blyaaaaq",
   "_tenant": 1
  }
```  

Dès lors, il n’est plus possible de :

- associer à cette transaction des unités archivistiques, ainsi que des groupes d’objets techniques et des objets numériques ;
- modifier des unités archivistiques.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | - La transaction associée n’existe pas ;<br>- La transaction associée a déjà été clôturée.|

***Point d’attention :***
S’il s’avère nécessaire de modifier le contenu de la transaction, il est toujours possible à ce stade la rouvrir[^21].

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam utilise l'API de clôture pour valider une transaction (ou versement).

Ce service est disponible :

-   depuis la page permettant de visualiser l’ensemble des archives d’un projet de versement, où il est possible de :

    -   « Valider » un versement, action correspondant à la clôture du versement.

-   depuis la page permettant de visualiser l’ensemble des transactions (ou versements) associées à un projet de versement, où il est possible de :

    -   « Valider » un versement, action correspondant à la clôture du versement.

|  Actions disponibles                   | Statut correspondant dans le front-office    | Statut correspondant dans le back-office| Purge automatique ? |
|---|---|---|---|
|  **Valider**   | Validé                      | READY| |
|Verser| Préparation et envoi du SIP | SENDING | |
|Verser| Envoyé, en cours de traitement du SAE | SENT            | |
|Verser | Versé en succès             | ACK_OK                    |  OUI|
|Verser | Versé                       | ACK_WARNING               |  OUI|
|Verser | Échec du versement          | ACK_KO                    | |
|Verser | Erreur technique            | KO                        | |
|  Éditer    | Ouvert en édition           | OPEN                      | |
|  Abandonner| Abandonné                   | ABORTED                   |  OUI|

#### Envoi d'une transaction

##### Utilisation des API

Pour une transaction donnée, une fois celle-ci clôturée, le module de collecte permet de générer un SIP et de le transférer au moyen d’une opération de type « INGEST ».

***Point d’attention :***
En prérequis à l’envoi du SIP, il faut avoir au préalable clôturé la transaction (son statut doit être égal à « READY ») et signaler cette dernière dans l’API.

 *Exemple : requête d’envoi du SIP vers la solution logicielle Vitam pour conservation*
```  
  @transaction-id = **aeeaaaaaaghiyso4ablmyal74slqwtqaaaaq**
  @unit-id = aeeaaaaaaghiyso4ablmyal74sndwiqaaaaq
  @tenant = 1
  
  POST  {{url}}/collect-external/v1/transactions/{{**transaction-id**}}/send
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: ContratTNR
  
  {
  }
```  

Cette action provoque :

-   si elle est en erreur technique :
    -   la modification de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*) : la valeur du champ « Status » est « KO » ;
-   si elle est conforme :
    -   l’initialisation d’une opération de type « INGEST »,
    -   la modification de l’enregistrement dans la base de données MongoDB, dans la collection « Transaction » (base *Collect*) :
        -   la valeur du champ « Status » est :

            -   « SENDING » tant que l’opération de type « INGEST » n’a pas été initialisée par la solution logicielle Vitam,
            -   « SENT » quand l’opération de type « INGEST » est en cours ;
        -   un champ correspondant à l’identifiant de l’opération d’entrée est ajouté (VitamOperationId).Une fois l’opération de type « INGEST » terminée, le statut est :
        
            -   si l’opération est en succès, la valeur du champ « Status » est désormais « ACK\_OK » ; si l’opération est en avertissement, la valeur du champ « Status » est « ACK\_WARNING » ;
            -   si l’opération est en erreur, la valeur du champ « Status » est « ACK\_KO ».

Lors de cette action, l’opération peut aboutir aux résultats suivants :

|  Statut | Motifs |
|---|---|
|  Succès | Action réalisée sans rencontrer de problèmes particuliers. |
|  Échec  | - La transaction associée n’existe pas ;<br>- La transaction associée n’a pas été clôturée ;<br>- La transaction ne contient pas d’archives associées (unités archivistiques et groupes d’objets techniques). |

***Point d’attention :***
Au terme de la version 8.1, les archives transférées avec succès ou en avertissement (statut égal à « ACK\_OK » et « ACK\_WARNING ») pour archivage sont purgées du module de collecte passé un certain délai configurable par tenant (60 minutes par défaut)[^22].

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam utilise l'API de génération d’un SIP pour envoi dans la solution logicielle Vitam.

Ce service est disponible :

-   depuis la page permettant de visualiser l’ensemble des archives d’un projet de versement, où il est possible de :

    -   « Verser » un versement, action correspondant à l’envoi du SIP.

-   depuis la page permettant de visualiser l’ensemble des transactions (ou versements) associées à un projet de versement, où il est possible de :

    -   « Verser » un versement, action correspondant à l’envoi du SIP.

Cette action entraîne la purge des archives passé un certain délai, si le résultat est un versement en succès ou en avertissement.

|  Actions disponibles                   | Statut correspondant dans le front-office    | Statut correspondant dans le back-office| Purge automatique ? |
|---|---|---|---|
|  Valider   | Validé                      | READY| |
|**Verser**| Préparation et envoi du SIP | SENDING | |
|**Verser**| Envoyé, en cours de traitement du SAE | SENT            | |
|**Verser** | Versé en succès             | ACK_OK                    |  OUI|
|**Verser** | Versé                       | ACK_WARNING               |  OUI|
|**Verser** | Échec du versement          | ACK_KO                    | |
|**Verser** | Erreur technique            | KO                        | |
|  Éditer    | Ouvert en édition           | OPEN                      | |
|  Abandonner| Abandonné                   | ABORTED                   |  OUI|


######################################################################################################
##### GESTION DES ARCHIVES ###########################################################################
######################################################################################################

### Gestion des archives

#### Définitions

Le module de collecte a vocation à permettre d’effectuer un certain nombre de traitements sur les archives en amont du versement.

Au terme de la V8.1, il est possible de réaliser les actions suivantes :

-   modification,
-   ajout d'une à plusieurs unités archivistiques sous une unité archivistique,
-   réorganisation d'arborescences,
-   suppression.

Ces actions sont propres à chaque tenant de la solution logicielle Vitam.

Sont journalisées dans le journal des opérations :
-   réorganisation d'arborescences,
-   suppression.
Ne sont pas journalisées dans le journal des opérations :
-   modification,
-   ajout d'une à plusieurs unités archivistiques sous une unité archivistique.

#### Modification des métadonnées

La solution logicielle Vitam permet de modifier des unités archivistiques par :

- import d'un fichier au format .csv,
- import d'un fichier au format .jsonl,
- une mise à jour unitaire en masse de métadonnées.

##### Modification unitaire en masse

###### Utilisation des API

La solution logicielle Vitam permet de mettre à jour unitairement plusieurs unités archivistiques. Pour chacune d'entre elles, elle permet plus précisément de :

- modifier des métadonnées,
- ajouter des métadonnées,
- supprimer des métadonnées.

***Points d'attention***
-   En prérequis à la mise à jour unitaire en masse des unités archivistiques, il faut avoir au préalable créé une transaction et le signaler dans l’API ;
-   Il n’est pas possible d'ajouter une unité archivistique lors de cette action de mise à jour.

  *Exemple : requête en vue de modifier un titre pour une unité archivistique dont l'identifiant d'agent est "123456", de supprimer une date d'envoi et d'ajouter une description pour une unité archivistique dont l'identifiant d'agent est 1234557*
```  
POST {{url}}/collect-external/v1/transactions/{{transaction-id}}/units/bulk
Accept: application/json
Content-Type: application/json
X-Tenant-Id: {{tenant}}

{
  "threshold": 10,
  "queries": [
    {
      "$query": [
        { "$eq": { "Agent.Identifier": "123456" } }
      ],
      "$action": [
        { "$set": { "Title": "Nouveau titre" } }
      ]
    },
    {
      "$query": [
        { "$eq": { "Agent.Identifier": "123457" } }
      ],
      "$action": [
        { "$unset": [ "SentDate" ] },
        { "$set": { "Description": "Description mise à jour" } }
      ]
    }
  ]
}
```  

Cette action provoque la mise à jour des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^18]*).

***Points d'attention***
L'API est synchrone et bloquante. L'action de mise à jour peut donc prendre quelques instants avant d'être effective.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut       |  Motifs |
|---|---|
| Succès       |  Action réalisée sans rencontrer de problèmes particuliers. |
| Échec        |  - Le seuil de requête est dépassé. <br>- Plusieurs unités archivistiques ont été trouvées. <br>- Aucune unité archivistique n'a été trouvée. <br>- Le format de la métadonnées à modifier n'est pas conforme au type d'indexation défini dans l'ontologie. |

***Points d'attention***
- L'échec ne concerne pas l'action en général, mais est spécifique à une unité archivistique en particulier.
- La requête utilise le langage de requête DSL de type mise à jour unitaire de masse (BULK UPDATE) de la solution logicielle Vitam en entrée.
- Le nombre de requêtes unitaires doit rester raisonnable, idéalement pas plus de 1000 par appel. Il est limité à un seuil maximum de 100 000 unités archivistiques par défaut. Ce seuil peut être redéfini dans la requête via le paramètre de seuil (threshold).

Elle n’est pas journalisée dans le journal des opérations.

###### Utilisation dans VitamUI

TO DO

##### Modification par import de fichier .csv

###### Utilisation des API

La solution logicielle permet de modifier des métadonnées descriptives et de gestion au moyen de l'import d’un fichier au format .csv. Il est plus précisement possible de :

- modifier des métadonnées descriptives et/ou de gestion,
- ajouter des métadonnées descriptives et/ou de gestion.

***Points d'attention***
-   En prérequis à la mise à jour des unités archivistiques, il faut avoir au préalable créé :

    -   une transaction et le signaler dans l’API ;
    -   les unités archivistiques qui sont référencées dans le fichier .csv ;

-   Il n’est pas possible de :

    -   supprimer une métadonnée avec ce mode ;
    -   ajouter une unité archivistique lors de cette action de mise à jour.

  *Exemple : requête en vue de modifier des métadonnées d’unités archivistiques associées à une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*
```  
  @transaction-id = aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq
  
  PUT {{url}}/collect-external/v1/transactions/{{**transaction-id**}}/units
  Accept: application/json
  Content-Type: application/octet-stream
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
  
  < /path\_tozip/stream.csv
```  

Pour une transaction donnée, peut être envoyé un fichier .csv contenant des métadonnées détaillant unitairement tout ou partie des unités archivistiques préalablement envoyées.

Le fichier .csv est composé de x colonnes[^17] :

-   File : chemin relatif à partir de l’emplacement où est positionnée l’unité archivistique faisant l’objet de la modification. Il s’agit d’une concaténation des intitulés des différentes unités archivistiques (colonne obligatoire) ;
-   toute colonne correspondant à un champ du standard SEDA et nécessitant une modification et/ou un ajout de métadonnées (colonnes facultatives).

***Points d’attention :***

-   le fichier .csv n’est pas obligatoirement intitulé « metadata.csv » ;
-   l’ordre des premières colonnes ne doit pas être modifié ;
-   une première ligne d’en-tête donnant le nom des colonnes doit être présente, chaque ligne décrivant ensuite une unité archivistique ;
-   le séparateur entre les colonnes est le point-virgule, le séparateur de texte les guillemets doubles et l’encodage est « UTF-8 » ;
-   le fichier .csv ne référence que des métadonnées propres aux unités archivistiques (métadonnées descriptives et de gestion).
-   concernant le nommage des colonnes :
    -   pour les colonnes correspondant à des champs du standard SEDA, l’intitulé de la colonne doit correspondre à celui du champ dans le standard SEDA, précédé de « Management. » s’il s’agit d’une métadonnée de gestion (ex. « Management.AccessRule.Rule » pour une règle de communicabilité) ou de « Content » s’il s’agit d’une métadonnée descriptive (ex. « Content.DocumentType »). Toutefois, si le fichier d’import ne décrit que des métadonnées descriptives, la présence du préfixe « Content » est facultative ;
    -   quand le schéma XML du standard SEDA propose une structure complexe de balises (par exemple pour décrire un auteur via l’objet XML &lt;Writer&gt; qui contient plusieurs balises XML comme FullName ou BirthName), il convient d’intituler la colonne de la manière suivante : Content.Writer.FullName ou Content.Writer.BirthName ;
    -   quand un champ ou un objet XML est multivalué dans le standard SEDA (et qu’il est possible d’en décrire plusieurs dans le bordereau comme c’est le cas pour l’objet Writer par exemple), il convient de numéroter la colonne de la manière suivante : Content.Writer.0.FullName, Content.Writer.1.FullName ;
-   concernant le contenu des colonnes :
    -   la colonne File :
        -   indique la position de l’unité archivistique dans l’arborescence de la transaction, depuis l’unité archivistique racine jusqu’à l’unité archivistique décrite. Il s’agit là d’une concaténation des intitulés des différentes unités archivistiques.
        -   ne doit pas comprendre d’espace avant ou après les « \\ » ;
        -   doit correspondre à un chemin tel que décrit par l’explorateur de fichiers (avec des « \\ » et non des « / ») ;

    -   la colonne DescriptionLevel, si elle est présente, ne doit comprendre que les valeurs autorisées par le standard SEDA : Collection, Fonds, Series, SubSeries, RecordGrp, File, Item ;
    -   les colonnes correspondant à des champs Date dans le standard SEDA doivent être formatées conformément à la norme ISO 8601 (AAAA-MM-JJ) ;
    -   les références à des règles de gestion doivent se conformer aux identifiants de règles présents dans le SAE ;
    -   les dates de début (Content.StartDate) doivent être antérieures aux dates de fin (Content.EndDate).

  *Exemple : fichier .csv de mise à jour des métadonnées (ajout ou modification des dates de début et de fin pour les unités archivistiques intitulées « AU1 » et « AU2 »)*
```csv  
  File;Content.DescriptionLevel;Content.Title;Content.StartDate;Content.EndDate
  "content/AU1";"Item";"AU1";"1970-06-03";"1980-06-03"
  "content/AU2";"Item";"AU2";"1970-06-03";"1980-06-03"
  "content/AU3";"Item";"AU3";"";""
  "content/AU4";"Item";"AU4";"";""
```

Cette action provoque la mise à jour des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^18]*).
Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut       |  Motifs |
|---|---|
| Succès       |  Action réalisée sans rencontrer de problèmes particuliers. |
| Avertissement|  Le formatage du fichier .csv contient au moins une erreur (ex. date mal formatée, valeur attendue erronée, date de début postérieure à la date de fin, etc.)|
| Échec        |  Le fichier .csv n’est pas au format .csv. <br>Le fichier .csv contient des erreurs dans la colonne File :<br>Action non réalisée pour cause de nom erroné ou de chemin introuvable dans la requête.<br>La transaction n’existe pas ou est erronée.<br>La transaction a un statut « READY », « SENDING », « SEND », « ACK\_OK », « ACK\_WARNING », « ACK\_KO », « KO », « ABORTED ».|

Elle n’est pas journalisée dans le journal des opérations.

***Point d’attention :***
-   Au terme de la V.8.1, le module de collecte peut :

	-  bloquer la mise à jour si le fichier .csv dernier comporte les erreurs suivantes :
	   -   il ne contient pas au moins la colonne obligatoire File ;
	   -   au moins un fichier référencé dans le fichier .csv n'est pas présent dans l'arborescence bureautique,
	   -   il ne contient aucune information ;
	   -   il ne contient pas de séparateurs de champs ;
	   -   il contient des virgules, des espaces, des pipes comme séparateurs de champs ;
	   -   le fichier contient des simples guillemets comme séparateurs de texte ;
	   -   etc.
	   L'API peut :
	       - soit renvoyer une seule erreur, si cette erreur est bloquante,
		   - soit renvoyer jusqu'à 20 erreurs, si ces erreurs sont cumulables.
	   L'arborescence bureautique ne sera pas importée.
	
	-  ne pas bloquer la mise à jour si le fichier .csv dernier comporte les erreurs suivantes :
       -   il dispose d’un champ dont le contenu est mal formaté (ex. ReceivedDate écrite en chaîne de caractères) ;
    Une erreur est alors renvoyée par l’API, le contenu du fichier CSV sera ignoré et seule l’arborescence bureautique sera téléchargée selon le comportement décrit dans la sous-section précédente.

-   Il ne permet pas de :

    - supprimer une métadonnée avec ce mode de mise à jour par envoi de fichier .csv ;
	- ajouter un rattachement à une unité archivistique (UpdateOperation).

###### Utilisation dans VitamUI

TO DO

##### Modification par import de fichier .jsonl

###### Utilisation des API

La solution logicielle permet de modifier des métadonnées descriptives et de gestion au moyen de l'import d’un fichier au format .jsonl. Il est plus précisement possible de :

- modifier des métadonnées descriptives et/ou de gestion,
- ajouter des métadonnées descriptives et/ou de gestion.

***Points d'attention***
-   En prérequis à la mise à jour des unités archivistiques, il faut avoir au préalable créé :

    -   une transaction et le signaler dans l’API ;
    -   les unités archivistiques qui sont référencées dans le fichier .jsonl ;

-   Il n’est pas possible de :

    -   supprimer une métadonnée avec ce mode ;
    -   ajouter une unité archivistique lors de cette action de mise à jour.

  *Exemple : requête en vue de modifier des métadonnées d’unités archivistiques associées à une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*

```  
  @transaction-id = aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq
  
  PUT {{url}}/collect-external/v1/transactions/{{**transaction-id**}}/units
  Accept: application/json
  Content-Type: application/octet-stream
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}
  
  < /path_tozip/stream.jsonl
```  

Pour une transaction donnée, peut être envoyé un fichier .jsonl contenant des métadonnées détaillant unitairement tout ou partie des unités archivistiques préalablement envoyées.

Le fichier .jsonl, obligatoirement intitulé « metadata.jsonl », est composé de :

-   File : chemin relatif à partir de l’emplacement où est positionnée l’unité archivistique faisant l’objet de la modification. Il s’agit d’une concaténation des intitulés des différentes unités archivistiques (champ obligatoire) ;
-   Selector : liste de conditions permettant l'enregistrement des métadonnées dans une unité archivistique correspond à ces conditions (champ obligatoire) ;
-   ObjectFiles : chemin relatif des fichiers numériques dont certains peuvent être rattachés à des répertoires déclarés dans la colonne File (champ facultatif) ;
-   UnitContent : bloc dans lequel sont insérées les métadonnées descriptives et de gestion d'une unité archivistique nécessitant d'être modifiée (champ obligatoire), dont :
    -   DescriptionLevel : niveau de description de l’unité archivistique (champ facultatif) ;
    -   Title : intitulé de l’unité archivistique (champ facultatif) ;
    -   tout champ correspondant à un champ du standard SEDA (champs facultatifs).

AAAAAAA




***Points d’attention :***

-   le fichier .csv n’est pas obligatoirement intitulé « metadata.csv » ;
-   l’ordre des premières colonnes ne doit pas être modifié ;
-   une première ligne d’en-tête donnant le nom des colonnes doit être présente, chaque ligne décrivant ensuite une unité archivistique ;
-   le séparateur entre les colonnes est le point-virgule, le séparateur de texte les guillemets doubles et l’encodage est « UTF-8 » ;
-   le fichier .csv ne référence que des métadonnées propres aux unités archivistiques (métadonnées descriptives et de gestion).
-   concernant le nommage des colonnes :
    -   pour les colonnes correspondant à des champs du standard SEDA, l’intitulé de la colonne doit correspondre à celui du champ dans le standard SEDA, précédé de « Management. » s’il s’agit d’une métadonnée de gestion (ex. « Management.AccessRule.Rule » pour une règle de communicabilité) ou de « Content » s’il s’agit d’une métadonnée descriptive (ex. « Content.DocumentType »). Toutefois, si le fichier d’import ne décrit que des métadonnées descriptives, la présence du préfixe « Content » est facultative ;
    -   quand le schéma XML du standard SEDA propose une structure complexe de balises (par exemple pour décrire un auteur via l’objet XML &lt;Writer&gt; qui contient plusieurs balises XML comme FullName ou BirthName), il convient d’intituler la colonne de la manière suivante : Content.Writer.FullName ou Content.Writer.BirthName ;
    -   quand un champ ou un objet XML est multivalué dans le standard SEDA (et qu’il est possible d’en décrire plusieurs dans le bordereau comme c’est le cas pour l’objet Writer par exemple), il convient de numéroter la colonne de la manière suivante : Content.Writer.0.FullName, Content.Writer.1.FullName ;
-   concernant le contenu des colonnes :
    -   la colonne File :
        -   indique la position de l’unité archivistique dans l’arborescence de la transaction, depuis l’unité archivistique racine jusqu’à l’unité archivistique décrite. Il s’agit là d’une concaténation des intitulés des différentes unités archivistiques.
        -   ne doit pas comprendre d’espace avant ou après les « \\ » ;
        -   doit correspondre à un chemin tel que décrit par l’explorateur de fichiers (avec des « \\ » et non des « / ») ;

    -   la colonne DescriptionLevel, si elle est présente, ne doit comprendre que les valeurs autorisées par le standard SEDA : Collection, Fonds, Series, SubSeries, RecordGrp, File, Item ;
    -   les colonnes correspondant à des champs Date dans le standard SEDA doivent être formatées conformément à la norme ISO 8601 (AAAA-MM-JJ) ;
    -   les références à des règles de gestion doivent se conformer aux identifiants de règles présents dans le SAE ;
    -   les dates de début (Content.StartDate) doivent être antérieures aux dates de fin (Content.EndDate).

  *Exemple : fichier .csv de mise à jour des métadonnées (ajout ou modification des dates de début et de fin pour les unités archivistiques intitulées « AU1 » et « AU2 »)*
```csv  
  File;Content.DescriptionLevel;Content.Title;Content.StartDate;Content.EndDate
  "content/AU1";"Item";"AU1";"1970-06-03";"1980-06-03"
  "content/AU2";"Item";"AU2";"1970-06-03";"1980-06-03"
  "content/AU3";"Item";"AU3";"";""
  "content/AU4";"Item";"AU4";"";""
```

Cette action provoque la mise à jour des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^18]*).
Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut       |  Motifs |
|---|---|
| Succès       |  Action réalisée sans rencontrer de problèmes particuliers. |
| Avertissement|  Le formatage du fichier .csv contient au moins une erreur (ex. date mal formatée, valeur attendue erronée, date de début postérieure à la date de fin, etc.)|
| Échec        |  Le fichier .csv n’est pas au format .csv. <br>Le fichier .csv contient des erreurs dans la colonne File :<br>Action non réalisée pour cause de nom erroné ou de chemin introuvable dans la requête.<br>La transaction n’existe pas ou est erronée.<br>La transaction a un statut « READY », « SENDING », « SEND », « ACK\_OK », « ACK\_WARNING », « ACK\_KO », « KO », « ABORTED ».|

Elle n’est pas journalisée dans le journal des opérations.

***Point d’attention :***
-   Au terme de la V.8.1, le module de collecte peut :

	-  bloquer la mise à jour si le fichier .csv dernier comporte les erreurs suivantes :
	   -   il ne contient pas au moins la colonne obligatoire File ;
	   -   au moins un fichier référencé dans le fichier .csv n'est pas présent dans l'arborescence bureautique,
	   -   il ne contient aucune information ;
	   -   il ne contient pas de séparateurs de champs ;
	   -   il contient des virgules, des espaces, des pipes comme séparateurs de champs ;
	   -   le fichier contient des simples guillemets comme séparateurs de texte ;
	   -   etc.
	   L'API peut :
	       - soit renvoyer une seule erreur, si cette erreur est bloquante,
		   - soit renvoyer jusqu'à 20 erreurs, si ces erreurs sont cumulables.
	   L'arborescence bureautique ne sera pas importée.
	
	-  ne pas bloquer la mise à jour si le fichier .csv dernier comporte les erreurs suivantes :
       -   il dispose d’un champ dont le contenu est mal formaté (ex. ReceivedDate écrite en chaîne de caractères) ;
    Une erreur est alors renvoyée par l’API, le contenu du fichier CSV sera ignoré et seule l’arborescence bureautique sera téléchargée selon le comportement décrit dans la sous-section précédente.

-   Il ne permet pas de :

    - supprimer une métadonnée avec ce mode de mise à jour par envoi de fichier .csv ;
	- ajouter un rattachement à une unité archivistique (UpdateOperation).


TO DO

Pour une transaction donnée peut être envoyé sous forme de zip en plus d’une arborescence bureautique[^13] un fichier .jsonl contenant des métadonnées détaillant unitairement les unités archivistiques.

Le fichier .jsonl, obligatoirement intitulé « metadata.jsonl », est composé de :

-   File : chemin relatif à partir de l’emplacement où est enregistré le fichier .jsonl (champ obligatoire) ;
-   Selector : liste de conditions permettant l'enregistrement des métadonnées dans une unité archivistique correspond à ces conditions (champ obligatoire) ;
-   ObjectFiles : chemin relatif des fichiers numériques dont certains peuvent être rattachés à des répertoires déclarés dans la colonne File (champ facultatif) ;
-   UnitContent : bloc dans lequel sont insérées les métadonnées descriptives et de gestion d'une unité archivistique (champ obligatoire), dont :
    -   DescriptionLevel : niveau de description de l’unité archivistique (champ facultatif) ;
    -   Title : intitulé de l’unité archivistique (champ facultatif) ;
    -   tout champ correspondant à un champ du standard SEDA (champs facultatifs).

 *Exemple : contenu d’un fichier « metadata.jsonl ».*

```
{ "File": "File", "UnitContent": { "DescriptionLevel": "Collection", "Title": "File", "Description": "Ceci est un versement de bulletins de paie", "StartDate": "2023-01-01", "EndDate": "2023-01-31", "Tag": [ "Paie", "Bulletin" ] } }
{ "File": "File/BP_123456_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123456_20230131.pdf", "OriginatingSystemId": [ "BP_123456_20230131" ], "Agent": [ { "FirstName": "DUPONT", "BirthName": "Charles", "Identifier": [ "123456" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00001", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } }
{ "File": "File/BP_123463_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123463_20230131.pdf", "OriginatingSystemId": [ "BP_123463_20230131" ], "Agent": [ { "FirstName": "DUPOND", "BirthName": "Victor", "Identifier": [ "123463" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00002", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } }
{ "File": "File/BP_123464_20230131.pdf", "UnitContent": { "DescriptionLevel": "Item", "Title": "BP_123464_20230131.pdf", "OriginatingSystemId": [ "BP_123464_20230131" ], "Agent": [ { "FirstName": "CHARLES", "BirthName": "Ray", "Identifier": [ "123464" ] } ], "SentDate": "2023-01-31", "AcquiredDate": "2023-01-20", "Tag": [ "Salaire" ], "#management": { "AppraisalRule": { "Rules": [ { "Rule": "APP-00002", "StartDate": "2023-01-20" } ], "FinalAction": "Destroy" }, "AccessRule": { "Rules": [ { "Rule": "ACC-00016", "StartDate": "2023-01-20" } ] } } } } 
```

 *Exemple : contenu d’un fichier « metadata.jsonl » décrivant un contexte de signature détachée.*

```  
{ "File" : "My Root Folder", "ObjectFiles": "SomeFile.xml", "UnitContent": { "Title": "My Root Folder (with attached SomeFile.xml)" } }
{ "File" : "My Root Folder/MyFile1.txt", "ObjectFiles": null, "UnitContent": { "Title": "My Root Folder/MyFile1.txt" } }
{ "File" : "My Root Folder/MyFile2.txt", "ObjectFiles": "My Root Folder/MyFile2.txt", "UnitContent": { "Title": "My Root Folder/MyFile2.txt" } }
{ "File" : "My Root Folder/SubFolder", "ObjectFiles": "My Root Folder/SubFolder/MyFile3.txt", "UnitContent": { "Title": "My Root Folder/SubFolder (with attached MyFile3.txt)" } }
{ "Selector" : { "#uploadPath" : "Yet Another Folder" }, "ObjectFiles": "My Root Folder/SubFolder/MyFile4.txt", "UnitContent": { "Title": "Yet Another Folder (with attached MyFile4.txt)" } }
```

 *Exemple : contenu d’un fichier « metadata.jsonl » déclarant un rattachement.*

```
{ "File": "Discours hors parlement", "UnitContent": { "DescriptionLevel": "RecordGrp", "Title": "Discours hors parlement", "#management": { "UpdateOperation": { "ArchiveUnitIdentifierKey" : { "MetadataName" : "ArchivalAgencyArchiveUnitIdentifier", "MetadataValue" : "20130456/3"} }  } } }
{ "File": "Discours hors parlement/Discours d'inauguration", "UnitContent": { "DescriptionLevel": "RecordGrp", "Title": "Discours d’inauguration" } }
{ "File": "Discours hors parlement/Discours d'inauguration/Inauguration de Notre-Dame.odt", "UnitContent": { "DescriptionLevel": "Item", "Title": "Inauguration de Notre-Dame" } }
 
```

***Points d’attention :***

-   le fichier .jsonl doit toujours contenir un champ File *ou* un champ Selector. Celui-ci doit toujours être placée en première position ;
-   les métadonnées pouvant être utilisées comme conditions dans le champ Selector doivent des éléments simples de type string, boolean, long ou double.
-   le fichier .jsonl ne référence que des métadonnées propres aux unités archivistiques (métadonnées descriptives et de gestion). Il ne supporte pas les métadonnées techniques propres aux fichiers numériques ;
-   seul un objet peut être associé à un enregistrement. Ce format d’import ne permet pas de facto de gérer l’import de groupe d’objets techniques disposant de plusieurs objets aux usages différents devant être référencés par la même unité archivistique.
-   le fichier .jsonl à importer doit se trouver dans le même répertoire que le répertoire correspondant à la racine de la structure arborescente de fichiers à importer.
-   chaque répertoire et objet numérique devant contenir des métadonnées particulières doit être référencé dans le fichier .jsonl ;
-   si le fichier .jsonl déclare un rattachement à une unité archivistique, il doit matérialiser cette unité archivistique par une ligne dédiée correspondant à un dossier dans l'arborescence bureautique. 
    Dans cette ligne :
    -   Ne devront être renseignées que les informations suivantes : 
	    -  DescriptionLevel, 
		-  Title,
		-  UpdateOperation.ArchiveUnitIdentifierKey.MetadataName et Management.UpdateOperation.ArchiveUnitIdentifierKey.MetadataValue OU UpdateOperation.SystemId.
    -   Un rattachement ne peut être déclaré que dans un répertoire racine.

-   le nommage des champs et leur structuration en JSON doivent se conformer au modèle de données de la solution logicielle Vitam.

-   concernant le contenu des champs :

    -   la colonne File :

        -   ne doit pas comprendre d’espace avant ou après les « \\ » ;
        -   doit correspondre à un chemin tel que décrit par l’explorateur de fichiers (avec des « \\ » et non des « / ») ;

    -   le champ DescriptionLevel ne doit comprendre que les valeurs autorisées par le standard SEDA : Collection, Fonds, Series, SubSeries, RecordGrp, File, Item ;
    -   les champs correspondant à des champs Date dans le standard SEDA doivent être formatés conformément à la norme ISO 8601 (AAAA-MM-JJ) ;
    -   les références à des règles de gestion et à des profils d’unité archivistique doivent se conformer aux identifiants de règles présents dans le SAE

-   Aucun fichier ne doit avoir un poids équivalent à 0 octet.
-   Les dates de début (Content.StartDate) doivent être antérieures aux dates de fin (Content.EndDate).
-   Au terme de la V.8.1, il est recommandé que les noms de répertoires et de fichiers ne contiennent ni caractère accentué, ni virgule, ni apostrophe, ni parenthèse, ni espace, ni élément de ponctuation, ou tout autre caractère spécial. Ne sont à privilégier que l’underscore et le tiret comme séparateurs.

    Néanmoins, s’ils en contiennent et si l’arborescence bureautique émane d’un environnement Windows, il est recommandé d’utiliser l’outil Winzip pour la zipper, afin d’éviter des problèmes d’encodage.

L’import du fichier .zip incluant un fichier .jsonl et une arborescence bureautique provoque :

-   la création des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^15]*). Sont enregistrées automatiquement les valeurs portées dans le fichier .csv si l’enregistrement ne contient pas d’erreur.

    À chaque enregistrement, est associé :
	
	-   l’identifiant de la transaction (_opi) ;
	-   un identifiant de batch (_batchId) ;
	-   la localisation initiale du dossier ou du fichier dans l'arborescence (_uploadPath),
	-   l'identifiant du service producteur (_sp et _sps) ;

-   la création de métadonnées techniques dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^16]*).

    À chaque enregistrement, est associé :
	-  l’identifiant de la transaction (_opi) ;
    -   un identifiant de batch (_batchId) ;
	-  l'identifiant du service producteur (_sp) ;

-   l’enregistrement des objets numériques sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets, calculés lors de l’envoi du fichier numérique ;
	
-   le cas échéant :

    - si le projet de versement déclarait un rattachement unique, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « STATIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation);
    - si le projet de versement déclarait un rattachement par clé / valeur, la création d'une unité archivistique dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement :
      -   un niveau de description (DescriptionLevel) dont la valeur est « Series »,
      -   un intitulé (Title) dont la valeur est « DYNAMIC_ATTACHEMENT »,
      -   l'identifiant de l'unité archivistique de rattachement (champ SystemId inclus dans un bloc UpdateOperation).

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec  | Le fichier .zip n’a pas été téléchargé pour cause de nom erroné ou de chemin introuvable ; Le fichier .jsonl contient au moins une erreur ; La transaction n’existe pas ou est erronée ; La transaction est clôturée. |

Cette action n’est pas journalisée dans le journal des opérations.

***Point d’attention :*****

-   Au terme de la V.8.1, le module de collecte peut :

	-  bloquer l'import de l’arborescence bureautique accompagnée d’un fichier .jsonl si ce dernier comporte les erreurs suivantes :
	   -   il ne contient pas au moins le champ obligatoire File ;
	   -   au moins un bloc UnitContent ne contient aucune information ;
	   -   au moins un fichier référencé dans le fichier .jsonl n'est pas présent dans l'arborescence bureautique,
	   -   il ne contient aucune information ;
	   -   une date de fin de règle a été intégrée dans le fichier .jsonl ;
	   -   il dispose d’un champ dont le contenu est mal formaté (ex. ReceivedDate écrite en chaîne de caractères) ;
    
	   -   etc.
	   L'API peut :
	       - soit renvoyer une seule erreur, si cette erreur est bloquante,
		   - soit renvoyer jusqu'à 20 erreurs, si ces erreurs sont cumulables.
	   L'arborescence bureautique ne sera pas importée.

-   Aucun contrôle n’est effectué entre le nombre de répertoires et d’objets binaires présents dans l’arborescence bureautique et les éléments décrits dans le fichier .jsonl. Il est recommandé de veiller à ne pas ajouter de niveaux intermédiaires dans l’arborescence bureautique non référencés dans le fichier .jsonl, car ils seront automatiquement créés dans le module de collecte selon le comportement décrit dans la sous-section précédente.


###### Utilisation dans VitamUI

Il n'est pas possible de mettre à jour des unités archivistiques au moyen d'un import de fichier .jsonl depuis l’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam.

#### Réorganisation des arborescences

##### Utilisation des API

La solution logicielle Vitam permet de modifier l’arborescence des unités archivistiques d'une transaction. Il est possible de :

-  rattacher une unité archivistique à une unité archivistique, en respectant l’organisation hiérarchique de l’information,
-  modifier un rattachement préexistant,
-  ajouter un rattachement,
-  supprimer un lien hiérarchique entre une unité archivistique et une autre, ce qui signifie qu’on peut supprimer un sous-niveau à un niveau de description parent.

***Point d’attention :*** 
-  En prérequis à cette action, il faut avoir au préalable créé une transaction et le signaler dans l’API, pour une suppression d'unités archivistiques.
-  A noter qu'au terme de la version 8.1, il n'est pas possible de modifier la(les) position(s) de rattachement de la transaction.

*Exemple : requête en vue de déplacer l'unité d'archives dont l’identifiant est «  aeaqaaaaaeecohy6ab4heamu7jl5epqaaaba »*

```  
@transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
POST {{url-collect}}/collect-external/v1/transactions/{{transaction-id}}/reclassification
Accept: application/json
Content-Type: application/json
X-Tenant-Id: {{tenant}}

[
  {
    "$roots": [],
    "$query": [{ "$eq": { "#id": "aeaqaaaaaeecohy6ab4heamu7jl5epqaaaba" } }],
    "$action": [
      {
        "$pull": {
          "#unitups": [ "aeaqaaaaaeecohy6ab4heamu7jl5epqaaaaq" ]
        },
        "$add": {
          "#unitups": [ "aeaqaaaaaeecohy6ab4heamu7jl5ejqaaaaq" ]
        }
      }
    ]
  }
]
```  

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès        | Action réalisée sans rencontrer de problèmes particuliers.|
| Échec         | Action non réalisée :
<br/>L'unité archivistique de destination semble inexistante ou inaccessible,
<br/>L'unité archivistique à déplacer semble inexistante dans la transaction.|

Elle est journalisée dans le journal des opérations (COLLECT_RECLASSIFICATION).

##### Utilisation dans VitamUI

TO DO

#### Ajout d'archives

##### Utilisation des API

La solution logicielle Vitam permet d'ajouter des unités archivistiques à une transaction donnée.

***Point d’attention :*** En prérequis à cette action, il faut avoir au préalable créé une transaction et le signaler dans l’API. Le(s) document(s) ajouté(s) doivent être compressé(s) au format zip.

*Exemple : requête en vue d'ajouter une ou plusieurs unité(s) d'archives à une transaction dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*

```  
  @transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
POST {{url}}/collect-external/v1/transactions/{{transaction-id}}/upload
Accept: application/json
Content-Type: application/zip
X-Tenant-Id: {{tenant}}
X-Access-Contract-Id: {{access-contract}}
*X-Attachement-Id : guid-de-au-cible*

< C:\Users\doc_a_ajouter.zip
```  

Cette action provoque :

-   la création des unités archivistiques dans la base de données MongoDB, dans la collection « Unit » (base *MetadataCollect[^10]*). Sont enregistrés automatiquement[^11] :

    -   un niveau de description (DescriptionLevel) dont la valeur est :

        -   « RecordGrp » pour une unité archivistique référençant un répertoire,
        -   « Item » pour une unité archivistique référençant un objet numérique ;

    -   un intitulé (Title), correspondant au nom d’un répertoire ou d’un objet binaire présent dans l’arborescence bureautique.

    À chaque enregistrement, est associé l’identifiant de la transaction (_opi).

-   la création de métadonnées techniques dans la base de données MongoDB, dans la collection « ObjectGroup » (base *MetadataCollect[^12]*) ;

    À chaque enregistrement, est associé l’identifiant de la transaction (_opi) ;

-   l’enregistrement des objets numériques sur les offres de stockage.
-   la mise à jour des métadonnées techniques de l’objet avec, calculés lors de l’envoi du fichier numérique :

    -   ajout de l’empreinte d’un fichier numérique,
    -   ajout de l’identification de son format,
    -   mise à jour de son poids exprimé en octets.

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
| --- | --- |
| Succès | Action réalisée sans rencontrer de problèmes particuliers. |
| Échec |  Le fichier .zip n’a pas été téléchargé pour cause de nom erroné ou de chemin introuvable<br> La transaction n’existe pas ou est erronée.<br>La transaction a été clôturée.<br>Le GUID de la position cible est erroné |

Elle n’est pas journalisée dans le journal des opérations.

Point d’attention :

-   Aucun fichier ne doit avoir un poids équivalent à 0 octet.
-   Au terme de la V.8.1, il est recommandé que les noms de répertoires et de fichiers ne contiennent ni caractère accentué, ni virgule, ni apostrophe, ni parenthèse, ni espace, ni élément de ponctuation, ou tout autre caractère spécial. Ne sont à privilégier que l’underscore et le tiret comme séparateurs.

    Néanmoins, s’ils en contiennent et si l’arborescence bureautique émane d’un environnement Windows, il est recommandé d’utiliser l’outil Winzip pour la zipper, afin d’éviter des problèmes d’encodage.

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet d'ajouter des unités archivistiques dans une transaction, à l'endroit de l'arborescence défini, au moyen d’un wizard ou boîte de dialogue contenant une fenêtre d'upload.

#### Suppression d'archives

##### Utilisation des API

La solution logicielle Vitam permet de supprimer une à plusieurs unités archivistiques d'une transaction donnée.

***Point d’attention :*** En prérequis à cette action, il faut avoir au préalable créé une transaction et le signaler dans l’API, pour une suppression d'unités archivistiques.

*Exemple : requête en vue de supprimer l'unité d'archives dont l’identifiant est «  aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq »*

```  
  @transaction-id= *aeeaaaaaachj3m7nabjocamcdqr2rqaaaaaq*
  
  POST {{url-collect}}/collect-external/v1/transactions/{{transaction-id}}/deletion/action
  Accept: application/json
  Content-Type: application/json
  X-Tenant-Id: {{tenant}}
  X-Access-Contract-Id: {{access-contract}}

{
  "dslRequest": {
    "$roots": [],
    "$query": [
      {
      "$eq": {
            "#id": "aeeaaaaaagecohy6ab4heamu6wrl5hiaaaaq"
          }
        }
    ],
    "$threshold": 10
  }
}
```  

Cette action provoque la suppression :
    -   des unités archivistiques de la collection « Unit » (base *MetadataCollect*) ;
    -   des groupes d’objets techniques de la collection « ObjectGroup » (base *MetadataCollect*).
    -   des objets des offres de stockage ;

Lors de cette action, l’opération peut aboutir aux résultats suivants :

| Statut | Motifs |
|---|---|
| Succès        | Action réalisée sans rencontrer de problèmes particuliers.|
| Avertissement | Au moins une des unités archivistiques ne peut pas être supprimée car elle(s) a(ont) des enfants (NON_DESTROYABLE_HAS_CHILD_UNITS).|
| Échec         | Le seuil de requête est dépassé.|

Elle est journalisée dans le journal des opérations (COLLECT_DELETION).

##### Utilisation dans VitamUI

L’APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam permet de supprimer une à plusieurs unités archivistiques d'une transaction et, de fait, les objets numériques associés.

Des droits utilisateurs sont par ailleurs définis :

| Profil utilisateur | Suppression d'archives |
|---|---|
| Administrateur     | oui |
| Archiviste         | oui |
| Service producteur | non |

Les opérations de suppression sont journalisées et leur résultat accessible depuis l'APP « Journal des opérations ».


Conseils de mise en œuvre
-------------------------

À l’issue de cette phase de réalisation de fonctionnalités concernant le module de collecte, l’équipe du programme Vitam est en mesure de fournir plusieurs recommandations de mise en œuvre.

### Comment formaliser les données dans les API du module de collecte ?

Il est possible de verser séparément dans le module de collecte selon un formalisme spécifique au format JSON :

-   les métadonnées correspondant à l’en-tête du message ArchiveTransfer,
-   les métadonnées décrivant les unités archivistiques,
-   les métadonnées techniques.

Chaque appel API[^23] permettant de verser ces métadonnées inclut une liste d’éléments, clés ou vocabulaires que l’on souhaite intégrer dans le module de collecte.

Si ces éléments doivent respecter le formalisme attendu par le SEDA et l’ontologie de la solution logicielle Vitam (s’il s’agit d’une chaîne de caractères, d’une date, d’un élément répétable, etc.), il n’est pas nécessaire de les ordonnancer comme le demande le SEDA.

Si certains éléments, issus du SEDA et/ou du système externe, ne doivent pas être envoyés, il n’est pas nécessaire de les référencer dans les différents appels API[^24].

Certains contrôles, disponibles au moment du transfert dans la solution logicielle Vitam n’ont pas été implémentés. Il est fortement recommandé de ne pas envoyer dans le module de collecte des éléments sans valeurs, en particulier ceux qui sont obligatoires et doivent nécessairement être renseignés.

#### Généralités

Dans un enregistrement JSON, un élément (ou vocabulaire) est désigné par son **nom**.

 *Exemple : l’élément suivant se nomme Description.*
```  
  "Description": "Ceci est une description"
```  

***Point d’attention :***

-   Si un élément (ou vocabulaire), présent dans un enregistrement, n’existe pas dans l’ontologie, Il est fortement recommandé de l’avoir préalablement créé dans le référentiel[^25].
-   Les vocabulaires issus du SEDA sont nommés de la même manière qu’ils le sont dans le standard (ex. l’élément « Tag » défini dans le SEDA est référencé sous ce nom dans l’ontologie et doit être indiqué comme tel).
-   Il existe néanmoins quelques exceptions à cette règle :

    -   le bloc Management doit être déclaré sous le nom \#management. La modélisation des catégories de règle de gestion attend :

        -   un sous-bloc « Rules » pouvant contenir 0 à n règles de gestion, non défini par le SEDA,
        -   un sous-bloc « Inheritance » pouvant bloquer des règles de gestion, non défini par le SEDA. Ce sous-bloc peut également contenir l’élément « PreventRulesId » correspondant au champ « RefNonRuleId » du SEDA.

    -   si le bloc Event porte le nom « Event », ses sous-blocs doivent être renommés pour se conformer à l’ontologie :

        -   « EventIdentifier » en « evId »,
        -   « EventTypeCode » en « evTypeProc »,
        -   « EventType » en « evType »,
        -   « EventDateTime » en « evDateTime »,
        -   « EventDetail » en « evTypeDetail »,
        -   « Outcome » en « outcome »,
        -   « OutcomeDetail » en « outDetail »,
        -   « OutcomeDetailMessage » en « outMessg »,
        -   « EventDetailData » en « evDetData ».

    -   les éléments Title et Description, s’ils contiennent des attributs, seront intitulés « Title\_ » et « Description\_ » et devront définir des propriétés[^26].

#### Types

L’élément (ou vocabulaire) est associé à un **type** particulier[^27]. On distingue plusieurs types JSON possibles :

-   « string » : texte ;
-   « number » : nombre, entier ou décimal ;
-   « integer » : nombre entier ;
-   « boolean » : booléen dont la valeur est true ou false ;
-   « object » : objet ;
-   « array » : liste ou tableau de valeurs textuelles.

Il doit alors être cohérent avec celui du vocabulaire tel qu’il est déclaré dans l’ontologie[^28] :

| Type d’indexation dans l’ontologie | Type correspondant<br>dans un profil d’unité archivistique<br>Vocabulaire interne|  Type correspondant<br>dans un profil d’unité archivistique<br>Vocabulaire externe| Commentaires |
|---|---|---|---|
| TEXT                               | string ou [string]                   | [string] | |
|  KEYWORD                           | string ou [string]                   |[string]||
|  DATE                              | string ou [string] + pattern date    |[string] + pattern date||
|  LONG                              | number ou integer <br> \[number\] ou [integer] | [number] ou [integer] ||
|  DOUBLE                            | number ou [number]                   |[number]||
|  BOOLEAN                           | boolean ou [boolean]                 |[boolean]||
|  GEO_POINT                         | string                               |[string]|*L’équipe Vitam n’a pas investigué sur les usages de ce type d’indexation*|
|  ENUM                              | [string] + pattern énumératif        |[string] + pattern énumératif|*L’équipe Vitam n’a pas investigué sur les usages de ce type d’indexation*|

Par analogie au SEDA et au langage XML, il convient de prêter attention aux éléments suivants :

-   sera qualifié en objet (« object ») un élément contenant des sous-éléments, par exemple : Management, Writer, Keyword ;
-   sera qualifié en tableau (ou « array ») :

    -   un élément répétable, tel que Tag ou OriginatingAgencyArchiveUnitIdentifier,
    -   un vocabulaire externe ;

-   certains éléments du SEDA (PreventInheritance, NeedAuthorization, NeedReassessingAuthorization) doivent contenir un booléen.

On trouvera essentiellement les types suivants :

-   pour les **informations d’en-tête** : les éléments sont uniquement de type « string » ou « array » ;
-   pour une **unité archivistique** :

    -   pour les *vocabulaires internes*, propres au SEDA, les principaux types rencontrés sont : « string », « array » et « object », auxquels s’ajoute un unique « boolean » et un unique « integer »[^29].
    -   quant aux *vocabulaires externes*, ajoutés pour répondre à des besoins et transferts spécifiques, il faut les identifier systématiquement comme des « array » (ou tableaux), c’est-à-dire des éléments répétables. Ces tableaux peuvent inclure ensuite un type particulier de chaînes : texte, entier, décimal ou booléen.

-   Pour un **groupe d’objets techniques**:

    -   pour les *vocabulaires internes*, propres au SEDA, les principaux types rencontrés sont : « string », « array » et « object », auxquels s’ajoutent quelques « integer » ou « number ».

Les éléments de type « array » et « object » ont une structuration plus complexe qu’un type simple :

-   un type simple se définit par un nom, auquel est associé une seule valeur. Ce type est associé à un élément dont la cardinalité est 0-1 ou 1-1.

 *Exemple : les vocabulaires Description, GpsAltitude et NeedAuthorization sont des éléments simples. Attendant un entier, Size est caractérisé par un item de type « integer », tandis que NeedAuthorization est de type « boolean ».*
```  
  "Description": "Ceci est une description"
  "GpsAltitude": 390
  "NeedAuthorization": true
```

-   un élément de type « array » peut contenir une liste ou un tableau de valeurs ou d’objets. Ce type est associé à un élément dont la cardinalité est 0-n ou 1-n.

 *Exemple : les vocabulaires externes NomDuCapitaine, AgeDuCapitaine et le vocabulaire interne Tag sont dotés d’un type « array » dans l’enregistrement d’une unité archivistique. Attendant un entier, AgeDuCapitaine est caractérisé par un item de type « integer ».*
  
```  
  "NomDuCapitaine" : ["Capitaine Fracasse"],
  "AgeDuCapitaine" : [1],
  "Tag" : ["Marine", "Capitaine Fracasse"]
```  

-   un élément de type « object » définit des sous-éléments. Ce type peut être associé à un tableau de sous-éléments (ex. « RegisteredAgent »).

 *Exemple :*
  
``` 
  "RegisteredAgent": [{
   **"FirstName": "description",**
   "FullName": "description",
   "BirthName": "description"
   }]
  "BirthPlace": {
   **"Geogname": "Toronto [Ontario]",**
   "Address": "123 my Street",
   "PostalCode": "CD255",
   "City": "Toronto",
   "Region": "Ontario",
   "Country": "Canada"
   }
```  

Enfin, en fonction du type d’indexation, les valeurs doivent être enregistrées

-   soit entre guillemets (string)
-   soit sans guillemets (integer, number, boolean).

 *Exemple : les vocabulaires Title, Size et NeedReassessingAuthorization sont des éléments simples : le premier est un string, le second un integer et le dernier un boolean.*
  
```  
  "Title": "Ceci est une description"
  "Size": 390
  "NeedReassessingAuthorization": false
```  

#### Cas particulier

Les éléments **« Title » et « Description »**, s’ils définissent un attribut ou sont répétables, doivent prendre la forme d’objet.
```
"Title_": {
     "fr": "Ceci est un titre en français",
     "en": "This is a title in English"
}
"Description_": {
     "fr": "Ceci est une description en français",
     "en": "This is a content in English"
}
```

Le bloc définissant les **règles de gestion** contient également des particularités. Il doit être déclaré sous le nom \#management. La modélisation des catégories de règle de gestion attend :

-   un sous-bloc « Rules » pouvant contenir 0 à n règles de gestion,
-   un sous-bloc « Inheritance » pouvant bloquer des règles de gestion[^30].

 *Exemple : Le bloc AppraisalRule déclare deux règles différentes dans le sous-bloc Rules, « APP-00001 » et « APP-00002 », et définit un blocage sur la catégorie de règle avec le sous-bloc PreventInheritance.*
```  
  "\#management": {
   "AppraisalRule": {
   "Rules": [ {
   "Rule": "APP-00001",
   "StartDate": "2015-01-01",
   "EndDate": "2095-01-01"
   },
   {
   "Rule": "APP-00002"
   } ],
   "Inheritance": {
   "PreventInheritance": true,
   "PreventRulesId": []
   },
   "FinalAction": "Keep"
  }
```
### Comment sont gérés les statuts d’une transaction ?

Le module de collecte attribue un certain nombre de statuts à une transaction. Ces statuts sont générés à la suite d’une action :

| Actions disponibles                   | Statut correspondant<br>dans le front-office | Statut correspondant<br>dans le back-office | Modification possible ? | Abandon possible ? | Purge automatique ? |
|---|---|---|---|---|---|
| Créer la transaction                     | Ouvert en édition            |OPEN           |          OUI       |          OUI ||
| Clôturer / Valider                       | Validé                       |READY          |                    |          OUI ||
| Verser / Envoyer                         | Préparation et envoi du SIP  |SENDING        |                    |              ||
|Verser / Envoyer|  Envoyé, en cours de traitement du SAE                                |SENT           |                    |              ||
|Verser / Envoyer|  Versé en succès                                                      |ACK_OK         |                    |              |OUI|
|Verser / Envoyer|  Versé                                                                |ACK_WARNING    |                    |              |OUI|
|Verser / Envoyer|  Échec du versement                                                   |ACK_KO         |                    |         OUI  ||
|Verser / Envoyer|  Erreur technique                                                     |KO             |                    |         OUI  ||
|  Éditer / Rouvrir                        | Ouvert en édition            |OPEN           |          OUI       |              ||
|  Abandonner                              | Abandonné                    |ABORTED        |                    |              |OUI|

### Comment sont gérés les statuts d’une transaction ? - A REVOIR

TO DO

Ces services sont disponibles depuis l'APP « Collecte et préparation des versements » du front-office VitamUI fournie avec la solution logicielle Vitam  :

-   depuis la page permettant de visualiser l’ensemble des archives d’un projet de versement, où il est possible de :

    -   « Valider » un versement, action correspondant à la clôture du versement,
    -   « Verser » un versement, action correspondant à l’envoi du SIP.

-   depuis la page permettant de visualiser l’ensemble des transactions (ou versements) associées à un projet de versement, où il est possible de :

    -   « Accéder aux archives »,
    -   « Valider » un versement, action correspondant à la clôture du versement,
    -   « Verser » un versement, action correspondant à l’envoi du SIP,
    -   « Editer » un versement, action correspondant à la réouverture du versement en vue, notamment, de le modifier,
    -   « Abandonner » un versement, action correspondant à l’abandon du versement,

Certaines de ces actions entraînent la purge des archives passé un certain délai. Il s’agit des actions suivantes :

-   « Abandonner »
-   « Verser », si le résultat de cette action est un versement en succès ou en avertissement.

|  Actions disponibles                   | Statut correspondant dans le front-office    | Statut correspondant dans le back-office| Purge automatique ? |
|---|---|---|---|
|  Valider   | Validé                      | READY| |
|Verser| Préparation et envoi du SIP | SENDING | |
|Verser| Envoyé, en cours de traitement du SAE | SENT            | |
|Verser | Versé en succès             | ACK_OK                    |  OUI|
|Verser | Versé                       | ACK_WARNING               |  OUI|
|Verser | Échec du versement          | ACK_KO                    | |
|Verser | Erreur technique            | KO                        | |
|  Éditer    | Ouvert en édition           | OPEN                      | |
|  Abandonner| Abandonné                   | ABORTED                   |  OUI|

### Comment paramétrer un versement ?

La solution logicielle Vitam permet de paramétrer des versements au moyen de la définition d’un projet de versement. Dans ce dernier, il est possible de :

-   définir des métadonnées d’en-tête qui seront héritées dans chacune des transactions qui seront associées au projet de versement et qui, de fait, ne nécessiteront pas d’être envoyées lors de la création d’une transaction. Peuvent être héritées les métadonnées suivantes :

    -   un intitulé (Name) ;
    -   des éléments obligatoires à la génération d’un SIP :

        -   le contrat d’entrée (champ « ArchivalAgreement »),
        -   l’identifiant du message (champ « MessageIdentifier),
        -   le service producteur (champ « OriginatingAgencyIdentifier »),
        -   le service d’archivage (champ « ArchivalAgencyIdentifier »),
        -   le service responsable du transfert (« TransferringAgencyIdentifier »)

    -   des éléments facultatifs à la génération d’un SIP :

        -   les modalités d’acquisition (« AcquisitionInformation »),
        -   le statut légal des archives (« LegalStatus »),
        -   le profil d’archivage (« ArchivalProfile »).

***Points d’attention :*** 
Dans le cas d’un flux automatisé, à l’exception de l’intitulé (« Name ») et de l’identifiant du message (« MessageIdentifier »), qui seront la plupart du temps spécifiques à chaque transaction, il est recommandé de spécifier dans le projet de versement les autres métadonnées, qui ont un caractère plus générique.

-   définir des rattachements automatiques pour la(les) transaction(s) associée(s) au projet de versement :

    -   rattachement à une unité archivistique déjà conservée dans la solution logicielle Vitam (« UnitUp ») ;
    -   rattachement à des unités archivistiques déjà conservées dans la solution par la définition de conditions (« UnitUps »), à savoir une métadonnée (« MetadataKey »), une valeur (« MetadataValue ») et une position de rattachement (« UnitUp »). Si l’(les) unité(s) archivistique(s) racine(s) comporte(nt) la métadonnée et la valeur définies, alors elle(s) ira(ont) se rattacher à l’unité archivistique de rattachement associée ;

    Ces deux paramètres peuvent être utilisés séparément ou ensemble. S’ils sont utilisés ensemble, alors, le module de collecte proposera un rattachement automatique des unités archivistiques racines suivant les conditions définies dans le projet de versement. Si elles ne remplissent pas les conditions, alors elles seront rattachées à l’unité archivistique de rattachement par défaut (« UnitUp »).

Annexe 1 : Exemples de données entrantes
----------------------------------------

*Nota bene *: les cas présentés ci-dessous sont des exemples fictifs.

### Métadonnées d'en-tête

```
{
  "ArchivalAgencyIdentifier": "Vitam",
  "TransferringAgencyIdentifier": "AN",
  "OriginatingAgencyIdentifier": "MICHEL\_MERCIER",
  "SubmissionAgencyIdentifier": "MICHEL\_MERCIER",
  "MessageIdentifier": "20220302-000005",
  "ArchivalAgreement":"IC-000001",
  "Comment": "Versement du service producteur : Cabinet de Michel Mercier"
}
```

### Unités archivistiques

```
{
    "DescriptionLevel": "RecordGrp",
    "Title": "Discours de Michel Mercier",
    "\#management": {
      "AccessRule": {
            "Rules": [
                {
                    "Rule": "ACC-00001",
                    "StartDate": "2000-01-01"
                }
            ]
        }
      }
}
```
### Objets

```
{
  "FileInfo": {
    "Filename": "MonFichier.txt"
  }
}
```

Annexe 2 : Types JSON
---------------------

Pour les éléments propres au SEDA, le tableau suivant précise les types de certains d’entre eux :

-   Métadonnées d’en-tête :

|                               | obligatoire | string | number | boolean | object | array|
|---|---|---|---|---|---|---|
|  ArchivalAgreement            | x           | x      |        |         |        | |
|  MessageIdentifier            | x           | x      |        |         |        | |
|  Comment                      |             | x[^31] |        |         |        | |
|  OriginatingAgencyIdentifier  | x           | x      |        |         |        | |
|  SubmissionAgencyIdentifier   |             | x      |        |         |        | |
|  ArchivalAgencyIdentifier     | x           | x      |        |         |        | |
|  TransferringAgencyIdentifier | x           | x      |        |         |        | |
|  ArchivalProfile              |             | x      |        |         |        | |
|  AcquisitionInformation       |             | x      |        |         |        | |

-   Métadonnées descriptives et de gestion d’une unité archivistique :

|                                      | obligatoire | string | number | boolean | object | array|
|---|---|---|---|---|---|---|
| ArchiveUnitProfile                      | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| #management[^32]                        | x               | <br>                    | <br>       | <br>        | x          | <br>                  |
| AccessRule                              | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| AppraisalRule                           | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| StorageRule                             | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| ReuseRule                               | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| ClassificationRule                      | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| HoldRule                                | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Rules                                   | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Rule                                    | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| StartDate                               | <br>            | x[^33]                  | <br>       | <br>        | <br>       | <br>                  |
| EndDate                                 | <br>            | x[^34]                  | <br>       | <br>        | <br>       | <br>                  |
| FinalAction[^35]                        | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Inheritance                             | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| PreventInheritance                      | <br>            | <br>                    | <br>       | x           | <br>       | <br>                  |
| PreventRulesId                          | <br>            | <br>                    | <br>       | <br>        | <br>       | x[^36] |
| HoldEndDate                             | <br>            | x[^37]                  | <br>       | <br>        | <br>       | <br>                  |
| HoldOwner                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| HoldReason                              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| HoldReassessingDate                     | <br>            | x[^38]                  | <br>       | <br>        | <br>       | <br>                  |
| PreventRearrangement                    | <br>            | <br>                    | <br>       | x           | <br>       | <br>                  |
| ClassificationOwner                     | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| ClassificationReassessingDate           | <br>            | x[^39]                  | <br>       | <br>        | <br>       | <br>                  |
| NeedReassessingAuthorization            | <br>            | <br>                    | <br>       | x           | <br>       | <br>                  |
| ClassificationLevel                     | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| ClassificationAudience                  | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Logbook                                 | <br>            | <br>                    | <br>       | <br>        | <br>       | x                     |
| NeedAuthorization                       | <br>            | <br>                    | <br>       | x           | <br>       | <br>                  |
| DescriptionLevel                        | x               | x                       | <br>       | <br>        | <br>       | <br>                  |
| Title                                   | x               | x                       | <br>       | <br>        | <br>       | x                     |
| Title_                                  | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| FilePlanPosition                        | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| SystemId                                | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| OriginatingSystemId                     | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| ArchivalAgencyArchiveUnitIdentifier     | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| OriginatingAgencyArchiveUnitIdentifier  | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| TransferringAgencyArchiveUnitIdentifier | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Description                             | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Description_                            | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| CustodialHistory                        | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| CustodialHistoryItem                    | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Type                                    | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| DocumentType                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Language                                | <br>            | x[^40]                  | <br>       | <br>        | <br>       | x                     |
| DescriptionLanguage                     | <br>            | x[^41]                  | <br>       | <br>        | <br>       | <br>                  |
| Status                                  | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Version                                 | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Tag                                     | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Keyword                                 | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| KeywordContent                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| KeywordReference                        | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| KeywordType                             | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Coverage                                | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Spatial                                 | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Temporal                                | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| Juridictional                           | <br>            | x                       | <br>       | <br>        | <br>       | x                     |
| OriginatingAgency                       | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| SubmissionAgency                        | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Identifier                              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| AuthorizedAgent                         | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Writer                                  | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Addressee                               | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Recipient                               | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Transmitter                             | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| Sender                                  | <br>            | <br>                    | <br>       | <br>        | x          | x                     |
| FirstName                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| BirthName                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| FullName                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GivenName                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Gender                                  | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| BirthDate                               | <br>            | x[^42]                  | <br>       | <br>        | <br>       | <br>                  |
| DeathDate                               | <br>            | x[^43]                  | <br>       | <br>        | <br>       | <br>                  |
| BirthPlace                              | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| DeathPlace                              | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Geogname                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Address                                 | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| PostalCode                              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| City                                    | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Region                                  | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Country                                 | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Nationality                             | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Corpname                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Identifier                              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Function                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Activity                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Position                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Role                                    | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Mandate                                 | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| RelatedObjectReference                  | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| IsVersionOf                             | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Replaces                                | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Requires                                | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| IsPartOf                                | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| References                              | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| ArchiveUnitRefId                        | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| DataObjectReference                     | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| DataObjectReferenceId                   | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| DataObjectGroupReferenceId              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| RepositoryArchiveUnitPID                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| RepositoryObjectPID                     | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| CreatedDate                             | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| TransactedDate                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| AcquiredDate                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| SentDate                                | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| ReceivedDate                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| RegisteredDate                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| StartDate                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| EndDate                                 | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Event                                   | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| evId[^44]                               | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| evTypeProc[^45]                         | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| evType[^46]                             | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| EvDateTime[^47]                         | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| evTypeDetail[^48]                       | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| outcome[^49]                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| outDetail[^50]                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| outMessg[^51]                           | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| evDetData[^52]                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Signature                               | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Signer                                  | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| Validator                               | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| ValidationTime                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| MasterData                              | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| ReferencedObject                        | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| SignedObjectId                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| SignedObjectDigest                      | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| Gps                                     | <br>            | <br>                    | <br>       | <br>        | x          | <br>                  |
| GpsVersionId                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GpsAltitude                             | <br>            | <br>                    | x          | <br>        | <br>       | <br>                  |
| GpsAltitudeRef                          | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GpsLatitude                             | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GpsLongitude                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GpsLongitudeRef                         | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |
| GpsDateStamp                            | <br>            | x                       | <br>       | <br>        | <br>       | <br>                  |

Annexe 3 : Liste des points d’API
---------------------------------

|                   |       Description                 | Permission               | Verbe         | EndPoint |
|---|---|---|---|---|
| project           | Création d’un projet de versement | project:create           | POST          | /collect-external/v1/projects/ |
|                   | Récupère la liste des projets de versement | project:read    | GET           | /collect-external/v1/projects/ |
|                   | Récupère un projet de versement   | project:id:read          | GET           | /collect-external/v1/projects/{projectId}/ |
|                   | Récupère la liste des projets de versement par critère de recherche | project:query:read | GET | project:query:read |
|                   | Mise à jour d’un projet de versement | project:update        | PUT           | /collect-external/v1/projects  |
|                   | Supprime un projet de versement   | project:id:delete        | DELETE        | /collect-external/v1/projects/{projectId}/ |
|                   | Verser une archive arborescente ZIP à un projet de versement automatique sans transaction | project:id:zip:create | POST        | /collect-external/v1/projects/{projectId}/upload/ |


|                   | Récupérer la liste des transactions du projet | project:id:transactions | GET |/collect-external/v1/projects/{projectId}/transactions/ |
| transaction       | Création de la transaction        | transaction:create       | POST          | /collect-external/v1/projects/{projectId}/transactions/ |
|                   | Mise à jour d’une transaction     | transaction:update       | PUT           | /collect-external/v1/transactions/ |
|                   | Récupère une transaction          | transaction:id:read      | GET           | /collect-external/v1/transactions/{transactionId}/ |
|                   | Clôture de la transaction         | transaction:close        | POST          | /collect-external/v1/transactions/{transactionId}/close/ |
|                   | Envoi de la transaction           | transaction:send         | POST          | /collect-external/v1/transactions/{transactionId}/send/ |
|                   | Abandonner une transaction        | transaction:abort        | PUT           | /collect-external/v1/transactions/{transactionId}/abort/ |
|                   | Rouvrir une transaction           | transaction:reopen       | PUT           | /collect-external/v1/transactions/{transactionId}/reopen/|
|                   | Charge les binaires en lot        | transaction:zip:create   | POST          | /collect-external/v1/transactions/{transactionId}/upload/|
|                   | Crée une unité archivistique      | transaction:unit:create  | POST          | /collect-external/v1/transactions/{transactionId}/units/|
|                   | Récupère toutes les unités archivistiques | transaction:unit:read | GET      | /collect-external/v1/transactions/{transactionId}/units/|
|                   | Supprime une transaction          | transaction:id:delete    | DELETE        | /collect-external/v1/transactions/{transactionId}/|
| units             | Crée ou modifie un groupe d’objets techniques | transaction:object:upsert | POST | /collect-external/v1/units/{unitId}/objects/{usage}/{version}/|
|                   | Insère ou modifie un objet binaire| transaction:binary:upsert | POST         | /collect-external/v1/units/{unitId}/objects/{usage}/{version}/binary/ |
|                   | Récupère une unité archivistique  | transaction:unit:id:read | GET           | /collect-external/v1/units/{{unit-id}}/ |
|                   | Mettre à jour les unités archivistiques | transaction:id:units:update | PUT  | /collect-external/v1/transactions/{transactionId}/units/|
|                   | Télécharge un usage/version du binaire<br> d'un groupe d'objets techniques| transaction:binary:read | GET | /collect-external/v1/units/{unitId}/objects/{usage}/{version}/binary/|
|                   | Réorganisation des arborescences | transaction:reclassification | POST  | /collect-external/v1/transactions/{transactionId}/reclassification|
|                   | Supprime des archives | transaction:deletion:action             | POST  | /collect-external/v1/transactions/{transactionId}/deletion|
|                   | Elimine des archives | transaction:elimination:action           | POST  | /collect-external/v1/transactions/{transactionId}/elimination/action|
| objects           | Récupère un groupe d’objets techniques | transaction:object:read | GET       | /collect-external/v1/objects/{gotId}/|

[^1]:  Pour plus d’informations, consulter le document *Modèle de données*, « Collection Project ». Un exemple de projet de versement se trouve dans l’[annexe 1](#annexe-1-exemples-de-donnees-entrantes) du présent document.

[^2]:  À noter que, dans l’APP « Collecte et préparation des versements », ce champ est alimenté par la valeur du champ « MessageIdentifier ».

[^3]:  Pour plus d’informations, consulter le document *Modèle de données*, « Collection Transaction ». Un exemple de contexte de collecte se trouve dans l’[annexe 1](#annexe-1-exemples-de-donnees-entrantes) du présent document.

[^4]:  À noter que cette collection est renommée « Transaction » dans la version 6 RC de la solution logicielle Vitam.

[^5]:  Si la transaction est clôturée (son statut est égal à « READY »), il n’est plus possible de lui adjoindre des unités archivistiques, ainsi que des métadonnées techniques et des objets.

[^6]:  Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^7]:  Si la transaction est clôturée (son statut est égal à « READY »), il n’est plus possible de lui adjoindre des unités archivistiques, ainsi que des métadonnées techniques et des objets.

[^8]:  Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^9]:  Si la transaction est clôturée (son statut est égal à « READY »), il n’est plus possible de lui adjoindre des unités archivistiques, ainsi que des métadonnées techniques et des objets.

[^10]: Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^11]:  Le fonctionnement est identique à celui de l’import d’arborescence bureautique dans ReSIP.

[^12]: Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^13]:  Se référer à la sous-section 3.2.4.2 « Envoi d’une arborescence bureautique » du présent document.

[^14]:  Son modèle est identique au modèle de fichier .csv importé dans ReSIP, hors colonnes ID et ParentID qui ne sont pas supportées par le module de collecte en l’état actuel des développements.

[^15]: Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^16]: Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^17]: Son modèle est identique au modèle de fichier .csv importé dans ReSIP, hors colonnes ID et ParentID qui ne sont pas supportées par le module de collecte en l’état actuel des développements.

[^18]: Pour plus d’informations sur l’enregistrement de l’unité archivistique dans la base de données, il est recommandé de consulter le document *Modèle de données*.

[^19]:  Le paramétrage de la purge automatique s’effectue depuis le fichier collect.conf. Pour modifier le délai par défaut, il faut modifier les valeurs des paramètres « purgeTransactionThreadFrequency » et « purgeTransactionDelayInMinutes » pour le(s) tenant(s) concerné(s).

[^20]:  Le paramétrage de la purge automatique s’effectue depuis le fichier collect.conf. Pour modifier le délai par défaut, il faut modifier les valeurs des paramètres « purgeTransactionThreadFrequency » et « purgeTransactionDelayInMinutes » pour le(s) tenant(s) concerné(s).

[^21]:  Se référer à la sous-section « Réouverture » du présent document.

[^22]:  Le paramétrage de la purge automatique s’effectue depuis le fichier collect.conf. Pour modifier le délai par défaut, il faut modifier les valeurs des paramètres « purgeTransactionThreadFrequency » et « purgeTransactionDelayInMinutes » pour le(s) tenant(s) concerné(s).

[^23]:  Ces appels API sont décrits dans le chapitre 3 du présent document, dans la sous-section 3.1.2 « Utilisation des API ».

[^24]:  La partie ci-dessous explicite la grammaire attendue par le format JSON dans le cadre d’un appel API. Des précisions sur le formalisme attendu est également disponible dans le document *Modèle de données*.

[^25]:  Pour plus d’informations sur les vocabulaires, consulter le document* Ontologie*.

[^26]:  Pour plus d’informations sur ces modélisations particulières, il est recommandé de consulter le document Modèle de données, chapitre 5.1, « Collection Unit ».

[^27]:  Les types des éléments propres au SEDA sont listés dans l'[annexe 2](#annexe-2-types-json) « Types JSON ». Il est conseillé de se reporter à cette annexe, afin de typer correctement les éléments.

[^28]:  La présence de crochets dans le tableau de correspondances indique que le vocabulaire employé dans l’enregistrement peut ou doit se présenter sous la forme d’un tableau ou « array », pouvant contenir un type de valeur en particulier. Le vocabulaire représenté entre crochets est également répétable.

[^29]:  Les types des éléments propres au SEDA sont listés dans l’[annexe 2](#annexe-2-types-json) « Types JSON ». du présent document.

[^30]:  Pour plus d’informations sur ces modélisations particulières, il est recommandé de consulter le document *Modèle de données*, chapitre 5.1, « Collection Unit ».

[^31]:  En l’état actuel des développements, le champ Comment est non répétable, alors que, dans le SEDA, il l’est.

[^32]:  \#management est à employer en lieu et place de la balise Management pour se conformer aux attendus de la solution logicielle Vitam.

[^33]:  Avec un pattern date.

[^34]:  Avec un pattern date.

[^35]:  Simple énumération.

[^36]:  Tableau contenant des éléments de type string.

[^37]:  Avec un pattern date.

[^38]:  Avec un pattern date.

[^39]:  Avec un pattern date.

[^40]:  Le SEDA attend plus précisément un pattern langue.

[^41]:  Le SEDA attend plus précisément un pattern langue.

[^42]:  Avec un pattern date.

[^43]:  Avec un pattern date.

[^44]:  evId est à employer en lieu et place de la balise EventIdentifier dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^45]:  evTypeProc est à employer en lieu et place de la balise EventTypeCode dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^46]:  evType est à employer en lieu et place de la balise EventType dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^47]:  evDateTime est à employer en lieu et place de la balise EventDateTime dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^48]:  evTypeDetail est à employer en lieu et place de la balise EventDetail dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^49]:  outcome est à employer en lieu et place de la balise Outcome dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^50]:  outDetail est à employer en lieu et place de la balise OutcomeDetail dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^51]:  outMessg est à employer en lieu et place de la balise OutcomeDetailMessage dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.

[^52]:  evDetData est à employer en lieu et place de la balise EventDetailData dans un schéma de contrôle pour se conformer aux attendus de la solution logicielle Vitam.