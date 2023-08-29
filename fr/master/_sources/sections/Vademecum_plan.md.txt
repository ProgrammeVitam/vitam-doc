Le plan de classement dans la solution logicielle Vitam
====


Un plan de classement correspond à un ensemble d’unités archivistiques hiérarchisées sous forme arborescente, décrivant la structure organique d’un ensemble documentaire.

Il est destiné dans la solution logicielle Vitam à faciliter l’organisation et la recherche des dossiers, documents et données produits ou reçus par un service producteur dans l’exercice de ses activités.

Il permet de situer et de rechercher des unités archivistiques au sein d’un ensemble documentaire.


Présentation du plan de classement 
---

### Périmètre du plan de classement
Un plan de classement est propre au tenant sur lequel il a été importé.


### Contrôles effectués à partir du plan de classement
En entrée, le plan de classement peut permettre de faire du classement automatique (déclaration d’un nœud de rattachement systématique des entrées) ou de vérifier le périmètre des rattachements déclarés dans le bordereau de transfert, en fonction du paramétrage du contrat d’entrée.
En accès, le plan de classement permet de cloisonner des parties d’arborescence en déclarant les nœuds de plan de classement comme nœud de consultation ou nœud d’exclusion dans le contrat d’accès.


### Articulation des arbres de positionnement, des plans de classement et des SIP
Les arbres de positionnement, les plans de classement et les SIP constituent tous les trois des moyens d’organiser les archives sous la responsabilité d’un service d’archives. Ils se présentent tous les trois sous la forme d’arborescences d’unités archivistiques. Ils sont cependant traités de manière différente dans la solution logicielle Vitam. Les unités de plan de classement présentent les caractéristiques suivantes :
- elles ne peuvent être rattachées qu’à des unités d’arbre ou de plan ;
- elles ne peuvent avoir pour filles que des unités archivistiques de plan ou des unités archivistiques standard ;
- elles déclarent obligatoirement un service producteur et sont comptabilisées dans le registre des fonds de ce service.


### Déclaration de règles de gestion
Les unités archivistiques de plan de classement peuvent déclarer des règles de gestion à tout niveau de l’arborescence du plan de classement.

Ces règles pourront être héritées par les unités de plan de classement ou les unités archivistiques standard qui leur seront rattachées.

Pour en savoir plus sur l’héritage et le positionnement des règles de gestion, consulter les fiches Positionner des règles de gestion dans la solution logicielle Vitam et Réaliser des éliminations avec la solution logicielle Vitam.



Configuration du plan de classement
--- 

### Utilisation du plan de classement
L’utilisation d’un plan de classement n’est pas obligatoire. Il est tout à fait possible de verser dans un SIP les documents et toute leur structuration hiérarchique (dossier, sous-dossier, pièces) sans les dissocier. De même, il est possible de verser les SIP en les plaçant tous au même niveau « racine » dans la solution logicielle Vitam ou en ne les rattachant qu’à un arbre de positionnement.

Toutefois, si le producteur dispose en amont de la création des documents d’un plan de classement validé, par exemple dans le cadre d’une démarche de records management, l’archiviste peut faire le choix de verser cette structure à part et de l’alimenter ensuite par des SIP contenant les documents produits ou reçus dans l’exercice des activités de ce producteur. Le bordereau de versement indiquera les rattachements des unités archivistiques du SIP aux unités archivistiques du plan à effectuer à l’entrée.

Cela sera d’autant plus intéressant si le plan est utilisé pour structurer une production documentaire sur plusieurs supports, par exemple l’arborescence bureautique des dossiers partagés, le logiciel de gestion du courrier et les dossiers papier. Dans ce cas, la structure du plan de classement pourra être versée dans la solution logicielle Vitam et être alimentée par des SIP correspondant aux versements de documents bureautiques et par des versements du logiciel de gestion du courrier.

Pour une GED qui inclut des plans de classement pour chaque producteur et des documents partagés entre les différents producteurs, il sera possible de verser dans un premier temps ces plans de classement, puis de réaliser des versements périodiques (par exemple sur une base annuelle) des documents en les rattachant à l’entrée au(x) dossier(s) du/des plan(s) de classement qu’ils alimentent.

L’utilisation d’un plan de classement s’avère également intéressante lorsque l’application métier qui doit réaliser des versements réguliers peut verser à part la structure type des dossiers qu’elle gère et ne transférer ensuite que les pièces au fur et à mesure de leur production.
Par exemple, pour un système de gestion des ressources humaines (SIRH) adossé à une plate-forme utilisant la solution logicielle Vitam pour son archivage courant, il est possible de verser la structure  du dossier agent à chaque nouveau recrutement et d’alimenter ensuite cette structure des documents validés en rattachant à l’entrée chaque unité archivistique du SIP au sous-dossier ad hoc par déclaration dans le bordereau de versement.

En fonction des choix effectués, il pourra être nécessaire d’intégrer un plan de classement dans la solution logicielle Vitam avant le premier transfert d’archives standard. D’autres plans pourront être versés par la suite, en fonction des besoins.


### Transposition des outils existants
Si l’administrateur fonctionnel choisit de structurer son information en utilisant des plans de classement, il peut s’appuyer pour réaliser ces plans sur différents outils existants : pour les services engagés dans une démarche de records management, les plans de classement validés ; pour les applications métier, la structuration de l’information définie dans l’application.

Chaque niveau de description correspondra à une unité archivistique de plan de classement.


### Formalisation du plan de classement
Les plans de classement sont importés dans la solution logicielle Vitam sous la forme de SIP contenant un bordereau de transfert, mais sans aucun objet associé. Le plan de classement peut contenir des règles de gestion associées à l’entrée ou aux unités archivistiques.

La description des unités archivistiques de type plan de classement comprend : 
- des champs d’identification : identifiant système, identifiants fournis par le service d’archives (cotation) ou par le producteur (identifiant métier de type numéro de dossier, matricule…) – facultatif,
- le niveau de description associé à l’unité archivistique – obligatoire,
- des champs de description correspondant soit à une description minimale conforme à la norme ISAD(G) soit à une description enrichie conformément aux besoins du service producteur (par exemple en utilisant les champs proposés dans l’ontologie proposée dans le SEDA v.2.1). 
Conformément à la norme ISAD(G), un intitulé est obligatoire.

Pour en savoir plus consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).

La moulinette ReSIP permet d’importer une structure arborescente d’unités archivistiques correspondant à un plan de classement sous la forme d’un fichier .csv pour en générer le SIP.

Pour plus de précision sur la constitution de ce fichier, se référer au [document VITAM. ReSIP](./resip.md).


Rattachement et modification d’un plan de classement
----

### Rattachement à l’import
Il est possible de rattacher un plan de classement à un arbre ou un plan existant déjà dans le système par déclaration dans le bordereau de versement ou par rattachement systématique déclaré dans le contrat d’entrée* à condition de respecter les règles de structuration de l’information dans la solution logicielle Vitam.


### Modification d’une arborescence d’un plan de classement
La solution logicielle Vitam permet de modifier l’arborescence d’unités archivistiques de plan de classement déjà entrées dans le système, à condition de respecter les règles de structuration de l’information. Il est possible de :
- modifier les intitulés des unités archivistiques de plan (modification unitaire ou en masse),
- ajouter des branches à un plan de classement en important un plan qui se rattachera au plan existant,
- déplacer des branches du plan de classement pour les rattacher à un autre plan de classement ou à un arbre ou à la « racine » de la solution logicielle,
- supprimer des branches du plan de classement dans le cadre d’une opération d’élimination.

L’opération est journalisée dans le journal du cycle de vie de l’unité archivistique ayant été rattachée, déplacée ou modifiée.


Pour aller plus loin, consulter le [document VITAM. Gestion des archives et des arborescences](./).