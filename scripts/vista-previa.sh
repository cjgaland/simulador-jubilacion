#!/usr/bin/env bash
#
# vista-previa.sh — Vista previa PRIVADA de la versión en desarrollo (no se publica en Internet).
# Sirve la carpeta del proyecto desde este Mac:
#   · en el ordenador:  http://localhost:8080/
#   · en el móvil:      http://<IP-del-Mac>:8080/  (el móvil debe estar en la misma Wi-Fi)
# Para pararla: Ctrl+C (o cerrar la Terminal).
#
# Uso: bash scripts/vista-previa.sh

set -euo pipefail
cd "$(dirname "$0")/.."
PUERTO=8080
IP=$(ipconfig getifaddr en0 2>/dev/null || ipconfig getifaddr en1 2>/dev/null || echo "")

echo "Rama: $(git branch --show-current)"
echo "Vista previa privada (solo en tu red):"
echo "  · Ordenador: http://localhost:$PUERTO/"
[ -n "$IP" ] && echo "  · Móvil (misma Wi-Fi): http://$IP:$PUERTO/"
echo "Ctrl+C para parar."
python3 -m http.server "$PUERTO" --bind 0.0.0.0
