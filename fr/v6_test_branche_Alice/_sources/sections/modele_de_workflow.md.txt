Description des workflows et des opérations
===========================================

Objectif du document
--------------------

Ce document a pour objectif de présenter les différents processus employés par la solution logicielle Vitam. Il est destiné aux administrateurs aussi bien techniques que fonctionnels, aux archivistes souhaitant avoir une connaissance plus avancée du logiciel ainsi qu’aux développeurs.

Il explicite chaque processus (appelé également « workflow »), et pour chacun leurs tâches, traitements et actions.

Ce document comprend du matériel additionnel pour faciliter la compréhension des processus comme des fiches récapitulatives et des schémas. Il explique également la manière dont est formée la structure des fichiers de workflow.


gestion du cycle de vie des archives
------------------------------------

Cette seconde partie du document détail les workflows suivants :

-   Entrée
-   Mise à jour unitaire
-   Mise à jour de masse
-   Mise à jour unitaire de masse (bulk update)
-   Export DIP
-   Élimination
-   Modification d’arborescence
-   Transfert
-   Restauration de métadonnées essentielles

### Ingest

Cette section décrit le processus (workflow) d’entrée, utilisé lors du transfert d’un Submission Information Package (SIP) dans la solution logicielle Vitam. Ce workflow se décompose en deux grandes catégories : le processus d’entrée externe dit « ingest externe » et le processus d’entrée interne dit « ingest interne ». Le premier prend en charge le SIP et effectue des contrôles techniques préalables, tandis que le second débute dès le premier traitement métier. Ex: Le processus d’entrée externe
comprend l’étape : STP_SANITY_CHECK_SIP (Contrôle sanitaire du SIP). Les autres étapes font partie du processus d’entrée interne.

Toutes les étapes, tâches et traitements sont journalisés dans le journal des opérations et décrivent le processus (clé et description de la clé associée dans le journal des opérations) tel qu’implémenté dans la version actuelle de la solution logicielle Vitam.


#### Processus des contrôles préalables à l’entrée (STP_SANITY_CHECK_SIP)

##### Contrôle sanitaire du SIP SANITY_CHECK_SIP (IngestExternalImpl.java)

-   **Règle** : tâche consistant à vérifier l’absence de virus dans le SIP

-   **Type** : bloquant

-   **Statuts** :

    -   OK : aucun virus n’a été détecté dans le SIP (SANITY\_CHECK\_SIP.OK = Succès du processus des contrôles préalables à l’entrée)

    -   KO : un ou plusieurs virus ont été détectés dans le SIP (SANITY\_CHECK\_SIP.KO = Échec du processus des contrôles préalables à l’entrée)

    -   FATAL : une erreur technique est survenue lors de la vérification de la présence de virus dans le SIP (SANITY\_CHECK\_SIP.FATAL = Erreur technique lors du processus des contrôles préalables à l’entrée)

##### Contrôle du format du conteneur du SIP CHECK_CONTAINER (IngestExternalImpl.java)

-   **Règle** : tâche consistant à vérifier le format du SIP via un outil d’identification de format qui se base sur le référentiel des formats qu’il intègre

    **Formats acceptés** : .zip, .tar, .tar.gz, .tar.bz2 et tar.gz2

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le conteneur du SIP est au bon format (CHECK\_CONTAINER.OK = Succès du contrôle du format du conteneur du SIP)

    -   KO : le conteneur du SIP n’est pas au bon format (CHECK\_CONTAINER.KO = Échec du contrôle du format du conteneur du SIP)

    -   FATAL : une erreur technique est survenue lors de la vérification du format du conteneur du SIP, liée à l’outil d’identification des formats (CHECK\_CONTAINER.FATAL = Erreur technique lors du contrôle du format du conteneur du SIP)

##### Contrôle du nom du bordereau de transfert MANIFEST_FILE_NAME_CHECK (IngestExternalImpl.java)

-   **Règle** : tâche consistant à vérifier le nom du bordereau de transfert. Le nom du bordereau doit être conforme avec l’expression régulière suivante :

    \^((\[a-zA-Z0-9\]{1,56}\[\_-\]{1}){0,1}|\_{0,1})(manifest.xml)\\b »} A savoir : une chaîne de caractères débutant par des caractères alphanumériques sans accent, jusqu’à 56 caractères, suivi d’un « - » ou d’un « \_ » puis suivi de « manifest.xml ». Exemples valides : « MonNouveau-manifest.xml », « UnAutreBordereau\_manifest.xml ». « manifest.xml » tout court est également valide. Un SIP ne possédant pas du tout de bordereau de transfert verra également son entrée terminer en KO à cette
    tâche.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le nom du bordereau de transfert est conforme (MANIFEST\_FILE\_NAME\_CHECK.OK = Succès du contrôle du nom du bordereau de transfert : nom du fichier conforme)

    -   KO : le nom du bordereau de transfert n’est pas conforme (MANIFEST\_FILE\_NAME\_CHECK.KO = Échec du contrôle du nom du bordereau de transfert : nom du fichier non conforme)

    -   FATAL : une erreur technique est survenue lors de la vérification du nom du bordereau de transfert (MANIFEST\_FILE\_NAME\_CHECK.FATAL = Erreur technique lors du contrôle du nom du bordereau de transfert)

##### Vérification de l’intégrité du bordereau de transfert MANIFEST\_DIGEST\_CHECK (IngestExternalImpl.java)

-   **Règle** : tâche consistant à vérifier l’empreinte du bordereau de transfert calculée par la solution logicielle Vitam et celle déclarée dans le bordereau. Si l’empreinte déclarée dans le bordereau de transfert n’a pas été calculée avec l’algorithme SHA-512, alors l’empreinte est recalculée avec cet algorithme. Elle sera alors enregistrée dans la solution logicielle Vitam.

    **Algorithmes autorisés en entrée** : MD5, SHA-1, SHA-256, SHA-512

-   **Type** : bloquant

-   **Statuts** :

    -   KO : L’empreinte du bordereau de transfert n’est pas conforme (MANIFEST\_DIGEST\_CHECK.KO=Échec du contrôle de l''empreinte du bordereau de transfert : fichier non conforme)

    -   FATAL : Une erreur technique est survenue lors du contrôle de l’empreinte (MANIFEST\_DIGEST\_CHECK.FATAL=Erreur technique lors du contrôle de l''empreinte du bordereau de transfert)

#### Processus de réception du SIP dans Vitam STP\_UPLOAD\_SIP (IngestInternalResource.java)

-   **Règle** : étape consistant à vérifier la bonne réception du SIP sur l’espace de travail interne (« workspace »)

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le SIP a été réceptionné sur l’espace de travail interne (STP\_UPLOAD\_SIP.OK = Succès du processus de réception du SIP)

    -   KO : le SIP n’a pas été réceptionné sur l’espace de travail interne (STP\_UPLOAD\_SIP.KO = Échec du processus de réception du SIP)

    -   FATAL : une erreur technique est survenue lors de la réception du SIP dans la solution logicielle Vitam, par exemple suite à une indisponibilité du serveur (STP\_UPLOAD\_SIP.FATAL = Erreur technique lors du processus de réception du SIP)

#### Processus de contrôle du SIP (STP\_INGEST\_CONTROL\_SIP)

##### Vérification globale du CHECK\_SEDA (CheckSedaActionHandler.java)

-   **Règle** : tâche consistant à vérifier la cohérence physique du SIP reçu par rapport au modèle de SIP accepté

    **Type de SIP accepté** : le bordereau de transfert, obligatoire dans le SIP, doit être conforme au schéma xsd par défaut fourni avec le standard SEDA v. 2.1, le SIP doit satisfaire les exigences du document « Structuration des SIP » et doit posséder un répertoire unique nommé « Content ».

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le SIP est présent et conforme au schéma xsd par défaut fourni avec le standard SEDA v.2.1. il satisfait aux exigences de « structuration des SIP » et possède un repertoire unique « Content » (CHECK\_SEDA.OK = Succès de la vérification globale du SIP)

    -   KO :

        -   Cas 1 : le bordereau de transfert est introuvable dans le SIP ou n’est pas au format XML (CHECK\_SEDA.NO\_FILE.KO = Absence du bordereau de transfert ou bordereau de transfert au mauvais format)

        -   Cas 2 : le bordereau de transfert n’est pas au format XML (CHECK\_SEDA.NOT\_XML\_FILE.KO = Échec de la vérification globale du SIP : bordereau de transfert non conforme aux caractéristiques d’un fichier xml)

        -   Cas 3 : le bordereau de transfert ne respecte pas le schéma par défaut fourni avec le standard SEDA 2.1 (CHECK\_SEDA.NOT\_XSD\_VALID.KO = Échec de la vérification globale du SIP : bordereau de transfert non conforme au schéma SEDA 2.1)

        -   Cas 4 : le SIP contient plus d’un dossier « Content » (CHECK\_SEDA.CONTAINER\_FORMAT.DIRECTORY.KO = Échec de la vérification globale du SIP : le SIP contient plus d’un dossier ou un dossier dont le nommage est invalide)

        -   Cas 5 : le SIP contient plus d’un seul fichier à la racine (CHECK\_SEDA.CONTAINER\_FORMAT.FILE.KO = Échec de la vérification globale du SIP : le SIP contient plus d’un fichier à sa racine)

        -   Cas 6 : l’action est déjà exécutée CHECK\_SEDA.ALREADY\_EXECUTED = Action déjà exécutée : Pas de vérification globale du SIP

    -   FATAL :

        -   Cas 1 : une erreur technique est survenue lors de la vérification globale du SIP (CHECK\_SEDA.FATAL = Erreur technique lors de la vérification globale du SIP)

        -   Cas 2 : une erreur technique est survenue lors de la vérification globale du SIP (CHECK\_SEDA.NOT\_XML\_FILE.FATAL=Erreur technique lors de la vérification globale du SIP)

        -   Cas 3 : une erreur technique est survenue lors de la vérification globale du SIP (CHECK\_SEDA.NOT\_XSD\_VALID.FATAL=Erreur technique lors de la vérification globale du SIP)

##### Vérification de l’en-tête du bordereau de transfert CHECK\_HEADER (CheckHeaderActionHandler.java)

-   **Règles** : tâche permettant de vérifier les informations générales du bordereau de transfert (nommées « header » dans le fichier « manifest.xml ») et de l’existence du service producteur (OriginatingAgencyIdentifier)

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les informations du bordereau de transfert sont conformes et le service producteur est déclaré (CHECK\_HEADER.OK = Succès de la vérification générale du bordereau de transfert)

    -   KO :

        -   Cas 1 : les informations du bordereau de transfert ne sont pas conformes ou il n’y a pas de service producteur déclaré (CHECK\_HEADER.KO = Échec de la vérification générale du bordereau de transfert)

        -   Cas 2 : les données référentielles sont inactives (CHECK\_HEADER.INACTIVE.KO = Échec de la vérification générale du bordereau de transfert : donnée référentielle inactive)

        -   Cas 3 : les données référentielles sont inconnues (CHECK\_HEADER.UNKNOWN.KO = Échec de la vérification générale du bordereau de transfert : donnée référentielle inconnue)

        -   Cas 4 : il y a une différence entre le profil déclaré dans le bordereau de transfert et celui déclaré dans le contrat (CHECK\_HEADER.DIFF.KO = Échec de la vérification générale du bordereau de transfert : différence entre le profil déclaré dans le bordereau de transfert et celui déclaré dans le contrat)

        -   Cas 5 : un des champs obligatoires n’est pas remplie (CHECK\_HEADER.EMPTY\_REQUIRED\_FIELD.KO = Vérification générale du bordereau de transfert : champ obligatoire vide)

        -   Cas 6 : la vérification a déjà été effectuée (CHECK\_HEADER.ALREADY\_EXECUTED = Action déjà exécutée : pas de vérification générale du bordereau de transfert)

    -   FATAL : une erreur technique est survenue lors des contrôles sur les informations générales du bordereau de transfert (CHECK\_HEADER.FATAL = Erreur technique lors de la vérification générale du bordereau de transfert)

**La tâche check\_header contient les traitements suivants :**


##### Vérification de la présence et contrôle des services agents CHECK_HEADER.CHECK_AGENT

Ce traitement n’est exécuté que si la valeur IN de *checkOriginatingAgency* est « true ».

-   **Règle** : traitement consistant à vérifier le service producteur ainsi que le service versant déclarés dans le SIP par rapport au référentiel des services agents présent dans la solution logicielle Vitam

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le service producteur et, le cas échéant, le service versant déclarés dans le SIP est valide (service agent existant dans le référentiel des services agents)(CHECK\_HEADER.CHECK\_AGENT.OK = Succès de la vérification de la présence et du contrôle des services agents)

    -   KO :

        -   Cas 1 : aucun service producteur n’est déclaré dans la balise dédiée dans le bordereau de transfert (CHECK\_HEADER.CHECK\_AGENT.EMPTY\_REQUIRED\_FIELD.KO = Échec de la vérification de la présence et du contrôle des services agents : champ obligatoire vide)

        -   Cas 2 : le service producteur et, le cas échéant, le service versant déclarés dans le SIP n’est pas connu du référentiel des services agents (CHECK\_HEADER.CHECK\_AGENT.UNKNOWN.KO = Échec de la vérification de la présence et du contrôle des services agents : services agents inconnus du référentiel des services agents)

        -   Cas 3 : la balise permettant de déclarer un service producteur est absente du bordereau de tranfert (CHECK\_HEADER.CHECK\_AGENT.KO = Échec de la vérification de la présence et du contrôle des services agents)

    -   FATAL : une erreur technique est survenue lors de la vérification de la présence et du contrôle des services agents (CHECK\_HEADER.CHECK\_AGENT.FATAL = Erreur technique lors de la vérification de la présence et du contrôle des services agents)

##### Vérification de la présence et contrôle du contrat d’entrée CHECK\_HEADER.CHECK\_CONTRACT\_INGEST

Ce traitement n’est exécuté que si la valeur IN de *checkContract* est « true ».

-   **Règle** : traitement consistant à vérifier le contrat d’entrée déclaré dans le SIP par rapport au référentiel des contrats d’entrée présent dans la solution logicielle Vitam

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le contrat déclaré dans le SIP existant dans le référentiel des contrats d’entrée de la solution logicielle Vitam et est actif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.OK = Succès de la vérification de la présence et du contrôle du contrat d’entrée)

    -   KO :

        -   Cas 1 : le contrat d’entrée déclaré dans le SIP est inexistant (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTRACT\_UNKNOWN.KO = Échec de la vérification de la présence du contrat d’entrée : contrat d’entrée inconnu du référentiel des contrats d’entrée)

        -   Cas 2 : le contrat d’entrée déclaré dans le SIP est inactif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTRACT\_INACTIVE.KO = Échec de la vérification du caractère actif du contrat d’entrée)

        -   Cas 3 : aucun contrat d’entrée n’a été trouvé dans le manifeste (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTRACT\_NOT\_IN\_MANIFEST.KO = Échec de la vérification de la présence du contrat d’entrée : le champ ArchivalAgreement est absent du bordereau de transfert)

        -   Cas 4 : le contrat d’entrée déclaré dans le SIP n’existe pas dans le contexte applicatif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTRACT\_NOT\_IN\_CONTEXT.KO = Échec du contrôle de la présence du contrat d’entrée dans le contexte applicatif)

        -   Cas 5 : le contexte applicatif est inexistant (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTEXT\_UNKNOWN.KO = Échec du contrôle de la présence du contexte applicatif : contexte inconnu du référentiel des contextes)

        -   Cas 6 : le contexte applicatif est inactif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTEXT\_INACTIVE.KO = Échec du contrôle du caractère actif du contexte applicatif)

        -   Cas 7 : erreur lors de la récupération du contexte applicatif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.CONTEXT\_CHECK\_ERROR.KO = Échec de la vérification de la présence et du contrôle du contexte applicatif)

        -   Cas 8 : le contrat de gestion déclaré est inexistant CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.MANAGEMENT\_CONTRACT\_UNKNOWN.KO = Échec de la vérification de la présence du contrat de gestion déclaré dans le contrat d’entrée: contrat de gestion connu dans le référentiel des contrats de gestion

        -   Cas 9 : le contrat de gestion déclaré est inactif CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.MANAGEMENT\_CONTRACT\_INACTIVE.KO = Échec de la vérification de la présence du contrat de gestion déclaré dans le contrat d’entrée: contrat de gestion au statut inactif dans le référentiel des contrats de gestion

        -   Cas 10 : le contrat de gestion déclaré est invalide CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.MANAGEMENT\_CONTRACT\_INVALID.KO = Échec de la vérification de la présence du contrat de gestion déclaré dans le contrat d’entrée: échec de validation des stratégies de stockage déclarées dans le contrat de gestion

    -   FATAL : une erreur technique est survenue lors de la vérification de la présence et du contrôle du contrat d’entrée ou du contexte applicatif (CHECK\_HEADER.CHECK\_CONTRACT\_INGEST.FATAL = Erreur technique lors de la vérification de la présence et du contrôle du contrat d’entrée ou du contexte applicatif)

##### Vérification de la relation entre le contrat d’entrée et le profil d’archivage CHECK\_HEADER.CHECK\_IC\_AP\_RELATION

Ce traitement n’est exécuté que si la valeur IN de *checkProfile* est « true ».

-   **Règle** : traitement consistant à vérifier que le profil d’archivage déclaré dans le contrat d’entrée du SIP est le même que celui déclaré dans le bordereau de transfert.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le profil d’archivage déclaré dans le contrat d’entrée et celui déclaré dans le bordereau de transfert sont les mêmes (CHECK\_HEADER.CHECK\_IC\_AP\_RELATION.OK = Succès de la vérification de la relation entre le contrat d’entrée et le profil)

    -   KO :

        -   Cas 1 : le profil d’archivage déclaré dans le SIP est inexistant (CHECK\_HEADER.CHECK\_IC\_AP\_RELATION.UNKNOWN.KO = Échec du contrôle de la présence du profil d’archivage dans le référentiel des profils d’archivage)

        -   Cas 2 : le profil d’archivage déclaré dans le SIP est inactif (CHECK\_HEADER.CHECK\_IC\_AP\_RELATION.INACTIVE.KO = Échec du contrôle du caractère actif du profil d’archivage)

        -   Cas 3 : le profil d’archivage déclaré dans le contrat d’entrée et celui déclaré dans le bordereau de transfert ne sont pas les mêmes (CHECK\_HEADER.CHECK\_IC\_AP\_RELATION.DIFF.KO = Échec du contrôle de cohérence entre le profil d’archivage déclaré dans le bordereau de transfert et celui déclaré dans le contrat d’entrée)

    -   FATAL : une erreur technique est survenue lors de la vérification de la relation entre le contrat d’entrée et le profil d’archivage (CHECK\_HEADER.CHECK\_IC\_AP\_RELATION.FATAL = Erreur technique lors de la vérification de la relation entre le contrat d’entrée et le profil d’archivage)

##### Vérification de la conformité du bordereau de transfert par le profil d’archivage CHECK\_HEADER.CHECK\_ARCHIVEPROFILE

-   **Règle** : traitement consistant à vérifier que le bordereau de transfert du SIP est conforme aux exigences du profil d’archivage. Si aucun profil d’archivage ne s’applique au SIP, ce traitement est ignoré

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le bordereau de transfert est conforme aux exigences du profil d’archivage (CHECK\_HEADER.CHECK\_ARCHIVEPROFILE.OK = Succès de la vérification de la conformité au profil d’archivage)

    -   KO : le bordereau de transfert n’est pas conforme aux exigences du profil d’archivage (CHECK\_HEADER.CHECK\_ARCHIVEPROFILE.KO = Échec de la vérification de la conformité au profil d’archivage)

    -   FATAL : une erreur technique est survenue lors de la vérification du bordereau de transfert par rapport au profil d’archivage (CHECK\_HEADER.CHECK\_ARCHIVEPROFILE.FATAL = Erreur technique lors de la vérification de la conformité au profil d’archivage)

##### Préparation des informations de stockage PREPARE\_STORAGE\_INFO (PrepareStorageInfoActionHandler.java)

-   **Règle** : tâche consistant à récupérer les informations liées aux offres de stockage à partir des stratégies

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la récupération des informations de stockage a bien été effectuée (PREPARE\_STORAGE\_INFO.OK = Succès de la préparation des informations de stockage)

    -   KO : la récupération des informations de stockage n’a pas pu être effectuée (PREPARE\_STORAGE\_INFO.KO = Échec de la préparation des informations de stockage)

    -   FATAL : une erreur technique est survenue lors de la récupération des informations de stockage (PREPARE\_STORAGE\_INFO.FATAL = Erreur technique lors de la récupération des informations de stockage)

##### Vérification des objets et groupes d’objets CHECK\_DATAOBJECTPACKAGE

-   **Règle** : tâche consistant à vérifier les objets et groupes d’objets

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la vérification des objets et groupes d’objets à été effectué avec succès (CHECK\_DATAOBJECTPACKAGE.OK=Succès de la vérification des objets et groupes d’objets)

    -   KO : la vérification des objets et groupes d’objets n’a pu être effectué (CHECK\_DATAOBJECTPACKAGE.KO=Échec de la vérification des objets et groupes d’objets)

    -   FATAL : une erreur technique est servenue lors de la vérification des objets et groupes d’objets (CHECK\_DATAOBJECTPACKAGE.FATAL=Erreur technique lors de la vérification des objets et groupes d’objets)

        La tâche Check\_DataObjectPackage contient les traitements suivants :

##### Vérification des usages des groupes d’objets CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_DATAOBJECT\_VERSION (CheckVersionActionHandler.java)

-   **Règle** : traitement consistant à vérifier que tous les objets décrits dans le bordereau de transfert du SIP déclarent un usage conforme à la liste des usages acceptés dans la solution logicielle Vitam ainsi qu’un numéro de version respectant la norme de ce champ

-   **Types d’usages acceptés : **

    -   original papier (PhysicalMaster),

    -   original numérique (BinaryMaster),

    -   diffusion (Dissemination),

    -   vignette (Thumbnail),

    -   contenu brut (TextContent).

        Les numéros de versions sont optionnels, il s'agit d'un entier positif ou nul (0, 1, 2…).

        La grammaire est : « usage\_version ». Exemples : « BinaryMaster\_2 », « TextContent\_10 » ou sans numéro de versions « PhysicalMaster ».

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les objets contenus dans le SIP déclarent tous dans le bordereau de transfert un usage cohérent avec ceux acceptés et optionnellement un numéro de version respectant la norme de ce champ usage, par exemple « BinaryMaster\_2 » (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.DATAOBJECT.VERSION.OK = Succès de la vérification des usages des objets)

    -   KO :

        -   Cas 1 : un ou plusieurs BinaryMaster sont déclarés dans un ou plusieurs objets physiques (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_DATAOBJECT\_VERSION.PDO\_DATAOBJECTIONVERSION\_BINARYMASTER.KO = L’objet physique déclare un usage « BinaryMaster ». Cet usage n’est pas autorisé pour les objets physiques

        -   Cas 2 : un ou plusieurs PhysicalMaster sont déclarés dans un ou plusieurs objets binaires (CHECK\_DATAOBJECTPACKAGE.BDO\_DATAOBJECTIONVERSION\_PHYSICALMASTER.KO = Au moins un objet binaire déclare un usage « PhysicalMaster ». Cet usage n’est pas autorisé pour les objets binaires)

        -   Cas 3 : un ou plusieurs objets contenus dans le SIP déclarent dans le bordereau de transfert un usage ou un numéro de version incohérent avec ceux acceptés (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_DATAOBJECT\_VERSION.INVALID\_DATAOBJECTVERSION.KO = Cet objet déclare un usage incorrect. L’usage doit s’écrire sous la forme \[usage\] ou \[usage\]\_\[version\]. « Usage » doit être parmi l’énumération DataObjectVersion définie pour Vitam, « version » doit être un entier positif)

        -   Cas 4 : une ou plusieurs URI sont vides (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_DATAOBJECT\_VERSION.EMPTY\_REQUIRED\_FIELD.KO = Il existe au moins un champ non renseigné dont la valeur est obligatoire)

    -   FATAL : une erreur technique est survenue lors du contrôle des usages déclarés dans le bordereau de transfert pour les objets contenus dans le SIP (CHECK\_MANIFEST\_DATAOBJECT\_VERSION.FATAL = Erreur technique lors de la vérification des usages des objets)

##### Vérification du nombre d’objets CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER (CheckObjectsNumberActionHandler.java)

-   **Règle** : traitement consistant à vérifier que le nombre d’objets binaires reçus dans la solution logicielle Vitam et stocké dans l’espace de travail interne (« workspace ») est strictement égal au nombre d’objets binaires déclaré dans le manifeste du SIP

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le nombre d’objets reçus dans la solution logicielle Vitam est strictement égal au nombre d’objets déclarés dans le bordereau de transfert du SIP (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER.OK = Succès de la vérification du nombre d’objets)

    -   KO :

        -   Cas 1 : le nombre d’objets reçus dans la solution logicielle Vitam est supérieur au nombre d’objets déclaré dans le bordereau de transfert du SIP (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER.MANIFEST\_INFERIOR\_BDO.KO = Le bordereau de transfert déclare moins d’objets binaires qu’il n’en existe dans le répertoire Content du SIP)

        -   Cas 2 : le nombre d’objets reçus dans la solution logicielle Vitam est inférieur au nombre d’objets déclaré dans le bordereau de transfert du SIP (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER.MANIFEST\_SUPERIOR\_BDO.KO = Le bordereau de transfert déclare plus d’objets binaires qu’il n’en existe dans le répertoire Content du SIP)

        -   Cas 3 : une ou plusieurs balises URI déclarent un chemin invalide (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER.INVALID\_URI.KO = Au moins un objet déclare une URI à laquelle ne correspond pas de fichier ou déclare une URI déjà utilisée par un autre objet)

    -   FATAL : une erreur technique est survenue lors de la vérification du nombre d’objets (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_OBJECTNUMBER.FATAL = Erreur technique lors de la vérification du nombre d’objets)

##### Vérification de la cohérence du bordereau de transfert CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST (ExtractSedaActionHandler.java)

-   **Règle** : traitement consistant à :

    -   créer les journaux du cycle de vie des unités archivistiques et des groupes d’objets,

    -   extraire les unités archivistiques, objets binaires et objets physiques du bordereau de transfert,

    -   vérifier la présence de récursivité dans les arborescences des unités archivistiques et à créer l’arbre d’ordre d’indexation,

    -   extraire les métadonnées contenues dans la balise ManagementMetadata du bordereau de transfert pour le calcul des règles de gestion,

    -   vérifier la validité des rattachements des unités du SIP aux unités présentes dans la solution logicielle Vitam si demandés,

    -   détecter des problèmes d’encodage dans le bordereau de transfert et vérifier que les objets ne font pas référence directement à des unités si ces objets possèdent des groupes d’objets,

    -   vérifier la présence obligatoire d’un objet de type Master pour une entrée, et vérifier les usages d’objets autorisés pour les rattachements.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les journaux du cycle de vie des unités archivistiques et des groupes d’objets ont été créés avec succès, aucune récursivité n’a été détectée dans l’arborescence des unités archivistiques, la structure de rattachement déclarée existe, le type de structure de rattachement est autorisé, (par exemple, un SIP peut être rattaché à un plan de classement, mais pas l’inverse) aucun problème d’encodage n’a été détecté et les objets avec groupe d’objets ne référencent pas directement les
        > unités. L’extraction des unités archivistiques, objets binaires et physiques, la création de l’arbre d’indexation et l’extraction des métadonnées des règles de gestion ont été effectuées avec succès, les vérifications au niveau des types d’usages autorisés ont bien été effectués. (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.OK = Succès du contrôle de cohérence du bordereau de transfert).

    -   KO :

        -   Cas 1 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car le nœud de rattachement déclaré dans le contrat d’entrées a pour valeur « null » (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.NULL\_LINK\_PARENT\_ID\_ATTACHMENT.KO = Le rattachement n’a pas été effectué : le contrat d’entrée ne déclare pas de nœud de rattachement)

        -   Cas 2 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car le contrat d’entrée requiert un rattachement à au moins une unité archivistique (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.ATTACHMENT\_REQUIRED.KO = Le contrat d’entrée requiert un rattachement à au moins une unité archivistique)

        -   Cas 3 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car le contrat d’entrée n’autorise pas les rattachements (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.UNAUTHORIZED\_ATTACHMENT\_BY\_CONTRACT.KO = Le rattachement n’a pas été effectué : le contrat d’entrée n’autorise pas les rattachements)

        -   Cas 4 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué en raison d’un nombre d’unités archivistiques répondant à la requête effectuée supérieur à 1 (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.TOO\_MANY\_FOUND\_ATTACHMENT.KO = Le rattachement n’a pas été effectué : l’élément de rattachement n’est pas unique dans le système)

        -   Cas 5 : au moins un objet binaire dans le bordereau de transfert déclare plusieurs version d’un même usage (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.TOO\_MANY\_VERSION\_BY\_USAGE.KO = Le transfert de plusieurs versions d’un même usage dans un même versement est interdit)

        -   Cas 6 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué en raison d’un nombre d’unités archivistiques répondant à la requête, égal à 0 (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.NOT\_FOUND\_ATTACHMENT.KO = Le rattachement n’a pas été effectué : l’élément de rattachement n’existe pas dans le système)

        -   Cas 7 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car le rattachement demandé n’est pas autorisé (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.UNAUTHORIZED\_ATTACHMENT.KO = Le rattachement n’a pas été effectué : le rattachement n’est pas situé dans le périmètre autorisé)

        -   Cas 8 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car le GUID déclaré n’est pas valide (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.INVALID\_GUID\_ATTACHMENT.KO = Le rattachement n’a pas été effectué : l’élément de rattachement est incorrect)

        -   Cas 9 : au moins une demande de rattachement à des unités archivistiques existantes dans le système a échoué, car elle provoquerait une récursivité de l’arborescence (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.MODIFY\_PARENT\_EXISTING\_UNIT\_UNAUTHORIZED.KO = Le rattachement n’a pas été effectué : impossibilité de rattacher une unité archivistique existante à une unité archivistique parente)

        -   Cas 10 : une ou plusieurs balises de rattachement vers un groupe d'objets techniques existant déclarent autre chose que le GUID d’un groupe d'objets techniques existant (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.EXISTING\_OG\_NOT\_DECLARED.KO = Une unité archivistique déclare un objet à la place du groupe d’objets correspondant)

        -   Cas 11 : une récursivité a été détectée dans l’arborescence des unités archivistiques (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.CHECK\_MANIFEST\_LOOP.KO = Le bordereau de transfert présente une récursivité dans l’arborescence de ses unités archivistiques)

        -   Cas 12 : il y a un problème d’encodage ou des objets référencent directement des unités archivistiques (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.KO = Échec du contrôle de cohérence du bordereau de transfert)

        -   Cas 13 : présence attendue d’un objet de type Master: Binary ou physical CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.MASTER\_MANDATORY\_REQUIRED.KO = Absence d’un BinaryMaster ou PhysicalMaster dans le groupe d’objet

        -   Cas 14 : le contrat d’entrée n’autorise pas un ou plusieurs usages d’objets (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST.ATTACHMENT\_OBJECTGROUP.KO = Le contrat d’entrée n’autorise pas le rattachement d’un objet à un groupe d’objets existant)

        -   Cas 15 : il y a une donnée malformatée (CHECK\_DATAOBJECTPACKAGE.CHECK\_MANIFEST\_MALFORMED\_DATA.KO = Le bordereau de transfert possède une donnée malformée)

    -   FATAL : une erreur technique est survenue lors de la vérification de la cohérence du bordereau, par exemple les journaux du cycle de vie n’ont pu être créés (CHECK\_MANIFEST.FATAL = Erreur technique lors du contrôle de cohérence du bordereau de transfert)

##### Vérification de la cohérence entre objets, groupes d’objets et unités archivistiques CHECK\_DATAOBJECTPACKAGE.CHECK\_CONSISTENCY (CheckObjectUnitConsistencyActionHandler.java)

-   **Règle** : traitement consistant à vérifier que chaque objet ou groupe d’objets est référencé par une unité archivistique, à rattacher à un groupe d’objets les objets sans groupe d’objets mais référencés par une unité archivistique, à créer la table de concordance (MAP) entre les identifiants des objets et des unités archivistiques du SIP et à générer leurs identifiants pérennes dans la solution logicielle Vitam (GUID)

-   **Type** : bloquant

-   **Statuts** :

    -   OK : aucun objet ou groupe d’objets n’est orphelin (c’est-à-dire non référencé par une unité archivistique) et tous les objets sont rattachés à un groupe d’objets. La table de concordance est créée et les identifiants des objets et unités archivistiques ont été générés (CHECK\_DATAOBJECTPACKAGE.CHECK\_CONSISTENCY.OK = Succès de la vérification de la cohérence entre objets, groupes d’objets et unités archivistiques)

    -   KO : au moins un objet ou groupe d’objets est orphelin (c’est-à-dire non référencé par une unité archivistique) (CHECK\_DATAOBJECTPACKAGE.CHECK\_CONSISTENCY.KO = Échec de la vérification de la cohérence entre objets, groupes d’objets et unités archivistiques)

    -   FATAL : une erreur technique est survenue lors de la vérification de la cohérence entre objets, groupes d’objets et unités archivistiques (CHECK\_DATAOBJECTPACKAGE.CHECK\_CONSISTENCY.FATAL = Erreur technique lors de la vérification de la cohérence entre objets, groupes d’objets et unités archivistiques)

##### Vérification du rattachement à un groupe d’objets ou une unité archivistique entrés sans erreur CHECK\_ATTACHEMENT (CheckAttachementActionHandler.java)

-   **Règle** : tâche consistant à vérifier le rattachement à des groupes d’objets techniques et des unités archivistiques entrés sans erreur dans le système.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la vérification des objets et groupes d’objets à été effectué avec succès (CHECK\_ATTACHEMENT.OK=Succès de la vérification du rattachement entre objets, groupes d'objets et unités archivistiques existantes et les nouveaux)

    -   KO : la vérification des objets et groupes d’objets n’a pu être effectuée, car le groupe d’objets techniques ou l’unité archivistique devant faire l’objet d’un rattachement dans le système sont entrés en erreur (CHECK\_ATTACHEMENT.KO=Échec de la vérification du rattachement entre objets, groupes d'objets et unités archivistiques existantes et les nouveaux)

    -   FATAL : une erreur technique est survenue lors de la vérification des objets et groupes d’objets (CHECK\_ATTACHEMENT.FATAL=Erreur technique lors de la vérification du rattachement entre objets, groupes d'objets et unités archivistiques existantes et les nouveaux)

#### Processus de contrôle et traitement des objets (STP\_OG\_CHECK\_AND\_TRANSFORME)

##### Vérification de l’intégrité des objets CHECK\_DIGEST (CheckConformityActionPlugin.java)

-   **Règle** : tâche consistant à vérifier la cohérence entre l’empreinte de l’objet binaire calculée par la solution logicielle Vitam et celle déclarée dans le bordereau de transfert. Si l’empreinte déclarée dans le bordereau de transfert n’a pas été calculée avec l’algorithme SHA-512, alors l’empreinte est recalculée avec cet algorithme. Elle sera alors enregistrée dans la solution logicielle Vitam.

    **Algorithmes autorisés en entrée** : MD5, SHA-1, SHA-256, SHA-512

-   **Type** : bloquant

-   **Statuts** :

    -   OK : tous les objets binaires reçus sont identiques aux objets binaires attendus. Tous les objets binaires disposent désormais d’une empreinte calculée avec l’algorithme SHA-512 (CHECK\_DIGEST.OK = Succès de la vérification de l’empreinte des objets)

    -   KO :

        -   Cas 1 : au moins un objet reçu n’a pas d’empreinte dans le bordereau (CHECK\_DIGEST.EMPTY.KO = Échec lors de la vérification de l’empreinte des objets : Il existe au moins un objet dont l’empreinte est absente dans le bordereau de transfert)

        -   Cas 2 : au moins une empreinte d’un objet reçu n’est pas conforme à son empreinte dans le bordereau (CHECK\_DIGEST.INVALID.KO = Échec lors de la vérification de l’empreinte des objets : Il existe au moins un objet dont l’empreinte est invalide dans le bordereau de transfert)

        -   Cas 3 : le SIP soumis à la solution logicielle Vitam contient à la fois le cas 1 et le cas 2 (CHECK\_DIGEST.KO = Échec de la vérification de l’empreinte des objets)

    -   FATAL : une erreur technique est survenue lors de la vérification de l’intégrité des objets binaires, par exemple lorsque l’algorithme est inconnu (CHECK\_DIGEST.FATAL = Erreur technique lors de la vérification de l’empreinte des objets)

        1.  []{#__RefHeading___Toc86357_2252739535 .anchor}Calcul de la taille des fichiers CHECK\_OBJECT\_SIZE

            (CheckObjectSizeActionPlugin.java)

-   **Règle** : tâche vérifier la taille de chaque objet binaire présent dans le SIP, à vérifier que la taille des objets correspond à la taille des fichiers renseignée pour chacun d’eux dans le manifeste. Le poids des fichiers est calculé en octets et comparé à la taille renseignée dans le manifeste. En cas d’incohérence entre la déclaration dans le manifeste et la taille du fichier, le SIP sera accepté, générant un avertissement. La solution logicielle Vitam se servira alors des informations
    > qu’elle a identifiées et non de celles fournies dans le SIP

-   **Type** : bloquant

-   **Statuts** :

    -   OK (CHECK\_OBJECT\_SIZE.OK = Succès de la vérification de la taille des objets) :

        -   la taille des fichiers correspond à celle qui est renseignée dans le manifeste et aucune incohérence n’a été trouvée ;

        -   la taille des fichiers n’est pas renseignée dans le manifeste et la solution logicielle Vitam enregistre la taille des fichiers qu’elle a calculée.

    -   WARNING (CHECK\_OBJECT\_SIZE.WARNING = Avertissement de la vérification de la taille des objets) : au moins un objet reçu a une taille renseignée dans le manifeste qui n’est pas identique à celle des fichiers numériques.

    -   FATAL : une erreur technique est survenue lors de la vérification de la taille des objets (CHECK\_OBJECT\_SIZE .FATAL = Erreur technique lors de la vérification de la taille des objets)

##### Identification des formats OG\_OBJECTS\_FORMAT\_CHECK (FormatIdentificationActionPlugin.java)

-   **Règle** : tâche consistant à identifier le format de chaque objet binaire présent dans le SIP, à vérifier que le format identifié des objets correspond à la liste des formats acceptés dans le contrat d’entrée et à vérifier que le format identifié des objets est référencé dans le référentiel des formats de la solution logicielle Vitam. Cette action met en œuvre un outil d’identification prenant l’objet en entrée et fournissant des informations de format en sortie. Ces informations sont
    > comparées avec les formats enregistrés dans le référentiel des formats interne à la solution logicielle Vitam et avec celles déclarées dans le bordereau de transfert. En cas d’incohérence entre la déclaration dans le SIP et le format identifié, le SIP sera accepté, générant un avertissement. La solution logicielle Vitam se servira alors des informations qu’elle a identifiées et non de celles fournies dans le SIP

-   **Type** : bloquant

-   **Statuts** :

    -   OK : l’identification s’est bien passée, les formats ont tous été identifiés, sont référencés dans le référentiel interne et sont soit dans la liste des formats autorisés du contrat d’entrée, soit ce contrat autorise tous les formats. De plus les informations de formats trouvées par la solution logicielle Vitam sont cohérentes avec celles déclarées dans le manifeste (OG\_OBJECTS\_FORMAT\_CHECK.OK = Succès de la vérification des formats)

    -   KO :

        -   Cas 1 : au moins un objet reçu a un format qui n’a pas été trouvé et le contrat d’entrée utilisé interdit le versement d’objets aux formats non identifiés (OG\_OBJECTS\_FORMAT\_CHECK.KO = Échec de l’identification des formats)

        -   Cas 2 : au moins un objet reçu a un format qui n’est pas référencé dans le référentiel interne (OG\_OBJECTS\_FORMAT\_CHECK.UNCHARTED.KO = Échec de l’identification des formats, le format de ou des objet(s) est identifié mais est inconnu du référentiel des formats)

        -   Cas 3 : au moins objet reçu possède un format qui n’est pas indiqué dans la liste des formats autorisés du contrat d’entrée du SIP (OG\_OBJECTS\_FORMAT\_CHECK.REJECTED\_FORMAT.KO = Échec de l’identification des formats : le contrat d’entrée interdit le versement d’objet au format inconnu et le SIP versé contient au moins un objet au format inconnu, ou bien le SIP contient un format interdit par le contrat d’entrée)

    -   WARNING :

        -   Cas 1 : l’identification s’est bien passée, les formats identifiés sont référencés dans le référentiel interne mais les informations ne sont pas cohérentes avec celles déclarées dans le manifeste (OG\_OBJECTS\_FORMAT\_CHECK.WARNING = Avertissement lors de l’identification des formats)

        -   Cas 2 : au moins un objet reçu a un format qui n’a pas été trouvé mais le contrat d’entrée utilisé autorise le versement d’objets aux formats non identifiés. Dans ce cas Vitam remplace le champ « FormatId » du manifest.xml par le mot « unknown » (OG\_OBJECTS\_FORMAT\_CHECK.WARNING = Avertissement lors de l’identification des formats)

    -   FATAL : une erreur technique est survenue lors de l’identification des formats (OG\_OBJECTS\_FORMAT\_CHECK.FATAL = Erreur technique lors de l’identification des formats)

#### Processus de contrôle et traitement des unités archivistiques (STP\_UNIT\_CHECK\_AND\_PROCESS)

##### Vérification globale de l’unité archivistique CHECK\_UNIT\_SCHEMA (CheckArchiveUnitSchemaActionPlugin.java)

-   **Règle** : tâche consistant à :

    -   contrôler que la valeur des champs déclarés dans le bordereau de transfert est d’un type conforme à celui déclaré dans l’ontologie ;

    -   contrôler la validité des champs de l’unité archivistique par rapport au schéma prédéfini dans la solution logicielle Vitam. Par exemple, les champs obligatoires, comme les titres des unités archivistiques, ne doivent pas être vides. Lorsque le manifeste déclare une personne (Person) et non une société (Entity), alors au moins un champ entre « Firstname » et « Birthname » est obligatoire,

    -   vérifier que la date de fin est bien supérieure ou égale à la date de début de l’unité archivistique.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : tous les champs de l’unité archivistique sont conformes à ce qui est attendu (CHECK\_UNIT\_SCHEMA.OK = Succès de la vérification globale de l’unité archivistique)

    -   KO :

        -   Cas 1 : au moins un champ d’une unité archivistique déclare un champ dont la valeur n’est pas conforme au type défini dans l’ontologie (CHECK\_UNIT\_SCHEMA.KO = Échec de la vérification globale de l’unité archivistique)

        -   Cas 2 : au moins un champ d’une unité archivistique dont le schéma n’est pas conforme par rapport au schéma par défaut des unités archivistiques défini pour la solution logicielle Vitam. (CHECK\_UNIT\_SCHEMA.INVALID\_UNIT.KO = Échec lors de la vérification globale de l’unité archivistique : champs non conformes)

        -   Cas 3 : au moins un champ obligatoire d’une unité archivistique est vide (CHECK\_UNIT\_SCHEMA.EMPTY\_REQUIRED\_FIELD.KO = Échec lors de la vérification globale de l’unité archivistique : champs obligatoires vides)

        -   Cas 4 : au moins un champ date d’une unité archivistique est supérieur à 9000 ou la date de fin des dates extrêmes est strictement inférieure à la date de début (CHECK\_UNIT\_SCHEMA.RULE\_DATE\_THRESHOLD.KO = Échec du calcul des dates d’échéance, la date ne peut être gérée)

        -   Cas 5 : au moins un champ date d’une unité archivistique déclare une valeur non conforme au type attendu (CHECK\_UNIT\_SCHEMA.RULE\_DATE\_FORMAT.KO = Échec du calcul des dates d’échéance, la date ne peut être gérée)

        -   Cas 6 : au moins une valeur de l’unité archivistique n’est pas conforme à son schéma en raison d’un problème de cohérence entre champs. Par exemple, la valeur contenue dans le champ « StartDate » est postérieure à la date définie dans la « EndDate » (CHECK\_UNIT\_SCHEMA.CONSISTENCY.KO = Au moins une unité archivistique n’est pas conforme à son schéma en raison d’un problème de cohérence entre champs)

    -   FATAL : une erreur technique est survenue lors de la vérification de l’unité archivistique (CHECK\_UNIT\_SCHEMA.FATAL = Erreur technique lors de la vérification globale de l’unité archivistique)

##### Vérification du profil d’unité archivistique CHECK\_ARCHIVE\_UNIT\_PROFILE (CheckArchiveUnitProfileActionPlugin.java)

-   **Règle** : tâche consistant à vérifier la conformité des unités archivistiques au schéma défini dans les profils d’unités archivistiques qu’elles déclarent dans la balise « ArchiveUnitProfile ». Les profils d’unités archivistiques référencés doivent être en état « Actif » et ne pas avoir un schéma de contrôle vide

-   **Type** : non bloquant

-   **Statuts** :

    -   OK : les unités archivistiques déclarant un profil d’unité archivistique de référence sont bien conformes au schéma décrit dans le profil d’unité archivistique, et le profil et le schéma existent bien dans le système en état actif (CHECK\_ARCHIVE\_UNIT\_PROFILE.OK = Succès de la vérification de la conformité au profil d’unité archivistique)

    -   KO :

        -   Cas 1 : au moins une unité archivistique n’est pas conforme au schéma décrit dans le profil d’unité archivistique associé (CHECK\_ARCHIVE\_UNIT\_PROFILE.KO = Échec de la vérification de la conformité au profil d’unité archivistique)

        -   Cas 2 : au moins une unité archivistique qui déclare un lien avec un profil d’unité archivistique inexistant dans le référentiel (CHECK\_ARCHIVE\_UNIT\_PROFILE.PROFILE\_NOT\_FOUND.KO = Échec de la vérification de la conformité au profil d’unité archivistique : profil d’unité archivistique non trouvé)

        -   Cas 3 : au moins une unité archivistique qui n’est pas conforme au schéma décrit dans le profil d’unité archivistique associé (CHECK\_ARCHIVE\_UNIT\_PROFILE.INVALID\_UNIT.KO = Échec de la vérification de la conformité au profil d’unité archivistique : champs non conformes)

        -   Cas 4 : le profil d’unité archivistique cité dans le référentiel est mal formaté (CHECK\_ARCHIVE\_UNIT\_PROFILE.INVALID\_AU\_PROFILE.KO = Échec de la vérification de la conformité aux documents type : profil d’unité archivistique non conforme)

        -   Cas 5 : le profil d’unité archivistique est dans l’état « inactif » (CHECK\_ARCHIVE\_UNIT\_PROFILE.INACTIVE\_STATUS.KO = Échec de la vérification de la conformité aux documents type : profil d’unité archivistique au statut « inactif »

        -   Cas 6 : le profil d’unité archivistique possède un schéma de contrôle qui est vide (CHECK\_ARCHIVE\_UNIT\_PROFILE.EMPTY\_CONTROL\_SCHEMA.KO = Échec de la vérification de la conformité aux documents type : schéma de contrôle du profil d’unité archivistique vide)

##### Vérification du niveau de classification CHECK\_CLASSIFICATION\_LEVEL (CheckClassificationLevelActionPlugin.java)

-   **Règle** : tâche consistant à vérifier les niveaux de classification associés, s’il en existe, aux unités archivistiques. Ces niveaux doivent exister dans la liste des niveaux de classification autorisés par la plateforme (paramètre configuré dans la configuration des workers). Pour les unités archivistiques sans niveau de classification, la vérification contrôle que la plateforme autorise le versement d’unités archivistiques ne déclarant pas de niveau de classification.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les unités archivistiques versées ont un niveau de classification autorisé par la plateforme. S’il existe dans le SIP des unités archivistiques sans niveau de classification, il faut que la plateforme autorise le versement d’unités archivistiques sans niveau de classification. (CHECK\_CLASSIFICATION\_LEVEL.OK = Succès de la vérification du niveau de classification)

    -   KO : au moins une unité archivistique du SIP possède un niveau de classification qui n’est pas un niveau de classification autorisé par la plateforme, ou une unité archivistique n’a pas de niveau de classification alors que la plateforme requiert que toutes les unités archivistiques possèdent un niveau de classification. (CHECK\_CLASSIFICATION\_LEVEL.KO = Échec de la vérification du niveau de classification, non autorisé par la plateforme : le bordereau de transfert déclare un niveau de
        > classification non autorisé par la plateforme)

    -   FATAL : une erreur technique est survenue lors de la vérification des niveaux de classification (CHECK\_CLASSIFICATION\_LEVEL.FATAL = Erreur technique lors de la vérification du niveau de classification)

##### Application des règles de gestion et calcul des dates d’échéances UNITS\_RULES\_COMPUTE (UnitsRulesComputePlugin.java)

-   **Règle** : tâche consistant à calculer les dates d’échéances des unités archivistiques du SIP. Pour les unités racines, c’est-à-dire les unités déclarées dans le SIP et n’ayant aucun parent dans l’arborescence, la solution logicielle Vitam utilise les règles de gestion incluses dans le bloc Management de chacune de ces unités ainsi que celles présentes dans le bloc ManagementMetadata. La solution logicielle Vitam effectue également ce calcul pour les autres unités archivistiques du SIP
    > possédant des règles de gestion déclarées dans leurs balises Management, sans prendre en compte le ManagementMetadata. Le référentiel utilisé pour ces calculs est le référentiel des règles de gestion de la solution logicielle Vitam.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les règles de gestion sont référencées dans le référentiel interne et ont été appliquées avec succès (UNITS\_RULES\_COMPUTE.OK = Succès de l’application des règles de gestion et du calcul des dates d’échéance)

    -   KO :

        -   Cas 1 : au moins une unité archivistique déclare un champ dont la valeur nest pas conforme à celle attendue (UNITS\_RULES\_COMPUTE.KO=Au moins une unité archivistique déclare un champ dont la valeur n”“est pas conforme à celle attendue)

        -   Cas 2 : au moins une unité archivistique déclare une règle non référencée dans le référentiel interne (UNITS\_RULES\_COMPUTE.UNKNOWN.KO = Échec lors de l’application des règles de gestion et du calcul des dates d’échéance : règle de gestion inconnue)

        -   Cas 3 : au moins une unité archivistique déclare une règle non cohérente avec sa catégorie (UNITS\_RULES\_COMPUTE.CONSISTENCY.KO = Échec lors de l’application des règles de gestion et du calcul des dates d’échéance : Au moins une unité archivistique déclare une règle non cohérente avec sa catégorie)

        -   Cas 4 : au moins une unité archivistique déclare dans le champ RefNonRuleId une règle non cohérente avec sa catégorie (UNITS\_RULES\_COMPUTE.REF\_INCONSISTENCY.KO = Échec lors de l’application des règles de gestion et du calcul des dates d’échéance : exclusion d’héritage incohérente)

    -   FATAL : une erreur technique est survenue lors du calcul des dates d’échéances (UNITS\_RULES\_COMPUTE.FATAL = Erreur technique lors de l’application des règles de gestion et du calcul des dates d’échéance)

#### Processus de vérification préalable à la prise en charge (STP\_STORAGE\_AVAILABILITY\_CHECK)

##### Vérification de la disponibilité de toutes les offres de stockage STORAGE\_AVAILABILITY\_CHECK (CheckStorageAvailabilityActionHandler.java)

-   **Règle** : tâche consistant à vérifier la disponibilité des offres de stockage et de l’espace disponible pour y stocker le contenu du SIP compte tenu de la taille des objets à stocker

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les offres de stockage sont accessibles et disposent d’assez d’espace pour stocker le contenu du SIP (STORAGE\_AVAILABILITY\_CHECK.OK = Succès de la vérification de la disponibilité de toutes les offres de stockage)

    -   KO :

        -   Cas 1 : les offres de stockage ne sont pas disponibles (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_OFFER\_KO\_UNAVAILABLE.KO = Échec de la vérification de la disponibilité d’au moins une offre de stockage)

        -   Cas 2 : les offres ne disposent pas d’assez d’espace pour stocker le contenu du SIP (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_OFFER\_SPACE\_KO.KO = Échec de la vérification de l’espace disponible)

    -   FATAL : une erreur technique est survenue lors de la vérification de la disponibilité de l’offre de stockage (STORAGE\_AVAILABILITY\_CHECK.FATAL = Erreur technique lors de la vérification de la disponibilité d’au moins une offre de stockage)

        La tâche Check\_Availability\_Check contient le traitement suivant :

##### Vérification de la disponibilité de l’offre de stockage STORAGE\_AVAILABILITY\_CHECK.STORAGE\_AVAILABILITY\_CHECK (CheckStorageAvailabilityActionHandler.java)

-   **Règle** : traitement consistant à vérifier la disponibilité de l’offre de stockage et de l’espace disponible pour y stocker le contenu du SIP compte tenu de la taille des objets à stocker

-   **Type** : bloquant

-   **Statuts** :

    -   OK : l’offre de stockage est accessible et dispose d’assez d’espace pour stocker le contenu du SIP (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_AVAILABILITY\_CHECK.OK = Succès de la vérification de la disponibilité de l’offre de stockage)

    -   KO :

        -   Cas 1 : l’offre de stockage n’est pas disponible (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_AVAILABILITY\_CHECK.STORAGE\_OFFER\_KO\_UNAVAILABLE.KO = L’offre de stockage n’est pas disponible)

        -   Cas 2 : l’offre de stockage ne dispose pas d’assez d’espace pour stocker le contenu du SIP (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_AVAILABILITY\_CHECK.STORAGE\_OFFER\_SPACE\_KO.KO = Disponibilité de l’offre de stockage insuffisante)

    -   FATAL : une erreur technique est survenue lors de la vérification de la disponibilité de l’offre de stockage (STORAGE\_AVAILABILITY\_CHECK.STORAGE\_AVAILABILITY\_CHECK.FATAL = Erreur technique lors de la vérification de la disponibilités de l’offre de stockage)

#### Processus d’écriture et indexation des objets et groupes d’objets (STP\_OBJ\_STORING)

##### Écriture des objets sur l’offre de stockage OBJ\_STORAGE (StoreObjectActionHandler.java)

-   **Règle** : tâche consistant à écrire les objets contenus dans le SIP sur les offres de stockage en fonction de la stratégie de stockage applicable

-   **Type** : Bloquant

-   **Statuts** :

    -   OK : tous les objets binaires contenus dans le SIP ont été écrits sur les offres de stockage (OBJ\_STORAGE.OK = Succès de l’écriture des objets et des groupes d’objets sur les offres de stockage)

    -   KO : au moins un des objets binaires contenus dans le SIP n’a pas pu être écrit sur les offres de stockage (OBJ\_STORAGE.KO = Échec de l’écriture des objets et des groupes d’objets sur les offres de stockage)

    -   WARNING : le SIP ne contient pas d’objet (OBJECTS\_LIST\_EMPTY.WARNING = Avertissement lors de l’établissement de la liste des objets : il n’y a pas d’objet pour cette étape)

    -   FATAL : une erreur technique est survenue lors de l’écriture des objets binaires sur les offres de stockage (OBJ\_STORAGE.FATAL = Erreur technique lors de l’écriture des objets et des groupes d’objets sur les offres de stockage)

##### Indexation des métadonnées des groupes d’objets et objets OG\_METADATA\_INDEXATION (IndexObjectGroupActionPlugin.java)

-   **Règle** : tâche consistant à indexer les métadonnées des groupes d’objets et objets dans les bases internes de la solution logicielle Vitam, comme la taille des objets, les métadonnées liées aux formats (Type MIME, PUID, etc.), l’empreinte des objets, etc.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les métadonnées des groupes d’objets et objets ont été indexées avec succès (OG\_METADATA\_INDEXATION.OK = Succès de l’indexation des métadonnées des objets et des groupes d’objets)

    -   KO : au moins une des métadonnées des groupes d’objets et objets n’a pas été indexée (OG\_METADATA\_INDEXATION.KO = Échec de l’indexation des métadonnées des objets et des groupes d’objets)

    -   FATAL : une erreur technique est survenue lors de l’indexation des métadonnées des groupes d’objets (OG\_METADATA\_INDEXATION.FATAL = Erreur technique lors de l’indexation des métadonnées des objets et des groupes d’objets)

#### Processus d’indexation des unités archivistiques (STP\_UNIT\_METADATA)

##### Indexation des métadonnées des unités archivistiques UNIT\_METADATA\_INDEXATION (IndexUnitActionPlugin.java)

-   **Règle** : tâche consistant à indexer les métadonnées des unités archivistiques dans les bases internes de la solution logicielle Vitam, c’est-à-dire le titre des unités, leurs descriptions, leurs dates extrêmes, etc.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les métadonnées des unités archivistiques ont été indexées avec succès (UNIT\_METADATA\_INDEXATION.OK = Succès de l’indexation des métadonnées de l’unité archivistique)

    -   KO : au moins une des métadonnées des unités archivistiques n’a pas été indexée (UNIT\_METADATA\_INDEXATION.KO = Échec de l’indexation des métadonnées de l’unité archivistique)

    -   FATAL : une erreur technique est survenue lors de l’indexation des métadonnées des unités archivistiques (UNIT\_METADATA\_INDEXATION.FATAL = Erreur technique lors de l’indexation des métadonnées de l’unité archivistique)

#### Processus d’enregistrement et écriture des métadonnées des objets et groupes d’objets (STP\_OG\_STORING)

##### Enregistrement des journaux du cycle de vie des groupes d’objets COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP (CommitLifeCycleObjectGroupActionHandler.java)

-   **Règle** : tâche consistant à sécuriser en base les journaux du cycle de vie des groupes d’objets. Avant cette étape, les journaux du cycle de vie des groupes d’objets sont dans une collection temporaire afin de garder une cohérence entre les métadonnées indexées et les journaux lors d’une entrée en succès ou en échec, il n’y a pas d’évènement créée dans le journal du cycle de vie.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la sécurisation des journaux du cycle de vie s’est correctement déroulée (COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP.OK = Succès de l’enregistrement des journaux du cycle de vie des groupes d’objets)

    -   FATAL : une erreur technique est survenue lors de la sécurisation du journal du cycle de vie (COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP.FATAL = Erreur technique lors de l’enregistrement des journaux du cycle de vie des groupes d’objets)

##### Écriture des métadonnées du groupe d’objets et objets sur l’offre de stockage OG\_METADATA\_STORAGE (StoreMetaDataObjectGroupActionPlugin)

-   **Règle** : tâche consistant à sauvegarder les métadonnées liées aux groupes d’objets ainsi que leurs journaux de cycle de vie sur les offres de stockage en fonction de la stratégie de stockage

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les métadonnées des groupes d’objets et objets ont été sauvegardées avec succès (OG\_METADATA\_STORAGE.OK = Succès de l’écriture des métadonnées des objets et groupes d’objets sur l’offre de stockage)

    -   KO : les métadonnées des groupes d’objets et objets n’ont pas été sauvegardées (OG\_METADATA\_STORAGE.KO = Échec de l’écriture des métadonnées des objets et groupes d’objets sur l’offre de stockage)

    -   FATAL : une erreur technique est survenue lors de l’écriture des métadonnées du groupe d’objets sur les offres de stockage (OG\_METADATA\_STORAGE.FATAL = Erreur technique lors de l’écriture des métadonnées du groupe d’objets sur les offres de stockage)

#### Processus d’enregistrement et écriture des unités archivistiques (STP\_UNIT\_STORING)

##### Enregistrement du journal du cycle de vie des unités archivistiques COMMIT\_LIFE\_CYCLE\_UNIT (AccessInternalModuleImpl.java)

-   **Règle** : tâche consistant à sécuriser en base les journaux du cycle de vie des unités archivistiques. Avant cette étape, les journaux du cycle de vie des unités archivistiques sont dans une collection temporaire afin de garder une cohérence entre les métadonnées indexées et les journaux lors d’une entrée en succès ou en échec.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la sécurisation des journaux du cycle de vie s’est correctement déroulée (COMMIT\_LIFE\_CYCLE\_UNIT.OK = Succès de l’enregistrement des journaux du cycle de vie des unités archivistiques)

    -   FATAL : une erreur technique est survenue lors de la sécurisation des journaux du cycle de vie (COMMIT\_LIFE\_CYCLE\_UNIT.FATAL = Erreur technique lors de l’enregistrement des journaux du cycle de vie des unités archivistiques)

##### Écriture des métadonnées de l’unité archivistique sur l’offre de stockage UNIT\_METADATA\_STORAGE (AccessInternalModuleImpl.java)

-   **Règle** : tâche consistant à sauvegarder les métadonnées et des journaux de cycle de vie des unités archivistiques sur les offres de stockage en fonction de la stratégie de stockage. Pas d’évènements stockés dans le journal de cycle de vie

-   **Type** : bloquant

-   **Statuts** :

    -   OK : l’écriture des métadonnées de l’unité archivistique sur les offres de stockage s’est correctement déroulée (UNIT\_METADATA\_STORAGE.OK = Succès de l’écriture des métadonnées de l’unité archivistique sur les offres de stockage)

    -   KO : l’écriture des métadonnées de l’unité archivistique sur les offres de stockage n’a pas été effectuée (UNIT\_METADATA\_STORAGE.KO = Échec de l’écriture des métadonnées de l’unité archivistique sur les offres de stockage)

    -   FATAL : une erreur technique est survenue lors de la sécurisation du journal du cycle de vie (UNIT\_METADATA\_STORAGE.FATAL = Erreur technique lors de l’écriture des métadonnées de l’unité archivistique sur les offres de stockage)

#### Processus de mise à jour des groupes d’objets (STP\_UPDATE\_OBJECT\_GROUP)

##### Mise à jour des groupes d’objets OBJECT\_GROUP\_UPDATE (AccessInternalModuleImpl.java)

-   **Règle** : Tâche consistant à mettre à jour les groupes d’objet techniques

-   **Type** : bloquant

    -   OK=Succès de la mise à jour des groupes d''objets existants

    -   KO=Échec lors de la mise à jour des groupes d'objets existants

    -   FATAL=Erreur fatale lors de la mise à jour des groupes d'objets existants

    -   WARNING=Avertissement lors de la mise à jour des groupes d'objets existants

##### Enregistrement du journal du cycle de vie des groupes d’objets COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP (CommitLifeCycleObjectGroupActionHandler.java)

-   **Règle** : tâche consistant à sécuriser en base les journaux du cycle de vie des groupes d’objets. Avant cette étape, les journaux du cycle de vie des groupes d’objets sont dans une collection temporaire afin de garder une cohérence entre les métadonnées indexées et les journaux lors d’une entrée en succès ou en échec, et il n’y a pas d’évènement créée dans le journal du cycle de vie.

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la sécurisation des journaux du cycle de vie s’est correctement déroulée (COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP.OK = Succès de l’enregistrement des journaux du cycle de vie des groupes d’objets)

    -   FATAL : une erreur technique est survenue lors de la sécurisation du journal du cycle de vie (COMMIT\_LIFE\_CYCLE\_OBJECT\_GROUP.FATAL = Erreur technique lors de l’enregistrement des journaux du cycle de vie des groupes d’objets)

##### Écriture des métadonnées des groupes d’objets sur l’offre de stockage OG\_METADATA\_STORAGE (StoreMetaDataObjectGroupActionPlugin)

-   **Règle** : tâche consistant à sauvegarder les métadonnées liées aux groupes d’objets ainsi que leurs journaux de cycle de vie sur les offres de stockage en fonction de la stratégie de stockage

-   **Type** : bloquant

-   **Statuts** :

    -   OK : les métadonnées des groupes d’objets et objets ont été sauvegardées avec succès (OG\_METADATA\_STORAGE.OK = Succès de l’écriture des métadonnées des objets et groupes d’objets sur l’offre de stockage)

    -   KO : les métadonnées des groupes d’objets et objets n’ont pas été sauvegardées (OG\_METADATA\_STORAGE.KO = Échec de l’écriture des métadonnées des objets et groupes d’objets sur l’offre de stockage)

    -   FATAL : une erreur technique est survenue lors de l’écriture des métadonnées du groupe d’objets sur les offres de stockage (OG\_METADATA\_STORAGE.FATAL = Erreur technique lors de l’écriture des métadonnées du groupe d’objets sur les offres de stockage)

#### Processus d’alimentation du registre des fonds (STP\_ACCESSION\_REGISTRATION)

##### Alimentation du registre des fonds ACCESSION\_REGISTRATION

-   **Règle** : tâche consistant à enregistrer dans le registre des fonds des informations concernant la nouvelle entrée (nombre d’objets, volumétrie...). Ces informations viennent s’ajouter aux informations existantes pour un même service producteur. Si aucune information n’existait préalablement, alors un nouveau document est créé dans la base de données concernant ce producteur. Une fois cette action d’ajout ou de mise à jour effectuée, la solution logicielle Vitam calcule et enregistre une
    > information agrégée de l’état des stocks du service producteur concerné (dans la collection AccessionRegisterDetail).

-   **Type** : bloquant

-   **Statuts** :

    -   OK : le registre des fonds est correctement alimenté (ACCESSION\_REGISTRATION.OK = Succès de l’alimentation du registre des fonds)

    -   KO : le registre des fonds n’a pas pu être alimenté (ACCESSION\_REGISTRATION.KO = Échec de l’alimentation du registre des fonds)

    -   FATAL : une erreur technique est survenue lors de l’alimentation du registre des fonds (ACCESSION\_REGISTRATION.FATAL = Erreur technique lors de l’alimentation du registre des fonds)

#### Processus de finalisation de l’entrée (STP\_INGEST\_FINALISATION)

##### Notification de la fin de l’opération d’entrée ATR\_NOTIFICATION (TransferNotificationActionHandler.java)

-   **Règle** : tâche consistant à générer la notification de réponse (ArchiveTransferReply ou ATR) une fois toutes les étapes passées, en succès, avertissement ou échec, puis écriture de cette notification dans l’offre de stockage et envoi au service versant

-   **Type** : non bloquant

-   **Statuts** :

    -   OK : le message de réponse a été correctement généré, écrit sur l’offre de stockage et envoyé au service versant (ATR\_NOTIFICATION.OK = Succès de la notification de la fin de l’opération d’entrée à l’opérateur de versement)

    -   KO : le message de réponse n’a pas été correctement généré, écrit sur l’offre de stockage ou envoyé au service versant (ATR\_NOTIFICATION.KO = Échec de la notification de la fin de l’opération d’entrée à l’opérateur de versement)

    -   FATAL : une erreur technique est survenue lors de la notification de la fin de l’opération (ATR\_NOTIFICATION.FATAL = Erreur technique lors de la notification de la fin de l’opération d’entrée à l’opérateur de versement)

##### Mise en cohérence des journaux du cycle de vie ROLL\_BACK (RollBackActionHandler.java)

-   **Règle** : Purge des collections temporaires des journaux du cycle de vie

-   **Type** : bloquant

-   **Statuts** :

    -   OK : la purge s’est correctement déroulée (ROLL\_BACK.OK = Succès de la mise en cohérence des journaux du cycle de vie)

    -   FATAL : une erreur technique est survenue lors de la purge (ROLL\_BACK.FATAL = Erreur technique lors de la mise en cohérence des journaux du cycle de vie)

#### Le cas du processus d’entrée « test à blanc »

Il est possible de procéder à un versement dit « à blanc », pour tester la conformité du SIP par rapport à la forme attendue par la solution logicielle Vitam sans pour autant le prendre en charge. Dans ce cas, le processus d’entrée à blanc diffère du processus d’entrée « classique » en ignorant un certain nombre d’étapes.

Les étapes non exécutées dans le processus d’entrée à blanc sont les suivantes :

-   Écriture et indexation des objets et groupes d’objets (STP\_OBJ\_STORING)

-   Indexation des unités archivistiques (STP\_UNIT\_METADATA)

-   Enregistrement et écriture des métadonnées des objets et groupes d’objets (STP\_OG\_STORING)

-   Enregistrement et écriture des unités archivistiques (STP\_UNIT\_STORING)

-   Rangement des métadonnées des objets (STP\_UPDATE\_OBJECT\_GROUP)

-   Alimentation du registre des fonds (STP\_ACCESSION\_REGISTRATION)

    Les tâches et traitements relatifs à toutes ces étapes sont donc également ignorés.

#### Structure du Workflow de l’entrée

Le workflow mis en place dans la solution logicielle Vitam est défini dans l’unique fichier *« DefaultIngestWorkflow.json »*. Ce fichier est disponible dans /sources/processing/processing-management/src/main/resources/workflows. Il décrit le processus d’entrée (hors Ingest externe) pour entrer un SIP, indexer les métadonnées et stocker les objets contenus dans le SIP.

D’une façon synthétique, le workflow est décrit de cette façon :

![](medias/modele_workflow/media/image2.png)

![](medias/modele_workflow/media/image3.png)

![](medias/modele_workflow/media/image4.png)

![](medias/modele_workflow/media/image5.png)

![](medias/modele_workflow/media/image6.png)

![](medias/modele_workflow/media/image7.jpeg)

### Mise à jour unitaire (Update)

#### Workflow de mise à jour unitaire des unités archivistiques

Cette section décrit le processus permettant la mise à jour unitaire des unités archivistiques.

Toutes les étapes, tâches et traitements sont journalisés dans le journal des opérations et décrivent le processus (clé et description de la clé associée dans le journal des opérations) tel qu’implémenté dans la version actuelle de la solution logicielle Vitam.

#### Mise à jour d’une unité archivistique (vision métier)

Le processus de mise à jour unitaire des unités archivistiques est lancé lors d’une mise à jour de n’importe quelle métadonnée d’une unité archivistique. On distingue cependant deux cas de modifications, liés à des droits gérés via les contrats d’accès : soit les utilisateurs disposent d’un droit de modification sur métadonnées descriptives seulement, soit ils disposent des droits pour modifier les métadonnées descriptives et les métadonnées de gestion (profil d’unité archivistiques et règles de
gestion).

Un certain nombre d’étapes, tâches et traitements sont journalisés dans le journal des opérations et décrivent ce processus de mise à jour (clé et description de la clé associée dans le journal des opérations).
