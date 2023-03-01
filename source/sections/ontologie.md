Ontologie
=========

Documents de référence
----------------------

  **Document**                                                           **Date de la version**   **Remarques**
  NF Z 44022 – MEDONA - Modélisation des données pour l’archivage        18/01/2014               
  **Standard d’échange de données pour l’archivage – SEDA – v. 2.1**     06/2018                  
  **Vitam** – Structuration des *Submission Information Package* (SIP)   27/09/2021               
  **Vitam** – Profils d’unité archivistique                              27/09/2021               Ce document est complémentaire du présent document qui fait référence, ponctuellement, aux profils d’unité archivistique.
  **Vitam** – Documentation d’exploitation                               27/09/2021               

Présentation du document
------------------------

Le document présente les fonctionnalités associées à la prise en compte
de la notion d'ontologie dans la solution logicielle Vitam.

Il s’articule autour des axes suivants :

- une présentation de la notion d’ontologie ;

- une présentation de la manière dont la solution logicielle Vitam la
  formalise ;

- une présentation des mécanismes mis en œuvre dans la solution
  logicielle Vitam pour prendre en compte cette notion ;

- quelques conseils complémentaires de mise en œuvre.

Le présent document décrit les fonctionnalités qui sont offertes par la
solution logicielle Vitam au terme de la version 5.RC (septembre 2021).
Il a vocation a être amendé, complété et enrichi au fur et à mesure de
la réalisation de la solution logicielle Vitam et des retours et
commentaires formulés par les ministères porteurs et les partenaires du
programme.

Présentation de la notion d’ontologie
-------------------------------------

### Qu’est-ce qu’une ontologie ?


Ceci est une modification

L’ontologie référence l’**ensemble des vocabulaires** ou métadonnées
acceptés dans la solution logicielle Vitam. Pour chacun de ces
vocabulaires, elle définit un intitulé et un type d’indexation
particulier (par exemple : texte, décimal, entier), ainsi que la(les)
collection(s) de la solution logicielle Vitam qui l'(les)
utilise(nt)[^1].

Les éléments dans l'ontologie:![](./medias/Pictures/ontologie_image2.png)

L’ontologie se compose :

- des vocabulaires définis dans le Standard d’échanges de données pour
  l’archivage (SEDA), inclus par défaut. Ces vocabulaires
  correspondent aux éléments XML présents dans les messages du SEDA
  (ArchiveTransfer en particulier) ;

- des vocabulaires propres à la solution logicielle Vitam, inclus par
  défaut[^2] ;

- de vocabulaires non gérés par les deux précédents items et ajoutés
  pour répondre à un besoin particulier du service utilisateur, en
  particulier enrichir les descriptions, en entrée ou en accès.

Ces vocabulaires peuvent être utilisés pour décrire :

- 0 à n contexte(s) applicatif(s),

- 0 à n contrat(s) d’accès,

- 0 à n contrat(s) d’entrée,

- 0 à n contrat(s) de gestion,

- 0 à n entrée(s) dans le registre des fonds (fonds propres et
  symboliques, détail des fonds),

- 0 à n format(s),

- 0 à n griffon(s),

- 0 à n groupe(s) d’objets,

- 0 à n journal(ux) (opérations, cycles de vie),

- 0 à n profil(s) d’archivage,

- 0 à n profil(s) de sécurité,

- 0 à n profil(s) d’unité archivistique,

- 0 à n règle(s) de gestion,

- 0 à n scénario(s) de préservation,

- 0 à n service(s) agent(s),

- 0 à n unité(s) archivistique(s),

- 0 à n vocabulaire(s).

***Points d'attention :***

- les vocabulaires sont uniques dans la solution logicielle Vitam ;

- les vocabulaires utilisés par la solution logicielle Vitam de type
  « objet », c’est-à-dire ne contenant pas de valeurs
  informationnelles, ne sont pas référencés dans l’ontologie. Il peut
  s’agir de :
  
  - vocabulaires conformes au SEDA de type « objet », c'est-à-dire
    correspondant à un élément XML englobant un sous-élément XML
    (par exemple, Writer ou Management) ;

Exemple : ne sont pas présents dans l’ontologie les éléments XML <ManagementMetadata>, <StorageRule> et <AccessRule>. Les autres, qui contiennent des valeurs informationnelles, le sont.

```xml
<ManagementMetadata>
      <AcquisitionInformation>Versement</AcquisitionInformation>
      <LegalStatus>Public Archive</LegalStatus>
      <OriginatingAgencyIdentifier>RATP</OriginatingAgencyIdentifier>
      <SubmissionAgencyIdentifier>RATP</SubmissionAgencyIdentifier>
      <StorageRule>
           <FinalAction>Copy</FinalAction>
      </StorageRule>
      <AccessRule>
           <Rule>ACC-00002</Rule>
           <StartDate>2000-01-01</StartDate>
      </AccessRule>
 </ManagementMetadata>
```

- vocabulaires générés par la solution logicielle Vitam, correspondant
  à un élément JSON de type « objet ».

Exemple : ne sont pas présents dans l’ontologie les éléments JSON _mgt, AccessRule, Rules, CustodialHistory. Les autres, qui contiennent des valeurs informationnelles, le sont.

```xml
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
    }
```

En d’autres termes, l’ontologie **référence seulement les vocabulaires
pouvant contenir des valeurs** (ou métadonnées) quand ils sont utilisés.

### Pourquoi une ontologie ?

L’ontologie répond à plusieurs besoins :

- regrouper toutes les façons de nommer un même objet intellectuel et
  disposer d’une liste de l’ensemble des vocabulaires gérés nativement
  par la solution logicielle Vitam, précisant :
  
  - leur dénomination lorsqu’ils sont exposés via l’API externe
    (ex : \#originating\_agency),
  
  - leur dénomination interne au système (\_sp),
  
  - leur dénomination dans un bordereau de transfert conforme au
    SEDA (OriginatingAgencyIdentifier) ;

- éviter les conflits en interdisant la définition d’un nouveau
  vocabulaire avec le même identifiant et intitulé qu’un vocabulaire
  préexistant ;

- connaître le type d’indexation des différents vocabulaires proposé
  par défaut par la solution logicielle Vitam et, le cas échéant, s’il
  ne correspond pas aux choix d’implémentation, le modifier ;

- pour un profil d’unité archivistique, connaître les vocabulaires et
  leur type, afin de rédiger un profil conforme aux éléments indexés
  et gérés par la solution logicielle Vitam ;

- le cas échéant, ajouter des vocabulaires afin d’enrichir la
  description des unités archivistiques et/ou des groupes d’objets
  techniques[^3] ;

- éviter la multiplication des vocabulaires déclarés dans les profils
  d’unité archivistique faisant référence à une même entité ;

- attribuer un type d’indexation particulier pour chacun d’entre eux,
  et ainsi :
  
  - améliorer leur indexation dans le moteur de recherche Elastic
    Search et, de fait, procéder à des recherches plus fines selon
    leur type d’indexation,
  
  - contrôler les valeurs des unités archivistiques déclarant un
    profil d’unité archivistique, en entrée comme en accès.

Formalisation des vocabulaires ontologiques
-------------------------------------------

### Dans un fichier JSON

Un référentiel ontologique, ou ontologie, liste l’ensemble des
vocabulaires pouvant être utilisés par la solution logicielle Vitam. Ce
référentiel est importé sous la forme d’un fichier JSON, contenant
systématiquement l’ensemble des vocabulaires utilisés.

Exemple : deux vocabulaires contenant uniquement les informations obligatoires pour être importés avec succès.

```json
[
{
 "Identifier": "Vocabulaire1",
 "Type": "LONG"
 },
{
 "Identifier": "Vocabulaire2",
 "Type": "TEXT"
 }
]
```

Un vocabulaire donné doit nécessairement être décrit avec les
informations suivantes :

- identifiant devant être unique dans le fichier JSON (Identifier) ;

- type d'indexation du vocabulaire, correspondant à un type attendu
  par le moteur Elastic Search. Les valeurs acceptées sont : DATE,
  TEXT, KEYWORD, BOOLEAN, LONG, DOUBLE, GEO\_POINT, ENUM[^4] ;

Un nom (SedaField et/ou ApiField), une traduction (ShortName), une
description (Description), une origine (Origin) et une référence à des
collections utilisant le vocabulaire décrit (Collections), facultatifs,
peuvent venir compléter ces informations.

Les valeurs acceptées pour référencer une collection (Collections)
sont :

- pour les métadonnées : Unit, ObjectGroup ;

- pour le registre des fonds : AccessionRegisterSummary,
  AccessionRegisterDetail, AccessionRegisterSymbolic ;

- pour les référentiels : Context, SecurityProfile,
  ManagementContract, IngestContract, AccessContract, FileFormat,
  PreservationScenario, Griffin, FileRules, Agencies, Profile,
  ArchiveUnitProfile, Ontology ;

- pour les journaux : LogbookOperation, LogbookLifeCycleUnit,
  LogbookLifeCycleObjectGroup.

### Dans la solution logicielle Vitam

Les vocabulaires sont enregistrés dans la base de données MongoDB, dans
la collection « Ontology », sous la forme d’enregistrements au format
JSON.

Chaque enregistrement est modélisé comme suit[^5] :

| Champs                | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| \_id                  | **identifiant** unique, fourni par le système (champ obligatoire)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| Identifier            | **identifiant** unique dans l’ensemble du système (champ obligatoire).</br>- Pour les vocabulaires internes, cet identifiant correspond au nom de la métadonnée telle qu’elle est définie dans le modèle de données de la solution logicielle Vitam. </br>Pour un vocabulaire interne issu du SEDA, l’identifiant peut prendre deux formes différentes: </br>1. une dénomination interne au système (ex :\_sp, équivalent du bloc OriginatingAgencyIdentifier),</br> 2. une dénomination correspondant à la nomenclature du SEDA (ex : Tag) ;</br> -   Pour les vocabulaires externes, cet identifiant correspond au nom de la métadonnée telle qu'elle est nommée dans un bordereau de transfert ou dans un profil d'unité archivistique. |
| SedaField et ApiField | **nom** du vocabulaire : </br>-   tel qu’il est défini dans la nomenclature du SEDA (champ facultatif). Ce champ est utilisé uniquement pour les vocabulaires référençant une unité archivistique et un groupe d'objets ; </br>-   tel qu’il est retourné via le DSL (champ facultatif. Exemple : \#sp).                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| ShortName             | **traduction** du vocabulaire, explicitant de manière intelligible le nom du vocabulaire (champ facultatif).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
| Description           | **description** (champ facultatif).                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        |
| Type                  | **type d’indexation** du vocabulaire, correspondant à un type attendu par le moteur Elastic Search (champ obligatoire).</br> Les valeurs acceptées sont : DATE, TEXT, KEYWORD, BOOLEAN, LONG, DOUBLE, GEO\_POINT, ENUM[^6].                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                |
| Origin                | **origine** du vocabulaire, précisant la provenance du vocabulaire (champ facultatif). Sa valeur peut être égale à :</br>-   INTERNAL : pour les vocabulaires conformes au SEDA et les vocabulaires propres à la solution logicielle Vitam ;</br>-   EXTERNAL : pour les vocabulaires non gérés nativement par les deux précédents items et ajoutés pour répondre à un besoin particulier.                                                                                                                                                                                                                                                                                                                                                 |
| Collections           | **collection(s)** de la base de données MongoDB qui utilise(nt) le vocabulaire en question (champ facultatif). </br>   Les valeurs acceptées sont : </br>   -   pour les métadonnées : Unit, ObjectGroup ; </br>   -   pour le registre des fonds : AccessionRegisterSummary, AccessionRegisterDetail, AccessionRegisterSymbolic ; </br>   -   pour les référentiels : Context, SecurityProfile, ManagementContract, IngestContract, AccessContract, FileFormat, PreservationScenario, Griffin, FileRules, Agencies, Profile, ArchiveUnitProfile, Ontology ;</br>-   pour les journaux : LogbookOperation, LogbookLifeCycleUnit, LogbookLifeCycleObjectGroup.                                                                              |

### Dans le Standard d’échange de données pour l’archivage (SEDA)

L’ontologie reprend des éléments définis dans la norme NF Z 44‑022 et
dans sa déclinaison pour les acteurs du service public, le Standard
d’échanges de données pour l’archivage (SEDA).

Un bordereau de transfert utilise de fait les vocabulaires définis dans
l’ontologie de la solution logicielle Vitam.

La norme NF Z 44‑022 offre la possibilité d’ajouter des éléments
supplémentaires, appelés « extensions » :

- Des extensions dont la définition est obligatoire pour que le schéma
  soit valide (extensions par substitution, de type abstract). Sont
  concernés :

| **Bloc concerné**      | **Elément XML**                        | **Signification / usage**                                                                                                                                                                                                                                                                                              |
| ---------------------- | -------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| test                   | test                                   | test                                                                                                                                                                                                                                                                                                                   |
| Métadonnées techniques | \<OtherDimensionsAbstract\>            | Autres dimensions possibles pour un objet physique                                                                                                                                                                                                                                                                     |
| ^                      | \<OtherCoreTechnicalMetadataAbstract\> | Métadonnées techniques essentielles ne correspondant : </br> • ni à des fichiers de type texte, </br> • ni à des fichiers de type document, </br> • ni à des fichiers de type image, </br> • ni à des fichiers de type audio, </br> • ni à des fichiers de type vidéo </br> Ex. : bases de données, plans 2D, plans 3D |

  Métadonnées descriptives   &lt;ObjectGroupExtensionAbstract&gt;         Métadonnées descriptives complémentaires

                             <ArchiveUnitReferenceAbstract>         Requêtes permettant de gérer la récursivité et de pointer vers un objet-archives supposé être déjà géré par le SAE

  Métadonnées de gestion     &lt;OtherManagementAbstract&gt;              Autres métadonnées de gestion

  -------------------------- -------------------------------------------- --------------------------------------------------------------------------------------------------------------------

- Des extensions dont la définition n’est pas obligatoire pour que le
  schéma soit valide (extensions par redéfinition, de type OpenType).
  Leur type peut être défini selon les besoins des utilisateurs qui
  peuvent y mettre ce qu’ils veulent. Aucune vérification sur ces
  extensions ne pourra être faite lors des transactions tant que le
  type de ces extensions n’est pas défini. Sont concernés :
  
  ------------------------ --------------------------------------------- ------------------------------------------------------------------------------------------------------------------
  
  **Bloc concerné**        **Elément XML**                               **Signification / usage**
  Noyau du schéma (main)   &lt;OrganizationDescriptiveMetadataType&gt;   Métadonnées descriptives pour une organisation
  
                         <SignatureType>                         Signature utilisée lors des échanges de messages
  
  Métadonnées techniques   &lt;XXXTechnicalMetadataType&gt;              Métadonnées techniques essentielles correspondant à des fichiers de types texte, document, image, audio et vidéo
  
                         <DescriptiveTechnicalMetadataType>      Autres métadonnées techniques
  
  ------------------------ --------------------------------------------- ------------------------------------------------------------------------------------------------------------------

Ces extensions doivent être qualifiées d’origine « EXTERNAL » dans
l’ontologie.

1. []{#__RefHeading___Toc12966_582479276 .anchor}Mécanismes mis en
   œuvre dans la solution logicielle Vitam

La solution logicielle Vitam offre à un service d’archives ou à un
service externe plusieurs fonctionnalités lui permettant de mettre en
œuvre des vocabulaires ontologiques :

- en termes d’administration :
  
  - la **gestion d’un référentiel** appelé « Ontologie » ;
  
  - une vérification que les **profils d’unité archivistique** (ou
    documents type) **déclarent des vocabulaires conformément à leur
    référencement** dans l'ontologie ;

- en entrée du système :
  
  - une **vérification que les unités archivistiques** présentes
    dans le SIP et déclarant un profil d’unité archivistique **sont
    conformes à l’ontologie et à leur profil d’unité archivistique**
    (ou document type) ;
  
  - une **vérification que les unités archivistiques** présentes
    dans le SIP sont conformes à leur type d’indexation dans
    l’ontologie, si les vocabulaires qu’elles contiennent y sont
    référencés ;

- en accès, **une traduction et une indexation** propre à chaque
  vocabulaire, induisant des règles à suivre en recherche et lors de
  la mise à jour des unités archivistiques.
  
  1. []{#__RefHeading__11286_3501494021 .anchor}Administration de
     l'ontologie

La solution logicielle Vitam intègre une ontologie, administrable par un
utilisateur doté des droits adéquats (**administrateur fonctionnel et
administrateur technique**) et gérée dans une collection
particulière[^7].

Ce référentiel interne à la solution logicielle Vitam a pour vocation
d’être une copie locale d’un référentiel administré dans le front office
des plates-formes d’archivage implémentant cette dernière.

L'ontologie est multi-tenant. Elle est administrable et journalisée
depuis le **tenant d’administration**.

Il est possible de réaliser les opérations présentées ci-dessous.

1. []{#__RefHeading___Toc7737_1347383732 .anchor}Import de l’ontologie

La solution logicielle Vitam intègre une ontologie, **automatiquement
importée lors de l’initialisation de la plate-forme,** et comportant les
vocabulaires internes à la solution.

Il est possible d’importer l'ontologie sous la forme d’un fichier JSON,
fonctionnant en mode « esclave », depuis le tenant d’administration.
Cette opération peut s’effectuer depuis l’APP Ontologie de VitamUI.

Il s’agit d’une opération d’administration (« MASTERDATA »), tracée dans
le journal des opérations de la solution logicielle Vitam[^8].

1. []{#__RefHeading__11292_3501494021 .anchor}Modification de
   l'ontologie

La modification de l'ontologie est possible :

- au moyen des API et de l’IHM standard fournie avec la solution
  logicielle Vitam et s'effectue par un réimport complet de
  l'ontologie, en mode « annule et remplace ». De fait, la solution
  logicielle Vitam permet de :
  
  - ajouter un nouveau vocabulaire ;
  
  - modifier les informations associées à un vocabulaire ;
  
  - supprimer un vocabulaire ;

- depuis l’APP Ontologie de VitamUI. Cette dernière permet, depuis le
  tenant d’instance (ou tenant d’administration) de :
  
  - ajouter unitairement un nouveau vocabulaire ;
  
  - modifier unitairement les informations associées à un
    vocabulaire ;
  
  - supprimer unitairement un vocabulaire
  
  - ajouter, modifier et supprimer des vocabulaires depuis l’import
    de l’ontologie dans sa forme JSON.

Cette action provoque la création d’une nouvelle version du référentiel.
Elle fait l’objet d’une journalisation dans le journal des opérations
(opération d’administration de type « MASTERDATA »)[^9].

Au moyen d’un paramétrage technique, la solution logicielle Vitam permet
de paramétrer les possibilités de mise à jour de l’ontologie :

- elle peut interdire toute modification des vocabulaires internes,
  qui ont vocation à ne pas être modifiés ni surtout supprimés en
  production ;

- elle peut forcer la mise à jour des types d’indexation, sans tenir
  compte des règles prédéfinies[^10].

Au moyen d’un acte d’exploitation, elle permet en outre de modifier,
d’ajouter ou de supprimer les seuls vocabulaires internes[^11].

Pour un vocabulaire externe et, si le paramétrage de l’ontologie le
permet, pour un vocabulaire interne, les champs modifiables sont :

- le nom du vocabulaire :
  
  - tel qu'il est défini dans la nomenclature du SEDA (SedaField) ;
  
  - tel qu'il est retourné via le DSL (ApiField) ;

- la traduction du vocabulaire (ShortName) ;

- la description (Description) ;

- le type d'indexation du vocabulaire, correspondant à un type attendu
  par le moteur Elastic Search (Type). Les valeurs acceptées sont :
  DATE, TEXT, KEYWORD, BOOLEAN, LONG, DOUBLE, ENUM, GEO\_POINT[^12] ;

- l'origine du vocabulaire (Origin – facultatif). Les valeurs
  acceptées sont : INTERNAL, EXTERNAL ;

- la collection de la base de données MongoDB qui utilise le
  vocabulaire en question (Collections). Ce champ doit toujours
  contenir une référence à au moins une collection. Les valeurs
  acceptées sont Unit et/ou ObjectGroup[^13].

Lors de ce ré-import ou de cette mise à jour, l’opération peut aboutir
aux statuts suivants :

  ------------ ---------------------------------------------------------------------------------------------------------------------------

  **Statut**   **Motifs**

  Succès       Opération réalisée sans rencontrer de problèmes particuliers.

  Échec        Sans journalisation :

               – ré-import d’un référentiel sous la forme d’un fichier qui n’est pas au format JSON ;
    
               – import d’un référentiel dont au moins un des champs contient une injection HTML.
    
               Avec journalisation :
    
               – ajout d’un vocabulaire dont l’identifiant est déjà utilisé par un autre vocabulaire de l’ontologie ;
    
               – ajout d’un vocabulaire dont l’identifiant ne correspond pas aux règles imposées par la solution logicielle Vitam[^14] ;
    
               – incompatibilité entre le nouveau et l’ancien type d’indexation ;
    
               – suppression d’un vocabulaire utilisé dans un profil d’unité archivistique.

  ------------ ---------------------------------------------------------------------------------------------------------------------------

Les différentes versions du référentiel font l’objet d’une sauvegarde
sur les offres de stockage utilisées par la solution logicielle Vitam.

Ces opérations de modifications des types d’indexation doivent
obligatoirement être accompagnées d’un acte technique d’exploitation,
afin que la nouvelle indexation soit effective et prise en compte par le
moteur de recherche Elastic Search[^15].

1. []{#__RefHeading___Toc6287_1217828720 .anchor}Contrôle de
   l'ontologie sur les profils d’unité archivistique

Lors de la création ou de la mise à jour de profils d’unité
archivistique (ou documents type), la solution logicielle Vitam vérifie
que les profils d’unité archivistique déclarent des vocabulaires
existant dans l’ontologie.

L’import ou la mise à jour d’un profil d’unité archivistique peut
échouer pour les motifs suivants :

- le schéma de contrôle contient un vocabulaire inconnu de
  l’ontologie,

- le schéma de contrôle contient un vocabulaire de type « objet » que
  l’on a oublié de qualifier comme tel.

**Point d’attention :**

- La solution logicielle Vitam n’effectue pas de contrôle sur la
  conformité des vocabulaires par rapport à leur type d’indexation
  dans l’ontologie, lors de la création de profils d’unité
  archivistique. Néanmoins, il est obligatoire que le type du
  vocabulaire défini dans le schéma de contrôle corresponde au type
  d’indexation du vocabulaire tel qu’il est défini dans
  l’ontologie[^16].
  
  1. []{#__RefHeading__11296_3501494021 .anchor}Processus d’entrée

Dans le cadre du processus d’entrée d’un ensemble d’archives, suite à la
réception d’un message ArchiveTransfer du SEDA, parmi les tâches et
traitements internes qu’elle effectue, la solution logicielle Vitam
**vérifie que :**

- **les unités archivistiques déclarant un profil d’unité
  archivistique sont conformes**
  
  - **au type d’indexation défini dans l’ontologie pour l’ensemble
    des vocabulaires qu’elles contiennent,**
  
  - **au profil d’unité archivistique ;**

- **les unités archivistiques ne déclarant pas de profil d’unité
  archivistique sont conformes au type d’indexation défini dans
  l’ontologie pour les vocabulaires qu’elles contiennent et qui y sont
  référencés.**

Ce contrôle s’effectue lors du processus de contrôle et traitements des
unités archivistiques, avant les vérifications portant sur les règles de
classification et de gestion.

![](./medias/Pictures/ontologie_image3.png){width="5.905555555555556in"
height="3.60625in"}À la suite des différents contrôles effectués en
entrée, la solution logicielle Vitam enregistre les unités
archivistiques, ainsi que les métadonnées techniques associées à leurs
objets en base, en se conformant au type d’indexation défini pour elles
dans l’ontologie.

1. []{#__RefHeading___Toc12970_582479276 .anchor}Accès
   
   1. []{#__RefHeading___Toc7672_1347383732 .anchor}Affichage
      dynamique des traductions

L’ontologie contenant la traduction des différents vocabulaires
supportés par la solution logicielle Vitam, il est possible, en accès :

- d’utiliser ce référentiel comme un fichier de propriétés pour
  récupérer les traductions, plutôt que ce soit l’IHM qui porte ces
  informations. Ainsi, cela évitera de constater des absences de
  traduction des vocabulaires externes récemment créés ;

- d’utiliser et d’afficher la traduction des vocabulaires dans les
  IHM, rendue administrable dans ce référentiel, afin qu’un
  administrateur fonctionnel ait la possibilité de modifier les
  intitulés (ou traductions) de certains vocabulaires (par exemple,
  modifier « Description », traduction textuelle du bloc Description
  du SEDA, par « Présentation du contenu », terme issu de la norme
  ISAD/G, davantage usité par les archivistes).

À titre d’exemple, l’IHM de démonstration de la solution logicielle
Vitam dispose de vocabulaires écrits en dur dans l’IHM de démonstration.
Dès qu’on transfère un bordereau contenant des vocabulaires externes,
l’IHM ne les traduit pas. Il est alors nécessaire de demander un acte
d’exploitation en vue de corriger ces éléments.

1. []{#__RefHeading___Toc7674_1347383732 .anchor}Optimisation de la
   recherche![](./medias/Pictures/ontologie_image4.png){width="4.275in"
   height="3.93125in"}

L’ontologie définit les types d’indexation des différents vocabulaires,
sur lesquels il faut s’appuyer afin de pouvoir optimiser les modalités
de recherche.

1. []{#__RefHeading___Toc7676_1347383732 .anchor}Contrôle lors de la
   mise à jour des unités archivistiques

La solution logicielle Vitam permet en outre de modifier :

- les métadonnées d’une **unité archivistique déclarant un profil
  d’unité archivistique**, à la condition que l’unité archivistique
  reste conforme à ce profil d’unité archivistique et, de fait, aux
  vocabulaires définis dans le profil d’unité archivistique. Cette
  conformité vaut aussi bien pour les vocabulaires utilisés que pour
  les valeurs utilisées[^17]. Par exemple, un vocabulaire de type
  « entier » tel que « AgeDuCapitaine » ne peut être mis à jour pour
  inclure une valeur textuelle s’il est indexé comme entier ;

- les métadonnées d’une **unité archivistique ne déclarant pas de
  profil d’unité archivistique**.
  
  - Si le vocabulaire est enregistré dans l’ontologie, la solution
    logicielle Vitam vérifie que la mise à jour est conforme au type
    d’indexation du vocabulaire dans l’ontologie ;
  
  - Si le vocabulaire n’est pas référencé dans l’ontologie, il sera
    mis à jour et interprété comme une chaîne de caractères textuels
    répétable.
1. []{#__RefHeading___Toc6289_1217828720 .anchor}Conseils de mise en
   œuvre

À l’issue de cette première phase de réalisation de fonctionnalités
concernant l’ontologie, l’équipe projet Vitam est en mesure de fournir
quelques recommandations de mise en œuvre :

1. []{#__RefHeading___Toc12972_582479276 .anchor}Quand et comment créer
   une ontologie ?

La création d’une ontologie est un préalable à l’utilisation des
vocabulaires dans la solution logicielle Vitam. C’est pourquoi, lors de
l’installation de la solution logicielle Vitam, une ontologie est
initialisée par défaut. Elle contient l’ensemble des vocabulaires
supportés par la solution logicielle Vitam, c’est-à-dire des
vocabulaires internes. Leur type d’indexation est conforme à
l’indexation réalisée dans le moteur de recherche Elastic Search.

**Un administrateur fonctionnel n’a pas besoin, *a priori*, de créer une
ontologie**. Il s’agit d’un acte d’exploitation technique.

1. []{#__RefHeading___Toc12974_582479276 .anchor}Quand et comment créer
   un vocabulaire ?

La création d’un nouveau vocabulaire s’effectue :

- au moyen des l’API et de l’IHM standard fournie avec la solution
  logicielle Vitam, par un réimport complet du référentiel, auquel a
  été ajouté un vocabulaire supplémentaire, d’origine externe.

- depuis l’APP Ontologie de VitamUI, par :
  
  - la création unitaire d’un vocabulaire,
  
  - le réimport complet du référentiel, auquel a été ajouté un
    vocabulaire supplémentaire, d’origine externe.
    
    Cette action renvoie une nouvelle version du référentiel dans la
    solution logicielle Vitam.

**Cette opération s’effectue uniquement sur le tenant
d’administration.**

Elle obéit à des règles strictes :

- un nouveau vocabulaire doit obligatoirement avoir une **origine
  externe**, à moins de correspondre à un vocabulaire nécessaire à la
  mise à jour du modèle de données géré par la solution logicielle
  Vitam ou engendré par la publication d’une nouvelle version du
  SEDA ;

- un nouveau vocabulaire doit détenir un **identifiant** :
  
  - unique,
  
  - ne commençant pas par un underscore (par exemple \_bibref) ou un
    dièse (\#bibref), qui sont des caractères réservés par la
    solution logicielle Vitam,
  
  - ne contenant pas d’espace,
  
  - étant insensible à la casse (il ne peut y avoir un nouveau
    vocabulaire intitulé « identifier » si un vocabulaire intitulé
    « Identifier » existe déjà dans l’ontologie) ;

- un nouveau vocabulaire doit être obligatoirement associé à, au
  moins, une **collection**. S’il s’agit d’un vocabulaire externe,
  créé pour répondre à des besoins liés à l’entrée (par exemple, ajout
  d’extensions dans le bordereau de transfert), la collection à
  renseigner doit être :
  
  - soit Unit si on ajoute des métadonnées descriptives aux unités
    archivistiques,
  
  - soit ObjectGroup si on étend les métadonnées liées au groupe
    d’objets techniques ;

- un nouveau vocabulaire doit nécessairement avoir un **type
  d’indexation**. Les types d’indexation pris en charge par la
  solution logicielle Vitam sont :
  
  -------------------------------- ------------------- ------------------------------------------------------------------- ------------------------------------------------------------------------------------
  
  **Type d’indexation initiale**   **Signification**   **Valeur correspondante**                                           **Commentaires**
  
  TEXT                             Texte               Paris, anciennement appelée Lutèce, est la capitale de la France.   La recherche sur un vocabulaire de type TEXT est effectuée en mode « full text ».
  
  KEYWORD                          Mot-clé             Paris \[Ville\]                                                     La recherche sur un vocabulaire de type KEYWORD correspond à une recherche exacte.
  
  DATE                             Date                2016-10-12T16:28:40                                                 
  
                                                     2018-06-06                                                          
  
  LONG                             Entier              9999                                                                
  
  DOUBLE                           Décimal             1.1111111                                                           
  
                                                     20.00001                                                            
      
                                                     3.0                                                                 
  
  BOOLEAN                          Booléen             true                                                                
  
                                                     false                                                               
  
  GEO\_POINT                       Géolocalisation     /                                                                   L’équipe Vitam n’a pas investigué sur les usages de ces deux types d’indexation.
  
  ENUM                             Énumération         /                                                                   
  
  -------------------------------- ------------------- ------------------------------------------------------------------- ------------------------------------------------------------------------------------

**Points d’attention :**

- Un élément de type objet ne doit pas être référencé dans
  l’ontologie[^18].

- L’indexation de ce nouveau vocabulaire dans le moteur de recherche
  Elastic Search correspond par défaut à un type TEXT (= texte). Si le
  type d’indexation du nouveau vocabulaire diffère, il est obligatoire
  de procéder à un acte d’exploitation technique visant à mettre en
  cohérence l’indexation du vocabulaire dans le moteur de recherche
  Elastic Search par rapport à l’ontologie[^19].

- Seules les collections Unit et ObjectGroup peuvent faire l’objet
  d’ajout de nouveaux vocabulaires. Il n’est pas possible d’étendre
  les autres collections.

La création d’un nouveau vocabulaire n’est pas un acte anodin. Avant de
procéder à sa création, il est recommandé de prendre en considération
les éléments suivants :

- est-ce qu’un vocabulaire existant peut couvrir le même champ
  sémantique et signifiant que le vocabulaire que l’on souhaite
  ajouter dans l’ontologie ?

- peut-on envisager une utilisation possible de ce nouveau vocabulaire
  pour un autre domaine d’utilisation ?
  
  Par exemple, on souhaite utiliser un vocabulaire permettant de gérer
  un titre de recette.
  
  - veut-on créer un vocabulaire « SommeTitreDeRecette » qui ne sera
    utilisable que dans un contexte particulier de recette ?
  
  - ou veut-on créer un vocabulaire qui sera plus générique, afin de
    l’utiliser dans un contexte plus large ? Dans ce cas précis, on
    pourrait choisir d’intituler le vocabulaire « Somme », afin de
    l’utiliser pour des titres de recette, mais aussi pour qualifier
    une dépense, le coût de frais de déplacement, une somme à payer
    indiquée dans les bulletins de salaire, etc.

- a-t-on besoin d’ajouter ce nouveau vocabulaire ? Pour quels usages ?

Pour créer un nouveau vocabulaire, il est recommandé de suivre les
étapes suivantes :

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------ ----------------------------

  **Qui ?**                                    **Quoi ?**                                                                                                                     **Via l’IHM démo Vitam ?**
  Administrateur fonctionnel                   émet le souhait d’ajouter un nouveau vocabulaire, **externe**, dans l’ontologie                                                Non
  Administrateur fonctionnel                   vérifie au préalable si ce nouveau vocabulaire n’existe pas ou si un vocabulaire préexistant ne correspond pas à son besoin.   Oui
  Administrateur fonctionnel et/ou technique   ajoute le nouveau vocabulaire dans l’ontologie.                                                                                Non
  Administrateur fonctionnel et/ou technique   met à jour l’ontologie sur le tenant d’administration.                                                                         Oui
  Administrateur technique                     Indexe le nouveau vocabulaire dans le moteur de recherche Elastic Search.                                                      Non

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------ ----------------------------

1. []{#__RefHeading___Toc12976_582479276 .anchor}Quand et comment
   modifier un type d’indexation ?

La mise à jour du type d’indexation d’un vocabulaire s’effectue, depuis
le tenant d’administration :

- de l’IHM standard par un réimport complet du référentiel, après
  avoir modifié le type d’indexation d’un à plusieurs vocabulaires ;

- de VitamUI, dans l’APP Ontologie, par :
  
  - la mise à jour unitaire d’un vocabulaire,
  
  - le réimport complet du référentiel, après avoir modifié le type
    d’indexation d’un à plusieurs vocabulaires.

Cette modification doit **obligatoirement** être suivie d’un acte
technique d’exploitation en vue de la rendre effective dans le moteur de
recherche Elastic Search[^20].

La modification du type d’indexation n’est pas un acte anodin. Elle peut
entraîner :

- des incohérences d’indexation si elle n’est pas mûrement réfléchie,

- une réindexation totale de la base de données, voire nécessiter des
  actions de migration et de sauvegarde.

La solution logicielle Vitam supporte les modifications suivantes :

  -------------------------------- ----------------------------- ---------------------------------- -----------------------------------

  **Type d’indexation initiale**   **Compatibilité supportée**   **Compatibilité non supportée,**   **Compatibilité non recommandée**

                                                                 **mais possible**                  

  TEXT                             KEYWORD                       DATE[^21]                          LONG, DOUBLE, BOOLEAN

  KEYWORD                          TEXT                          DATE[^22]                          /

  DATE                             TEXT, KEYWORD                 **/**                              **/**

  LONG                             /                             DOUBLE[^23]                        TEXT, KEYWORD

  DOUBLE                           /                             LONG[^24]                          TEXT, KEYWORD

  BOOLEAN                          /                             /                                  TEXT, KEYWORD

  GEO\_POINT                       TEXT, KEYWORD                 /                                  /

  ENUM                             TEXT, KEYWORD                 /                                  /

  -------------------------------- ----------------------------- ---------------------------------- -----------------------------------

Certaines modifications ne sont pas supportées, mais restent possibles
(3^e^ colonne du tableau ci-dessus), après analyse des données. En
effet, si les données en base sont conformes au type que l’on souhaite
leur attribuer, par exemple des données identifiées comme textuelles
sont en fait des dates, il est possible d’envisager la mise à jour du
vocabulaire pour passer d’un type TEXT à un type DATE.

En revanche, il n’est pas cohérent de modifier des valeurs initialement
identifiées comme des entiers par un type d’indexation TEXT. C’est
pourquoi, il n’est pas recommandé de procéder à des modifications de ce
type, sauf si le vocabulaire en question vient d’être initialisé et
qu’aucune donnée ne l’utilise.

La mise à jour du type d’indexation d’un vocabulaire doit nécessairement
être effectuée de concert avec un administrateur technique.

Pour modifier un type d’indexation, il est recommandé de suivre les
étapes suivantes :

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------ ----------------------------

  **Qui ?**                                    **Quoi ?**                                                                                                                                 **Via l’IHM démo Vitam ?**

  Administrateur fonctionnel et/ou technique   émet le souhait de modifier un type d’indexation dans l’ontologie.                                                                         Non

  Administrateur technique                     vérifie au préalable si ce nouveau type d’indexation est compatible avec le précédent type d’indexation du vocabulaire dans l’ontologie.   Oui

  Administrateur fonctionnel et/ou technique   met à jour le type d’indexation dans l’ontologie.                                                                                          Non

  **Compatibilité supportée**

  Administrateur fonctionnel et/ou technique   si le nouveau type d’indexation a une compatibilité supportée, met à jour l’ontologie sur le tenant d’administration.                      Oui

  Administrateur technique                     indexe le nouveau vocabulaire dans le moteur de recherche Elastic Search.                                                                  Non

  **Compatibilité non supportée**

  Administrateur technique                     – arrête pour un temps donné les traitements en cours (en entrée comme en accès) dans la solution logicielle Vitam.                        Non

                                               – procède à une réindexation de la base de données et du moteur de recherche Elastic Search pour intégrer le nouveau type d’indexation     

  Administrateur technique                     met à jour l’ontologie sur le tenant d’administration.                                                                                     Oui

  Administrateur technique                     rétablit les traitements et accès dans la solution logicielle Vitam.                                                                       Non

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------ ----------------------------

1. []{#__RefHeading___Toc12978_582479276 .anchor}Quels sont les types
   d’indexation compatibles entre un profil d’unité archivistique et
   des vocabulaires ontologiques ?

La solution logicielle Vitam n’effectue pas de contrôles de conformité
entre un vocabulaire défini dans l’ontologie et la manière dont il est
décrit dans un profil d’unité archivistique au moment de la création de
celui-ci.

Mais elle effectue des contrôles en entrée et à la mise à jour des
unités archivistiques, ce qui rend nécessaire de maintenir une cohérence
entre les types définis dans l’ontologie et ceux définis dans un profil
d’unité archivistique.

De fait, en fonction de son type d’indexation, il est fortement
recommandé de décrire un vocabulaire dans un schéma de contrôle avec les
types suivants[^25] :

  ---------------------------------------- ------------------------------------------ --------------------------------- ----------------------------------------------------------------------------------

  **Type d’indexation dans l’ontologie**   **Type correspondant**                     **Commentaires**

                                           **dans un profil d’unité archivistique**   
    
                                           **Vocabulaire interne**                    **Vocabulaire externe**

  TEXT                                     string ou \[string\]                       \[string\]

  KEYWORD                                  string ou \[string\]                       \[string\]

  DATE                                     string ou \[string\] + pattern date        \[string\] + pattern date

  LONG                                     number ou integer                          \[number\] ou \[integer\]

                                           \[number\] ou \[integer\]                  

  DOUBLE                                   number ou \[number\]                       \[number\]

  BOOLEAN                                  boolean ou \[boolean\]                     \[boolean\]

  GEO\_POINT                               string                                     \[string\]

  ENUM                                     \[string\] + pattern énumératif            \[string\] + pattern énumératif

  ---------------------------------------- ------------------------------------------ --------------------------------- ----------------------------------------------------------------------------------

1. []{#__RefHeading___Toc12980_582479276 .anchor}Quand et comment
   supprimer un vocabulaire ?

La suppression d’un vocabulaire s’effectue :

- depuis l’IHM standard et les API, par un réimport complet du
  référentiel, duquel a été supprimé ce vocabulaire ;

- depuis l’APP Ontologie de VitamUI, par :
  
  - la suppression unitaire d’un vocabulaire,
  
  - le réimport complet du référentiel, duquel a été supprimé ce
    vocabulaire .

Cet acte n’est pas anodin. Avant de procéder à cette suppression, il est
recommandé de vérifier les éléments suivants :

- le vocabulaire devant être supprimé doit obligatoirement être un
  vocabulaire d’origine externe, à moins de correspondre à un
  vocabulaire supprimé à l’occasion d’une mise à jour du modèle de
  données géré par la solution logicielle Vitam ou la publication
  d’une nouvelle version du SEDA ;

- le vocabulaire ne doit pas être utilisé en base de données et
  contenir des valeurs enregistrées en base de données ;

- le vocabulaire ne doit pas être utilisé dans un profil d’unité
  archivistique.

**Point d’attention :** la suppression d’un vocabulaire doit être
accompagnée d’un acte d’exploitation technique visant à supprimer
l’indexation du vocabulaire concerné dans le moteur de recherche Elastic
Search, sans quoi le vocabulaire ne sera pas complètement supprimé de la
solution logicielle Vitam[^26].

Pour supprimer vocabulaire, il est recommandé de suivre les étapes
suivantes :

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------------

  **Qui ?**                                    **Quoi ?**                                                                                                                                                                      **Via l’IHM démo Vitam ?**

  Administrateur fonctionnel                   émet le souhait de supprimer un vocabulaire, **externe**, dans l’ontologie.                                                                                                     Non

  Administrateur fonctionnel                   vérifie au préalable si ce vocabulaire n’est pas utilisé par une unité archivistique ou un profil d’unité archivistique ;                                                       Oui

                                               -   si ce vocabulaire est utilisé par des unités archivistiques, procède à une mise à jour de ces unités archivistiques, afin de modifier l’utilisation ;                       
    
                                               -   si ce vocabulaire est utilisé par un profil d’unité archivistique, ôter la référence au profil d’unité archivistique dans l’(les) unité(s) archivistique(s) concernée(s).   

  Administrateur fonctionnel et/ou technique   – vérifient qu’aucun traitement en cours (en entrée comme en accès) n’utilise le vocabulaire à supprimer ;                                                                      Oui / Non

                                               – le cas échéant, arrêtent pour un temps donné les traitements en cours (en entrée comme en accès) dans la solution logicielle Vitam.                                           

  Administrateur fonctionnel et/ou technique   supprime le vocabulaire dans l’ontologie.                                                                                                                                       Non

  Administrateur fonctionnel et/ou technique   met à jour l’ontologie sur le tenant d’administration.                                                                                                                          Oui

  Administrateur technique                     supprime l’indexation du vocabulaire dans le moteur de recherche Elastic Search.                                                                                                Non

  Administrateur fonctionnel et/ou technique   rétablissent les traitements en cours (en entrée comme en accès).                                                                                                               Oui / Non

  -------------------------------------------- ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ----------------------------

1. []{#__RefHeading___Toc4666_549432207 .anchor}Comment mettre à jour
   une unité archivistique associée ou non à un profil d’unité
   archivistique ?

Les métadonnées d’une unité archivistique déclarant un profil d’unité
archivistique sont modifiables, à la condition que l’unité archivistique
reste conforme à ce profil d’unité archivistique et, de fait, aux
vocabulaires définis dans le profil d’unité archivistique. Cette
conformité vaut aussi bien pour les vocabulaires utilisés que pour les
valeurs utilisées. En d’autres termes :

- le vocabulaire utilisé, mis à jour ou ajouté, doit être présent dans
  le profil d’unité archivistique associé à l’unité archivistique ;

- la nouvelle valeur doit être conforme au type d’indexation défini
  pour le vocabulaire auquel elle est associée.

Les métadonnées d’une unité archivistique ne déclarant pas de profil
d’unité archivistique sont modifiables à condition que la nouvelle
valeur soit conforme au type d’indexation défini pour le vocabulaire
auquel elle est associée.

  -------------------------------- ----------------------- ------ -------- --------- --------- -------------

  **Type d’indexation initiale**   **Valeurs acceptées**
                                   Texte
  TEXT                             oui
  KEYWORD                          oui
  DATE                             oui
  LONG                             
  DOUBLE                           
  BOOLEAN                          
  GEO\_POINT                       oui
  ENUM                             oui

  -------------------------------- ----------------------- ------ -------- --------- --------- -------------

[]{#__RefHeading___Toc12984_582479276 .anchor}**Point d’attention :**
l’enregistrement des vocabulaires dans la base de données Mongo diffère,
selon que le vocabulaire est de type TEXT, KEYWORD, DATE, GEO\_POINT,
ENUM ou de type LONG, DOUBLE, BOOLEAN :

- []{#__RefHeading___Toc12986_582479276 .anchor}dans le premier cas,
  les valeurs sont enregistrées entre des *double quotes*
  (guillemets),

- []{#__RefHeading___Toc12988_582479276 .anchor}dans le second cas,
  les valeurs ne sont pas signalées par des *double quotes*
  (guillemets).

Il est recommandé d’utiliser ces vocabulaires conformément à leur type
d’indexation. Si ce n’est pas le cas (par exemple, on renseigne
systématiquement des valeurs booléennes en utilisant un vocabulaire
indexé comme texte), mieux vaut choisir une autre indexation pour le
vocabulaire en question.

[]{#__RefHeading___Toc12990_582479276 .anchor}Dans le cas d’une
réindexation a posteriori des vocabulaires, cela peut engendrer des
conflits.

1. []{#__RefHeading___Toc10433_666097311 .anchor}Quand et comment
   modifier des vocabulaires internes ?

La solution logicielle Vitam permet d’ajouter, de modifier ou de
supprimer des vocabulaires internes, de transformer des vocabulaires
externes en vocabulaires internes, de modifier leur indexation par un
réimport complet du référentiel au moyen d’un **acte d’exploitation**,
ou suite à une procédure de montée de version de la solution logicielle
VITAM. L’import de l’ontologie à cet étape ne remet pas à jour les
vocabulaires externes et veille à ce que cet import réussisse sans
conflits entre les deux vocabulaires internes et externes [^27]. [^28].
En d’autres termes, cet acte ne met à jour que les vocabulaires internes
et pas les vocabulaires externes.

Cette procédure d’exploitation peut avoir lieu dans les cas suivants :

- lors d’une montée de version du modèle de données interne à la
  solution logicielle Vitam,

- lors d’une mise à jour du SEDA, qui décrit les unités archivistiques
  et les groupes d’objets techniques.

Elle obéit aux mêmes règles strictes que celles relatives aux
vocabulaires externes[^29].

***Point d’attention :*** Suite à un import par acte d’exploitation ou
par procédure de montée de version une phase préliminaire permet de
vérifier d’éventuelles incohérences entre les vocabulaires internes et
les vocabulaires externes. En cas de présence d’erreurs, il reviendra à
l’exploitant de les analyser et de les corriger avant de procéder à la
montée de version de l’ontologie[^30].

1. []{#__RefHeading___Toc12992_582479276 .anchor}Quel accès à
   l’ontologie ?
   
   1. []{#__RefHeading___Toc12994_582479276 .anchor}Gestion des droits

La gestion de l’ontologie relève d’opérations d’administration
technico-fonctionnelle. Il est donc recommandé d’en limiter l’accès de
la manière suivante :

- des administrateurs fonctionnel et technique peuvent avoir accès à
  l’ontologie et la mettre à jour (Create, Read, Update, Delete) ;

- seul un administrateur technique a vocation à gérer la mise à jour
  des types d’indexation et leur mise en cohérence avec le moteur de
  recherche Elastic Search ;

- un tiers n’a pas vocation à prendre connaissance de l’ensemble de
  l’ontologie, mais peut avoir accès aux vocabulaires utilisés lors
  d’un transfert et avec des profils d’unité archivistique, à savoir
  les vocabulaires internes issus du SEDA et les vocabulaires externes
  créés pour des besoins de transfert particuliers (Read).
  
  1. []{#__RefHeading___Toc35927_1590522192 .anchor}Restitution sur
     une IHM

La solution logicielle Vitam propose une IHM pour représenter
l’ontologie.

Étant donné les liens étroits de l’ontologie avec les profils d’unité
archivistique, il est possible d’envisager d’associer pour chaque
vocabulaire la liste des profils d’unité archivistique l’utilisant.

1. []{#__RefHeading___Toc12996_582479276 .anchor}Comment utiliser
   l’ontologie ?
   
   ------------------------------------------------------------------------------------------------------------ --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------------------------
   
   **Intitulé**                                                                                                 **Description**                                                                                                                                                                                                                                                                               **Niveau de recommandation**
   
   **Administration de l’ontologie**
   
   Import ou modification de l’ontologie                                                                        Les opérations d’import et de mise à jour de l’ontologie s’effectuent obligatoirement sur le tenant d’administration.                                                                                                                                                                         Obligatoire
   
                                                                                                              L’indexation des vocabulaires dans le moteur de recherche Elastic Search se fait tenant par tenant.                                                                                                                                                                                           
   
   Import initial de l’ontologie                                                                                Il est obligatoire d’importer l’ontologie lors de l’installation de la solution logicielle Vitam.                                                                                                                                                                                             Obligatoire
   
                                                                                                              Cette ontologie, fournie avec la solution logicielle Vitam, inclut par défaut l’ensemble des vocabulaires internes gérés par la solution.                                                                                                                                                     
   
   Ajout d’un vocabulaire externe                                                                               La solution logicielle Vitam rend possible l’ajout d’un vocabulaire externe par un renvoi complet de l’ontologie depuis le tenant d’administration.                                                                                                                                           Recommandé
   
                                                                                                              Il peut s’agir d’un acte d’administration fonctionnelle, qui doit néanmoins être accompagné d’un acte d’exploitation visant à réindexer le nouveau vocabulaire dans le moteur de recherche Elastic Search.                                                                                    
       
                                                                                                              Il faut veiller à ce que le vocabulaire présent dans l’ontologie et les mappings du moteur de recherche Elastic Search soient cohérents.                                                                                                                                                      
       
                                                                                                              Exemple : si j’ajoute un vocabulaire sur les unités archivistiques, le mapping de la collection Unit Elastic Search devra être mise à jour.                                                                                                                                                   
   
   Ajout d’un vocabulaire interne pour évolution du modèle de données ou évolution du SEDA                      La solution logicielle Vitam rend possible l’ajout d’un vocabulaire interne au moyen d’un acte d’exploitation, qui permet en outre de ne pas mettre à jour les vocabulaires externes du référentiel.                                                                                          Recommandé
   
                                                                                                              Cette opération ne peut avoir lieu qu’à deux occasions :                                                                                                                                                                                                                                      
       
                                                                                                              -   évolution du modèle de données de la solution logicielle Vitam,                                                                                                                                                                                                                           
       
                                                                                                              -   publication d’une nouvelle version du SEDA.                                                                                                                                                                                                                                               
       
                                                                                                              Elle est alors initiée et réalisée par un administrateur technique, car elle nécessite en plus un acte d’exploitation technique sur le moteur de recherche Elastic Search (réindexation).                                                                                                     
       
                                                                                                              En dehors de ces deux cas, il n’est pas recommandé d’ajouter un vocabulaire interne.                                                                                                                                                                                                          
   
   Modification de l’identifiant des vocabulaires internes                                                      Selon son paramétrage, la solution logicielle Vitam permet de modifier les vocabulaires internes de l’ontologie.                                                                                                                                                                              Interdit
   
                                                                                                              Néanmoins, il est interdit de modifier leur identifiant.                                                                                                                                                                                                                                      
   
   Modification du type d’indexation des vocabulaires internes par un administrateur fonctionnel                Selon son paramétrage, la solution logicielle Vitam permet de modifier le type d’indexation des vocabulaires internes de l’ontologie.                                                                                                                                                         Non recommandé
   
                                                                                                              Néanmoins, cette action pouvant avoir un impact sur l’indexation des enregistrements en base de données et devant être accompagnée d’un acte d’exploitation pour être effective, il n’est pas recommandé qu’un administrateur fonctionnel seul l’effectue.                                    
   
   Modification du type d’indexation des vocabulaires internes par un administrateur technique                  Selon son paramétrage, la solution logicielle Vitam permet de modifier le type d’indexation des vocabulaires internes de l’ontologie.                                                                                                                                                         Recommandé
   
                                                                                                              Mais cette action peut avoir un impact sur l’indexation des enregistrements en base de données et doit être accompagnée d’un acte d’exploitation pour être effective.                                                                                                                         
       
                                                                                                              Il est recommandé que cet acte soit effectué par un administrateur technique, en accord avec un administrateur fonctionnel.                                                                                                                                                                   
   
   Modification du type d’indexation des vocabulaires externes par un administrateur fonctionnel                La modification du type d’indexation des vocabulaires externes est possible, mais obéit à des règles précises.                                                                                                                                                                                Non recommandé
   
                                                                                                              Cette action pouvant avoir un impact sur l’indexation des enregistrements en base de données et devant être accompagnée d’un acte d’exploitation pour être effective, il n’est pas recommandé qu’un administrateur fonctionnel seul l’effectue.                                               
   
   Suppression d’un vocabulaire externe inutilisé par un profil d’unité archivistique                           Si un vocabulaire externe n’est pas utilisé par un profil d’unité archivistique, il est possible de le supprimer de l’ontologie.                                                                                                                                                              Possible
   
                                                                                                              *Point d’attention :* il est ensuite nécessaire de procéder à une suppression de ce vocabulaire dans le moteur de recherche Elastic Search au moyen d’une opération technique d’exploitation                                                                                                  
   
   Paramétrage d’interdiction de la Suppression d’un vocabulaire interne par un administrateur fonctionnel      La solution logicielle Vitam rend possible la suppression d’un vocabulaire interne au moyen d’un paramétrage visant à forcer cette suppression.                                                                                                                                               Recommandé
   
                                                                                                              Néanmoins, il est recommandé d’activer le paramétrage technique interdisant cette suppression. En effet, un vocabulaire interne n’a pas vocation a être supprimé en production.                                                                                                               
   
   Suppression d’un vocabulaire interne par un administrateur fonctionnel                                       Il est interdit de supprimer un vocabulaire interne.                                                                                                                                                                                                                                          Interdit
   
   Suppression d’un vocabulaire interne pour évolution du modèle de données ou évolution du SEDA                La solution logicielle Vitam rend possible la suppression d’un vocabulaire interne au moyen d’un paramétrage visant à forcer cette suppression, qui permet en outre de ne pas mettre à jour les vocabulaires externes du référentiel.                                                         Recommandé
   
                                                                                                              Cette opération ne peut avoir lieu qu’à deux occasions :                                                                                                                                                                                                                                      
       
                                                                                                              -   évolution du modèle de données de la solution logicielle Vitam,                                                                                                                                                                                                                           
       
                                                                                                              -   publication d’une nouvelle version du SEDA.                                                                                                                                                                                                                                               
       
                                                                                                              Elle est alors initiée et réalisée par un administrateur technique, car elle nécessite un acte d’exploitation technique sur le moteur de recherche Elastic Search (réindexation).                                                                                                             
       
                                                                                                              En dehors de ces deux cas, il n’est pas recommandé de supprimer un vocabulaire interne.                                                                                                                                                                                                       
   
   Suppression d’un vocabulaire externe utilisé par un profil d’unité archivistique                             Si un vocabulaire externe est utilisé par un profil d’unité archivistique, il est interdit de le supprimer de l’ontologie.                                                                                                                                                                    Interdit
   
   Suppression d’un vocabulaire externe utilisé par un profil d’unité archivistique                             Si un vocabulaire externe est utilisé par un profil d’unité archivistique, la solution logicielle Vitam ne permet pas de le supprimer de l’ontologie.                                                                                                                                         Recommandé
   
                                                                                                              Si l’on souhaite vraiment le supprimer, il est alors conseiller de procéder comme suit :                                                                                                                                                                                                      
       
                                                                                                              -   vérifier que le profil d’unité archivistique n’est pas utilisé par des unités archivistiques ;                                                                                                                                                                                            
       
                                                                                                              -   le cas échéant, modifier le profil d’unité archivistique déclaré par ces unités archivistiques, l’objectif étant que le profil d’unité archivistique ne soit plus utilisé en accès ;                                                                                                      
       
                                                                                                              -   modifier le profil d’unité archivistique et supprimer le vocabulaire externe ;                                                                                                                                                                                                            
       
                                                                                                              -   supprimer le vocabulaire externe de l’ontologie.                                                                                                                                                                                                                                          

  **Entrée**

  Transfert d’un SIP déclarant un profil d’unité archivistique et contenant des vocabulaires externes          Le transfert d’un SIP déclarant un profil d’unité archivistique et comportant des extensions au SEDA nécessite en préalable les opérations suivantes :                                                                                                                                        Obligatoire

                                                                                                               -   création des vocabulaires externes correspondant à ces extensions,                                                                                                                                                                                                                        
    
                                                                                                               -   création du profil d’unité archivistique.                                                                                                                                                                                                                                                 

  Transfert d’un SIP ne déclarant pas de profil d’unité archivistique et contenant des vocabulaires externes   La solution logicielle Vitam autorise le transfert de bordereau contenant des extensions au SEDA. Ces extensions sont alors automatiquement indexées sous un type TEXT et peuvent *a posteriori* entrer en conflit avec des vocabulaires externes de l’ontologie.                             Recommandé

                                                                                                               Avant un transfert de bordereau contenant des extensions, il est fortement recommandé de créer les vocabulaires correspondant dans l’ontologie.                                                                                                                                               

  **Accès**

  Modification des traductions des vocabulaires internes                                                       L’ontologie permet de gérer une traduction explicite des vocabulaires internes. La solution logicielle Vitam est livrée avec une traduction par défaut, notamment reprise du SEDA pour les vocabulaires issus du standard.                                                                    Recommandé

                                                                                                               Afin de rendre intelligible ces vocabulaires par les futurs utilisateurs de la solution logicielle Vitam, il est recommandé de modifier ces vocabulaires (par exemple, traduire « Description » non pas par « Description », mais par « Présentation du contenu »).                           

  Utilisation de l’ontologie pour afficher les vocabulaires internes et externes dans l’IHM                    Dans les différentes IHM, il est recommandé de récupérer au moyen d’une requête la traduction des vocabulaires de l’ontologie, plutôt que d’afficher des intitulés en dur, afin de faciliter leur modification par un administrateur fonctionnel.                                             Recommandé

  Accès à l’ontologie par un administrateur fonctionnel                                                        Un administrateur fonctionnel peut avoir accès à l’ontologie et détenir des droits d’ajout et de modification de vocabulaires.                                                                                                                                                                Obligatoire

                                                                                                               Il est obligatoire que son intervention sur l’ontologie, **surtout sur l’indexation**, soit réalisée de concert avec l’administrateur technique.                                                                                                                                              
    
                                                                                                               En outre, il est recommandé de lui interdire de supprimer de son propre chef des vocabulaires internes.                                                                                                                                                                                       

  Accès à l’ontologie par un administrateur technique                                                          Un administrateur technique doit avoir accès à l’ontologie et détenir des droits d’ajout et de modification de vocabulaire. Il a également la possibilité de supprimer des vocabulaires, internes et externes.                                                                                Recommandé

                                                                                                               Il est recommandé de réaliser cette action de concert avec l’administrateur fonctionnel.                                                                                                                                                                                                      

  Accès à l’ontologie par un tiers                                                                             Il est recommandé, pour des tiers, de restreindre leur accès aux seuls vocabulaires utilisés lors d’un transfert et avec des profils d’unité archivistique, à savoir les vocabulaires internes issus du SEDA et les vocabulaires externes créés pour des besoins de transfert particuliers.   Recommandé

  ------------------------------------------------------------------------------------------------------------ --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- ------------------------------

[]{#__RefHeading__11320_350149402 .anchor}Annexe 1 : Vocabulaires
internes de l’ontologie

Liste des vocabulaires internes présents dans l’ontologie.

*Nota bene* : cette liste n’est pas forcément exhaustive.

[]{#LC1 .anchor}\[

[]{#LC2 .anchor} {

[]{#LC3 .anchor} "Identifier": "AcquiredDate",

[]{#LC4 .anchor} "SedaField": "AcquiredDate",

[]{#LC5 .anchor} "Description": "Mapping : unit-es-mapping.json.
Références : ARKMS.DateAcquired",

[]{#LC6 .anchor} "Type": "DATE",

[]{#LC7 .anchor} "Origin": "INTERNAL",

[]{#LC8 .anchor} "ShortName": "Date de numérisation",

[]{#LC9 .anchor} "Collections": \[

[]{#LC10 .anchor} "Unit"

[]{#LC11 .anchor} \]

[]{#LC12 .anchor} },

[]{#LC13 .anchor} {

[]{#LC14 .anchor} "Identifier": "BirthDate",

[]{#LC15 .anchor} "SedaField": "BirthDate",

[]{#LC16 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC17 .anchor} "Type": "DATE",

[]{#LC18 .anchor} "Origin": "INTERNAL",

[]{#LC19 .anchor} "ShortName": "Date de naissance",

[]{#LC20 .anchor} "Collections": \[

[]{#LC21 .anchor} "Unit"

[]{#LC22 .anchor} \]

[]{#LC23 .anchor} },

[]{#LC24 .anchor} {

[]{#LC25 .anchor} "Identifier": "BirthName",

[]{#LC26 .anchor} "SedaField": "BirthName",

[]{#LC27 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC28 .anchor} "Type": "TEXT",

[]{#LC29 .anchor} "Origin": "INTERNAL",

[]{#LC30 .anchor} "ShortName": "Nom de naissance",

[]{#LC31 .anchor} "Collections": \[

[]{#LC32 .anchor} "Unit"

[]{#LC33 .anchor} \]

[]{#LC34 .anchor} },

[]{#LC35 .anchor} {

[]{#LC36 .anchor} "Identifier": "Address",

[]{#LC37 .anchor} "SedaField": "Address",

[]{#LC38 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Adresse. Références : ead.address",

[]{#LC39 .anchor} "Type": "TEXT",

[]{#LC40 .anchor} "Origin": "INTERNAL",

[]{#LC41 .anchor} "ShortName": "Addresse",

[]{#LC42 .anchor} "Collections": \[

[]{#LC43 .anchor} "Unit"

[]{#LC44 .anchor} \]

[]{#LC45 .anchor} },

[]{#LC46 .anchor} {

[]{#LC47 .anchor} "Identifier": "City",

[]{#LC48 .anchor} "SedaField": "City",

[]{#LC49 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Ville.",

[]{#LC50 .anchor} "Type": "TEXT",

[]{#LC51 .anchor} "Origin": "INTERNAL",

[]{#LC52 .anchor} "ShortName": "Ville",

[]{#LC53 .anchor} "Collections": \[

[]{#LC54 .anchor} "Unit"

[]{#LC55 .anchor} \]

[]{#LC56 .anchor} },

[]{#LC57 .anchor} {

[]{#LC58 .anchor} "Identifier": "Country",

[]{#LC59 .anchor} "SedaField": "Country",

[]{#LC60 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Pays.",

[]{#LC61 .anchor} "Type": "TEXT",

[]{#LC62 .anchor} "Origin": "INTERNAL",

[]{#LC63 .anchor} "ShortName": "Pays",

[]{#LC64 .anchor} "Collections": \[

[]{#LC65 .anchor} "Unit"

[]{#LC66 .anchor} \]

[]{#LC67 .anchor} },

[]{#LC68 .anchor} {

[]{#LC69 .anchor} "Identifier": "Geogname",

[]{#LC70 .anchor} "SedaField": "Geogname",

[]{#LC71 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Nom géographique. Références :
ead.geogname",

[]{#LC72 .anchor} "Type": "TEXT",

[]{#LC73 .anchor} "Origin": "INTERNAL",

[]{#LC74 .anchor} "ShortName": "Nom géographique",

[]{#LC75 .anchor} "Collections": \[

[]{#LC76 .anchor} "Unit"

[]{#LC77 .anchor} \]

[]{#LC78 .anchor} },

[]{#LC79 .anchor} {

[]{#LC80 .anchor} "Identifier": "PostalCode",

[]{#LC81 .anchor} "SedaField": "PostalCode",

[]{#LC82 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Code postal.",

[]{#LC83 .anchor} "Type": "KEYWORD",

[]{#LC84 .anchor} "Origin": "INTERNAL",

[]{#LC85 .anchor} "ShortName": "Code postal",

[]{#LC86 .anchor} "Collections": \[

[]{#LC87 .anchor} "Unit"

[]{#LC88 .anchor} \]

[]{#LC89 .anchor} },

[]{#LC90 .anchor} {

[]{#LC91 .anchor} "Identifier": "Region",

[]{#LC92 .anchor} "SedaField": "Region",

[]{#LC93 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Région.",

[]{#LC94 .anchor} "Type": "TEXT",

[]{#LC95 .anchor} "Origin": "INTERNAL",

[]{#LC96 .anchor} "ShortName": "Région",

[]{#LC97 .anchor} "Collections": \[

[]{#LC98 .anchor} "Unit"

[]{#LC99 .anchor} \]

[]{#LC100 .anchor} },

[]{#LC101 .anchor} {

[]{#LC102 .anchor} "Identifier": "Corpname",

[]{#LC103 .anchor} "SedaField": "Corpname",

[]{#LC104 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC105 .anchor} "Type": "TEXT",

[]{#LC106 .anchor} "Origin": "INTERNAL",

[]{#LC107 .anchor} "ShortName": "Nom d'une entité",

[]{#LC108 .anchor} "Collections": \[

[]{#LC109 .anchor} "Unit"

[]{#LC110 .anchor} \]

[]{#LC111 .anchor} },

[]{#LC112 .anchor} {

[]{#LC113 .anchor} "Identifier": "DeathDate",

[]{#LC114 .anchor} "SedaField": "DeathDate",

[]{#LC115 .anchor} "Description": "Mapping : unit-es-mapping.json. Date
de décès d'une personne.",

[]{#LC116 .anchor} "Type": "DATE",

[]{#LC117 .anchor} "Origin": "INTERNAL",

[]{#LC118 .anchor} "ShortName": "Date de décès",

[]{#LC119 .anchor} "Collections": \[

[]{#LC120 .anchor} "Unit"

[]{#LC121 .anchor} \]

[]{#LC122 .anchor} },

[]{#LC123 .anchor} {

[]{#LC124 .anchor} "Identifier": "FirstName",

[]{#LC125 .anchor} "SedaField": "FirstName",

[]{#LC126 .anchor} "Description": "Mapping : unit-es-mapping.json.
Prénom d'une personne.",

[]{#LC127 .anchor} "Type": "TEXT",

[]{#LC128 .anchor} "Origin": "INTERNAL",

[]{#LC129 .anchor} "ShortName": "Prénom",

[]{#LC130 .anchor} "Collections": \[

[]{#LC131 .anchor} "Unit"

[]{#LC132 .anchor} \]

[]{#LC133 .anchor} },

[]{#LC134 .anchor} {

[]{#LC135 .anchor} "Identifier": "Gender",

[]{#LC136 .anchor} "SedaField": "Gender",

[]{#LC137 .anchor} "Description": "Mapping : unit-es-mapping.json. Sexe
de la personne.",

[]{#LC138 .anchor} "Type": "TEXT",

[]{#LC139 .anchor} "Origin": "INTERNAL",

[]{#LC140 .anchor} "ShortName": "Sexe",

[]{#LC141 .anchor} "Collections": \[

[]{#LC142 .anchor} "Unit"

[]{#LC143 .anchor} \]

[]{#LC144 .anchor} },

[]{#LC145 .anchor} {

[]{#LC146 .anchor} "Identifier": "GivenName",

[]{#LC147 .anchor} "SedaField": "GivenName",

[]{#LC148 .anchor} "Description": "Mapping : unit-es-mapping.json. Nom
d'usage d'une personne.",

[]{#LC149 .anchor} "Type": "TEXT",

[]{#LC150 .anchor} "Origin": "INTERNAL",

[]{#LC151 .anchor} "ShortName": "Nom d'usage",

[]{#LC152 .anchor} "Collections": \[

[]{#LC153 .anchor} "Unit"

[]{#LC154 .anchor} \]

[]{#LC155 .anchor} },

[]{#LC156 .anchor} {

[]{#LC157 .anchor} "Identifier": "Identifier",

[]{#LC158 .anchor} "SedaField": "Identifier",

[]{#LC159 .anchor} "Description": "Mapping : unit-es-mapping.json. UNITE
ARCHIVISTIQUE : Dans le PersonGroup, Identifiant de type numéro
matricule. Dans le EntityGroup, Identifiant de l'entité. REFERENTIELS :
identifiant.",

[]{#LC160 .anchor} "Type": "KEYWORD",

[]{#LC161 .anchor} "Origin": "INTERNAL",

[]{#LC162 .anchor} "ShortName": "Identifiant",

[]{#LC163 .anchor} "Collections": \[

[]{#LC164 .anchor} "Unit",

[]{#LC165 .anchor} "AccessContract",

[]{#LC166 .anchor} "Agencies",

[]{#LC167 .anchor} "ArchiveUnitProfile",

[]{#LC168 .anchor} "Context",

[]{#LC169 .anchor} "IngestContract",

[]{#LC170 .anchor} "Ontology",

[]{#LC171 .anchor} "Profile",

[]{#LC172 .anchor} "SecurityProfile",

[]{#LC173 .anchor} "Griffin",

[]{#LC174 .anchor} "PreservationScenario",

[]{#LC175 .anchor} "ManagementContract"

[]{#LC176 .anchor} \]

[]{#LC177 .anchor} },

[]{#LC178 .anchor} {

[]{#LC179 .anchor} "Identifier": "Nationality",

[]{#LC180 .anchor} "SedaField": "Nationality",

[]{#LC181 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC182 .anchor} "Type": "TEXT",

[]{#LC183 .anchor} "Origin": "INTERNAL",

[]{#LC184 .anchor} "ShortName": "Nationalité",

[]{#LC185 .anchor} "Collections": \[

[]{#LC186 .anchor} "Unit"

[]{#LC187 .anchor} \]

[]{#LC188 .anchor} },

[]{#LC189 .anchor} {

[]{#LC190 .anchor} "Identifier": "ArchivalAgencyArchiveUnitIdentifier",

[]{#LC191 .anchor} "SedaField": "ArchivalAgencyArchiveUnitIdentifier",

[]{#LC192 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant métier attribué à l'ArchiveUnit par le service d'archives.
Peut être comparé à une cote.",

[]{#LC193 .anchor} "Type": "KEYWORD",

[]{#LC194 .anchor} "Origin": "INTERNAL",

[]{#LC195 .anchor} "ShortName": "Identifiant métier (Service
d'archives)",

[]{#LC196 .anchor} "Collections": \[

[]{#LC197 .anchor} "Unit"

[]{#LC198 .anchor} \]

[]{#LC199 .anchor} },

[]{#LC200 .anchor} {

[]{#LC201 .anchor} "Identifier": "ArchiveUnitProfile",

[]{#LC202 .anchor} "SedaField": "ArchiveUnitProfile",

[]{#LC203 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC204 .anchor} "Type": "KEYWORD",

[]{#LC205 .anchor} "Origin": "INTERNAL",

[]{#LC206 .anchor} "ShortName": "Profil d'unité archivistique",

[]{#LC207 .anchor} "Collections": \[

[]{#LC208 .anchor} "Unit"

[]{#LC209 .anchor} \]

[]{#LC210 .anchor} },

[]{#LC211 .anchor} {

[]{#LC212 .anchor} "Identifier": "Juridictional",

[]{#LC213 .anchor} "SedaField": "Juridictional",

[]{#LC214 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC215 .anchor} "Type": "TEXT",

[]{#LC216 .anchor} "Origin": "INTERNAL",

[]{#LC217 .anchor} "ShortName": "Couverture administrative",

[]{#LC218 .anchor} "Collections": \[

[]{#LC219 .anchor} "Unit"

[]{#LC220 .anchor} \]

[]{#LC221 .anchor} },

[]{#LC222 .anchor} {

[]{#LC223 .anchor} "Identifier": "Spatial",

[]{#LC224 .anchor} "SedaField": "Spatial",

[]{#LC225 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC226 .anchor} "Type": "TEXT",

[]{#LC227 .anchor} "Origin": "INTERNAL",

[]{#LC228 .anchor} "ShortName": "Couverture géographique",

[]{#LC229 .anchor} "Collections": \[

[]{#LC230 .anchor} "Unit"

[]{#LC231 .anchor} \]

[]{#LC232 .anchor} },

[]{#LC233 .anchor} {

[]{#LC234 .anchor} "Identifier": "Temporal",

[]{#LC235 .anchor} "SedaField": "Temporal",

[]{#LC236 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC237 .anchor} "Type": "TEXT",

[]{#LC238 .anchor} "Origin": "INTERNAL",

[]{#LC239 .anchor} "ShortName": "Couverture temporelle",

[]{#LC240 .anchor} "Collections": \[

[]{#LC241 .anchor} "Unit"

[]{#LC242 .anchor} \]

[]{#LC243 .anchor} },

[]{#LC244 .anchor} {

[]{#LC245 .anchor} "Identifier": "CreatedDate",

[]{#LC246 .anchor} "SedaField": "CreatedDate",

[]{#LC247 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC248 .anchor} "Type": "DATE",

[]{#LC249 .anchor} "Origin": "INTERNAL",

[]{#LC250 .anchor} "ShortName": "Date de création",

[]{#LC251 .anchor} "Collections": \[

[]{#LC252 .anchor} "Unit",

[]{#LC253 .anchor} "FileFormat"

[]{#LC254 .anchor} \]

[]{#LC255 .anchor} },

[]{#LC256 .anchor} {

[]{#LC257 .anchor} "Identifier": "DataObjectGroupReferenceId",

[]{#LC258 .anchor} "SedaField": "DataObjectGroupReferenceId",

[]{#LC259 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à un groupe d'objets-données listé dans les métadonnées de
transport.",

[]{#LC260 .anchor} "Type": "KEYWORD",

[]{#LC261 .anchor} "Origin": "INTERNAL",

[]{#LC262 .anchor} "ShortName": "Référence à un groupe d'objets",

[]{#LC263 .anchor} "Collections": \[

[]{#LC264 .anchor} "Unit"

[]{#LC265 .anchor} \]

[]{#LC266 .anchor} },

[]{#LC267 .anchor} {

[]{#LC268 .anchor} "Identifier": "CustodialHistoryItem",

[]{#LC269 .anchor} "SedaField": "CustodialHistoryItem",

[]{#LC270 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC271 .anchor} "Type": "TEXT",

[]{#LC272 .anchor} "Origin": "INTERNAL",

[]{#LC273 .anchor} "ShortName": "Historique de propriété, de
responsabilité et de conservation",

[]{#LC274 .anchor} "Collections": \[

[]{#LC275 .anchor} "Unit"

[]{#LC276 .anchor} \]

[]{#LC277 .anchor} },

[]{#LC278 .anchor} {

[]{#LC279 .anchor} "Identifier": "Description",

[]{#LC280 .anchor} "SedaField": "Description",

[]{#LC281 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC282 .anchor} "Type": "TEXT",

[]{#LC283 .anchor} "Origin": "INTERNAL",

[]{#LC284 .anchor} "ShortName": "Description",

[]{#LC285 .anchor} "Collections": \[

[]{#LC286 .anchor} "Unit",

[]{#LC287 .anchor} "AccessContract",

[]{#LC288 .anchor} "Agencies",

[]{#LC289 .anchor} "ArchiveUnitProfile",

[]{#LC290 .anchor} "IngestContract",

[]{#LC291 .anchor} "Ontology",

[]{#LC292 .anchor} "Profile",

[]{#LC293 .anchor} "Griffin",

[]{#LC294 .anchor} "PreservationScenario",

[]{#LC295 .anchor} "ManagementContract"

[]{#LC296 .anchor} \]

[]{#LC297 .anchor} },

[]{#LC298 .anchor} {

[]{#LC299 .anchor} "Identifier": "DescriptionLanguage",

[]{#LC300 .anchor} "SedaField": "DescriptionLanguage",

[]{#LC301 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC302 .anchor} "Type": "KEYWORD",

[]{#LC303 .anchor} "Origin": "INTERNAL",

[]{#LC304 .anchor} "ShortName": "Langue des descriptions",

[]{#LC305 .anchor} "Collections": \[

[]{#LC306 .anchor} "Unit"

[]{#LC307 .anchor} \]

[]{#LC308 .anchor} },

[]{#LC309 .anchor} {

[]{#LC310 .anchor} "Identifier": "DescriptionLevel",

[]{#LC311 .anchor} "SedaField": "DescriptionLevel",

[]{#LC312 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC313 .anchor} "Type": "KEYWORD",

[]{#LC314 .anchor} "Origin": "INTERNAL",

[]{#LC315 .anchor} "ShortName": "Niveau de description",

[]{#LC316 .anchor} "Collections": \[

[]{#LC317 .anchor} "Unit"

[]{#LC318 .anchor} \]

[]{#LC319 .anchor} },

[]{#LC320 .anchor} {

[]{#LC321 .anchor} "Identifier": "DocumentType",

[]{#LC322 .anchor} "SedaField": "DocumentType",

[]{#LC323 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC324 .anchor} "Type": "TEXT",

[]{#LC325 .anchor} "Origin": "INTERNAL",

[]{#LC326 .anchor} "ShortName": "Type de document",

[]{#LC327 .anchor} "Collections": \[

[]{#LC328 .anchor} "Unit"

[]{#LC329 .anchor} \]

[]{#LC330 .anchor} },

[]{#LC331 .anchor} {

[]{#LC332 .anchor} "Identifier": "EndDate",

[]{#LC333 .anchor} "SedaField": "EndDate",

[]{#LC334 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC335 .anchor} "Type": "DATE",

[]{#LC336 .anchor} "Origin": "INTERNAL",

[]{#LC337 .anchor} "ShortName": "Date de fin",

[]{#LC338 .anchor} "Collections": \[

[]{#LC339 .anchor} "Unit",

[]{#LC340 .anchor} "AccessionRegisterDetail",

[]{#LC341 .anchor} "LogbookOperation"

[]{#LC342 .anchor} \]

[]{#LC343 .anchor} },

[]{#LC344 .anchor} {

[]{#LC345 .anchor} "Identifier": "evTypeDetail",

[]{#LC346 .anchor} "SedaField": "EventDetail",

[]{#LC347 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC348 .anchor} "Type": "TEXT",

[]{#LC349 .anchor} "Origin": "INTERNAL",

[]{#LC350 .anchor} "ShortName": "Détail",

[]{#LC351 .anchor} "Collections": \[

[]{#LC352 .anchor} "Unit"

[]{#LC353 .anchor} \]

[]{#LC354 .anchor} },

[]{#LC355 .anchor} {

[]{#LC356 .anchor} "Identifier": "FilePlanPosition",

[]{#LC357 .anchor} "SedaField": "FilePlanPosition",

[]{#LC358 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC359 .anchor} "Type": "KEYWORD",

[]{#LC360 .anchor} "Origin": "INTERNAL",

[]{#LC361 .anchor} "ShortName": "Position dans le plan de classement",

[]{#LC362 .anchor} "Collections": \[

[]{#LC363 .anchor} "Unit"

[]{#LC364 .anchor} \]

[]{#LC365 .anchor} },

[]{#LC366 .anchor} {

[]{#LC367 .anchor} "Identifier": "GpsAltitude",

[]{#LC368 .anchor} "SedaField": "GpsAltitude",

[]{#LC369 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC370 .anchor} "Type": "LONG",

[]{#LC371 .anchor} "Origin": "INTERNAL",

[]{#LC372 .anchor} "ShortName": "Altitude",

[]{#LC373 .anchor} "Collections": \[

[]{#LC374 .anchor} "Unit"

[]{#LC375 .anchor} \]

[]{#LC376 .anchor} },

[]{#LC377 .anchor} {

[]{#LC378 .anchor} "Identifier": "GpsAltitudeRef",

[]{#LC379 .anchor} "SedaField": "GpsAltitudeRef",

[]{#LC380 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC381 .anchor} "Type": "KEYWORD",

[]{#LC382 .anchor} "Origin": "INTERNAL",

[]{#LC383 .anchor} "ShortName": "Niveau de la mer",

[]{#LC384 .anchor} "Collections": \[

[]{#LC385 .anchor} "Unit"

[]{#LC386 .anchor} \]

[]{#LC387 .anchor} },

[]{#LC388 .anchor} {

[]{#LC389 .anchor} "Identifier": "GpsDateStamp",

[]{#LC390 .anchor} "SedaField": "GpsDateStamp",

[]{#LC391 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC392 .anchor} "Type": "KEYWORD",

[]{#LC393 .anchor} "Origin": "INTERNAL",

[]{#LC394 .anchor} "ShortName": "Heure et date",

[]{#LC395 .anchor} "Collections": \[

[]{#LC396 .anchor} "Unit"

[]{#LC397 .anchor} \]

[]{#LC398 .anchor} },

[]{#LC399 .anchor} {

[]{#LC400 .anchor} "Identifier": "GpsLatitude",

[]{#LC401 .anchor} "SedaField": "GpsLatitude",

[]{#LC402 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC403 .anchor} "Type": "KEYWORD",

[]{#LC404 .anchor} "Origin": "INTERNAL",

[]{#LC405 .anchor} "ShortName": "Latitude",

[]{#LC406 .anchor} "Collections": \[

[]{#LC407 .anchor} "Unit"

[]{#LC408 .anchor} \]

[]{#LC409 .anchor} },

[]{#LC410 .anchor} {

[]{#LC411 .anchor} "Identifier": "GpsLatitudeRef",

[]{#LC412 .anchor} "SedaField": "GpsLatitudeRef",

[]{#LC413 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC414 .anchor} "Type": "KEYWORD",

[]{#LC415 .anchor} "Origin": "INTERNAL",

[]{#LC416 .anchor} "ShortName": "Référence",

[]{#LC417 .anchor} "Collections": \[

[]{#LC418 .anchor} "Unit"

[]{#LC419 .anchor} \]

[]{#LC420 .anchor} },

[]{#LC421 .anchor} {

[]{#LC422 .anchor} "Identifier": "GpsLongitude",

[]{#LC423 .anchor} "SedaField": "GpsLongitude",

[]{#LC424 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC425 .anchor} "Type": "KEYWORD",

[]{#LC426 .anchor} "Origin": "INTERNAL",

[]{#LC427 .anchor} "ShortName": "Longitude",

[]{#LC428 .anchor} "Collections": \[

[]{#LC429 .anchor} "Unit"

[]{#LC430 .anchor} \]

[]{#LC431 .anchor} },

[]{#LC432 .anchor} {

[]{#LC433 .anchor} "Identifier": "GpsLongitudeRef",

[]{#LC434 .anchor} "SedaField": "GpsLongitudeRef",

[]{#LC435 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC436 .anchor} "Type": "KEYWORD",

[]{#LC437 .anchor} "Origin": "INTERNAL",

[]{#LC438 .anchor} "ShortName": "Référence",

[]{#LC439 .anchor} "Collections": \[

[]{#LC440 .anchor} "Unit"

[]{#LC441 .anchor} \]

[]{#LC442 .anchor} },

[]{#LC443 .anchor} {

[]{#LC444 .anchor} "Identifier": "GpsVersionID",

[]{#LC445 .anchor} "SedaField": "GpsVersionID",

[]{#LC446 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC447 .anchor} "Type": "KEYWORD",

[]{#LC448 .anchor} "Origin": "INTERNAL",

[]{#LC449 .anchor} "ShortName": "Identifiant de version du GPS",

[]{#LC450 .anchor} "Collections": \[

[]{#LC451 .anchor} "Unit"

[]{#LC452 .anchor} \]

[]{#LC453 .anchor} },

[]{#LC454 .anchor} {

[]{#LC455 .anchor} "Identifier": "HoldEndDate",

[]{#LC456 .anchor} "SedaField": "HoldEndDate",

[]{#LC457 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC458 .anchor} "Type": "DATE",

[]{#LC459 .anchor} "Origin": "INTERNAL",

[]{#LC460 .anchor} "ShortName": "Date de fin de gel",

[]{#LC461 .anchor} "Collections": \[

[]{#LC462 .anchor} "Unit"

[]{#LC463 .anchor} \]

[]{#LC464 .anchor} },

[]{#LC465 .anchor} {

[]{#LC466 .anchor} "Identifier": "HoldOwner",

[]{#LC467 .anchor} "SedaField": "HoldOwner",

[]{#LC468 .anchor} "Description": "Mapping : unit-es-mapping.json.
Propriétaire de la demande de gel.",

[]{#LC469 .anchor} "Type": "TEXT",

[]{#LC470 .anchor} "Origin": "INTERNAL",

[]{#LC471 .anchor} "ShortName": "Propriétaire de la demande de gel",

[]{#LC472 .anchor} "Collections": \[

[]{#LC473 .anchor} "Unit"

[]{#LC474 .anchor} \]

[]{#LC475 .anchor} },

[]{#LC476 .anchor} {

[]{#LC477 .anchor} "Identifier": "HoldReassessingDate",

[]{#LC478 .anchor} "SedaField": "HoldReassessingDate",

[]{#LC479 .anchor} "Description": "Mapping : unit-es-mapping.json. Date
de réévaluation du gel.",

[]{#LC480 .anchor} "Type": "DATE",

[]{#LC481 .anchor} "Origin": "INTERNAL",

[]{#LC482 .anchor} "ShortName": "Date de réévaluation",

[]{#LC483 .anchor} "Collections": \[

[]{#LC484 .anchor} "Unit"

[]{#LC485 .anchor} \]

[]{#LC486 .anchor} },

[]{#LC487 .anchor} {

[]{#LC488 .anchor} "Identifier": "HoldReason",

[]{#LC489 .anchor} "SedaField": "HoldReason",

[]{#LC490 .anchor} "Description": "Mapping : unit-es-mapping.json. Motif
de gel.",

[]{#LC491 .anchor} "Type": "TEXT",

[]{#LC492 .anchor} "Origin": "INTERNAL",

[]{#LC493 .anchor} "ShortName": "Motif de gel",

[]{#LC494 .anchor} "Collections": \[

[]{#LC495 .anchor} "Unit"

[]{#LC496 .anchor} \]

[]{#LC497 .anchor} },

[]{#LC498 .anchor} {

[]{#LC499 .anchor} "Identifier": "HoldRuleIds",

[]{#LC500 .anchor} "ApiField": "HoldRuleIds",

[]{#LC501 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiants des règles de gel",

[]{#LC502 .anchor} "Type": "KEYWORD",

[]{#LC503 .anchor} "Origin": "INTERNAL",

[]{#LC504 .anchor} "ShortName": "HoldRuleIds",

[]{#LC505 .anchor} "Collections": \[

[]{#LC506 .anchor} "Unit"

[]{#LC507 .anchor} \]

[]{#LC508 .anchor} },

[]{#LC509 .anchor} {

[]{#LC510 .anchor} "Identifier": "KeywordContent",

[]{#LC511 .anchor} "SedaField": "KeywordContent",

[]{#LC512 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC513 .anchor} "Type": "KEYWORD",

[]{#LC514 .anchor} "Origin": "INTERNAL",

[]{#LC515 .anchor} "ShortName": "Mot clé",

[]{#LC516 .anchor} "Collections": \[

[]{#LC517 .anchor} "Unit"

[]{#LC518 .anchor} \]

[]{#LC519 .anchor} },

[]{#LC520 .anchor} {

[]{#LC521 .anchor} "Identifier": "KeywordReference",

[]{#LC522 .anchor} "SedaField": "KeywordReference",

[]{#LC523 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC524 .anchor} "Type": "KEYWORD",

[]{#LC525 .anchor} "Origin": "INTERNAL",

[]{#LC526 .anchor} "ShortName": "Référence",

[]{#LC527 .anchor} "Collections": \[

[]{#LC528 .anchor} "Unit"

[]{#LC529 .anchor} \]

[]{#LC530 .anchor} },

[]{#LC531 .anchor} {

[]{#LC532 .anchor} "Identifier": "KeywordType",

[]{#LC533 .anchor} "SedaField": "KeywordType",

[]{#LC534 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC535 .anchor} "Type": "KEYWORD",

[]{#LC536 .anchor} "Origin": "INTERNAL",

[]{#LC537 .anchor} "ShortName": "Type",

[]{#LC538 .anchor} "Collections": \[

[]{#LC539 .anchor} "Unit"

[]{#LC540 .anchor} \]

[]{#LC541 .anchor} },

[]{#LC542 .anchor} {

[]{#LC543 .anchor} "Identifier": "Language",

[]{#LC544 .anchor} "SedaField": "Language",

[]{#LC545 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC546 .anchor} "Type": "KEYWORD",

[]{#LC547 .anchor} "Origin": "INTERNAL",

[]{#LC548 .anchor} "ShortName": "Langue des documents",

[]{#LC549 .anchor} "Collections": \[

[]{#LC550 .anchor} "Unit"

[]{#LC551 .anchor} \]

[]{#LC552 .anchor} },

[]{#LC553 .anchor} {

[]{#LC554 .anchor} "Identifier":
"OriginatingAgencyArchiveUnitIdentifier",

[]{#LC555 .anchor} "SedaField":
"OriginatingAgencyArchiveUnitIdentifier",

[]{#LC556 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC557 .anchor} "Type": "KEYWORD",

[]{#LC558 .anchor} "Origin": "INTERNAL",

[]{#LC559 .anchor} "ShortName": "Identifiant métier (Service
producteur)",

[]{#LC560 .anchor} "Collections": \[

[]{#LC561 .anchor} "Unit"

[]{#LC562 .anchor} \]

[]{#LC563 .anchor} },

[]{#LC564 .anchor} {

[]{#LC565 .anchor} "Identifier": "OriginatingSystemId",

[]{#LC566 .anchor} "SedaField": "OriginatingSystemId",

[]{#LC567 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC568 .anchor} "Type": "KEYWORD",

[]{#LC569 .anchor} "Origin": "INTERNAL",

[]{#LC570 .anchor} "ShortName": "Identifiant système (Service
producteur)",

[]{#LC571 .anchor} "Collections": \[

[]{#LC572 .anchor} "Unit"

[]{#LC573 .anchor} \]

[]{#LC574 .anchor} },

[]{#LC575 .anchor} {

[]{#LC576 .anchor} "Identifier": "ReceivedDate",

[]{#LC577 .anchor} "SedaField": "ReceivedDate",

[]{#LC578 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC579 .anchor} "Type": "DATE",

[]{#LC580 .anchor} "Origin": "INTERNAL",

[]{#LC581 .anchor} "ShortName": "Date de réception",

[]{#LC582 .anchor} "Collections": \[

[]{#LC583 .anchor} "Unit"

[]{#LC584 .anchor} \]

[]{#LC585 .anchor} },

[]{#LC586 .anchor} {

[]{#LC587 .anchor} "Identifier": "RegisteredDate",

[]{#LC588 .anchor} "SedaField": "RegisteredDate",

[]{#LC589 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC590 .anchor} "Type": "DATE",

[]{#LC591 .anchor} "Origin": "INTERNAL",

[]{#LC592 .anchor} "ShortName": "Date d'enregistrement",

[]{#LC593 .anchor} "Collections": \[

[]{#LC594 .anchor} "Unit"

[]{#LC595 .anchor} \]

[]{#LC596 .anchor} },

[]{#LC597 .anchor} {

[]{#LC598 .anchor} "Identifier": "ArchiveUnitRefId",

[]{#LC599 .anchor} "SedaField": "ArchiveUnitRefId",

[]{#LC600 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à une ArchiveUnit interne.",

[]{#LC601 .anchor} "Type": "KEYWORD",

[]{#LC602 .anchor} "Origin": "INTERNAL",

[]{#LC603 .anchor} "ShortName": "Référence à une ArchiveUnit interne",

[]{#LC604 .anchor} "Collections": \[

[]{#LC605 .anchor} "Unit"

[]{#LC606 .anchor} \]

[]{#LC607 .anchor} },

[]{#LC608 .anchor} {

[]{#LC609 .anchor} "Identifier": "DataObjectReferenceId",

[]{#LC610 .anchor} "SedaField": "DataObjectReferenceId",

[]{#LC611 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à un objet-données ou à un groupe d'objets-données
interne(s).",

[]{#LC612 .anchor} "Type": "KEYWORD",

[]{#LC613 .anchor} "Origin": "INTERNAL",

[]{#LC614 .anchor} "ShortName": "Référence à un objet ou à un groupe
d'objets interne(s)",

[]{#LC615 .anchor} "Collections": \[

[]{#LC616 .anchor} "Unit"

[]{#LC617 .anchor} \]

[]{#LC618 .anchor} },

[]{#LC619 .anchor} {

[]{#LC620 .anchor} "Identifier": "RepositoryArchiveUnitPID",

[]{#LC621 .anchor} "SedaField": "RepositoryArchiveUnitPID",

[]{#LC622 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à un ArchiveUnit déjà conservé dans un système d'archivage.",

[]{#LC623 .anchor} "Type": "KEYWORD",

[]{#LC624 .anchor} "Origin": "INTERNAL",

[]{#LC625 .anchor} "ShortName": "Référence à une ArchiveUnit déjà
conservée",

[]{#LC626 .anchor} "Collections": \[

[]{#LC627 .anchor} "Unit"

[]{#LC628 .anchor} \]

[]{#LC629 .anchor} },

[]{#LC630 .anchor} {

[]{#LC631 .anchor} "Identifier": "RepositoryObjectPID",

[]{#LC632 .anchor} "SedaField": "RepositoryObjectPID",

[]{#LC633 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à un un objet-données ou à un groupe d'objets-données déjà
conservé(s) dans un système d'archivage.",

[]{#LC634 .anchor} "Type": "KEYWORD",

[]{#LC635 .anchor} "Origin": "INTERNAL",

[]{#LC636 .anchor} "ShortName": "Référence à un objet ou à un groupe
d'objets déjà conservé(s)",

[]{#LC637 .anchor} "Collections": \[

[]{#LC638 .anchor} "Unit"

[]{#LC639 .anchor} \]

[]{#LC640 .anchor} },

[]{#LC641 .anchor} {

[]{#LC642 .anchor} "Identifier": "ExternalReference",

[]{#LC643 .anchor} "SedaField": "ExternalReference",

[]{#LC644 .anchor} "Description": "Mapping : unit-es-mapping.json.
Référence à un objet externe, présent ni dans le message, ni dans le
SAE",

[]{#LC645 .anchor} "Type": "TEXT",

[]{#LC646 .anchor} "Origin": "INTERNAL",

[]{#LC647 .anchor} "ShortName": "Référence à un objet externe, présent
ni dans le message, ni dans le SAE",

[]{#LC648 .anchor} "Collections": \[

[]{#LC649 .anchor} "Unit"

[]{#LC650 .anchor} \]

[]{#LC651 .anchor} },

[]{#LC652 .anchor} {

[]{#LC653 .anchor} "Identifier": "Activity",

[]{#LC654 .anchor} "SedaField": "Activity",

[]{#LC655 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Activité.",

[]{#LC656 .anchor} "Type": "TEXT",

[]{#LC657 .anchor} "Origin": "INTERNAL",

[]{#LC658 .anchor} "ShortName": "Activité",

[]{#LC659 .anchor} "Collections": \[

[]{#LC660 .anchor} "Unit"

[]{#LC661 .anchor} \]

[]{#LC662 .anchor} },

[]{#LC663 .anchor} {

[]{#LC664 .anchor} "Identifier": "ExecutableName",

[]{#LC665 .anchor} "SedaField": "ExecutableName",

[]{#LC666 .anchor} "Description": "Mapping : griffin-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : ExecutableName.",

[]{#LC667 .anchor} "Type": "KEYWORD",

[]{#LC668 .anchor} "Origin": "INTERNAL",

[]{#LC669 .anchor} "ShortName": "ExecutableName",

[]{#LC670 .anchor} "Collections": \[

[]{#LC671 .anchor} "Griffin"

[]{#LC672 .anchor} \]

[]{#LC673 .anchor} },

[]{#LC674 .anchor} {

[]{#LC675 .anchor} "Identifier": "ExecutableVersion",

[]{#LC676 .anchor} "SedaField": "ExecutableVersion",

[]{#LC677 .anchor} "Description": "Mapping : griffin-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : ExecutableVersion.",

[]{#LC678 .anchor} "Type": "KEYWORD",

[]{#LC679 .anchor} "Origin": "INTERNAL",

[]{#LC680 .anchor} "ShortName": "ExecutableVersion",

[]{#LC681 .anchor} "Collections": \[

[]{#LC682 .anchor} "Griffin"

[]{#LC683 .anchor} \]

[]{#LC684 .anchor} },

[]{#LC685 .anchor} {

[]{#LC686 .anchor} "Identifier": "Function",

[]{#LC687 .anchor} "SedaField": "Function",

[]{#LC688 .anchor} "Description": "Mapping : unit-es-mapping.json. En
plus des balises Tag et Keyword, il est possible d'indexer les objets
avec des éléments pré-définis : Fonction.",

[]{#LC689 .anchor} "Type": "TEXT",

[]{#LC690 .anchor} "Origin": "INTERNAL",

[]{#LC691 .anchor} "ShortName": "Fonction",

[]{#LC692 .anchor} "Collections": \[

[]{#LC693 .anchor} "Unit"

[]{#LC694 .anchor} \]

[]{#LC695 .anchor} },

[]{#LC696 .anchor} {

[]{#LC697 .anchor} "Identifier": "Position",

[]{#LC698 .anchor} "SedaField": "Position",

[]{#LC699 .anchor} "Description": "Mapping : unit-es-mapping.json.
Intitulé du poste de travail occupé par la personne.",

[]{#LC700 .anchor} "Type": "TEXT",

[]{#LC701 .anchor} "Origin": "INTERNAL",

[]{#LC702 .anchor} "ShortName": "Intitulé du poste",

[]{#LC703 .anchor} "Collections": \[

[]{#LC704 .anchor} "Unit"

[]{#LC705 .anchor} \]

[]{#LC706 .anchor} },

[]{#LC707 .anchor} {

[]{#LC708 .anchor} "Identifier": "Role",

[]{#LC709 .anchor} "SedaField": "Role",

[]{#LC710 .anchor} "Description": "Mapping : unit-es-mapping.json.
Droits avec lesquels un utilisateur a réalisé une opération, notamment
dans une application.",

[]{#LC711 .anchor} "Type": "TEXT",

[]{#LC712 .anchor} "Origin": "INTERNAL",

[]{#LC713 .anchor} "ShortName": "Droits",

[]{#LC714 .anchor} "Collections": \[

[]{#LC715 .anchor} "Unit"

[]{#LC716 .anchor} \]

[]{#LC717 .anchor} },

[]{#LC718 .anchor} {

[]{#LC719 .anchor} "Identifier": "Mandate",

[]{#LC720 .anchor} "SedaField": "Mandate",

[]{#LC721 .anchor} "Description": "Mapping : unit-es-mapping.json.
Mandat octroyé à la personne.",

[]{#LC722 .anchor} "Type": "TEXT",

[]{#LC723 .anchor} "Origin": "INTERNAL",

[]{#LC724 .anchor} "ShortName": "Mandat octroyé à la personne",

[]{#LC725 .anchor} "Collections": \[

[]{#LC726 .anchor} "Unit"

[]{#LC727 .anchor} \]

[]{#LC728 .anchor} },

[]{#LC729 .anchor} {

[]{#LC730 .anchor} "Identifier": "SentDate",

[]{#LC731 .anchor} "SedaField": "SentDate",

[]{#LC732 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC733 .anchor} "Type": "DATE",

[]{#LC734 .anchor} "Origin": "INTERNAL",

[]{#LC735 .anchor} "ShortName": "Date d'envoi",

[]{#LC736 .anchor} "Collections": \[

[]{#LC737 .anchor} "Unit"

[]{#LC738 .anchor} \]

[]{#LC739 .anchor} },

[]{#LC740 .anchor} {

[]{#LC741 .anchor} "Identifier": "Algorithm",

[]{#LC742 .anchor} "SedaField": "Algorithm",

[]{#LC743 .anchor} "Description": "Mapping : unit-es-mapping.json.
Attribut SEDA.",

[]{#LC744 .anchor} "Type": "KEYWORD",

[]{#LC745 .anchor} "Origin": "INTERNAL",

[]{#LC746 .anchor} "ShortName": "Algorithme",

[]{#LC747 .anchor} "Collections": \[

[]{#LC748 .anchor} "Unit",

[]{#LC749 .anchor} "ObjectGroup"

[]{#LC750 .anchor} \]

[]{#LC751 .anchor} },

[]{#LC752 .anchor} {

[]{#LC753 .anchor} "Identifier": "SignedObjectId",

[]{#LC754 .anchor} "SedaField": "SignedObjectId",

[]{#LC755 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant de l'objet-données signé.",

[]{#LC756 .anchor} "Type": "KEYWORD",

[]{#LC757 .anchor} "Origin": "INTERNAL",

[]{#LC758 .anchor} "ShortName": "Identifiant",

[]{#LC759 .anchor} "Collections": \[

[]{#LC760 .anchor} "Unit"

[]{#LC761 .anchor} \]

[]{#LC762 .anchor} },

[]{#LC763 .anchor} {

[]{#LC764 .anchor} "Identifier": "FullName",

[]{#LC765 .anchor} "SedaField": "FullName",

[]{#LC766 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC767 .anchor} "Type": "TEXT",

[]{#LC768 .anchor} "Origin": "INTERNAL",

[]{#LC769 .anchor} "ShortName": "Nom / Nom + Prénom",

[]{#LC770 .anchor} "Collections": \[

[]{#LC771 .anchor} "Unit"

[]{#LC772 .anchor} \]

[]{#LC773 .anchor} },

[]{#LC774 .anchor} {

[]{#LC775 .anchor} "Identifier": "SigningTime",

[]{#LC776 .anchor} "SedaField": "SigningTime",

[]{#LC777 .anchor} "Description": "Mapping : unit-es-mapping.json. Date
de signature",

[]{#LC778 .anchor} "Type": "DATE",

[]{#LC779 .anchor} "Origin": "INTERNAL",

[]{#LC780 .anchor} "ShortName": "Date",

[]{#LC781 .anchor} "Collections": \[

[]{#LC782 .anchor} "Unit"

[]{#LC783 .anchor} \]

[]{#LC784 .anchor} },

[]{#LC785 .anchor} {

[]{#LC786 .anchor} "Identifier": "ValidationTime",

[]{#LC787 .anchor} "SedaField": "ValidationTime",

[]{#LC788 .anchor} "Description": "Mapping : unit-es-mapping.json. Date
de la validation de la signature.",

[]{#LC789 .anchor} "Type": "DATE",

[]{#LC790 .anchor} "Origin": "INTERNAL",

[]{#LC791 .anchor} "ShortName": "Date",

[]{#LC792 .anchor} "Collections": \[

[]{#LC793 .anchor} "Unit"

[]{#LC794 .anchor} \]

[]{#LC795 .anchor} },

[]{#LC796 .anchor} {

[]{#LC797 .anchor} "Identifier": "Source",

[]{#LC798 .anchor} "SedaField": "Source",

[]{#LC799 .anchor} "Description": "Mapping : unit-es-mapping.json. En
cas de substitution numérique, permet de faire référence au papier.",

[]{#LC800 .anchor} "Type": "TEXT",

[]{#LC801 .anchor} "Origin": "INTERNAL",

[]{#LC802 .anchor} "ShortName": "Source",

[]{#LC803 .anchor} "Collections": \[

[]{#LC804 .anchor} "Unit"

[]{#LC805 .anchor} \]

[]{#LC806 .anchor} },

[]{#LC807 .anchor} {

[]{#LC808 .anchor} "Identifier": "StartDate",

[]{#LC809 .anchor} "SedaField": "StartDate",

[]{#LC810 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC811 .anchor} "Type": "DATE",

[]{#LC812 .anchor} "Origin": "INTERNAL",

[]{#LC813 .anchor} "ShortName": "Date de début",

[]{#LC814 .anchor} "Collections": \[

[]{#LC815 .anchor} "Unit",

[]{#LC816 .anchor} "AccessionRegisterDetail",

[]{#LC817 .anchor} "LogbookOperation"

[]{#LC818 .anchor} \]

[]{#LC819 .anchor} },

[]{#LC820 .anchor} {

[]{#LC821 .anchor} "Identifier": "Status",

[]{#LC822 .anchor} "SedaField": "Status",

[]{#LC823 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC824 .anchor} "Type": "KEYWORD",

[]{#LC825 .anchor} "Origin": "INTERNAL",

[]{#LC826 .anchor} "ShortName": "Statut",

[]{#LC827 .anchor} "Collections": \[

[]{#LC828 .anchor} "Unit",

[]{#LC829 .anchor} "AccessContract",

[]{#LC830 .anchor} "AccessionRegisterDetail",

[]{#LC831 .anchor} "ArchiveUnitProfile",

[]{#LC832 .anchor} "Context",

[]{#LC833 .anchor} "IngestContract",

[]{#LC834 .anchor} "Profile",

[]{#LC835 .anchor} "ManagementContract"

[]{#LC836 .anchor} \]

[]{#LC837 .anchor} },

[]{#LC838 .anchor} {

[]{#LC839 .anchor} "Identifier": "SystemId",

[]{#LC840 .anchor} "SedaField": "SystemId",

[]{#LC841 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant attribué aux objets. Il est attribué par le SAE et
correspond à un identifiant interne.",

[]{#LC842 .anchor} "Type": "KEYWORD",

[]{#LC843 .anchor} "Origin": "INTERNAL",

[]{#LC844 .anchor} "ShortName": "GUID",

[]{#LC845 .anchor} "Collections": \[

[]{#LC846 .anchor} "Unit"

[]{#LC847 .anchor} \]

[]{#LC848 .anchor} },

[]{#LC849 .anchor} {

[]{#LC850 .anchor} "Identifier": "Tag",

[]{#LC851 .anchor} "SedaField": "Tag",

[]{#LC852 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC853 .anchor} "Type": "KEYWORD",

[]{#LC854 .anchor} "Origin": "INTERNAL",

[]{#LC855 .anchor} "ShortName": "Tag",

[]{#LC856 .anchor} "Collections": \[

[]{#LC857 .anchor} "Unit"

[]{#LC858 .anchor} \]

[]{#LC859 .anchor} },

[]{#LC860 .anchor} {

[]{#LC861 .anchor} "Identifier": "Title",

[]{#LC862 .anchor} "SedaField": "Title",

[]{#LC863 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC864 .anchor} "Type": "TEXT",

[]{#LC865 .anchor} "Origin": "INTERNAL",

[]{#LC866 .anchor} "ShortName": "Intitulé",

[]{#LC867 .anchor} "Collections": \[

[]{#LC868 .anchor} "Unit"

[]{#LC869 .anchor} \]

[]{#LC870 .anchor} },

[]{#LC871 .anchor} {

[]{#LC872 .anchor} "Identifier": "TextContent",

[]{#LC873 .anchor} "SedaField": "TextContent",

[]{#LC874 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC875 .anchor} "Type": "TEXT",

[]{#LC876 .anchor} "Origin": "INTERNAL",

[]{#LC877 .anchor} "ShortName": "TextContent",

[]{#LC878 .anchor} "Collections": \[

[]{#LC879 .anchor} "Unit"

[]{#LC880 .anchor} \]

[]{#LC881 .anchor} },

[]{#LC882 .anchor} {

[]{#LC883 .anchor} "Identifier": "TransactedDate",

[]{#LC884 .anchor} "SedaField": "TransactedDate",

[]{#LC885 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC886 .anchor} "Type": "DATE",

[]{#LC887 .anchor} "Origin": "INTERNAL",

[]{#LC888 .anchor} "ShortName": "Date de la transaction",

[]{#LC889 .anchor} "Collections": \[

[]{#LC890 .anchor} "Unit"

[]{#LC891 .anchor} \]

[]{#LC892 .anchor} },

[]{#LC893 .anchor} {

[]{#LC894 .anchor} "Identifier":
"TransferringAgencyArchiveUnitIdentifier",

[]{#LC895 .anchor} "SedaField":
"TransferringAgencyArchiveUnitIdentifier",

[]{#LC896 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC897 .anchor} "Type": "KEYWORD",

[]{#LC898 .anchor} "Origin": "INTERNAL",

[]{#LC899 .anchor} "ShortName": "ID métier (Service versant)",

[]{#LC900 .anchor} "Collections": \[

[]{#LC901 .anchor} "Unit"

[]{#LC902 .anchor} \]

[]{#LC903 .anchor} },

[]{#LC904 .anchor} {

[]{#LC905 .anchor} "Identifier": "Type",

[]{#LC906 .anchor} "SedaField": "Type",

[]{#LC907 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC908 .anchor} "Type": "KEYWORD",

[]{#LC909 .anchor} "Origin": "INTERNAL",

[]{#LC910 .anchor} "ShortName": "Type",

[]{#LC911 .anchor} "Collections": \[

[]{#LC912 .anchor} "Unit",

[]{#LC913 .anchor} "Ontology",

[]{#LC914 .anchor} "PreservationScenario"

[]{#LC915 .anchor} \]

[]{#LC916 .anchor} },

[]{#LC917 .anchor} {

[]{#LC918 .anchor} "Identifier": "Version",

[]{#LC919 .anchor} "SedaField": "Version",

[]{#LC920 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC921 .anchor} "Type": "KEYWORD",

[]{#LC922 .anchor} "Origin": "INTERNAL",

[]{#LC923 .anchor} "ShortName": "Version",

[]{#LC924 .anchor} "Collections": \[

[]{#LC925 .anchor} "Unit",

[]{#LC926 .anchor} "FileFormat"

[]{#LC927 .anchor} \]

[]{#LC928 .anchor} },

[]{#LC929 .anchor} {

[]{#LC930 .anchor} "Identifier": "\_glpd",

[]{#LC931 .anchor} "ApiField": "\#graph\_last\_persisted\_date",

[]{#LC932 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC933 .anchor} "Type": "DATE",

[]{#LC934 .anchor} "Origin": "INTERNAL",

[]{#LC935 .anchor} "ShortName": "\_glpd",

[]{#LC936 .anchor} "Collections": \[

[]{#LC937 .anchor} "Unit",

[]{#LC938 .anchor} "ObjectGroup"

[]{#LC939 .anchor} \]

[]{#LC940 .anchor} },

[]{#LC941 .anchor} {

[]{#LC942 .anchor} "Identifier": "\_graph",

[]{#LC943 .anchor} "ApiField": "\#graph",

[]{#LC944 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC945 .anchor} "Type": "KEYWORD",

[]{#LC946 .anchor} "Origin": "INTERNAL",

[]{#LC947 .anchor} "ShortName": "\_graph",

[]{#LC948 .anchor} "Collections": \[

[]{#LC949 .anchor} "Unit"

[]{#LC950 .anchor} \]

[]{#LC951 .anchor} },

[]{#LC952 .anchor} {

[]{#LC953 .anchor} "Identifier": "\_max",

[]{#LC954 .anchor} "ApiField": "\#max",

[]{#LC955 .anchor} "Description": "Mapping : unit-es-mapping.json.
Profondeur maximale de l’unité archivistique par rapport à une racine.",

[]{#LC956 .anchor} "Type": "LONG",

[]{#LC957 .anchor} "Origin": "INTERNAL",

[]{#LC958 .anchor} "ShortName": "Profondeur maximale",

[]{#LC959 .anchor} "Collections": \[

[]{#LC960 .anchor} "Unit"

[]{#LC961 .anchor} \]

[]{#LC962 .anchor} },

[]{#LC963 .anchor} {

[]{#LC964 .anchor} "Identifier": "PreventInheritance",

[]{#LC965 .anchor} "SedaField": "PreventInheritance",

[]{#LC966 .anchor} "Description": "Mapping : unit-es-mapping.json.
Indique si les règles de gestion héritées des ArchiveUnit parents
doivent être ignorées pour l'ArchiveUnit concerné.",

[]{#LC967 .anchor} "Type": "BOOLEAN",

[]{#LC968 .anchor} "Origin": "INTERNAL",

[]{#LC969 .anchor} "ShortName": "Ignorer l'héritage",

[]{#LC970 .anchor} "Collections": \[

[]{#LC971 .anchor} "Unit"

[]{#LC972 .anchor} \]

[]{#LC973 .anchor} },

[]{#LC974 .anchor} {

[]{#LC975 .anchor} "Identifier": "PreventRearrangement",

[]{#LC976 .anchor} "SedaField": "PreventRearrangement",

[]{#LC977 .anchor} "Description": "Mapping : unit-es-mapping.json.
Blocage de la reclassification de l'ArchiveUnit lorsque la restriction
de gel est effective.",

[]{#LC978 .anchor} "Type": "BOOLEAN",

[]{#LC979 .anchor} "Origin": "INTERNAL",

[]{#LC980 .anchor} "ShortName": "Blocage de la reclassification.",

[]{#LC981 .anchor} "Collections": \[

[]{#LC982 .anchor} "Unit"

[]{#LC983 .anchor} \]

[]{#LC984 .anchor} },

[]{#LC985 .anchor} {

[]{#LC986 .anchor} "Identifier": "PreventRulesId",

[]{#LC987 .anchor} "SedaField": "RefNonRuleId",

[]{#LC988 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC989 .anchor} "Type": "KEYWORD",

[]{#LC990 .anchor} "Origin": "INTERNAL",

[]{#LC991 .anchor} "ShortName": "Bloquer la règle",

[]{#LC992 .anchor} "Collections": \[

[]{#LC993 .anchor} "Unit"

[]{#LC994 .anchor} \]

[]{#LC995 .anchor} },

[]{#LC996 .anchor} {

[]{#LC997 .anchor} "Identifier": "Rule",

[]{#LC998 .anchor} "SedaField": "Rule",

[]{#LC999 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC1000 .anchor} "Type": "KEYWORD",

[]{#LC1001 .anchor} "Origin": "INTERNAL",

[]{#LC1002 .anchor} "ShortName": "Règle de gestion",

[]{#LC1003 .anchor} "Collections": \[

[]{#LC1004 .anchor} "Unit"

[]{#LC1005 .anchor} \]

[]{#LC1006 .anchor} },

[]{#LC1007 .anchor} {

[]{#LC1008 .anchor} "Identifier": "FinalAction",

[]{#LC1009 .anchor} "SedaField": "FinalAction",

[]{#LC1010 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC1011 .anchor} "Type": "KEYWORD",

[]{#LC1012 .anchor} "Origin": "INTERNAL",

[]{#LC1013 .anchor} "ShortName": "Sort final",

[]{#LC1014 .anchor} "Collections": \[

[]{#LC1015 .anchor} "Unit"

[]{#LC1016 .anchor} \]

[]{#LC1017 .anchor} },

[]{#LC1018 .anchor} {

[]{#LC1019 .anchor} "Identifier": "ClassificationLevel",

[]{#LC1020 .anchor} "SedaField": "ClassificationLevel",

[]{#LC1021 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC1022 .anchor} "Type": "KEYWORD",

[]{#LC1023 .anchor} "Origin": "INTERNAL",

[]{#LC1024 .anchor} "ShortName": "Niveau de classification",

[]{#LC1025 .anchor} "Collections": \[

[]{#LC1026 .anchor} "Unit"

[]{#LC1027 .anchor} \]

[]{#LC1028 .anchor} },

[]{#LC1029 .anchor} {

[]{#LC1030 .anchor} "Identifier": "ClassificationOwner",

[]{#LC1031 .anchor} "SedaField": "ClassificationOwner",

[]{#LC1032 .anchor} "Description": "Mapping : unit-es-mapping.json.
Propriétaire de la classification. Service émetteur au sens de l'IGI
1300.",

[]{#LC1033 .anchor} "Type": "TEXT",

[]{#LC1034 .anchor} "Origin": "INTERNAL",

[]{#LC1035 .anchor} "ShortName": "Service émetteur / Propriétaire de la
classification",

[]{#LC1036 .anchor} "Collections": \[

[]{#LC1037 .anchor} "Unit"

[]{#LC1038 .anchor} \]

[]{#LC1039 .anchor} },

[]{#LC1040 .anchor} {

[]{#LC1041 .anchor} "Identifier": "ClassificationAudience",

[]{#LC1042 .anchor} "SedaField": "ClassificationAudience",

[]{#LC1043 .anchor} "Description": "Mapping : unit-es-mapping.json.
Permet de gérer les questions de 'diffusion restreinte', de 'spécial
France' et de 'Confidentiel Industrie'.",

[]{#LC1044 .anchor} "Type": "TEXT",

[]{#LC1045 .anchor} "Origin": "INTERNAL",

[]{#LC1046 .anchor} "ShortName": "Audience de la classification",

[]{#LC1047 .anchor} "Collections": \[

[]{#LC1048 .anchor} "Unit"

[]{#LC1049 .anchor} \]

[]{#LC1050 .anchor} },

[]{#LC1051 .anchor} {

[]{#LC1052 .anchor} "Identifier": "ClassificationReassessingDate",

[]{#LC1053 .anchor} "SedaField": "ClassificationReassessingDate",

[]{#LC1054 .anchor} "Description": "Mapping : unit-es-mapping.json. Date
de réévaluation de la classification.",

[]{#LC1055 .anchor} "Type": "DATE",

[]{#LC1056 .anchor} "Origin": "INTERNAL",

[]{#LC1057 .anchor} "ShortName": "Date de réévaluation",

[]{#LC1058 .anchor} "Collections": \[

[]{#LC1059 .anchor} "Unit"

[]{#LC1060 .anchor} \]

[]{#LC1061 .anchor} },

[]{#LC1062 .anchor} {

[]{#LC1063 .anchor} "Identifier": "NeedReassessingAuthorization",

[]{#LC1064 .anchor} "SedaField": "NeedReassessingAuthorization",

[]{#LC1065 .anchor} "Description": "Mapping : unit-es-mapping.json.
Indique si une autorisation humaine est nécessaire pour réévaluer la
classification.",

[]{#LC1066 .anchor} "Type": "BOOLEAN",

[]{#LC1067 .anchor} "Origin": "INTERNAL",

[]{#LC1068 .anchor} "ShortName": "Autorisation",

[]{#LC1069 .anchor} "Collections": \[

[]{#LC1070 .anchor} "Unit"

[]{#LC1071 .anchor} \]

[]{#LC1072 .anchor} },

[]{#LC1073 .anchor} {

[]{#LC1074 .anchor} "Identifier": "NeedAuthorization",

[]{#LC1075 .anchor} "SedaField": "NeedAuthorization",

[]{#LC1076 .anchor} "Description": "Mapping : unit-es-mapping.json.
Indique si une autorisation humaine est nécessaire pour vérifier ou
valider les opérations de gestion des ArchiveUnit.",

[]{#LC1077 .anchor} "Type": "BOOLEAN",

[]{#LC1078 .anchor} "Origin": "INTERNAL",

[]{#LC1079 .anchor} "ShortName": "Autorisation",

[]{#LC1080 .anchor} "Collections": \[

[]{#LC1081 .anchor} "Unit"

[]{#LC1082 .anchor} \]

[]{#LC1083 .anchor} },

[]{#LC1084 .anchor} {

[]{#LC1085 .anchor} "Identifier": "\_min",

[]{#LC1086 .anchor} "ApiField": "\#min",

[]{#LC1087 .anchor} "Description": "Mapping : unit-es-mapping.json.
Profondeur minimum de l’unité archivistique par rapport à une racine.",

[]{#LC1088 .anchor} "Type": "LONG",

[]{#LC1089 .anchor} "Origin": "INTERNAL",

[]{#LC1090 .anchor} "ShortName": "Profondeur minimale",

[]{#LC1091 .anchor} "Collections": \[

[]{#LC1092 .anchor} "Unit"

[]{#LC1093 .anchor} \]

[]{#LC1094 .anchor} },

[]{#LC1095 .anchor} {

[]{#LC1096 .anchor} "Identifier": "\_nbc",

[]{#LC1097 .anchor} "ApiField": "\_nbc",

[]{#LC1098 .anchor} "Description": "Mapping : unit-es-mapping.json.
Nombre d’objets correspondant à un usage ou à un groupe d'objets.",

[]{#LC1099 .anchor} "Type": "LONG",

[]{#LC1100 .anchor} "Origin": "INTERNAL",

[]{#LC1101 .anchor} "ShortName": "Nombre d’objets",

[]{#LC1102 .anchor} "Collections": \[

[]{#LC1103 .anchor} "Unit",

[]{#LC1104 .anchor} "ObjectGroup"

[]{#LC1105 .anchor} \]

[]{#LC1106 .anchor} },

[]{#LC1107 .anchor} {

[]{#LC1108 .anchor} "Identifier": "\_og",

[]{#LC1109 .anchor} "ApiField": "\#object",

[]{#LC1110 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant du groupe d’objets représentant cette unité archivistique.",

[]{#LC1111 .anchor} "Type": "KEYWORD",

[]{#LC1112 .anchor} "Origin": "INTERNAL",

[]{#LC1113 .anchor} "ShortName": "Identifiant du groupe d’objets",

[]{#LC1114 .anchor} "Collections": \[

[]{#LC1115 .anchor} "Unit"

[]{#LC1116 .anchor} \]

[]{#LC1117 .anchor} },

[]{#LC1118 .anchor} {

[]{#LC1119 .anchor} "Identifier": "\_opi",

[]{#LC1120 .anchor} "ApiField": "\#opi",

[]{#LC1121 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant de l’opération à l’origine de la création de cette unité
archivistique.",

[]{#LC1122 .anchor} "Type": "KEYWORD",

[]{#LC1123 .anchor} "Origin": "INTERNAL",

[]{#LC1124 .anchor} "ShortName": "Opération initiale",

[]{#LC1125 .anchor} "Collections": \[

[]{#LC1126 .anchor} "Unit",

[]{#LC1127 .anchor} "ObjectGroup"

[]{#LC1128 .anchor} \]

[]{#LC1129 .anchor} },

[]{#LC1130 .anchor} {

[]{#LC1131 .anchor} "Identifier": "\_ops",

[]{#LC1132 .anchor} "ApiField": "\#operations",

[]{#LC1133 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiants d’opérations auxquelles cette unité archivistique a
participé.",

[]{#LC1134 .anchor} "Type": "KEYWORD",

[]{#LC1135 .anchor} "Origin": "INTERNAL",

[]{#LC1136 .anchor} "ShortName": "Opérations",

[]{#LC1137 .anchor} "Collections": \[

[]{#LC1138 .anchor} "Unit",

[]{#LC1139 .anchor} "ObjectGroup"

[]{#LC1140 .anchor} \]

[]{#LC1141 .anchor} },

[]{#LC1142 .anchor} {

[]{#LC1143 .anchor} "Identifier": "\_opts",

[]{#LC1144 .anchor} "ApiField": "\#opts",

[]{#LC1145 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiants de l’opération dans laquelle l'unité archivistique est en
cours de transfert",

[]{#LC1146 .anchor} "Type": "KEYWORD",

[]{#LC1147 .anchor} "Origin": "INTERNAL",

[]{#LC1148 .anchor} "ShortName": "Opérations de transfert",

[]{#LC1149 .anchor} "Collections": \[

[]{#LC1150 .anchor} "Unit"

[]{#LC1151 .anchor} \]

[]{#LC1152 .anchor} },

[]{#LC1153 .anchor} {

[]{#LC1154 .anchor} "Identifier": "\_sp",

[]{#LC1155 .anchor} "SedaField": "OriginatingAgencyIdentifier",

[]{#LC1156 .anchor} "ApiField": "\#originating\_agency",

[]{#LC1157 .anchor} "Description": "Mapping : unit-es-mapping.json.
Service producteur d’origine déclaré lors de la prise en charge de
l’unité archivistique par la solution logicielle Vitam.",

[]{#LC1158 .anchor} "Type": "KEYWORD",

[]{#LC1159 .anchor} "Origin": "INTERNAL",

[]{#LC1160 .anchor} "ShortName": "Service producteur",

[]{#LC1161 .anchor} "Collections": \[

[]{#LC1162 .anchor} "Unit",

[]{#LC1163 .anchor} "ObjectGroup"

[]{#LC1164 .anchor} \]

[]{#LC1165 .anchor} },

[]{#LC1166 .anchor} {

[]{#LC1167 .anchor} "Identifier": "\_sps",

[]{#LC1168 .anchor} "ApiField": "\#originating\_agencies",

[]{#LC1169 .anchor} "Description": "Mapping : unit-es-mapping.json.
Services producteurs liés à l’unité archivistique suite à un
rattachement et ayant des droits d’accès sur celle-ci.",

[]{#LC1170 .anchor} "Type": "KEYWORD",

[]{#LC1171 .anchor} "Origin": "INTERNAL",

[]{#LC1172 .anchor} "ShortName": "Services producteurs liés à l’unité
archivistique",

[]{#LC1173 .anchor} "Collections": \[

[]{#LC1174 .anchor} "Unit",

[]{#LC1175 .anchor} "ObjectGroup"

[]{#LC1176 .anchor} \]

[]{#LC1177 .anchor} },

[]{#LC1178 .anchor} {

[]{#LC1179 .anchor} "Identifier": "offerIds",

[]{#LC1180 .anchor} "ApiField": "offerIds",

[]{#LC1181 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC1182 .anchor} "Type": "KEYWORD",

[]{#LC1183 .anchor} "Origin": "INTERNAL",

[]{#LC1184 .anchor} "ShortName": "offerIds",

[]{#LC1185 .anchor} "Collections": \[

[]{#LC1186 .anchor} "Unit",

[]{#LC1187 .anchor} "ObjectGroup"

[]{#LC1188 .anchor} \]

[]{#LC1189 .anchor} },

[]{#LC1190 .anchor} {

[]{#LC1191 .anchor} "Identifier": "strategyId",

[]{#LC1192 .anchor} "ApiField": "strategyId",

[]{#LC1193 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC1194 .anchor} "Type": "KEYWORD",

[]{#LC1195 .anchor} "Origin": "INTERNAL",

[]{#LC1196 .anchor} "ShortName": "strategyId",

[]{#LC1197 .anchor} "Collections": \[

[]{#LC1198 .anchor} "Unit",

[]{#LC1199 .anchor} "ObjectGroup"

[]{#LC1200 .anchor} \]

[]{#LC1201 .anchor} },

[]{#LC1202 .anchor} {

[]{#LC1203 .anchor} "Identifier": "\_tenant",

[]{#LC1204 .anchor} "ApiField": "\#tenant",

[]{#LC1205 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant du tenant.",

[]{#LC1206 .anchor} "Type": "LONG",

[]{#LC1207 .anchor} "Origin": "INTERNAL",

[]{#LC1208 .anchor} "ShortName": "Tenant",

[]{#LC1209 .anchor} "Collections": \[

[]{#LC1210 .anchor} "Unit",

[]{#LC1211 .anchor} "ObjectGroup",

[]{#LC1212 .anchor} "AccessContract",

[]{#LC1213 .anchor} "AccessionRegisterDetail",

[]{#LC1214 .anchor} "AccessionRegisterSummary",

[]{#LC1215 .anchor} "AccessionRegisterSymbolic",

[]{#LC1216 .anchor} "Agencies",

[]{#LC1217 .anchor} "ArchiveUnitProfile",

[]{#LC1218 .anchor} "IngestContract",

[]{#LC1219 .anchor} "Ontology",

[]{#LC1220 .anchor} "Profile",

[]{#LC1221 .anchor} "FileRules",

[]{#LC1222 .anchor} "LogbookOperation",

[]{#LC1223 .anchor} "Griffin",

[]{#LC1224 .anchor} "PreservationScenario",

[]{#LC1225 .anchor} "ManagementContract"

[]{#LC1226 .anchor} \]

[]{#LC1227 .anchor} },

[]{#LC1228 .anchor} {

[]{#LC1229 .anchor} "Identifier": "\_unitType",

[]{#LC1230 .anchor} "ApiField": "\#unitType",

[]{#LC1231 .anchor} "Description": "Mapping : unit-es-mapping.json. Type
d’unité archivistique concerné : SIP, plan de classement, arbre de
positionnement.",

[]{#LC1232 .anchor} "Type": "KEYWORD",

[]{#LC1233 .anchor} "Origin": "INTERNAL",

[]{#LC1234 .anchor} "ShortName": "Type d'unité archivistique",

[]{#LC1235 .anchor} "Collections": \[

[]{#LC1236 .anchor} "Unit"

[]{#LC1237 .anchor} \]

[]{#LC1238 .anchor} },

[]{#LC1239 .anchor} {

[]{#LC1240 .anchor} "Identifier": "\_up",

[]{#LC1241 .anchor} "ApiField": "\#unitups",

[]{#LC1242 .anchor} "Description": "Mapping : unit-es-mapping.json. Pour
une unité archivistique, identifiant(s) des unités archivistiques
parentes (parents immédiats). Pour un groupe d'objets, identifiant(s)
des unités archivistiques représentées par ce groupe d’objets.",

[]{#LC1243 .anchor} "Type": "KEYWORD",

[]{#LC1244 .anchor} "Origin": "INTERNAL",

[]{#LC1245 .anchor} "ShortName": "Identifiant(s) des unités
archivistiques parentes (parents immédiats)",

[]{#LC1246 .anchor} "Collections": \[

[]{#LC1247 .anchor} "Unit",

[]{#LC1248 .anchor} "ObjectGroup"

[]{#LC1249 .anchor} \]

[]{#LC1250 .anchor} },

[]{#LC1251 .anchor} {

[]{#LC1252 .anchor} "Identifier": "\_us",

[]{#LC1253 .anchor} "ApiField": "\#allunitups",

[]{#LC1254 .anchor} "Description": "Mapping : unit-es-mapping.json.
Tableau contenant la parentalité, c’est à dire l’ensemble des unités
archivistiques parentes, indexé de la manière suivante : \[ GUID1,
GUID2, … \].",

[]{#LC1255 .anchor} "Type": "KEYWORD",

[]{#LC1256 .anchor} "Origin": "INTERNAL",

[]{#LC1257 .anchor} "ShortName": "Identifiant(s) des unités
archivistiques parentes",

[]{#LC1258 .anchor} "Collections": \[

[]{#LC1259 .anchor} "Unit",

[]{#LC1260 .anchor} "ObjectGroup"

[]{#LC1261 .anchor} \]

[]{#LC1262 .anchor} },

[]{#LC1263 .anchor} {

[]{#LC1264 .anchor} "Identifier": "\_v",

[]{#LC1265 .anchor} "ApiField": "\#version",

[]{#LC1266 .anchor} "Description": "Mapping : unit-es-mapping.json.
Version de l’enregistrement décrit.",

[]{#LC1267 .anchor} "Type": "LONG",

[]{#LC1268 .anchor} "Origin": "INTERNAL",

[]{#LC1269 .anchor} "ShortName": "Version",

[]{#LC1270 .anchor} "Collections": \[

[]{#LC1271 .anchor} "Unit",

[]{#LC1272 .anchor} "ObjectGroup",

[]{#LC1273 .anchor} "AccessContract",

[]{#LC1274 .anchor} "AccessionRegisterDetail",

[]{#LC1275 .anchor} "AccessionRegisterSummary",

[]{#LC1276 .anchor} "AccessionRegisterSymbolic",

[]{#LC1277 .anchor} "Agencies",

[]{#LC1278 .anchor} "ArchiveUnitProfile",

[]{#LC1279 .anchor} "Context",

[]{#LC1280 .anchor} "FileFormat",

[]{#LC1281 .anchor} "IngestContract",

[]{#LC1282 .anchor} "Ontology",

[]{#LC1283 .anchor} "Profile",

[]{#LC1284 .anchor} "FileRules",

[]{#LC1285 .anchor} "SecurityProfile",

[]{#LC1286 .anchor} "LogbookOperation",

[]{#LC1287 .anchor} "Griffin",

[]{#LC1288 .anchor} "PreservationScenario",

[]{#LC1289 .anchor} "ManagementContract"

[]{#LC1290 .anchor} \]

[]{#LC1291 .anchor} },

[]{#LC1292 .anchor} {

[]{#LC1293 .anchor} "Identifier": "\_av",

[]{#LC1294 .anchor} "ApiField": "\_av",

[]{#LC1295 .anchor} "Description": "Version interne de l’enregistrement
décrit.",

[]{#LC1296 .anchor} "Type": "LONG",

[]{#LC1297 .anchor} "Origin": "INTERNAL",

[]{#LC1298 .anchor} "ShortName": "Version",

[]{#LC1299 .anchor} "Collections": \[

[]{#LC1300 .anchor} "Unit",

[]{#LC1301 .anchor} "ObjectGroup"

[]{#LC1302 .anchor} \]

[]{#LC1303 .anchor} },

[]{#LC1304 .anchor} {

[]{#LC1305 .anchor} "Identifier": "CreatingApplicationName",

[]{#LC1306 .anchor} "SedaField": "CreatingApplicationName",

[]{#LC1307 .anchor} "Description": "Mapping : og-es-mapping.json.
Version de l'application utilisée pour créer le fichier.",

[]{#LC1308 .anchor} "Type": "TEXT",

[]{#LC1309 .anchor} "Origin": "INTERNAL",

[]{#LC1310 .anchor} "ShortName": "Nom de l'application",

[]{#LC1311 .anchor} "Collections": \[

[]{#LC1312 .anchor} "ObjectGroup"

[]{#LC1313 .anchor} \]

[]{#LC1314 .anchor} },

[]{#LC1315 .anchor} {

[]{#LC1316 .anchor} "Identifier": "CreatingApplicationVersion",

[]{#LC1317 .anchor} "SedaField": "CreatingApplicationVersion",

[]{#LC1318 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1319 .anchor} "Type": "TEXT",

[]{#LC1320 .anchor} "Origin": "INTERNAL",

[]{#LC1321 .anchor} "ShortName": "Version de l'application",

[]{#LC1322 .anchor} "Collections": \[

[]{#LC1323 .anchor} "ObjectGroup"

[]{#LC1324 .anchor} \]

[]{#LC1325 .anchor} },

[]{#LC1326 .anchor} {

[]{#LC1327 .anchor} "Identifier": "CreatingOs",

[]{#LC1328 .anchor} "SedaField": "CreatingOs",

[]{#LC1329 .anchor} "Description": "Mapping : og-es-mapping.json.
Système d'exploitation utilisé pour créer le fichier.",

[]{#LC1330 .anchor} "Type": "TEXT",

[]{#LC1331 .anchor} "Origin": "INTERNAL",

[]{#LC1332 .anchor} "ShortName": "Système d'exploitation",

[]{#LC1333 .anchor} "Collections": \[

[]{#LC1334 .anchor} "ObjectGroup"

[]{#LC1335 .anchor} \]

[]{#LC1336 .anchor} },

[]{#LC1337 .anchor} {

[]{#LC1338 .anchor} "Identifier": "CreatingOsVersion",

[]{#LC1339 .anchor} "SedaField": "CreatingOsVersion",

[]{#LC1340 .anchor} "Description": "Mapping : og-es-mapping.json.
Version du système d'exploitation utilisé pour créer le fichier.",

[]{#LC1341 .anchor} "Type": "TEXT",

[]{#LC1342 .anchor} "Origin": "INTERNAL",

[]{#LC1343 .anchor} "ShortName": "Version du système d'exploitation",

[]{#LC1344 .anchor} "Collections": \[

[]{#LC1345 .anchor} "ObjectGroup"

[]{#LC1346 .anchor} \]

[]{#LC1347 .anchor} },

[]{#LC1348 .anchor} {

[]{#LC1349 .anchor} "Identifier": "DateCreatedByApplication",

[]{#LC1350 .anchor} "SedaField": "DateCreatedByApplication",

[]{#LC1351 .anchor} "Description": "Mapping : og-es-mapping.json. Date
de création du fichier.",

[]{#LC1352 .anchor} "Type": "DATE",

[]{#LC1353 .anchor} "Origin": "INTERNAL",

[]{#LC1354 .anchor} "ShortName": "Date de création",

[]{#LC1355 .anchor} "Collections": \[

[]{#LC1356 .anchor} "ObjectGroup"

[]{#LC1357 .anchor} \]

[]{#LC1358 .anchor} },

[]{#LC1359 .anchor} {

[]{#LC1360 .anchor} "Identifier": "Filename",

[]{#LC1361 .anchor} "SedaField": "Filename",

[]{#LC1362 .anchor} "Description": "Mapping : og-es-mapping.json. Nom du
fichier d'origine.",

[]{#LC1363 .anchor} "Type": "TEXT",

[]{#LC1364 .anchor} "Origin": "INTERNAL",

[]{#LC1365 .anchor} "ShortName": "Nom du fichier",

[]{#LC1366 .anchor} "Collections": \[

[]{#LC1367 .anchor} "ObjectGroup",

[]{#LC1368 .anchor} "LogbookOperation"

[]{#LC1369 .anchor} \]

[]{#LC1370 .anchor} },

[]{#LC1371 .anchor} {

[]{#LC1372 .anchor} "Identifier": "LastModified",

[]{#LC1373 .anchor} "SedaField": "LastModified",

[]{#LC1374 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1375 .anchor} "Type": "DATE",

[]{#LC1376 .anchor} "Origin": "INTERNAL",

[]{#LC1377 .anchor} "ShortName": "Dernière modification",

[]{#LC1378 .anchor} "Collections": \[

[]{#LC1379 .anchor} "ObjectGroup"

[]{#LC1380 .anchor} \]

[]{#LC1381 .anchor} },

[]{#LC1382 .anchor} {

[]{#LC1383 .anchor} "Identifier": "\_profil",

[]{#LC1384 .anchor} "ApiField": "\_profil",

[]{#LC1385 .anchor} "Description": "Mapping : og-es-mapping.json.
Catégorie de l’objet. Valeurs possibles : Audio, Document, Text, Image
et Video. Des extensions seront possibles (Database, Plan3D, …).",

[]{#LC1386 .anchor} "Type": "KEYWORD",

[]{#LC1387 .anchor} "Origin": "INTERNAL",

[]{#LC1388 .anchor} "ShortName": "Catégorie d'objet",

[]{#LC1389 .anchor} "Collections": \[

[]{#LC1390 .anchor} "ObjectGroup"

[]{#LC1391 .anchor} \]

[]{#LC1392 .anchor} },

[]{#LC1393 .anchor} {

[]{#LC1394 .anchor} "Identifier": "qualifier",

[]{#LC1395 .anchor} "ApiField": "qualifier",

[]{#LC1396 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1397 .anchor} "Type": "KEYWORD",

[]{#LC1398 .anchor} "Origin": "INTERNAL",

[]{#LC1399 .anchor} "ShortName": "Usage",

[]{#LC1400 .anchor} "Collections": \[

[]{#LC1401 .anchor} "ObjectGroup"

[]{#LC1402 .anchor} \]

[]{#LC1403 .anchor} },

[]{#LC1404 .anchor} {

[]{#LC1405 .anchor} "Identifier": "DataObjectGroupId",

[]{#LC1406 .anchor} "SedaField": "DataObjectGroupId",

[]{#LC1407 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1408 .anchor} "Type": "KEYWORD",

[]{#LC1409 .anchor} "Origin": "INTERNAL",

[]{#LC1410 .anchor} "ShortName": "Identifiant du groupe d'objets
techniques",

[]{#LC1411 .anchor} "Collections": \[

[]{#LC1412 .anchor} "ObjectGroup"

[]{#LC1413 .anchor} \]

[]{#LC1414 .anchor} },

[]{#LC1415 .anchor} {

[]{#LC1416 .anchor} "Identifier": "DataObjectVersion",

[]{#LC1417 .anchor} "SedaField": "DataObjectVersion",

[]{#LC1418 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1419 .anchor} "Type": "KEYWORD",

[]{#LC1420 .anchor} "Origin": "INTERNAL",

[]{#LC1421 .anchor} "ShortName": "Usage",

[]{#LC1422 .anchor} "Collections": \[

[]{#LC1423 .anchor} "ObjectGroup",

[]{#LC1424 .anchor} "AccessContract",

[]{#LC1425 .anchor} "IngestContract"

[]{#LC1426 .anchor} \]

[]{#LC1427 .anchor} },

[]{#LC1428 .anchor} {

[]{#LC1429 .anchor} "Identifier": "Encoding",

[]{#LC1430 .anchor} "SedaField": "Encoding",

[]{#LC1431 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1432 .anchor} "Type": "KEYWORD",

[]{#LC1433 .anchor} "Origin": "INTERNAL",

[]{#LC1434 .anchor} "ShortName": "Encodage",

[]{#LC1435 .anchor} "Collections": \[

[]{#LC1436 .anchor} "ObjectGroup"

[]{#LC1437 .anchor} \]

[]{#LC1438 .anchor} },

[]{#LC1439 .anchor} {

[]{#LC1440 .anchor} "Identifier": "FormatId",

[]{#LC1441 .anchor} "SedaField": "FormatId",

[]{#LC1442 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1443 .anchor} "Type": "KEYWORD",

[]{#LC1444 .anchor} "Origin": "INTERNAL",

[]{#LC1445 .anchor} "ShortName": "PUID du format",

[]{#LC1446 .anchor} "Collections": \[

[]{#LC1447 .anchor} "ObjectGroup"

[]{#LC1448 .anchor} \]

[]{#LC1449 .anchor} },

[]{#LC1450 .anchor} {

[]{#LC1451 .anchor} "Identifier": "FormatLitteral",

[]{#LC1452 .anchor} "SedaField": "FormatLitteral",

[]{#LC1453 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1454 .anchor} "Type": "KEYWORD",

[]{#LC1455 .anchor} "Origin": "INTERNAL",

[]{#LC1456 .anchor} "ShortName": "Nom litteral",

[]{#LC1457 .anchor} "Collections": \[

[]{#LC1458 .anchor} "ObjectGroup"

[]{#LC1459 .anchor} \]

[]{#LC1460 .anchor} },

[]{#LC1461 .anchor} {

[]{#LC1462 .anchor} "Identifier": "MimeType",

[]{#LC1463 .anchor} "SedaField": "MimeType",

[]{#LC1464 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1465 .anchor} "Type": "KEYWORD",

[]{#LC1466 .anchor} "Origin": "INTERNAL",

[]{#LC1467 .anchor} "ShortName": "Type Mime",

[]{#LC1468 .anchor} "Collections": \[

[]{#LC1469 .anchor} "ObjectGroup",

[]{#LC1470 .anchor} "FileFormat"

[]{#LC1471 .anchor} \]

[]{#LC1472 .anchor} },

[]{#LC1473 .anchor} {

[]{#LC1474 .anchor} "Identifier": "MessageDigest",

[]{#LC1475 .anchor} "SedaField": "MessageDigest",

[]{#LC1476 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1477 .anchor} "Type": "KEYWORD",

[]{#LC1478 .anchor} "Origin": "INTERNAL",

[]{#LC1479 .anchor} "ShortName": "Empreinte",

[]{#LC1480 .anchor} "Collections": \[

[]{#LC1481 .anchor} "Unit",

[]{#LC1482 .anchor} "ObjectGroup"

[]{#LC1483 .anchor} \]

[]{#LC1484 .anchor} },

[]{#LC1485 .anchor} {

[]{#LC1486 .anchor} "Identifier": "dValue",

[]{#LC1487 .anchor} "SedaField": "Value",

[]{#LC1488 .anchor} "ApiField": "dValue",

[]{#LC1489 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1490 .anchor} "Type": "DOUBLE",

[]{#LC1491 .anchor} "Origin": "INTERNAL",

[]{#LC1492 .anchor} "ShortName": "Valeur",

[]{#LC1493 .anchor} "Collections": \[

[]{#LC1494 .anchor} "ObjectGroup"

[]{#LC1495 .anchor} \]

[]{#LC1496 .anchor} },

[]{#LC1497 .anchor} {

[]{#LC1498 .anchor} "Identifier": "unit",

[]{#LC1499 .anchor} "SedaField": "unit",

[]{#LC1500 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1501 .anchor} "Type": "KEYWORD",

[]{#LC1502 .anchor} "Origin": "INTERNAL",

[]{#LC1503 .anchor} "ShortName": "Unité",

[]{#LC1504 .anchor} "Collections": \[

[]{#LC1505 .anchor} "ObjectGroup"

[]{#LC1506 .anchor} \]

[]{#LC1507 .anchor} },

[]{#LC1508 .anchor} {

[]{#LC1509 .anchor} "Identifier": "NumberOfPage",

[]{#LC1510 .anchor} "SedaField": "NumberOfPage",

[]{#LC1511 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1512 .anchor} "Type": "LONG",

[]{#LC1513 .anchor} "Origin": "INTERNAL",

[]{#LC1514 .anchor} "ShortName": "Nombre de pages",

[]{#LC1515 .anchor} "Collections": \[

[]{#LC1516 .anchor} "ObjectGroup"

[]{#LC1517 .anchor} \]

[]{#LC1518 .anchor} },

[]{#LC1519 .anchor} {

[]{#LC1520 .anchor} "Identifier": "Shape",

[]{#LC1521 .anchor} "SedaField": "Shape",

[]{#LC1522 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1523 .anchor} "Type": "KEYWORD",

[]{#LC1524 .anchor} "Origin": "INTERNAL",

[]{#LC1525 .anchor} "ShortName": "Forme",

[]{#LC1526 .anchor} "Collections": \[

[]{#LC1527 .anchor} "ObjectGroup"

[]{#LC1528 .anchor} \]

[]{#LC1529 .anchor} },

[]{#LC1530 .anchor} {

[]{#LC1531 .anchor} "Identifier": "PhysicalId",

[]{#LC1532 .anchor} "SedaField": "PhysicalId",

[]{#LC1533 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1534 .anchor} "Type": "KEYWORD",

[]{#LC1535 .anchor} "Origin": "INTERNAL",

[]{#LC1536 .anchor} "ShortName": "Identifiant d'objet physique",

[]{#LC1537 .anchor} "Collections": \[

[]{#LC1538 .anchor} "ObjectGroup"

[]{#LC1539 .anchor} \]

[]{#LC1540 .anchor} },

[]{#LC1541 .anchor} {

[]{#LC1542 .anchor} "Identifier": "Size",

[]{#LC1543 .anchor} "SedaField": "Size",

[]{#LC1544 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1545 .anchor} "Type": "LONG",

[]{#LC1546 .anchor} "Origin": "INTERNAL",

[]{#LC1547 .anchor} "ShortName": "Taille (en octets)",

[]{#LC1548 .anchor} "Collections": \[

[]{#LC1549 .anchor} "ObjectGroup",

[]{#LC1550 .anchor} "LogbookOperation"

[]{#LC1551 .anchor} \]

[]{#LC1552 .anchor} },

[]{#LC1553 .anchor} {

[]{#LC1554 .anchor} "Identifier": "Uri",

[]{#LC1555 .anchor} "SedaField": "Uri",

[]{#LC1556 .anchor} "Description": "Mapping : og-es-mapping.json",

[]{#LC1557 .anchor} "Type": "KEYWORD",

[]{#LC1558 .anchor} "Origin": "INTERNAL",

[]{#LC1559 .anchor} "ShortName": "Uri",

[]{#LC1560 .anchor} "Collections": \[

[]{#LC1561 .anchor} "ObjectGroup"

[]{#LC1562 .anchor} \]

[]{#LC1563 .anchor} },

[]{#LC1564 .anchor} {

[]{#LC1565 .anchor} "Identifier": "\_id",

[]{#LC1566 .anchor} "ApiField": "\#id",

[]{#LC1567 .anchor} "Description": "Mapping : og-es-mapping.json.
Identifiant du groupe d’objets",

[]{#LC1568 .anchor} "Type": "KEYWORD",

[]{#LC1569 .anchor} "Origin": "INTERNAL",

[]{#LC1570 .anchor} "ShortName": "Identifiant du groupe d'objets",

[]{#LC1571 .anchor} "Collections": \[

[]{#LC1572 .anchor} "ObjectGroup",

[]{#LC1573 .anchor} "Griffin",

[]{#LC1574 .anchor} "PreservationScenario",

[]{#LC1575 .anchor} "Unit",

[]{#LC1576 .anchor} "AccessContract",

[]{#LC1577 .anchor} "ArchiveUnitProfile",

[]{#LC1578 .anchor} "Profile",

[]{#LC1579 .anchor} "Ontology",

[]{#LC1580 .anchor} "Context",

[]{#LC1581 .anchor} "IngestContract",

[]{#LC1582 .anchor} "LogbookOperation",

[]{#LC1583 .anchor} "LogbookLifeCycleUnit",

[]{#LC1584 .anchor} "LogbookLifeCycleObjectGroup",

[]{#LC1585 .anchor} "AccessionRegisterDetail",

[]{#LC1586 .anchor} "AccessionRegisterSummary",

[]{#LC1587 .anchor} "AccessionRegisterSymbolic",

[]{#LC1588 .anchor} "Agencies",

[]{#LC1589 .anchor} "SecurityProfile",

[]{#LC1590 .anchor} "FileRules",

[]{#LC1591 .anchor} "FileFormat",

[]{#LC1592 .anchor} "ManagementContract"

[]{#LC1593 .anchor} \]

[]{#LC1594 .anchor} },

[]{#LC1595 .anchor} {

[]{#LC1596 .anchor} "Identifier": "AccessLog",

[]{#LC1597 .anchor} "ApiField": "AccessLog",

[]{#LC1598 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1599 .anchor} "Type": "KEYWORD",

[]{#LC1600 .anchor} "Origin": "INTERNAL",

[]{#LC1601 .anchor} "ShortName": "Log des accès",

[]{#LC1602 .anchor} "Collections": \[

[]{#LC1603 .anchor} "AccessContract"

[]{#LC1604 .anchor} \]

[]{#LC1605 .anchor} },

[]{#LC1606 .anchor} {

[]{#LC1607 .anchor} "Identifier": "ActivationDate",

[]{#LC1608 .anchor} "ApiField": "ActivationDate",

[]{#LC1609 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1610 .anchor} "Type": "DATE",

[]{#LC1611 .anchor} "Origin": "INTERNAL",

[]{#LC1612 .anchor} "ShortName": "Date d'activation",

[]{#LC1613 .anchor} "Collections": \[

[]{#LC1614 .anchor} "AccessContract",

[]{#LC1615 .anchor} "ArchiveUnitProfile",

[]{#LC1616 .anchor} "Context",

[]{#LC1617 .anchor} "IngestContract",

[]{#LC1618 .anchor} "Profile",

[]{#LC1619 .anchor} "ManagementContract"

[]{#LC1620 .anchor} \]

[]{#LC1621 .anchor} },

[]{#LC1622 .anchor} {

[]{#LC1623 .anchor} "Identifier": "CreationDate",

[]{#LC1624 .anchor} "ApiField": "CreationDate",

[]{#LC1625 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1626 .anchor} "Type": "DATE",

[]{#LC1627 .anchor} "Origin": "INTERNAL",

[]{#LC1628 .anchor} "ShortName": "Date de création",

[]{#LC1629 .anchor} "Collections": \[

[]{#LC1630 .anchor} "AccessContract",

[]{#LC1631 .anchor} "AccessionRegisterSummary",

[]{#LC1632 .anchor} "AccessionRegisterDetail",

[]{#LC1633 .anchor} "AccessionRegisterSymbolic",

[]{#LC1634 .anchor} "ArchiveUnitProfile",

[]{#LC1635 .anchor} "Context",

[]{#LC1636 .anchor} "IngestContract",

[]{#LC1637 .anchor} "Ontology",

[]{#LC1638 .anchor} "Profile",

[]{#LC1639 .anchor} "FileRules",

[]{#LC1640 .anchor} "Griffin",

[]{#LC1641 .anchor} "PreservationScenario",

[]{#LC1642 .anchor} "ManagementContract"

[]{#LC1643 .anchor} \]

[]{#LC1644 .anchor} },

[]{#LC1645 .anchor} {

[]{#LC1646 .anchor} "Identifier": "DeactivationDate",

[]{#LC1647 .anchor} "ApiField": "DeactivationDate",

[]{#LC1648 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1649 .anchor} "Type": "DATE",

[]{#LC1650 .anchor} "Origin": "INTERNAL",

[]{#LC1651 .anchor} "ShortName": "Date de désactivation",

[]{#LC1652 .anchor} "Collections": \[

[]{#LC1653 .anchor} "AccessContract",

[]{#LC1654 .anchor} "ArchiveUnitProfile",

[]{#LC1655 .anchor} "Context",

[]{#LC1656 .anchor} "IngestContract",

[]{#LC1657 .anchor} "Profile",

[]{#LC1658 .anchor} "ManagementContract"

[]{#LC1659 .anchor} \]

[]{#LC1660 .anchor} },

[]{#LC1661 .anchor} {

[]{#LC1662 .anchor} "Identifier": "EveryDataObjectVersion",

[]{#LC1663 .anchor} "ApiField": "EveryDataObjectVersion",

[]{#LC1664 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1665 .anchor} "Type": "BOOLEAN",

[]{#LC1666 .anchor} "Origin": "INTERNAL",

[]{#LC1667 .anchor} "ShortName": "Tous les usages",

[]{#LC1668 .anchor} "Collections": \[

[]{#LC1669 .anchor} "AccessContract",

[]{#LC1670 .anchor} "IngestContract"

[]{#LC1671 .anchor} \]

[]{#LC1672 .anchor} },

[]{#LC1673 .anchor} {

[]{#LC1674 .anchor} "Identifier": "EveryOriginatingAgency",

[]{#LC1675 .anchor} "ApiField": "EveryOriginatingAgency",

[]{#LC1676 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1677 .anchor} "Type": "BOOLEAN",

[]{#LC1678 .anchor} "Origin": "INTERNAL",

[]{#LC1679 .anchor} "ShortName": "Tous les services producteurs",

[]{#LC1680 .anchor} "Collections": \[

[]{#LC1681 .anchor} "AccessContract"

[]{#LC1682 .anchor} \]

[]{#LC1683 .anchor} },

[]{#LC1684 .anchor} {

[]{#LC1685 .anchor} "Identifier": "ExcludedRootUnits",

[]{#LC1686 .anchor} "ApiField": "ExcludedRootUnits",

[]{#LC1687 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1688 .anchor} "Type": "KEYWORD",

[]{#LC1689 .anchor} "Origin": "INTERNAL",

[]{#LC1690 .anchor} "ShortName": "Noeuds inaccessibles",

[]{#LC1691 .anchor} "Collections": \[

[]{#LC1692 .anchor} "AccessContract"

[]{#LC1693 .anchor} \]

[]{#LC1694 .anchor} },

[]{#LC1695 .anchor} {

[]{#LC1696 .anchor} "Identifier": "LastUpdate",

[]{#LC1697 .anchor} "ApiField": "LastUpdate",

[]{#LC1698 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1699 .anchor} "Type": "DATE",

[]{#LC1700 .anchor} "Origin": "INTERNAL",

[]{#LC1701 .anchor} "ShortName": "Dernière modification",

[]{#LC1702 .anchor} "Collections": \[

[]{#LC1703 .anchor} "AccessContract",

[]{#LC1704 .anchor} "AccessionRegisterDetail",

[]{#LC1705 .anchor} "ArchiveUnitProfile",

[]{#LC1706 .anchor} "Context",

[]{#LC1707 .anchor} "IngestContract",

[]{#LC1708 .anchor} "Ontology",

[]{#LC1709 .anchor} "Profile",

[]{#LC1710 .anchor} "Griffin",

[]{#LC1711 .anchor} "PreservationScenario",

[]{#LC1712 .anchor} "ManagementContract"

[]{#LC1713 .anchor} \]

[]{#LC1714 .anchor} },

[]{#LC1715 .anchor} {

[]{#LC1716 .anchor} "Identifier": "Name",

[]{#LC1717 .anchor} "ApiField": "Name",

[]{#LC1718 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1719 .anchor} "Type": "TEXT",

[]{#LC1720 .anchor} "Origin": "INTERNAL",

[]{#LC1721 .anchor} "ShortName": "Intitulé",

[]{#LC1722 .anchor} "Collections": \[

[]{#LC1723 .anchor} "AccessContract",

[]{#LC1724 .anchor} "Agencies",

[]{#LC1725 .anchor} "ArchiveUnitProfile",

[]{#LC1726 .anchor} "Context",

[]{#LC1727 .anchor} "FileFormat",

[]{#LC1728 .anchor} "IngestContract",

[]{#LC1729 .anchor} "Profile",

[]{#LC1730 .anchor} "SecurityProfile",

[]{#LC1731 .anchor} "Griffin",

[]{#LC1732 .anchor} "PreservationScenario",

[]{#LC1733 .anchor} "ManagementContract"

[]{#LC1734 .anchor} \]

[]{#LC1735 .anchor} },

[]{#LC1736 .anchor} {

[]{#LC1737 .anchor} "Identifier": "OriginatingAgencies",

[]{#LC1738 .anchor} "ApiField": "OriginatingAgencies",

[]{#LC1739 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1740 .anchor} "Type": "KEYWORD",

[]{#LC1741 .anchor} "Origin": "INTERNAL",

[]{#LC1742 .anchor} "ShortName": "Liste blanche des services
producteurs",

[]{#LC1743 .anchor} "Collections": \[

[]{#LC1744 .anchor} "AccessContract"

[]{#LC1745 .anchor} \]

[]{#LC1746 .anchor} },

[]{#LC1747 .anchor} {

[]{#LC1748 .anchor} "Identifier": "RuleCategoryToFilter",

[]{#LC1749 .anchor} "ApiField": "RuleCategoryToFilter",

[]{#LC1750 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1751 .anchor} "Type": "KEYWORD",

[]{#LC1752 .anchor} "Origin": "INTERNAL",

[]{#LC1753 .anchor} "ShortName": "Liste des catégories de règles à
filtrer",

[]{#LC1754 .anchor} "Collections": \[

[]{#LC1755 .anchor} "AccessContract"

[]{#LC1756 .anchor} \]

[]{#LC1757 .anchor} },

[]{#LC1758 .anchor} {

[]{#LC1759 .anchor} "Identifier": "RootUnits",

[]{#LC1760 .anchor} "ApiField": "RootUnits",

[]{#LC1761 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1762 .anchor} "Type": "KEYWORD",

[]{#LC1763 .anchor} "Origin": "INTERNAL",

[]{#LC1764 .anchor} "ShortName": "Noeuds de consultation",

[]{#LC1765 .anchor} "Collections": \[

[]{#LC1766 .anchor} "AccessContract"

[]{#LC1767 .anchor} \]

[]{#LC1768 .anchor} },

[]{#LC1769 .anchor} {

[]{#LC1770 .anchor} "Identifier": "WritingPermission",

[]{#LC1771 .anchor} "ApiField": "WritingPermission",

[]{#LC1772 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1773 .anchor} "Type": "BOOLEAN",

[]{#LC1774 .anchor} "Origin": "INTERNAL",

[]{#LC1775 .anchor} "ShortName": "Droit d'écriture",

[]{#LC1776 .anchor} "Collections": \[

[]{#LC1777 .anchor} "AccessContract"

[]{#LC1778 .anchor} \]

[]{#LC1779 .anchor} },

[]{#LC1780 .anchor} {

[]{#LC1781 .anchor} "Identifier": "WritingRestrictedDesc",

[]{#LC1782 .anchor} "ApiField": "WritingRestrictedDesc",

[]{#LC1783 .anchor} "Description": "Mapping :
accesscontract-es-mapping.json",

[]{#LC1784 .anchor} "Type": "BOOLEAN",

[]{#LC1785 .anchor} "Origin": "INTERNAL",

[]{#LC1786 .anchor} "ShortName": "Restriction d'écriture aux métadonnées
de description",

[]{#LC1787 .anchor} "Collections": \[

[]{#LC1788 .anchor} "AccessContract"

[]{#LC1789 .anchor} \]

[]{#LC1790 .anchor} },

[]{#LC1791 .anchor} {

[]{#LC1792 .anchor} "Identifier": "AcquisitionInformation",

[]{#LC1793 .anchor} "SedaField": "AcquisitionInformation",

[]{#LC1794 .anchor} "ApiField": "AcquisitionInformation",

[]{#LC1795 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC1796 .anchor} "Type": "TEXT",

[]{#LC1797 .anchor} "Origin": "INTERNAL",

[]{#LC1798 .anchor} "ShortName": "Modalités d'entrée",

[]{#LC1799 .anchor} "Collections": \[

[]{#LC1800 .anchor} "AccessionRegisterDetail"

[]{#LC1801 .anchor} \]

[]{#LC1802 .anchor} },

[]{#LC1803 .anchor} {

[]{#LC1804 .anchor} "Identifier": "ArchivalAgreement",

[]{#LC1805 .anchor} "SedaField": "ArchivalAgreement",

[]{#LC1806 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC1807 .anchor} "Type": "KEYWORD",

[]{#LC1808 .anchor} "Origin": "INTERNAL",

[]{#LC1809 .anchor} "ShortName": "Contrat d'entrée",

[]{#LC1810 .anchor} "Collections": \[

[]{#LC1811 .anchor} "AccessionRegisterDetail",

[]{#LC1812 .anchor} "LogbookOperation"

[]{#LC1813 .anchor} \]

[]{#LC1814 .anchor} },

[]{#LC1815 .anchor} {

[]{#LC1816 .anchor} "Identifier": "deleted",

[]{#LC1817 .anchor} "ApiField": "deleted",

[]{#LC1818 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC1819 .anchor} "Type": "LONG",

[]{#LC1820 .anchor} "Origin": "INTERNAL",

[]{#LC1821 .anchor} "ShortName": "Supprimé",

[]{#LC1822 .anchor} "Collections": \[

[]{#LC1823 .anchor} "AccessionRegisterDetail",

[]{#LC1824 .anchor} "AccessionRegisterSummary"

[]{#LC1825 .anchor} \]

[]{#LC1826 .anchor} },

[]{#LC1827 .anchor} {

[]{#LC1828 .anchor} "Identifier": "ActionList",

[]{#LC1829 .anchor} "SedaField": "ActionList",

[]{#LC1830 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1831 .anchor} "Type": "KEYWORD",

[]{#LC1832 .anchor} "Origin": "INTERNAL",

[]{#LC1833 .anchor} "ShortName": "ActionList",

[]{#LC1834 .anchor} "Collections": \[

[]{#LC1835 .anchor} "PreservationScenario"

[]{#LC1836 .anchor} \]

[]{#LC1837 .anchor} },

[]{#LC1838 .anchor} {

[]{#LC1839 .anchor} "Identifier": "FormatList",

[]{#LC1840 .anchor} "SedaField": "FormatList",

[]{#LC1841 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1842 .anchor} "Type": "KEYWORD",

[]{#LC1843 .anchor} "Origin": "INTERNAL",

[]{#LC1844 .anchor} "ShortName": "FormatList",

[]{#LC1845 .anchor} "Collections": \[

[]{#LC1846 .anchor} "PreservationScenario"

[]{#LC1847 .anchor} \]

[]{#LC1848 .anchor} },

[]{#LC1849 .anchor} {

[]{#LC1850 .anchor} "Identifier": "GriffinIdentifier",

[]{#LC1851 .anchor} "SedaField": "GriffinIdentifier",

[]{#LC1852 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1853 .anchor} "Type": "KEYWORD",

[]{#LC1854 .anchor} "Origin": "INTERNAL",

[]{#LC1855 .anchor} "ShortName": "GriffinIdentifier",

[]{#LC1856 .anchor} "Collections": \[

[]{#LC1857 .anchor} "PreservationScenario"

[]{#LC1858 .anchor} \]

[]{#LC1859 .anchor} },

[]{#LC1860 .anchor} {

[]{#LC1861 .anchor} "Identifier": "Timeout",

[]{#LC1862 .anchor} "SedaField": "Timeout",

[]{#LC1863 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1864 .anchor} "Type": "LONG",

[]{#LC1865 .anchor} "Origin": "INTERNAL",

[]{#LC1866 .anchor} "ShortName": "Timeout",

[]{#LC1867 .anchor} "Collections": \[

[]{#LC1868 .anchor} "PreservationScenario"

[]{#LC1869 .anchor} \]

[]{#LC1870 .anchor} },

[]{#LC1871 .anchor} {

[]{#LC1872 .anchor} "Identifier": "MaxSize",

[]{#LC1873 .anchor} "SedaField": "MaxSize",

[]{#LC1874 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1875 .anchor} "Type": "LONG",

[]{#LC1876 .anchor} "Origin": "INTERNAL",

[]{#LC1877 .anchor} "ShortName": "MaxSize",

[]{#LC1878 .anchor} "Collections": \[

[]{#LC1879 .anchor} "PreservationScenario"

[]{#LC1880 .anchor} \]

[]{#LC1881 .anchor} },

[]{#LC1882 .anchor} {

[]{#LC1883 .anchor} "Identifier": "Debug",

[]{#LC1884 .anchor} "SedaField": "Debug",

[]{#LC1885 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1886 .anchor} "Type": "BOOLEAN",

[]{#LC1887 .anchor} "Origin": "INTERNAL",

[]{#LC1888 .anchor} "ShortName": "Debug",

[]{#LC1889 .anchor} "Collections": \[

[]{#LC1890 .anchor} "PreservationScenario"

[]{#LC1891 .anchor} \]

[]{#LC1892 .anchor} },

[]{#LC1893 .anchor} {

[]{#LC1894 .anchor} "Identifier": "Args",

[]{#LC1895 .anchor} "SedaField": "Args",

[]{#LC1896 .anchor} "Description": "Mapping :
preservationscenario-es-mapping.json",

[]{#LC1897 .anchor} "Type": "KEYWORD",

[]{#LC1898 .anchor} "Origin": "INTERNAL",

[]{#LC1899 .anchor} "ShortName": "Extension",

[]{#LC1900 .anchor} "Collections": \[

[]{#LC1901 .anchor} "PreservationScenario"

[]{#LC1902 .anchor} \]

[]{#LC1903 .anchor} },

[]{#LC1904 .anchor} {

[]{#LC1905 .anchor} "Identifier": "ingested",

[]{#LC1906 .anchor} "ApiField": "ingested",

[]{#LC1907 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC1908 .anchor} "Type": "LONG",

[]{#LC1909 .anchor} "Origin": "INTERNAL",

[]{#LC1910 .anchor} "ShortName": "Total",

[]{#LC1911 .anchor} "Collections": \[

[]{#LC1912 .anchor} "AccessionRegisterDetail",

[]{#LC1913 .anchor} "AccessionRegisterSummary"

[]{#LC1914 .anchor} \]

[]{#LC1915 .anchor} },

[]{#LC1916 .anchor} {

[]{#LC1917 .anchor} "Identifier": "remained",

[]{#LC1918 .anchor} "ApiField": "remained",

[]{#LC1919 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC1920 .anchor} "Type": "LONG",

[]{#LC1921 .anchor} "Origin": "INTERNAL",

[]{#LC1922 .anchor} "ShortName": "Restant",

[]{#LC1923 .anchor} "Collections": \[

[]{#LC1924 .anchor} "AccessionRegisterDetail",

[]{#LC1925 .anchor} "AccessionRegisterSummary"

[]{#LC1926 .anchor} \]

[]{#LC1927 .anchor} },

[]{#LC1928 .anchor} {

[]{#LC1929 .anchor} "Identifier": "Opi",

[]{#LC1930 .anchor} "ApiField": "Opi",

[]{#LC1931 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Identifiant de l’opération
d’entrée ayant versé les archives recensées dans ce détail du registre
des fonds",

[]{#LC1932 .anchor} "Type": "KEYWORD",

[]{#LC1933 .anchor} "Origin": "INTERNAL",

[]{#LC1934 .anchor} "ShortName": "Identifiant de l'opération",

[]{#LC1935 .anchor} "Collections": \[

[]{#LC1936 .anchor} "AccessionRegisterDetail"

[]{#LC1937 .anchor} \]

[]{#LC1938 .anchor} },

[]{#LC1939 .anchor} {

[]{#LC1940 .anchor} "Identifier": "Opc",

[]{#LC1941 .anchor} "ApiField": "Opc",

[]{#LC1942 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Identifiant de l’opération
courante (Ingest, Elimination,...) ayant modifié les archives recensées
dans ce détail du registre des fonds",

[]{#LC1943 .anchor} "Type": "KEYWORD",

[]{#LC1944 .anchor} "Origin": "INTERNAL",

[]{#LC1945 .anchor} "ShortName": "Identifiant de l'opération courante",

[]{#LC1946 .anchor} "Collections": \[

[]{#LC1947 .anchor} "AccessionRegisterDetail"

[]{#LC1948 .anchor} \]

[]{#LC1949 .anchor} },

[]{#LC1950 .anchor} {

[]{#LC1951 .anchor} "Identifier": "OpType",

[]{#LC1952 .anchor} "ApiField": "OpType",

[]{#LC1953 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Le type de l'opération (Ingest,
Elimination, ...)",

[]{#LC1954 .anchor} "Type": "KEYWORD",

[]{#LC1955 .anchor} "Origin": "INTERNAL",

[]{#LC1956 .anchor} "ShortName": "Type de l'opération",

[]{#LC1957 .anchor} "Collections": \[

[]{#LC1958 .anchor} "AccessionRegisterDetail"

[]{#LC1959 .anchor} \]

[]{#LC1960 .anchor} },

[]{#LC1961 .anchor} {

[]{#LC1962 .anchor} "Identifier": "Gots",

[]{#LC1963 .anchor} "ApiField": "Gots",

[]{#LC1964 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Total des groupes d'objets
modifiant le register des fonds suite à une opération (ingest,
élimination, ...)",

[]{#LC1965 .anchor} "Type": "LONG",

[]{#LC1966 .anchor} "Origin": "INTERNAL",

[]{#LC1967 .anchor} "ShortName": "Total des groupes d'objets",

[]{#LC1968 .anchor} "Collections": \[

[]{#LC1969 .anchor} "AccessionRegisterDetail"

[]{#LC1970 .anchor} \]

[]{#LC1971 .anchor} },

[]{#LC1972 .anchor} {

[]{#LC1973 .anchor} "Identifier": "Units",

[]{#LC1974 .anchor} "ApiField": "Units",

[]{#LC1975 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Total des unités archivistiques
modifiant le register des fonds suite à une opération (ingest,
élimination, ...)",

[]{#LC1976 .anchor} "Type": "LONG",

[]{#LC1977 .anchor} "Origin": "INTERNAL",

[]{#LC1978 .anchor} "ShortName": "Total des unités archivistiques",

[]{#LC1979 .anchor} "Collections": \[

[]{#LC1980 .anchor} "AccessionRegisterDetail"

[]{#LC1981 .anchor} \]

[]{#LC1982 .anchor} },

[]{#LC1983 .anchor} {

[]{#LC1984 .anchor} "Identifier": "Objects",

[]{#LC1985 .anchor} "ApiField": "Objects",

[]{#LC1986 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Total des objets modifiant le
register des fonds suite à une opération (ingest, élimination, ...)",

[]{#LC1987 .anchor} "Type": "LONG",

[]{#LC1988 .anchor} "Origin": "INTERNAL",

[]{#LC1989 .anchor} "ShortName": "Total des objets",

[]{#LC1990 .anchor} "Collections": \[

[]{#LC1991 .anchor} "AccessionRegisterDetail"

[]{#LC1992 .anchor} \]

[]{#LC1993 .anchor} },

[]{#LC1994 .anchor} {

[]{#LC1995 .anchor} "Identifier": "ObjSize",

[]{#LC1996 .anchor} "ApiField": "ObjSize",

[]{#LC1997 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json. Total de poids d'objets
modifiant le register des fonds suite à une opération (ingest,
élimination, ...)",

[]{#LC1998 .anchor} "Type": "LONG",

[]{#LC1999 .anchor} "Origin": "INTERNAL",

[]{#LC2000 .anchor} "ShortName": "Total des poids d'objets",

[]{#LC2001 .anchor} "Collections": \[

[]{#LC2002 .anchor} "AccessionRegisterDetail"

[]{#LC2003 .anchor} \]

[]{#LC2004 .anchor} },

[]{#LC2005 .anchor} {

[]{#LC2006 .anchor} "Identifier": "OperationIds",

[]{#LC2007 .anchor} "ApiField": "OperationIds",

[]{#LC2008 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC2009 .anchor} "Type": "KEYWORD",

[]{#LC2010 .anchor} "Origin": "INTERNAL",

[]{#LC2011 .anchor} "ShortName": "Identifiant de l'opération",

[]{#LC2012 .anchor} "Collections": \[

[]{#LC2013 .anchor} "AccessionRegisterDetail"

[]{#LC2014 .anchor} \]

[]{#LC2015 .anchor} },

[]{#LC2016 .anchor} {

[]{#LC2017 .anchor} "Identifier": "OriginatingAgency",

[]{#LC2018 .anchor} "SedaField": "OriginatingAgencyIdentifier",

[]{#LC2019 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC2020 .anchor} "Type": "KEYWORD",

[]{#LC2021 .anchor} "Origin": "INTERNAL",

[]{#LC2022 .anchor} "ShortName": "Service producteur",

[]{#LC2023 .anchor} "Collections": \[

[]{#LC2024 .anchor} "AccessionRegisterDetail",

[]{#LC2025 .anchor} "AccessionRegisterSummary",

[]{#LC2026 .anchor} "AccessionRegisterSymbolic"

[]{#LC2027 .anchor} \]

[]{#LC2028 .anchor} },

[]{#LC2029 .anchor} {

[]{#LC2030 .anchor} "Identifier": "SubmissionAgency",

[]{#LC2031 .anchor} "SedaField": "SubmissionAgencyIdentifier",

[]{#LC2032 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC2033 .anchor} "Type": "KEYWORD",

[]{#LC2034 .anchor} "Origin": "INTERNAL",

[]{#LC2035 .anchor} "ShortName": "Service versant",

[]{#LC2036 .anchor} "Collections": \[

[]{#LC2037 .anchor} "AccessionRegisterDetail"

[]{#LC2038 .anchor} \]

[]{#LC2039 .anchor} },

[]{#LC2040 .anchor} {

[]{#LC2041 .anchor} "Identifier": "LegalStatus",

[]{#LC2042 .anchor} "SedaField": "LegalStatus",

[]{#LC2043 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json",

[]{#LC2044 .anchor} "Type": "KEYWORD",

[]{#LC2045 .anchor} "Origin": "INTERNAL",

[]{#LC2046 .anchor} "ShortName": "Statut légal",

[]{#LC2047 .anchor} "Collections": \[

[]{#LC2048 .anchor} "AccessionRegisterDetail",

[]{#LC2049 .anchor} "LogbookOperation"

[]{#LC2050 .anchor} \]

[]{#LC2051 .anchor} },

[]{#LC2052 .anchor} {

[]{#LC2053 .anchor} "Identifier": "ControlSchema",

[]{#LC2054 .anchor} "ApiField": "ControlSchema",

[]{#LC2055 .anchor} "Description": "Mapping :
archiveunitprofile-es-mapping.json",

[]{#LC2056 .anchor} "Type": "KEYWORD",

[]{#LC2057 .anchor} "Origin": "INTERNAL",

[]{#LC2058 .anchor} "ShortName": "Schéma de contrôle",

[]{#LC2059 .anchor} "Collections": \[

[]{#LC2060 .anchor} "ArchiveUnitProfile"

[]{#LC2061 .anchor} \]

[]{#LC2062 .anchor} },

[]{#LC2063 .anchor} {

[]{#LC2064 .anchor} "Identifier": "Fields",

[]{#LC2065 .anchor} "ApiField": "Fields",

[]{#LC2066 .anchor} "Description": "Mapping :
archiveunitprofile-es-mapping.json",

[]{#LC2067 .anchor} "Type": "KEYWORD",

[]{#LC2068 .anchor} "Origin": "INTERNAL",

[]{#LC2069 .anchor} "ShortName": "Fields",

[]{#LC2070 .anchor} "Collections": \[

[]{#LC2071 .anchor} "ArchiveUnitProfile"

[]{#LC2072 .anchor} \]

[]{#LC2073 .anchor} },

[]{#LC2074 .anchor} {

[]{#LC2075 .anchor} "Identifier": "EnableControl",

[]{#LC2076 .anchor} "ApiField": "EnableControl",

[]{#LC2077 .anchor} "Description": "Mapping : context-es-mapping.json",

[]{#LC2078 .anchor} "Type": "BOOLEAN",

[]{#LC2079 .anchor} "Origin": "INTERNAL",

[]{#LC2080 .anchor} "ShortName": "Activation des contrôles",

[]{#LC2081 .anchor} "Collections": \[

[]{#LC2082 .anchor} "Context"

[]{#LC2083 .anchor} \]

[]{#LC2084 .anchor} },

[]{#LC2085 .anchor} {

[]{#LC2086 .anchor} "Identifier": "AccessContracts",

[]{#LC2087 .anchor} "ApiField": "AccessContracts",

[]{#LC2088 .anchor} "Description": "Mapping : context-es-mapping.json",

[]{#LC2089 .anchor} "Type": "KEYWORD",

[]{#LC2090 .anchor} "Origin": "INTERNAL",

[]{#LC2091 .anchor} "ShortName": "Liste contrats d'accès",

[]{#LC2092 .anchor} "Collections": \[

[]{#LC2093 .anchor} "Context"

[]{#LC2094 .anchor} \]

[]{#LC2095 .anchor} },

[]{#LC2096 .anchor} {

[]{#LC2097 .anchor} "Identifier": "IngestContracts",

[]{#LC2098 .anchor} "ApiField": "IngestContracts",

[]{#LC2099 .anchor} "Description": "Mapping : context-es-mapping.json",

[]{#LC2100 .anchor} "Type": "KEYWORD",

[]{#LC2101 .anchor} "Origin": "INTERNAL",

[]{#LC2102 .anchor} "ShortName": "Liste contrats d'entrée",

[]{#LC2103 .anchor} "Collections": \[

[]{#LC2104 .anchor} "Context"

[]{#LC2105 .anchor} \]

[]{#LC2106 .anchor} },

[]{#LC2107 .anchor} {

[]{#LC2108 .anchor} "Identifier": "tenant",

[]{#LC2109 .anchor} "ApiField": "tenant",

[]{#LC2110 .anchor} "Description": "Mapping : context-es-mapping.json",

[]{#LC2111 .anchor} "Type": "LONG",

[]{#LC2112 .anchor} "Origin": "INTERNAL",

[]{#LC2113 .anchor} "ShortName": "Tenant",

[]{#LC2114 .anchor} "Collections": \[

[]{#LC2115 .anchor} "Context"

[]{#LC2116 .anchor} \]

[]{#LC2117 .anchor} },

[]{#LC2118 .anchor} {

[]{#LC2119 .anchor} "Identifier": "SecurityProfile",

[]{#LC2120 .anchor} "ApiField": "SecurityProfile",

[]{#LC2121 .anchor} "Description": "Mapping : context-es-mapping.json",

[]{#LC2122 .anchor} "Type": "KEYWORD",

[]{#LC2123 .anchor} "Origin": "INTERNAL",

[]{#LC2124 .anchor} "ShortName": "Profil de sécurité",

[]{#LC2125 .anchor} "Collections": \[

[]{#LC2126 .anchor} "Context"

[]{#LC2127 .anchor} \]

[]{#LC2128 .anchor} },

[]{#LC2129 .anchor} {

[]{#LC2130 .anchor} "Identifier": "Alert",

[]{#LC2131 .anchor} "ApiField": "Alert",

[]{#LC2132 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2133 .anchor} "Type": "BOOLEAN",

[]{#LC2134 .anchor} "Origin": "INTERNAL",

[]{#LC2135 .anchor} "ShortName": "Alerte",

[]{#LC2136 .anchor} "Collections": \[

[]{#LC2137 .anchor} "FileFormat"

[]{#LC2138 .anchor} \]

[]{#LC2139 .anchor} },

[]{#LC2140 .anchor} {

[]{#LC2141 .anchor} "Identifier": "Comment",

[]{#LC2142 .anchor} "SedaField": "Comment",

[]{#LC2143 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2144 .anchor} "Type": "TEXT",

[]{#LC2145 .anchor} "Origin": "INTERNAL",

[]{#LC2146 .anchor} "ShortName": "Commentaire",

[]{#LC2147 .anchor} "Collections": \[

[]{#LC2148 .anchor} "FileFormat"

[]{#LC2149 .anchor} \]

[]{#LC2150 .anchor} },

[]{#LC2151 .anchor} {

[]{#LC2152 .anchor} "Identifier": "Extension",

[]{#LC2153 .anchor} "ApiField": "Extension",

[]{#LC2154 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2155 .anchor} "Type": "KEYWORD",

[]{#LC2156 .anchor} "Origin": "INTERNAL",

[]{#LC2157 .anchor} "ShortName": "Extension(s)",

[]{#LC2158 .anchor} "Collections": \[

[]{#LC2159 .anchor} "FileFormat",

[]{#LC2160 .anchor} "PreservationScenario"

[]{#LC2161 .anchor} \]

[]{#LC2162 .anchor} },

[]{#LC2163 .anchor} {

[]{#LC2164 .anchor} "Identifier": "Group",

[]{#LC2165 .anchor} "ApiField": "Group",

[]{#LC2166 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2167 .anchor} "Type": "TEXT",

[]{#LC2168 .anchor} "Origin": "INTERNAL",

[]{#LC2169 .anchor} "ShortName": "Groupe",

[]{#LC2170 .anchor} "Collections": \[

[]{#LC2171 .anchor} "FileFormat"

[]{#LC2172 .anchor} \]

[]{#LC2173 .anchor} },

[]{#LC2174 .anchor} {

[]{#LC2175 .anchor} "Identifier": "HasPriorityOverFileFormatID",

[]{#LC2176 .anchor} "ApiField": "HasPriorityOverFileFormatID",

[]{#LC2177 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2178 .anchor} "Type": "KEYWORD",

[]{#LC2179 .anchor} "Origin": "INTERNAL",

[]{#LC2180 .anchor} "ShortName": "Priorité sur les versions
précédentes",

[]{#LC2181 .anchor} "Collections": \[

[]{#LC2182 .anchor} "FileFormat"

[]{#LC2183 .anchor} \]

[]{#LC2184 .anchor} },

[]{#LC2185 .anchor} {

[]{#LC2186 .anchor} "Identifier": "PUID",

[]{#LC2187 .anchor} "ApiField": "PUID",

[]{#LC2188 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2189 .anchor} "Type": "KEYWORD",

[]{#LC2190 .anchor} "Origin": "INTERNAL",

[]{#LC2191 .anchor} "ShortName": "PUID",

[]{#LC2192 .anchor} "Collections": \[

[]{#LC2193 .anchor} "FileFormat"

[]{#LC2194 .anchor} \]

[]{#LC2195 .anchor} },

[]{#LC2196 .anchor} {

[]{#LC2197 .anchor} "Identifier": "VersionPronom",

[]{#LC2198 .anchor} "ApiField": "VersionPronom",

[]{#LC2199 .anchor} "Description": "Mapping : format-es-mapping.json",

[]{#LC2200 .anchor} "Type": "KEYWORD",

[]{#LC2201 .anchor} "Origin": "INTERNAL",

[]{#LC2202 .anchor} "ShortName": "Version de Pronom",

[]{#LC2203 .anchor} "Collections": \[

[]{#LC2204 .anchor} "FileFormat"

[]{#LC2205 .anchor} \]

[]{#LC2206 .anchor} },

[]{#LC2207 .anchor} {

[]{#LC2208 .anchor} "Identifier": "ArchiveProfiles",

[]{#LC2209 .anchor} "ApiField": "ArchiveProfiles",

[]{#LC2210 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2211 .anchor} "Type": "KEYWORD",

[]{#LC2212 .anchor} "Origin": "INTERNAL",

[]{#LC2213 .anchor} "ShortName": "Profils d'archivage",

[]{#LC2214 .anchor} "Collections": \[

[]{#LC2215 .anchor} "IngestContract"

[]{#LC2216 .anchor} \]

[]{#LC2217 .anchor} },

[]{#LC2218 .anchor} {

[]{#LC2219 .anchor} "Identifier": "CheckParentLink",

[]{#LC2220 .anchor} "ApiField": "CheckParentLink",

[]{#LC2221 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2222 .anchor} "Type": "KEYWORD",

[]{#LC2223 .anchor} "Origin": "INTERNAL",

[]{#LC2224 .anchor} "ShortName": "Contrôle sur noeud de rattachement",

[]{#LC2225 .anchor} "Collections": \[

[]{#LC2226 .anchor} "IngestContract"

[]{#LC2227 .anchor} \]

[]{#LC2228 .anchor} },

[]{#LC2229 .anchor} {

[]{#LC2230 .anchor} "Identifier": "EveryFormatType",

[]{#LC2231 .anchor} "ApiField": "EveryFormatType",

[]{#LC2232 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2233 .anchor} "Type": "BOOLEAN",

[]{#LC2234 .anchor} "Origin": "INTERNAL",

[]{#LC2235 .anchor} "ShortName": "Tous les formats",

[]{#LC2236 .anchor} "Collections": \[

[]{#LC2237 .anchor} "IngestContract"

[]{#LC2238 .anchor} \]

[]{#LC2239 .anchor} },

[]{#LC2240 .anchor} {

[]{#LC2241 .anchor} "Identifier": "FormatType",

[]{#LC2242 .anchor} "ApiField": "FormatType",

[]{#LC2243 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2244 .anchor} "Type": "KEYWORD",

[]{#LC2245 .anchor} "Origin": "INTERNAL",

[]{#LC2246 .anchor} "ShortName": "Liste blanche des formats",

[]{#LC2247 .anchor} "Collections": \[

[]{#LC2248 .anchor} "IngestContract"

[]{#LC2249 .anchor} \]

[]{#LC2250 .anchor} },

[]{#LC2251 .anchor} {

[]{#LC2252 .anchor} "Identifier": "FormatUnidentifiedAuthorized",

[]{#LC2253 .anchor} "ApiField": "FormatUnidentifiedAuthorized",

[]{#LC2254 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2255 .anchor} "Type": "BOOLEAN",

[]{#LC2256 .anchor} "Origin": "INTERNAL",

[]{#LC2257 .anchor} "ShortName": "Formats non identifiés autorisés",

[]{#LC2258 .anchor} "Collections": \[

[]{#LC2259 .anchor} "IngestContract"

[]{#LC2260 .anchor} \]

[]{#LC2261 .anchor} },

[]{#LC2262 .anchor} {

[]{#LC2263 .anchor} "Identifier": "ComputeInheritedRulesAtIngest",

[]{#LC2264 .anchor} "ApiField": "ComputeInheritedRulesAtIngest",

[]{#LC2265 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2266 .anchor} "Type": "BOOLEAN",

[]{#LC2267 .anchor} "Origin": "INTERNAL",

[]{#LC2268 .anchor} "ShortName": "Execute ComputedInheritedRules at
ingest",

[]{#LC2269 .anchor} "Collections": \[

[]{#LC2270 .anchor} "IngestContract"

[]{#LC2271 .anchor} \]

[]{#LC2272 .anchor} },

[]{#LC2273 .anchor} {

[]{#LC2274 .anchor} "Identifier": "LinkParentId",

[]{#LC2275 .anchor} "ApiField": "LinkParentId",

[]{#LC2276 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2277 .anchor} "Type": "KEYWORD",

[]{#LC2278 .anchor} "Origin": "INTERNAL",

[]{#LC2279 .anchor} "ShortName": "Noeud de rattachement",

[]{#LC2280 .anchor} "Collections": \[

[]{#LC2281 .anchor} "IngestContract"

[]{#LC2282 .anchor} \]

[]{#LC2283 .anchor} },

[]{#LC2284 .anchor} {

[]{#LC2285 .anchor} "Identifier": "MasterMandatory",

[]{#LC2286 .anchor} "ApiField": "MasterMandatory",

[]{#LC2287 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json",

[]{#LC2288 .anchor} "Type": "BOOLEAN",

[]{#LC2289 .anchor} "Origin": "INTERNAL",

[]{#LC2290 .anchor} "ShortName": "Présence obligatoire d'un Master",

[]{#LC2291 .anchor} "Collections": \[

[]{#LC2292 .anchor} "IngestContract"

[]{#LC2293 .anchor} \]

[]{#LC2294 .anchor} },

[]{#LC2295 .anchor} {

[]{#LC2296 .anchor} "Identifier": "ManagementContractId",

[]{#LC2297 .anchor} "ApiField": "ManagementContractId",

[]{#LC2298 .anchor} "Description": "Mapping :
ingestcontract-es-mapping.json.",

[]{#LC2299 .anchor} "Type": "KEYWORD",

[]{#LC2300 .anchor} "Origin": "INTERNAL",

[]{#LC2301 .anchor} "ShortName": "Identifiant du contrat de gestion",

[]{#LC2302 .anchor} "Collections": \[

[]{#LC2303 .anchor} "IngestContract"

[]{#LC2304 .anchor} \]

[]{#LC2305 .anchor} },

[]{#LC2306 .anchor} {

[]{#LC2307 .anchor} "Identifier": "\_lastPersistedDate",

[]{#LC2308 .anchor} "ApiField": "\#lastPersistedDate",

[]{#LC2309 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Date technique de sauvegarde en base.",

[]{#LC2310 .anchor} "Type": "DATE",

[]{#LC2311 .anchor} "Origin": "INTERNAL",

[]{#LC2312 .anchor} "ShortName": "Date de sauvegarde",

[]{#LC2313 .anchor} "Collections": \[

[]{#LC2314 .anchor} "LogbookOperation"

[]{#LC2315 .anchor} \]

[]{#LC2316 .anchor} },

[]{#LC2317 .anchor} {

[]{#LC2318 .anchor} "Identifier": "agId",

[]{#LC2319 .anchor} "ApiField": "agId",

[]{#LC2320 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Identifiant de l’agent interne réalisant l’évènement.",

[]{#LC2321 .anchor} "Type": "TEXT",

[]{#LC2322 .anchor} "Origin": "INTERNAL",

[]{#LC2323 .anchor} "ShortName": "Identifiant de l'agent interne",

[]{#LC2324 .anchor} "Collections": \[

[]{#LC2325 .anchor} "LogbookOperation"

[]{#LC2326 .anchor} \]

[]{#LC2327 .anchor} },

[]{#LC2328 .anchor} {

[]{#LC2329 .anchor} "Identifier": "evDateTime",

[]{#LC2330 .anchor} "SedaField": "EventDateTime",

[]{#LC2331 .anchor} "ApiField": "evDateTime",

[]{#LC2332 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Date de lancement de l’opération",

[]{#LC2333 .anchor} "Type": "DATE",

[]{#LC2334 .anchor} "Origin": "INTERNAL",

[]{#LC2335 .anchor} "ShortName": "Date",

[]{#LC2336 .anchor} "Collections": \[

[]{#LC2337 .anchor} "LogbookOperation",

[]{#LC2338 .anchor} "Unit"

[]{#LC2339 .anchor} \]

[]{#LC2340 .anchor} },

[]{#LC2341 .anchor} {

[]{#LC2342 .anchor} "Identifier": "evId",

[]{#LC2343 .anchor} "SedaField": "EventIdentifier",

[]{#LC2344 .anchor} "ApiField": "evId",

[]{#LC2345 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2346 .anchor} "Type": "KEYWORD",

[]{#LC2347 .anchor} "Origin": "INTERNAL",

[]{#LC2348 .anchor} "ShortName": "Identifiant de l'événement",

[]{#LC2349 .anchor} "Collections": \[

[]{#LC2350 .anchor} "LogbookOperation",

[]{#LC2351 .anchor} "Unit"

[]{#LC2352 .anchor} \]

[]{#LC2353 .anchor} },

[]{#LC2354 .anchor} {

[]{#LC2355 .anchor} "Identifier": "evDetData",

[]{#LC2356 .anchor} "SedaField": "eventDetailData",

[]{#LC2357 .anchor} "ApiField": "evDetData",

[]{#LC2358 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC2359 .anchor} "Type": "KEYWORD",

[]{#LC2360 .anchor} "Origin": "INTERNAL",

[]{#LC2361 .anchor} "ShortName": "Détails techniques",

[]{#LC2362 .anchor} "Collections": \[

[]{#LC2363 .anchor} "Unit"

[]{#LC2364 .anchor} \]

[]{#LC2365 .anchor} },

[]{#LC2366 .anchor} {

[]{#LC2367 .anchor} "Identifier": "evIdProc",

[]{#LC2368 .anchor} "ApiField": "evIdProc",

[]{#LC2369 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2370 .anchor} "Type": "KEYWORD",

[]{#LC2371 .anchor} "Origin": "INTERNAL",

[]{#LC2372 .anchor} "ShortName": "Identifiant du processus",

[]{#LC2373 .anchor} "Collections": \[

[]{#LC2374 .anchor} "LogbookOperation"

[]{#LC2375 .anchor} \]

[]{#LC2376 .anchor} },

[]{#LC2377 .anchor} {

[]{#LC2378 .anchor} "Identifier": "SecurisationVersion",

[]{#LC2379 .anchor} "ApiField": "SecurisationVersion",

[]{#LC2380 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2381 .anchor} "Type": "TEXT",

[]{#LC2382 .anchor} "Origin": "INTERNAL",

[]{#LC2383 .anchor} "ShortName": "SecurisationVersion",

[]{#LC2384 .anchor} "Collections": \[

[]{#LC2385 .anchor} "LogbookOperation"

[]{#LC2386 .anchor} \]

[]{#LC2387 .anchor} },

[]{#LC2388 .anchor} {

[]{#LC2389 .anchor} "Identifier": "MaxEntriesReached",

[]{#LC2390 .anchor} "ApiField": "MaxEntriesReached",

[]{#LC2391 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2392 .anchor} "Type": "BOOLEAN",

[]{#LC2393 .anchor} "Origin": "INTERNAL",

[]{#LC2394 .anchor} "ShortName": "MaxEntriesReached",

[]{#LC2395 .anchor} "Collections": \[

[]{#LC2396 .anchor} "LogbookOperation"

[]{#LC2397 .anchor} \]

[]{#LC2398 .anchor} },

[]{#LC2399 .anchor} {

[]{#LC2400 .anchor} "Identifier": "ServiceLevel",

[]{#LC2401 .anchor} "SedaField": "ServiceLevel",

[]{#LC2402 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2403 .anchor} "Type": "KEYWORD",

[]{#LC2404 .anchor} "Origin": "INTERNAL",

[]{#LC2405 .anchor} "ShortName": "Niveau de service",

[]{#LC2406 .anchor} "Collections": \[

[]{#LC2407 .anchor} "LogbookOperation"

[]{#LC2408 .anchor} \]

[]{#LC2409 .anchor} },

[]{#LC2410 .anchor} {

[]{#LC2411 .anchor} "Identifier": "evIdReq",

[]{#LC2412 .anchor} "ApiField": "evIdReq",

[]{#LC2413 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Identifiant de la requête déclenchant l’opération",

[]{#LC2414 .anchor} "Type": "KEYWORD",

[]{#LC2415 .anchor} "Origin": "INTERNAL",

[]{#LC2416 .anchor} "ShortName": "Identifiant de la requête",

[]{#LC2417 .anchor} "Collections": \[

[]{#LC2418 .anchor} "LogbookOperation"

[]{#LC2419 .anchor} \]

[]{#LC2420 .anchor} },

[]{#LC2421 .anchor} {

[]{#LC2422 .anchor} "Identifier": "evParentId",

[]{#LC2423 .anchor} "ApiField": "evParentId",

[]{#LC2424 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2425 .anchor} "Type": "KEYWORD",

[]{#LC2426 .anchor} "Origin": "INTERNAL",

[]{#LC2427 .anchor} "ShortName": "Identifiant de l'événement parent",

[]{#LC2428 .anchor} "Collections": \[

[]{#LC2429 .anchor} "LogbookOperation"

[]{#LC2430 .anchor} \]

[]{#LC2431 .anchor} },

[]{#LC2432 .anchor} {

[]{#LC2433 .anchor} "Identifier": "evType",

[]{#LC2434 .anchor} "SedaField": "EventType",

[]{#LC2435 .anchor} "ApiField": "evType",

[]{#LC2436 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Code du type de l’opération",

[]{#LC2437 .anchor} "Type": "KEYWORD",

[]{#LC2438 .anchor} "Origin": "INTERNAL",

[]{#LC2439 .anchor} "ShortName": "Type d'opération",

[]{#LC2440 .anchor} "Collections": \[

[]{#LC2441 .anchor} "LogbookOperation",

[]{#LC2442 .anchor} "Unit"

[]{#LC2443 .anchor} \]

[]{#LC2444 .anchor} },

[]{#LC2445 .anchor} {

[]{#LC2446 .anchor} "Identifier": "evTypeProc",

[]{#LC2447 .anchor} "SedaField": "EventTypeCode",

[]{#LC2448 .anchor} "ApiField": "evTypeProc",

[]{#LC2449 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Type de processus. Equivaut à la traduction du code du type de
l'opération.",

[]{#LC2450 .anchor} "Type": "KEYWORD",

[]{#LC2451 .anchor} "Origin": "INTERNAL",

[]{#LC2452 .anchor} "ShortName": "Catégorie d'opération",

[]{#LC2453 .anchor} "Collections": \[

[]{#LC2454 .anchor} "LogbookOperation",

[]{#LC2455 .anchor} "Unit"

[]{#LC2456 .anchor} \]

[]{#LC2457 .anchor} },

[]{#LC2458 .anchor} {

[]{#LC2459 .anchor} "Identifier": "ArchivalAgency",

[]{#LC2460 .anchor} "SedaField": "ArchivalAgency",

[]{#LC2461 .anchor} "ApiField": "ArchivalAgency",

[]{#LC2462 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2463 .anchor} "Type": "KEYWORD",

[]{#LC2464 .anchor} "Origin": "INTERNAL",

[]{#LC2465 .anchor} "ShortName": "Service d'archives",

[]{#LC2466 .anchor} "Collections": \[

[]{#LC2467 .anchor} "LogbookOperation"

[]{#LC2468 .anchor} \]

[]{#LC2469 .anchor} },

[]{#LC2470 .anchor} {

[]{#LC2471 .anchor} "Identifier": "TransferringAgency",

[]{#LC2472 .anchor} "SedaField": "TransferringAgency",

[]{#LC2473 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Service en charge du transfert.",

[]{#LC2474 .anchor} "Type": "KEYWORD",

[]{#LC2475 .anchor} "Origin": "INTERNAL",

[]{#LC2476 .anchor} "ShortName": "Service versant",

[]{#LC2477 .anchor} "Collections": \[

[]{#LC2478 .anchor} "LogbookOperation"

[]{#LC2479 .anchor} \]

[]{#LC2480 .anchor} },

[]{#LC2481 .anchor} {

[]{#LC2482 .anchor} "Identifier": "AgIfTrans",

[]{#LC2483 .anchor} "ApiField": "AgIfTrans",

[]{#LC2484 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2485 .anchor} "Type": "KEYWORD",

[]{#LC2486 .anchor} "Origin": "INTERNAL",

[]{#LC2487 .anchor} "ShortName": "AgIfTrans",

[]{#LC2488 .anchor} "Collections": \[

[]{#LC2489 .anchor} "LogbookOperation"

[]{#LC2490 .anchor} \]

[]{#LC2491 .anchor} },

[]{#LC2492 .anchor} {

[]{#LC2493 .anchor} "Identifier": "EvDateTimeReq",

[]{#LC2494 .anchor} "ApiField": "EvDateTimeReq",

[]{#LC2495 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Date de la demande de transfert inscrit dans le champ evDetData",

[]{#LC2496 .anchor} "Type": "DATE",

[]{#LC2497 .anchor} "Origin": "INTERNAL",

[]{#LC2498 .anchor} "ShortName": "Date de la demande de transfert",

[]{#LC2499 .anchor} "Collections": \[

[]{#LC2500 .anchor} "LogbookOperation"

[]{#LC2501 .anchor} \]

[]{#LC2502 .anchor} },

[]{#LC2503 .anchor} {

[]{#LC2504 .anchor} "Identifier": "EvDetailReq",

[]{#LC2505 .anchor} "ApiField": "EvDetailReq",

[]{#LC2506 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Précisions sur la demande de transfert. Chaîne de caractères. Reprend le
champ « Comment » du message ArchiveTransfer.",

[]{#LC2507 .anchor} "Type": "TEXT",

[]{#LC2508 .anchor} "Origin": "INTERNAL",

[]{#LC2509 .anchor} "ShortName": "Précisions",

[]{#LC2510 .anchor} "Collections": \[

[]{#LC2511 .anchor} "LogbookOperation"

[]{#LC2512 .anchor} \]

[]{#LC2513 .anchor} },

[]{#LC2514 .anchor} {

[]{#LC2515 .anchor} "Identifier": "Hash",

[]{#LC2516 .anchor} "ApiField": "Hash",

[]{#LC2517 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Empreinte de la racine de l’arbre de Merkle.",

[]{#LC2518 .anchor} "Type": "KEYWORD",

[]{#LC2519 .anchor} "Origin": "INTERNAL",

[]{#LC2520 .anchor} "ShortName": "Empreinte",

[]{#LC2521 .anchor} "Collections": \[

[]{#LC2522 .anchor} "LogbookOperation"

[]{#LC2523 .anchor} \]

[]{#LC2524 .anchor} },

[]{#LC2525 .anchor} {

[]{#LC2526 .anchor} "Identifier": "LogType",

[]{#LC2527 .anchor} "ApiField": "LogType",

[]{#LC2528 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Type de logbook sécurisé : OPERATION ou LIFECYCLE.",

[]{#LC2529 .anchor} "Type": "KEYWORD",

[]{#LC2530 .anchor} "Origin": "INTERNAL",

[]{#LC2531 .anchor} "ShortName": "Type de journal",

[]{#LC2532 .anchor} "Collections": \[

[]{#LC2533 .anchor} "LogbookOperation"

[]{#LC2534 .anchor} \]

[]{#LC2535 .anchor} },

[]{#LC2536 .anchor} {

[]{#LC2537 .anchor} "Identifier":
"MinusOneMonthLogbookTraceabilityDate",

[]{#LC2538 .anchor} "ApiField": "MinusOneMonthLogbookTraceabilityDate",

[]{#LC2539 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2540 .anchor} "Type": "DATE",

[]{#LC2541 .anchor} "Origin": "INTERNAL",

[]{#LC2542 .anchor} "ShortName": "Date de l’opération de sécurisation
passée d’un mois",

[]{#LC2543 .anchor} "Collections": \[

[]{#LC2544 .anchor} "LogbookOperation"

[]{#LC2545 .anchor} \]

[]{#LC2546 .anchor} },

[]{#LC2547 .anchor} {

[]{#LC2548 .anchor} "Identifier": "MinusOneYearLogbookTraceabilityDate",

[]{#LC2549 .anchor} "ApiField": "MinusOneYearLogbookTraceabilityDate",

[]{#LC2550 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2551 .anchor} "Type": "DATE",

[]{#LC2552 .anchor} "Origin": "INTERNAL",

[]{#LC2553 .anchor} "ShortName": "date de l’opération de sécurisation
passée d’un an",

[]{#LC2554 .anchor} "Collections": \[

[]{#LC2555 .anchor} "LogbookOperation"

[]{#LC2556 .anchor} \]

[]{#LC2557 .anchor} },

[]{#LC2558 .anchor} {

[]{#LC2559 .anchor} "Identifier": "NumberOfElements",

[]{#LC2560 .anchor} "ApiField": "NumberOfElements",

[]{#LC2561 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2562 .anchor} "Type": "LONG",

[]{#LC2563 .anchor} "Origin": "INTERNAL",

[]{#LC2564 .anchor} "ShortName": "Nombre d'éléments",

[]{#LC2565 .anchor} "Collections": \[

[]{#LC2566 .anchor} "LogbookOperation"

[]{#LC2567 .anchor} \]

[]{#LC2568 .anchor} },

[]{#LC2569 .anchor} {

[]{#LC2570 .anchor} "Identifier": "PreviousLogbookTraceabilityDate",

[]{#LC2571 .anchor} "ApiField": "PreviousLogbookTraceabilityDate",

[]{#LC2572 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2573 .anchor} "Type": "DATE",

[]{#LC2574 .anchor} "Origin": "INTERNAL",

[]{#LC2575 .anchor} "ShortName": "Date de la précédente opération de
sécurisation",

[]{#LC2576 .anchor} "Collections": \[

[]{#LC2577 .anchor} "LogbookOperation"

[]{#LC2578 .anchor} \]

[]{#LC2579 .anchor} },

[]{#LC2580 .anchor} {

[]{#LC2581 .anchor} "Identifier": "TimeStampToken",

[]{#LC2582 .anchor} "ApiField": "TimeStampToken",

[]{#LC2583 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2584 .anchor} "Type": "KEYWORD",

[]{#LC2585 .anchor} "Origin": "INTERNAL",

[]{#LC2586 .anchor} "ShortName": "Tampon d'horodatage",

[]{#LC2587 .anchor} "Collections": \[

[]{#LC2588 .anchor} "LogbookOperation"

[]{#LC2589 .anchor} \]

[]{#LC2590 .anchor} },

[]{#LC2591 .anchor} {

[]{#LC2592 .anchor} "Identifier": "diff",

[]{#LC2593 .anchor} "ApiField": "diff",

[]{#LC2594 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2595 .anchor} "Type": "KEYWORD",

[]{#LC2596 .anchor} "Origin": "INTERNAL",

[]{#LC2597 .anchor} "ShortName": "Différentiel",

[]{#LC2598 .anchor} "Collections": \[

[]{#LC2599 .anchor} "LogbookOperation"

[]{#LC2600 .anchor} \]

[]{#LC2601 .anchor} },

[]{#LC2602 .anchor} {

[]{#LC2603 .anchor} "Identifier": "errors",

[]{#LC2604 .anchor} "ApiField": "errors",

[]{#LC2605 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2606 .anchor} "Type": "KEYWORD",

[]{#LC2607 .anchor} "Origin": "INTERNAL",

[]{#LC2608 .anchor} "ShortName": "Erreurs",

[]{#LC2609 .anchor} "Collections": \[

[]{#LC2610 .anchor} "LogbookOperation"

[]{#LC2611 .anchor} \]

[]{#LC2612 .anchor} },

[]{#LC2613 .anchor} {

[]{#LC2614 .anchor} "Identifier": "reports",

[]{#LC2615 .anchor} "ApiField": "reports",

[]{#LC2616 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2617 .anchor} "Type": "KEYWORD",

[]{#LC2618 .anchor} "Origin": "INTERNAL",

[]{#LC2619 .anchor} "ShortName": "reports",

[]{#LC2620 .anchor} "Collections": \[

[]{#LC2621 .anchor} "LogbookOperation"

[]{#LC2622 .anchor} \]

[]{#LC2623 .anchor} },

[]{#LC2624 .anchor} {

[]{#LC2625 .anchor} "Identifier": "loadingURI",

[]{#LC2626 .anchor} "ApiField": "loadingURI",

[]{#LC2627 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2628 .anchor} "Type": "TEXT",

[]{#LC2629 .anchor} "Origin": "INTERNAL",

[]{#LC2630 .anchor} "ShortName": "loadingURI",

[]{#LC2631 .anchor} "Collections": \[

[]{#LC2632 .anchor} "LogbookOperation"

[]{#LC2633 .anchor} \]

[]{#LC2634 .anchor} },

[]{#LC2635 .anchor} {

[]{#LC2636 .anchor} "Identifier": "pointer",

[]{#LC2637 .anchor} "SedaField": "pointer",

[]{#LC2638 .anchor} "ApiField": "pointer",

[]{#LC2639 .anchor} "Description": "Mapping : logbook-es-mapping.json",

[]{#LC2640 .anchor} "Type": "TEXT",

[]{#LC2641 .anchor} "Origin": "INTERNAL",

[]{#LC2642 .anchor} "ShortName": "pointer",

[]{#LC2643 .anchor} "Collections": \[

[]{#LC2644 .anchor} "LogbookOperation"

[]{#LC2645 .anchor} \]

[]{#LC2646 .anchor} },

[]{#LC2647 .anchor} {

[]{#LC2648 .anchor} "Identifier": "obId",

[]{#LC2649 .anchor} "ApiField": "obId",

[]{#LC2650 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Identifiant Vitam du lot d’objets auquel s’applique l’opération (lot
correspondant à une liste).",

[]{#LC2651 .anchor} "Type": "KEYWORD",

[]{#LC2652 .anchor} "Origin": "INTERNAL",

[]{#LC2653 .anchor} "ShortName": "Identifiant du lot d'objets",

[]{#LC2654 .anchor} "Collections": \[

[]{#LC2655 .anchor} "LogbookOperation"

[]{#LC2656 .anchor} \]

[]{#LC2657 .anchor} },

[]{#LC2658 .anchor} {

[]{#LC2659 .anchor} "Identifier": "outDetail",

[]{#LC2660 .anchor} "SedaField": "OutcomeDetail",

[]{#LC2661 .anchor} "ApiField": "outDetail",

[]{#LC2662 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Code correspondant au résultat de l’événement.",

[]{#LC2663 .anchor} "Type": "KEYWORD",

[]{#LC2664 .anchor} "Origin": "INTERNAL",

[]{#LC2665 .anchor} "ShortName": "Code technique",

[]{#LC2666 .anchor} "Collections": \[

[]{#LC2667 .anchor} "LogbookOperation",

[]{#LC2668 .anchor} "Unit"

[]{#LC2669 .anchor} \]

[]{#LC2670 .anchor} },

[]{#LC2671 .anchor} {

[]{#LC2672 .anchor} "Identifier": "outMessg",

[]{#LC2673 .anchor} "SedaField": "OutcomeDetailMessage",

[]{#LC2674 .anchor} "ApiField": "outMessg",

[]{#LC2675 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Détail du résultat de l’événement.",

[]{#LC2676 .anchor} "Type": "TEXT",

[]{#LC2677 .anchor} "Origin": "INTERNAL",

[]{#LC2678 .anchor} "ShortName": "Message",

[]{#LC2679 .anchor} "Collections": \[

[]{#LC2680 .anchor} "LogbookOperation",

[]{#LC2681 .anchor} "Unit"

[]{#LC2682 .anchor} \]

[]{#LC2683 .anchor} },

[]{#LC2684 .anchor} {

[]{#LC2685 .anchor} "Identifier": "outcome",

[]{#LC2686 .anchor} "SedaField": "Outcome",

[]{#LC2687 .anchor} "ApiField": "outcome",

[]{#LC2688 .anchor} "Description": "Mapping : logbook-es-mapping.json.
Statut de l’événement",

[]{#LC2689 .anchor} "Type": "KEYWORD",

[]{#LC2690 .anchor} "Origin": "INTERNAL",

[]{#LC2691 .anchor} "ShortName": "Statut",

[]{#LC2692 .anchor} "Collections": \[

[]{#LC2693 .anchor} "LogbookOperation",

[]{#LC2694 .anchor} "Unit"

[]{#LC2695 .anchor} \]

[]{#LC2696 .anchor} },

[]{#LC2697 .anchor} {

[]{#LC2698 .anchor} "Identifier": "ApiField",

[]{#LC2699 .anchor} "ApiField": "ApiField",

[]{#LC2700 .anchor} "Description": "Mapping : ontology-es-mapping.json.
Correspond au nom donné au vocabulaire ontologique côté API.",

[]{#LC2701 .anchor} "Type": "KEYWORD",

[]{#LC2702 .anchor} "Origin": "INTERNAL",

[]{#LC2703 .anchor} "ShortName": "Intitulé",

[]{#LC2704 .anchor} "Collections": \[

[]{#LC2705 .anchor} "Ontology"

[]{#LC2706 .anchor} \]

[]{#LC2707 .anchor} },

[]{#LC2708 .anchor} {

[]{#LC2709 .anchor} "Identifier": "Collections",

[]{#LC2710 .anchor} "ApiField": "Collections",

[]{#LC2711 .anchor} "Description": "Mapping : ontology-es-mapping.json.
Collection(s) de la base de données associée(s) à un vocabulaire
ontologique",

[]{#LC2712 .anchor} "Type": "KEYWORD",

[]{#LC2713 .anchor} "Origin": "INTERNAL",

[]{#LC2714 .anchor} "ShortName": "Collections",

[]{#LC2715 .anchor} "Collections": \[

[]{#LC2716 .anchor} "Ontology"

[]{#LC2717 .anchor} \]

[]{#LC2718 .anchor} },

[]{#LC2719 .anchor} {

[]{#LC2720 .anchor} "Identifier": "Origin",

[]{#LC2721 .anchor} "ApiField": "Origin",

[]{#LC2722 .anchor} "Description": "Mapping : ontology-es-mapping.json.
Liste de valeurs : Interne (élément défini par VITAM) ou Externe
(extension au SEDA)",

[]{#LC2723 .anchor} "Type": "KEYWORD",

[]{#LC2724 .anchor} "Origin": "INTERNAL",

[]{#LC2725 .anchor} "ShortName": "Contexte de création",

[]{#LC2726 .anchor} "Collections": \[

[]{#LC2727 .anchor} "Ontology"

[]{#LC2728 .anchor} \]

[]{#LC2729 .anchor} },

[]{#LC2730 .anchor} {

[]{#LC2731 .anchor} "Identifier": "SedaField",

[]{#LC2732 .anchor} "ApiField": "SedaField",

[]{#LC2733 .anchor} "Description": "Mapping : ontology-es-mapping.json.
Elémént XML issu du SEDA.",

[]{#LC2734 .anchor} "Type": "KEYWORD",

[]{#LC2735 .anchor} "Origin": "INTERNAL",

[]{#LC2736 .anchor} "ShortName": "Intitulé",

[]{#LC2737 .anchor} "Collections": \[

[]{#LC2738 .anchor} "Ontology"

[]{#LC2739 .anchor} \]

[]{#LC2740 .anchor} },

[]{#LC2741 .anchor} {

[]{#LC2742 .anchor} "Identifier": "ShortName",

[]{#LC2743 .anchor} "ApiField": "ShortName",

[]{#LC2744 .anchor} "Description": "Mapping : ontology-es-mapping.json.
Correspond au label, ou traduction d'un enregistrement de la base de
données.",

[]{#LC2745 .anchor} "Type": "KEYWORD",

[]{#LC2746 .anchor} "Origin": "INTERNAL",

[]{#LC2747 .anchor} "ShortName": "Traduction",

[]{#LC2748 .anchor} "Collections": \[

[]{#LC2749 .anchor} "Ontology"

[]{#LC2750 .anchor} \]

[]{#LC2751 .anchor} },

[]{#LC2752 .anchor} {

[]{#LC2753 .anchor} "Identifier": "Format",

[]{#LC2754 .anchor} "ApiField": "Format",

[]{#LC2755 .anchor} "Description": "Mapping : profile-es-mapping.json.
Liste de valeurs : RNG ou XSD.",

[]{#LC2756 .anchor} "Type": "KEYWORD",

[]{#LC2757 .anchor} "Origin": "INTERNAL",

[]{#LC2758 .anchor} "ShortName": "Format",

[]{#LC2759 .anchor} "Collections": \[

[]{#LC2760 .anchor} "Profile"

[]{#LC2761 .anchor} \]

[]{#LC2762 .anchor} },

[]{#LC2763 .anchor} {

[]{#LC2764 .anchor} "Identifier": "Path",

[]{#LC2765 .anchor} "ApiField": "Path",

[]{#LC2766 .anchor} "Description": "Mapping : profile-es-mapping.json.
Lien vers le profil d'archivage RNG ou XSD.",

[]{#LC2767 .anchor} "Type": "KEYWORD",

[]{#LC2768 .anchor} "Origin": "INTERNAL",

[]{#LC2769 .anchor} "ShortName": "Fichier",

[]{#LC2770 .anchor} "Collections": \[

[]{#LC2771 .anchor} "Profile"

[]{#LC2772 .anchor} \]

[]{#LC2773 .anchor} },

[]{#LC2774 .anchor} {

[]{#LC2775 .anchor} "Identifier": "RuleDescription",

[]{#LC2776 .anchor} "ApiField": "RuleDescription",

[]{#LC2777 .anchor} "Description": "Mapping : rule-es-mapping.json.
Description associée à une règle de gestion.",

[]{#LC2778 .anchor} "Type": "TEXT",

[]{#LC2779 .anchor} "Origin": "INTERNAL",

[]{#LC2780 .anchor} "ShortName": "Description",

[]{#LC2781 .anchor} "Collections": \[

[]{#LC2782 .anchor} "FileRules"

[]{#LC2783 .anchor} \]

[]{#LC2784 .anchor} },

[]{#LC2785 .anchor} {

[]{#LC2786 .anchor} "Identifier": "RuleDuration",

[]{#LC2787 .anchor} "ApiField": "RuleDuration",

[]{#LC2788 .anchor} "Description": "Mapping : rule-es-mapping.json.
Durée associée à une règle de gestion, correspond à un entier.",

[]{#LC2789 .anchor} "Type": "KEYWORD",

[]{#LC2790 .anchor} "Origin": "INTERNAL",

[]{#LC2791 .anchor} "ShortName": "Durée",

[]{#LC2792 .anchor} "Collections": \[

[]{#LC2793 .anchor} "FileRules"

[]{#LC2794 .anchor} \]

[]{#LC2795 .anchor} },

[]{#LC2796 .anchor} {

[]{#LC2797 .anchor} "Identifier": "RuleId",

[]{#LC2798 .anchor} "ApiField": "RuleId",

[]{#LC2799 .anchor} "Description": "Mapping : rule-es-mapping.json.
Identifiant associé à une règle de gestion.",

[]{#LC2800 .anchor} "Type": "KEYWORD",

[]{#LC2801 .anchor} "Origin": "INTERNAL",

[]{#LC2802 .anchor} "ShortName": "Identifiant",

[]{#LC2803 .anchor} "Collections": \[

[]{#LC2804 .anchor} "FileRules"

[]{#LC2805 .anchor} \]

[]{#LC2806 .anchor} },

[]{#LC2807 .anchor} {

[]{#LC2808 .anchor} "Identifier": "RuleMeasurement",

[]{#LC2809 .anchor} "ApiField": "RuleMeasurement",

[]{#LC2810 .anchor} "Description": "Mapping : rule-es-mapping.json.
Mesure associée à une règle de gestion. Correspond aux valeurs : année,
mois, jour. Mesure devant être associée à une durée.",

[]{#LC2811 .anchor} "Type": "KEYWORD",

[]{#LC2812 .anchor} "Origin": "INTERNAL",

[]{#LC2813 .anchor} "ShortName": "Mesure",

[]{#LC2814 .anchor} "Collections": \[

[]{#LC2815 .anchor} "FileRules"

[]{#LC2816 .anchor} \]

[]{#LC2817 .anchor} },

[]{#LC2818 .anchor} {

[]{#LC2819 .anchor} "Identifier": "RuleType",

[]{#LC2820 .anchor} "ApiField": "RuleType",

[]{#LC2821 .anchor} "Description": "Mapping : rule-es-mapping.json. Type
associé à une règle de gestion.",

[]{#LC2822 .anchor} "Type": "KEYWORD",

[]{#LC2823 .anchor} "Origin": "INTERNAL",

[]{#LC2824 .anchor} "ShortName": "Type",

[]{#LC2825 .anchor} "Collections": \[

[]{#LC2826 .anchor} "FileRules"

[]{#LC2827 .anchor} \]

[]{#LC2828 .anchor} },

[]{#LC2829 .anchor} {

[]{#LC2830 .anchor} "Identifier": "RuleValue",

[]{#LC2831 .anchor} "ApiField": "RuleValue",

[]{#LC2832 .anchor} "Description": "Mapping : rule-es-mapping.json.
Identifiant, code ou clé définissant une règle de gestion. Doit être
unique.",

[]{#LC2833 .anchor} "Type": "TEXT",

[]{#LC2834 .anchor} "Origin": "INTERNAL",

[]{#LC2835 .anchor} "ShortName": "Identifiant",

[]{#LC2836 .anchor} "Collections": \[

[]{#LC2837 .anchor} "FileRules"

[]{#LC2838 .anchor} \]

[]{#LC2839 .anchor} },

[]{#LC2840 .anchor} {

[]{#LC2841 .anchor} "Identifier": "UpdateDate",

[]{#LC2842 .anchor} "ApiField": "UpdateDate",

[]{#LC2843 .anchor} "Description": "Mapping : rule-es-mapping.json",

[]{#LC2844 .anchor} "Type": "DATE",

[]{#LC2845 .anchor} "Origin": "INTERNAL",

[]{#LC2846 .anchor} "ShortName": "Dernière modification",

[]{#LC2847 .anchor} "Collections": \[

[]{#LC2848 .anchor} "FileRules",

[]{#LC2849 .anchor} "FileFormat"

[]{#LC2850 .anchor} \]

[]{#LC2851 .anchor} },

[]{#LC2852 .anchor} {

[]{#LC2853 .anchor} "Identifier": "FullAccess",

[]{#LC2854 .anchor} "ApiField": "FullAccess",

[]{#LC2855 .anchor} "Description": "Mapping :
securityprofile-es-mapping.json. Mode super-administrateur donnant
toutes les permissions.",

[]{#LC2856 .anchor} "Type": "BOOLEAN",

[]{#LC2857 .anchor} "Origin": "INTERNAL",

[]{#LC2858 .anchor} "ShortName": "Tous les droits",

[]{#LC2859 .anchor} "Collections": \[

[]{#LC2860 .anchor} "SecurityProfile"

[]{#LC2861 .anchor} \]

[]{#LC2862 .anchor} },

[]{#LC2863 .anchor} {

[]{#LC2864 .anchor} "Identifier": "Permissions",

[]{#LC2865 .anchor} "ApiField": "Permissions",

[]{#LC2866 .anchor} "Description": "Mapping :
securityprofile-es-mapping.json",

[]{#LC2867 .anchor} "Type": "KEYWORD",

[]{#LC2868 .anchor} "Origin": "INTERNAL",

[]{#LC2869 .anchor} "ShortName": "Permissions",

[]{#LC2870 .anchor} "Collections": \[

[]{#LC2871 .anchor} "SecurityProfile"

[]{#LC2872 .anchor} \]

[]{#LC2873 .anchor} },

[]{#LC2874 .anchor} {

[]{#LC2875 .anchor} "Identifier": "ud",

[]{#LC2876 .anchor} "ApiField": "ud",

[]{#LC2877 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC2878 .anchor} "Type": "DATE",

[]{#LC2879 .anchor} "Origin": "INTERNAL",

[]{#LC2880 .anchor} "ShortName": "Dernière modification",

[]{#LC2881 .anchor} "Collections": \[

[]{#LC2882 .anchor} "Unit"

[]{#LC2883 .anchor} \]

[]{#LC2884 .anchor} },

[]{#LC2885 .anchor} {

[]{#LC2886 .anchor} "Identifier": "OperationId",

[]{#LC2887 .anchor} "ApiField": "OperationId",

[]{#LC2888 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant de l'operation.",

[]{#LC2889 .anchor} "Type": "KEYWORD",

[]{#LC2890 .anchor} "Origin": "INTERNAL",

[]{#LC2891 .anchor} "ShortName": "OperationId",

[]{#LC2892 .anchor} "Collections": \[

[]{#LC2893 .anchor} "Unit"

[]{#LC2894 .anchor} \]

[]{#LC2895 .anchor} },

[]{#LC2896 .anchor} {

[]{#LC2897 .anchor} "Identifier": "GlobalStatus",

[]{#LC2898 .anchor} "ApiField": "GlobalStatus",

[]{#LC2899 .anchor} "Description": "Mapping : unit-es-mapping.json.
Statut global de l'indexation.",

[]{#LC2900 .anchor} "Type": "KEYWORD",

[]{#LC2901 .anchor} "Origin": "INTERNAL",

[]{#LC2902 .anchor} "ShortName": "GlobalStatus",

[]{#LC2903 .anchor} "Collections": \[

[]{#LC2904 .anchor} "Unit"

[]{#LC2905 .anchor} \]

[]{#LC2906 .anchor} },

[]{#LC2907 .anchor} {

[]{#LC2908 .anchor} "Identifier": "DestroyableOriginatingAgencies",

[]{#LC2909 .anchor} "ApiField": "DestroyableOriginatingAgencies",

[]{#LC2910 .anchor} "Description": "Mapping : unit-es-mapping.json.
Services producteurs éliminables",

[]{#LC2911 .anchor} "Type": "KEYWORD",

[]{#LC2912 .anchor} "Origin": "INTERNAL",

[]{#LC2913 .anchor} "ShortName": "DestroyableOriginatingAgencies",

[]{#LC2914 .anchor} "Collections": \[

[]{#LC2915 .anchor} "Unit"

[]{#LC2916 .anchor} \]

[]{#LC2917 .anchor} },

[]{#LC2918 .anchor} {

[]{#LC2919 .anchor} "Identifier": "NonDestroyableOriginatingAgencies",

[]{#LC2920 .anchor} "ApiField": "NonDestroyableOriginatingAgencies",

[]{#LC2921 .anchor} "Description": "Mapping : unit-es-mapping.json.
Services producteurs non éliminables",

[]{#LC2922 .anchor} "Type": "KEYWORD",

[]{#LC2923 .anchor} "Origin": "INTERNAL",

[]{#LC2924 .anchor} "ShortName": "NonDestroyableOriginatingAgencies",

[]{#LC2925 .anchor} "Collections": \[

[]{#LC2926 .anchor} "Unit"

[]{#LC2927 .anchor} \]

[]{#LC2928 .anchor} },

[]{#LC2929 .anchor} {

[]{#LC2930 .anchor} "Identifier": "ExtendedInfoType",

[]{#LC2931 .anchor} "ApiField": "ExtendedInfoType",

[]{#LC2932 .anchor} "Description": "Mapping : unit-es-mapping.json. Type
d'informations étendues",

[]{#LC2933 .anchor} "Type": "KEYWORD",

[]{#LC2934 .anchor} "Origin": "INTERNAL",

[]{#LC2935 .anchor} "ShortName": "ExtendedInfoType",

[]{#LC2936 .anchor} "Collections": \[

[]{#LC2937 .anchor} "Unit"

[]{#LC2938 .anchor} \]

[]{#LC2939 .anchor} },

[]{#LC2940 .anchor} {

[]{#LC2941 .anchor} "Identifier": "ParentUnitId",

[]{#LC2942 .anchor} "ApiField": "ParentUnitId",

[]{#LC2943 .anchor} "Description": "Mapping : unit-es-mapping.json.
Identifiant de l'unité parente",

[]{#LC2944 .anchor} "Type": "KEYWORD",

[]{#LC2945 .anchor} "Origin": "INTERNAL",

[]{#LC2946 .anchor} "ShortName": "ParentUnitId",

[]{#LC2947 .anchor} "Collections": \[

[]{#LC2948 .anchor} "Unit"

[]{#LC2949 .anchor} \]

[]{#LC2950 .anchor} },

[]{#LC2951 .anchor} {

[]{#LC2952 .anchor} "Identifier": "OriginatingAgenciesInConflict",

[]{#LC2953 .anchor} "ApiField": "OriginatingAgenciesInConflict",

[]{#LC2954 .anchor} "Description": "Mapping : unit-es-mapping.json.
Services producteurs en conflit",

[]{#LC2955 .anchor} "Type": "KEYWORD",

[]{#LC2956 .anchor} "Origin": "INTERNAL",

[]{#LC2957 .anchor} "ShortName": "OriginatingAgenciesInConflict",

[]{#LC2958 .anchor} "Collections": \[

[]{#LC2959 .anchor} "Unit"

[]{#LC2960 .anchor} \]

[]{#LC2961 .anchor} },

[]{#LC2962 .anchor} {

[]{#LC2963 .anchor} "Identifier": "\_sedaVersion",

[]{#LC2964 .anchor} "ApiField": "\#sedaVersion",

[]{#LC2965 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC2966 .anchor} "Type": "KEYWORD",

[]{#LC2967 .anchor} "Origin": "INTERNAL",

[]{#LC2968 .anchor} "ShortName": "\_sedaVersion",

[]{#LC2969 .anchor} "Collections": \[

[]{#LC2970 .anchor} "Unit"

[]{#LC2971 .anchor} \]

[]{#LC2972 .anchor} },

[]{#LC2973 .anchor} {

[]{#LC2974 .anchor} "Identifier": "\_implementationVersion",

[]{#LC2975 .anchor} "ApiField": "\#implementationVersion",

[]{#LC2976 .anchor} "Description": "Mapping : unit-es-mapping.json",

[]{#LC2977 .anchor} "Type": "KEYWORD",

[]{#LC2978 .anchor} "Origin": "INTERNAL",

[]{#LC2979 .anchor} "ShortName": "\_implementationVersion",

[]{#LC2980 .anchor} "Collections": \[

[]{#LC2981 .anchor} "Unit"

[]{#LC2982 .anchor} \]

[]{#LC2983 .anchor} },

[]{#LC2984 .anchor} {

[]{#LC2985 .anchor} "Identifier": "Compressed",

[]{#LC2986 .anchor} "SedaField": "Compressed",

[]{#LC2987 .anchor} "Description": "Indique si l’objet-données est
compressé et doit être décompressé.",

[]{#LC2988 .anchor} "Type": "TEXT",

[]{#LC2989 .anchor} "Origin": "INTERNAL",

[]{#LC2990 .anchor} "ShortName": "Objet compressé",

[]{#LC2991 .anchor} "Collections": \[

[]{#LC2992 .anchor} "ObjectGroup"

[]{#LC2993 .anchor} \]

[]{#LC2994 .anchor} },

[]{#LC2995 .anchor} {

[]{#LC2996 .anchor} "Identifier": "RawMetadata",

[]{#LC2997 .anchor} "ApiField": "RawMetadata",

[]{#LC2998 .anchor} "Description": "Métadonnées brutes, issues d'une
extraction de métadonnées",

[]{#LC2999 .anchor} "Type": "TEXT",

[]{#LC3000 .anchor} "Origin": "INTERNAL",

[]{#LC3001 .anchor} "ShortName": "Métadonnées extraites",

[]{#LC3002 .anchor} "Collections": \[

[]{#LC3003 .anchor} "ObjectGroup"

[]{#LC3004 .anchor} \]

[]{#LC3005 .anchor} },

[]{#LC3006 .anchor} {

[]{#LC3007 .anchor} "Identifier": "BinaryObjectSize",

[]{#LC3008 .anchor} "ApiField": "BinaryObjectSize",

[]{#LC3009 .anchor} "Description": "Volumétrie des objets de fonds
symboliques",

[]{#LC3010 .anchor} "Type": "DOUBLE",

[]{#LC3011 .anchor} "Origin": "INTERNAL",

[]{#LC3012 .anchor} "ShortName": "Volumétrie des objets",

[]{#LC3013 .anchor} "Collections": \[

[]{#LC3014 .anchor} "AccessionRegisterSymbolic"

[]{#LC3015 .anchor} \]

[]{#LC3016 .anchor} },

[]{#LC3017 .anchor} {

[]{#LC3018 .anchor} "Identifier": "BinaryObject",

[]{#LC3019 .anchor} "ApiField": "BinaryObject",

[]{#LC3020 .anchor} "Description": "Nombre d'objets de fonds
symboliques",

[]{#LC3021 .anchor} "Type": "LONG",

[]{#LC3022 .anchor} "Origin": "INTERNAL",

[]{#LC3023 .anchor} "ShortName": "Nombre d'objets",

[]{#LC3024 .anchor} "Collections": \[

[]{#LC3025 .anchor} "AccessionRegisterSymbolic"

[]{#LC3026 .anchor} \]

[]{#LC3027 .anchor} },

[]{#LC3028 .anchor} {

[]{#LC3029 .anchor} "Identifier": "ObjectGroup",

[]{#LC3030 .anchor} "ApiField": "ObjectGroup",

[]{#LC3031 .anchor} "Description": "Nombre de groupes d'objets
techniques de fonds symboliques",

[]{#LC3032 .anchor} "Type": "LONG",

[]{#LC3033 .anchor} "Origin": "INTERNAL",

[]{#LC3034 .anchor} "ShortName": "Nombre de groupes d'objets
techniques",

[]{#LC3035 .anchor} "Collections": \[

[]{#LC3036 .anchor} "AccessionRegisterSymbolic"

[]{#LC3037 .anchor} \]

[]{#LC3038 .anchor} },

[]{#LC3039 .anchor} {

[]{#LC3040 .anchor} "Identifier": "ArchiveUnit",

[]{#LC3041 .anchor} "ApiField": "ArchiveUnit",

[]{#LC3042 .anchor} "Description": "Nombre d'unités archivistiques de
fonds symboliques",

[]{#LC3043 .anchor} "Type": "LONG",

[]{#LC3044 .anchor} "Origin": "INTERNAL",

[]{#LC3045 .anchor} "ShortName": "Nombre d'unités archivistiques",

[]{#LC3046 .anchor} "Collections": \[

[]{#LC3047 .anchor} "AccessionRegisterSymbolic"

[]{#LC3048 .anchor} \]

[]{#LC3049 .anchor} },

[]{#LC3050 .anchor} {

[]{#LC3051 .anchor} "Identifier": "FilteredExtractedObjectGroupData",

[]{#LC3052 .anchor} "ApiField": "FilteredExtractedObjectGroupData",

[]{#LC3053 .anchor} "Description": "Métadonnées à extraire dans le
groupe d'objets techniques",

[]{#LC3054 .anchor} "Type": "KEYWORD",

[]{#LC3055 .anchor} "Origin": "INTERNAL",

[]{#LC3056 .anchor} "ShortName": "Métadonnées à extraire dans le groupe
d'objets techniques",

[]{#LC3057 .anchor} "Collections": \[

[]{#LC3058 .anchor} "PreservationScenario"

[]{#LC3059 .anchor} \]

[]{#LC3060 .anchor} },

[]{#LC3061 .anchor} {

[]{#LC3062 .anchor} "Identifier": "FilteredExtractedUnitData",

[]{#LC3063 .anchor} "ApiField": "FilteredExtractedUnitData",

[]{#LC3064 .anchor} "Description": "Métadonnées à extraire dans les
unités archivistiques",

[]{#LC3065 .anchor} "Type": "KEYWORD",

[]{#LC3066 .anchor} "Origin": "INTERNAL",

[]{#LC3067 .anchor} "ShortName": "Métadonnées à extraire dans les unités
archivistiques",

[]{#LC3068 .anchor} "Collections": \[

[]{#LC3069 .anchor} "PreservationScenario"

[]{#LC3070 .anchor} \]

[]{#LC3071 .anchor} },

[]{#LC3072 .anchor} {

[]{#LC3073 .anchor} "Identifier": "CheckParentId",

[]{#LC3074 .anchor} "ApiField": "CheckParentId",

[]{#LC3075 .anchor} "Description": "Déclaration d’un ou plusieurs cônes
de positionnement des rattachements",

[]{#LC3076 .anchor} "Type": "KEYWORD",

[]{#LC3077 .anchor} "Origin": "INTERNAL",

[]{#LC3078 .anchor} "ShortName": "Déclaration d’un ou plusieurs cônes de
positionnement des rattachements",

[]{#LC3079 .anchor} "Collections": \[

[]{#LC3080 .anchor} "IngestContract"

[]{#LC3081 .anchor} \]

[]{#LC3082 .anchor} },

[]{#LC3083 .anchor} {

[]{#LC3084 .anchor} "Identifier": "ArchivalProfile",

[]{#LC3085 .anchor} "SedaField": "ArchivalProfile",

[]{#LC3086 .anchor} "Description": "Mapping :
accessionregisterdetail-es-mapping.json.",

[]{#LC3087 .anchor} "Type": "KEYWORD",

[]{#LC3088 .anchor} "Origin": "INTERNAL",

[]{#LC3089 .anchor} "ShortName": "Profile d'archivage",

[]{#LC3090 .anchor} "Collections": \[

[]{#LC3091 .anchor} "AccessionRegisterDetail"

[]{#LC3092 .anchor} \]

[]{#LC3093 .anchor} },

[]{#LC3094 .anchor} {

[]{#LC3095 .anchor} "Identifier": "DataObjectSystemId",

[]{#LC3096 .anchor} "SedaField": "DataObjectSystemId",

[]{#LC3097 .anchor} "Description": "Mapping : og-es-mapping.json.",

[]{#LC3098 .anchor} "Type": "KEYWORD",

[]{#LC3099 .anchor} "Origin": "INTERNAL",

[]{#LC3100 .anchor} "ShortName": "Identifiant de l'objet",

[]{#LC3101 .anchor} "Collections": \[

[]{#LC3102 .anchor} "ObjectGroup"

[]{#LC3103 .anchor} \]

[]{#LC3104 .anchor} },

[]{#LC3105 .anchor} {

[]{#LC3106 .anchor} "Identifier": "DataObjectGroupSystemId",

[]{#LC3107 .anchor} "SedaField": "DataObjectGroupSystemId",

[]{#LC3108 .anchor} "Description": "Mapping : og-es-mapping.json.",

[]{#LC3109 .anchor} "Type": "KEYWORD",

[]{#LC3110 .anchor} "Origin": "INTERNAL",

[]{#LC3111 .anchor} "ShortName": "Identifiant du groupe d'objet",

[]{#LC3112 .anchor} "Collections": \[

[]{#LC3113 .anchor} "ObjectGroup"

[]{#LC3114 .anchor} \]

[]{#LC3115 .anchor} },

[]{#LC3116 .anchor} {

[]{#LC3117 .anchor} "Identifier": "\_validComputedInheritedRules",

[]{#LC3118 .anchor} "Description": "Indique si les règles calculées sont
valides",

[]{#LC3119 .anchor} "Type": "BOOLEAN",

[]{#LC3120 .anchor} "Origin": "INTERNAL",

[]{#LC3121 .anchor} "ShortName": "validComputedInheritedRules",

[]{#LC3122 .anchor} "Collections": \[

[]{#LC3123 .anchor} "Unit"

[]{#LC3124 .anchor} \]

[]{#LC3125 .anchor} },

[]{#LC3126 .anchor} {

[]{#LC3127 .anchor} "Identifier": "MaxEndDate",

[]{#LC3128 .anchor} "Description": "Date de fin maximale",

[]{#LC3129 .anchor} "Type": "DATE",

[]{#LC3130 .anchor} "Origin": "INTERNAL",

[]{#LC3131 .anchor} "ShortName": "MaxEndDate",

[]{#LC3132 .anchor} "Collections": \[

[]{#LC3133 .anchor} "Unit"

[]{#LC3134 .anchor} \]

[]{#LC3135 .anchor} },

[]{#LC3136 .anchor} {

[]{#LC3137 .anchor} "Identifier": "indexationDate",

[]{#LC3138 .anchor} "Description": "Date d'indexation'",

[]{#LC3139 .anchor} "Type": "DATE",

[]{#LC3140 .anchor} "Origin": "INTERNAL",

[]{#LC3141 .anchor} "ShortName": "indexationDate",

[]{#LC3142 .anchor} "Collections": \[

[]{#LC3143 .anchor} "Unit"

[]{#LC3144 .anchor} \]

[]{#LC3145 .anchor} },

[]{#LC3146 .anchor} {

[]{#LC3147 .anchor} "Identifier": "UnitStrategy",

[]{#LC3148 .anchor} "ApiField": "UnitStrategy",

[]{#LC3149 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Stratégie de stockage pour les
métadonnées de type unité archivistique",

[]{#LC3150 .anchor} "Type": "KEYWORD",

[]{#LC3151 .anchor} "Origin": "INTERNAL",

[]{#LC3152 .anchor} "ShortName": "UnitStrategy",

[]{#LC3153 .anchor} "Collections": \[

[]{#LC3154 .anchor} "ManagementContract"

[]{#LC3155 .anchor} \]

[]{#LC3156 .anchor} },

[]{#LC3157 .anchor} {

[]{#LC3158 .anchor} "Identifier": "ObjectGroupStrategy",

[]{#LC3159 .anchor} "ApiField": "ObjectGroupStrategy",

[]{#LC3160 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Stratégie de stockage pour les
métadonnées de type groupe d'objet technique",

[]{#LC3161 .anchor} "Type": "KEYWORD",

[]{#LC3162 .anchor} "Origin": "INTERNAL",

[]{#LC3163 .anchor} "ShortName": "ObjectGroupStrategy",

[]{#LC3164 .anchor} "Collections": \[

[]{#LC3165 .anchor} "ManagementContract"

[]{#LC3166 .anchor} \]

[]{#LC3167 .anchor} },

[]{#LC3168 .anchor} {

[]{#LC3169 .anchor} "Identifier": "ObjectStrategy",

[]{#LC3170 .anchor} "ApiField": "ObjectStrategy",

[]{#LC3171 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Stratégie de stockage pour les
objets",

[]{#LC3172 .anchor} "Type": "KEYWORD",

[]{#LC3173 .anchor} "Origin": "INTERNAL",

[]{#LC3174 .anchor} "ShortName": "ObjectStrategy",

[]{#LC3175 .anchor} "Collections": \[

[]{#LC3176 .anchor} "ManagementContract"

[]{#LC3177 .anchor} \]

[]{#LC3178 .anchor} },

[]{#LC3179 .anchor} {

[]{#LC3180 .anchor} "Identifier": "InitialVersion",

[]{#LC3181 .anchor} "ApiField": "InitialVersion",

[]{#LC3182 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Politique de conservation des
versions initiales",

[]{#LC3183 .anchor} "Type": "BOOLEAN",

[]{#LC3184 .anchor} "Origin": "INTERNAL",

[]{#LC3185 .anchor} "ShortName": "InitialVersion",

[]{#LC3186 .anchor} "Collections": \[

[]{#LC3187 .anchor} "ManagementContract"

[]{#LC3188 .anchor} \]

[]{#LC3189 .anchor} },

[]{#LC3190 .anchor} {

[]{#LC3191 .anchor} "Identifier": "IntermediaryVersion",

[]{#LC3192 .anchor} "ApiField": "IntermediaryVersion",

[]{#LC3193 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Politique de conservation des
versions intermédiaries",

[]{#LC3194 .anchor} "Type": "KEYWORD",

[]{#LC3195 .anchor} "Origin": "INTERNAL",

[]{#LC3196 .anchor} "ShortName": "IntermediaryVersion",

[]{#LC3197 .anchor} "Collections": \[

[]{#LC3198 .anchor} "ManagementContract"

[]{#LC3199 .anchor} \]

[]{#LC3200 .anchor} },

[]{#LC3201 .anchor} {

[]{#LC3202 .anchor} "Identifier": "UsageName",

[]{#LC3203 .anchor} "ApiField": "UsageName",

[]{#LC3204 .anchor} "Description": "Mapping :
managementcontract-es-mapping.json. Nom d'usage pour la politique de
conservation des versions",

[]{#LC3205 .anchor} "Type": "KEYWORD",

[]{#LC3206 .anchor} "Origin": "INTERNAL",

[]{#LC3207 .anchor} "ShortName": "UsageName",

[]{#LC3208 .anchor} "Collections": \[

[]{#LC3209 .anchor} "ManagementContract"

[]{#LC3210 .anchor} \]

[]{#LC3211 .anchor} }

[]{#LC3212 .anchor}\]

[]{#__RefHeading___Toc7678_1347383732 .anchor}Annexe 2 : Types JSON
conformes au type d’indexation des vocabulaires internes

Pour les éléments propres au SEDA, le tableau suivant précise les types
de certains d’entre eux, tels qu’ils doivent être dans un schéma de
contrôle, conformément au type d’indexation du vocabulaire déclaré dans
l’ontologie :

  ----------------------------------------- ------------ ------------ ------------- ------------ -----------

                                            **string**   **number**   **boolean**   **object**   **array**

  \_up                                      x                                                    
  \_og                                      x                                                    
  ArchiveUnitProfile                        x                                                    
  Management                                                                        x            
  AccessRule                                                                        x            
  AppraisalRule                                                                     x            
  StorageRule                                                                       x            
  ReuseRule                                                                         x            
  ClassificationRule                                                                x            
  Rule                                      x                                                    
  StartDate                                 x[^31]                                               
  EndDate                                   x[^32]                                               
  FinalAction[^33]                          x                                                    
  Inheritance                                                                       x            
  PreventInheritance                                                  x                          
  PreventRulesId                                                                                 x[^34]
  DescriptionLevel                          x                                                    
  Title                                     x                                                    x
  FilePlanPosition                          x                                                    x
  SystemId                                  x                                                    x
  OriginatingSystemId                       x                                                    x
  ArchivalAgencyArchiveUnitIdentifier       x                                                    x
  OriginatingAgencyArchiveUnitIdentifier    x                                                    x
  TransferringAgencyArchiveUnitIdentifier   x                                                    x
  Description                               x                                                    x
  CustodialHistory                                                                  x            
  CustodialHistoryItem                      x                                                    x
  Type                                      x                                                    
  DocumentType                              x                                                    
  Language                                  x[^35]                                               x
  DescriptionLanguage                       x[^36]                                               
  Status                                    x                                                    
  Version                                   x                                                    
  Tag                                       x                                                    x
  Keyword                                                                           x            x
  KeywordContent                            x                                                    
  KeywordReference                          x                                                    
  KeywordType                               x                                                    
  Coverage                                                                          x            
  Spatial                                   x                                                    x
  Temporal                                  x                                                    x
  Juridictional                             x                                                    x
  OriginatingAgency                                                                 x            
  SubmissionAgency                                                                  x            
  Identifier                                x                                                    
  AuthorizedAgent                                                                   x            x
  Writer                                                                            x            x
  Addressee                                                                         x            x
  Recipient                                                                         x            x
  Transmitter                                                                       x            x
  Sender                                                                            x            x
  FirstName                                 x                                                    
  BirthName                                 x                                                    
  FullName                                  x                                                    
  GivenName                                 x                                                    
  Gender                                    x                                                    
  BirthDate                                 x[^37]                                               
  DeathDate                                 x[^38]                                               
  BirthPlace                                                                        x            
  DeathPlace                                                                        x            
  Geogname                                  x                                                    
  Address                                   x                                                    
  PostalCode                                x                                                    
  City                                      x                                                    
  Region                                    x                                                    
  Country                                   x                                                    
  Nationality                               x                                                    
  Corpname                                  x                                                    
  Identifier                                x                                                    
  Function                                  x                                                    
  Activity                                  x                                                    
  Position                                  x                                                    
  Role                                      x                                                    
  Mandate                                   x                                                    
  RelatedObjectReference                                                            x            
  IsVersionOf                                                                       x            
  Replaces                                                                          x            
  Requires                                                                          x            
  IsPartOf                                                                          x            
  References                                                                        x            
  ArchiveUnitRefId                          x                                                    
  DataObjectReference                                                               x            
  DataObjectReferenceId                     x                                                    
  DataObjectGroupReferenceId                x                                                    
  RepositoryArchiveUnitPID                  x                                                    
  RepositoryObjectPID                       x                                                    
  CreatedDate                               x                                                    
  TransactedDate                            x                                                    
  AcquiredDate                              x                                                    
  SentDate                                  x                                                    
  ReceivedDate                              x                                                    
  RegisteredDate                            x                                                    
  StartDate                                 x                                                    
  EndDate                                   x                                                    
  Event                                                                             x            
  evId[^39]                                 x                                                    
  evTypeProc[^40]                           x                                                    
  evType[^41]                               x                                                    
  EvDateTime[^42]                           x                                                    
  evTypeDetail[^43]                         x                                                    
  outcome[^44]                              x                                                    
  outDetail[^45]                            x                                                    
  outMessg[^46]                             x                                                    
  evDetData[^47]                            x                                                    
  Signature                                                                         x            
  Signer                                                                            x            
  Validator                                                                         x            
  ValidationTime                            x                                                    
  MasterData                                x                                                    
  ReferencedObject                                                                  x            
  SignedObjectId                            x                                                    
  SignedObjectDigest                        x                                                    
  Gps                                                                               x            
  GpsVersionId                              x                                                    
  GpsAltitude                               x                                                    
  GpsAltitudeRef                            x                                                    
  GpsLatitude                               x                                                    
  GpsLongitude                              x                                                    
  GpsLongitudeRef                           x                                                    
  GpsDateStamp                              x                                                    

  ----------------------------------------- ------------ ------------ ------------- ------------ -----------

[[]{#refheading___toc15927_1084181859
.anchor}]{#__RefHeading___Toc15927_1084181859 .anchor}

[^1]: Pour plus de précisions, consulter la section 3. « Formalisation
    des vocabulaires ontologiques » du présent document.

[^2]: Ces vocabulaires sont détaillés dans la documentation *Modèle de
    données*.

[^3]: Seules les collections Unit et ObjectGroup peuvent faire l’objet
    d’ajout de nouveaux vocabulaires. Il n’est pas possible d’étendre
    les autres collections.

[^4]: Des précisions sur les types d’indexation supportés par la
    solution logicielle Vitam sont apportées dans la partie 5.2. « Quand
    et comment créer un vocabulaire ? ».

[^5]: Pour plus d’informations, consulter le document *Modèle de
    données*, chapitre « Collection Ontology ». Un exemple d’ontologie
    se trouve dans l’annexe 1 du présent document.

[^6]: Des précisions sur les types d’indexation supportés par la
    solution logicielle Vitam sont apportées dans la partie 5.2. « Quand
    et comment créer un vocabulaire ? ».

[^7]: Pour plus d’informations sur la modélisation de cette collection,
    consulter le document *Modèle de données*, chapitre « Collection
    Ontology ».

[^8]: Pour plus d’informations sur le processus d’import du référentiel,
    consulter le document *Modèle de workflow*, chapitre 5.11 « Workflow
    d’administration d’un référentiel des vocabulaires de l’ontologie ».

[^9]: Pour plus d’informations sur le processus d’import du référentiel,
    consulter le document *Modèle de workflow*, chapitre 5.11 « Workflow
    d’administration d’un référentiel des vocabulaires de l’ontologie ».

[^10]: Les règles propres à la mise à jour du type d’indexation d’un
    vocabulaire sont définies dans la partie 5.3. « Quand et comment
    modifier un type d’indexation ? » du présent document.

[^11]: La procédure est détaillée dans la documentation d’exploitation,
    chapitre 5.19. « L’ontologie externe suite à la montée de version de
    Vitam ». Ce service permet de ne pas mettre à jour les vocabulaires
    externes. Il s’applique notamment lors des montées de version du
    modèle de données interne à la solution logicielle Vitam ou du SEDA.

[^12]: Les règles propres à la mise à jour du type d’indexation d’un
    vocabulaire sont définies dans la partie 5.3. « Quand et comment
    modifier un type d’indexation ? » du présent document.

[^13]: Un utilisateur externe n’a pas vocation à modifier, ajouter ou
    supprimer les autres collections qui référencent uniquement des
    vocabulaires internes.

[^14]: Les règles propres au nommage d’un vocabulaire sont définies dans
    la partie « Conseils de mise en œuvre » du présent document.

[^15]: Pour plus d’informations, consulter la documentation
    d’exploitation, chapitre 5.11. « Procédure d’exploitation suite à la
    création ou la modification d’une ontologie ».

[^16]: Les règles propres à la cohérence des types définis dans un
    profil d’unité archivistique et dans l’ontologie sont définies dans
    la partie 5.4. « Quels sont les types d’indexation compatibles entre
    un profil d’unité archivistique et des vocabulaires ontologiques ? »
    du présent document.

[^17]: Les règles de mise à jour d’une unité archivistique associée à un
    profil d’unité archivistique sont précisées dans la partie 5.5.
    « Comment modifier une unité archivistique associée à un profil
    d’unité archivistique ? » du présent document.

[^18]: Pour plus de précisions sur ce qu’est un élément de type objet,
    se référer à la présente documentation, section 2.1. « Qu’est-ce
    qu’une ontologie ? ».

[^19]: Pour plus d’informations, consulter la documentation
    d’exploitation, chapitre 5.11. « Procédure d’exploitation suite à la
    création ou la modification d’une ontologie ».

[^20]: Pour plus d’informations, consulter la documentation
    d’exploitation, chapitre 5.11 « Procédure d’exploitation suite à la
    création ou la modification d’une ontologie ».

[^21]: Ce type est compatible si et seulement si les données en base
    correspondent à des dates.

[^22]: Ce type est compatible si et seulement si les données en base
    correspondent à des dates.

[^23]: Ce type est compatible si et seulement si les données en base
    correspondent à des décimaux.

[^24]: Ce type est compatible si et seulement si les données en base
    correspondent à des entiers.

[^25]: La présence de crochets dans le tableau de correspondances
    indique que le vocabulaire employé dans le profil d’unité
    archivistique doit se présenter sous la forme d’un tableau. Pour
    plus d’informations, consulter le document *Profil d’unité
    archivistique*. L’annexe 2 « Types JSON conformes au type
    d’indexation des vocabulaires internes » du présent document précise
    les types attendus dans un schéma de contrôle pour définir un
    vocabulaire interne, conformément à son type dans l’ontologie.

[^26]: Pour plus d’informations, consulter la documentation
    d’exploitation, chapitre 5.11 « Procédure d’exploitation suite à la
    création ou la modification d’une ontologie ».

[^27]: La procédure est détaillée dans la documentation d’exploitation,
    chapitre 5.19. « L’ontologie externe suite à la montée de version de
    Vitam » et la documentation de montée de version, chapitre
    4.3.7.1.1. « Gestion du référentiel de l’ontologie ».

[^28]: La procédure est détaillée dans la documentation d’exploitation,
    chapitre 5.19. « L’ontologie externe suite à la montée de version de
    Vitam » et la documentation de montée de version, chapitre
    4.3.7.1.1. « Gestion du référentiel de l’ontologie ».

[^29]: Pour plus d’informations, se référer aux chapitres précédents du
    présent document : chapitre 5.2. « Quand et comment créer un
    vocabulaire ? », chapitre 5.3. « Quand et comment modifier un type
    d’indexation ? », chapitre 5.5. « Quand et comment supprimer un
    vocabulaire ? ».

[^30]: Consulter la documentation de montée de version, chapitre
    4.3.7.1.1. « Gestion du référentiel de l’ontologie ».

[^31]: Avec un pattern date.

[^32]: Idem.

[^33]: Simple énumération.

[^34]: Tableau contenant des éléments de type string.

[^35]: Le SEDA attend plus précisément un pattern langue.

[^36]: Idem.

[^37]: Avec un pattern date.

[^38]: Idem.

[^39]: evId est à employer en lieu et place de la balise EventIdentifier
    dans un schéma de contrôle pour se conformer aux attendus de la
    solution logicielle Vitam.

[^40]: evTypeProc est à employer en lieu et place de la balise
    EventTypeCode dans un schéma de contrôle pour se conformer aux
    attendus de la solution logicielle Vitam.

[^41]: evType est à employer en lieu et place de la balise EventType
    dans un schéma de contrôle pour se conformer aux attendus de la
    solution logicielle Vitam.

[^42]: evDateTime est à employer en lieu et place de la balise
    EventDateTime dans un schéma de contrôle pour se conformer aux
    attendus de la solution logicielle Vitam.

[^43]: evTypeDetail est à employer en lieu et place de la balise
    EventDetail dans un schéma de contrôle pour se conformer aux
    attendus de la solution logicielle Vitam.

[^44]: outcome est à employer en lieu et place de la balise Outcome dans
    un schéma de contrôle pour se conformer aux attendus de la solution
    logicielle Vitam.

[^45]: outDetail est à employer en lieu et place de la balise
    OutcomeDetail dans un schéma de contrôle pour se conformer aux
    attendus de la solution logicielle Vitam.

[^46]: outMessg est à employer en lieu et place de la balise
    OutcomeDetailMessage dans un schéma de contrôle pour se conformer
    aux attendus de la solution logicielle Vitam.

[^47]: evDetData est à employer en lieu et place de la balise
    EventDetailData dans un schéma de contrôle pour se conformer aux
    attendus de la solution logicielle Vitam.
