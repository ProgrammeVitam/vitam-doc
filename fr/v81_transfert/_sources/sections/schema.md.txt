Schéma
=====

Introduction
------------

### Documents de référence


|**Document**|**Date de la version**|
|:---------------:|:-----:|:-----:|
|NF Z 44022 – MEDONA – Modélisation des données pour l’archivage|18/01/2014|
|Standard d’échange de données pour l’archivage – SEDA – v. 2.1|06/2018||           
|Standard d’échange de données pour l’archivage – SEDA – v. 2.2|02/2022|
|Standard d’échange de données pour l’archivage – SEDA – v. 2.3|06/2024|
|[Structuration des *Submission Information Packages* (SIP)](./SIP.md)||
|[Ontologie](./ontologie.md)||

### Présentation du document

Le document présente les fonctionnalités associées à la prise en compte de la notion de schéma dans la solution logicielle Vitam.
Il s’articule autour des axes suivants :
- une présentation de la notion de schéma ;
- une présentation de la manière dont la solution logicielle Vitam la formalise ;
- une présentation des mécanismes mis en œuvre dans la solution logicielle Vitam pour prendre en compte cette notion ;
- quelques conseils complémentaires de mise en œuvre.

Le présent document décrit les fonctionnalités qui sont offertes par la solution logicielle Vitam au terme de la version 8.1 (printemps 2025).
Il a vocation à être amendé, complété et enrichi au fur et à mesure de la réalisation de la solution logicielle Vitam et des retours et commentaires formulés par les ministères porteurs et les partenaires du programme.


Présentation de la notion de schéma
-----

### Qu’est-ce qu’un schéma ?

Le schéma référence l’ensemble des vocabulaires ou métadonnées acceptés dans la solution logicielle Vitam pour décrire des archives (unités archivistiques et groupes d’objets techniques). Pour chacun de ces vocabulaires, il définit un chemin, ainsi que des informations utiles à leur utilisation par un front-office (informations relatives au type d’indexation, à sa traduction, son type (métadonnée descriptive, métadonnée de gestion, autre), la version du SEDA, sa taille[^1]).

Le schéma se compose :
- des vocabulaires définis dans le Standard d’échanges de données pour l’archivage (SEDA), inclus par défaut. Ces vocabulaires correspondent aux éléments XML présents dans les messages du SEDA (ArchiveTransfer en particulier) ;
- des vocabulaires propres à la solution logicielle Vitam, inclus par défaut[^2] ;
-  de vocabulaires non gérés par les deux précédents items et ajoutés pour répondre à un besoin particulier du service utilisateur, en particulier enrichir les descriptions, en entrée ou en accès.

Ces vocabulaires peuvent être utilisés pour décrire :
-  0 à n groupe(s) d’objets,
-  0 à n unité(s) archivistique(s),
-  0 à n vocabulaire(s).

**Points d'attention :**
-  les chemins sont uniques dans la solution logicielle Vitam ;
-  contrairement à l’ontologie, les vocabulaires utilisés par la solution logicielle Vitam de type « objet », c’est-à-dire ne contenant pas de valeurs informationnelles, sont référencés dans le schéma. Il peut s’agir de :
    - vocabulaires conformes au SEDA de type « objet », c'est-à-dire correspondant à un élément XML englobant un sous-élément XML (par exemple, Writer ou Management) ;
*Exemple :* sont présents dans le schéma les vocabulaires « Keyword », « Keyword.Keyword Content », « Keyword.KeywordType ».

```xml
<Keyword>
    <KeywordContent>Paris</Content>
    <KeywordType>geogname</Type>
</Keyword>
```

    - vocabulaires générés par la solution logicielle Vitam, correspondant à un élément JSON de type « objet ».
*Exemple :* sont présents dans le schéma les éléments JSON _mgt, _v.

```json
"_mgt": {
        "AccessRule": {
            "Rules": [
                {
                    "Rule": "ACC-00001",
                    "StartDate": "1914-01-01",
                    "EndDate": "1914-01-01"
                }
            ]
        }
    },
    "DescriptionLevel": "Item",
    "Description": "Cabinet de Michel Mercier : correspondances.",
    "CustodialHistory": {
        "CustodialHistoryItem": [
            "Fonds provenant des archives du cabinet du ministre Michel Mercier",
            "
        ]
    },
"_v" : 4
```

En d’autres termes, le schéma référence tous les vocabulaires, qu’il s’agisse de vocabulaires pouvant contenir des valeurs (ou métadonnées, dits vocabulaire de type « feuille ») quand ils sont utilisés ou de vocabulaires ne contenant pas de valeurs (ou objets).

### Pourquoi un schéma ?

Le schéma répond à plusieurs besoins :
-  regrouper toutes les façons de nommer un même objet intellectuel et disposer d’une liste de l’ensemble des vocabulaires gérés nativement par la solution logicielle Vitam et plus spécifiquement dans l’ontologie, précisant :
    - leur dénomination lorsqu’ils sont exposés via l’API externe (ex : #originating_agency),
    - leur dénomination interne au système (_sp),
    - leur dénomination dans un bordereau de transfert conforme au SEDA (OriginatingAgencyIdentifier) ;
-  éviter les conflits en interdisant la définition d’un nouveau vocabulaire avec le même chemin qu’un vocabulaire préexistant ;
-  connaître le type d’indexation des différents vocabulaires proposé par défaut par la solution logicielle Vitam, qu’ils soient de type « feuille » ou de type « objet » ;
-  pour un profil d’unité archivistique, connaître les vocabulaires et leur type, afin de rédiger un profil conforme aux éléments indexés et gérés par la solution logicielle Vitam ;
-  le cas échéant, ajouter des vocabulaires afin d’enrichir la description des unités archivistiques[^3] ;
-  restituer l’ensemble de ces métadonnées dans une interface et les rendre disponibles pour une recherche.

Formalisation des vocabulaires du schéma
----

### Dans un fichier JSON

Un à plusieurs vocabulaire(s) externe(s) peu(ven)t être importé(s) sous la forme d’un fichier JSON.
*Exemple :* trois vocabulaires externes, « Invoice », « Provider » et « BirthDate », contenant les informations nécessaires pour être importés avec succès.
```json
[
{
    "IsObject": true,
    "Cardinality": "MANY",
    "Path": "Invoice"
    "ShortName": "Facture"
  },
  {
    "IsObject": true,
    "Cardinality": "MANY",
    "Path": "Invoice.Provider",
    "ShortName": "Provider"
  },
  {
    "Cardinality": "ONE",
    "Path": "Invoice.Provider.BirthDate",
    "ShortName": "Date de naissance"
  }
]
```

Un vocabulaire de type « feuille » donné
-  doit nécessairement être décrit avec les informations suivantes :
    - un chemin (Path),
    - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
-  peut inclure :
    - un intitulé (ShortName),
    - une description (Description),
    - une déclaration d’objet (IsObject).
Chaque vocabulaire de type « objet » :
-  nécessairement être décrit avec les informations suivantes :
    - un chemin (Path),
    - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
    - une déclaration d’objet (IsObject).
-  peut inclure :
    - un intitulé (ShortName),
    - une description (Description).

### Dans la solution logicielle Vitam

Les vocabulaires du schéma sont enregistrés sous deux formes :
-  dans un fichier interne, dit « schéma interne » regroupant l'ensemble des vocabulaires internes comme externes,
-  pour les seuls vocabulaires externes, dans la base de données MongoDB, dans la collection « Schéma », sous la forme d’enregistrements au format JSON.

#### Dans le schéma interne

Les vocabulaires internes et, le cas échéant, les vocabulaires externes, sont enregistrés dans un fichier interne, sous la forme d’enregistrements au format JSON.

*Exemple :* deux vocabulaires, le premier de type « objet » et le second de type « feuille ».
```json
[
{
      "FieldName": "Addressee",
      "Collection": "Unit",
      "ApiPath": "Addressee",
      "ApiField": "Addressee",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Destinataire",
      "Path": "Addressee",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Addressee.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Addressee.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    }
]
```
Chaque enregistrement est modélisé comme suit :

|**Champ**|**Description**|
|:-----:|:-----:|
|FieldName|**nom** du vocabulaire, fourni par la solution logicielle Vitam (champ obligatoire).|
|SedaField et ApiField|**nom** du vocabulaire (champ facultatif) :<br>-  tel qu’il est défini dans la nomenclature du SEDA (champ facultatif). Ce champ est utilisé uniquement pour les vocabulaires référençant une unité archivistique et un groupe d’objets ;<br>-  tel qu’il est retourné via le DSL (champ facultatif. Exemple : _#sp).<br>Ces champs sont uniquement disponibles pour les vocabulaires internes et sont fournis par la solution logicielle Vitam.|
|Path|**chemin** du vocabulaire, correspondant à l'identifiant du vocabulaire dans la collection Schéma (champ obligatoire).<br>Un vocabulaire unique dans l’ontologie peut avoir plusieurs chemins dans le schéma (Exemple : StartDate, AccessRule.StartDate, StorageRule.StartDate, etc.).|
|ApiPath|**chemin** du vocabulaire :<br>-  tel qu’il est défini dans la nomenclature du SEDA (champ facultatif). Ce champ est utilisé uniquement pour les vocabulaires référençant une unité archivistique et un groupe d’objets ;<br>-  tel qu’il est retourné via le DSL (champ facultatif. Exemple : \#qualifier).<br>Ce champ est uniquement disponible pour les vocabulaires internes et est fournis par la solution logicielle Vitam.|
|ShortName|**traduction** du vocabulaire, explicitant de manière intelligible le nom du vocabulaire (champ obligatoire).<br>Dans le cas des vocabulaires de type « feuille », cette traduction peut être héritée de l'ontologie.|
|Description|**description** (champ facultatif).<br>Dans le cas des vocabulaires de type « feuille », la description peut être héritée de l'ontologie.|
|Collection|**collection(s)** de la base de données MongoDB qui utilise(nt) le vocabulaire en question (champ obligatoire).<br>Les valeurs acceptées sont : Unit, ObjectGroup.<br>La valeur est fournie par la solution logicielle Vitam.|
|Origin|**origine** du vocabulaire, précisant la provenance du vocabulaire (champ obligatoire). Sa valeur peut être égale à :<br>-  INTERNAL : pour les vocabulaires conformes au SEDA et les vocabulaires propres à la solution logicielle Vitam ;<br>-  EXTERNAL : pour les vocabulaires non gérés nativement par les deux précédents items et ajoutés pour répondre à un besoin particulier.<br>La valeur est fournie par la solution logicielle Vitam.|
|Category|**catégorie** du vocabulaire (champ obligatoire).<br>Sa valeur peut être égale à :<br>-  DESCRIPTION : pour les vocabulaires conformes au SEDA et les vocabulaires propres à la solution logicielle Vitam équivalents à des métadonnées descriptives ;<br>-  MANAGEMENT : pour les vocabulaires conformes au SEDA et les vocabulaires propres à la solution logicielle Vitam équivalents à des métadonnées de gestion ;<br>-  OTHER : pour les vocabulaires non gérés nativement par les deux précédents items et ajoutés pour répondre à un besoin particulier et les vocabulaires propres à la solution logicielle Vitam et spécifiques à des usages internes.<br>La valeur est fournie par la solution logicielle Vitam.|
|Cardinality|**cardinalité** du vocabulaire, correspondant à un type attendu par le moteur Elastic Search (champ obligatoire).<br>Les valeurs acceptées sont : ONE, ONE_REQUIRED, MANY ou MANY_REQUIRED.|
|SedaVersions|**version du SEDA** dans laquelle le vocabulaire peut être utilisé (champ facultatif).<br>La valeur est fournie par la solution logicielle Vitam pour les seuls vocabulaires internes.|
|Type|**type d’indexation** du vocabulaire, correspondant à un type attendu par le moteur Elastic Search (champ obligatoire).<br>-  Dans le cas des vocabulaires de type « feuille », le type est hérité de l'ontologie. Les valeurs acceptées sont : DATE, TEXT, KEYWORD, BOOLEAN, LONG, DOUBLE, ENUM[^4].<br>-  Dans le cas des vocabulaires de type « objet », la valeur acceptée est : OBJECT.|
|TypeDetail|**type détaillé d'indexation**, uniquement présent pour les vocabulaires de type « feuille » (champ obligatoire).<br>Les valeurs acceptées sont : STRING, ENUM, DATETIME, BOOLEAN, LONG, DOUBLE.|
|StringSize|**taille** du vocabulaire, disponible uniquement pour les vocabulaires dont le type détaillé a pour valeur "STRING" (champ facultatif).<br>Les valeurs acceptées sont : SHORT, MEDIUM, LONG.|

#### Dans la base de données MongoDB

Les vocabulaires externes sont enregistrés dans la base de données MongoDB, dans la collection « Schema », sous la forme d’enregistrements au format JSON.

**Point d'attention :** Les vocabulaires internes ne sont pas enregistrés dans cette collection.

*Exemple :* deux vocabulaires, l’un de type « objet » et l’autre de type « feuille »/
```json
{
    _id: 'aeaaaaaaaaecx2k6abhpuamq4m36uqiaaaaq',
    Origin: 'EXTERNAL',
    Collection: 'Unit',
    Cardinality: 'MANY',
    Path: 'TNRSchema.Provider',
    ShortName: 'Provider',
    CreationDate: '2024-07-24T05:30:10.874',
    LastUpdate: '2024-07-24T05:30:10.874',
    IsObject: true,
    _v: 0,
    _tenant: 0
   }
	
   {
    _id: 'aeaaaaaaaaecx2k6abhpuamq4m36uqqaaaaq',
    Origin: 'EXTERNAL',
    Collection: 'Unit',
    Cardinality: 'ONE',
    Path: 'TNRSchema.Provider.BirthDate',
    ShortName: 'Date de naissance du provider',
    CreationDate: '2024-07-24T05:30:10.874',
    LastUpdate: '2024-07-24T05:30:10.874',
    IsObject: false,
    _v: 0,
    _tenant: 0
}
```

Chaque enregistrement est modélisé comme suit :

|**Champ**|**Description**|
|:----:|:----:|
|_id|identifiant unique, fourni par le système (champ obligatoire).|
|Path|**chemin** du vocabulaire, correspondant à l'identifiant du vocabulaire dans la collection Schéma (champ obligatoire).<br>Pour les vocabulaires de type « feuille », un vocabulaire unique dans l’ontologie peut avoir plusieurs chemins dans le schéma (Exemple : StartDate, AccessRule.StartDate, StorageRule.StartDate, etc.).|
|ShortName|**traduction** du vocabulaire, explicitant de manière intelligible le nom du vocabulaire (champ obligatoire).<br>Dans le cas des vocabulaires de type « feuille », cette traduction peut être héritée de l'ontologie.|
|Collection|**collection(s)** de la base de données MongoDB qui utilise(nt) le vocabulaire en question (champ obligatoire).<br>La valeur, fournie par la solution logicielle Vitam, est égale à Unit.|
|Origin|**origine** du vocabulaire, précisant la provenance du vocabulaire (champ obligatoire). Sa valeur, fournie par la solution logicielle Vitam, est égale à EXTERNAL.|
|Cardinality|**cardinalité** du vocabulaire, correspondant à un type attendu par le moteur Elastic Search (champ obligatoire).<br>Les valeurs acceptées sont : ONE, ONE_REQUIRED, MANY ou MANY_REQUIRED.|
|IsObject|Type de vocabulaire (champ obligatoire).<br>-  Si la valeur est égale à true, le vocabulaire est un objet.<br>-  Si la valeur est égale à false, le vocabulaire n’est pas un objet, mais un vocabulaire de type « feuille ».|
|CreationDate|date de création du vocabulaire, fournie par le système (champ obligatoire).|
|LastUpdate|dernière date de modification du vocabulaire, fournie et mise à jour par le système (champ obligatoire).|
|_tenant|tenant dans lequel le vocabulaire s’applique, fourni par le système (champ obligatoire).<br>S’il s’agit du tenant d’administration, le vocabulaire sera disponible pour tous les tenants.|
|_v|version du vocabulaire, fournie par le système (champ obligatoire).|

### Dans le Standard d’échange de données pour l’archivage (SEDA)

Le schéma reprend des éléments définis dans la norme NF Z 44‑022 et dans sa déclinaison pour les acteurs du service public, le Standard d’échanges de données pour l’archivage (SEDA).  
Un bordereau de transfert utilise de fait les vocabulaires définis dans l’ontologie de la solution logicielle Vitam.

La norme NF Z 44‑022 offre la possibilité d’ajouter des éléments supplémentaires, appelés « extensions » :
-  Des extensions dont la définition est obligatoire pour que le schéma soit valide (extensions par substitution, de type abstract). Sont concernés :

|Bloc concerné|Elément XML|Signification / usage|
|:---:|:---:|:----:|
|Métadonnées techniques|<OtherDimensionsAbstract>|Autres dimensions possibles pour un objet physique|
||<OtherCoreTechnicalMetadataAbstract>|Métadonnées techniques essentielles ne correspondant :<br>• ni à des fichiers de type texte,<br>• ni à des fichiers de type document,<br>• ni à des fichiers de type image,<br>• ni à des fichiers de type audio,<br>• ni à des fichiers de type vidéo <br>Ex. : bases de données, plans 2D, plans 3D|
|Métadonnées descriptives|<ObjectGroupExtensionAbstract>|Métadonnées descriptives complémentaires|
||<ArchiveUnitReferenceAbstract>|Requêtes permettant de gérer la récursivité et de pointer vers un objet-archives supposé être déjà géré par le SAE|
|Métadonnées de gestion|<OtherManagementAbstract>|Autres métadonnées de gestion|

-  Des extensions dont la définition n’est pas obligatoire pour que le schéma soit valide (extensions par redéfinition, de type OpenType). Leur type peut être défini selon les besoins des utilisateurs qui peuvent y mettre ce qu’ils veulent. Aucune vérification sur ces extensions ne pourra être faite lors des transactions tant que le type de ces extensions n’est pas défini. Sont concernés :

|Bloc concerné|Elément XML|Signification / usage|
|:---:|:---:|:----:|
|Noyau du schéma (main)|<OrganizationDescriptiveMetadataType>|Métadonnées descriptives pour une organisation|
||<SignatureType>|Signature utilisée lors des échanges de messages|
|Métadonnées techniques|<XXXTechnicalMetadataType>|Métadonnées techniques essentielles correspondant à des fichiers de types texte, document, image, audio et vidéo|
||<DescriptiveTechnicalMetadataType>|Autres métadonnées techniques|

Ces extensions doivent être qualifiées d’origine « EXTERNAL » dans l’ontologie.

Mécanismes mis en œuvre dans la solution logicielle Vitam
------

La solution logicielle Vitam offre à un service d’archives ou à un service externe plusieurs fonctionnalités lui permettant de mettre en œuvre un schéma de données :
-  en termes d’administration :
    - gestion d’un référentiel appelé « Schéma » ;
    - une vérification que le schéma déclare des vocabulaires conformément à leur référencement dans l'ontologie ;
-  en accès, une traduction et une indexation propre à chaque vocabulaire, induisant des règles à suivre en recherche et lors de la mise à jour des unités archivistiques.

### Administration du schéma

La solution logicielle Vitam intègre un schéma interne, administrable par un utilisateur doté des droits adéquats (administrateur fonctionnel et administrateur technique) et gérée dans une collection particulière pour les seuls vocabulaires externes[^5].  
Ce référentiel interne à la solution logicielle Vitam a pour vocation d’être une copie locale d’un référentiel administré dans le front office des plates-formes d’archivage implémentant cette dernière.  
Le schéma interne est multi-tenant et peut avoir une gestion par tenant pour les vocabulaires externes. De fait, il est administrable et journalisée depuis le tenant d’administration et peut l’être par tenant pour les vocabulaires externes.  
Il est possible de réaliser les opérations présentées ci-dessous.

#### Import du schéma

La solution logicielle Vitam intègre un schéma, automatiquement importé lors de l’initialisation de la plate-forme sur le tenant d’administration, et comportant les vocabulaires internes à la solution.  
Ce schéma est multi-tenant. Il est administrable et journalisé depuis le tenant d’administration.

#### Ajout d’un vocabulaire externe

Il est possible d’ajouter des vocabulaires externes sous la forme d’enregistrements JSON depuis le tenant d’administration ou un tenant en particulier.  
L’ajout d’un vocabulaire externe est possible au moyen des API pour la collection « Unit ».

Point d’attention : Au terme de la version 8.0, il n’est pas possible d’ajouter :
-  un vocabulaire externe dans le schéma depuis les interfaces de VitamUI ;
-  un vocabulaire externe pour la collection « ObjectGroup ».

Chaque vocabulaire de type « feuille » :
-  doit définir :
    - un chemin (Path),
    - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
-  peut inclure :
    - un intitulé (ShortName),
    - une description (Description),
    - une déclaration d’objet (IsObject).

Chaque vocabulaire de type « objet » :
-  doit définir :
    - un chemin (Path),
    - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
    - une déclaration d’objet (IsObject).
-  peut inclure :
    - un intitulé (ShortName),
    - une description (Description).

*Exemple :* Création d’un objet et d’un vocabulaire de type « feuille ».
```json
POST {{url}}/admin-external/v1/schema/unit
Accept: application/json
Content-Type: application/json
X-Tenant-Id: {{tenant}} 

[
  {
    "Path": "MyObject",
    "Cardinality": "ONE",
    "IsObject": true
  },
 {
    "Path": "MyObject.MyText",
    "Cardinality": "MANY",
    "IsObject": false
  }
]
```

Cette action provoque :
-  la création d’un enregistrement dans la base de données MongoDB, dans la collection « Schema » (base « Masterdata »).
      À cet enregistrement, pour les vocabulaires de type « feuille », sont associées :
    - les informations obligatoirement envoyées dans la solution logicielle Vitam :
        - un chemin (Path),
        - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
    - les informations optionnelles si elles n’ont pas été envoyées dans la solution logicielle Vitam :
        - définies par la solution logicielle Vitam : une déclaration d’objet (IsObject) dont la valeur est égale à « false »,
        - héritées de l’ontologie :
            - un intitulé (ShortName),
            - une description (Description),
    - des informations générées systématiquement par la solution logicielle Vitam :
        - un identifiant technique (champ « _id »),
        - une origine dont la valeur est égale à « EXTERNAL »,
        - une date de création (champ « CreationDate ») dont la valeur est égale à la date de création de l’enregistrement,
        - une date de dernière modification (champ « LastUpdate ») dont la valeur est égale à la date de création de l’enregistrement ;
        - une collection dont la valeur est égale à « Unit »,
        - la version de l’enregistrement (« _v »),
        - le tenant dans lequel a été créé le vocabulaire (« _tenant »).
      À cet enregistrement,  pour les vocabulaires de type « objet », sont associées :
    - les informations obligatoirement envoyées dans la solution logicielle Vitam :
        - un chemin (Path),
        - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
        - une déclaration d’objet (IsObject) dont la valeur est égale à « true »,
    - des informations générées systématiquement par la solution logicielle Vitam :
        - un identifiant technique (champ « _id »),
        - une origine dont la valeur est égale à « EXTERNAL »,
        - une date de création (champ « CreationDate ») dont la valeur est égale à la date de création de l’enregistrement,
        - une date de dernière modification (champ « LastUpdate ») dont la valeur est égale à la date de création de l’enregistrement ;
        - une collection dont la valeur est égale à « Unit »,
        - la version de l’enregistrement (« _v »),
        - le tenant dans lequel a été créé le vocabulaire (« _tenant ») ;

*Exemple :* Enregistrement d’un vocabulaire de type « feuille » dans la collection « Unit » (base « Masterdata »).
```json
{
    _id: 'aeaaaaaaaagtfhyvadjsqamrbc6fvsiaaaaq',
    Origin: 'EXTERNAL',
    Collection: 'Unit',
    Cardinality: 'MANY',
    Path: 'Liquidation.Facture,
    ShortName: 'Facture',
    CreationDate: '2024-07-31T12:20:47.432',
    LastUpdate: '2024-07-31T12:20:47.432',
    IsObject: false,
    _v: 0,
    _tenant: 1
}
``` 
-  la création d’un enregistrement dans le schéma interne de la solution logicielle Vitam.
      À cet enregistrement,  pour les vocabulaires de type « feuille », sont associées :
    - les informations obligatoirement envoyées dans la solution logicielle Vitam :
        - un chemin (Path),
        - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
    - les informations optionnelles si elles n’ont pas été envoyées dans la solution logicielle Vitam, héritées de l’ontologie :
        - un intitulé (ShortName),
        - une description (Description),
        - le type d’indexation (Type) dont les valeurs peuvent être égales à « DATE », « TEXT », « KEYWORD », « BOOLEAN », « LONG », « DOUBLE », « ENUM »[^6] ;
    - des informations générées systématiquement par la solution logicielle Vitam :
        - un nom de vocabulaire (« FieldName »),
        - une origine dont la valeur est égale à « EXTERNAL »,
        - une catégorie dont la valeur est égale à « OTHER »,
        - une collection dont la valeur est égale à « Unit » ou « ObjectGroup »,
        - le tenant dans lequel a été créé le vocabulaire (« _tenant »),
        - le type détaillé d'indexation dont les valeurs peuvent être égales à « STRING », « ENUM », « DATETIME », « BOOLEAN », « LONG », « DOUBLE »,
        - la taille du vocabulaire (« TypeSize ») , disponible uniquement pour les vocabulaires dont le type détaillé a pour valeur « STRING ». Les valeurs acceptées sont : « SHORT », « MEDIUM », « LONG ».
      À cet enregistrement,  pour les vocabulaires de type « objet », sont associées :
    - les informations obligatoirement envoyées dans la solution logicielle Vitam :
        - un chemin (Path),
        - une cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
        - le type d’indexation (Type) dont la valeur est égale à « OBJECT »,
    - des informations générées systématiquement par la solution logicielle Vitam :
        - un nom de vocabulaire (« FieldName »),
        - une origine dont la valeur est égale à « EXTERNAL »,
        - une catégorie dont la valeur est égale à « OTHER »,
        - une collection dont la valeur est égale à « Unit » ou « ObjectGroup »,
        - le tenant dans lequel a été créé le vocabulaire (« _tenant ») .

*Exemple :* Enregistrement d’un vocabulaire de type « feuille » dans le schéma interne.
```json
{
      "FieldName": "MyText",
      "tenant": 1,
      "Collection": "Unit",
      "Category": "OTHER",
      "Description": "Extension au SEDA. Elément de type texte",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "EXTERNAL",
      "Path": "MyText",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    }
```

Il s’agit d’une opération d’administration (« MASTERDATA »), tracée dans le journal des opérations de la solution logicielle Vitam[^7].
Les différentes versions du référentiel font l’objet d’une sauvegarde sur les offres de stockage utilisées par la solution logicielle Vitam.
Lors de cette opération, l’opération peut aboutir aux statuts suivants :

|Statut|Motifs|
|:---:|:---:|
|Succès|Opération réalisée sans rencontrer de problèmes particuliers.|
|Échec|Sans journalisation :<br>– la valeur de la cardinalité est incorrecte.|
||Avec journalisation :<br>– ajout d’un vocabulaire déjà présent dans le schéma ;<br>- ajout d’un vocabulaire de type « feuille » qui n’existe pas dans l’ontologie ;<br>- ajout d’un vocabulaire de type « feuille », associé à un vocabulaire de type « objet » qui n’a pas été préalablement créé dans le schéma ;<br>– ajout d’un vocabulaire dont le type d’indexation est « GEO_POINT » ;<br>- ajout d’un vocabulaire sans avoir défini un chemin (« Path ») ou une cardinalité  (« Cardinality »).<br>– ajout d’un vocabulaire dont l’identifiant ne correspond pas aux règles imposées par la solution logicielle Vitam[^8].|

#### Suppression d’un vocabulaire externe

Il est possible de supprimer des vocabulaires externes depuis le tenant d’administration ou un tenant en particulier.
La suppression d’un vocabulaire externe est possible au moyen des API pour la collection « Unit ».

Point d’attention : Au terme de la version 8.0, il n’est pas possible de :
-  supprimer un vocabulaire externe dans le schéma depuis les interfaces de VitamUI ;
-  supprimer un vocabulaire externe pour la collection « ObjectGroup ».

*Exemple :* Suppression d’un vocabulaire externe « MyText ».
```json
DELETE {{url}}/admin-external/v1/schema/unit
Accept: application/json
Content-Type: application/json
X-Tenant-Id: {{tenant}}

[
  "MyText"
]
```

**Point d’attention :** L’action aboutit à une erreur si :
-  on tente de supprimer un vocabulaire interne ;
-  on supprime un vocabulaire utilisé dans un autre enregistrement (ex. suppression du  chemin « Provider », alors que le chemin « Provider.BirthDate » existe) ou dans un autre tenant ;
-  on supprime un chemin qui n’existe pas.

#### Contrôle du schéma sur l’ontologie

Lors de la suppression d'un vocabulaire externe dans l'ontologie, la solution logicielle Vitam vérifie que le vocabulaire n'est pas utilisé dans le schéma.

L’import ou la mise à jour de l'ontologie peut échouer si le vocabulaire est utilisé dans le schéma.

### Accès

#### Affichage des vocabulaires du schéma

La solution logicielle Vitam permet d’accéder à :
-  la liste des vocabulaires internes et, le cas échéant, externes de la collection « Unit »,
-  la liste des vocabulaires internes de la collection « ObjectGroup ».

*Exemple :* Requête en vue de rechercher les vocabulaires de la collection « Unit ».

```json
GET {{url}}/admin-external/v1/schema/unit 
Accept: application/json 
Content-Type: application/json 
X-Tenant-Id: 2
X-Access-Contract-Id: {{access-contract}}
```

*Exemple :* Requête en vue de rechercher les vocabulaires de la collection « ObjectGroup ».

```json
GET {{url}}/admin-external/v1/schema/object
Accept: application/json 
Content-Type: application/json 
X-Tenant-Id: 2
X-Access-Contract-Id: {{access-contract}}
```

**Point d’attention :** En résultats, la solution logicielle renvoie systématiquement l’ensemble des vocabulaires du schéma. Au terme de la version 8.0, il n’est pas possible de récupérer une sélection de métadonnées.

#### Affichage dynamique des traductions

Le schéma contenant la traduction des différents vocabulaires supportés par la solution logicielle Vitam, il est possible, en accès :
-  d’utiliser ce référentiel comme un fichier de propriétés pour récupérer les traductions, plutôt que ce soit l’IHM qui porte ces informations. Ainsi, cela évitera de constater des absences de traduction des vocabulaires externes récemment créés ;
-  d’utiliser et d’afficher la traduction des vocabulaires dans les IHM, rendue administrable dans ce référentiel, afin qu’un administrateur fonctionnel ait la possibilité de modifier les intitulés (ou traductions) de certains vocabulaires (par exemple, modifier « Description », traduction textuelle du bloc Description du SEDA, par « Présentation du contenu », terme issu de la norme ISAD/G, davantage usité par les archivistes) ;
-  d’afficher la traduction des vocabulaires externes.

À titre d’exemple, au terme de la version 8.0, l’APP VitamUI « Recherche et consultation des archives » fournie avec la solution logicielle Vitam dispose de vocabulaires affichés dynamiquement :
-  depuis la recherche sur l’ensemble des métadonnées, internes comme externes,
-  depuis le détail des métadonnées descriptives d’une unité archivistique.


*Exemple 1 :* Recherche dite « Autres critères » accessible depuis l’APP « Recherche et consultation des archives »

![](./medias/schema/APP_recherche_1.png)

*Exemple 2 :* Edition dynamique de métadonnées descriptives pour modification d’une unité archivistique

![](./medias/schema/APP_recherche_2.png)

#### Personnalisation des masques de saisie

La solution logicielle Vitam permet d’accéder à la liste des métadonnées requises par un profil d’unité archivistique, qu’il s’agisse de vocabulaires internes ou, le cas échéant, de vocabulaires externes de la collection « Unit ».

*Exemple :* Requête en vue de rechercher les vocabulaires utilisés par le profil d’unité archivistique dont l’identifiant est  « AUP-00001 » :
```json
GET {{url}}/admin-external/v1/archiveunitprofiles/AUP-00001/schema
Accept: application/json
Content-Type: application/json
X-Tenant-Id: {{tenant}}
X-Access-Contract-Id: {{access-contract}}
```
La solution logicielle Vitam renvoie alors :
-  les vocabulaires internes et/ou externes non utilisés par le profil d’unité archivistique, en signalant qu’ils ne sont pas utilisés par ce dernier en exprimant une cardinalité ayant « ZERO » pour valeur (EffectiveCardinality - obligatoire) ;
-  les vocabulaires internes et /ou externes utilisés par le profil d’unité archivistique, avec les informations suivantes :
    - la cardinalité exprimée dans le profil d’unité archivisique, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (EffectiveCardinality - obligatoire),
    - les contrôles exprimés pour la métadonnée en question (Control – obligatoire, mais pouvant être vide) :
        - le type de contrôle dont la valeur peut être égale à :
            - « REGEX » pour une expression régulière ou une format de date contrôlé,
            - « SELECT » pour une à plusieurs valeurs contrôlées ;
        - pour un contrôle de type « REGEX », l’expression en elle-même (Value),
        - pour un contrôle de type « SELECT », les différentes valeurs contrôlées (Values) ;
    - un commentaire (Comment – facultatif).

*Exemple :* Résultats possibles suite à une requête en vue de rechercher les vocabulaires utilisés par le profil d’unité archivistique dont l’identifiant est  « AUP-00001 » :

```json
[...]
{ "FieldName": "SystemId", 
"SedaField": "SystemId", 
"Collection": "Unit", 
"ApiPath": "SystemId", 
"Category": "DESCRIPTION", 
"Description": "Mapping : unit-es-mapping.json. Identifiant attribué aux objets. Il est attribué par le SAE et correspond à un identifiant interne.", 
"Cardinality": "MANY", 
"Type": "KEYWORD", 
"Origin": "INTERNAL", 
"ShortName": "Identifiant technique du système", 
"Path": "SystemId", 
"SedaVersions": [ "2.1", "2.2", "2.3" ], 
"StringSize": "SHORT", 
"Control": { 
   "Type": "REGEX", 
   "Value": "^[0-9]{4}$", 
   "Comment": "systemid 1-N" }, 
"EffectiveCardinality": "MANY_REQUIRED" } 
[...]
{ 
"FieldName": "FilePlanPosition", 
"SedaField": "FilePlanPosition", 
"Collection": "Unit", 
"ApiPath": "FilePlanPosition", 
"Category": "DESCRIPTION", 
"Description": "Mapping : unit-es-mapping.json", 
"Cardinality": "MANY", 
"Type": "KEYWORD", 
"Origin": "INTERNAL", 
"ShortName": "Position dans le plan de classement", 
"Path": "FilePlanPosition", 
"SedaVersions": [ "2.1", "2.2", "2.3" ], 
"StringSize": "SHORT", 
"Control": { 
   "Type": "SELECT", 
   "Values": [ "REP.1.1", "REP.1.2" ], 
   "Comment": "fileplanposition 0-N" }, 
"EffectiveCardinality": "MANY" } 
```

**Point d’attention :** En résultats, la solution logicielle renvoie systématiquement l’ensemble des vocabulaires du schéma. A charge du front-office de filtrer les vocabulaires utilisés dans le profil d’unité archivistique en utilisant le schéma.

Il est possible, en accès :
-  d’utiliser ce filtre sur les profils d’unité archivistique comme un fichier de propriétés pour récupérer les traductions, mais aussi les restrictions et informations spécifiquement déclarées dans les profils d’unité archivistiques, plutôt que ce soit l’IHM qui porte ces informations ;
-  d’utiliser et d’afficher la traduction des vocabulaires et les contraintes définies dans un profil d’unité archivistique dans les IHM.
À titre d’exemple, au terme de la version 8.0, l’APP VitamUI « Recherche et consultation des archives » fournie avec la solution logicielle Vitam dispose d’un affichage dynamique filtré sur un profil d’unité archivistique depuis le détail des métadonnées descriptives d’une unité archivistique déclarant un profil d’unité archivistique en mode édition.

Conseils de mise en œuvre
----

À l’issue de cette première phase de réalisation de fonctionnalités concernant le schéma, l’équipe projet Vitam est en mesure de fournir quelques recommandations de mise en œuvre :

### Quand et comment créer un schéma ?

La création d’un schéma interne est un préalable à l’utilisation des vocabulaires dans la solution logicielle Vitam. C’est pourquoi, lors de l’installation de la solution logicielle Vitam, un schéma interne est initialisé par défaut. Il contient l’ensemble des vocabulaires supportés par la solution logicielle Vitam, c’est-à-dire des vocabulaires internes.  
Un administrateur fonctionnel n’a pas besoin de créer de schéma interne. Il s’agit d’un acte d’exploitation technique.

### Quand et comment créer un vocabulaire dans le schéma ?

La création unitaire d’un nouveau vocabulaire dans le schéma s’effectue au moyen des API.

Cette opération s’effectue :
-  sur le tenant d’administration si l’on souhaite que le vocabulaire soit disponible sur tous les tenants,
-  sur un tenant en particulier si l’on souhaite que le vocabulaire soit disponible uniquement un tenant et pas sur les autres tenants de la plate-forme.

Elle obéit à des règles strictes :
-  pour un vocabulaire de type « feuille »,
    - un nouveau vocabulaire doit détenir un chemin :
        - unique,
        - dont les vocabulaires de type « objet », s’ils existent dans le chemin, doivent avoir été créés préalablement dans le schéma (ex. « BulletinDePaie » doit préalablement exister dans le cas d’un chemin « BulletinDePaie.FullName »),
        - dont le vocabulaire de type « feuille » doit avoir été préalablement créé dans l’ontologie ;
    - un nouveau vocabulaire doit définir une cardinalité. Les cardinalités sont :
        - « ONE » pour les vocabulaires qui ont vocation à être facultatifs et non répétables,
        - « ONE_REQUIRED » pour les vocabulaires qui ont vocation à être obligatoires et non répétables,
        - « MANY » pour les vocabulaires qui ont vocation à être facultatifs et répétables,
        - « MANY_REQUIRED » pour les vocabulaires qui ont vocation à être obligatoires et répétables.
-  pour un vocabulaire de type « objet »,
    - un nouveau vocabulaire doit détenir un chemin :
        - unique,
        - dont les vocabulaires de type « objet », s’ils existent dans le chemin, doivent avoir été créés préalablement dans le schéma (ex. « BulletinDePaie » doit préalablement exister dans le cas d’un chemin « BulletinDePaie.Facture.FullName »),
        - ne devant pas être lui-même déclaré dans l’ontologie ;
        - ne commençant pas par un underscore (par exemple _bibref) ou un dièse (#bibref), qui sont des caractères réservés par la solution logicielle Vitam,
        - ne contenant pas d’espace,
        - étant insensible à la casse (il ne peut y avoir un nouveau vocabulaire intitulé « identifier » si un vocabulaire intitulé « Identifier » existe déjà dans l’ontologie) ;
    - un nouveau vocabulaire doit définir une cardinalité. Les cardinalités sont :
        - « ONE » pour les vocabulaires qui ont vocation à être facultatifs et non répétables,
        - « ONE_REQUIRED » pour les vocabulaires qui ont vocation à être obligatoires et non répétables,
        - « MANY » pour les vocabulaires qui ont vocation à être facultatifs et répétables,
        - « MANY_REQUIRED » pour les vocabulaires qui ont vocation à être obligatoires et répétables ;
    - un nouveau vocabulaire doit être défini comme un objet.

**Points d’attention :** 
-  Seule la collection Unit peut faire l’objet d’ajout de nouveaux vocabulaires dans le schéma. Il n’est pas possible d’étendre les autres collections ;
-  Il n’est pas possible de modifier le schéma depuis les interfaces de VitamUI.
La création d’un nouveau vocabulaire n’est pas un acte anodin. Avant de procéder à sa création, il est recommandé de prendre en considération les éléments suivants :
-  est-ce qu’un vocabulaire existant peut couvrir le même champ sémantique et signifiant que le vocabulaire que l’on souhaite ajouter dans l’ontologie et/ou le schéma ?
-  peut-on envisager une utilisation possible de ce nouveau vocabulaire pour un autre domaine d’utilisation ?
      Par exemple, on souhaite utiliser un vocabulaire permettant de gérer un titre de recette.
    - veut-on créer un vocabulaire « SommeTitreDeRecette » qui ne sera utilisable que dans un contexte particulier de recette ?
    - ou veut-on créer un vocabulaire qui sera plus générique, afin de l’utiliser dans un contexte plus large ? Dans ce cas précis, on pourrait choisir d’intituler le vocabulaire « Somme », afin de l’utiliser pour des titres de recette, mais aussi pour qualifier une dépense, le coût de frais de déplacement, une somme à payer indiquée dans les bulletins de salaire, etc.
-  a-t-on besoin d’ajouter ce nouveau vocabulaire ? Pour quels usages ?
-  a-t-on besoin d’afficher et de rechercher ce vocabulaire dans les interfaces ?

Pour créer un nouveau vocabulaire, il est recommandé de suivre les étapes suivantes :

|Qui ?|Quoi ?|Via VitamUI ?|
|:---:|:---:|:---:|
|Administrateur fonctionnel|émet le souhait d’ajouter un nouveau vocabulaire, externe, dans l’ontologie et dans le schéma|Non|
|Administrateur fonctionnel|vérifie au préalable si ce nouveau vocabulaire n’existe pas ou si un vocabulaire préexistant ne correspond pas à son besoin.|Oui|
|Administrateur fonctionnel et/ou technique|met à jour l’ontologie sur le tenant d’administration.|Oui|
|Administrateur fonctionnel et/ou technique|met à jour le schéma sur le tenant d’administration ou sur un tenant spécifique|Non|
|Administrateur technique|indexe le nouveau vocabulaire dans le moteur de recherche Elastic Search.|Non|

### Quand et comment modifier un vocabulaire ?

en version 8.0, la mise à jour d’un vocabulaire utilisé dans le schéma passe par sa suppression, puis son réimport en utilisant les API mises à disposition par la solution logicielle Vitam.
Il est ainsi possible de mettre à jour les informations suivantes :
-  le chemin (Path),
-  la cardinalité, dont la valeur doit être égale à « ONE », « ONE_REQUIRED », « MANY » ou « MANY_REQUIRED » (Cardinality),
-  les informations optionnelles si elles n’ont pas été envoyées dans la solution logicielle Vitam, héritées de l’ontologie :
    - un intitulé (ShortName),
    - une description (Description).

**Point d’attention :** 
-  La modification n’est pas un acte anodin. Elle peut entraîner des incohérences si elle n’est pas mûrement réfléchie, ainsi qu’un possible changement des interfaces pour l’utilisateur ;
-  le vocabulaire devant être modifié doit obligatoirement être un vocabulaire d’origine externe, à moins de correspondre à un vocabulaire supprimé à l’occasion d’une mise à jour du modèle de données géré par la solution logicielle Vitam ou la publication d’une nouvelle version du SEDA ;
-  Il n’est pas possible de modifier le schéma depuis les interfaces de VitamUI ;
-  Il n’est pas possible de modifier le type d’indexation, le type détaillé d’indexation ou la taille du vocabulaire depuis le schéma. Il faut le faire en mettant à jour l’ontologie.

### Quand et comment supprimer un vocabulaire ?

La suppression d’un vocabulaire s’effectue uniquement depuis les API.

Cet acte n’est pas anodin. Avant de procéder à cette suppression, il est recommandé de vérifier les éléments suivants :
-  le vocabulaire devant être supprimé doit obligatoirement être un vocabulaire d’origine externe, à moins de correspondre à un vocabulaire supprimé à l’occasion d’une mise à jour du modèle de données géré par la solution logicielle Vitam ou la publication d’une nouvelle version du SEDA ;
-  le vocabulaire ne doit pas être utilisé par un autre vocabulaire dans le schéma s’il s’agit d’un élément de type « objet ».
Point d’attention : 
-  La suppression n’est pas un acte anodin. Elle peut entraîner des incohérences si elle n’est pas mûrement réfléchie, ainsi qu’un possible changement des interfaces pour l’utilisateur ;
-  Il n’est pas possible de supprimer un vocabulaire du schéma depuis les interfaces de VitamUI.

### Quel accès au schéma  ?

#### Gestion des droits

La gestion de l’ontologie relève d’opérations d’administration technico-fonctionnelle. Il est donc recommandé d’en limiter l’accès de la manière suivante :
-  des administrateurs fonctionnel et technique peuvent avoir accès à l’ontologie et la mettre à jour (Create, Read, Delete) ;
-  un tiers n’a pas vocation à prendre connaissance de l’ensemble du schéma, mais peut avoir accès aux vocabulaires utilisés lors d’un transfert et avec des profils d’unité archivistique, à savoir les vocabulaires internes issus du SEDA et les vocabulaires externes créés pour des besoins de transfert particuliers (Read).

#### Restitution sur une IHM

[en construction]

### Comment utiliser le schéma   ?

#### Administration du schéma

|Intitulé|Description|Niveau de recommandation|
|:---:|:----:|:---:|
|Import initial du schéma interne|Il est obligatoire d’importer le schéma interne lors de l’installation de la solution logicielle Vitam.
Ce schéma, fourni avec la solution logicielle Vitam, inclut par défaut l’ensemble des vocabulaires internes gérés par la solution.|Obligatoire|
|Ajout d’un vocabulaire externe|La solution logicielle Vitam rend possible l’ajout unitaire d’un vocabulaire externe au moyen des API.<br>Il peut s’agir d’un acte d’administration fonctionnelle.<br>Il faut veiller à ce que le vocabulaire soit présent dans l’ontologie et les mappings du moteur de recherche Elastic Search s’il s’agit d’un vocabulaire de type « feuille ».|Recommandé|
|Ajout d’un vocabulaire externe – choix du tenant|Il est possible d’ajouter un vocabulaire externe au moyen des API sur :<br>-  le tenant d’administration, si l’on souhaite que le vocabulaire soit utilisé sur tous les tenants ;<br>-  un tenant spécifique, si le vocabulaire est propre à un usage en particulier (ex. tenant dédié à l’archivage intermédiaire) ou un usager en particulier (ex. cas des plates-formes mutualisées).|Obligatoire|
|Ajout d’un vocabulaire interne pour évolution du modèle de données ou évolution du SEDA|La solution logicielle Vitam rend possible l’ajout d’un vocabulaire interne au moyen d’un acte d’exploitation, qui permet en outre de ne pas mettre à jour les vocabulaires externes du référentiel.<br>Cette opération ne peut avoir lieu qu’à deux occasions :<br>-  évolution du modèle de données de la solution logicielle Vitam,<br>-  publication d’une nouvelle version du SEDA.<br>Elle est alors initiée et réalisée par un administrateur technique, car elle nécessite en plus un acte d’exploitation technique sur le moteur de recherche Elastic Search (réindexation).<br>En dehors de ces deux cas, il n’est pas recommandé d’ajouter un vocabulaire interne.|Non recommandé|
|Modification de l’identifiant des vocabulaires internes|La solution logicielle Vitam ne permet pas de modifier les vocabulaires internes du schéma.|Interdit|
|Modification du type d’indexation des vocabulaires externes par un administrateur fonctionnel|La modification du type d’indexation des vocabulaires externes n’est pas possible depuis le schéma.|Impossible|
|Modification des vocabulaires externes par un administrateur fonctionnel|La modification du type d’indexation des vocabulaires externes est possible au moyen d’une suppression, puis d’un réimport du vocabulaire.|Possible|
|Suppression d’un vocabulaire externe|Si un vocabulaire externe n’est pas utilisé dans l’ontologie, dans un autre tenant ou par un autre vocabulaire dans le schéma, il est possible de le supprimer du schéma.|Possible|
|Suppression d’un vocabulaire interne par un administrateur fonctionnel|Il est interdit de supprimer un vocabulaire interne.|Interdit / Impossible|

### Accès

|Intitulé|Description|Niveau de recommandation|
|:---:|:----:|:---:|
|Utilisation du schéma pour afficher les vocabulaires internes et externes dans l’IHM|Dans les différentes IHM, il est recommandé de récupérer au moyen d’une requête la traduction des vocabulaires du schéma, plutôt que d’afficher des intitulés en dur, afin de faciliter leur modification par un administrateur fonctionnel.|Recommandé|
|Accès au schéma par un administrateur fonctionnel|Un administrateur fonctionnel peut avoir accès au schéma et détenir des droits d’ajout et de modification de vocabulaires.|Recommandé|
|Accès au schéma par un administrateur technique|Un administrateur technique doit avoir accès au schéma et détenir des droits d’ajout et de modification de vocabulaire. Il a également la possibilité de supprimer des vocabulaires, externes.<br>Il est recommandé de réaliser cette action de concert avec l’administrateur fonctionnel.|Obligatoire|
|Accès au schéma par un tiers|Il est recommandé, pour des tiers, de restreindre leur accès aux seuls vocabulaires utilisés lors d’un transfert et avec des profils d’unité archivistique, à savoir les vocabulaires internes issus du SEDA et les vocabulaires externes créés pour des besoins de transfert particuliers.|Recommandé|


Annexe 1 : Vocabulaires internes du schéma interne
-----

### Liste des vocabulaires internes de la collection « Unit » présents dans le schéma interne.
Nota bene : cette liste n’est pas forcément exhaustive.

```json
{
      "FieldName": "AcquiredDate",
      "SedaField": "AcquiredDate",
      "Collection": "Unit",
      "ApiPath": "AcquiredDate",
      "ApiField": "AcquiredDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Références : ARKMS.DateAcquired",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de numérisation",
      "Path": "AcquiredDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Addressee",
      "Collection": "Unit",
      "ApiPath": "Addressee",
      "ApiField": "Addressee",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Destinataire",
      "Path": "Addressee",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Addressee.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Addressee.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Addressee.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Addressee.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Addressee.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Addressee.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Addressee.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Addressee.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Addressee.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Addressee.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Addressee.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Addressee.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Addressee.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Addressee.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Addressee.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Addressee.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Addressee.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Addressee.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Addressee.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Addressee.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Addressee.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Addressee.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Addressee.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Addressee.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Addressee.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Addressee.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Addressee.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Addressee.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Addressee.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Addressee.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Addressee.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Addressee.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Addressee.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Addressee.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Addressee.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Addressee.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Addressee.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Addressee.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Addressee.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Addressee.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Addressee.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Addressee.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Addressee.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Agent",
      "Collection": "Unit",
      "ApiPath": "Agent",
      "ApiField": "Agent",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Agent",
      "Path": "Agent",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Agent.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Agent.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Agent.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Agent.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Agent.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Agent.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Agent.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Agent.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Agent.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Agent.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Agent.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Agent.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Agent.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Agent.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Agent.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Agent.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Agent.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Agent.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Agent.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Agent.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Agent.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Agent.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Agent.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Agent.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Agent.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Agent.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Agent.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Agent.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Agent.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Agent.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Agent.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Agent.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Agent.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Agent.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Agent.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Agent.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Agent.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Agent.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Agent.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Agent.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Agent.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Agent.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Agent.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ArchivalAgencyArchiveUnitIdentifier",
      "SedaField": "ArchivalAgencyArchiveUnitIdentifier",
      "Collection": "Unit",
      "ApiPath": "ArchivalAgencyArchiveUnitIdentifier",
      "ApiField": "ArchivalAgencyArchiveUnitIdentifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Identifiant métier attribué à l'ArchiveUnit par le service d'archives. Peut être comparé à une cote.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant attribué par le service d'archives",
      "Path": "ArchivalAgencyArchiveUnitIdentifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ArchiveUnitProfile",
      "SedaField": "ArchiveUnitProfile",
      "Collection": "Unit",
      "ApiPath": "ArchiveUnitProfile",
      "ApiField": "ArchiveUnitProfile",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Profil d'unité archivistique",
      "Path": "ArchiveUnitProfile",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "AuthorizedAgent",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent",
      "ApiField": "AuthorizedAgent",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Titulaire des droits",
      "Path": "AuthorizedAgent",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "AuthorizedAgent.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "AuthorizedAgent.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "AuthorizedAgent.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "AuthorizedAgent.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "AuthorizedAgent.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "AuthorizedAgent.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "AuthorizedAgent.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "AuthorizedAgent.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "AuthorizedAgent.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "AuthorizedAgent.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "AuthorizedAgent.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "AuthorizedAgent.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "AuthorizedAgent.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "AuthorizedAgent.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "AuthorizedAgent.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "AuthorizedAgent.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "AuthorizedAgent.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "AuthorizedAgent.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "AuthorizedAgent.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "AuthorizedAgent.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "AuthorizedAgent.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "AuthorizedAgent.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "AuthorizedAgent.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "AuthorizedAgent.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "AuthorizedAgent.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "AuthorizedAgent.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "AuthorizedAgent.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "AuthorizedAgent.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "AuthorizedAgent.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "AuthorizedAgent.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Coverage",
      "Collection": "Unit",
      "ApiPath": "Coverage",
      "ApiField": "Coverage",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Couverture(s)",
      "Path": "Coverage",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Juridictional",
      "SedaField": "Juridictional",
      "Collection": "Unit",
      "ApiPath": "Coverage.Juridictional",
      "ApiField": "Juridictional",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Couverture juridictionnelle",
      "Path": "Coverage.Juridictional",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Spatial",
      "SedaField": "Spatial",
      "Collection": "Unit",
      "ApiPath": "Coverage.Spatial",
      "ApiField": "Spatial",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Couverture spatiale",
      "Path": "Coverage.Spatial",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Temporal",
      "SedaField": "Temporal",
      "Collection": "Unit",
      "ApiPath": "Coverage.Temporal",
      "ApiField": "Temporal",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Couverture temporelle",
      "Path": "Coverage.Temporal",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "CreatedDate",
      "SedaField": "CreatedDate",
      "Collection": "Unit",
      "ApiPath": "CreatedDate",
      "ApiField": "CreatedDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de création",
      "Path": "CreatedDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "CustodialHistory",
      "Collection": "Unit",
      "ApiPath": "CustodialHistory",
      "ApiField": "CustodialHistory",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Historique de la conservation",
      "Path": "CustodialHistory",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "CustodialHistoryFile",
      "Collection": "Unit",
      "ApiPath": "CustodialHistory.CustodialHistoryFile",
      "ApiField": "CustodialHistoryFile",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un journal externe",
      "Path": "CustodialHistory.CustodialHistoryFile",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "CustodialHistory.CustodialHistoryFile.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un groupe d'objets",
      "Path": "CustodialHistory.CustodialHistoryFile.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "CustodialHistory.CustodialHistoryFile.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un objet",
      "Path": "CustodialHistory.CustodialHistoryFile.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "CustodialHistoryItem",
      "SedaField": "CustodialHistoryItem",
      "Collection": "Unit",
      "ApiPath": "CustodialHistory.CustodialHistoryItem",
      "ApiField": "CustodialHistoryItem",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY_REQUIRED",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Détail",
      "Path": "CustodialHistory.CustodialHistoryItem",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "LARGE",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DateLitteral",
      "SedaField": "DateLitteral",
      "Collection": "Unit",
      "ApiPath": "DateLitteral",
      "ApiField": "DateLitteral",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. DateLitteral",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Date textuelle",
      "Path": "DateLitteral",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Description",
      "SedaField": "Description",
      "Collection": "Unit",
      "ApiPath": "Description",
      "ApiField": "Description",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Description",
      "Path": "Description",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "LARGE",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DescriptionLanguage",
      "SedaField": "DescriptionLanguage",
      "Collection": "Unit",
      "ApiPath": "DescriptionLanguage",
      "ApiField": "DescriptionLanguage",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Langue de la description",
      "Path": "DescriptionLanguage",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DescriptionLevel",
      "SedaField": "DescriptionLevel",
      "Collection": "Unit",
      "ApiPath": "DescriptionLevel",
      "ApiField": "DescriptionLevel",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Niveau de description *",
      "Path": "DescriptionLevel",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "ENUM"
    },
    {
      "FieldName": "Description_",
      "Collection": "Unit",
      "ApiPath": "Description_",
      "ApiField": "Description_",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Description",
      "Path": "Description_",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DocumentType",
      "SedaField": "DocumentType",
      "Collection": "Unit",
      "ApiPath": "DocumentType",
      "ApiField": "DocumentType",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Type de document",
      "Path": "DocumentType",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "EndDate",
      "ApiField": "EndDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Event",
      "Collection": "Unit",
      "ApiPath": "Event",
      "ApiField": "Event",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Événement",
      "Path": "Event",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "evDateTime",
      "SedaField": "EventDateTime",
      "Collection": "Unit",
      "ApiPath": "Event.evDateTime",
      "ApiField": "evDateTime",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Date de lancement de l’opération",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date",
      "Path": "Event.evDateTime",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "evDetData",
      "SedaField": "eventDetailData",
      "Collection": "Unit",
      "ApiPath": "Event.evDetData",
      "ApiField": "evDetData",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Message technique détaillant l'événement",
      "Path": "Event.evDetData",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "evId",
      "SedaField": "EventIdentifier",
      "Collection": "Unit",
      "ApiPath": "Event.evId",
      "ApiField": "evId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Event.evId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "evType",
      "SedaField": "EventType",
      "Collection": "Unit",
      "ApiPath": "Event.evType",
      "ApiField": "evType",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Code du type de l’opération",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type",
      "Path": "Event.evType",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "evTypeDetail",
      "SedaField": "EventDetail",
      "Collection": "Unit",
      "ApiPath": "Event.evTypeDetail",
      "ApiField": "evTypeDetail",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Détail de l’événement",
      "Path": "Event.evTypeDetail",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "evTypeProc",
      "SedaField": "EventTypeCode",
      "Collection": "Unit",
      "ApiPath": "Event.evTypeProc",
      "ApiField": "evTypeProc",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Type de processus. Equivaut à la traduction du code du type de l'opération.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code",
      "Path": "Event.evTypeProc",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "outDetail",
      "SedaField": "OutcomeDetail",
      "Collection": "Unit",
      "ApiPath": "Event.outDetail",
      "ApiField": "outDetail",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Code correspondant au résultat de l’événement.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Détail sur le résultat",
      "Path": "Event.outDetail",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "outMessg",
      "SedaField": "OutcomeDetailMessage",
      "Collection": "Unit",
      "ApiPath": "Event.outMessg",
      "ApiField": "outMessg",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Détail du résultat de l’événement.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Description détaillée de l'événement",
      "Path": "Event.outMessg",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "outcome",
      "SedaField": "Outcome",
      "Collection": "Unit",
      "ApiPath": "Event.outcome",
      "ApiField": "outcome",
      "Category": "DESCRIPTION",
      "Description": "Mapping : logbook-es-mapping.json. Statut de l’événement",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Résultat",
      "Path": "Event.outcome",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "LinkingAgentIdentifier",
      "SedaField": "LinkingAgentIdentifier",
      "Collection": "Unit",
      "ApiPath": "Event.linkingAgentIdentifier",
      "ApiField": "linkingAgentIdentifier",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Agent",
      "Path": "Event.LinkingAgentIdentifier",
      "SedaVersions": [
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "LinkingAgentIdentifierType",
      "SedaField": "LinkingAgentIdentifierType",
      "Collection": "Unit",
      "ApiPath": "Event.linkingAgentIdentifier.LinkingAgentIdentifierType",
      "ApiField": "LinkingAgentIdentifierType",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. LinkingAgentIdentifierType ",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Event.LinkingAgentIdentifier.LinkingAgentIdentifierType",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "LinkingAgentIdentifierValue",
      "SedaField": "LinkingAgentIdentifierValue",
      "Collection": "Unit",
      "ApiPath": "Event.linkingAgentIdentifier.LinkingAgentIdentifierValue",
      "ApiField": "LinkingAgentIdentifierValue",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. LinkingAgentIdentifierValue",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Valeur",
      "Path": "Event.LinkingAgentIdentifier.LinkingAgentIdentifierValue",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "LinkingAgentRole",
      "SedaField": "LinkingAgentRole",
      "Collection": "Unit",
      "ApiPath": "Event.linkingAgentIdentifier.LinkingAgentRole",
      "ApiField": "LinkingAgentRole",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. LinkingAgentRole",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Event.LinkingAgentIdentifier.LinkingAgentRole",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FilePlanPosition",
      "SedaField": "FilePlanPosition",
      "Collection": "Unit",
      "ApiPath": "FilePlanPosition",
      "ApiField": "FilePlanPosition",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Position dans le plan de classement",
      "Path": "FilePlanPosition",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gps",
      "Collection": "Unit",
      "ApiPath": "Gps",
      "ApiField": "Gps",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Coordonnées GPS",
      "Path": "Gps",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "GpsAltitude",
      "SedaField": "GpsAltitude",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsAltitude",
      "ApiField": "GpsAltitude",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Altitude",
      "Path": "Gps.GpsAltitude",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "GpsAltitudeRef",
      "SedaField": "GpsAltitudeRef",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsAltitudeRef",
      "ApiField": "GpsAltitudeRef",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence de l’altitude",
      "Path": "Gps.GpsAltitudeRef",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsDateStamp",
      "SedaField": "GpsDateStamp",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsDateStamp",
      "ApiField": "GpsDateStamp",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Heure et date de la position",
      "Path": "Gps.GpsDateStamp",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsLatitude",
      "SedaField": "GpsLatitude",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsLatitude",
      "ApiField": "GpsLatitude",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Latitude",
      "Path": "Gps.GpsLatitude",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsLatitudeRef",
      "SedaField": "GpsLatitudeRef",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsLatitudeRef",
      "ApiField": "GpsLatitudeRef",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence de la latitude",
      "Path": "Gps.GpsLatitudeRef",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsLongitude",
      "SedaField": "GpsLongitude",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsLongitude",
      "ApiField": "GpsLongitude",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Longitude",
      "Path": "Gps.GpsLongitude",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsLongitudeRef",
      "SedaField": "GpsLongitudeRef",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsLongitudeRef",
      "ApiField": "GpsLongitudeRef",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence de la longitude",
      "Path": "Gps.GpsLongitudeRef",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GpsVersionID",
      "SedaField": "GpsVersionID",
      "Collection": "Unit",
      "ApiPath": "Gps.GpsVersionID",
      "ApiField": "GpsVersionID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant de version du GPS",
      "Path": "Gps.GpsVersionID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Keyword",
      "Collection": "Unit",
      "ApiPath": "Keyword",
      "ApiField": "Keyword",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Mot-clé",
      "Path": "Keyword",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "KeywordContent",
      "SedaField": "KeywordContent",
      "Collection": "Unit",
      "ApiPath": "Keyword.KeywordContent",
      "ApiField": "KeywordContent",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Valeur du mot-clé",
      "Path": "Keyword.KeywordContent",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "KeywordReference",
      "SedaField": "KeywordReference",
      "Collection": "Unit",
      "ApiPath": "Keyword.KeywordReference",
      "ApiField": "KeywordReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence du mot-clé",
      "Path": "Keyword.KeywordReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "KeywordType",
      "SedaField": "KeywordType",
      "Collection": "Unit",
      "ApiPath": "Keyword.KeywordType",
      "ApiField": "KeywordType",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type de mot-clé",
      "Path": "Keyword.KeywordType",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "ENUM"
    },
    {
      "FieldName": "Language",
      "SedaField": "Language",
      "Collection": "Unit",
      "ApiPath": "Language",
      "ApiField": "Language",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Langue",
      "Path": "Language",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OriginatingAgency",
      "SedaField": "OriginatingAgencyIdentifier",
      "Collection": "Unit",
      "ApiPath": "OriginatingAgency",
      "ApiField": "OriginatingAgency",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Service producteur",
      "Path": "OriginatingAgency",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "OriginatingAgency.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant du service producteur",
      "Path": "OriginatingAgency.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OrganizationDescriptiveMetadata",
      "Collection": "Unit",
      "ApiPath": "OriginatingAgency.OrganizationDescriptiveMetadata",
      "ApiField": "OrganizationDescriptiveMetadata",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "OrganizationDescriptiveMetadata",
      "Path": "OriginatingAgency.OrganizationDescriptiveMetadata",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "OriginatingAgencyArchiveUnitIdentifier",
      "SedaField": "OriginatingAgencyArchiveUnitIdentifier",
      "Collection": "Unit",
      "ApiPath": "OriginatingAgencyArchiveUnitIdentifier",
      "ApiField": "OriginatingAgencyArchiveUnitIdentifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant attribué par le service producteur",
      "Path": "OriginatingAgencyArchiveUnitIdentifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OriginatingSystemId",
      "SedaField": "OriginatingSystemId",
      "Collection": "Unit",
      "ApiPath": "OriginatingSystemId",
      "ApiField": "OriginatingSystemId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant attribué par le système d'origine",
      "Path": "OriginatingSystemId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OriginatingSystemIdReplyTo",
      "SedaField": "OriginatingSystemIdReplyTo",
      "Collection": "Unit",
      "ApiPath": "OriginatingSystemIdReplyTo",
      "ApiField": "OriginatingSystemIdReplyTo",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. OriginatingSystemIdReplyTo",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Réponse au message en référence",
      "Path": "OriginatingSystemIdReplyTo",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PersistentIdentifier",
      "Collection": "Unit",
      "ApiPath": "PersistentIdentifier",
      "ApiField": "PersistentIdentifier",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant pérenne",
      "Path": "PersistentIdentifier",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "PersistentIdentifierContent",
      "SedaField": "PersistentIdentifierContent",
      "Collection": "Unit",
      "ApiPath": "PersistentIdentifier.PersistentIdentifierContent",
      "ApiField": "PersistentIdentifierContent",
      "Category": "DESCRIPTION",
      "Description": "Persistent Identifier Content",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "PersistentIdentifier.PersistentIdentifierContent",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PersistentIdentifierOrigin",
      "SedaField": "PersistentIdentifierOrigin",
      "Collection": "Unit",
      "ApiPath": "PersistentIdentifier.PersistentIdentifierOrigin",
      "ApiField": "PersistentIdentifierOrigin",
      "Category": "DESCRIPTION",
      "Description": "Persistent Identifier Origin",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Origine",
      "Path": "PersistentIdentifier.PersistentIdentifierOrigin",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PersistentIdentifierReference",
      "SedaField": "PersistentIdentifierReference",
      "Collection": "Unit",
      "ApiPath": "PersistentIdentifier.PersistentIdentifierReference",
      "ApiField": "PersistentIdentifierReference",
      "Category": "DESCRIPTION",
      "Description": "Persistent Identifier Reference",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence",
      "Path": "PersistentIdentifier.PersistentIdentifierReference",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PersistentIdentifierType",
      "SedaField": "PersistentIdentifierType",
      "Collection": "Unit",
      "ApiPath": "PersistentIdentifier.PersistentIdentifierType",
      "ApiField": "PersistentIdentifierType",
      "Category": "DESCRIPTION",
      "Description": "Persistent Identifier Type",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type*",
      "Path": "PersistentIdentifier.PersistentIdentifierType",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ReceivedDate",
      "SedaField": "ReceivedDate",
      "Collection": "Unit",
      "ApiPath": "ReceivedDate",
      "ApiField": "ReceivedDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de réception",
      "Path": "ReceivedDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Recipient",
      "Collection": "Unit",
      "ApiPath": "Recipient",
      "ApiField": "Recipient",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Destinataire pour information",
      "Path": "Recipient",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Recipient.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Recipient.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Recipient.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Recipient.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Recipient.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Recipient.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Recipient.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Recipient.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Recipient.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Recipient.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Recipient.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Recipient.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Recipient.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Recipient.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Recipient.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Recipient.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Recipient.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Recipient.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Recipient.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Recipient.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Recipient.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Recipient.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Recipient.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Recipient.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Recipient.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Recipient.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Recipient.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Recipient.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Recipient.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Recipient.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Recipient.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Recipient.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Recipient.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Recipient.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Recipient.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Recipient.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Recipient.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Recipient.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Recipient.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Recipient.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Recipient.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Recipient.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Recipient.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RegisteredDate",
      "SedaField": "RegisteredDate",
      "Collection": "Unit",
      "ApiPath": "RegisteredDate",
      "ApiField": "RegisteredDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date d’enregistrement",
      "Path": "RegisteredDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "RelatedObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference",
      "ApiField": "RelatedObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Référence(s)",
      "Path": "RelatedObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "IsPartOf",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf",
      "ApiField": "IsPartOf",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Est une partie de",
      "Path": "RelatedObjectReference.IsPartOf",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ArchiveUnitRefId",
      "SedaField": "ArchiveUnitRefId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.ArchiveUnitRefId",
      "ApiField": "ArchiveUnitRefId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à une ArchiveUnit interne.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Unité",
      "Path": "RelatedObjectReference.IsPartOf.ArchiveUnitRefId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.DataObjectReference",
      "ApiField": "DataObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Objet",
      "Path": "RelatedObjectReference.IsPartOf.DataObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.DataObjectReference.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID du groupe d'objets",
      "Path": "RelatedObjectReference.IsPartOf.DataObjectReference.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.DataObjectReference.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID de l'objet",
      "Path": "RelatedObjectReference.IsPartOf.DataObjectReference.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExternalReference",
      "SedaField": "ExternalReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.ExternalReference",
      "ApiField": "ExternalReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Unité déjà archivée",
      "Path": "RelatedObjectReference.IsPartOf.ExternalReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryArchiveUnitPID",
      "SedaField": "RepositoryArchiveUnitPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.RepositoryArchiveUnitPID",
      "ApiField": "RepositoryArchiveUnitPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Objet déjà archivé",
      "Path": "RelatedObjectReference.IsPartOf.RepositoryArchiveUnitPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryObjectPID",
      "SedaField": "RepositoryObjectPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsPartOf.RepositoryObjectPID",
      "ApiField": "RepositoryObjectPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un un objet-données ou à un groupe d'objets-données déjà conservé(s) dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence externe",
      "Path": "RelatedObjectReference.IsPartOf.RepositoryObjectPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "IsVersionOf",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf",
      "ApiField": "IsVersionOf",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Est une version de",
      "Path": "RelatedObjectReference.IsVersionOf",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ArchiveUnitRefId",
      "SedaField": "ArchiveUnitRefId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.ArchiveUnitRefId",
      "ApiField": "ArchiveUnitRefId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à une ArchiveUnit interne.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Unité",
      "Path": "RelatedObjectReference.IsVersionOf.ArchiveUnitRefId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.DataObjectReference",
      "ApiField": "DataObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Objet",
      "Path": "RelatedObjectReference.IsVersionOf.DataObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.DataObjectReference.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID du groupe d'objets",
      "Path": "RelatedObjectReference.IsVersionOf.DataObjectReference.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.DataObjectReference.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID de l'objet",
      "Path": "RelatedObjectReference.IsVersionOf.DataObjectReference.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExternalReference",
      "SedaField": "ExternalReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.ExternalReference",
      "ApiField": "ExternalReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Référence externe",
      "Path": "RelatedObjectReference.IsVersionOf.ExternalReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryArchiveUnitPID",
      "SedaField": "RepositoryArchiveUnitPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.RepositoryArchiveUnitPID",
      "ApiField": "RepositoryArchiveUnitPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Unité déjà archivée",
      "Path": "RelatedObjectReference.IsVersionOf.RepositoryArchiveUnitPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryObjectPID",
      "SedaField": "RepositoryObjectPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.IsVersionOf.RepositoryObjectPID",
      "ApiField": "RepositoryObjectPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un un objet-données ou à un groupe d'objets-données déjà conservé(s) dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Objet déjà archivé",
      "Path": "RelatedObjectReference.IsVersionOf.RepositoryObjectPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "References",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References",
      "ApiField": "References",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "References",
      "Path": "RelatedObjectReference.References",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ArchiveUnitRefId",
      "SedaField": "ArchiveUnitRefId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.ArchiveUnitRefId",
      "ApiField": "ArchiveUnitRefId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à une ArchiveUnit interne.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à une ArchiveUnit interne",
      "Path": "RelatedObjectReference.References.ArchiveUnitRefId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.DataObjectReference",
      "ApiField": "DataObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "DataObjectReference",
      "Path": "RelatedObjectReference.References.DataObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.DataObjectReference.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un groupe d'objets",
      "Path": "RelatedObjectReference.References.DataObjectReference.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.DataObjectReference.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un objet ou à un groupe d'objets interne(s)",
      "Path": "RelatedObjectReference.References.DataObjectReference.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExternalReference",
      "SedaField": "ExternalReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.ExternalReference",
      "ApiField": "ExternalReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Path": "RelatedObjectReference.References.ExternalReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryArchiveUnitPID",
      "SedaField": "RepositoryArchiveUnitPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.RepositoryArchiveUnitPID",
      "ApiField": "RepositoryArchiveUnitPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à une ArchiveUnit déjà conservée",
      "Path": "RelatedObjectReference.References.RepositoryArchiveUnitPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryObjectPID",
      "SedaField": "RepositoryObjectPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.References.RepositoryObjectPID",
      "ApiField": "RepositoryObjectPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un un objet-données ou à un groupe d'objets-données déjà conservé(s) dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence à un objet ou à un groupe d'objets déjà conservé(s)",
      "Path": "RelatedObjectReference.References.RepositoryObjectPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Replaces",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces",
      "ApiField": "Replaces",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Remplace",
      "Path": "RelatedObjectReference.Replaces",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ArchiveUnitRefId",
      "SedaField": "ArchiveUnitRefId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.ArchiveUnitRefId",
      "ApiField": "ArchiveUnitRefId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à une ArchiveUnit interne.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Unité",
      "Path": "RelatedObjectReference.Replaces.ArchiveUnitRefId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.DataObjectReference",
      "ApiField": "DataObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Objet",
      "Path": "RelatedObjectReference.Replaces.DataObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.DataObjectReference.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID du groupe d'objets",
      "Path": "RelatedObjectReference.Replaces.DataObjectReference.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.DataObjectReference.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID de l'objet",
      "Path": "RelatedObjectReference.Replaces.DataObjectReference.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExternalReference",
      "SedaField": "ExternalReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.ExternalReference",
      "ApiField": "ExternalReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Unité déjà archivée",
      "Path": "RelatedObjectReference.Replaces.ExternalReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryArchiveUnitPID",
      "SedaField": "RepositoryArchiveUnitPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.RepositoryArchiveUnitPID",
      "ApiField": "RepositoryArchiveUnitPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Objet déjà archivé",
      "Path": "RelatedObjectReference.Replaces.RepositoryArchiveUnitPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryObjectPID",
      "SedaField": "RepositoryObjectPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Replaces.RepositoryObjectPID",
      "ApiField": "RepositoryObjectPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un un objet-données ou à un groupe d'objets-données déjà conservé(s) dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence externe",
      "Path": "RelatedObjectReference.Replaces.RepositoryObjectPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Requires",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires",
      "ApiField": "Requires",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Requiert",
      "Path": "RelatedObjectReference.Requires",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ArchiveUnitRefId",
      "SedaField": "ArchiveUnitRefId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.ArchiveUnitRefId",
      "ApiField": "ArchiveUnitRefId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à une ArchiveUnit interne.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Unité",
      "Path": "RelatedObjectReference.Requires.ArchiveUnitRefId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.DataObjectReference",
      "ApiField": "DataObjectReference",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Objet",
      "Path": "RelatedObjectReference.Requires.DataObjectReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "DataObjectGroupReferenceId",
      "SedaField": "DataObjectGroupReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.DataObjectReference.DataObjectGroupReferenceId",
      "ApiField": "DataObjectGroupReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un groupe d'objets-données listé dans les métadonnées de transport.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID du groupe d'objets",
      "Path": "RelatedObjectReference.Requires.DataObjectReference.DataObjectGroupReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DataObjectReferenceId",
      "SedaField": "DataObjectReferenceId",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.DataObjectReference.DataObjectReferenceId",
      "ApiField": "DataObjectReferenceId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet-données ou à un groupe d'objets-données interne(s).",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ID de l'objet",
      "Path": "RelatedObjectReference.Requires.DataObjectReference.DataObjectReferenceId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExternalReference",
      "SedaField": "ExternalReference",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.ExternalReference",
      "ApiField": "ExternalReference",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un objet externe, présent ni dans le message, ni dans le SAE",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Unité déjà archivée",
      "Path": "RelatedObjectReference.Requires.ExternalReference",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryArchiveUnitPID",
      "SedaField": "RepositoryArchiveUnitPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.RepositoryArchiveUnitPID",
      "ApiField": "RepositoryArchiveUnitPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Objet déjà archivé",
      "Path": "RelatedObjectReference.Requires.RepositoryArchiveUnitPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "RepositoryObjectPID",
      "SedaField": "RepositoryObjectPID",
      "Collection": "Unit",
      "ApiPath": "RelatedObjectReference.Requires.RepositoryObjectPID",
      "ApiField": "RepositoryObjectPID",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence à un un objet-données ou à un groupe d'objets-données déjà conservé(s) dans un système d'archivage.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Référence externe",
      "Path": "RelatedObjectReference.Requires.RepositoryObjectPID",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Sender",
      "Collection": "Unit",
      "ApiPath": "Sender",
      "ApiField": "Sender",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Expéditeur",
      "Path": "Sender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Sender.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Sender.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Sender.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Sender.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Sender.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Sender.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Sender.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Sender.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Sender.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Sender.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Sender.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Sender.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Sender.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Sender.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Sender.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Sender.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Sender.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Sender.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Sender.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Sender.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Sender.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Sender.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Sender.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Sender.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Sender.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Sender.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Sender.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Sender.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Sender.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Sender.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Sender.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Sender.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Sender.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Sender.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Sender.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Sender.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Sender.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Sender.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Sender.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Sender.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Sender.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Sender.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Sender.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "SentDate",
      "SedaField": "SentDate",
      "Collection": "Unit",
      "ApiPath": "SentDate",
      "ApiField": "SentDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date d'envoi",
      "Path": "SentDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Signature",
      "Collection": "Unit",
      "ApiPath": "Signature",
      "ApiField": "Signature",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Signature",
      "Path": "Signature",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Masterdata",
      "Collection": "Unit",
      "ApiPath": "Signature.Masterdata",
      "ApiField": "Masterdata",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Référentiel des personnes et des organisations",
      "Path": "Signature.Masterdata",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "ReferencedObject",
      "Collection": "Unit",
      "ApiPath": "Signature.ReferencedObject",
      "ApiField": "ReferencedObject",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE_REQUIRED",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Référence à l'objet signé",
      "Path": "Signature.ReferencedObject",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "SignedObjectDigest",
      "Collection": "Unit",
      "ApiPath": "Signature.ReferencedObject.SignedObjectDigest",
      "ApiField": "SignedObjectDigest",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Empreinte de l'objet signé",
      "Path": "Signature.ReferencedObject.SignedObjectDigest",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Algorithm",
      "SedaField": "Algorithm",
      "Collection": "Unit",
      "ApiPath": "Signature.ReferencedObject.SignedObjectDigest.Algorithm",
      "ApiField": "Algorithm",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Attribut SEDA.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Algorithme",
      "Path": "Signature.ReferencedObject.SignedObjectDigest.Algorithm",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MessageDigest",
      "SedaField": "MessageDigest",
      "Collection": "Unit",
      "ApiPath": "Signature.ReferencedObject.SignedObjectDigest.MessageDigest",
      "ApiField": "MessageDigest",
      "Category": "DESCRIPTION",
      "Description": "Mapping : og-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Empreinte",
      "Path": "Signature.ReferencedObject.SignedObjectDigest.MessageDigest",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "SignedObjectId",
      "SedaField": "SignedObjectId",
      "Collection": "Unit",
      "ApiPath": "Signature.ReferencedObject.SignedObjectId",
      "ApiField": "SignedObjectId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Identifiant de l'objet-données signé.",
      "Cardinality": "ONE_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant de l'objet de données signé",
      "Path": "Signature.ReferencedObject.SignedObjectId",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Signer",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer",
      "ApiField": "Signer",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY_REQUIRED",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Signataire",
      "Path": "Signature.Signer",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Signature.Signer.Activity",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Signature.Signer.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Signature.Signer.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Signature.Signer.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Signature.Signer.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Signature.Signer.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Signature.Signer.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Signature.Signer.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Signature.Signer.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Signature.Signer.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Signature.Signer.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de décès",
      "Path": "Signature.Signer.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Signature.Signer.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Signature.Signer.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Signature.Signer.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Signature.Signer.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Signature.Signer.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Signature.Signer.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Signature.Signer.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Signature.Signer.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Signature.Signer.FullName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Signature.Signer.Function",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Signature.Signer.Gender",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Signature.Signer.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Signature.Signer.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Signature.Signer.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Signature.Signer.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Signature.Signer.Position",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Signature.Signer.Role",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "SigningTime",
      "SedaField": "SigningTime",
      "Collection": "Unit",
      "ApiPath": "Signature.Signer.SigningTime",
      "ApiField": "SigningTime",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de signature",
      "Cardinality": "ONE_REQUIRED",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de signature",
      "Path": "Signature.Signer.SigningTime",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Validator",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator",
      "ApiField": "Validator",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Validateur",
      "Path": "Signature.Validator",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Signature.Validator.Activity",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Signature.Validator.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Signature.Validator.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Signature.Validator.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Signature.Validator.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Signature.Validator.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Signature.Validator.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Signature.Validator.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Signature.Validator.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Signature.Validator.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Signature.Validator.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Signature.Validator.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Signature.Validator.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Signature.Validator.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Signature.Validator.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Signature.Validator.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Signature.Validator.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Signature.Validator.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Signature.Validator.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Signature.Validator.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Signature.Validator.FullName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Signature.Validator.Function",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Signature.Validator.Gender",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Signature.Validator.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Signature.Validator.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Signature.Validator.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Signature.Validator.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Signature.Validator.Position",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Signature.Validator.Role",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ValidationTime",
      "SedaField": "ValidationTime",
      "Collection": "Unit",
      "ApiPath": "Signature.Validator.ValidationTime",
      "ApiField": "ValidationTime",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de la validation de la signature.",
      "Cardinality": "ONE_REQUIRED",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de validation *",
      "Path": "Signature.Validator.ValidationTime",
      "SedaVersions": [
        "2.1",
        "2.2"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "SigningInformation",
      "Collection": "Unit",
      "ApiPath": "SigningInformation",
      "ApiField": "SigningInformation",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Informations sur la signature",
      "Path": "SigningInformation",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "AdditionalProof",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.AdditionalProof",
      "ApiField": "AdditionalProof",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Preuve complémentaire",
      "Path": "SigningInformation.AdditionalProof",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "AdditionalProofInformation",
      "SedaField": "AdditionalProofInformation",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.AdditionalProof.AdditionalProofInformation",
      "ApiField": "AdditionalProofInformation",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Informations relatives aux preuves complémentaires archivées dans un contexte de signature.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Description",
      "Path": "SigningInformation.AdditionalProof.AdditionalProofInformation",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "LARGE",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DetachedSigningRole",
      "SedaField": "DetachedSigningRole",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.DetachedSigningRole",
      "ApiField": "DetachedSigningRole",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Référence aux rôles des unités d'archives encapsulées sous la racine contenant le document signé.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Rôle de l'unité encapsulée",
      "Path": "SigningInformation.DetachedSigningRole",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "ENUM"
    },
    {
      "FieldName": "Extended",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.Extended",
      "ApiField": "Extended",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Extended",
      "Path": "SigningInformation.Extended",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "SignatureDescription",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription",
      "ApiField": "SignatureDescription",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Signature",
      "Path": "SigningInformation.SignatureDescription",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Signer",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer",
      "ApiField": "Signer",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Signataire",
      "Path": "SigningInformation.SignatureDescription.Signer",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "SigningInformation.SignatureDescription.Signer.Activity",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthDate",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.Address",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.City",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.Country",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.Geogname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "SigningInformation.SignatureDescription.Signer.BirthPlace.Region",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "SigningInformation.SignatureDescription.Signer.Corpname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de décès",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathDate",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.Address",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.City",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.Country",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.Geogname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "SigningInformation.SignatureDescription.Signer.DeathPlace.Region",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "SigningInformation.SignatureDescription.Signer.FirstName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom / Nom + Prénom",
      "Path": "SigningInformation.SignatureDescription.Signer.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "SigningInformation.SignatureDescription.Signer.Function",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "SigningInformation.SignatureDescription.Signer.Gender",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "SigningInformation.SignatureDescription.Signer.GivenName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "SigningInformation.SignatureDescription.Signer.Identifier",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "SigningInformation.SignatureDescription.Signer.Mandate",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "SigningInformation.SignatureDescription.Signer.Nationality",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "SigningInformation.SignatureDescription.Signer.Position",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "SigningInformation.SignatureDescription.Signer.Role",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "SigningTime",
      "SedaField": "SigningTime",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Signer.SigningTime",
      "ApiField": "SigningTime",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de signature",
      "Cardinality": "ONE_REQUIRED",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de signature",
      "Path": "SigningInformation.SignatureDescription.Signer.SigningTime",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "SigningType",
      "SedaField": "SigningType",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.SigningType",
      "ApiField": "SigningType",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Type de signature, au sens juridique du terme. Par exemple, simple, avancée, qualifiée.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type de signature",
      "Path": "SigningInformation.SignatureDescription.SigningType",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Validator",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator",
      "ApiField": "Validator",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Validateur",
      "Path": "SigningInformation.SignatureDescription.Validator",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "SigningInformation.SignatureDescription.Validator.Activity",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthDate",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.Address",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.City",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.Country",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.Geogname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "SigningInformation.SignatureDescription.Validator.BirthPlace.Region",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "SigningInformation.SignatureDescription.Validator.Corpname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathDate",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.Address",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.City",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.Country",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.Geogname",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "SigningInformation.SignatureDescription.Validator.DeathPlace.Region",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "SigningInformation.SignatureDescription.Validator.FirstName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom / Nom + Prénom",
      "Path": "SigningInformation.SignatureDescription.Validator.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "SigningInformation.SignatureDescription.Validator.Function",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "SigningInformation.SignatureDescription.Validator.Gender",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "SigningInformation.SignatureDescription.Validator.GivenName",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "SigningInformation.SignatureDescription.Validator.Identifier",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "SigningInformation.SignatureDescription.Validator.Mandate",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "SigningInformation.SignatureDescription.Validator.Nationality",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "SigningInformation.SignatureDescription.Validator.Position",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "SigningInformation.SignatureDescription.Validator.Role",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ValidationTime",
      "SedaField": "ValidationTime",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SignatureDescription.Validator.ValidationTime",
      "ApiField": "ValidationTime",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de la validation de la signature.",
      "Cardinality": "ONE_REQUIRED",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de validation *",
      "Path": "SigningInformation.SignatureDescription.Validator.ValidationTime",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "SigningRole",
      "SedaField": "SigningRole",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.SigningRole",
      "ApiField": "SigningRole",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Rôle de l'unité d'archives dans un contexte de signature. Quatre rôles (étiquettes) ont été identifiés : document signé, signature, horodatage et preuves complémentaires.",
      "Cardinality": "MANY_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "SigningInformation.SigningRole",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "ENUM"
    },
    {
      "FieldName": "TimestampingInformation",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.TimestampingInformation",
      "ApiField": "TimestampingInformation",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Information d'horodatage",
      "Path": "SigningInformation.TimestampingInformation",
      "SedaVersions": [
        "2.3"
      ]
    },
    {
      "FieldName": "AdditionalTimestampingInformation",
      "SedaField": "AdditionalTimestampingInformation",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.TimestampingInformation.AdditionalTimestampingInformation",
      "ApiField": "AdditionalTimestampingInformation",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Informations complémentaires sur l'horodatage d'une signature",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Description de l'horodatage",
      "Path": "SigningInformation.TimestampingInformation.AdditionalTimestampingInformation",
      "SedaVersions": [
        "2.3"
      ],
      "StringSize": "LARGE",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "TimeStamp",
      "SedaField": "TimeStamp",
      "Collection": "Unit",
      "ApiPath": "SigningInformation.TimestampingInformation.TimeStamp",
      "ApiField": "TimeStamp",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Horodatage de la signature",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Horodatage de la signature",
      "Path": "SigningInformation.TimestampingInformation.TimeStamp",
      "SedaVersions": [
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Source",
      "SedaField": "Source",
      "Collection": "Unit",
      "ApiPath": "Source",
      "ApiField": "Source",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En cas de substitution numérique, permet de faire référence au papier.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Source",
      "Path": "Source",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "StartDate",
      "ApiField": "StartDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Status",
      "SedaField": "Status",
      "Collection": "Unit",
      "ApiPath": "Status",
      "ApiField": "Status",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Statut",
      "Path": "Status",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "SubmissionAgency",
      "SedaField": "SubmissionAgencyIdentifier",
      "Collection": "Unit",
      "ApiPath": "SubmissionAgency",
      "ApiField": "SubmissionAgency",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Service versant",
      "Path": "SubmissionAgency",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "SubmissionAgency.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant du service versant",
      "Path": "SubmissionAgency.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OrganizationDescriptiveMetadata",
      "Collection": "Unit",
      "ApiPath": "SubmissionAgency.OrganizationDescriptiveMetadata",
      "ApiField": "OrganizationDescriptiveMetadata",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "OrganizationDescriptiveMetadata",
      "Path": "SubmissionAgency.OrganizationDescriptiveMetadata",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "SystemId",
      "SedaField": "SystemId",
      "Collection": "Unit",
      "ApiPath": "SystemId",
      "ApiField": "SystemId",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Identifiant attribué aux objets. Il est attribué par le SAE et correspond à un identifiant interne.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant technique du système",
      "Path": "SystemId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Tag",
      "SedaField": "Tag",
      "Collection": "Unit",
      "ApiPath": "Tag",
      "ApiField": "Tag",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Tag",
      "Path": "Tag",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "TextContent",
      "SedaField": "TextContent",
      "Collection": "Unit",
      "ApiPath": "TextContent",
      "ApiField": "TextContent",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Contenu",
      "Path": "TextContent",
      "SedaVersions": [
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Title",
      "SedaField": "Title",
      "Collection": "Unit",
      "ApiPath": "Title",
      "ApiField": "Title",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Intitulé *",
      "Path": "Title",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Title_",
      "Collection": "Unit",
      "ApiPath": "Title_",
      "ApiField": "Title_",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Intitulé",
      "Path": "Title_",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "TransactedDate",
      "SedaField": "TransactedDate",
      "Collection": "Unit",
      "ApiPath": "TransactedDate",
      "ApiField": "TransactedDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de transaction",
      "Path": "TransactedDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "TransferringAgencyArchiveUnitIdentifier",
      "SedaField": "TransferringAgencyArchiveUnitIdentifier",
      "Collection": "Unit",
      "ApiPath": "TransferringAgencyArchiveUnitIdentifier",
      "ApiField": "TransferringAgencyArchiveUnitIdentifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant attribué par le service versant",
      "Path": "TransferringAgencyArchiveUnitIdentifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Transmitter",
      "Collection": "Unit",
      "ApiPath": "Transmitter",
      "ApiField": "Transmitter",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Emetteur",
      "Path": "Transmitter",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Transmitter.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Transmitter.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Transmitter.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Transmitter.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Transmitter.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Transmitter.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Transmitter.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Transmitter.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Transmitter.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Transmitter.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Transmitter.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Transmitter.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Transmitter.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Transmitter.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Transmitter.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Transmitter.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Transmitter.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Transmitter.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Transmitter.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Transmitter.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Transmitter.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Transmitter.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Transmitter.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Transmitter.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Transmitter.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Transmitter.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Transmitter.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Transmitter.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Transmitter.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Transmitter.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Transmitter.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Transmitter.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Transmitter.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Transmitter.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Transmitter.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Type",
      "SedaField": "Type",
      "Collection": "Unit",
      "ApiPath": "Type",
      "ApiField": "Type",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type d'information",
      "Path": "Type",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Version",
      "SedaField": "Version",
      "Collection": "Unit",
      "ApiPath": "Version",
      "ApiField": "Version",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Version",
      "Path": "Version",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Writer",
      "Collection": "Unit",
      "ApiPath": "Writer",
      "ApiField": "Writer",
      "Category": "DESCRIPTION",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rédacteur",
      "Path": "Writer",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Activity",
      "SedaField": "Activity",
      "Collection": "Unit",
      "ApiPath": "Writer.Activity",
      "ApiField": "Activity",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Activité.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Activité",
      "Path": "Writer.Activity",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthDate",
      "SedaField": "BirthDate",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthDate",
      "ApiField": "BirthDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de naissance",
      "Path": "Writer.BirthDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "BirthName",
      "SedaField": "BirthName",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthName",
      "ApiField": "BirthName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de naissance",
      "Path": "Writer.BirthName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "BirthPlace",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace",
      "ApiField": "BirthPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de naissance",
      "Path": "Writer.BirthPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Writer.BirthPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Writer.BirthPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Writer.BirthPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Writer.BirthPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Writer.BirthPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Writer.BirthPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Writer.BirthPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Corpname",
      "SedaField": "Corpname",
      "Collection": "Unit",
      "ApiPath": "Writer.Corpname",
      "ApiField": "Corpname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de l'entité",
      "Path": "Writer.Corpname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DeathDate",
      "SedaField": "DeathDate",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathDate",
      "ApiField": "DeathDate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Date de décès d'une personne.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "date de décès",
      "Path": "Writer.DeathDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DeathPlace",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace",
      "ApiField": "DeathPlace",
      "Category": "DESCRIPTION",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Lieu de décès",
      "Path": "Writer.DeathPlace",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Address",
      "SedaField": "Address",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.Address",
      "ApiField": "Address",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Adresse. Références : ead.address",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Adresse",
      "Path": "Writer.DeathPlace.Address",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "City",
      "SedaField": "City",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.City",
      "ApiField": "City",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Ville.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Ville",
      "Path": "Writer.DeathPlace.City",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Country",
      "SedaField": "Country",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.Country",
      "ApiField": "Country",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Pays.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Pays",
      "Path": "Writer.DeathPlace.Country",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Geogname",
      "SedaField": "Geogname",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.Geogname",
      "ApiField": "Geogname",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Nom géographique. Références : ead.geogname",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom de lieu",
      "Path": "Writer.DeathPlace.Geogname",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "PostalCode",
      "SedaField": "PostalCode",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.PostalCode",
      "ApiField": "PostalCode",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Code postal.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Code postal",
      "Path": "Writer.DeathPlace.PostalCode",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Region",
      "SedaField": "Region",
      "Collection": "Unit",
      "ApiPath": "Writer.DeathPlace.Region",
      "ApiField": "Region",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Région.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Région",
      "Path": "Writer.DeathPlace.Region",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FirstName",
      "SedaField": "FirstName",
      "Collection": "Unit",
      "ApiPath": "Writer.FirstName",
      "ApiField": "FirstName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Prénom d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Prénom",
      "Path": "Writer.FirstName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "FullName",
      "SedaField": "FullName",
      "Collection": "Unit",
      "ApiPath": "Writer.FullName",
      "ApiField": "FullName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom complet",
      "Path": "Writer.FullName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Function",
      "SedaField": "Function",
      "Collection": "Unit",
      "ApiPath": "Writer.Function",
      "ApiField": "Function",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. En plus des balises Tag et Keyword, il est possible d'indexer les objets avec des éléments pré-définis : Fonction.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Fonction",
      "Path": "Writer.Function",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Gender",
      "SedaField": "Gender",
      "Collection": "Unit",
      "ApiPath": "Writer.Gender",
      "ApiField": "Gender",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Sexe de la personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Sexe",
      "Path": "Writer.Gender",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GivenName",
      "SedaField": "GivenName",
      "Collection": "Unit",
      "ApiPath": "Writer.GivenName",
      "ApiField": "GivenName",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Nom d'usage d'une personne.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Nom d'usage",
      "Path": "Writer.GivenName",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Identifier",
      "SedaField": "Identifier",
      "Collection": "Unit",
      "ApiPath": "Writer.Identifier",
      "ApiField": "Identifier",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. UNITE ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS : identifiant.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant",
      "Path": "Writer.Identifier",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Mandate",
      "SedaField": "Mandate",
      "Collection": "Unit",
      "ApiPath": "Writer.Mandate",
      "ApiField": "Mandate",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Mandat octroyé à la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Droits",
      "Path": "Writer.Mandate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Nationality",
      "SedaField": "Nationality",
      "Collection": "Unit",
      "ApiPath": "Writer.Nationality",
      "ApiField": "Nationality",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "nationalité",
      "Path": "Writer.Nationality",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Position",
      "SedaField": "Position",
      "Collection": "Unit",
      "ApiPath": "Writer.Position",
      "ApiField": "Position",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Intitulé du poste de travail occupé par la personne.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Position",
      "Path": "Writer.Position",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Role",
      "SedaField": "Role",
      "Collection": "Unit",
      "ApiPath": "Writer.Role",
      "ApiField": "Role",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Droits avec lesquels un utilisateur a réalisé une opération, notamment dans une application.",
      "Cardinality": "MANY",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Rôle",
      "Path": "Writer.Role",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "SHORT",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_acd",
      "Collection": "Unit",
      "ApiPath": "#approximate_creation_date",
      "ApiField": "#approximate_creation_date",
      "Category": "OTHER",
      "Description": "Approximative created date, Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "_acd",
      "Path": "_acd",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_aud",
      "Collection": "Unit",
      "ApiPath": "#approximate_update_date",
      "ApiField": "#approximate_update_date",
      "Category": "OTHER",
      "Description": "Approximative updated date, Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "_aud",
      "Path": "_aud",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_av",
      "Collection": "Unit",
      "ApiPath": "#atomic_version",
      "ApiField": "#atomic_version",
      "Category": "OTHER",
      "Description": "Version interne de l’enregistrement décrit.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Version",
      "Path": "_av",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "_computedInheritedRules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules",
      "ApiField": "#computedInheritedRules",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_computedInheritedRules",
      "Path": "_computedInheritedRules"
    },
    {
      "FieldName": "AccessRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule",
      "ApiField": "AccessRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "AccessRule",
      "Path": "_computedInheritedRules.AccessRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.AccessRule.EndDates"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.AccessRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.AccessRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.AccessRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.AccessRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.AccessRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AccessRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.AccessRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "AppraisalRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule",
      "ApiField": "AppraisalRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "AppraisalRule",
      "Path": "_computedInheritedRules.AppraisalRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.AppraisalRule.EndDates"
    },
    {
      "FieldName": "FinalAction",
      "SedaField": "FinalAction",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.FinalAction",
      "ApiField": "FinalAction",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Sort final",
      "Path": "_computedInheritedRules.AppraisalRule.FinalAction",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.AppraisalRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.AppraisalRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.AppraisalRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.AppraisalRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.AppraisalRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.AppraisalRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.AppraisalRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule",
      "ApiField": "ClassificationRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ClassificationRule",
      "Path": "_computedInheritedRules.ClassificationRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.ClassificationRule.EndDates"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.ClassificationRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.ClassificationRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.ClassificationRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.ClassificationRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.ClassificationRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ClassificationRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.ClassificationRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "DisseminationRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule",
      "ApiField": "DisseminationRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "DisseminationRule",
      "Path": "_computedInheritedRules.DisseminationRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.DisseminationRule.EndDates"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.DisseminationRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.DisseminationRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.DisseminationRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.DisseminationRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.DisseminationRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.DisseminationRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.DisseminationRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "HoldRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule",
      "ApiField": "HoldRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "HoldRule",
      "Path": "_computedInheritedRules.HoldRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.HoldRule.EndDates"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.HoldRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.HoldRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.HoldRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.HoldRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.HoldRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.HoldRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.HoldRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "NeedAuthorization",
      "SedaField": "NeedAuthorization",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.NeedAuthorization",
      "ApiField": "NeedAuthorization",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si une autorisation humaine est nécessaire pour vérifier ou valider les opérations de gestion des ArchiveUnit.",
      "Cardinality": "MANY",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Autorisation",
      "Path": "_computedInheritedRules.NeedAuthorization",
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "ReuseRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule",
      "ApiField": "ReuseRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ReuseRule",
      "Path": "_computedInheritedRules.ReuseRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.ReuseRule.EndDates"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.ReuseRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.ReuseRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.ReuseRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.ReuseRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.ReuseRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.ReuseRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.ReuseRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StorageRule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule",
      "ApiField": "StorageRule",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "StorageRule",
      "Path": "_computedInheritedRules.StorageRule"
    },
    {
      "FieldName": "EndDates",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.EndDates",
      "ApiField": "EndDates",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "EndDates",
      "Path": "_computedInheritedRules.StorageRule.EndDates"
    },
    {
      "FieldName": "FinalAction",
      "SedaField": "FinalAction",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.FinalAction",
      "ApiField": "FinalAction",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Sort final",
      "Path": "_computedInheritedRules.StorageRule.FinalAction",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritanceOrigin",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.InheritanceOrigin",
      "ApiField": "InheritanceOrigin",
      "Category": "MANAGEMENT",
      "Description": "Origine de définition des règles de gestion",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritanceOrigin",
      "Path": "_computedInheritedRules.StorageRule.InheritanceOrigin",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "InheritedRuleIds",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.InheritedRuleIds",
      "ApiField": "InheritedRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Identifiant des règles héritées applicables",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "InheritedRuleIds",
      "Path": "_computedInheritedRules.StorageRule.InheritedRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "MaxEndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.MaxEndDate",
      "ApiField": "MaxEndDate",
      "Category": "MANAGEMENT",
      "Description": "Date de fin maximale",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "MaxEndDate",
      "Path": "_computedInheritedRules.StorageRule.MaxEndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_computedInheritedRules.StorageRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_computedInheritedRules.StorageRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.StorageRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_computedInheritedRules.StorageRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "indexationDate",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.indexationDate",
      "ApiField": "indexationDate",
      "Category": "MANAGEMENT",
      "Description": "Date d'indexation'",
      "Cardinality": "MANY",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "indexationDate",
      "Path": "_computedInheritedRules.indexationDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "inheritedRulesAPIOutput",
      "Collection": "Unit",
      "ApiPath": "#computedInheritedRules.inheritedRulesAPIOutput",
      "ApiField": "inheritedRulesAPIOutput",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "inheritedRulesAPIOutput",
      "Path": "_computedInheritedRules.inheritedRulesAPIOutput"
    },
    {
      "FieldName": "_elimination",
      "Collection": "Unit",
      "ApiPath": "#elimination",
      "ApiField": "#elimination",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_elimination",
      "Path": "_elimination"
    },
    {
      "FieldName": "DestroyableOriginatingAgencies",
      "Collection": "Unit",
      "ApiPath": "#elimination.DestroyableOriginatingAgencies",
      "ApiField": "DestroyableOriginatingAgencies",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs éliminables",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "DestroyableOriginatingAgencies",
      "Path": "_elimination.DestroyableOriginatingAgencies",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExtendedInfo",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo",
      "ApiField": "ExtendedInfo",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ExtendedInfo",
      "Path": "_elimination.ExtendedInfo"
    },
    {
      "FieldName": "ExtendedInfoDetails",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails",
      "ApiField": "ExtendedInfoDetails",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ExtendedInfoDetails",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails"
    },
    {
      "FieldName": "DestroyableOriginatingAgencies",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails.DestroyableOriginatingAgencies",
      "ApiField": "DestroyableOriginatingAgencies",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs éliminables",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "DestroyableOriginatingAgencies",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails.DestroyableOriginatingAgencies",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "HoldRuleIds",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails.HoldRuleIds",
      "ApiField": "HoldRuleIds",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Identifiants des règles de gel",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "HoldRuleIds",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails.HoldRuleIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "NonDestroyableOriginatingAgencies",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails.NonDestroyableOriginatingAgencies",
      "ApiField": "NonDestroyableOriginatingAgencies",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs non éliminables",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "NonDestroyableOriginatingAgencies",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails.NonDestroyableOriginatingAgencies",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OriginatingAgenciesInConflict",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails.OriginatingAgenciesInConflict",
      "ApiField": "OriginatingAgenciesInConflict",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs en conflit",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "OriginatingAgenciesInConflict",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails.OriginatingAgenciesInConflict",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ParentUnitId",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoDetails.ParentUnitId",
      "ApiField": "ParentUnitId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Identifiant de l'unité parente",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ParentUnitId",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoDetails.ParentUnitId",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ExtendedInfoType",
      "Collection": "Unit",
      "ApiPath": "#elimination.ExtendedInfo.ExtendedInfoType",
      "ApiField": "ExtendedInfoType",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Type d'informations étendues",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "ExtendedInfoType",
      "Path": "_elimination.ExtendedInfo.ExtendedInfoType",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "GlobalStatus",
      "Collection": "Unit",
      "ApiPath": "#elimination.GlobalStatus",
      "ApiField": "GlobalStatus",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Statut global de l'indexation.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "GlobalStatus",
      "Path": "_elimination.GlobalStatus",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "NonDestroyableOriginatingAgencies",
      "Collection": "Unit",
      "ApiPath": "#elimination.NonDestroyableOriginatingAgencies",
      "ApiField": "NonDestroyableOriginatingAgencies",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs non éliminables",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "NonDestroyableOriginatingAgencies",
      "Path": "_elimination.NonDestroyableOriginatingAgencies",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "OperationId",
      "Collection": "Unit",
      "ApiPath": "#elimination.OperationId",
      "ApiField": "OperationId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Identifiant de l'operation.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "OperationId",
      "Path": "_elimination.OperationId",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_glpd",
      "Collection": "Unit",
      "ApiPath": "#graph_last_persisted_date",
      "ApiField": "#graph_last_persisted_date",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "_glpd",
      "Path": "_glpd",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_graph",
      "Collection": "Unit",
      "ApiPath": "#graph",
      "ApiField": "#graph",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "_graph",
      "Path": "_graph",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_history",
      "Collection": "Unit",
      "ApiPath": "#history",
      "ApiField": "#history",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_history",
      "Path": "_history"
    },
    {
      "FieldName": "data",
      "Collection": "Unit",
      "ApiPath": "#history.data",
      "ApiField": "data",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "data",
      "Path": "_history.data"
    },
    {
      "FieldName": "_mgt",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management",
      "ApiField": "#management",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_mgt",
      "Path": "_history.data._mgt"
    },
    {
      "FieldName": "ClassificationRule",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule",
      "ApiField": "ClassificationRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ClassificationRule",
      "Path": "_history.data._mgt.ClassificationRule"
    },
    {
      "FieldName": "ClassificationAudience",
      "SedaField": "ClassificationAudience",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.ClassificationAudience",
      "ApiField": "ClassificationAudience",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Permet de gérer les questions de 'diffusion restreinte', de 'spécial France' et de 'Confidentiel Industrie'.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Audience de la classification",
      "Path": "_history.data._mgt.ClassificationRule.ClassificationAudience",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationLevel",
      "SedaField": "ClassificationLevel",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.ClassificationLevel",
      "ApiField": "ClassificationLevel",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Niveau de classification",
      "Path": "_history.data._mgt.ClassificationRule.ClassificationLevel",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationOwner",
      "SedaField": "ClassificationOwner",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.ClassificationOwner",
      "ApiField": "ClassificationOwner",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Propriétaire de la classification. Service émetteur au sens de l'IGI 1300.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Service émetteur / Propriétaire de la classification",
      "Path": "_history.data._mgt.ClassificationRule.ClassificationOwner",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationReassessingDate",
      "SedaField": "ClassificationReassessingDate",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.ClassificationReassessingDate",
      "ApiField": "ClassificationReassessingDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Date de réévaluation de la classification.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de réévaluation",
      "Path": "_history.data._mgt.ClassificationRule.ClassificationReassessingDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_history.data._mgt.ClassificationRule.Inheritance"
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_history.data._mgt.ClassificationRule.Inheritance.PreventInheritance",
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_history.data._mgt.ClassificationRule.Inheritance.PreventRulesId",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "NeedReassessingAuthorization",
      "SedaField": "NeedReassessingAuthorization",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.NeedReassessingAuthorization",
      "ApiField": "NeedReassessingAuthorization",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si une autorisation humaine est nécessaire pour réévaluer la classification.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Autorisation",
      "Path": "_history.data._mgt.ClassificationRule.NeedReassessingAuthorization",
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_history.data._mgt.ClassificationRule.Rules"
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_history.data._mgt.ClassificationRule.Rules.EndDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_history.data._mgt.ClassificationRule.Rules.Rule",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#history.data.#management.ClassificationRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_history.data._mgt.ClassificationRule.Rules.StartDate",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_v",
      "Collection": "Unit",
      "ApiPath": "#history.data.#version",
      "ApiField": "#version",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Version de l’enregistrement décrit.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Version",
      "Path": "_history.data._v",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "ud",
      "Collection": "Unit",
      "ApiPath": "#history.ud",
      "ApiField": "ud",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Dernière modification",
      "Path": "_history.ud",
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_id",
      "Collection": "Unit",
      "ApiPath": "#id",
      "ApiField": "#id",
      "Category": "OTHER",
      "Description": "Mapping : og-es-mapping.json. Identifiant du groupe d’objets",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant du groupe d'objets",
      "Path": "_id",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_implementationVersion",
      "Collection": "Unit",
      "ApiPath": "#implementationVersion",
      "ApiField": "#implementationVersion",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "_implementationVersion",
      "Path": "_implementationVersion",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_max",
      "Collection": "Unit",
      "ApiPath": "#max",
      "ApiField": "#max",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Profondeur maximale de l’unité archivistique par rapport à une racine.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Profondeur maximale",
      "Path": "_max",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "_mgt",
      "Collection": "Unit",
      "ApiPath": "#management",
      "ApiField": "#management",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_mgt",
      "Path": "_mgt",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "AccessRule",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule",
      "ApiField": "AccessRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "AccessRule",
      "Path": "_mgt.AccessRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.AccessRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.AccessRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.AccessRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.AccessRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.AccessRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.AccessRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.AccessRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.AccessRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "AppraisalRule",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule",
      "ApiField": "AppraisalRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "AppraisalRule",
      "Path": "_mgt.AppraisalRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "FinalAction",
      "SedaField": "FinalAction",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.FinalAction",
      "ApiField": "FinalAction",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Sort final",
      "Path": "_mgt.AppraisalRule.FinalAction",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.AppraisalRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.AppraisalRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.AppraisalRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.AppraisalRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.AppraisalRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.AppraisalRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.AppraisalRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.AppraisalRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "ClassificationRule",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule",
      "ApiField": "ClassificationRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ClassificationRule",
      "Path": "_mgt.ClassificationRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "ClassificationAudience",
      "SedaField": "ClassificationAudience",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.ClassificationAudience",
      "ApiField": "ClassificationAudience",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Permet de gérer les questions de 'diffusion restreinte', de 'spécial France' et de 'Confidentiel Industrie'.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Audience de la classification",
      "Path": "_mgt.ClassificationRule.ClassificationAudience",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationLevel",
      "SedaField": "ClassificationLevel",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.ClassificationLevel",
      "ApiField": "ClassificationLevel",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Niveau de classification",
      "Path": "_mgt.ClassificationRule.ClassificationLevel",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationOwner",
      "SedaField": "ClassificationOwner",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.ClassificationOwner",
      "ApiField": "ClassificationOwner",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Propriétaire de la classification. Service émetteur au sens de l'IGI 1300.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Service émetteur / Propriétaire de la classification",
      "Path": "_mgt.ClassificationRule.ClassificationOwner",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "ClassificationReassessingDate",
      "SedaField": "ClassificationReassessingDate",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.ClassificationReassessingDate",
      "ApiField": "ClassificationReassessingDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Date de réévaluation de la classification.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de réévaluation",
      "Path": "_mgt.ClassificationRule.ClassificationReassessingDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.ClassificationRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.ClassificationRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.ClassificationRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "NeedReassessingAuthorization",
      "SedaField": "NeedReassessingAuthorization",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.NeedReassessingAuthorization",
      "ApiField": "NeedReassessingAuthorization",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si une autorisation humaine est nécessaire pour réévaluer la classification.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Autorisation",
      "Path": "_mgt.ClassificationRule.NeedReassessingAuthorization",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.ClassificationRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.ClassificationRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.ClassificationRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.ClassificationRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.ClassificationRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "DisseminationRule",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule",
      "ApiField": "DisseminationRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "DisseminationRule",
      "Path": "_mgt.DisseminationRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.DisseminationRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.DisseminationRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.DisseminationRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.DisseminationRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.DisseminationRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.DisseminationRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.DisseminationRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.DisseminationRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "HoldRule",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule",
      "ApiField": "HoldRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "HoldRule",
      "Path": "_mgt.HoldRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.HoldRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.HoldRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.HoldRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.HoldRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.HoldRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "HoldEndDate",
      "SedaField": "HoldEndDate",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.HoldEndDate",
      "ApiField": "HoldEndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin de gel",
      "Path": "_mgt.HoldRule.Rules.HoldEndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "HoldOwner",
      "SedaField": "HoldOwner",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.HoldOwner",
      "ApiField": "HoldOwner",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Propriétaire de la demande de gel.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Propriétaire de la demande de gel",
      "Path": "_mgt.HoldRule.Rules.HoldOwner",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "HoldReason",
      "SedaField": "HoldReason",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.HoldReason",
      "ApiField": "HoldReason",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Motif de gel.",
      "Cardinality": "ONE",
      "Type": "TEXT",
      "Origin": "INTERNAL",
      "ShortName": "Motif de gel",
      "Path": "_mgt.HoldRule.Rules.HoldReason",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "HoldReassessingDate",
      "SedaField": "HoldReassessingDate",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.HoldReassessingDate",
      "ApiField": "HoldReassessingDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Date de réévaluation du gel.",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de réévaluation",
      "Path": "_mgt.HoldRule.Rules.HoldReassessingDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "PreventRearrangement",
      "SedaField": "PreventRearrangement",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.PreventRearrangement",
      "ApiField": "PreventRearrangement",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Blocage de la reclassification de l'ArchiveUnit lorsque la restriction de gel est effective.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Blocage de la reclassification.",
      "Path": "_mgt.HoldRule.Rules.PreventRearrangement",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.HoldRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.HoldRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.HoldRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "NeedAuthorization",
      "SedaField": "NeedAuthorization",
      "Collection": "Unit",
      "ApiPath": "#management.NeedAuthorization",
      "ApiField": "NeedAuthorization",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si une autorisation humaine est nécessaire pour vérifier ou valider les opérations de gestion des ArchiveUnit.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Autorisation",
      "Path": "_mgt.NeedAuthorization",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "ReuseRule",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule",
      "ApiField": "ReuseRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "ReuseRule",
      "Path": "_mgt.ReuseRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.ReuseRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.ReuseRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.ReuseRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.ReuseRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.ReuseRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.ReuseRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.ReuseRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.ReuseRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "StorageRule",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule",
      "ApiField": "StorageRule",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "StorageRule",
      "Path": "_mgt.StorageRule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "FinalAction",
      "SedaField": "FinalAction",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.FinalAction",
      "ApiField": "FinalAction",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Sort final",
      "Path": "_mgt.StorageRule.FinalAction",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Inheritance",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Inheritance",
      "ApiField": "Inheritance",
      "Category": "MANAGEMENT",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Inheritance",
      "Path": "_mgt.StorageRule.Inheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "PreventInheritance",
      "SedaField": "PreventInheritance",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Inheritance.PreventInheritance",
      "ApiField": "PreventInheritance",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json. Indique si les règles de gestion héritées des ArchiveUnit parents doivent être ignorées pour l'ArchiveUnit concerné.",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "Ignorer l'héritage",
      "Path": "_mgt.StorageRule.Inheritance.PreventInheritance",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "PreventRulesId",
      "SedaField": "RefNonRuleId",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Inheritance.PreventRulesId",
      "ApiField": "PreventRulesId",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Bloquer la règle",
      "Path": "_mgt.StorageRule.Inheritance.PreventRulesId",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "Rules",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Rules",
      "ApiField": "Rules",
      "Category": "MANAGEMENT",
      "Cardinality": "MANY",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "Rules",
      "Path": "_mgt.StorageRule.Rules",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ]
    },
    {
      "FieldName": "EndDate",
      "SedaField": "EndDate",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Rules.EndDate",
      "ApiField": "EndDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de fin",
      "Path": "_mgt.StorageRule.Rules.EndDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "Rule",
      "SedaField": "Rule",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Rules.Rule",
      "ApiField": "Rule",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Règle de gestion",
      "Path": "_mgt.StorageRule.Rules.Rule",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "StartDate",
      "SedaField": "StartDate",
      "Collection": "Unit",
      "ApiPath": "#management.StorageRule.Rules.StartDate",
      "ApiField": "StartDate",
      "Category": "MANAGEMENT",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "DATE",
      "Origin": "INTERNAL",
      "ShortName": "Date de début",
      "Path": "_mgt.StorageRule.Rules.StartDate",
      "SedaVersions": [
        "2.1",
        "2.2",
        "2.3"
      ],
      "TypeDetail": "DATETIME"
    },
    {
      "FieldName": "_min",
      "Collection": "Unit",
      "ApiPath": "#min",
      "ApiField": "#min",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Profondeur minimum de l’unité archivistique par rapport à une racine.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Profondeur minimale",
      "Path": "_min",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "_og",
      "Collection": "Unit",
      "ApiPath": "#object",
      "ApiField": "#object",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Identifiant du groupe d’objets représentant cette unité archivistique.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant du groupe d’objets",
      "Path": "_og",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_opi",
      "Collection": "Unit",
      "ApiPath": "#opi",
      "ApiField": "#opi",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Identifiant de l’opération à l’origine de la création de cette unité archivistique.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Opération initiale",
      "Path": "_opi",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_ops",
      "Collection": "Unit",
      "ApiPath": "#operations",
      "ApiField": "#operations",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Identifiants d’opérations auxquelles cette unité archivistique a participé.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Opérations",
      "Path": "_ops",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_opts",
      "Collection": "Unit",
      "ApiPath": "#opts",
      "ApiField": "#opts",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Identifiants de l’opération dans laquelle l'unité archivistique est en cours de transfert",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Opérations de transfert",
      "Path": "_opts",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_sedaVersion",
      "Collection": "Unit",
      "ApiPath": "#sedaVersion",
      "ApiField": "#sedaVersion",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "_sedaVersion",
      "Path": "_sedaVersion",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_sp",
      "SedaField": "OriginatingAgencyIdentifier",
      "Collection": "Unit",
      "ApiPath": "#originating_agency",
      "ApiField": "#originating_agency",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Service producteur d’origine déclaré lors de la prise en charge de l’unité archivistique par la solution logicielle Vitam.",
      "Cardinality": "ONE_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Service producteur responsable de l'entrée(*)",
      "Path": "_sp",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_sps",
      "Collection": "Unit",
      "ApiPath": "#originating_agencies",
      "ApiField": "#originating_agencies",
      "Category": "DESCRIPTION",
      "Description": "Mapping : unit-es-mapping.json. Services producteurs liés à l’unité archivistique suite à un rattachement et ayant des droits d’accès sur celle-ci.",
      "Cardinality": "MANY_REQUIRED",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Service(s) producteur(s) ayant des droits sur l'unité",
      "Path": "_sps",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_storage",
      "Collection": "Unit",
      "ApiPath": "#storage",
      "ApiField": "#storage",
      "Category": "OTHER",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_storage",
      "Path": "_storage"
    },
    {
      "FieldName": "_nbc",
      "Collection": "Unit",
      "ApiPath": "#storage.#nbc",
      "ApiField": "#nbc",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Nombre d’objets correspondant à un usage ou à un groupe d'objets.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Nombre d’objets",
      "Path": "_storage._nbc",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "offerIds",
      "Collection": "Unit",
      "ApiPath": "#storage.offerIds",
      "ApiField": "offerIds",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Deprecated.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "offerIds",
      "Path": "_storage.offerIds",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "strategyId",
      "Collection": "Unit",
      "ApiPath": "#storage.strategyId",
      "ApiField": "strategyId",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "strategyId",
      "Path": "_storage.strategyId",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_tenant",
      "Collection": "Unit",
      "ApiPath": "#tenant",
      "ApiField": "#tenant",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Identifiant du tenant.",
      "Cardinality": "ONE",
      "Type": "LONG",
      "Origin": "INTERNAL",
      "ShortName": "Tenant",
      "Path": "_tenant",
      "TypeDetail": "LONG"
    },
    {
      "FieldName": "_uds",
      "Collection": "Unit",
      "ApiPath": "#uds",
      "ApiField": "#uds",
      "Category": "OTHER",
      "Cardinality": "ONE",
      "Type": "OBJECT",
      "Origin": "INTERNAL",
      "ShortName": "_uds",
      "Path": "_uds"
    },
    {
      "FieldName": "_unitType",
      "Collection": "Unit",
      "ApiPath": "#unitType",
      "ApiField": "#unitType",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Type d’unité archivistique concerné : SIP, plan de classement, arbre de positionnement.",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Type d'unité archivistique",
      "Path": "_unitType",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_up",
      "Collection": "Unit",
      "ApiPath": "#unitups",
      "ApiField": "#unitups",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Pour une unité archivistique, identifiant(s) des unités archivistiques parentes (parents immédiats). Pour un groupe d'objets, identifiant(s) des unités archivistiques représentées par ce groupe d’objets.",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant(s) des unités archivistiques parentes (parents immédiats)",
      "Path": "_up",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_us",
      "Collection": "Unit",
      "ApiPath": "#allunitups",
      "ApiField": "#allunitups",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json. Tableau contenant la parentalité, c’est à dire l’ensemble des unités archivistiques parentes, indexé de la manière suivante : [ GUID1, GUID2, … ].",
      "Cardinality": "MANY",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Identifiant(s) des unités archivistiques parentes",
      "Path": "_us",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_validComputedInheritedRules",
      "Collection": "Unit",
      "ApiPath": "#validComputedInheritedRules",
      "ApiField": "#validComputedInheritedRules",
      "Category": "MANAGEMENT",
      "Description": "Indique si les règles calculées sont valides",
      "Cardinality": "ONE",
      "Type": "BOOLEAN",
      "Origin": "INTERNAL",
      "ShortName": "validComputedInheritedRules",
      "Path": "_validComputedInheritedRules",
      "TypeDetail": "BOOLEAN"
    },
    {
      "FieldName": "_batchId",
      "Collection": "Unit",
      "ApiPath": "#batchId",
      "ApiField": "#batchId",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json (collect-only)",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Collect batch identifier",
      "Path": "_batchId",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    },
    {
      "FieldName": "_uploadPath",
      "Collection": "Unit",
      "ApiPath": "#uploadPath",
      "ApiField": "#uploadPath",
      "Category": "OTHER",
      "Description": "Mapping : unit-es-mapping.json (collect-only)",
      "Cardinality": "ONE",
      "Type": "KEYWORD",
      "Origin": "INTERNAL",
      "ShortName": "Collect initial upload path",
      "Path": "_uploadPath",
      "StringSize": "MEDIUM",
      "TypeDetail": "STRING"
    }
  ]
  ```

[^1]: Pour plus de précisions, consulter la [section « Formalisation des vocabulaires du schéma » du présent document](#formalisation-des-vocabulaires-du-schema).

[^2]: Ces vocabulaires sont détaillés dans la documentation [Modèle de données](modele_de_donnees.md).

[^3]: Seule la collection Unit peut faire l’objet d’ajout de nouveaux vocabulaires. Il n’est pas possible d’étendre les autres collections.

[^4]: Le type d’indexation « GEO_POINT » n’est pas supporté dans le schéma.

[^5]: Pour plus d’informations sur la modélisation de cette collection, consulter le document [Modèle de données](./modele_de_donnees.md), chapitre « Collection Schema ».

[^6]: Le type d’indexation « GEO_POINT » n’est pas supporté dans le schéma.

[^7]: Pour plus d’informations sur le processus d’import du référentiel, consulter le document [Modèle de workflow](./modele_de_workflow.md), « Workflow d’administration d’un référentiel des vocabulaires du schéma ».

[^8]: Les règles propres au nommage d’un vocabulaire sont définies dans la [partie « Conseils de mise en œuvre » du présent document](#conseils-de-mise-en-œuvre).