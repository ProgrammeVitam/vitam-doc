Le référentiel des formats dans la solution logicielle Vitam
===
L’identification du format des fichiers constitue une donnée essentielle du système d’archivage électronique pour maîtriser les formats reconnus et manipulables dans le système.<br>
Le référentiel des formats permet de consulter les formats de fichiers susceptibles d’être pris en charge par la solution logicielle Vitam et de contrôler que les opérations de préservation s’appuient sur une information normalisée et fiable.


Présentation du référentiel des formats
---
### Périmètre du référentiel des formats
Le référentiel des formats est valable pour la plate-forme. Il est dit trans-tenant.


### Contrôles effectués à partir du référentiel des formats
Le référentiel des formats permet de déclarer un format d’une façon normalisée.
Les identifiants des formats sont utilisés dans la solution logicielle Vitam :
- dans les contrats d’entrée, pour indiquer les formats autorisés en entrée ;
- dans les scénarios de préservation, pour indiquer le format à traiter et, pour une conversion, le format cible ;
- dans la recherche de groupes d’objets techniques ;
- dans les métadonnées des objets techniques, pour indiquer le format du fichier pris en charge.

Pour les contrats d’entrée et les scénarios de préservation, la présence de l’identifiant du format dans le référentiel est contrôlé. Si l’identifiant n’est pas présent, la création ou la modification du contrat d’entrée ou du scénario de préservation est rejetée.


### Gestion des formats de fichiers en entrée
Lors du processus d’entrée, la solution logicielle Vitam procède à une identification fine du format des fichiers au moyen d’un outil d’identification (Siegfried) qui utilise le registre PRONOM. En cas d’incohérence avec le format déclaré dans le bordereau de transfert, c’est le format identifié par l’outil Siegfried qui sera pris en compte dans la solution logicielle Vitam.<br>
En fonction des paramètres définis dans le contrat d’entrée, la solution logicielle vérifie en outre si les fichiers non identifiés sont ou non acceptés ; la solution logicielle vérifie également si les fichiers ont un format identifié qui fait partie de la liste des formats acceptés.<br>
L’entrée est alors acceptée ou rejetée.<br>
En cas d’acceptation de l’entrée, les identifiants des formats remontés par l’outil d’identification sont enregistrés dans les métadonnées des objets techniques.

L’identifiant de format remonté par l’outil d’identification Siegfried doit figurer dans le référentiel des formats de la solution logicielle Vitam pour éviter les incohérences en base. Il est donc nécessaire que la version du registre PRONOM utilisée par l’outil d’identification soit la même que celle utilisée par le référentiel des formats.


Configuration du référentiel des formats
---
### Constitution du référentiel des formats
La solution logicielle Vitam utilise comme référentiel des formats le registre PRONOM développé par les archives nationales britanniques (The National Archives – UK), principale ressource disponible en ligne sur les formats de fichiers connus, notamment en raison de la fiabilité du mode d’identification proposé.
De ce registre, la solution logicielle Vitam ne retient actuellement que les éléments exposés sous forme réutilisable par The National Archives :
- informations liées à la version et à la date de création du fichier de signatures,
- informations correspondant aux formats.

Le référentiel de la solution logicielle Vitam ne décrit que les formats connus et référencés dans PRONOM.

Il n’est pas possible d’utiliser la solution logicielle Vitam sans utiliser le référentiel PRONOM.


### Gestion des identifiants des formats
Le référentiel des formats fonctionne en mode « esclave ». C’est donc l’outil externe qui permet de le piloter qui gère les identifiants des différents formats.


### Formalisation du référentiel des formats
Le registre PRONOM prend la forme d’un fichier xml, appelé « fichier de signatures ».
Pour en savoir plus sur la modélisation de ce fichier, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).


### Import du référentiel des formats
Le référentiel des formats utilisé par la solution logicielle Vitam est automatiquement importé lors de l’initialisation de la plate-forme.<br>
L’import d’un référentiel des formats est un acte d’administration technique.


Modification du référentiel des formats
---
Le référentiel des formats ne peut pas être mis à jour unitairement (pour un format uniquement). Il convient d’importer un nouveau fichier xml contenant l’ensemble des champs obligatoires du registre PRONOM en mode « annule et remplace ».

Lors d’une mise à jour du référentiel, des contrôles sont effectués sur la version du registre PRONOM.<br>
La mise à jour est en succès avec avertissement si :
- elle met un jour un référentiel dont la version est identique à la version du référentiel précédemment importé ;
- elle met à jour un référentiel dont la version est antérieure à celle du référentiel précédemment importé ;
- elle met à jour un référentiel dont la date de création est antérieure à la date de création du référentiel préalablement importé.

*Point d’attention :* La version du nouveau référentiel doit être identique à celle qui est importée dans l’outil Siegfried. Toute mise à jour du référentiel des formats doit être accompagnée d’une mise à jour du fichier de signatures importé dans cet outil au moyen d’un acte d’administration technique.

Les différentes versions du référentiel font l’objet d’une sauvegarde sur les offres de stockage.


Pour aller plus loin, consulter le [document VITAM. Gestion de la préservation](./preservation.md).