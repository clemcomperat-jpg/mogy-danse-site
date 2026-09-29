#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Télécharge toutes les photos de l'ancien site (www.cours-danse89.fr)
# et les range dans public/assets/img/ avec des noms clairs.
# Usage :  ./scripts/recuperer-images.sh
# ---------------------------------------------------------------------------
set -u
cd "$(dirname "$0")/.."

SRC="https://www.cours-danse89.fr/s"
DEST="public/assets/img"
mkdir -p "$DEST/bandeaux" "$DEST/professeurs" "$DEST/photos"

ok=0; ko=0
telecharger() { # $1 = URL source, $2 = fichier de destination
  if curl -fsSL --retry 2 -A "Mozilla/5.0 (X11; Linux x86_64)" -o "$DEST/$2" "$1"; then
    echo "  ✔ $2"; ok=$((ok+1))
  else
    echo "  ✘ $2  ($1)"; rm -f "$DEST/$2"; ko=$((ko+1))
  fi
}

echo "▶ Logo et visuels généraux"
telecharger "$SRC/misc/logo.png"                              "logo.png"
telecharger "$SRC/cc_images/cache_12717273.jpg"               "ffd.jpg"
telecharger "$SRC/cc_images/teaserbox_31834956.jpg"           "accueil-club.jpg"

echo "▶ Bandeaux des pages"
telecharger "$SRC/img/emotionheader19929696.jpg"              "bandeaux/accueil.jpg"
telecharger "$SRC/img/emotionheader13826658.JPG"              "bandeaux/danses.jpg"
telecharger "$SRC/img/emotionheader13826981.JPG"              "bandeaux/professeurs.jpg"
telecharger "$SRC/img/emotionheader13827007.jpg"              "bandeaux/photos.jpg"
telecharger "$SRC/img/emotionheader13827111.JPG"              "bandeaux/videos.jpg"
telecharger "$SRC/img/emotionheader13826913.JPG"              "bandeaux/horaires.jpg"
telecharger "$SRC/img/emotionheader13827130.JPG"              "bandeaux/contact.jpg"

echo "▶ Professeurs"
telecharger "$SRC/cc_images/teaserbox_12697523.JPG"           "professeurs/monik-gilles.jpg"
telecharger "$SRC/cc_images/teaserbox_20340938.jpg"           "professeurs/prof-2.jpg"
telecharger "$SRC/cc_images/teaserbox_28303347.jpg"           "professeurs/prof-3.jpg"

echo "▶ Photos — Forum des associations Leclerc"
telecharger "$SRC/cc_images/teaserbox_17582713.jpg"           "photos/forum-leclerc-1.jpg"
telecharger "$SRC/cc_images/teaserbox_17582696.jpg"           "photos/forum-leclerc-2.jpg"

echo "▶ Photos — Initiation kizomba"
telecharger "$SRC/cc_images/teaserbox_16652448.jpg"           "photos/kizomba-1.jpg"
telecharger "$SRC/cc_images/teaserbox_30726731.JPG"           "photos/kizomba-2.jpg"
telecharger "$SRC/cc_images/teaserbox_30726732.JPG"           "photos/kizomba-3.jpg"
telecharger "$SRC/cc_images/teaserbox_31674612.jpg"           "photos/kizomba-4.jpg"
telecharger "$SRC/cc_images/teaserbox_30726733.JPG"           "photos/kizomba-5.jpg"
telecharger "$SRC/cc_images/teaserbox_16562345.jpg"           "photos/kizomba-6.jpg"

echo "▶ Photos — Forum des associations Sens"
telecharger "$SRC/cc_images/teaserbox_12696761.JPG"           "photos/forum-sens-1.jpg"

echo "▶ Photos — Galerie Leclerc Sens"
telecharger "$SRC/cc_images/teaserbox_12697335.JPG"           "photos/galerie-leclerc-1.jpg"
telecharger "$SRC/cc_images/teaserbox_12474523.jpg"           "photos/galerie-leclerc-2.jpg"
telecharger "$SRC/cc_images/teaserbox_12474530.jpg"           "photos/galerie-leclerc-3.jpg"

echo
echo "Terminé : $ok image(s) récupérée(s), $ko échec(s)."
[ "$ko" -gt 0 ] && echo "Pour les échecs, enregistrez l'image depuis l'ancien site (clic droit > Enregistrer) sous le nom indiqué."

# Optimisation facultative des JPEG (si jpegoptim est installé)
if command -v jpegoptim >/dev/null 2>&1; then
  echo "▶ Optimisation des JPEG…"
  find "$DEST" -name '*.jpg' -exec jpegoptim --max=85 --strip-all -q {} +
fi
