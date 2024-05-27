L’arbre de positionnement dans la solution logicielle Vitam
====

Un service d’archives peut avoir besoin d’organiser les fonds d’archives placés sous sa responsabilité, quel qu’en soit le producteur, afin de faciliter la recherche et la navigation dans ceux-ci. L’arbre de positionnement est, dans la solution logicielle Vitam, l’outil pour réaliser cette organisation des fonds. Il permettra à un service d’archives et à ses utilisateurs de rechercher un fonds d’archives et de le positionner dans une organisation plus globale.

Présentation de l’arbre de positionnement
----

### Périmètre de l’arbre de positionnement
Un arbre de positionnement est propre au tenant sur lequel il a été importé.

### Contrôles effectués à partir de l’arbre de positionnement
Il est possible d’utiliser l’arbre de positionnement :
- en entrée, pour rattacher/classer systématiquement des archives transférées dans la solution logicielle Vitam dans l’organisation globale des fonds d’archives sous la responsabilité du service d’archives. Cette opération peut être systématique, en paramétrant pour cela le contrat d’entrée, ou spécifique, via une déclaration dans le bordereau de transfert ;
- en accès, pour définir un périmètre autorisé pour la recherche, la consultation et la modification.
Les nœuds de l’arbre de positionnement pourront ainsi être déclarés dans un contrat d’entrée pour servir de nœud de rattachement systématique ou pour contrôler le périmètre des rattachements déclarés dans le bordereau de versement.
Dans un contrat d’accès, les nœuds de l’arbre de positionnement pourront être déclarés comme nœud de consultation ou nœud d’exclusion.

### Articulation des arbres de positionnement, des plans de classement et des SIP
Les arbres de positionnement, les plans de classement et les SIP constituent tous les trois des moyens d’organiser les archives sous la responsabilité d’un service d’archives. Ils se présentent tous les trois sous la forme d’arborescences d’unités archivistiques. Ils sont cependant traités de manière différente dans la solution logicielle Vitam. Les unités d’arbres de positionnement présentent les caractéristiques suivantes :
- elles ne peuvent être rattachées qu’à d’autres unités d’arbres ;
- elles peuvent avoir pour filles des unités archivistiques d’arbre, de plan ou des unités archivistiques standard ;
- elles ne déclarent pas de service producteur, elles ne sont donc pas comptabilisées dans le registre des fonds.

Configuration de l’arbre de positionnement
---
### Pourquoi constituer un arbre de positionnement ?
L’utilisation d’un arbre de positionnement n’est pas obligatoire. Il est tout à fait possible de verser des SIP en les plaçant tous au même niveau « racine » dans la solution logicielle Vitam.
Cependant, l’utilisation d’un arbre de positionnement permettra de :
- faciliter la navigation dans les archives transférées en permettant d’avoir un ou plusieurs niveaux d’organisation de celles-ci pour orienter l’utilisateur ;
- gérer plus finement les droits d’accès en excluant des parties d’arborescence ou en limitant l’accès à certaines parties de cette arborescence.

### Comment structurer un arbre de positionnement ?
Un arbre de positionnement peut être organisé :
- en fonction du statut juridique (archives publiques/archives privées) ;
- en fonction des catégories de services producteurs (archives de l’Etat/archives des collectivités/archives privées) ;
- par période (Ancien Régime…) ;
- par grandes fonctions (justice, défense, éducation, etc.) ;
- thématiquement.
La structuration retenue dépendra des besoins d’orientation des utilisateurs et de gestion des droits d’accès.
Par exemple, les Archives nationales ont mis en place un arbre de positionnement fondé sur des domaines fonctionnels correspondant aux grandes politiques publiques de l’État.

### Quelle profondeur pour un arbre de positionnement ?
Un arbre de positionnement n’a pas nécessairement besoin d’avoir une grande profondeur pour faciliter la navigation dans les archives.
Par exemple, pour un service d’archives départementales, un arbre de positionnement pourrait ne définir que quelques branches : archives de l’État, archives du conseil départemental, archives communales, archives notariales, archives privées, pour fournir une orientation générale dans les fonds. Si le besoin en est ressenti, un deuxième niveau pourrait être ajouté pour distinguer dans les archives de l’État celles de la préfecture, celles des services déconcentrés…

Avant de commencer à réaliser des transferts, il est fortement recommandé de travailler sur l’organisation des archives transférées au sein de la solution logicielle Vitam. Une fois en production, des modifications ponctuelles d’arborescence (rattachement et détachement d’une unité archivistique) seront possibles, mais il s’agit potentiellement d’opérations lourdes car ayant un impact sur toute la descendance de l’unité archivistique.

### Transposition d’outils existants
La notion d’arbre de positionnement s’apparente à celle de cadre de classement existant aux Archives nationales ou dans les services d’archives départementaux ou communaux.

Toutefois, un arbre de positionnement peut être utilisé pour décrire la structure des fonds d’un service en dehors de toute référence à un cadre de classement normatif.

Pour élaborer son arbre de positionnement, l’administrateur fonctionnel pourra donc s’appuyer sur diverses documentations métier existantes : cadre de classement, guide des fonds, présentation des archives…
Dans certains cas, des services d’archives disposant d’un « plan de classement » alimenté par les versements des services producteurs auront tout intérêt à traduire cette structure dans la solution logicielle Vitam au moyen d’un arbre de positionnement, dès lors que cette structuration est plus thématique qu’organique et qu’il n’est pas nécessaire d’associer à ces unités archivistiques des services producteurs et des règles de gestion (cf. [vademecum Positionner des règles de gestion dans la solution logicielle Vitam](./Vademecum_reglesgestion_fonctionnement.md)).

### Formalisation de l’arbre de positionnement
Les arbres de positionnement sont importés dans la solution logicielle Vitam sous la forme de SIP contenant un bordereau de transfert, mais sans aucun objet associé. L’arbre de positionnement ne peut pas contenir de règle de gestion ni de service producteur associé à l’entrée ou aux unités archivistiques.

La description des unités archivistiques de type arbre de positionnement comprend : 
- des champs d’identification : identifiants fournis par le service d’archives (ex : cotation) – facultatif,
- le niveau de description associé à l’unité archivistique – obligatoire,
- des champs de description correspondant soit à une description minimale conforme à la norme ISAD(G), soit à une description enrichie conformément aux besoins du service producteur. Conformément à la norme ISAD(G), un intitulé est obligatoire.

Pour en savoir plus, consulter le [document VITAM. Modèle de données](./modele_de_donnees.md).

La moulinette ReSIP permet d’importer une structure arborescente d’unités archivistiques correspondant à un arbre de positionnement sous la forme d’un fichier tableur au format .csv pour en générer le SIP.

Pour plus de précision sur la constitution de ce fichier se référer au document Vitam. ReSIP.

Rattachement et modification d’un arbre de positionnement
-----

### Rattachement à l’import
Il est possible de rattacher un arbre de positionnement à un arbre existant déjà dans le système par déclaration dans le bordereau de versement ou par rattachement systématique déclaré dans le contrat d’entrée à condition de respecter les règles de structuration de l’information dans la solution logicielle Vitam.

### Modification de l’arbre de positionnement
La solution logicielle Vitam permet également de modifier l’arborescence d’unités archivistiques d’arbre de positionnement déjà entrées dans le système. Il est possible de :
- modifier les intitulés des unités archivistiques d’arbre (modification unitaire ou en masse) ;
- rattacher une arborescence d’archives à un arbre de positionnement ;
- rattacher le plan de classement d’un service producteur à un arbre de positionnement,
- rattacher un arbre de positionnement à un autre arbre de positionnement ;
- supprimer un rattachement à un arbre de positionnement ;
- supprimer des branches d’arbre de positionnement dans le cadre d’une opération d’élimination.
L’opération est journalisée dans le journal du cycle de vie de l’unité archivistique ayant été rattachée, déplacée ou supprimée.

Pour aller plus loin, consulter le [document VITAM. Gestion des archives et des arborescences](./gestion_archives_arbo.md).