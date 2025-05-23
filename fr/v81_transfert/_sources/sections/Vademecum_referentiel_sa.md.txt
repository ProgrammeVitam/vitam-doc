Le référentiel des services agents dans la solution logicielle Vitam
===
Le service producteur constitue une donnée essentielle du système d’archivage électronique, car il permet d’identifier précisément les responsables des fonds d’archives, et de gérer les droits d’accès et de traitement sur celles-ci en se basant sur une information normalisée et fiable dans la solution logicielle Vitam.
Le référentiel des services agents liste l’ensemble des services producteurs et versants des unités archivistiques conservées dans la solution logicielle Vitam et gère cette donnée de référence.
Le référentiel sert de base au contrôle des services déclarés dans le bordereau de transfert lors de l’entrée, à l’alimentation du registre des fonds ainsi qu’à la gestion des accès sur les archives.


Présentation du référentiel des services agents
---
### Périmètre du référentiel des services agents
Un référentiel des services agents est propre au tenant sur lequel il a été importé.


### Contrôles effectués à partir du référentiel des services agents
Lors d’une entrée, la solution logicielle Vitam vérifie que les services agents déclarés pour toute l’entrée (balise <ManagementMetadata> du bordereau de transfert) – c’est-à-dire le service producteur et le service versant de l’entrée – sont bien présents dans le référentiel des services agents applicable sur le tenant.

En cas d’absence du référentiel des services agents, la vérification de la conformité des services agents présents dans le bordereau de transfert ne pourra être réalisée et l’entrée sera rejetée. Ce référentiel est donc indispensable pour pouvoir réaliser des entrées.

Sur la base de ce contrôle, la solution logicielle enregistre la prise en charge du transfert pour le service producteur déclaré dans le bordereau de transfert et enrichit en conséquence le registre des fonds de celui-ci.

Les services producteurs déclarés au niveau des unités archivistiques (balise <Content> dans la partie DescriptiveMetadata du bordereau) ne font pas l’objet d’un contrôle de conformité avec le référentiel des services agents, dans la mesure où ces informations sont traitées comme des métadonnées descriptives et ne servent pas de base à des traitements en gestion dans la solution logicielle Vitam.

Il est possible de contrôler les accès aux archives en fonction des services ayant des droits sur les unités archivistiques, c’est-à-dire le service producteur d’une entrée et les éventuels services producteurs auxquels tout ou partie de cette entrée a été rattachée. Les services producteurs déclarés dans le contrat d’accès font l’objet d’un contrôle d’existence dans le référentiel des services agents. Si un contrat est créé ou modifié avec l’identifiant d’un service inconnu du référentiel, la création ou la modification de ce contrat est refusée.


Configuration du référentiel des services agents
---
### Constitution du référentiel des services agents
L’administrateur fonctionnel constitue le référentiel des services agents à partir du recensement des services producteurs et versants de son entité.
À chacun de ces services, il associe un identifiant et une description sommaire qui permettra de différencier au besoin deux services au nom proche, par exemple, les services des ressources humaines des différentes entités.

Le référentiel des services agents n’est pas un référentiel complet comme ceux utilisés dans les applications archivistiques qui indiquent les filiations et les héritages. Pour les services qui disposent déjà d’un tel outil, une extraction simplifiée en sera réalisée pour alimenter la solution logicielle Vitam.
Néanmoins, il peut contenir des informations historiques relatives aux services agents au terme de la version 8.0.


### Gestion des identifiants des services agents
Le référentiel des services agents fonctionne en mode « esclave ». En effet, le référencement des agents constitue une donnée de référence partagée entre de nombreux systèmes et, dans les services d’archives, souvent pilotée depuis le SIA ou des gestionnaires de référentiels externes au SAE. Le  référentiel du SAE sera alors constitué d’un export du référentiel maître applicable aux archives papier comme électroniques, ce qui permet de garder une unité dans la dénomination (identifiant) des services agents, quel que soit le support auquel ils s’appliquent.
Utiliser le référentiel des services agents en mode « esclave » permet également au service d’archives d’attribuer des identifiants signifiants aux services agents et/ou de permettre l’interopérabilité avec des systèmes attribuant des identifiants nationaux ou internationaux pour désigner de manière univoque les personnes et les organismes, comme les identifiants ISNI (International Standard Name Identifier).


### Formalisation du référentiel des services agents
Le référentiel des services agents est importé dans la solution logicielle Vitam sous la forme d’un fichier tableur au format .csv comportant les colonnes suivantes :

|Nom de la colonne|Description de la colonne|Valeurs possibles|Observations|
|:----|:----|:----|:----|
|Identifier|Identifiant du service||Cet identifiant ne doit pas comprendre d’espace ou de caractère accentué|
|Name|Nom du service|||
|Description|Description du service|||

Il peut aussi inclure les colonnes suivantes dans sa forme étendue :

- dans sa forme étendue :

|Nom de la colonne|Description de la colonne|Valeurs possibles|Observations|
| :--------------- |:---------------:|:-----:|:-----------:|
|Identifier|Identifiant du service||Cet identifiant ne doit pas comprendre d’espace, de caractère accentué, de virgule, d’apostrophe, de parenthèse, de slash, d’élément de ponctuation, ou tout autre caractère spécial. Ne sont recommandés que l’underscore et le tiret comme séparateurs.|
|Name|Nom du service|||
|Description|Description du service|||
|EntityType|Type d’entité|Colonne facultative.||
|NameEntryParallel|Formes parallèles du nom|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|AuthorizedForm|Formes du nom normalisées selon d’autres conventions|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|AlternativeForm|Autres formes du nom|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|EntityId|Numéro d’immatriculation des collectivités|Colonne facultative.||
|FromDate|Date de début d’existence|Colonne facultative.<br>Les formats de date acceptés sont AAAA-MM-JJ et JJ/MM/AAAA.||
|ToDate|Date de fin d’existence|Colonne facultative.<br>Les formats de date acceptés sont AAAA-MM-JJ et JJ/MM/AAAA.||
|Functions|Fonctions et activités|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|BiogHist|Histoire|Colonne facultative.||
|Places|Lieux|Colonne facultative.Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|LegalStatuses|Statut juridique|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|Mandates|Textes de référence|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|StructureOrGenealogy|Organisation interne/généalogie|Colonne facultative.||
|GeneralContext|Contexte général|Colonne facultative.||
|MaintenanceStatus|Niveau d’élaboration|Colonne facultative.||
|LocalStatus|Niveau de détail|Colonne facultative.||
|Sources|Sources|Colonne facultative.<br>Il est possible de saisir plusieurs valeurs, séparées par des pipes.||
|EventDescription|Notes relatives à la mise à jour de la notice|Colonne facultative.||

Le fichier .csv à importer doit avoir les caractéristiques suivantes :
- encodage des caractères : UTF-8 ;
- séparateur de champ : la virgule ;
- séparateur de texte : guillemets simples ou doubles, espace vide ;
- les noms de colonnes facultatifs peuvent être absents, s'ils ne sont pas utilisés ;
- si un champ doit contenir plusieurs valeurs, elles doivent être séparées par un pipe.

Pour en savoir plus, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).


Modification du référentiel des services agents
---
Le référentiel des services agents ne peut pas être mis à jour unitairement (pour un service uniquement). Il convient d’importer un nouveau fichier .csv contenant l’ensemble des services agents en mode « annule et remplace ».

Lors d’une mise à jour du référentiel, des contrôles sont effectués sur les services agents déjà utilisés dans la solution logicielle Vitam, c’est-à-dire les services agents déclarés par des entrées ou par des contrats d’accès.
Sont appliqués les cas suivants :
- échec de la mise à jour si celle-ci a demandé la suppression d’un service agent déjà utilisé ;
- succès avec avertissement de la mise à jour si celle-ci a demandé la modification d’un service agent déjà utilisé (uniquement son intitulé et sa description).

Les différentes versions du référentiel font l’objet d’une sauvegarde sur les offres de stockage utilisées par l’implémentation de la solution logicielle Vitam.


Pour aller plus loin, consulter le [document VITAM. Services producteurs](./services_prod.md).