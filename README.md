# MOGY DANS' CLUB — Site web

Nouveau site du club de danse **Mogy Dans' Club** (Sens & Fouchères, Yonne), recréé de A à Z à partir du contenu de l'ancien site IONOS [cours-danse89.fr](https://www.cours-danse89.fr/).

- Site **statique** (HTML + CSS + un peu de JavaScript), sans base de données ni CMS : rapide, sûr, gratuit à maintenir.
- Un seul petit fichier **PHP** pour le formulaire de contact.
- Fonctionne tel quel sur **Hostinger** et **OVH** (hébergement mutualisé), et en local sur **Debian**.
- Aucun service externe (pas de Google Fonts ni de traqueur) : conforme RGPD, vidéos YouTube chargées au clic uniquement.

## Arborescence

```
mogy-danse-site/
├── public/                  ← LE SITE (c'est ce dossier qu'on envoie chez l'hébergeur)
│   ├── index.html           Accueil
│   ├── danses.html          Danses enseignées
│   ├── professeurs.html     Les professeurs
│   ├── photos.html          Galerie photos
│   ├── videos.html          Vidéos
│   ├── horaires.html        Horaires & calendrier
│   ├── contact.html         Contact + formulaire
│   ├── contact.php          Envoi du formulaire par e-mail
│   ├── mentions-legales.html
│   ├── 404.html
│   ├── .htaccess            HTTPS, redirections des anciennes adresses, cache
│   ├── robots.txt / sitemap.xml
│   └── assets/
│       ├── css/style.css    Couleurs, typographie, mise en page
│       ├── js/main.js       Menu mobile, visionneuse photos, vidéos
│       └── img/             Photos (remplies par scripts/recuperer-images.sh)
├── scripts/
│   ├── installer-debian.sh  Installe git, PHP, lftp… sur une Debian vierge
│   ├── recuperer-images.sh  Télécharge les photos de l'ancien site
│   ├── lancer-local.sh      Lance le site sur http://localhost:8000
│   └── deployer.sh          Envoie public/ chez Hostinger ou OVH (FTP)
├── docs/
│   ├── MIGRATION-HOSTINGER-OVH.md   Mise en ligne pas à pas + nom de domaine
│   └── CONTENU-A-VERIFIER.md        Infos incomplètes ou contradictoires de l'ancien site
└── deploiement.env.exemple  Modèle des accès FTP
```

## Démarrage rapide sur Debian vierge

```bash
# 1. Outils de base
sudo apt update && sudo apt install -y git

# 2. Récupérer le dépôt
git clone https://github.com/<votre-compte>/mogy-danse-site.git
cd mogy-danse-site

# 3. Installer le reste (PHP, lftp, jpegoptim…)
chmod +x scripts/*.sh
sudo ./scripts/installer-debian.sh

# 4. Rapatrier les photos de l'ancien site
./scripts/recuperer-images.sh

# 5. Voir le site
./scripts/lancer-local.sh
# → ouvrir http://localhost:8000 dans le navigateur
```

## Modifier le contenu

Chaque page est un simple fichier HTML dans `public/` : ouvrez-le avec un éditeur de texte (par ex. `nano`, `gedit` ou VS Code), modifiez le texte, enregistrez, rechargez la page dans le navigateur.

| Je veux changer…                        | Fichier                                             |
|-----------------------------------------|-----------------------------------------------------|
| les horaires, vacances, manifestations  | `public/horaires.html`                              |
| le texte d'accueil / portes ouvertes    | `public/index.html`                                 |
| un numéro de téléphone ou l'e-mail      | toutes les pages (pied de page) + `contact.html`    |
| l'adresse qui reçoit le formulaire      | `public/contact.php` (constante `DESTINATAIRE`)     |
| les couleurs du site                    | `public/assets/css/style.css` (haut du fichier)     |
| ajouter une photo                       | copier l'image dans `public/assets/img/photos/` et ajouter une ligne `<a href=…><img …></a>` dans `photos.html` |

Astuce : pour remplacer un texte partout d'un coup (ex. un numéro de téléphone) :

```bash
grep -rl "06 09 57 38 88" public/ | xargs sed -i "s/06 09 57 38 88/06 XX XX XX XX/g"
```

## Enregistrer ses modifications avec Git

```bash
git add -A
git commit -m "Mise à jour des horaires"
git push
```

## Mise en ligne

Voir **[docs/MIGRATION-HOSTINGER-OVH.md](docs/MIGRATION-HOSTINGER-OVH.md)**. En résumé :

```bash
cp deploiement.env.exemple deploiement.env   # puis remplir les accès FTP
./scripts/deployer.sh --test                 # simulation
./scripts/deployer.sh                        # envoi réel
```
