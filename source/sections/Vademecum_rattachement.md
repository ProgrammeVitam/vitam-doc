Faire un rattachement dans la solution logicielle Vitam
====

Présentation des rattachements
---
### À quoi sert un rattachement ?
Le rattachement est une fonctionnalité offerte par la solution logicielle Vitam qui permet de faire un lien entre deux éléments présents dans le système pour :
- rattacher un plan de classement à un arbre de positionnement,
- compléter un arbre de positionnement ou un plan de classement en y ajoutant une nouvelle branche,
- rattacher un dossier ou une arborescence de dossiers à un nœud d’arbre de positionnement ou de plan de classement,
- compléter un dossier déjà ouvert dans le système en y versant les pièces de ce dossier,
- compléter une unité archivistique en intégrant à son groupe d’objets techniques une nouvelle représentation du document (par exemple, une version basse résolution d’une photographie).


### Quand faire un rattachement ?
La solution Vitam offre plusieurs possibilités de rattachement :
- à l’entrée :
      - le rattachement d’une unité archivistique à une unité archivistique déjà présente dans le système ;
      - le rattachement d’une unité archivistique à un groupe d’objets techniques (GOT) déjà présent dans le système ;
      - le rattachement d’un objet à un GOT déjà présent dans le système ;
- après l’entrée, la réorganisation d’arborescence pour des unités archivistiques présentes dans le système permettant de créer ou de supprimer des liens de parenté.


### Contrôles effectués sur les rattachements demandés
Un rattachement ne peut être effectué qu’entre des unités archivistiques, des groupes d’objets techniques ou des objets techniques présents sur un même tenant de la plate-forme.

Les rattachements doivent respecter les règles définies en fonction de la nature des unités archivistiques :
- une unité archivistique standard peut se rattacher à une unité archivistique standard, une unité archivistique de plan de classement ou une unité archivistique d’arbre de positionnement,
- une unité archivistique de plan de classement peut se rattacher à une unité archivistique de plan de classement ou à une unité archivistique d’arbre de positionnement,
- une unité archivistique d’arbre de positionnement peut se rattacher à une unité archivistique d’arbre de positionnement.
Le rattachement proposé ne doit pas créer de cycle (une unité archivistique ne peut pas devenir la mère de sa mère).
Si ces règles ne sont pas respectées, l’entrée sera rejetée.

La position d’une unité archivistique dans une arborescence et son service producteur constituent deux des filtres utilisés dans le contrat d’accès pour filtrer les accès à l’unité archivistique. Un rattachement qui modifie la position de l’unité archivistique ou lui ajoute un service producteur de rattachement peut donc avoir des conséquences sur l’accès à une unité archivistique.

### Recommandations pour déclarer une unité archivistique de rattachement dans un bordereau de transfert

La création de l’unité archivistique de rattachement se fait une fois le bordereau de transfert constitué. Il est fortement conseillé de choisir une présentation du bordereau en mode râteau (mode « à plat » pour les SIP générés avec la moulinette ReSIP) et non en mode arborescent. Les exemples donnés dans ce document correspondent tous à des bordereaux de transfert présentés en mode râteau.
Les champs obligatoires du SEDA doivent impérativement être présents et complétés (titre et niveau de description).
L’unité archivistique de rattachement ne sera pas créée dans la solution logicielle lors de l’entrée, aussi la valeur indiquée dans ces champs n’a pas d’importance, même si pour des raisons de facilitation de relecture du bordereau de transfert il est préférable d’indiquer les valeurs portées par l’unité archivistique de rattachement dans le système.
Une attention particulière doit être portée au moment d’attribuer à l’unité archivistique ainsi créée un identifiant xml : cet identifiant ne doit pas être déjà attribué à une autre unité archivistique dans le manifeste.

Configuration des rattachements en entrée
---

### Le rattachement à l’entrée des unités archivistiques racines du SIP à une unité archivistique  déjà présente dans le système par contrat d’entrée

*Cas d’usage : un service d’archives a défini un arbre de positionnement ou un plan de classement et souhaite rattacher automatiquement toutes les unités racine des SIP utilisant un même contrat d’entrée à un même nœud de cet arbre ou de ce plan.*

La solution logicielle Vitam offre la possibilité de déclarer au niveau du contrat d’entrée un nœud de rattachement qui s’appliquera à toutes les unités archivistiques racines des SIP qui utilisent ce contrat.
Le rattachement se fait sur la base de l’identifiant (GUID) d’une unité archivistique déjà présente dans le système. Cette unité archivistique peut être de type « arbre de positionnement », « plan de classement » ou « standard ».


### Le rattachement à l’entrée d’unités archivistiques du SIP à des unités archivistiques déjà présentes dans le système par déclaration dans le bordereau de transfert

*Cas d’usage : une application de type GED verse périodiquement les documents produits dans la GED en demandant leur rattachement au plan de classement déjà présent dans le système.*

La solution logicielle Vitam offre la possibilité de déclarer dans le bordereau de transfert une unité archivistique déjà présente dans le système à laquelle rattacher une ou plusieurs unités archivistiques du SIP. L’unité archivistique de rattachement peut être de type « arbre de positionnement », « plan de classement » ou « standard ».
Le rattachement peut se faire soit sur la base de l’identifiant (GUID) de l’unité archivistique de rattachement, soit sur la base de la valeur d’une métadonnée de l’unité archivistique de rattachement (par exemple : *MetadataName*Title*/MetadataName*, *MetadataValue*Titre de mon AU*/MetadataValue*).

Avec la deuxième solution, la balise et la valeur déclarées pour identifier l’unité archivistique de rattachement doivent renvoyer un résultat unique dans la plate-forme. Ainsi, si le rattachement se fait sur la métadonnée *Title* et que plusieurs unités archivistiques ont la même valeur pour le champ Title, le rattachement ne pourra pas être effectué et l’entrée du SIP échouera.
Il est donc recommandé d’utiliser des éléments univoques comme un identifiant (par exemple, les balises *FilePlanPosition*, *OriginatingSystemId*, *ArchivalAgencyArchiveUnitIdentifier*, *OriginatingAgencyArchiveUnitIdentifier*, *TransferringAgencyArchiveUnitIdentifier*).

Dans les deux cas, il convient de :
- créer dans le bordereau une unité archivistique correspondant à l’unité archivistique déjà présente dans le système, renseignée avec les champs obligatoires dans le SEDA (Title, DescriptionLevel). Cette création est indispensable afin de respecter la logique du standard SEDA ;
- insérer dans le sous-bloc *Management* de cette unité archivistique un sous-bloc *UpdateOperation* (extension du schéma SEDA) ;
- déclarer dans la balise *UpdateOperation* de cette unité archivistique les informations permettant son identification dans le système. Cette déclaration peut être faite selon 2 méthodes :
      - méthode 1 : insérer dans le sous-bloc *UpdateOperation* une balise *SystemId* comprenant l’identifiant unique attribué par la solution logicielle Vitam à l’unité archivistique déjà présente dans le système ;
      - méthode 2 : insérer dans le sous-bloc *UpdateOperation* un bloc *ArchiveUnitIdentifierKey* qui comprend lui-même 2 balises : *MetadataName* qui doit correspondre à une balise du bloc Content du schéma SEDA 2.1, et une balise *MetadataValue* qui doit correspondre à la valeur du champ de l’unité archivistique déjà présente dans le système à laquelle on veut rattacher l’unité archivistique du SIP ;
- faire référence aux unités archivistiques du bordereau de transfert à rattacher en utilisant la balise *ArchiveUnitRefId*.

*Exemple pour la méthode 1*
```
<ArchiveUnit id="ID4">
        <Management>
                <UpdateOperation>
                            <SystemId>aeaqaaaaaihnjdarabzvqak3m2b3qoqaaaaq</SystemId>
                </UpdateOperation>
        </Management>
        <Content>
                <DescriptionLevel>RecordGrp</DescriptionLevel>
                <Title xml:lang="fr">Sénat</Title>
        </Content>
        <ArchiveUnit id="ID20">
                <ArchiveUnitRefId>ID3</ArchiveUnitRefId>
        </ArchiveUnit>
</ArchiveUnit>
```

*Exemple pour la méthode 2*
```
<ArchiveUnit id="ID4">
        <Management>
                <UpdateOperation>
                            <ArchiveUnitIdentifierKey>
                                     <MetadataName>Title</MetadataName>
                                     <MetadataValue>デモ</MetadataValue>
                            </ArchiveUnitIdentifierKey>
                </UpdateOperation>
        </Management>
        <Content>
                <DescriptionLevel>RecordGrp</DescriptionLevel>
                <Title>Sénat</Title>
        </Content>
        <ArchiveUnit id="ID9">
                <ArchiveUnitRefId>ID3</ArchiveUnitRefId>
        </ArchiveUnit>
</ArchiveUnit>
```

*Contrôle sur le positionnement des rattachements déclarés dans le bordereau de transfert*  
La solution logicielle Vitam offre la possibilité de déclarer un ou plusieurs nœud(s) dans le contrat d’entrée pour faire des contrôles sur les rattachements déclarés dans les bordereaux de transfert des SIP utilisant ce contrat d’entrée. En ce cas, le système vérifiera à l’entrée que les rattachements déclarés dans le bordereau de transfert correspondent à ce nœud ou sont bien situés dans sa descendance. Si ce n’est pas le cas, l’entrée sera en échec.
Le nœud déclaré peut être de type « arbre de positionnement », « plan de classement » ou « standard ».

Le contrat d’entrée peut être paramétré pour interdire la présence d’un rattachement dans le bordereau de transfert, l’autoriser ou la rendre obligatoire.


### Le rattachement à l’entrée d’une unité archivistique du SIP à un groupe d’objets techniques déjà présent dans le système par déclaration dans le bordereau de transfert

*Cas d’usage : une unité archivistique est représentée par un objet technique (au sein d’un groupe d’objets techniques) déjà présent dans le système. Le service d’archives ne souhaite pas verser une deuxième fois le fichier et veut que l’unité archivistique à verser soit rattachée au groupe d’objets techniques déjà présent dans le système.*

La solution logicielle Vitam offre la possibilité de déclarer dans le bordereau un groupe d’objets techniques déjà présent dans le système auquel se rattachera une unité archivistique.
Afin de rattacher une unité archivistique présente dans le bordereau à un groupe d’objets déjà présent dans la plate-forme utilisant la solution logicielle Vitam, il est obligatoire :
- d’ajouter un sous-bloc *DataObjectGroup* à l’unité archivistique (extension du schéma SEDA) ;
- d’ajouter dans ce bloc un élément *DataObjectGroupExistingReferenceId* ;
- d’insérer dans l’élément *DataObjectGroupExistingReferenceId* une balise *SystemId* comprenant l’identifiant unique attribué par la solution logicielle Vitam au groupe d’objets techniques déjà présent dans la solution logicielle Vitam.

Le rattachement d’une unité archivistique à un groupe d’objets techniques déjà présent dans le système ne nécessite aucune configuration particulière du contrat d’entrée.


### Le rattachement d’un objet technique à un groupe d’objets techniques déjà présent dans le système par déclaration dans le bordereau de transfert (mise à jour d’une unité archivistique)

*Cas d’usage : un nouveau fichier représentant l’unité archivistique a été créé (par exemple, une version basse résolution d’une image fixe pour diffusion ou une vignette) et on souhaite l’ajouter au groupe d’objets techniques existant.*
*Cas d’usage : au moment de l’entrée d’un fonds photographique, seules les versions de diffusion ont pu être collectées. Le service d’archives reçoit par la suite les versions haute définition (masters) et souhaite les ajouter aux groupes d’objets techniques existants.*

La solution logicielle Vitam offre la possibilité de déclarer dans le bordereau l’unité archivistique dont le groupe d’objets techniques doit être mis à jour par l’ajout d’un objet technique.  
Seul le service producteur ayant provoqué la création du groupe d’objets techniques dans la plate-forme utilisant la solution logicielle Vitam a le droit de rajouter des objets à ce groupe d’objets. Le service producteur du SIP doit donc obligatoirement être le même que le service producteur du SIP qui a transféré le groupe d’objets techniques. Le transfert sera sinon rejeté.

L’ajout d’objets à un groupe d’objets existant doit être autorisé par le contrat d’entrée utilisé. Le contrat d’entrée peut bloquer l’ajout d’un objet ou ne l’autoriser que pour certains usages.

Le rattachement se fait en déclarant l’identifiant (GUID) de l’unité archivistique qui déclare le groupe d’objets à compléter.

Pour cela il convient de :
- créer dans le bordereau une unité archivistique correspondant à l’unité archivistique dont le groupe d’objets doit être mis à jour, renseignée avec les champs obligatoires dans le SEDA (Title, DescriptionLevel). Cette création est indispensable afin de respecter la logique du standard SEDA ;
- insérer dans le sous-bloc *Management* de cette unité archivistique un sous-bloc *UpdateOperation* (extension du schéma SEDA) ;
- déclarer dans le sous-bloc *UpdateOperation* les informations permettant l’identification dans le système de l’unité archivistique dont le groupe d’objets techniques est à mettre à jour. Cette déclaration peut être faite selon 2 méthodes :
      - méthode 1 en utilisant le GUID attribué par la solution logicielle Vitam : insérer dans le sous-bloc *UpdateOperation* une balise *SystemId* comprenant l’identifiant unique attribué par la solution logicielle Vitam à l’unité archivistique déjà présente dans le système ;
      - méthode 2 en utilisant d’autres éléments de description de l’unité archivistique : insérer dans le sous-bloc *UpdateOperation* un bloc *ArchiveUnitIdentifierKey* qui comprend lui-même 2 balises : *MetadataName* qui doit correspondre à une balise du bloc Content du schéma SEDA 2.1., et une balise *MetadataValue* qui doit correspondre à la valeur du champ de l’unité archivistique présente dans le système à laquelle on veut rattacher l’objet du SIP ;
- déclarer les objets du bordereau de transfert à rajouter en utilisant la balise *DataObjectGroupReferenceId*.

*Exemple pour la méthode 1*
```
<ArchiveUnit id="ID4">
        <Management>
                <UpdateOperation>
                            <SystemId>aeaqaaaaaihnjdarabzvqak3m2b3qoqaaaaq</SystemId>
                </UpdateOperation>
        </Management>
        <Content>
                <DescriptionLevel>Item</DescriptionLevel>
                <Title xml:lang="fr">Discours prononcé lors de la discussion générale en deuxième lecture de la proposition de loi Warsmann de simplification et d'amélioration de la qualité du droit</Title>
        </Content>
        <DataObjectReference>
                <DataObjectGroupReferenceId>ID4</DataObjectGroupReferenceId>
        </DataObjectReference>
</ArchiveUnit>
```

*Exemple pour la méthode 2*
```
<ArchiveUnit id="ID4">
        <Management>
                <UpdateOperation>
                            <ArchiveUnitIdentifierKey>
                                     <MetadataName>Title</MetadataName>
                                     <MetadataValue>デモ</MetadataValue>
                            </ArchiveUnitIdentifierKey>
                </UpdateOperation>
        </Management>
        <Content>
                <DescriptionLevel>RecordGrp</DescriptionLevel>
                <Title>Sénat</Title>
        </Content>
        <DataObjectReference>
                <DataObjectGroupReferenceId>ID4</DataObjectGroupReferenceId>
        </DataObjectReference>
</ArchiveUnit>
```

La réorganisation d’arborescence pour les unités archivistiques déjà présentes dans le système
----

*Cas d’usage : un service d’archives a modifié son arbre de positionnement ou son plan de classement et souhaite rattacher à une branche nouvellement créée une arborescence d’unités archivistiques déjà présentes dans le système.*

La solution logicielle Vitam offre la possibilité de modifier l’arborescence des unités archivistiques déjà présentes dans la plate-forme en supprimant ou en créant un lien entre deux unités archivistiques.

La modification d’arborescence :
- est une opération potentiellement lourde, car elle a un impact sur toute la descendance des unités archivistiques concernées. Elle doit être utilisée avec précaution et n’a pas pour objectif de permettre la réorganisation de vracs ;
- ne peut être réalisée si une autre modification d’arborescence ou une opération d’élimination est en cours.

La modification d’arborescence s’accompagne d’une mise à jour du registre des fonds.

Le détachement et le rattachement ont des conséquences sur les services producteurs et les héritages de règles de gestion. L’archiviste doit s’assurer que les unités archivistiques resteront accessibles aux utilisateurs qui ont des droits pour les consulter et que les nouveaux héritages des règles de gestion ne conduiront pas à des conflits dans l’application des règles (cf. [vademecum Positionner des règles de gestion dans la solution logicielle Vitam](./Vademecum_reglesgestion_fonctionnement.md)).
