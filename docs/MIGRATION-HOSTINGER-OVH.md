# Mise en ligne : Hostinger ou OVH + nom de domaine

Le site est 100 % compatible avec l'hébergement mutualisé des deux hébergeurs. Le principe est toujours le même :
**envoyer le contenu du dossier `public/` dans le dossier web de l'hébergement**.

| | Hostinger | OVH |
|---|---|---|
| Offre suffisante | « Premium » / « Single » (hébergement web) | « Perso » (hébergement web) |
| Dossier web | `/public_html` | `/www` |
| Accès FTP | hPanel › Fichiers › Comptes FTP | Espace client › Web Cloud › Hébergements › onglet FTP-SSH |
| Serveur FTP | `ftp.votre-domaine.fr` (ou l'IP indiquée) | `ftp.clusterXXX.hosting.ovh.net` |
| Certificat SSL (HTTPS) | hPanel › Sécurité › SSL (gratuit) | Hébergements › onglet Informations générales › Certificat SSL (Let's Encrypt gratuit) |
| E-mail @domaine | hPanel › E-mails | Web Cloud › E-mails |

> Conseil : choisissez **un seul** hébergeur pour le site. Vous pouvez en revanche acheter le nom de domaine chez l'un et héberger chez l'autre (voir plus bas).

---

## 1. Le nom de domaine

### Garder `cours-danse89.fr`
Le domaine est aujourd'hui chez **IONOS**. Pour le déplacer :

1. Chez IONOS : *Domaines & SSL* › le domaine › **désactiver la protection de transfert** et **demander le code d'autorisation (AuthCode)**.
2. Chez Hostinger (*Domaines › Transférer*) ou OVH (*Commander › Transfert de domaine*) : saisir le domaine et l'AuthCode.
3. Valider l'e-mail de confirmation. Le transfert prend de quelques heures à 5 jours.

⚠ Avant de résilier IONOS : vérifiez qu'aucune boîte e-mail en `@cours-danse89.fr` n'est utilisée, et **gardez l'ancien site en ligne jusqu'à ce que le nouveau fonctionne**.

### Ou prendre un nouveau domaine
Ex. `mogy-danse.fr` (≈ 7 à 12 €/an). Le fichier `.htaccess` redirige déjà les anciennes adresses (`/danses-enseignees/`, `/contacts/`…) vers les nouvelles pages ; si vous changez de domaine, pensez à mettre à jour `robots.txt` et `sitemap.xml`.

### Domaine chez l'un, site chez l'autre
Dans la zone DNS du registrar, pointez le domaine vers l'hébergement :
- **Hostinger** : changez les serveurs DNS pour `ns1.dns-parking.com` / `ns2.dns-parking.com` (valeurs affichées dans hPanel), ou créez un enregistrement **A** vers l'IP indiquée dans hPanel.
- **OVH** : enregistrement **A** vers l'IP du cluster (visible dans *Hébergements › Informations générales*).

La propagation DNS prend jusqu'à 24 h.

---

## 2. Envoyer le site

### Méthode A — Le script (recommandé)
```bash
cp deploiement.env.exemple deploiement.env
nano deploiement.env           # remplir hôte, utilisateur, dossier
./scripts/deployer.sh --test   # simulation
./scripts/deployer.sh          # envoi réel (le mot de passe est demandé)
```
Seuls les fichiers modifiés sont renvoyés les fois suivantes.

### Méthode B — FileZilla (graphique)
```bash
sudo apt install filezilla
```
Connectez-vous avec les accès FTP, puis glissez **le contenu** de `public/` (pas le dossier lui-même) dans `public_html` (Hostinger) ou `www` (OVH).
Pensez à afficher les fichiers cachés (menu *Serveur › Forcer l'affichage des fichiers cachés*) pour que `.htaccess` soit bien envoyé.

### Méthode C — Gestionnaire de fichiers en ligne
Compressez `public/` en ZIP (`cd public && zip -r ../site.zip .`), envoyez-le via le gestionnaire de fichiers de hPanel ou via FTP, puis décompressez-le dans le dossier web.

### Méthode D (Hostinger uniquement) — Déploiement Git automatique
hPanel › Avancé › **Git** : indiquez l'URL du dépôt GitHub, branche `main`, dossier d'installation `public_html`.
⚠ Hostinger déploie tout le dépôt : il faudra alors placer le site dans un sous-dossier ou copier `public/` ; la méthode A reste plus simple.

---

## 3. Après la mise en ligne — liste de contrôle

- [ ] **Activer le SSL** (HTTPS) dans le panneau de l'hébergeur. *Le `.htaccess` force le HTTPS : sans certificat actif, le site affichera une erreur. En attendant, mettez un `#` devant les 3 lignes « Forcer le HTTPS ».*
- [ ] Créer une adresse e-mail sur le domaine (ex. `contact@votre-domaine.fr`) et la mettre dans `contact.php` (constante `EXPEDITEUR`).
- [ ] Tester le formulaire de contact (vérifier aussi les spams).
- [ ] Remplir `mentions-legales.html` (adresse du siège, n° RNA, hébergeur réel).
- [ ] Vérifier le site sur téléphone.
- [ ] Déclarer le site dans [Google Search Console](https://search.google.com/search-console) et y envoyer `sitemap.xml`.
- [ ] Mettre à jour la fiche Google Business / Facebook du club avec la nouvelle adresse.
- [ ] Seulement ensuite : résilier l'offre IONOS MyWebsite.

## Formulaire de contact : si les e-mails n'arrivent pas

- **OVH** : la fonction `mail()` marche sans réglage ; l'expéditeur doit être une adresse du domaine hébergé.
- **Hostinger** : `mail()` fonctionne aussi, mais l'expéditeur **doit** être une adresse e-mail existante créée dans hPanel sur le même domaine.
- Toujours regarder dans les **spams** d'Orange au premier test.
