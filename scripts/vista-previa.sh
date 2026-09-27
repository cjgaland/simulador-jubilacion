#!/usr/bin/env bash
#
# vista-previa.sh — Vista previa PRIVADA de la versión en desarrollo (no se publica en Internet).
# Sirve la app desde este Mac (scripts/servidor-local.js: nunca sirve PDF ni datos personales):
#   · en el ordenador:  http://localhost:8080/
#   · en el móvil:      http://<IP-del-Mac>:8080/  (el móvil debe estar en la misma Wi-Fi)
# Para pararla: Ctrl+C (o cerrar la Terminal).
#
# Uso: bash scripts/vista-previa.sh

set -euo pipefail
cd "$(dirname "$0")/.."
PUERTO=8080
command -v node >/dev/null || { echo "✗ Falta Node.js (https://nodejs.org)"; exit 1; }
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")

echo "Rama: $(git branch --show-current 2>/dev/null || sed "s#.*/##" .git/HEAD)"
echo "Vista previa privada (solo en tu red):"
echo "  · Ordenador: http://localhost:$PUERTO/"
[ -n "$IP" ] && echo "  · Móvil (misma Wi-Fi): http://$IP:$PUERTO/"
echo "Ctrl+C para parar."
node scripts/servidor-local.js "$PUERTO"
