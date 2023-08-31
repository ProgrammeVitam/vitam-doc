La journalisation et la conservation de la valeur probante dans la solution logicielle Vitam
===

La conservation de la valeur probante est un sujet central d’un système d’archivage électronique. L’objectif est de rendre prouvable toute opération effectuée sur toute unité archivistique ou objet technique.
Dans la solution logicielle Vitam, la conservation de la valeur probante repose sur un faisceau d’éléments redondants dont la modification simultanée et cohérente est considérée comme impossible. Les journaux en constituent un élément central.


Les journaux
---
### Périmètre des journaux
Les journaux sont constitués par tenant.

### Journal des opérations
Le journal des opérations a pour objectif d’enregistrer toutes les opérations effectuées par la solution logicielle Vitam ayant un impact significatif dans le système, et en particulier sur les unités archivistiques, groupes d’objets techniques et objets techniques pris en charge.

Exemple d’opérations faisant l’objet d’une journalisation : import et mise à jour d’un référentiel, réalisation d’une opération d’entrée, réalisation d’une élimination, modification d’arborescence, mise à jour d’unités archivistiques, réalisation d’une opération de préservation, réalisation d’un export de DIP, réalisation d’un transfert, réalisation d’une opération d’audit, réalisation d’une opération de sécurisation, réalisation d’une opération de vérification des journaux sécurisés.

### Journaux du cycle de vie
Les journaux du cycle de vie ont pour objectif d’enregistrer toutes les actions significatives effectuées par la solution logicielle Vitam sur chacune des unités archivistiques et sur chacun des groupes d’objets techniques et des objets techniques qui les composent.

Une action significative est une action qui modifie l’unité archivistique, le groupe d’objets techniques ou l’objet technique ou qui apporte une information significative sur son cycle de vie : par exemple, la modification d’une règle de gestion, le rattachement à une unité archivistique, l’ajout d’un objet technique à un groupe d’objets, la réidentification du format d’un objet.

Lors de la prise en charge des unités archivistiques et des groupes d’objets techniques, la solution logicielle crée un journal de cycle de vie pour chaque unité archivistique et un journal de cycle de vie pour chaque groupe d’objets techniques.

### Journal des écritures
Le journal des écritures a pour objectif de tracer les opérations d’écriture effectuées par la solution logicielle sur les offres de stockage. Il garantit de fait l’horodatage et l’intégrité de tout élément dans le système.

Ce journal apporte une sécurité supplémentaire par rapport aux autres journaux métier. Il peut servir d’ultime recours pour s’assurer de la présence d’un fichier dans le système à un moment donné.

### Sécurisation des journaux
La sécurisation des journaux consiste à apporter de la sécurité cryptographique sur l’objet journal en tant que tel. Cette sécurisation est effectuée à intervalles réguliers tenant par tenant par la solution logicielle Vitam et génère un fichier de sécurisation sauvegardé sur l’offre de stockage.

Un mécanisme de chaînage permet de vérifier l’intégrité technique des journaux en remontant le fil des journaux produits.


La preuve systémique
----
La sécurisation de ces trois journaux et le croisement de leurs informations permettent d’assurer la traçabilité de tout événement et d’en apporter la preuve, parfois par plusieurs voies.

Par exemple, il est ainsi possible de prouver la prise en charge d’un objet technique dans le système par :
- le journal du cycle de vie du groupe d’objets techniques qui fournit la date de création du journal, l’identifiant de l’opération qui a occasionné la prise en charge de l’objet dans la solution logicielle Vitam, ainsi que l’empreinte de l’objet,
- le journal des opérations qui contient l’identifiant de l’opération qui a occasionné la prise en charge de l’objet dans la solution logicielle Vitam, la date de cette opération et l’identité du service responsable de l’entrée s’il s’agit d’une opération d’entrée et non de préservation,
- le journal des écritures qui assure l’écriture de cet objet (via son empreinte) sur les offres de stockage.


Le relevé de valeur probante
----

Le relevé de valeur probante a pour objectif d’apporter la preuve de la bonne existence d’un fichier dans le système à la date supposée de sa prise en charge dans celui-ci, que cette prise en charge résulte d’une opération d’entrée ou d’une opération de préservation.

Il réunit les éléments permettant de fournir à un auditeur externe une présomption de confiance sur la valeur probante de ce qui lui est communiqué, par exemple dans le cadre d’une commission rogatoire.

Une première série de vérifications atteste que la sécurisation du journal de l’opération de création de l’objet est bien faite et chaînée.

Une deuxième série de vérifications atteste que la sécurisation du journal du cycle de vie de l’objet au moment supposé de la création de l’objet est bien faite et chaînée.

Une troisième vérification atteste que l’objet actuellement en base et bien l’objet du journal du cycle de vie au moment supposé de la création supposée, donc que l’objet en base existait bien au moment supposé de la création.

Une quatrième vérification atteste que le journal du cycle de vie de l’objet au moment de sa création peut être lu dans le journal du cycle de vie actuellement en base.
Ainsi, au-delà de la garantie de la date de création de l’objet dans le système, c’est tout le journal du cycle de vie du groupe d’objets au moment de la création de l’objet dans le système qui peut être attesté.

Le rapport fourni par la solution logicielle Vitam est un fichier technique qui présente une structure très riche et détaillée qui n’est pas faite pour être lue directement, mais pour apporter tous les éléments utiles à la construction d’un document lisible selon la forme souhaitée par le demandeur, au niveau du front-office.

Pour en savoir plus, consulter le [document VITAM. Conservation de la valeur probante](./valeur_probante.md).