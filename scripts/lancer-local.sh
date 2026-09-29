#!/usr/bin/env bash
# ---------------------------------------------------------------------------
# Lance le site en local : http://localhost:8000
# Usage :  ./scripts/lancer-local.sh [port]
# ---------------------------------------------------------------------------
cd "$(dirname "$0")/../public"
PORT="${1:-8000}"

echo "Site disponible sur : http://localhost:$PORT   (Ctrl+C pour arrêter)"
if command -v php >/dev/null 2>&1; then
  # Le serveur PHP permet aussi de tester le formulaire (l'e-mail ne partira pas en local)
  php -S "localhost:$PORT"
else
  echo "(PHP absent : serveur Python utilisé, le formulaire de contact ne fonctionnera pas)"
  python3 -m http.server "$PORT" --bind 127.0.0.1
fi
