Réaliser des éliminations d’archives avec la solution logicielle Vitam
====

Présentation de l’élimination
----

### Calcul des règles de gestion applicables à une unité archivistique
Lorsque la solution logicielle Vitam calcule les règles qui s’appliquent à une unité archivistique donnée, pour chaque règle spécifique est indiqué le chemin par lequel est héritée cette règle ainsi que le service producteur à l’origine de la règle.
Ce service producteur est le service producteur principal de l’unité archivistique qui porte la règle.
Dans le cas de l’élimination, cela permet de savoir quel producteur a demandé la destruction ou la conservation de l’unité archivistique et de mettre en œuvre l’élimination en conséquence.

Pour la catégorie de règle de durée d’utilité administrative, la déclaration d’une règle spécifique s’accompagne de la déclaration d’une propriété de sort final dont le statut peut être « conserver » (Keep) ou « détruire » (Destroy).


### Critères pour déterminer qu’une unité archivistique est éliminable
Pour être éliminable, une unité archivistique doit définir ou hériter une règle de durée d’utilité administrative dont la date d’échéance est dans le passé par rapport à une date de référence donnée par l’archiviste et avoir un sort final « détruire » au titre du même service producteur. En outre, elle ne doit ni définir ni hériter de règles de gel non expirées à date de l’opération d’élimination.

*Si l’unité archivistique n’a qu’un sort final « détruire » sans règle associée permettant de calculer une date d’échéance, elle ne sera pas considérée comme éliminable.*

Si une unité archivistique hérite pour un service producteur une règle de durée d’utilité administrative sans qu’un sort final soit associé au titre de ce même service producteur, aucune action ne pourra être mise en œuvre à échéance de la règle.
Cette situation se rencontre quand l’unité archivistique déclare en propre un sort final (donc au titre de son service producteur principal), ce qui fait obstacle à l’héritage du sort final d’un producteur de **rattachement**.

En cas d’absence de déclaration de sort final pour la durée d’utilité administrative dans le  bordereau de transfert, un sort final par défaut « conserver » est défini lors de l’entrée.

*Rattacher des unités archivistiques à d’autres unités archivistiques peut entraîner des héritages complexes et empêcher la mise en œuvre des opérations d’élimination. L’archiviste devra identifier ces cas et procéder à des mises à jour des règles applicables à l’unité et/ou à des réorganisations d’arborescence pour pouvoir éliminer effectivement les unités archivistiques concernées.*

Pour en savoir plus, consulter le [vademecum "Positionner des règles de gestion dans la solution logicielle Vitam"](./Vademecum_reglesgestion_fonctionnement.md).

### Critères pour déterminer qu’une unité archivistique peut être éliminée
Pour pouvoir être éliminée, une unité archivistique doit disposer, pour un producteur donné, d’une règle de durée d’utilité administrative échue à la date du lancement de l’opération d’élimination et ne pas avoir de descendance conservée dans le système. En outre, elle ne doit ni définir ni hériter de règles de gel non expirées à date de l’opération d’élimination.

Pour pouvoir éliminer une unité archivistique qui a encore un enfant à conserver (par exemple, un sous-dossier éliminable qui contient encore une pièce à conserver) ou un enfant gelé, l’archiviste doit procéder à une réorganisation d’arborescence (par exemple, placer la pièce à la racine du dossier) et relancer l’opération d’élimination sur cette unité archivistique.

Pour pouvoir éliminer une unité archivistique gelée, la règle de gel doit être échue ou avoir été préalablement supprimée.

### Conséquence d’une élimination dans le système
Si l’unité archivistique peut être éliminée pour tous ses services producteurs, elle sera effectivement éliminée dans le système, c’est-à-dire immédiatement déréférencée pour ne plus permettre à un utilisateur d’y accéder.

Une élimination complète, au sens de la suppression du fichier de toutes les offres de stockage, n’est pas possible à garantir, compte tenu des technologies utilisées.

Quand une unité archivistique n’est éliminable que pour l’un de ses services producteurs, l’élimination pour ce service producteur se fait sous la forme d’une modification d’arborescence : le lien de l’unité archivistique avec son unité archivistique parente pour ce service producteur est coupé. L’unité archivistique n’est plus accessible pour ce service producteur, mais reste disponible pour ses autres services producteurs.

Mise en œuvre de l’élimination
----

### Configuration
Il est possible d’ajouter des informations complémentaires dans les rapports d’élimination produits (identifiants métier, informations système) au moyen d’un paramétrage de plate-forme.

### Lancement d’une campagne d’évaluation des éliminables (analyse)
La solution logicielle permet d’étudier le caractère éliminable d’ensemble d’unités archivistiques. L’analyse peut porter sur des unités isolées, sur des unités et leur descendance, sur des entrées.

La date par rapport à laquelle se fait l’analyse peut se situer dans le passé ou le futur.

Il est ainsi possible de réaliser en cours d’année l’analyse des archives arrivées à échéance de leur durée d’utilité administrative au 31 décembre de l’année précédente ou bien de rechercher les archives qui deviendront éliminables à la fin de l’année.

Il est recommandé d’avoir un seuil de 100.000 unités archivistiques parcourues pour une requête d’analyse.

L’analyse permet de définir le statut des unités archivistiques concernées :
- à conserver : KEEP
- éliminable : DESTROY
- non décidable : CONFLICT.
Les unités archivistiques de statut DESTROY et CONFLICT sont indexées en base de données de manière à pouvoir faire l’objet de tris.

L’analyse permet également d’établir, pour les unités archivistiques de statut CONFLICT, la liste des services producteurs pour lesquels l’unité archivistique est éliminable et la liste des services producteurs pour lesquels l’unité archivistique doit être conservée.

De même, pour les cas de conflits, des informations supplémentaires sont indexées dans l’unité archivistique pour apporter des précisions sur la nature de certains conflits :
- lorsque le service producteur principal (producteur de l’entrée) demande la suppression de l’unité archivistique et un ou plusieurs services de rattachement demande sa conservation ; en effet, la suppression du service producteur principal d’une unité archivistique et la conservation des services de rattachement entraînerait des incohérences dans la base de données ; statut KEEP_ACCESS_SP ;
- lorsque deux règles passent par le même chemin ce qui rend impossible de couper le lien pour un parent et pas pour un autre, la solution logicielle indexe également le nœud posant problème (ParentUnitId) et les services producteurs concernés ; statut ACCESS_LINK_INCONSISTENCY ;
- lorsque l’unité archivistique a par héritage deux sorts finaux différents pour un même service producteur, la solution logicielle indexe également le service producteur concerné (OriginatingAgenciesInConflict) ; statut FINAL_ACTION_INCONSISTENCY,
- lorsque l’unité archivistique déclare en propre ou hérite d’une règle de gel qui interdit son élimination, la solution logicielle indexe également la règle concernée (HoldRuleIds) ;  statut BLOCKED_BY_HOLD_RULE.

Un conflit résulte d’une situation où la solution logicielle ne dispose pas des éléments permettant de conclure de manière certaine au caractère éliminable ou non éliminable de l’unité archivistique.
Une intervention humaine est nécessaire pour décider du sort final de l’unité archivistique. L’archiviste doit alors revoir les règles posées sur l’unité archivistique ou procéder à une réorganisation d’arborescence de sorte que, lorsqu’il relancera une phase d’analyse, la solution logicielle puisse interpréter les règles applicables à cette unité.

Les informations qui ont été indexées peuvent être interrogées et, pour certaines, être filtrées par des facettes afin de permettre une évaluation des résultats d’analyse pour que l’archiviste décide de prendre en compte ou non les unités archivistiques dans une campagne d’élimination :
- Services producteurs éliminables
- Services producteurs non éliminables
- Statut global d’élimination
- Informations étendues d’élimination
- Niveau de description
- Date de début
- Date de fin

L’archiviste peut exporter sous forme de DIP des listes filtrées des résultats de l’analyse des archives éliminables pour permettre la génération, depuis son front office, des bordereaux de demande d’élimination destinés aux services producteurs.

### Lancement d’une opération d’élimination (action)
La solution logicielle permet de lancer une opération d’élimination d’unités archivistiques. Cette opération peut être lancée indépendamment d’une campagne d’évaluation des éliminables et porter sur des unités archivistiques n’ayant encore jamais été analysées par la solution logicielle.
L’analyse peut porter sur des unités isolées, sur des unités et leur descendance, sur des entrées.

L’opération d’élimination peut être lancée par rapport à une date située dans le passé ou à la date du jour. Elle ne peut pas être lancée par rapport à une date située dans le futur.

Pour des raisons liées aux problématiques de calcul de graphe, il n’est pas possible de lancer cette action si une autre action d’élimination est en cours (ou en pause) ou en parallèle d’une action de modification d’arborescence. La solution logicielle vérifie si des processus concurrents ne sont pas en cours au lancement du processus d’élimination.

Il est recommandé d’avoir un seuil de 10.000 unités archivistiques parcourues pour une requête d’élimination.

Seules les unités archivistiques dont la solution logicielle peut déterminer le sort final applicable en fonction des règles de gestion portées par les unités archivistiques (échéance expirée et sort final « détruire » au titre d’un même service producteur, absence de règles de gel non expirées à date) sont effectivement éliminées.

L’opération d’élimination implique donc que la mise en œuvre de l’élimination proprement dite soit immédiatement précédée dans la solution logicielle d’une phase d’analyse du caractère éliminable des unités archivistiques. Cette phase d’analyse systématique calcule les mêmes statuts qu’une campagne d’évaluation des archives éliminables (cf. ci-dessus), mais sans indexation des résultats dans les métadonnées des unités archivistiques :
- unités archivistiques dont le statut est « à conserver » (Global Status : KEEP),
- unités archivistiques dont le statut ne peut être déterminé (Global Status : CONFLICT),
- unités archivistiques dont le statut est « éliminable » (Global Status : DESTROY).

La présence d’unités archivistiques de statut KEEP conduira à une opération en avertissement, mais n’interrompt pas le processus.

Une vérification supplémentaire est effectuée sur les unités archivistiques éliminables : celles qui ont des enfants encore à conserver ne sont pas éliminées afin de ne pas créer des unités archivistiques orphelines qui auraient perdu leurs parents et ne seraient plus accessibles par leurs grands-parents (statut spécifique à cette phase : NON_DESTROYABLE_HAS_CHILD_UNITS).

Ainsi, sur toutes les unités archivistiques soumises, seules celles dont le sort final est « détruire », qui ont une règle de gestion expirée et qui n’ont pas d’enfants encore à conserver sont donc effectivement éliminées.

La présence d’unités archivistiques de statut DESTROY qui ne peuvent être effectivement éliminées conduira à une opération en avertissement, mais n’interrompt pas le processus.

Une fois le statut des unités archivistiques déterminé, la solution logicielle étudie les groupes d’objets techniques (GOT) associés aux unités archivistiques :
- si l’unité archivistique est conservée, le GOT est conservé (KEEP),
- si le GOT n’est associé qu’à une unité archiviqtique et que celle-ci est éliminée, le GOT est éliminé (statut DELETED),
- si le GOT est associé à une unité archivistique éliminée et à une unité archivistique non éliminée, le GOT est détaché (statut PARTIAL_DETACHMENT).

Le statut de l’opération à l’issue de la mise en œuvre de l’élimination pourra être :
- succès : toutes les unités archivistiques soumises ont été éliminées ;
- avertissement : parmi les unités archivistiques soumises, la phase d’analyse a permis de déterminer que certaines ne devaient pas être éliminées ou ne pouvaient pas l’être ;
- fatal : une erreur technique s’est produite lors du processus de mise en œuvre de l’élimination.

Le rapport de l’opération de mise en œuvre de l’élimination permet de retrouver :
- les unités archivistiques dont le statut est « à conserver » (GLOBAL_STATUS_KEEP),
- les unités archivistiques dont le statut ne peut être déterminé (GLOBAL_STATUS_CONFLICT),
- les unités archivistiques dont le statut est « à éliminer », mais qui ne peuvent pas être supprimées car elles ont des enfants (NON_DESTROYABLE_HAS_CHILD_UNITS),
- les unités archivistiques qui ont pu être supprimées (DELETED),
- les GOT qui ont été supprimés (DELETED),
- les GOT qui ont été détachés (PARTIAL_DETACHMENT).
Les GOT des unités archivistiques conservées ne sont pas listés dans le rapport.

On a considéré pour le développement de la fonctionnalité d’élimination que la phase de mise en œuvre de l’élimination serait déclenchée par l’archiviste sur la base d’une évaluation préalable du caractère éliminable des archives. Dans ces conditions, la présence de documents non éliminables est une anomalie et c’est pour cette raison que le rapport liste les unités archivistiques dont le statut est « à conserver » au lieu de les ignorer comme en phase d’évaluation.

### Mise à jour du registre des fonds

Les éliminations d’archives ont des conséquences sur le registre des fonds propres et symboliques.

Pour les fonds propres, les totaux d’unités archivistiques, groupes d’objets techniques, objets techniques et la volumétrie sont mis à jour immédiatement. Le détail de l’opération d’entrée concernée est également mis à jour. En cliquant sur la ligne de cette opération, l’utilisateur peut connaître toutes les opérations qui ont affecté cette entrée et le nombre d’unités archivistiques, groupes d’objets techniques et objets techniques ainsi que la volumétrie concernée pour chacune des opérations, celle de l’entrée initiale comme celles des éliminations qui ont ensuite affecté cette entrée.

Pour les fonds symboliques, au moment du calcul périodique des fonds symboliques de la base, les unités archivistiques, groupes d’objets techniques et objets techniques éliminés seront décomptés et la volumétrie sera mise à jour.

Le calcul des unités archivistiques, groupes d’objets techniques et objets techniques rattachés à un producteur au titre de son fonds symbolique n’est effectué qu’une fois par vingt-quatre heures (sauf paramétrage différent de la plate-forme). Dans ces conditions, si sur la même période de vingt-quatre heures l’archiviste effectue une entrée de 3 unités archivistiques et une élimination de 3 unités archivistiques, le total des unités archivistiques symboliques entre deux calculs n’aura pas évolué.