#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Installe sur une Debian vierge tout le nécessaire pour travailler sur le site
# Usage :  sudo ./scripts/installer-debian.sh
# ---------------------------------------------------------------------------
set -e

if [ "$(id -u)" -ne 0 ]; then
  echo "Lancez ce script avec sudo :  sudo ./scripts/installer-debian.sh"
  exit 1
fi

echo "▶ Mise à jour de la liste des paquets…"
apt-get update

echo "▶ Installation de git, curl, PHP (serveur local + formulaire), lftp (envoi FTP), jpegoptim…"
apt-get install -y git curl ca-certificates php-cli php-mbstring lftp jpegoptim

echo
echo "✔ Installation terminée."
php -v | head -n 1
git --version
echo
echo "Étapes suivantes :"
echo "  ./scripts/recuperer-images.sh   # récupérer les photos de l'ancien site"
echo "  ./scripts/lancer-local.sh       # voir le site sur http://localhost:8000"
