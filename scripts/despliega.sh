#!/usr/bin/env bash
#
# despliega.sh — Despliegue del Simulador de Jubilación.
#   1. Comprueba que APP_VERSION (index.html), CHANGES, version.json y CHANGELOG.md coinciden.
#   2. Hace la copia de seguridad local en Backup/ (rotación de 5).
#   3. Commit y push a main → GitHub Pages publica solo en 1-2 minutos y los usuarios
#      ven el aviso «Ha habido cambios».
#
# Uso: bash scripts/despliega.sh "Mensaje del commit"

set -euo pipefail
cd "$(dirname "$0")/.."

MSG="${1:-}"
[ -n "$MSG" ] || { echo "Uso: bash scripts/despliega.sh \"Mensaje del commit\""; exit 1; }

V_HTML=$(grep -o "const APP_VERSION = '[^']*'" index.html | cut -d"'" -f2)
V_JSON=$(sed -n 's/.*"version": *"\([^"]*\)".*/\1/p' version.json)

fallo(){ echo "✗ $1"; exit 1; }
[ -n "$V_HTML" ]                    || fallo "No encuentro APP_VERSION en index.html"
[ "$V_HTML" = "$V_JSON" ]           || fallo "APP_VERSION ($V_HTML) y version.json ($V_JSON) no coinciden"
grep -q "{v:'$V_HTML'" index.html   || fallo "Falta la entrada $V_HTML en CHANGES (index.html)"
grep -q "## \[$V_HTML\]" CHANGELOG.md || fallo "Falta la entrada $V_HTML en CHANGELOG.md"
echo "✓ Versión $V_HTML coherente en index.html, version.json y CHANGELOG.md"

bash scripts/copia_seguridad.sh --name SimuladorJubilacion

git add -A
# Red de seguridad: el repo es público; nunca subir PDFs ni hojas de datos personales
PELIGRO=$(git diff --cached --name-only | grep -iE '\.(pdf|csv|xlsx?|ods|docx?)$' || true)
if [ -n "$PELIGRO" ]; then
  git reset -q
  fallo "Hay ficheros que podrían contener datos personales y NO se suben:
$PELIGRO
Muévelos fuera del proyecto o añádelos a .gitignore."
fi
if git diff --cached --quiet; then
  echo "No hay cambios que subir."
else
  git commit -q -m "$MSG"
fi
git push -q origin main
echo "✓ Subido a GitHub. En 1-2 minutos estará en https://cjgaland.github.io/simulador-jubilacion/"
