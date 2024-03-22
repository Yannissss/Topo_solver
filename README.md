# Les jolis petits rayons
##  Reconstitution d'un fichier SYBYL mol2 complet

Ce projet vise à reconstituer un fichier SYBYL mol2 complet et valide à partir d'un fichier mol2 incomplet ne contenant que les coordonnées atomiques.

## Installation

Il suffit de cloner ce répertoire sur l'environnement de calculs ROMEO puis d'exécuter les commandes suivantes:
```bash
source source.env
make
```

## Validation

Pour tester le programme sur un jeu de test (1QSN_NO_BOND.mol2), il suffit d'exécuter la commande suivate:
```bash
make run
```

## Utilisation

```bash
./complete_mol2 Cov_radii <in_mol2_file> <out_mol2_file> \
    # Optional
    <tol_max:0.35> <tol_min:0.10> <tol_step:0.05>
```

## Améliorations possibles

Il a un bug possible du programme lorsque que le fichier d'entrer mol2 n'espace correctement les nombres dans sa déclaration des données de la molécule.

Le bug n'arrive pas sur les fichiers fournis dans ce répertoire.