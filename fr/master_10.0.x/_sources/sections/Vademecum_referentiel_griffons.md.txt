Le référentiel des griffons dans la solution logicielle Vitam
===

Les griffons sont des outils logiciels permettant d’effectuer dans la solution logicielle Vitam des traitements sur les objets binaires en fonction de leur format.
Le référentiel des griffons permet d’administrer l’ensemble des griffons installés et pouvant être utilisés par la solution logicielle Vitam.<br>
L’objectif du référentiel est de :
- connaître l’ensemble des griffons installés, gérés et utilisables dans la solution logicielle Vitam ;
- permettre l’utilisation des griffons ainsi référencés dans un à plusieurs scénario(s) de préservation.


Présentation du référentiel des griffons
---
### Périmètre
Le référentiel des griffons est valable pour la plate-forme. Il est dit trans-tenant.

### Contrôles effectués
Les identifiants des griffons sont utilisés dans la solution logicielle Vitam dans les scénarios de préservation, pour indiquer le griffon à utiliser. Si l’identifiant du griffon indiqué dans le scénario de préservation n’est pas présent dans le référentiel des griffons, la création ou la modification du scénario de préservation est rejetée.

Pour pouvoir être utilisé dans un scénario de préservation, le griffon doit avoir préalablement été installé au moyen d’un acte technique.


Configurer un référentiel des griffons
---
### Installation des griffons et constitution du référentiel
Un griffon est construit autour d’un outil logiciel interfacé avec la solution logicielle Vitam pour effectuer différents traitements de préservation sur les objets binaires en fonction de leur format, dans le cadre d’un scénario de préservation.<br>
Un même griffon peut être utilisé pour effectuer plusieurs traitements, plusieurs griffons peuvent être utilisés pour effectuer un traitement identique sur un même périmètre.

Le choix des griffons à installer est fait par l’administrateur fonctionnel en fonction de ses besoins en matière de préservation et de la nature des fonds qu’il conserve (fichiers bureautiques, fichiers image, fichiers son, plans en 2D…). Par défaut, plusieurs griffons sont disponibles avec la solution logicielle Vitam et peuvent être installés.<br>
L’installation et l’exploitation des griffons constituent un acte d’administration technique.

L’installation des griffons lors de l’initialisation de la plate-forme est facultative, mais leur absence interdira toute opération de préservation.

L’installation des griffons doit être suivie de leur déclaration dans le référentiel des griffons, afin que le griffon puisse être utilisé lors d’une opération de préservation.

### Gestion des identifiants des griffons
Le référentiel des griffons fonctionne en mode « esclave ». L’identifiant des différents griffons est géré dans un outil externe.

### Formalisation du référentiel
Le référentiel des griffons est importé dans la solution logicielle Vitam sous la forme d’un fichier JSON contenant l’ensemble des griffons installés.
Pour un griffon donné, il comporte obligatoirement les informations suivantes :
- identifiant signifiant du griffon, généré par l’application à l’origine de sa création (Identifier) ;
- nom du griffon (Name)
- nom technique du griffon, utilisé pour lancer son exécution dans la solution logicielle Vitam (ExecutableName)
- version du griffon (ExecutableVersion)
Une description (Description) et une date de création (CreationDate), facultatives, peuvent venir compléter ces informations.

Pour plus d’informations, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).


Modification du référentiel
---
### Suppression d’un griffon
La solution logicielle Vitam ne permet pas de désinstaller un griffon, au sens technique du terme.
Si on souhaite ne plus utiliser un griffon, il faut l’ôter du référentiel des griffons. Ainsi, il ne peut plus être utilisé dans un scénario de préservation.
Les raisons pouvant amener à supprimer un griffon sont les suivantes :
- Le griffon n’est jamais utilisé. Par souci de clarté, on souhaite le supprimer du référentiel ;
- Le griffon est obsolète et a été remplacé par une version plus récente. Plutôt que de maintenir deux griffons de version différente dans le référentiel, on souhaite en supprimer un du référentiel ;
- Il y a eu erreur de saisie, qui a entraîné la création d’un griffon qui n’est pas installé et/ou supporté par la solution logicielle Vitam.
Quand on supprime un griffon, il est indispensable de vérifier s’il est utilisé par un ou plusieurs scénarios de préservation et de modifier au préalable ces derniers avant la suppression du griffon.

### Mise à jour du référentiel des griffons
La mise à jour du référentiel des griffons s’effectue par un réimport du fichier JSON, en mode « annule et remplace ». Il est possible : 
- d’ajouter un nouveau griffon ;
- de modifier les informations associées à un ou plusieurs griffons (ex : modification de la description) ;
- de supprimer un griffon à condition qu’il ne soit pas utilisé par un scénario de préservation.

Les différentes versions du référentiel font l’objet d’une sauvegarde sur les offres de stockage.

*Points d’attention :*
- Après la mise à jour du référentiel, il est recommandé à l’administrateur technique de vérifier que la liste des griffons présents dans le référentiel correspond aux différents griffons installés sur la plate-forme ;
- Un griffon pouvant être utilisé dans un ou plusieurs scénario(s) de préservation, il est recommandé de vérifier son utilisation avant de procéder à sa suppression dans le référentiel des griffons.


Pour en savoir plus, consulter le [document VITAM. Gestion de la préservation](./preservation.md).


