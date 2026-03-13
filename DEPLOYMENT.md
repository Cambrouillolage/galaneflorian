# Mise en prod (MEP)

Ce projet est un site statique (HTML/CSS/JS) deploye sur GitHub Pages, sans GitHub Actions.

## 1) Prerequis (une seule fois)

1. Pousser le repository sur GitHub
2. Ouvrir Settings > Pages
3. Dans Build and deployment, choisir Deploy from a branch
4. Selectionner Branch: main
5. Selectionner Folder: /(root)
6. Enregistrer

## 2) Preflight obligatoire avant MEP

Lancer les controles automatiques:

```bash
./scripts/preflight.sh
```

Le script verifie notamment:

1. Presence des fichiers critiques
2. Chemins HTML (pas de chemins absolus cassants)
3. References locales vers les assets
4. Presence des images photos et liste de mariage
5. Presence d'un webhook configure

Si le script retourne une erreur, corriger avant de deployer.

## 3) Deploiement production

Le site est publie depuis la branche main (racine du projet).

Commandes recommandées:

```bash
git checkout main
git pull origin main
git merge <ta-branche>
./scripts/preflight.sh
git push origin main
```

Ensuite, attendre 1 a 3 minutes le temps que GitHub Pages publie la mise a jour.

## 4) Verification post-deploiement

Verifier rapidement:

1. Ouverture de la page d'accueil
2. Navigation entre sections
3. Chargement des photos
4. Chargement des visuels de la liste de mariage
5. Ouverture du formulaire de participation

## 5) URL de prod

URL standard:

- https://<owner>.github.io/<repo>/

Dans ce projet:

- https://Cambrouillolage.github.io/galaneflorian/

## 6) Verification locale rapide

```bash
python3 -m http.server 8000
```

Puis ouvrir:

- http://localhost:8000/index.html
- http://localhost:8000/mariage_premium_site.html

## 7) Rollback simple

En cas de probleme:

1. Identifier le dernier commit stable
2. Revenir dessus (revert ou reset selon votre process)
3. Push sur main
4. GitHub Pages republie automatiquement cette version
