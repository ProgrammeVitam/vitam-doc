Les audits dans la solution logicielle Vitam
====


La solution logicielle Vitam offre des fonctionnalités d’audit permettant de vérifier la disponibilité des objets métier (unités archivistiques, groupes d’objets techniques) dans la solution logicielle ainsi que le maintien de leur intégrité.


Présentation des audits
----

### Périmètre des audits
Un audit est lancé sur un tenant donné.
Il peut être réalisé sur tout le tenant, sur un service producteur en particulier ou à partir d’une requête destinée à sélectionner un lot d’archives, pour les audits d’existence, d’intégrité et de cohérence.
L’audit correctif se lance à partir de l’identifiant d’opération d’un audit de cohérence.

### Audit d’existence
L’audit d’existence permet de vérifier la présence effective des objets techniques (fichiers) dans la solution logicielle Vitam. Il assure que ces objets techniques sont toujours disponibles et que toutes leurs copies, stockées sur les différentes offres de stockage, conformément à la stratégie de stockage, sont bien présentes.

À l’issue de l’opération d’audit, un rapport est produit indiquant le périmètre audité et, le cas échéant, les objets en échec (au moins un objet absent par rapport au nombre de copies déclarées dans la stratégie de stockage) ou en avertissement (pas d’objets techniques à traiter dans le lot d’archives audité).

### Audit d’intégrité
L’audit d’intégrité permet de vérifier, outre l’existence des objets techniques, que ces objets sont intègres, c’est-à-dire qu’ils n’ont pas été modifiés au sein de la solution logicielle Vitam.

La vérification de l’intégrité est basée sur une comparaison des empreintes des objets techniques fournies par les offres de stockage avec l’empreinte enregistrée en base de données au moment de la prise en charge des objets techniques.

À l’issue de l’opération d’audit, un rapport est produit indiquant les objets en échec (au moins un objet absent par rapport au nombre de copies déclarées dans la stratégie de stockage, au moins une empreinte non identique entre l’offre de stockage et la base de données) ou en avertissement (pas d’objets techniques à traiter dans le lot d’archives audité).

### Audit de cohérence
L’audit de cohérence permet de vérifier la conformité globale du système. Il croise les empreintes des unités archivistiques, des groupes d’objets techniques et des fichiers, ainsi que de leurs journaux en base de données et sur les offres de stockage avec celle du journal sécurisé.

Il offre une garantie supplémentaire par rapport aux audits d’existence et d’intégrité et permet de démontrer que le périmètre audité n’a pas été altéré sur l’ensemble des offres et pour tous les objets métier considérés (journaux...).

Lors d’un audit de cohérence, la solution logicielle Vitam ne produit de rapport que dans les cas d’erreurs avérées (l’une des empreintes vérifiée est non conforme) ou en l’absence de journal sécurisé (l’opération est alors en avertissement).

### Audit correctif
L’audit correctif se lance à partir de l’identifiant d’opération d’un audit de cohérence et comprend :
- une phase de réalisation d’un nouvel audit de cohérence qui permet de vérifier la conformité globale du système,
- une phase de rétablissement de l’élément manquant détecté par l’audit de cohérence.
Lors d’un audit correctif, la solution logicielle Vitam ne produit un rapport que dans les cas d’erreurs avérées (plus d’un objet technique, d’un groupe d’objets techniques ou d’une unité archivistique à corriger).

La solution logicielle Vitam ne rétablit que l’objet technique présent sur une offre non corrompue. Elle ne rétablit pas les incohérences présentes dans la base de données.

Une intervention humaine sera nécessaire si des incohérences sont détectées dans la base de données.


Mise en œuvre d’une opération d’audit
----

L’administrateur pourra souhaiter réaliser un audit d’existence :
- de manière ponctuelle, sur un échantillon,
- sur un périmètre défini dans le cadre d’un programme complet de vérification de l’existence des objets techniques,
- de manière systématique sur les entrées du jour ou de la semaine,
- dans le cadre d’une évolution de sa stratégie de stockage pour vérifier le bon fonctionnement des offres de stockage.

Il lancera un audit d’intégrité s’il souhaite en plus prouver l’intégrité d’un fonds en particulier ou dans le cadre d’un changement de stockage.

L’audit de cohérence sera utilisé lorsque l’administrateur souhaite prouver, par la génération d’un rapport, l’intégrité et l’authenticité d’un fonds en particulier ou dans le cadre d’une migration de plate-forme et de données.

L’audit correctif sera lancé à la suite d’un audit de cohérence dont le rapport contient au moins une anomalie.

En fonction du nombre d’objets conservés dans la solution logicielle Vitam, une opération d’audit peut prendre du temps et avoir un impact en termes de performance. Avant de lancer un audit, il est recommandé de bien prendre en considération le périmètre qui doit faire l’objet de cet audit.


Pour en savoir plus, consulter le [document VITAM. Gestion de la préservation](./preservation).