Les profils d’archivage dans la solution logicielle Vitam
====

Le profil d’archivage permet de définir précisément la manière dont des archives destinées à être transférées dans un système d’archivage électronique doivent être structurées et décrites.
La solution logicielle Vitam permet de disposer d’un référentiel des profils utilisables pour contrôler la structuration des entrées.


Présentation du référentiel des profils d’archivage
---
### Périmètre du référentiel des profils d’archivage
Le référentiel des profils d’archivage est propre au tenant sur lequel il a été importé.


### Déclaration des profils d’archivage dans les contrats d’entrée
Pour pouvoir être utilisé en entrée de la solution logicielle Vitam, le profil d’archivage doit être associé à un contrat d’entrée.

Un contrat d’entrée peut déclarer plusieurs profils d’archivage.

La déclaration se fait sur la base de l’identifiant de la notice du profil dans le référentiel des profils d’archivage.


### Contrôles effectués à partir du référentiel des profils d’archivage
En entrée, la solution logicielle Vitam contrôle la conformité du transfert reçu par rapport au profil déclaré dans le bordereau de transfert.<br>
La déclaration du profil dans le bordereau de transfert dans le bloc <ManagementMetadata>, sous-bloc <ArchiveProfile>, se fait sur la base de l’identifiant du profil dans le référentiel des profils d’archivage.
La solution logicielle vérifie ensuite que le profil d’archivage déclaré dans le bordereau de transfert est bien associé au contrat d’entrée utilisé pour le transfert et est actif. Si ce n’est pas le cas, le versement sera rejeté.<br>
La solution logicielle contrôle enfin que le SIP est conforme au profil d’archivage déclaré. Si ce n’est pas le cas, le versement sera rejeté.

Si le bordereau de transfert ne déclare pas de profil d’archivage, la solution logicielle Vitam n’effectuera pas de contrôle de conformité en entrée, même si le contrat d’entrée utilisée est bien associé à un profil d’archivage.


Configuration du référentiel des profils d’archivage
---
### Constitution des profils d’archivage
Disposer de profils d’archivage n’est pas un pré-requis pour réaliser des entrées dans la solution logicielle Vitam.<br>
En fonction des types de transfert, cependant, l’administrateur fonctionnel pourra souhaiter définir un ou plusieurs profils d’archivage pour structurer des bordereaux de versement et effectuer des contrôles plus précis à l’entrée.<br>
Rédiger un profil d’archivage est intéressant lorsque l’on attend des versements réguliers de données très structurées, obéissant à des règles de classement, de nommage et de description uniformes.<br>
Il permet en effet d’imposer un modèle de description identique pour des séries de dossiers homogènes, quel que soit leur contexte de production et d’effectuer un contrôle supplémentaire sur les transferts reçus et leur contenu, ce qui est un gage de qualité des archives versées.<br>
Un profil d’archivage n’est en revanche pas adapté pour des versements unitaires ou isolés puisque son objectif est de standardiser un transfert et d’associer un modèle à un type de données.

Un profil d’archivage est un outil de contrôle du bordereau de transfert, il ne permet pas d’alimenter automatiquement le bordereau.


### Transposition des outils existants
Un profil d’archivage nécessite une analyse et une modélisation préalables des données à archiver.

Il s’agit de connaître :
- l’organisation structurelle des données à archiver ;
- les métadonnées associées à ces données, permettant de les identifier, de les gérer et de les retrouver après transfert dans le système d’archivage électronique ;
- le contenu de données, à savoir la nature des données à archiver (présence ou non d’un fichier associé et type du fichier).

Les profils d’archivage doivent être élaborés conformément au schéma imposé par le SEDA.
Ils peuvent :
- émettre des règles plus strictes que celles du SEDA (ex. : rendre unique un titre, alors que le SEDA rend possible sa répétabilité), mais pas des règles moins stricte ;
- rendre obligatoire l’utilisation de certains éléments et/ou valeurs ;
- imposer une structure hiérarchique des données (ex : un dossier doit contenir deux sous-dossiers et non trois).
      
Rédiger un profil d’archivage revient donc à définir la structure du bordereau de transfert qui sera complétée avec les informations qui varient d’un dossier à l’autre. Des commentaires permettent d’expliciter les valeurs attendues.<br>
L’administrateur fonctionnel peut se baser sur les bordereaux spécifiques à une filière utilisés dans son service pour les transposer dans un profil.

*Illustration avec le bordereau de versement par une association de ses dossiers d’assemblée générale*

|[En tête du bordereau]|<br>	Association XY<br>	Dossiers d’assemblée générale<br>  2005-2006|||||
|:-----|:----|:-----|:------|:------|:------|
|[Numéro d’ordre]|[Description]|[Date de début]|[Date de fin]|[DUA]|[Sort final]|
|1|Dossier de l’assemblée générale : convocation, documents joints,compte-rendu|20/10/2005|29/11/2005|5 ans|Conserver|
|2|Dossier de l’assemblée générale : convocation, documents joints, compte-rendu|19/10/2006|28/11/2006|5 ans|Conserver|

Le profil d’archivage va définir les éléments qui sont fixes (en gras) qui devront obligatoirement être présents et correspondre aux valeurs définies, ceux qui doivent être remplis par le producteur (en italique) en précisant les valeurs attendues (une date, une chaîne de caractères…). Le profil va également imposer qu’un dossier d’assemblée générale se compose systématiquement de trois unités archivistiques nommés « convocation », « documents joints » et « compte rendu ».

Le profil d’archivage peut se combiner avec le profil d’unité archivistique. En ce cas, le profil d’archivage décrira la structure générale du bordereau et le profil d’unité archivistique précisera les champs et valeurs attendues pour les unités archivistiques (dossiers, pièces).

Pour la formalisation des champs et leur type d’indexation, consulter le [vademecum L’ontologie dans la solution logicielle Vitam](./Vademecum_ontologie.md).


### Gestion des identifiants des profils d’archivage
À l’installation de la plate-forme Vitam, l’administrateur technique peut configurer le tenant pour que les identifiants des profils d’archivage soient générés par Vitam (mode « maître ») ou par le front-office (mode « esclave »).
Le mode esclave est intéressant si les profils d’archivage sont générés dans une autre application qui leur donne un identifiant que l’on souhaite pouvoir suivre.


### Formalisation du référentiel des profils d’archivage
Les profils d’archivage prennent la forme de fichiers au format XSD ou Relax NG (RNG) qui permettent de valider un fichier écrit en XML, comme le bordereau de transfert. Ils sont élaborés hors de la solution logicielle Vitam, par exemple avec les outils mis à disposition par le Service interministériel des archives de France (outil SHERPA).

Le référentiel des profils d’archivage de la solution logicielle Vitam se compose de notices descriptives au format JSON auxquelles il est possible d’associer le profil d’archivage proprement dit au format XSD ou RNG.

La notice descriptive est composée des éléments suivants :

**Éléments obligatoires**
- identifiant unique donné à la notice, sauf s’il est généré automatiquement par le système
- nom du profil d’archivage, qui doit être obligatoirement renseigné dans la solution logicielle Vitam
- statut « Actif » ou « Inactif » ; par défaut, le statut est « Inactif »
      - format du profil d’archivage, obligatoire (Format). Il correspond au format du profil d’archivage associé à la notice, à savoir :
            - XSD si le profil d’archivage a été écrit en XSD,
            - RNG si le profil d’archivage a été généré conformément au langage Relax NG
**Éléments facultatifs**
- description du profil d’archivage
- date d’activation
- date de désactivation

Pour plus d’informations, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md), chapitre « 5.12. Collection Profile ».

L’import des notices est une opération d’administration fonctionnelle.<br>
Il est possible d’importer en une seule fois un référentiel complet, comprenant plusieurs notices décrivant chacune un profil d’archivage. La solution logicielle Vitam ne comptabilisera qu’une seule opération, et ne prendra pas en compte dans le journal des opérations la création unitaire des différents items compris dans le référentiel importé. Afin d’optimiser la traçabilité de la création des différentes notices, il est recommandé de créer ces dernières une par une.
      
L’import d’une notice ne suffit pas pour utiliser un profil d’archivage dans la solution logicielle Vitam. Il est nécessaire, après cette opération, d’importer le fichier .xsd ou .rng correspondant au profil d’archivage lui-même et de l’associer à la notice qui le référence, afin qu’il soit pris en compte dans la solution logicielle Vitam.

À chaque notice descriptive, il n’est possible d’associer qu’un seul profil d’archivage qui doit être conforme au format déclaré dans la notice (XSD ou RNG).
Si le profil d’archivage n’est pas conforme au format annoncé dans la notice, il n’est pas possible de l’importer dans la solution logicielle Vitam.

L’import d’un profil d’archivage dans le référentiel des profils est un des prérequis indispensable pour pouvoir réaliser des contrôles entre un profil d’archivage et des bordereaux de transfert au moment de leur versement dans la solution logicielle Vitam.


### Activation/désactivation d’un profil d’archivage
Un profil d’archivage peut être importé avec un statut inactif ou être désactivé lors d’une mise à jour du profil. Pour pouvoir être utilisé pour effectuer des contrôles en entrée, un profil d’archivage doit avoir un statut « actif » dans le référentiel des profils d’archivage.

Si le profil n’a pas un statut « actif », les transferts déclarant ce profil seront rejetés.


Modification du référentiel des profils d’archivage
---
Les champs des notices décrivant les profils d’archivage peuvent être modifiés. Cette action provoque la création d’une nouvelle version de la notice modifiée. Elle fait l’objet d’une journalisation dans le journal des opérations.

Les champs modifiables sont :
- le nom du profil d’archivage ;
- la description du profil d’archivage ;
- le statut « Actif » ou « Inactif » ;
- le chemin d’accès au profil d’archivage associé à la notice détaillée.

La solution logicielle Vitam permet de modifier le fichier au format XSD ou RNG correspondant au profil d’archivage. Néanmoins, cette action requiert des précautions d’usage, dans la mesure où le profil d’archivage peut être utilisé pour des transferts en cours. Avant de modifier un profil d’archivage dans une notice descriptive, il est recommandé de :
- vérifier qu’aucun transfert nécessitant ce profil d’archivage n’est en cours ou programmé ;
- désactiver la notice descriptive ;
- modifier le profil d’archivage en téléchargeant un nouveau profil qui prend la forme :
      - d’un fichier XSD si la notice déclare un format XSD,
      - d’un fichier RNG si la notice déclare un format Relax NG ;
- rétablir les services désactivés.

Pour en savoir plus, consulter le [document VITAM. Profils d’archivage](./profil_archivage.md).