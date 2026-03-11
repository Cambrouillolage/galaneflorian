# Mise en prod

Ce projet est un site statique (HTML/CSS/JS) et est pret pour un deploiement classique GitHub Pages (sans GitHub Actions).

## 1) Prerequis (une seule fois)

1. Pousser le repository sur GitHub
2. Ouvrir Settings > Pages
3. Dans Build and deployment, choisir Deploy from a branch
4. Selectionner Branch: main
5. Selectionner Folder: /(root)
6. Enregistrer

## 2) Deploiement production

Le site est publie depuis la branche main (racine du projet).

Commandes typiques:

```bash
git checkout main
git pull
git merge <ta-branche>
git push origin main
```

Ensuite, attendre 1 a 3 minutes le temps que GitHub Pages publie la mise a jour.

## 3) URL de prod

L'URL finale est generalement:

- https://<owner>.github.io/<repo>/

Dans ce projet:

- https://Cambrouillolage.github.io/galaneflorian/

## 4) Verification rapide avant push

```bash
python3 -m http.server 8000
```

Puis ouvrir:

- http://localhost:8000/index.html
- http://localhost:8000/mariage_premium_site.html

## 5) Rollback simple

En cas de probleme:

1. Revenir au commit precedent sur main
2. Push sur main
3. GitHub Pages republie automatiquement cette version
