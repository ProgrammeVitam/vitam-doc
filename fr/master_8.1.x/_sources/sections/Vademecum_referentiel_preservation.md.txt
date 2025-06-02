Le référentiel des scénarios de préservation dans la solution logicielle Vitam
===

Un scénario de préservation décrit, pour une liste de formats donnée et un griffon donné, les actions de préservation à lancer.
Le référentiel des scénarios de préservation a pour finalités de :
- connaître l’ensemble des scénarios de préservation disponibles et utilisables dans la solution logicielle Vitam ;
- gérer et administrer une politique de préservation dont les scénarios de préservation sont la déclinaison ;
- permettre l’utilisation des scénarios de préservation ainsi référencés dans une ou plusieurs opérations de préservation.


Présentation du référentiel des scénarios de préservation
----
### Périmètre
Le référentiel des scénarios de préservation est propre au tenant sur lequel il a été importé.


### Actions couvertes par un scénario de préservation
Quatre actions élémentaires de préservation peuvent être effectuées par un scénario de préservation :
- GENERATE : génération d’un nouvel objet, par exemple, conversion d’un format,
- ANALYSE : analyse d’un ou plusieurs formats, par exemple, validation d’un format,
- IDENTIFY : ré-identification d’un ou plusieurs formats,
- EXTRACT : extraction de métadonnées contenues dans les objets binaires.
Un scénario de préservation peut effectuer une ou plusieurs de ces actions élémentaires.


### Paramétrage du griffon utilisé
À un scénario de préservation, un ou plusieurs griffons peuvent être associés.

Le griffon déclaré dans le scénario de préservation doit impérativement figurer dans le référentiel des griffons.

Pour chaque griffon, le scénario de préservation définit des arguments (des précisions sur l’action de préservation) et des conditions d’appel permettant ainsi d’affiner l’action de préservation et d’aller au-delà d’une simple conversion de format ou d’une simple validation de format.
Exemple :
- convertir un fichier .tiff en .jpeg en précisant la résolution attendue ;
- valider un format d’image ainsi que sa résolution conformément aux paramètres du scénario de préservation.

#### Formats
Un griffon peut être utilisé pour tous les formats d’objets techniques (griffon par défaut ou « DefaultGriffin ») ou pour des formats spécifiques listés dans le scénario (griffon par format ou « GriffinByFormat »).

Les formats déclarés dans le scénario de préservation doivent impérativement figurer dans le référentiel des formats.

#### Mécanismes de surveillance du fonctionnement des griffons
- Délai de traitement maximal défini pour le griffon : sans réponse du griffon dans ce délai, l’opération de préservation sera en échec.
- Taille maximale pour la génération des objets numériques attendue : si le griffon génère un objet de taille supérieure à cette limite, l’opération de préservation sera en échec.
- Récupération des logs générés par les griffons : cette option est intéressante en phase de test du scénario de préservation pour comprendre les éventuelles anomalies rencontrées.

#### Commande à exécuter
- Type d’action à exécuter : une des quatre actions élémentaires de préservation.
- Valeurs précisant les commandes passées par le scénario de préservation :
    - arguments, correspondant à une commande passée au griffon selon son langage et sa grammaire propre,
    - extension de sortie, permettant de préciser, dans le cadre d’une opération de génération d’objet binaire, l’extension du format généré attendue
    - métadonnées à extraire dans le cas d’une extraction de métadonnées.


### Contrôles effectués
Lors du lancement d’une opération de préservation, la solution logicielle Vitam vérifie que le scénario de préservation déclaré figure bien dans le référentiel des scénarios de préservation.


Configurer un référentiel des scénarios de préservation
----
### Constitution du référentiel des scénarios de préservation
Créer un scénario de préservation est un pré-requis obligatoire pour lancer une opération de préservation.<br>
Pour cela, il convient de réfléchir aux actions de préservation que l’on souhaite réaliser et de mener des tests préalables afin de tester les outils à utiliser, de les valider et de valider les résultats de l’action de préservation.<br>

De fait, afin de créer un scénario de préservation, il est recommandé que :
|Qui ?|Quoi ?|
|:-----|:-----|
|Administrateur fonctionnel|- détermine l’opération de préservation qu’il veut mettre en œuvre et l’outil qu’il souhaite utiliser.|
|Administrateur technique|– vérifie si le griffon que l’on souhaite solliciter est installé et disponible dans la solution logicielle Vitam<br>– le cas échéant, installe le griffon.|
|Administrateur technique et/ou fonctionnel|– vérifie si le griffon est référencé dans le référentiel des griffons ;<br>– le cas échéant, ajoute le griffon dans le référentiel des griffons|
|Administrateur technique et fonctionnel|– crée un scénario de préservation utilisant le griffon en question|
|Administrateur fonctionnel|– lance l’opération de préservation|

En fonction du périmètre, de(s) l’action(s) à effectuer et de(s) l’outil(s) privilégié(s), la conception du scénario de préservation variera. Par exemple :
- On peut envisager de réaliser un scénario unique d’identification de formats en utilisant le griffon par défaut Siegfried. Ce scénario ne spécifie pas de formats en particulier dans la mesure où Siegfried couvre les formats référencés dans le registre PRONOM ;
- Si l’on veut faire une succession d’actions sur un fichier (d’abord le transformer de A en B, puis de B en C), il faudra faire deux scénarios, car on va intervenir sur deux objets de format différent ;
- Si l’on veut faire deux actions sur le même fichier (analyse, puis conversion), on doit créer deux scénarios : l’un pour l’analyse, l’autre pour la conversion, car un même scénario ne peut avoir deux actions à réaliser portant sur le même format.

Le référentiel des scénarios de préservation peut être alimenté de manière très modulaire :
- d’une manière très générique, en réduisant le nombre de scénarios au nombre d’actions de préservation possibles : validation, conversion, identification, extraction ;
- d’une manière plus spécifique, en se focalisant sur :
    - un type de format en particulier par scénario ;
    - la finalité du scénario de préservation, en dissociant les scénarios par type d’action et format.

*Cas 1 : un scénario par type d’action de préservation*  
Cette première solution présente l’avantage de limiter le nombre de scénarios. En revanche, la mise au point de chacun des scénarios peut s’avérer complexe et leur utilisation dans le cadre d’une opération de préservation peut s’avérer lourde en termes de traitement et de performance. L’élaboration de ce type de scénarios génériques peut être envisagée dans le cadre d’opérations de préservation portant sur l’ensemble des objets conservés dans la solution logicielle Vitam et tournant en tâche de fond.
Élaborer un scénario par type d’action ne présente d’intérêt que pour l’identification.

*Cas 2 : un scénario par format*  
Cette deuxième solution permet d’effectuer des opérations de préservation plus ciblées et de répondre à des besoins plus circonscrits en termes de préservation. L’avantage de cette solution est de permettre de ne pas lancer une opération sur l’ensemble des objets conservés dans la solution logicielle Vitam et d’avoir une vision plus claire du contenu de chacun des scénarios de préservation.

*Cas 3 : un scénario par finalité*  
Cette troisième solution, modulaire, permet de disposer de scénarios génériques, portant sur l’ensemble des formats supportés dans la solution logicielle Vitam, en vue de réaliser une opération de préservation en particulier (ex : générer des GIF, grâce à plusieurs griffons et sur une liste exhaustive de formats). Mais elle permet également d’effectuer des actions plus ciblées et de répondre à des besoins plus circonscrits (ex : valider des fichiers PDF).


### Transposition d’un référentiel existant
La préservation numérique étant un domaine relativement récent pour les archivistes, il n’existe actuellement que rarement des outils métier qui pourraient être transposés pour élaborer le référentiel des scénarios de préservation.


### Gestion des identifiants des scénarios de préservation
Le référentiel des scénarios de préservation fonctionne en mode « esclave ». Les identifiants des scénarios de préservation sont gérés dans un outil externe.


### Formalisation du référentiel
Le référentiel des scénarios de préservation est importé dans la solution logicielle Vitam sous la forme d’un fichier JSON contenant l’ensemble des scénarios de préservation.
Un scénario de préservation comporte obligatoirement les informations suivantes :
- identifiant signifiant du scénario de préservation, généré par l’application à l’origine de sa création (Identifier) et devant être unique dans le système ;
- nom du scénario de préservation (Name) ;
- action(s) couverte(s) par le scénario de préservation (ActionList). Ce champ peut contenir 1 à 4 valeurs : « GENERATE », « ANALYSE », « IDENTIFY » ou « EXTRACT » ;
- un bloc GriffinByFormat (Action(s) couverte(s)) précise l’(les) action(s) couverte(s) par le scénario de préservation, pour un griffon donné et une liste de formats donnée.<br>
Une description (Description), ainsi qu’une action et un griffon à exécuter par défaut (bloc DefaultGriffin), facultatifs, peuvent venir compléter ces informations.

Pour en savoir plus, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).


Modification du référentiel des scénarios de préservation
---
### Suppression d’un scénario de préservation 
Si on ne souhaite plus utiliser un scénario de préservation, il faut l’ôter du référentiel des scénarios de préservation et ainsi il ne pourra plus être utilisé dans une opération de préservation.
Les raisons pouvant amener à supprimer un scénario sont les suivantes :
- Le scénario n’est jamais utilisé ou n’est plus utilisé. Par souci de clarté, on souhaite le supprimer du référentiel ;
- Le référentiel contient deux scénarios identiques. Plutôt que de les maintenir séparément, on souhaite en supprimer un du référentiel ;
- Le scénario fait appel à un griffon qui n’est plus utilisé dans le système ;
- Il y a eu erreur de saisie dans le référentiel, qui a entraîné la création d’une deuxième version d’un scénario de préservation.

Avant de supprimer tout scénario de préservation, il est recommandé de vérifier qu’il n’est pas utilisé dans le cadre d’une opération de préservation en cours de réalisation.


### Mise à jour du référentiel
La mise à jour du référentiel des scénarios de préservation s’effectue par un réimport du fichier JSON, en mode « annule et remplace ». Il est donc possible : 
- d’ajouter un nouveau scénario ;
- modifier les informations associées à un scénario (notamment lorsque on le met à jour un griffon ou lorsque l’on en crée un nouveau) ;
- supprimer un scénario.

Les différentes versions du référentiel font l’objet d’une sauvegarde sur les offres de stockage.


Pour en savoir plus, consulter le [document VITAM. Gestion de la préservation](./preservation.md).