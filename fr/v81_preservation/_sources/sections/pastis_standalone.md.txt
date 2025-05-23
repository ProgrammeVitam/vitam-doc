# PASTIS STANDALONE

## Résumé

### Documents de référence

|**Document**|**Date de la version**|**Remarques**|
|:---------------:|:-----:|:-----:|
|NF Z 44022 – MEDONA – Modélisation des données pour l’archivage       |18/01/2014| |         
|Standard d’échange de données pour l’archivage – SEDA – v. 2.1 | 06/2018| |
|Standard d’échange de données pour l’archivage – SEDA – v. 2.2 | 02/2022| |
|Standard d’échange de données pour l’archivage – SEDA – v. 2.3 | 06/2024| |

### Présentation du document

Le présent document présente l'application Pastis Standalone, qui est une version de l'application Profils Documentaires indépendante de la plateforme VITAM.

## Présentation, installation, et lancement de Pastis Standalone

### Présentation de Pastis Standalone

[EN CONSTRUCTION]

### Installation de Pastis Standalone

L'application Pastis Standalone est téléchargeable sur le site internet du programme Vitam à l’adresse suivante : https://download.programmevitam.fr/pastis-standalone/

Le fichier ZIP a un unique répertoire contenant :
- un environnement d'exécution Java 17, nécessaire si vous n'avez pas Java installé sur votre poste
- un fichier `readme.txt` décrivant succintement la procédure pour lancer l'application
- un fichier de configuration `PASTIS-APP.url`
- un fichier .exe, qui contient l'application devant être lancée

### Lancement de Pastis Standalone

Le lancement de Pastis Standalone se fait via un double-clic sur le fichier .exe cité précédemment.

### Extension du modèle du SEDA par des métadonnées externes

Depuis la version 8.1 de Vitam, il est possible d'enrichir le modèle des Profils d'archivage (PA) et des Profils d'unité archivistique (PUA) en ajoutant des champs personnalisés, qui viendront enrichir les informations des unités archivistiques.

Pour cela, il conviendra de créer un fichier de configuration nommé `external-schema-definition.json` placé dans le même répertoire que le fichier .exe.

Le contenu du fichier est au format JSON, avec la syntaxe suivante :

```json
[
  {
    "FieldName": "MyText",
    "Path": "Invoice.Provider.MyText",
    "ShortName": "Mon champ texte",
    "Type": "TEXT",
    "Cardinality": "ONE",
    "Description": "Extension au SEDA. Elément de type texte"
  },
  ...
]
```

Les champs attendus sont les suivants :

| **Champ** |**Description**|
|:---------:|:-----:|
|FieldName|Nom du champ, tel qu'il sera présent dans le contenu de l'unité archivistique|
|Path|Nom complet, depuis la racine. Les différents parents seront séparés par des '.'|
|ShortName|Libellé court du champ|
|Type|Type du champ. Voir plus bas pour les différentes valeurs possibles|
|Cardinality|Cardinalité du champ. Voir plus bas pour les différentes valeurs possibles|
|Description|Description longue du champ|


Valeurs possibles pour le champ "Type" :
- OBJECT : le champ sera un objet contenant des sous-champs
- DATE : le champ sera de type date
- KEYWORD ou ENUM : champ de type énuméré, sous forme d'une chaîne de caractères
- LONG : champ de type numérique entier
- DOUBLE : champ de type numérique décimal
- TEXT : chaîne de caractère
- BOOLEAN : champ de type booléen (vrai / faux, ou oui / non)

Valeurs possibles pour le champ "Cardinality" :
- ONE : le champ peut avoir zéro ou une seule occurrence
- ONE_REQUIRED : le champ est obligatoire et n'a qu'une seule occurrence
- MANY : le champ est répétable plusieurs fois, mais peut ne pas être présent
- MANY_REQUIRED : le champ est répétable plusieurs fois, mais doit apparaître au moins une fois

Il est possible de regrouper les métadonnées en arbre, en utilisant des métadonnées de type OBJECT, qui vont elle-même contenir d'autres métadonnées. L'organisation de l'arbre des métadonnées se fera avec la propriété `Path` de chaque métadonnée.

Par exemple, si nous avons créé une métadonnée `A` de type objet, on pourra créer une métadonnée `B` de type texte imbriquée dans `A` si pour `B` on définit la valeur `Path` à `A.B`. Attention, il faut bien s'assurer que tous les parents d'une métadonnée, tels que définis dans son `Path` existent bien.

Si, par exemple, nous souhaitons créer la structure suivante :
```
Invoice - Informations de facture (objet, optionnel, répétable)
    +--- FactDate - date de la facture (date, obligatoire, non répétable)
    +--- FactNum - numéro de facture (texte, obligatoire, non répétable)
    +--- FactDetail - détail de la facture (objet, obligatoire, répétable)
             +--- ItemName - Nom de l'article (texte, obligatoire, non répétable)
             +--- ItemQty - Nombre d'articles (entier, obligatoire, non répétable)
             +--- ItemUnitPrice - Prix unitaire de l'article (décimal, obligatoire, non répétable)
```

Le fichier de configuration `external-schema-definition.json` devra avoir le contenu suivant :

```json
[
  {
    "FieldName": "Invoice",
    "Path": "Invoice",
    "ShortName": "Informations de facture",
    "Type": "OBJECT",
    "Cardinality": "MANY",
    "Description": "Informations de facture, avec le détail des articles"
  },
  {
    "FieldName": "FactDate",
    "Path": "Invoice.FactDate",
    "ShortName": "Date de la facture",
    "Type": "DATE",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Date d'émission de la facture"
  },
  {
    "FieldName": "FactNum",
    "Path": "Invoice.FactNum",
    "ShortName": "Numéro de facture",
    "Type": "TEXT",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Numéro unique de la facture"
  },
  {
    "FieldName": "FactDetail",
    "Path": "Invoice.FactDetail",
    "ShortName": "Détails de la facture",
    "Type": "OBJECT",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Détails des articles de la facture"
  },
  {
    "FieldName": "ItemName",
    "Path": "Invoice.FactDetail.ItemName",
    "ShortName": "Nom de l'article",
    "Type": "TEXT",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Nom de l'article tel qu'indiqué sur la facture"
  },
  {
    "FieldName": "ItemQty",
    "Path": "Invoice.FactDetail.ItemQty",
    "ShortName": "Nombre d'articles",
    "Type": "LONG",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Nombre d'articles de ce type"
  },
  {
    "FieldName": "ItemUnitPrice",
    "Path": "Invoice.FactDetail.ItemUnitPrice",
    "ShortName": "Prix unitaire",
    "Type": "DOUBLE",
    "Cardinality": "ONE_REQUIRED",
    "Description": "Prix unitaire de l'article"
  }
]
```