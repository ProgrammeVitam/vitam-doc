Le gel d’archives avec la solution logicielle Vitam
===================================================

Résumé
------

Jusqu’à présent, pour la gestion, la conservation, la préservation et la
consultation des archives numériques, les acteurs du secteur public
étatique ont utilisé des techniques d’archivage classiques, adaptées aux
volumes limités dont la prise en charge leur était proposée. Cette
situation évolue désormais rapidement et les acteurs du secteur public
étatique doivent se mettre en capacité de traiter les volumes croissants
d’archives numériques qui doivent être archivés, grâce à un saut
technologique.

### Présentation du document

Le gel d’archives fait partie des processus archivistiques mis en œuvre
dans la solution logicielle Vitam.

Dans un contexte d’archivage électronique, cette fonctionnalité est mise
en œuvre en tenant compte des particularités liées au calcul et à
l’héritage des règles et au graphe, tout en ayant ses propres
spécificités.

Ce document s’articule autour des axes suivants :

-   calcul des règles et détermination d’une règle de gel pour un lot
    d’unités archivistiques,
-   modalités du gel d’un lot d’archives,
-   modalités de dégel d’archives.

Le présent document décrit les fonctionnalités qui sont offertes par la
solution logicielle Vitam au terme de la Version 5.RC (septembre 2021).
Il a vocation à être amendé, complété et enrichi au fur et à mesure de
la réalisation de la solution logicielle Vitam et des retours et
commentaires formulés par les ministères porteurs et les partenaires du
programme.


Definitions
-----------


Le gel d’archives consiste en une opération visant à interdire
l’élimination d’archives, quand bien même celles-ci seraient
éliminables.

Il peut intervenir à plusieurs occasions :

-   procédures judiciaires,
-   enquêtes (policières, parlementaires, etc.)
-   perquisitions,
-   audits de type divers (financiers, comptables, etc.).

Des pièces de dossiers sont alors gelées, sur demande, le temps de la
procédure. Le gel permet ainsi d’éviter toute élimination malencontreuse
d’archives.

Les archives gelées peuvent être en outre soumises à des droits
particuliers :

-   interdiction d’être modifiées ou réorganisées,
-   interdiction d’être transférées vers un autre système d’archivage
    électronique,
-   restrictions de consultation.

Les règles consistant à procéder au gel ou au dégel d’archives sont
définies dans les normes suivantes :

-   Modular Requirements for Records Systems 2010 (MoReq2010) : recueil
    d’exigences pour l'organisation de l'archivage numérique, élaboré
    dans le cadre de l’Union européenne ;
-   NF Z 42‑013  : Archivage électronique, recommandations et exigences.

La procédure s’effectue en deux temps :

-   un gel des archives, suite à une demande émanant d’un service
    producteur dans le cadre d’un contexte particulier ;
-   après clôture de la procédure, dégel des archives, visant à les
    gérer à nouveau selon leur cycle de vie initial.

Détermination de la règle de gel et de son application sur une unité archivistique avec la solution logicielle Vitam
--------------------------------------------------------------------------------------------------------------------

### Le gel dans le référentiel des règles de gestion

La solution logicielle Vitam implémente une règle spécifique dans le
référentiel des règles de gestion pour traiter le gel d’archives. Cette
règle propre au gel est de type « HoldRule ».

Elle peut être définie de deux manières :

-   avec une durée et une mesure, comme les autres règles de gestion
    gérées dans ce référentiel ;
-   sans durée ni mesure, si on n’est pas en mesure de les qualifier.

Exemple:
``` La première règle de gel définit une durée et une mesure, contrairement à la deuxième règle de gel.```
  
### Formalisation du gel dans le Standard d’échanges de données pour l’archivage (SEDA)

La règle de gel a été intégrée par la solution logicielle Vitam en
**extension** à la norme NF Z 44‑022, intitulée « Modèle d’Échange de
DONnées pour l’Archivage » ou MEDONA, et sa déclinaison pour les acteurs
du service public, le Standard d’Échanges de Données pour l’Archivage
(SEDA), qui ne définissent pas actuellement ce type d’information.

Cette extension fonctionne néanmoins comme une règle de gestion. Et la
solution logicielle Vitam offre la possibilité, pour une unité
archivistique donnée, de :

-   déclarer la ou les règles qui s’appliquent à elle et aux unités
    archivistiques qui dépendent d’elles (ses « filles ») ;
-   hériter de la ou des règles de gestions déclarées par les unités
    archivistiques dont elle dépend (ses « parentes »).

Si elles sont déclarées, les règles de gel peuvent être décrites, au
moment de la demande de transfert à un service d’archives (message
*ArchiveTransfer*, bloc *DataObjectPackage*) :

-   dans le bloc **ManagementMetadata** pour toute une entrée ;


-   dans le sous-bloc **Management de chaque unité archivistique** pour
    une unité archivistique ou un ensemble d’unités archivistiques
    décrites dans le bloc *DescriptiveMetadata*.

Le schéma ci-après, issu de la documentation publiée par le Service
interministériel des archives de France (SIAF), illustre ces différentes
possibilités.

![](./medias/Pictures/1000000000000556000003002C2276E3B31C73E3.png){width="16.351cm"
height="9.855cm"}

Le bloc *ManagementMetadata* et le sous-bloc Management des unités
archivistiques dispose d’un sous-bloc correspondant à la règle de gel
(HoldRule)[^1], dans lequel il est possible de préciser :

-   la ou les règles applicables, décrites par :

    -   l’**identifiant** de la règle applicable (RuleId –
        obligatoire) ;
    -   la** date de départ, **à partir de laquelle la règle s’applique
        (StartDate – facultatif) ;

-   des **attributs** spécifiques à une règle de gel :

    -   la date de fin du gel (HoldEndDate – facultatif),
    -   l’émetteur du gel (HoldOwner – facultatif),
    -   la raison du gel (HoldReason – facultatif),
    -   la date de réévaluation du gel (HoldReassessingDate –
        facultatif),
    -   le blocage du reclassement de l’archives gelée
        (PreventRearrangement – facultatif) ;

-   des métadonnées de gestion d’héritage, avec indication des **règles
    héritées** des unités archivistiques parentes** qui ne doivent pas
    s’appliquer **à l’unité archivistique concernée et à ses unités
    archivistiques filles.

    Ce blocage de règle peut être :

    -   global (blocage de toutes les règles héritées dans une catégorie
        via l’élément PreventInheritance – facultatif) ;
    -   ou partiel (blocage d’une ou plusieurs règles de la catégorie
        concernée via l’élément RefNonRuleId – facultatif).

**Nota bene** :

-   il est possible pour une unité archivistique, dans une même
    catégorie de règle, de déclarer plusieurs règles. Cette possibilité
    pour le gel (HoldRule), une même unité archivistique pouvant être
    gelée pour des motifs différents ou par des entités différentes ;
-   le schéma correspondant à la règle de gel, extension du SEDA, est
    également spécifique et plus riche en termes d’informations par
    rapport aux autres règles de gestion ;
-   Les attributs sont propres à chaque règle de gel.

  Exemple de modélisation d’une règle de gel en XML :
```xml
<HoldRule>
      <Rule>HOLD-00001</RuleId>
      <StartDate>2020-06-18</StartDate>
      <HoldOwner>Maître Dupont</HoldOwner>   
      <HoldReassessingDate>2055-01-01</HoldReassessingDate>
      <PreventRearrangement>true</NonUpdatable>
</HoldRule>
```

Un exemple de bordereau exploitant les différents cas de figures
utilisables pour l’expression des règles de gestion et conforme au SEDA
2.1. est fourni en annexe.

### Formalisation du gel dans la solution logicielle Vitam

Enregistrement générique

Les règles de gel déclarées dans une unité archivistique sont
enregistrées, au même titre que les métadonnées décrivant cette unité,
dans la collection « Unit », sous la forme d’enregistrements au format
JSON.

Elles sont enregistrées dans un enregistrement correspondant aux
métadonnées d’une unité archivistique en fonction de la manière dont
elles sont déclarées dans le bordereau de transfert :

-   elles sont déclarées dans le bloc Management de l’unité en
    question ;
-   l’unité archivistique correspond à une unité archivistique racine
    et, de fait, enregistre les règles de gestion déclarées dans le bloc
    ManagementMetadata du bordereau de transfert.

Dans les autres cas, l’unité archivistique ne contiendra pas de règles
enregistrées en base. Elles seront calculées automatiquement par la
solution logicielle Vitam.

Exemple d’enregistrement de règles de gel pour une unité archivistique :
```json
"_mgt": {
        "HoldRule": {
            "Rules": [
                {
                    "Rule": "HOL-00002",
                    "StartDate": "2000-01-01",
                    "HoldEndDate": "2010-01-01",
                    "HoldOwner": "Juge Dupont",
                    "HoldReason": "Gel du dossier dans le cadre de la procédure XYZ",
                    "HoldReassessingDate": "2005-01-01",
                    "PreventRearrangement": false,
                    "EndDate": "2010-01-01"
                },
                {
                    "Rule": "HOL-00003",
                    "StartDate": "2000-01-01",
                    "HoldOwner": "M. Tartempion",
                    "HoldReason": "Gel du dossier dans le cadre de l’enquête parlementaire ABC",
                    "HoldReassessingDate": "2005-01-01",
                    "PreventRearrangement": true,
                    "EndDate": "2010-01-01"
                }
            ]
        }
    }
```

Le gel est l’une des catégories de règle qui peut figurer parmi
l’ensemble de ***règles pour une unité archivistique***, héritant
des règles présentes dans le bloc ManagementMetadata et/ou dans le
sous-bloc Management (_mgt – obligatoire, mais pouvant être
vide)[^2]. Il est défini dans un sous-bloc dédié (HoldRule –
facultatif).

Cette catégorie peut contenir :

-   **une à plusieurs règles** particulières, énumérées dans un
    tableau (Rules – facultatif).

    Chacune des règles de ce tableau est elle-même composée de plusieurs
    informations :

    -   l’**identifiant de la règle**, correspondant à l’identifiant
        d’une des règles définies dans le référentiel des règles de
        gestion (Rule – obligatoire) ;
    -   la **date de début du calcul de l’échéance**
        (StartDate – facultatif) ;


-   -   la **date de fin d’application de la règle**
        (EndDate – facultatif). Cette valeur est issue
        d’un calcul réalisé par la solution logicielle Vitam. Celui-ci
        consiste en l’ajout du délai correspondant à la règle dans la
        collection FileRules à la valeur du champ startDate (EndDate =
        StartDate + Durée)[^3] ;

-   des données spécifiques :

    -   la **date de fin de gel**, pour les règles de gel ne déclarant
        pas de durée générique (HoldEndDate –
        facultatif),
    -   le **propriétaire** de la règle de gel
        (Hold Owner – facultatif);
    -   la **raison** de la règle de gel
        (HoldReason – facultatif);
    -   la date de réévaluation de la règle de gel
        (Hold ReassessingDate – facultatif),
    -   **blocage du reclassement** de l’archives gelée
        (PreventRearrangement – obligatoire), dont
        la valeur par défaut est « false »;

-   des **paramètres de gestion d’héritage de règles**
    (Inheritance[^4] – facultatif), pouvant contenir les
    deux éléments suivants :

    -   booléen permettant de **bloquer l’héritage de toutes les
        règles** de gel de la même catégorie (PreventInheritance –
        obligatoire),
    -   **règles de gel qui ne doivent pas être héritées** d’un parent,
        correspondant au champ « RefNonRuleId » du SEDA
        (PreventRulesId – obligatoire, mais pouvant être
        vide).

Enregistrement paramétrable

La solution logicielle Vitam enregistre également en base à la demande
pour chaque unité archivistique les règles de gel applicables et les
échéances de ces règles, que les règles soient déclarées par l’unité
archivistique ou héritées d’unités archivistiques parentes.

***Par défaut***, est enregistrée la catégorie liée au gel (HoldRule)
parmi l’**ensemble de catégories de règle indexées par
défaut **pour une unité archivistique
(computedInheritedRule – facultatif)

Elle peut contenir :

-   la **date d’échéance la plus lointaine** pour la catégorie de
    règle (MaxEndDate – facultatif)


-   des données spécifiques à la catégorie « HoldRule » uniquement :

    -   la **date de fin de gel**, pour les règles de gel ne déclarant
        pas de durée générique (HoldEndDate –
        facultatif),
    -   le **propriétaire** de la règle de gel
        (Hold Owner – facultatif),
    -   la **raison** de la règle de gel
        (HoldReason – facultatif) ;
    -   la date de réévaluation de la règle de gel
        (Hold ReassessingDate – facultatif),
    -   **blocage du reclassement** de l’archives gelée
        (PreventRearrangement – facultatif).


Exemple d’enregistrement par défaut des catégories de règle de gestion :

```json
"_computedInheritedRules": {

 "StorageRule": {

 "FinalAction": [

 "Copy"

 ]

 },

 "AppraisalRule": {

 "MaxEndDate": "2007-01-01",

 "FinalAction": [

 "Keep"

 ]

 },

 "DisseminationRule": {},

 "AccessRule": {

 "MaxEndDate": "2027-01-01"

 },

 "ReuseRule": {

 "MaxEndDate": "2047-01-01"

 },

 "ClassificationRule": {

 "MaxEndDate": "2025-06-03",

 "ClassificationAudience": [

 "Spécial France"

 ],

 "ClassificationLevel": [

 "Secret Défense"

 ],

 "ClassificationOwner": [

 "Emetteur0"

 ],

 "ClassificationReassessingDate": [

 "2016-06-03"

 ],

 "NeedReassessingAuthorization": [

 true,

 true

 ]

 },

 "HoldRule": {

 "MaxEndDate": "2010-01-01"

 },

 "indexationDate": "2019-07-17"

 }
```

**Pour une configuration indexant en plus, pour chaque règle, les
dates d’échéance maximales **(indexInheritedRulesWithRulesIdByTenant),
est enregistrée la catégorie liée au gel (HoldRule) parmi l’ensemble
de **catégories de règle indexées pour une unité
archivistique** (computedInheritedRule –
facultatif).

Cette catégorie peut contenir :

-   la **date d’échéance la plus lointaine** pour la catégorie de
    règle (MaxEndDate – facultatif)
-   la **date d’échéance la plus lointaine** par règle de
    gestion (EndDates – facultatif).

    Ce champ contient **une à plusieurs règles de gel**,
    caractérisée(s) par son(leur) identifiant et ayant pour
    valeur associée la date de fin de validité la plus longue.


-   des données spécifiques à la règle de gel :

    -   la **date de fin de gel**, pour les règles de gel ne déclarant
        pas de durée générique (HoldEndDate –
        facultatif),
    -   le **propriétaire** de la règle de gel
        (Hold Owner – facultatif);
    -   la **raison** de la règle de gel
        (HoldReason – facultatif);
    -   la date de réévaluation de la règle de gel
        (Hold ReassessingDate – facultatif),
    -   **blocage du reclassement** de l’archives gelée
        (****PreventRearrangement**** – facultatif).****


Exemple d’enregistrement par défaut des catégories de règle de gestion :

```json
"_computedInheritedRules": {
        "StorageRule": {
            "FinalAction": [
                "Copy"
            ]
        },
        "AppraisalRule": {
            "MaxEndDate": "2007-01-01",
           "EndDates": {
                "APP-00001": "2007-01-01"
            }
            "FinalAction": [
                "Keep"
            ]
        },
        "DisseminationRule": {},
        "AccessRule": {
            "MaxEndDate": "2027-01-01",
            "EndDates": {
                "DIS-00001": "2025-01-01"
            }
        },
        "ReuseRule": {
            "MaxEndDate": "2047-01-01",
            "EndDates": {
                "REU-00001": "2023-01-01",
                "REU-00004": "2040-01-01"
            }
        },
        "HoldRule": {
            "MaxEndDate": "2010-01-01",
            "EndDates": {
                "HOL-00002": "2010-01-01"
            }
        },
        "indexationDate": "2019-07-17"
    }
```

**Pour une configuration indexant toutes les catégories de
règle, ainsi que leur contexte**
(indexInheritedRulesWithAPIV2OutputByTenant), sont enregistrés les
éléments suivants :

-   ensemble de **catégories de règle indexées pour
    une unité archivistique, incluant leur contexte**
    (inheritedRulesAPIOutput – facultatif).

    Il peut contenir les éléments suivants :

    -   des propriétés génériques (Global Properties –
        facultatif).

        Chacune d’elle est modélisée comme suit :

        -   **identifiant unique de l’unité archivistique**, généré
            par la solution logicielle Vitam (UnitId –
            obligatoire),
        -   **identifiant du service producteur**, correspondant au
            champ « Identifier » du référentiel des services agents
            (OriginatingAgency – obligatoire),
        -   **identifiant de l’(des) unité(s) archivistique(s)** d’où
            provient la propriété (Paths – obligatoire),
        -   **nom de la propriété** décrite (PropertyName –
            obligatoire, mais pouvant être vide),
        -   **valeur de la propriété** décrite, pouvant varier en
            fonction de la propriété décrite (PropertyValue
            – obligatoire, mais pouvant être vide);

    -   la règle de gel (HoldRule), parmi une liste de catégories de
        règles de gestion appliquées à cette unité archivistique
        (facultatif).

Cette catégorie peut contenir :

-   une à plusieurs règles de gel (Rules –
    obligatoire, mais pouvant être vide).

    ****Chacune d’elle est modélisée comme suit :****

    -   -   **identifiant unique de l’unité archivistique**, généré
            par la solution logicielle Vitam (UnitId –
            obligatoire),
        -   **identifiant du service producteur**, correspondant au
            champ « Identifier » du référentiel des services agents
            (OriginatingAgency – obligatoire),
        -   **identifiant de l’(des) unité(s) archivistique(s)** d’où
            provient la règle de gestion (Paths –
            obligatoire),
        -   **identifiant de la règle**, correspondant au champ
            « RuleId » du référentiel des règles de gestion****
            (Rule – obligatoire, mais pouvant être
            vide),
        -   **date de début** du calcul de l’échéance (StartDate –
            facultatif),
        -   **date de fin** d’application de la règle (EndDate –
            facultatif) ;

-   des propriétés propres à la règle décrite (Properties –
    obligatoire, mais pouvant être vide).

    Chacune d’elle est modélisée comme suit :

    -   -   **identifiant unique de l’unité archivistique**, généré
            par la solution logicielle Vitam (UnitId –
            obligatoire),
        -   **identifiant du service producteur**, correspondant au
            champ « Identifier » du référentiel des services agents
            (OriginatingAgency – obligatoire),
        -   **identifiant de l’(des) unité(s) archivistique(s)** d’où
            provient la propriété (Paths – obligatoire),
        -   **nom de la propriété** décrite (PropertyName –
            obligatoire, mais pouvant être vide),
        -   **valeur de la propriété** décrite, pouvant varier en
            fonction de la propriété décrite (PropertyValue
            – obligatoire, mais pouvant être vide).

    Ces propriétés sont spécifiques à la catégorie « HoldRule »
    uniquement :


-   -   -   la **date de fin de gel**, pour les règles de gel ne
            déclarant pas de durée générique (HoldEndDate –
            facultatif),
        -   le **propriétaire** de la règle de gel
            (HoldOwner – facultatif) ;
        -   la **raison** de la règle de gel
            (HoldReason – facultatif) ;
        -   la date de réévaluation de la règle de gel
            (HoldReassessingDate – facultatif),
        -   **blocage du reclassement** de l’archives gelée
            (PreventRearrangement – facultatif).

Exemple d’enregistrement par défaut des catégories de règle de gestion :

```json
"inheritedRulesAPIOutput": {
            "GlobalProperties": [
                {
                    "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qvziaaabq",
                    "OriginatingAgency": "RATP",
                    "Paths": [
                        [
                            "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                            "aeaqaaaaaehi7u6oabuokalqki5qvzyaaaba",
                            "aeaqaaaaaehi7u6oabuokalqki5qvziaaabq"
                        ]
                    ],
                    "PropertyName": "NeedAuthorization",
                    "PropertyValue": "true"
                }
            ],
            "StorageRule": {
                "Rules": [],
                "Properties": [
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq"
                            ]
                        ],
                        "PropertyName": "FinalAction",
                        "PropertyValue": "Copy"
                    }
                ]
            },
            "AppraisalRule": {
                "Rules": [],
                "Properties": [
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qv2aaaada",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                                "aeaqaaaaaehi7u6oabuokalqki5qv2iaaabq",
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaeq",
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaada"
                            ]
                        ],
                        "PropertyName": "FinalAction",
                        "PropertyValue": "Keep"
                    },
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qvyaaaaba",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                                "aeaqaaaaaehi7u6oabuokalqki5qvzyaaaba",
                                "aeaqaaaaaehi7u6oabuokalqki5qvziaaabq",
                                "aeaqaaaaaehi7u6oabuokalqki5qvyaaaaba"
                            ]
                        ],
                        "PropertyName": "FinalAction",
                        "PropertyValue": "Keep"
                    }
                ]
            },
            "DisseminationRule": {
                "Rules": [],
                "Properties": []
            },
            "ReuseRule": {
                "Rules": [
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qvzyaaaba",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                                "aeaqaaaaaehi7u6oabuokalqki5qvzyaaaba"
                            ]
                        ],
                        "Rule": "REU-00001",
                        "StartDate": "2000-01-01",
                        "EndDate": "2010-01-01"
                    }
                ],
                "Properties": []
            },
            "ClassificationRule": {
                "Rules": [],
                "Properties": []
            },
            "AccessRule": {
                "Rules": [
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qvyaaaaba",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                                "aeaqaaaaaehi7u6oabuokalqki5qvzyaaaba",
                                "aeaqaaaaaehi7u6oabuokalqki5qvziaaabq",
                                "aeaqaaaaaehi7u6oabuokalqki5qvyaaaaba"
                            ]
                        ],
                        "Rule": "ACC-00002",
                        "StartDate": "2000-01-01",
                        "EndDate": "2025-01-01"
                    },
                    {
                        "UnitId": "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaeq",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaaq",
                                "aeaqaaaaaehi7u6oabuokalqki5qv2iaaabq",
                                "aeaqaaaaaehi7u6oabuokalqki5qv2aaaaeq"
                            ]
                        ],
                        "Rule": "ACC-00002",
                        "StartDate": "2002-01-01",
                        "EndDate": "2027-01-01"
                    }
                ],
                "Properties": []
            }
        },
        "HoldRule": {
                "Rules": [
                    {
                        "UnitId": "aeaqaaaaaehkzzw7ab6psalz6x2weqqaaaca",
                        "OriginatingAgency": "RATP",
                        "Paths": [
                            [
                                "aeaqaaaaaehkzzw7ab6psalz6x2weqqaaaca"
                            ]
                        ],
                        "Rule": "HOL-00002",
                        "StartDate": "2000-01-01",
                        "PreventRearrangement": false,
                        "HoldEndDate": "2010-01-01",
                        "HoldOwner": "Owner",
                        "HoldReassessingDate": "2005-01-01",
                        "EndDate": "2010-01-01",
                        "HoldReason": "Reason"
                    }
                ],
                "Properties": []
            },
        "indexationDate": "2020-02-17",
        "NeedAuthorization": [
            true
        ]
    }
```

## Mécanismes mis en œuvre dans la solution logicielle Vitam

La solution logicielle Vitam offre à un service d’archives plusieurs
fonctionnalités lui permettant de gérer les règles de gel associées aux
archives :

-   la **configuration** des règles de gel au niveau de la plate-forme ;
-   l’**administration des règles de gel dans le référentiel **de règles
    de gestion ;
-   en entrée du système, le **calcul des échéances** associées aux
    unités archivistiques gelées et **l’indexation des métadonnées**
    liées au gel et associées à ces unités archivistiques ;
-   en gestion des archives existantes :

    -   le **gel d’archives, visant à interdire leur élimination et, le
        cas échéant, leur reclassement,** et l’indexation des règles de
        gel et échéances héritées par les unités archivistiques ;
    -   le **dégel** d’archives ;
    -   à la demande, le calcul des échéances applicables aux unités
        archivistiques gelées et l’**indexation** du résultat dans un
        champ spécifique permettant des recherches et des filtres sur
        les résultats ;

-   en accès, le **calcul des échéances** pour toutes les unités
    archivistiques conservées dans le système, ainsi qu’un **filtre sur
    les catégories de règles échues** au moyen d’un contrat d’accès.

Les fonctionnalités ont été conçues et réalisées pour prendre en compte
toutes les situations susceptibles d’être rencontrées par les services
d’archives[^5], notamment en termes de structuration des archives prises
en charge, avec la possibilité d’avoir :

-   **0 à n unités archivistiques **à la racine du bloc
    DescriptionMetadata du message de transfert d’archives
    (ArchiveTransfer)** **;
-   **0 à n parents **pour une unité archivistique ;
-   **0 à n enfants **pour une unité archivistique.

Le présent document détaille uniquement les mécanismes permettant de
**geler et dégeler** une archives. Les autres fonctionnalités sont
décrites dans la documentation *Règles de gestion*.

### Réalisation du gel d’archives

Le gel d’archives s’effectue au moyen d’une opération de mise à jour en
masse effectuée sur un lot d’archives préalablement sélectionnées. Il a
pour impact d’interdire l’élimination des archives gelées et, de manière
optionnelle, de bloquer leur reclassement.

#### Action de gel

La solution logicielle permet de geler un lot d’archives au moyen des
API. Plusieurs critères de constitution d’un lot d’archives à geler sont
utilisables : identifiant d’une opération d’entrée, unité(s)
archivistique(s) précise(s), ensemble des unités archivistiques
dépendant d’une unité archivistique précise, etc.

Point d’attention :

-   La sélection est réalisée en fonction des droits octroyés par le
    contrat d’accès utilisé.
-   La solution logicielle Vitam ne contrôle pas si le lot contient des
    archives éliminables ou à conserver.

L’action de gel d’archives s’effectue au moyen de l’opération de mise à
jour en masse des règles de gestion. Elle consiste en l’ajout d’une à
plusieurs règles de gel sur le lot d’archives sélectionnées :

-   Si on ajoute une règle de gel définie dans le référentiel sans durée
    ni mesure, l’unité archivistique contiendra une règle de gel sans
    date de fin calculée par la solution logicielle Vitam ;
-   Si on ajoute une règle de gel définie dans le référentiel avec durée
    et mesure, en plus d’une date de début, la solution logicielle Vitam
    calculera automatiquement la date de dégel des archives.

Il est également possible d’ajouter des informations liées à l’émetteur
et à la raison du gel du lot d’archives, une date de révision de la
règle, mais aussi de bloquer tout reclassement du lot d’archives.

***Point d’attention :*** Il n’est pas possible d’ajouter une règle de
gel au moyen d’une opération de mise à jour unitaire de règle de
gestion. Ce service fourni par la solution logicielle Vitam est en cours
de dépréciation.

L’opération est journalisée dans le journal des opérations. Son statut à
l’issue de la mise en œuvre du gel pourra être :

-   succès : toutes les unités archivistiques soumises ont été gelées ;
-   erreur : les paramètres de la requête d’ajout d’une règle de gel
    sont incohérents par rapport au référentiel des règles de gestion,
    par exemple : ils contiennent une date de fin (HoldEndDate) alors
    que la règle de gel déclarée dans le référentiel déclare une durée
    et une mesure ;
-   fatal : une erreur technique s’est produite lors du processus de
    mise en œuvre de l’opération de gel.

Elle donne lieu à un enregistrement dans le journal du cycle de vie de
l’(des) unité(s) archivistique(s) ayant fait l’objet d’un gel.

**Point d’attention :** L’information n’est enregistrée que dans le
journal du cycle de vie de l’(des) unité(s) archivistique(s) racine(s).

#### Impacts du gel sur les traitements de masse

**Impact sur le processus d’élimination**

Une archives gelée ou héritant d’une règle de gel** ne peut pas être
éliminée** du système si la date de fin calculée de gel ou la date de
fin renseignée (HoldEndDate) n’est pas arrivée à échéance.

Il est néanmoins possible d’intégrer une archives gelée dans :

-   le processus d’**analyse** d’élimination. Le résultat de cette
    analyse, indexé dans les métadonnées des unités archivistiques,
    indiquera un conflit en raison du caractère gelé de l’archives
    (statut CONFLICT, BLOCKED\_BY\_HOLD\_RULE) :

```json
 "_elimination": [
        {
            "OperationId": "aeeaaaaaa2hfba5wabzviallw7xjlsqaaaaq",
            "GlobalStatus": "CONFLICT",
            "DestroyableOriginatingAgencies": [],
            "NonDestroyableOriginatingAgencies": [],
            "ExtendedInfo": [
                {
                    "ExtendedInfoType": "BLOCKED_BY_HOLD_RULE",
                    "ExtendedInfoDetails": {
                        "HoldRuleIds": [
                            "HOL-00001"
                        ]
```

-   le processus d’**élimination**. L’opération sera alors en
    avertissement et signalera le statut de l’unité archivistique gelée
    comme ne pouvant être déterminé (Global Status : CONFLICT), même si
    sa durée d’utilité administrative est arrivée à échéance et son sort
    final est égal à « Destroy »[^6].

***Impact sur le processus de réorganisation d’arborescence***

La solution logicielle Vitam permet de bloquer tout reclassement
d’archives gelées ou héritant d’une règle de gel de manière
**optionnelle**. Par défaut, ce blocage n’est pas activé.

Ce blocage est rendu possible par l’ajout, lors de l’opération de gel
d’archives, d’un paramètre l’activant. La requête doit en effet contenir
en plus de la règle de gel le blocage du reclassement avec pour valeur
« true » (PreventRearrangement).

Lors d’une réorganisation d’arborescence d’au moins une archives gelée
contenant un blocage de reclassement actif, l’opération sera en échec à
la tâche de contrôle du blocage de reclassification des unités
archivistiques par des règles de gel.

La réorganisation d’arborescence reste possible dans les cas suivants :

-   l’archives gelée ne dispose pas d’un blocage de reclassement actif.
    Le paramètre a pour valeur « false » ;
-   l’archives gelée, pouvant disposer d’un blocage actif, a une date de
    fin, calculée ou renseignée, arrivée à échéance.

***Point d’attention :***: il est recommandé d’activer le blocage de tout reclassement d’archives gelées.
En effet, activé, ce paramètre permet d’éviter de dégeler des archives héritant d’une règle de gel à la suite d’une réorganisation d’arborescence. 

### Réalisation du dégel d’archives

La solution logicielle Vitam permet de dégeler des archives de plusieurs
manières. Cette action permet de rétablir le cycle de vie attendu des
archives.

#### Action de dégel

***Dégel manuel***

Que la règle de gel contienne une date de fin calculée ou renseignée
manuellement, la solution logicielle Vitam permet de dégeler un lot
d’archives gelées au moyen des API, que ces archives déclarent ou
héritent d’une règle avec date de fin calculée ou renseignée
manuellement, que la règle soit arrivée à échéance ou non. Plusieurs
critères de constitution d’un lot d’archives à dégeler sont
utilisables : unité(s) archivistique(s) contenant ou héritant d’une
règle de gel, unité(s) archivistique(s) contenant ou héritant d’une
règle de gel arrivée à échéance, date de réévaluation du caractère gelé
d’unité(s) archivistique(s), etc.

***Point d’attention :*** La sélection est réalisée en fonction des
droits octroyés par le contrat d’accès utilisé.

L’action de dégel d’archives s’effectue au moyen de l’opération de mise
à jour en masse des règles de gestion. Elle consiste en la suppression
d’une à plusieurs règles de gel sur le lot d’archives sélectionnées.

***Point d’attention :*** Il n’est pas possible de supprimer une règle
de gel au moyen d’une opération de mise à jour unitaire de règle de
gestion. Ce service fourni par la solution logicielle Vitam est en cours
de dépréciation.

L’opération est journalisée dans le journal des opérations.

Elle donne lieu à un enregistrement dans le journal du cycle de vie de
l’(des) unité(s) archivistique(s) ayant fait l’objet d’un gel.

***Point d’attention :*** L’information n’est enregistrée que dans le
journal du cycle de vie de l’(des) unité(s) archivistique(s) racine(s).

***Dégel automatisé***

La solution logicielle Vitam rend possible le dégel automatique
d’archives dans deux cas :

-   quand l’archives gelée contient une date de fin calculée par le
    système, l’archives portant ou héritant de la règle est
    automatiquement dégelée lorsque la date de fin est arrivée à
    échéance ;
-   quand l’archives gelée ne contient pas de date de fin calculée, il
    est possible d’associer au moment de l’ajout de la règle de gel ou a
    posteriori une date de fin de gel (HoldEndDate). Cette archives est
    automatiquement dégelée dès que cette date de fin renseignée
    manuellement est arrivée à échéance.

Aucune opération n’est alors réalisée, ni journalisée.

***Point d’attention :*** il est recommandé d’utiliser cette option de
dégel, si on souhaite pouvoir conserver traces dans les métadonnées des
unités archivistiques que certaines ont été gelées durant une certaine
période.

#### Impacts du dégel sur les traitements de masse

Une archives dégelée à la suite d’une suppression de sa règle de gel ou
en raison de sa date de fin arrivée à échéance peut à nouveau faire
l’objet de traitements de masse :

-   elle peut être analysée, puis éliminée, si aucun autre conflit n’est
    détecté et si sa durée d’utilité administrative est arrivée à
    échéance et si son sort final est égal à « Destroy » ;
-   elle peut être déplacée dans les arborescences sans aucun blocage.

Elle poursuit à nouveau son cycle de vie.

Conseils de mise en œuvre
-------------------------


À l’issue de la réalisation de fonctionnalités concernant les règles de
gel associées aux unités archivistiques, l’équipe projet Vitam est en
mesure de fournir quelques recommandations de mise en œuvre[^7].

### Comment intégrer des règles de gel dans le référentiel des règles de gestion ?

Il est obligatoire de déclarer des règles de gel dans le référentiel des
règles de gestion pour pouvoir geler des archives.

Le référentiel peut être alimenté :

-   d’une manière très générique, en se focalisant uniquement sur les
    durées associées aux règles. À titre d’exemple, il est possible de
    déclarer des règles correspondant à des durées d’1 an, de 2 ans, de
    3 ans, etc. Dans ce cas, la règle pourra être utilisée pour
    différentes catégories de dossiers gelés ;
-   d’une manière plus spécifique, en se focalisant sur les spécificités
    de chaque catégorie de dossier gelé. À titre d’exemple, on pourra
    distinguer la règle applicable à des scellés judiciaires de la règle
    applicable lors d’audits comptables et/ou financiers.

La première solution présente l’avantage de limiter le
nombre de règles à administrer ; la seconde, de permettre d’effectuer
des mises à jour de règles plus ciblées.

Par ailleurs, il est possible de déclarer des règles de gel :

-   avec durée et mesure, comme pour les autres règles de gestion ;
-   sans durée et mesure, si on n’est pas en capacité de préciser ces
    éléments.

### Quand et comment bloquer le reclassement d'archives gelées ?

Il est possible de bloquer le reclassement d’archives portant ou
héritant d’une règle de gel par l’utilisation du paramètre interdisant
la réorganisation d’arborescences des archives gelées
(PreventRearrangement), en lui attribuant une valeur égale à « true ».

Il est fortement recommandé d’utiliser systématiquement ce paramètre et
de l’activer, malgré son caractère facultatif.

S’il n’est pas utilisé (valeur « false » par défaut, autorisant les
reclassements d’archives) ou activé (par la valeur « true »), il est en
effet possible de dégeler des archives héritant d’une règle de gel en
les déplaçant dans une arborescence ne portant pas de règle de gel.

### Comment geler des archives ?

Il est possible de geler des archives par l’ajout d’une règle de gel.
Lors de cette opération d’ajout de métadonnées liées à une règle de gel,
il est :

-   obligatoire de signaler un identifiant de règle de gel,
-   fortement recommandé de :

    -   associer à cet identifiant une date de début,
    -   déclarer un blocage de reclassement (PreventRearrangement avec
        une valeur égale à « true »),

-   conseillé, dans le cas d’une règle ne déclarant ni durée ni mesure,
    d’indiquer une date de réévaluation de la règle de gel.

Annexe 1 : Exemple de message ArchiveTransfer mettant en œuvre les différentes possibilités d’utilisation des règles de gestion
-------------------------------------------------------------------------------------------------------------------------------

**Nota bene** : le cas présenté ci-dessous est un exemple
fictif qui vise simplement à vérifier la bonne mise en œuvre des
mécanismes relatifs aux règles de gel dans la solution logicielle Vitam.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<ArchiveTransfer xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
 xsi:schemaLocation="fr:gouv:culture:archivesdefrance:seda:v2.1 seda-2.1-main.xsd"
 xmlns="fr:gouv:culture:archivesdefrance:seda:v2.1">
    <Comment>Test SIP for HoldRules</Comment>
    <Date>2016-10-12T16:28:40</Date>
    <MessageIdentifier>20161012002</MessageIdentifier>
    <ArchivalAgreement>IC-000001</ArchivalAgreement>
    <CodeListVersions>
        <ReplyCodeListVersion>ReplyCodeListVersion0</ReplyCodeListVersion>
        <MessageDigestAlgorithmCodeListVersion>MessageDigestAlgorithmCodeListVersion0</MessageDigestAlgorithmCodeListVersion>
        <MimeTypeCodeListVersion>MimeTypeCodeListVersion0</MimeTypeCodeListVersion>
        <EncodingCodeListVersion>EncodingCodeListVersion0</EncodingCodeListVersion>
        <FileFormatCodeListVersion>FileFormatCodeListVersion0</FileFormatCodeListVersion>
        <CompressionAlgorithmCodeListVersion>CompressionAlgorithmCodeListVersion0</CompressionAlgorithmCodeListVersion>
        <DataObjectVersionCodeListVersion>DataObjectVersionCodeListVersion0</DataObjectVersionCodeListVersion>
        <StorageRuleCodeListVersion>StorageRuleCodeListVersion0</StorageRuleCodeListVersion>
        <AppraisalRuleCodeListVersion>AppraisalRuleCodeListVersion0</AppraisalRuleCodeListVersion>
        <AccessRuleCodeListVersion>AccessRuleCodeListVersion0</AccessRuleCodeListVersion>
        <DisseminationRuleCodeListVersion>DisseminationRuleCodeListVersion0</DisseminationRuleCodeListVersion>
        <ReuseRuleCodeListVersion>ReuseRuleCodeListVersion0</ReuseRuleCodeListVersion>
        <ClassificationRuleCodeListVersion>ClassificationRuleCodeListVersion0</ClassificationRuleCodeListVersion>
        <AuthorizationReasonCodeListVersion>AuthorizationReasonCodeListVersion0</AuthorizationReasonCodeListVersion>
        <RelationshipCodeListVersion>RelationshipCodeListVersion0</RelationshipCodeListVersion>
    </CodeListVersions>
    <DataObjectPackage>
        <DescriptiveMetadata>
            <ArchiveUnit id="ID01">
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit1</Title>
                    <Description>Unit1 - Sans HoldRules</Description>
                </Content>
                <ArchiveUnit id="ID_REF_1">
                    <ArchiveUnitRefId>ID02</ArchiveUnitRefId>
                </ArchiveUnit>
                <ArchiveUnit id="ID_REF_2">
                    <ArchiveUnitRefId>ID03</ArchiveUnitRefId>
                </ArchiveUnit>
            </ArchiveUnit>
            <ArchiveUnit id="ID02">
                <Management>
                    <AppraisalRule>
                        <Rule>APP-00002</Rule>
                        <StartDate>2000-01-01</StartDate>
                        <FinalAction>Destroy</FinalAction>
                    </AppraisalRule>
                    <HoldRule>
                        <Rule>HOL-00001</Rule>
                        <StartDate>2000-01-01</StartDate>
                        <HoldOwner>Owner de la règle de Gel</HoldOwner>
                        <HoldReassessingDate>2005-01-01</HoldReassessingDate>
                        <HoldReason>Motif du gel</HoldReason>
                        <PreventRearrangement>true</PreventRearrangement>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit2</Title>
                    <Description>Unit2 - Hold rules avec durée définie, et date de début</Description>
                </Content>
                <ArchiveUnit id="ID_REF_3">
                    <ArchiveUnitRefId>ID05</ArchiveUnitRefId>
                </ArchiveUnit>
            </ArchiveUnit>
            <ArchiveUnit id="ID03">
                <Management>
                    <HoldRule>
                        <Rule>HOL-00001</Rule>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit3</Title>
                    <Description>Unit3 - Hold rules avec durée définie, sans date de début</Description>
                </Content>
                <ArchiveUnit id="ID_REF_4">
                    <ArchiveUnitRefId>ID06</ArchiveUnitRefId>
                </ArchiveUnit>
                <ArchiveUnit id="ID_REF_5">
                    <ArchiveUnitRefId>ID07</ArchiveUnitRefId>
                </ArchiveUnit>
            </ArchiveUnit>
            <ArchiveUnit id="ID04">
                <Management>
                    <HoldRule>
                        <Rule>HOL-00002</Rule>
                        <StartDate>2000-01-01</StartDate>
                        <HoldEndDate>2010-01-01</HoldEndDate>
                        <HoldOwner>Owner de la règle de Gel</HoldOwner>
                        <HoldReassessingDate>2005-01-01</HoldReassessingDate>
                        <HoldReason>Motif du gel</HoldReason>
                        <PreventRearrangement>false</PreventRearrangement>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit4</Title>
                    <Description>Unit4 - Hold rules avec durée indéfinie, et durée de fin explicite HoldEndDate</Description>
                </Content>
            </ArchiveUnit>
            <ArchiveUnit id="ID05">
                <Management>
                    <HoldRule>
                        <Rule>HOL-00002</Rule>
                        <StartDate>2000-01-01</StartDate>
                        <HoldOwner>Owner de la règle de Gel</HoldOwner>
                        <HoldReassessingDate>2005-01-01</HoldReassessingDate>
                        <PreventRearrangement>false</PreventRearrangement>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit5</Title>
                    <Description>Unit5 - Hold rules avec durée indéfinie, et sans durée de fin explicite HoldEndDate</Description>
                </Content>
            </ArchiveUnit>
            <ArchiveUnit id="ID06">
                <Management>
                    <HoldRule>
                        <RefNonRuleId>HOL-00001</RefNonRuleId>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit6</Title>
                    <Description>Unit6 - HoldRules avec RefNonRuleId</Description>
                </Content>
            </ArchiveUnit>
            <ArchiveUnit id="ID07">
                <Management>
                    <HoldRule>
                        <PreventInheritance>true</PreventInheritance>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit7</Title>
                    <Description>Unit7 - HoldRules avec PreventInheritence</Description>
                </Content>
            </ArchiveUnit>
            <ArchiveUnit id="ID08">
                <Management>
                    <HoldRule>
                        <Rule>HOL-00001</Rule>
                        <StartDate>2000-01-01</StartDate>
                        <HoldOwner>Owner de la règle de Gel HOL-00001</HoldOwner>
                        <Rule>HOL-00002</Rule>
                        <HoldEndDate>2010-01-01</HoldEndDate>
                        <HoldOwner>Owner de la règle de Gel HOL-00002</HoldOwner>
                        <HoldReassessingDate>2005-01-01</HoldReassessingDate>
                        <PreventRearrangement>false</PreventRearrangement>
                        <Rule>HOL-00003</Rule>
                        <RefNonRuleId>HOL-00004</RefNonRuleId>
                    </HoldRule>
                </Management>
                <Content>
                    <DescriptionLevel>Item</DescriptionLevel>
                    <Title>Unit8</Title>
                    <Description>Unit8 - Multiples HoldRules</Description>
                </Content>
            </ArchiveUnit>
        </DescriptiveMetadata>
        <ManagementMetadata>
            <OriginatingAgencyIdentifier>Vitam</OriginatingAgencyIdentifier>
            <SubmissionAgencyIdentifier>Vitam</SubmissionAgencyIdentifier>
            <HoldRule>
                <Rule>HOL-00003</Rule>
                <StartDate>2000-01-01</StartDate>
                <HoldOwner>Owner de la règle de Gel HOL-00003</HoldOwner>
                <HoldReassessingDate>2005-01-01</HoldReassessingDate>
                <HoldReason>Motif du gel HOL-00003</HoldReason>
                <PreventRearrangement>false</PreventRearrangement>
            </HoldRule>
        </ManagementMetadata>
    </DataObjectPackage>
    <RelatedTransferReference>RelatedTransferReference0</RelatedTransferReference>
    <TransferRequestReplyIdentifier>TransferRequestReplyIdentifier0</TransferRequestReplyIdentifier>
    <ArchivalAgency>
        <Identifier>BBBBBB</Identifier>
    </ArchivalAgency>
    <TransferringAgency>
        <Identifier>FRAN_NP_050758</Identifier>
    </TransferringAgency>
</ArchiveTransfer>
```


Annexe 2 : Exemple de requête pour geler et dégeler des archives
----------------------------------------------------------------

Requête permettant d’ajouter une règle de gel (la règle n’a pas de durée
ni de mesure) :
```json
  {
  
  "dslRequest": {
  
   "$roots": [],
  
   "$query": [ { "$eq": { "#id": "{{unit-id}}" } } ],
  
   "$threshold": 10000
  
  },
  
  "ruleActions": {
  
  "add": [
  
   {
  
   "HoldRule": {
  
   "Rules": [
  
   {
  
   "Rule": "HOL-00001",
  
   "StartDate": "2000-01-01",
  
   "HoldEndDate": "2025-01-01",
  
   "HoldOwner": "Owner",
  
   "HoldReason": "Reason",
  
   "HoldReassessingDate": "2015-01-01",
  
   "PreventRearrangement": true
  
   }
  
   ]
  
   }
  
  }
  
  ],
  
  "update": [],
  
  "delete": []
  
  }
  
  }
```


Requête permettant d’ajouter une règle de gel (la règle a une durée et
une mesure) :

```json
  {
  
  "dslRequest": {
  
   "$roots": [],
  
   "$query": [ { "$eq": { "#id": "{{unit-id}}" } } ],
  
   "$threshold": 10000
  
  },
  
  "ruleActions": {
  
  "add": [
  
   {
  
   "HoldRule": {
  
   "Rules": [
  
   {
  
   "Rule": "HOL-00002",
  
   "StartDate": "2000-01-01",
  
   "HoldOwner": "Owner",
  
   "HoldReason": "Reason",
  
   "HoldReassessingDate": "2015-01-01",
  
   "PreventRearrangement": true
  
   }
  
   ]
  
   }
  
  }
  
  ],
  
  "update": [],
  
  "delete": []
  
  }
  
  }
```

Requête permettant de supprimer une règle de gel :

```json
  {
  
  "dslRequest" {
  
   "$roots" [],
  
   "$query" [ { "$eq": { "#id": "{{unit-id}}" } } ],
  
   "$threshold" 10000
  
  },
  
  "ruleActions" {
  
   "add" [],
  
   "update" [],
  
   "delete" [
  
   {
  
   "HoldRule" {
  
   "Rules" [
  
   {
  
   "Rule" "HOL-00001"
  
   }
  
   ]
  
   }
  
  }
  
  ]
  
  }
  
  }
```

[^1]:  Au terme de la release 16, le gel est implémenté dans la solution
    logicielle Vitam comme une extension du schéma SEDA.

[^2]:  Pour plus d’informations, consulter *Modèle de données*, chapitre
    4.1, « Collection Unit ».

[^3]:  À noter que ce calcul automatique n’est pas effectué pour les
    seules règles de gel ne déclarant pas de durée.

[^4]:  Ce champ n’est pas formalisé dans le SEDA.

[^5]: Pour plus de précisions, consulter la documentation *VITAM.
    Organisation de l’information.*

[^6]:  Pour plus de précisions, consulter la documentation *VITAM. Les
    éliminations avec la solution logicielle Vitam.*

[^7]:  D’autres conseils d’utilisation sont proposés dans la
    documentation *VITAM. Règles de gestion.*
