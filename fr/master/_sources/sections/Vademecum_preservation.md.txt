La préservation dans la solution logicielle Vitam
===

La préservation numérique consiste en un ensemble de processus visant à maintenir un accès aux objets numériques sur le long terme. Elle implique un moyen de représenter ces objets dans le temps et de vérifier la disponibilité et l’intégrité des objets dans la solution logicielle Vitam.


Présentation de la préservation
---
### Définition
Au-delà des services de sécurisation des journaux, d’audit et de génération de relevé de valeur probante, la préservation numérique intègre les services suivants :
- la réalisation de traitements de masse sur les fichiers pour :
    - identifier ou ré-identifier leur format à la suite d’une mise à jour du référentiel des formats,
    - valider les fichiers par rapport aux spécifications des formats,
    - convertir les fichiers dans un nouveau format ;
    - extraire les métadonnées encapsulées dans les fichiers ;
- l’administration des objets permettant de paramétrer et d’effectuer des traitements :
    - les outils (griffons),
    - les traitements (scénarios de préservation),
    - les formats (référentiel des formats)


### Les types d’action de préservation
Une action de préservation s’applique sur un objet donné (fichier numérique), caractérisé par un usage et une version relative, c’est-à-dire la première ou la dernière version disponible pour cet usage).

Il existe quatre types d’action élémentaire.

L’*analyse* traite la conformité d’un objet par rapport aux spécifications de son format (validation de format) ou encore par rapport à des critères émis pour des besoins de conservation et en déduit une valeur  contenue dans une énumération ; le résultat est exprimé dans un rapport d’analyse.
Exemple pour la validation : VALID, WELL_FORMED, NON_VALID, WRONG_FORMAT.
Exemple pour la qualité d’image : NETTE, FLOUE…

La *génération de binaire* permet de générer un nouveau fichier dans un usage défini. Le nouvel objet binaire fait l’objet d’un calcul d’empreinte, d’une identification de format, d’un stockage et d’une indexation. Le groupe d’objets techniques correspondant est mis à jour, ainsi que le registre des fonds.
Exemples :
- conversion du format obsolète d’un fichier d’usage original (BinaryMaster) en générant un nouveau BinaryMaster dans un format cible ;
- création d’un fichier d’usage diffusion (Dissemination) à partir d’un original (BinaryMaster) en supprimant des métadonnées de géolocalisation ;
- création d’un fichier d’usage vignette pour un aperçu sur un site internet à partir d’un original (BinaryMaster) ;
- création d’un fichier d’usage contenu brut (TextContent) avec les résultats de l’océrisation d’un fichier original (BinaryMaster) lors d’une campagne de numérisation.

L’*extraction de métadonnées* permet d’extraire des métadonnées techniques ou descriptives encapsulées dans le fichier pour les ajouter aux métadonnées indexées par la solution logicielle Vitam.
Exemples :
- enrichissement de la description d’une image en ajoutant ses dimensions ;
- enrichissement de la description d’une vidéo en ajoutant ses coordonnées GPS.

L’*identification de formats* permet d’identifier ou de ré-identifier a posteriori des fichiers déjà transférés dans la solution logicielle Vitam.


### Mécanismes mis en œuvre en fonction de l’action de préservation lancée

||Création d’un objet|Mise à jour du groupe d’objets techniques|Mise à jour de l’unité archivistique|Mise à jour du registre des fonds|Rapport|
|:----|:----|:----|:----|:----|
|Génération de binaire|oui|oui||oui|oui|
|Identification|||||oui|
|Réidentification||oui|||oui|
|Analyse|||||oui|
|Extraction de métadonnées||oui|oui||oui|


Mise en place d’une politique de préservation
---
### Définition d’une politique de préservation
La politique de préservation d’une entité ne se limite pas à la question des formats des fichiers pris en charge, même si c’est en général le premier point qui est évoqué lorsqu’on parle de conservation des données numériques.

Une étude pilotée par le Service interministériel, en partenariat avec l’équipe Vitam et les ministères de la Culture, de l’Europe et des Affaires étrangères et des Armées au deuxième semestre 2018 a porté sur la définition du périmètre des services à prendre en compte dans le cadre d’une politique de préservation. Au-delà des aspects de conservation à proprement parler (politique de conservation et planification de la préservation, processus de pérennisation, restauration), la politique de préservation concerne également les fonctions d’entrée et d’accès aux archives.

L’étude, dont les résultats sont disponibles sur le site internet France Archives, propose une modélisation des processus, sous-processus et actions à mettre en œuvre pour assurer la pérennisation des données versées dans un système d’archivage électronique. Cette modélisation est accompagnée des profils à mobiliser pour chacun des processus (archiviste, développeur, administrateur système…), détaillés sous forme de schéma et de tableau, afin de faciliter dans un contexte donné le recensement des compétences indispensables à la mise en œuvre d’une stratégie de pérennisation des données numériques.

Ces livrables proposent un socle de réflexion sur la pérennisation des données numériques qui peut servir de référence pour identifier dans une structure quels processus sont ou non mis en œuvre, quelles compétences sont mobilisables mais aussi à quels risques s’expose une structure en l’absence de stratégie de pérennisation, autant d’éléments qui peuvent constituer un argumentaire précieux auprès des instances de décision.


### Choix des outils à mettre en œuvre
Dans la solution logicielle Vitam, les actions de préservation sont réalisées par des outils logiciels interfacés avec la solution logicielle Vitam appelés griffons. Ces griffons sont capables de prendre un lot d’objets et de retourner un fichier de résultat ou un lot d’objets générés.

Plusieurs griffons sont proposés avec la solution logicielle Vitam et peuvent être installés à l’initialisation de la plate-forme. Il est également possible à un service d’installer ses propres griffons, en fonction de ses besoins de préservation et de la nature des objets techniques à préserver (fichiers bureautiques, fichiers 2D ou 3D, fichiers son ou vidéo…).

L’installation des griffons est une opération d’administration technique.

Les griffons sont référencés et administrés au moyen du référentiel des griffons.


### Définition de scénarios de préservation
Les scénarios de préservation permettent de spécifier une action de préservation à mettre en œuvre, le griffon à utiliser en fonction des formats d’objets techniques à traiter et les traitements à exécuter par le griffon.

Un scénario de préservation peut être comparé à une recette de cuisine qui indique, en fonction du type d’ingrédient, l’instrument à utiliser et la méthode de cuisson à retenir.

Les scénarios de préservation sont référencés et administrés au moyen du référentiel des scénarios de préservation.


### Tests des fonctionnalités de préservation
Les griffons proposés avec la solution logicielle Vitam ont été jugés intéressants en termes de fonctionnalités couvertes, tant sur les actions de préservation que sur les formats pris en charge. Pour autant, le résultat des traitements effectués avec ces griffons doit systématiquement être évalué sur des données réelles avant toute généralisation de leur utilisation en production.

Une opération de préservation a des conséquences lourdes. Elle ne doit pas être lancée sans avoir fait au préalable l’objet de tests sur des échantillons représentatifs des données réelles qui seront traitées dans la solution logicielle Vitam.

Avant toute opération de préservation, il est recommandé que : 

|Qui ?|Quoi ?|
|:----|:----|
|Administrateur fonctionnel|- identifie les objets à préserver, détermine l’opération de préservation qu’il veut mettre en œuvre et l’outil qu’il souhaite utiliser|
|Administrateur technique|- vérifie si le griffon que l’on souhaite solliciter est installé et disponible dans la solution logicielle Vitam.<br>- le cas échéant, installe le griffon|
|Administrateur technique et/ou fonctionnel|- vérifie si le griffon est référencé dans le référentiel des griffons ;<br>- le cas échéant, ajoute le griffon dans le référentiel des griffons|
|Administrateur technique et fonctionnel|- crée un scénario de préservation utilisant le griffon en question|
|Administrateur fonctionnel et technique|- teste l’opération de préservation sur un environnement de test ;<br>- en fonction du résultat des tests, modifie le scénario de préservation et/ou le griffon utilisé ;<br>- intègre le scénario de préservation validé en production|


Pour en savoir plus, consulter le [document VITAM. Gestion de la préservation](./preservation).