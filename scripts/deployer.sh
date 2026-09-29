#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Envoie le contenu de public/ sur l'hébergement (Hostinger ou OVH) par FTP/SFTP
#
# 1. Copiez le modèle :     cp deploiement.env.exemple deploiement.env
# 2. Remplissez vos accès dans deploiement.env (ce fichier n'est JAMAIS envoyé sur GitHub)
# 3. Lancez :               ./scripts/deployer.sh
#    Simulation sans rien envoyer :  ./scripts/deployer.sh --test
# ---------------------------------------------------------------------------
set -e
cd "$(dirname "$0")/.."

if [ ! -f deploiement.env ]; then
  echo "Fichier deploiement.env introuvable."
  echo "Faites :  cp deploiement.env.exemple deploiement.env   puis remplissez-le."
  exit 1
fi
# shellcheck disable=SC1091
source deploiement.env

: "${FTP_HOTE:?FTP_HOTE manquant dans deploiement.env}"
: "${FTP_UTILISATEUR:?FTP_UTILISATEUR manquant}"
: "${FTP_DOSSIER:?FTP_DOSSIER manquant}"
PROTOCOLE="${FTP_PROTOCOLE:-ftp}"

if ! command -v lftp >/dev/null 2>&1; then
  echo "lftp n'est pas installé :  sudo apt install lftp"
  exit 1
fi

if [ -z "${FTP_MOT_DE_PASSE:-}" ]; then
  read -r -s -p "Mot de passe FTP pour $FTP_UTILISATEUR : " FTP_MOT_DE_PASSE
  echo
fi

SIMULATION=""
[ "${1:-}" = "--test" ] && SIMULATION="--dry-run" && echo "(mode simulation : rien ne sera envoyé)"

echo "▶ Envoi de public/ vers $PROTOCOLE://$FTP_HOTE$FTP_DOSSIER …"
lftp -u "$FTP_UTILISATEUR","$FTP_MOT_DE_PASSE" "$PROTOCOLE://$FTP_HOTE" <<EOF
set ftp:ssl-allow yes
set ssl:verify-certificate no
set net:max-retries 2
mirror --reverse --verbose --only-newer $SIMULATION \
  --exclude-glob .DS_Store --exclude-glob '*.md' \
  public/ $FTP_DOSSIER
bye
EOF
echo "✔ Déploiement terminé."
