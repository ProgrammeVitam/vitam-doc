Les profils d’unité archivistique dans la solution logicielle Vitam
====

Le profil d’unité archivistique permet de définir la syntaxe, la sémantique et les règles de gestion applicables à une unité archivistique, en entrée et tout au long de sa prise en charge par le système.  
La solution logicielle Vitam permet de disposer d’un référentiel des profils utilisables.


Présentation du référentiel des profils d’unité archivistique
----
### Périmètre du référentiel des profils d’unité archivistique
Le référentiel des profils d’unité archivistique est propre au tenant sur lequel il a été importé.


### Contrôles effectués
#### En entrée
La solution logicielle Vitam vérifie que les unités archivistiques déclarant, dans le bordereau de transfert, un profil d’unité archivistique sont conformes à ce dernier.  
Si l’une d’entre elles n’est pas conforme à son profil d’unité archivistique, l’entrée sera rejetée.  
Le profil d’unité archivistique est déclaré au moyen de son identifiant dans le référentiel des profils d’unité archivistique dans les blocs <ArchiveUnit> pour chaque unité archivistique qui le nécessite.

#### En modification
La solution logicielle Vitam permet :
- de modifier les métadonnées d’une unité archivistique déclarant un profil d’unité archivistique, en contrôlant que l’unité archivistique reste conforme au profil d’unité archivistique qu’elle déclare (pas de suppression des métadonnées obligatoires par exemple) ;
- d’ajouter un profil d’unité archivistique à une unité archivistique déjà prise en charge dans le système, en contrôlant que l’unité archivistique est bien conforme au profil d’unité archivistique auquel on souhaite l’associer (vérification que les champs définis dans le profil d’unité archivistique à associer sont bien présents avec la cardinalité voire les valeurs attendues) ;
- de remplacer le profil d’unité archivistique associé à l’unité archivistique, en contrôlant que l’unité archivistique est bien conforme au nouveau profil d’unité archivistique auquel on souhaite l’associer (vérification que les champs définis dans le profil d’unité archivistique à associer sont bien présents avec la cardinalité voire les valeurs attendues).
Le profil d’unité archivistique est déclaré au moyen de son identifiant dans le référentiel des profils d’unité archivistique dans les métadonnées de gestion des unités archivistiques.

L’application doit disposer dans son contrat d’accès de droits de mise à jour étendus aux métadonnées de gestion pour pouvoir associer en gestion un profil d’unité archivistique ou le supprimer.


Configuration du référentiel des profils d’unité archivistique
---
### Constitution des profils d’unité archivistique
Les profils d’unité archivistique ne sont pas obligatoires pour effectuer des entrées sur la plate-forme.
Néanmoins, l’administrateur fonctionnel pourra souhaiter définir des profils d’unité archivistique pour :
- faciliter les contrôles sur les transferts d’archives, à l’échelle des unités archivistiques,
- effectuer un contrôle supplémentaire sur les transferts reçus et leur contenu par rapport aux contrôles par défaut en entrée, ce qui est un gage de qualité des données,
- imposer un modèle de description identique sur une typologie particulière, quel que soit son contexte de production,
- faciliter la recherche d’unités archivistiques, voire spécifier un filtre de recherche propre à un profil d’unité archivistique en particulier,
- s’assurer que les métadonnées obligatoires pour une typologie de documents ne pourront pas être supprimées en gestion dans le système ou modifiées quand une valeur spécifique est attendue.

Le profil d’unité archivistique est spécifique à une unité archivistique. Il ne permet pas de contrôler la structure de l’entrée, ni la structure interne des dossiers (nombre de sous-dossiers attendus), contrairement au profil d’archivage.
Le profil d’unité archivistique peut être utilisé dans un profil d’archivage pour spécifier des types particuliers d’unité archivistique, en plus du contrôle sur la structuration globale du versement effectué par le profil d’archivage.

Un profil d’unité archivistique peut être utilisé pour contrôler de manière très précise la description d’archives dont l’archiviste maîtrise bien la structure et les métadonnées attendues. En ce cas, le profil rendra obligatoires les métadonnées attendues et pourra spécifier les valeurs de ces métadonnées. Il pourra interdire la présence d’autres métadonnées.
Un profil d’unité archivistique peut également être utilisé pour des types ou catégories d’archives dont la structuration précise ne peut être définie par défaut (absence de connaissance a priori du nombre de niveaux dans l’arborescence), comme des documents bureautiques, pris isolément. De même, il peut être utilisé pour des documents structurés mais décrits de manière non uniforme, comme des boîtes de messagerie. Dans ces deux cas, l’archiviste définira un profil assez générique et qui permet une souplesse dans les métadonnées attendues.

Un profil d’unité archivistique peut s’utiliser indifféremment dans différents contextes de production. Par exemple, un profil détaillant les attendus pour un acte de naissance peut être utilisé pour décrire ce document dans un dossier de carrière, mais également dans un dossier de pension ou un dossier scolaire.

Contrairement au profil d’archivage, les profils d’unité archivistique accompagnent les unités archivistiques tout au long de leur prise en charge dans la solution logicielle Vitam et permettent de contrôler les données, leur sémantique et leur syntaxe lors d’une éventuelle mise à jour des unités archivistiques ou de leurs règles de gestion associées.
Cela permet de s’assurer que des métadonnées essentielles à la recherche ne sont pas supprimées lors d’une mise à jour (par exemple, le matricule pour un dossier d’agent).


### Transposition des outils existants
Des profils d’unité archivistique peuvent être définis à tout niveau de l’arborescence : dossier, sous-dossier, pièce.

Définir un profil d’unité archivistique nécessite une analyse préalable des données à archiver, type de document par type de document. Il s’agit de connaître :
- les types de documents rencontrés (ex : documents bureautiques, factures, messages électroniques…),
- les métadonnées associées à ces documents, permettant de les identifier, de les gérer et de les retrouver après transfert dans le système d’archivage électronique.

Les profils d’unité archivistique doivent se conformer :
- aux règles émises par le SEDA ; ainsi, ils peuvent émettre des règles plus strictes que celles du SEDA (mais pas des règles moins strictes) et rendre obligatoire l’utilisation de certains éléments et/ou valeurs ;
- aux vocabulaires définis dans l’ontologie.

Pour rassembler les informations à faire figurer dans les profils d’unité archivistique de niveau dossier, l’administrateur fonctionnel peut s’appuyer sur les bordereaux de versement pour des filières particulières qui définissent très précisément les informations attendues.

#### Illustration pour un niveau dossier

Champs attendus dans le bordereau de transfert des dossiers de personnel

|Nom|Prénom|Date de naissance|Matricule|Corps|Grade|Nombre d’enfants|Date de départ en retraite|Décorations|
|:----|:----|:----|:----|:----|:----|:----|:----|:----|
||||||||||

Le profil d’unité archivistique peut :
- rendre obligatoire ou non la présence de tous ces champs (pour leur formalisation, voir le [vademecum ontologie](./Vademecum_ontologie.md)) ;
- préciser si ces champs sont répétables ou non ; on pourrait ici n’accepter qu’un seul matricule alors que le SEDA rend cette information répétable ;
- rendre obligatoire la présence de certaines métadonnées de gestion, par exemple, dans ce cas, la présence d’une règle de communicabilité correspondant au délai de communicabilité de 50 ans.

#### Illustration pour un niveau pièce

Le niveau « pièce » est assez rarement défini actuellement dans les outils dont disposent les services d’archives. 
L’administrateur fonctionnel qui souhaiterait contrôler les métadonnées d’une pièce au moyen d’un profil d’unité archivistique pourra étudier la manière dont une même pièce est décrite dans les différents SI et définir ainsi les métadonnées à renseigner systématiquement ou de manière facultative.

Exemple pour un courrier :

|Champ|Application GEC|Application subvention|Application réclamations client|Transposition dans l’AUP|
|:----|:----|:----|:----|:----|
|Date|Oui|Non|Oui|Facultatif|
|Date de réception|Oui|Oui|Oui|Obligatoire|
|Auteur|Oui|Oui|Oui|Obligatoire|
|Destinataire|Oui|Non|Non|Facultatif|
|Objet|Oui|Non|Oui|Facultatif|
|Position dans le plan de classement|Oui|Non|Non|Facultatif|
|Type de subvention|Non|Oui|Non|Facultatif|
|Service concerné par la réclamation|Non|Non|Oui|Facultatif|

En s’en tenant au plus petit dénominateur commun, l’administrateur fonctionnel permettra la réutilisation large du profil d’unité archivistique, quel que soit le contexte de production, mais limitera les contrôles possibles. À l’inverse, en rendant obligatoire un plus grand nombre de métadonnées, l’administrateur fonctionnel gagnera en qualité des données, mais le profil d’unité archivistique sera moins réutilisable dans différents contextes.


### Gestion des identifiants des profils d’unité archivistique
À l’installation de la plate-forme Vitam, l’administrateur technique peut configurer le tenant pour que les identifiants des profils d’unité archivistique soient générés par Vitam (mode « maître ») ou par le front-office (mode « esclave »).
Le mode esclave est intéressant si les profils d’unité archivistique sont générés dans le front office qui leur attribue un identifiant que l’on souhaite pouvoir suivre.


### Formalisation du référentiel
Le référentiel des profils d’unité archivistique se compose de notices descriptives au format JSON qui incluent nativement un schéma de contrôle au format JSON ou auxquelles il est possible d’associer a posteriori un schéma de contrôle au format JSON.

L’import d’une notice seule ne suffit pas pour utiliser un profil d’unité archivistique dans la solution logicielle Vitam. Il est nécessaire, après cette opération, d’ajouter le schéma de contrôle correspondant au profil d’unité archivistique lui-même et de l’associer à la notice qui le référence, afin qu’il soit pris en compte dans la solution logicielle Vitam.

Les schémas de contrôle permettent de valider des contenus exprimés au format JSON, format de structuration des données dans la solution logicielle Vitam.

Actuellement, il n’existe ni outil ni interface pour générer automatiquement un schéma de contrôle associé à un profil d’unité archivistique au format JSON. L’administrateur fonctionnel devra se rapprocher du service informatique pour établir ces schémas.

La notice descriptive est composée des éléments suivants :

- Éléments obligatoires
      - identifiant de la notice qui peut être attribué au profil d’unité archivistique, généré automatiquement par la solution logicielle Vitam ou par l’application à l’origine de sa création
      - nom du profil d’unité archivistique
      - statut « Actif » ou « Inactif » ; par défaut, le statut est « Inactif »
      - schéma de contrôle, champ obligatoire, mais pouvant être vide (ControlSchema).
            - Il est destiné à contenir l’ensemble des éléments qui feront l’objet d’un contrôle en entrée ou en mise à jour ;
            - Les éléments (ou propriétés) qu’il définit doivent se conformer aux vocabulaires définis dans l’ontologie, que ce soit en termes de nommage ou de typage.
- Éléments facultatifs
      - description du profil d’unité archivistique
      - date d’activation
      - date de désactivation

Pour en savoir plus, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).

Il est possible d’importer, en une seule fois, un référentiel complet, comprenant plusieurs notices  décrivant chacune un profil d’unité archivistique. La solution logicielle Vitam ne comptabilisera qu’une seule opération et ne prendra pas en compte dans le journal des opérations la création unitaire des différents items compris dans le référentiel importé.

Afin d’optimiser la traçabilité de la création des différentes notices, il est recommandé de créer ces dernières une par une.

À chaque notice descriptive, il est possible d’associer un seul profil d’unité archivistique ou schéma de contrôle.
Lors de l’import du schéma de contrôle, la solution logicielle Vitam vérifie que le schéma est compatible avec l’ontologie, c’est-à-dire que les vocabulaires déclarés dans le schéma de contrôle existent dans l’ontologie.


### Activation du profil d’unité archivistique
Un profil d’unité archivistique peut être importé avec un statut inactif ou être désactivé lors d’une mise à jour du profil d’unité archivistique.
Pour pouvoir être utilisé pour effectuer des contrôles en entrée ou lors d’une modification de métadonnées des unités archivistiques, un profil d’unité archivistique doit avoir un statut « actif » dans le référentiel des profils d’unité archivistique.

Si le profil n’a pas un statut « actif », les versements déclarant ce profil seront rejetés. De même, les modifications des unités archivistiques déclarant ce profil ou l’association de ce profil à une unité archivistique ne seront pas possibles.


Modification du référentiel des profils d’unité archivistique
---
La modification des champs des notices décrivant les profils d’unité archivistique est possible. Cette action provoque la création d’une nouvelle version de la notice modifiée. Elle fait l’objet d’une journalisation dans le journal des opérations.

La solution logicielle Vitam permet de modifier la notice de profil d’unité archivistique ou son schéma de contrôle, tant que ce dernier n’est pas utilisé par une unité archivistique. S’il l’est, il n’est plus possible de le modifier.


Pour aller plus loin, consulter le [document VITAM. Profils d’unité archivistique](./profil_unite_archivistique.md).