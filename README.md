# galaneflorian

Site statique de mariage (HTML/CSS/JS).

## Lancer en local

```bash
python3 -m http.server 8000
```

Puis ouvrir:

- http://localhost:8000/index.html
- http://localhost:8000/mariage_premium_site.html

## Mise en production

Le projet est configure pour un deploiement classique GitHub Pages (sans GitHub Actions).

- Guide detaille: [DEPLOYMENT.md](DEPLOYMENT.md)

Commande de verification avant MEP:

```bash
./scripts/preflight.sh
```

Configurer dans GitHub: Settings > Pages > Deploy from a branch > `main` + `/(root)`.