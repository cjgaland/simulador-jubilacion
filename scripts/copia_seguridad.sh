#!/usr/bin/env bash
#
# copia_seguridad.sh — Copia de seguridad local de un proyecto, con rotación.
#
# Crea una carpeta dentro de <proyecto>/Backup/ con una copia completa del
# proyecto (rsync -a) excluyendo lo que no aporta o no debe versionarse, y
# mantiene solo las N copias más recientes (por defecto 5), borrando la más
# antigua antes de crear una nueva.
#
# Formato del nombre de cada copia:
#     Copia_Seguridad_<NOMBRE_CORTO>_DD_MM_YYYY-HH_MM
#
# Uso:
#     copia_seguridad.sh [--root RUTA] [--name NOMBRE] [--keep N] [--exclude PATRON]...
#
#   --root RUTA      Raíz del proyecto a copiar. Por defecto: directorio actual.
#   --name NOMBRE    Identificador corto y sin espacios del proyecto. Por
#                    defecto: el nombre de la carpeta raíz, saneado.
#   --keep N         Número de copias a conservar. Por defecto: 5.
#   --exclude PATRON Patrón extra a excluir (se puede repetir). Se suman a los
#                    que se detectan automáticamente.
#
# Exclusiones automáticas:
#   - Siempre: Backup, .git
#   - Si existen en la raíz: node_modules, .firebase, dist, build, .next,
#     .cache, .venv, .DS_Store, .parcel-cache, coverage
#   - Datos personales / secretos: *.csv, .env, .env.* (los mismos que se
#     suelen ignorar en git)
#
# Compatible con el bash 3.2 que trae macOS (no usa mapfile/readarray).
# Salida: imprime la ruta de la copia creada y lista el contenido de Backup/.

set -euo pipefail

ROOT="$(pwd)"
NAME=""
KEEP=5
EXTRA_EXCLUDES=()

while [[ $# -gt 0 ]]; do
    case "$1" in
        --root)    ROOT="$2"; shift 2 ;;
        --name)    NAME="$2"; shift 2 ;;
        --keep)    KEEP="$2"; shift 2 ;;
        --exclude) EXTRA_EXCLUDES+=("$2"); shift 2 ;;
        *) echo "Opción desconocida: $1" >&2; exit 1 ;;
    esac
done

# Normaliza la raíz a ruta absoluta.
ROOT="$(cd "$ROOT" && pwd)"

# Deriva un nombre corto saneado si no se ha pasado.
if [[ -z "$NAME" ]]; then
    NAME="$(basename "$ROOT")"
fi
# Sanea: sustituye espacios y caracteres raros por "_" y colapsa repetidos.
NAME="$(printf '%s' "$NAME" | tr ' /:' '___' | tr -cd '[:alnum:]_-' | sed 's/__*/_/g; s/^_//; s/_$//')"
[[ -z "$NAME" ]] && NAME="proyecto"

BACKUP_DIR="$ROOT/Backup"
mkdir -p "$BACKUP_DIR"

# --- Construye la lista de exclusiones de rsync ---
EXCLUDES=(--exclude "Backup" --exclude ".git")

# Carpetas de dependencias/caché que solo se añaden si existen realmente.
for d in node_modules .firebase dist build .next .cache .venv .parcel-cache coverage .DS_Store; do
    if [[ -e "$ROOT/$d" ]]; then
        EXCLUDES+=(--exclude "$d")
    fi
done

# Datos personales / secretos: mismos patrones que se ignoran en git.
EXCLUDES+=(--exclude "*.csv" --exclude ".env" --exclude ".env.*")

# Exclusiones extra pasadas por el usuario (guardado seguro con set -u si vacío).
if [[ ${#EXTRA_EXCLUDES[@]} -gt 0 ]]; then
    for pat in "${EXTRA_EXCLUDES[@]}"; do
        [[ -n "$pat" ]] && EXCLUDES+=(--exclude "$pat")
    done
fi

# --- Rotación: deja como mucho (KEEP-1) para que al crear la nueva haya KEEP ---
# Ordenamos por fecha de modificación real (el nombre DD_MM_YYYY-HH_MM no ordena
# cronológicamente entre meses). Sin mapfile: leemos línea a línea.
COPIAS=()
while IFS= read -r linea; do
    [[ -n "$linea" ]] && COPIAS+=("$linea")
done < <(find "$BACKUP_DIR" -maxdepth 1 -type d -name 'Copia_Seguridad_*' \
            -exec stat -f '%m %N' {} \; 2>/dev/null | sort -n | sed 's/^[0-9]* //')

NUM="${#COPIAS[@]}"
if (( NUM >= KEEP )); then
    BORRAR=$(( NUM - KEEP + 1 ))
    for (( i=0; i<BORRAR; i++ )); do
        echo "Rotación: elimino copia antigua → $(basename "${COPIAS[$i]}")"
        rm -rf "${COPIAS[$i]}"
    done
fi

# --- Crea la nueva copia ---
STAMP="$(date +%d_%m_%Y-%H_%M)"
DEST="$BACKUP_DIR/Copia_Seguridad_${NAME}_${STAMP}"
mkdir -p "$DEST"

rsync -a "${EXCLUDES[@]}" "$ROOT/" "$DEST/"

echo ""
echo "✅ Copia creada: $DEST"
echo ""
echo "Contenido actual de Backup/ (más recientes abajo):"
find "$BACKUP_DIR" -maxdepth 1 -type d -name 'Copia_Seguridad_*' \
    -exec stat -f '%m %N' {} \; 2>/dev/null | sort -n \
    | sed 's/^[0-9]* //' | while IFS= read -r ruta; do
        [[ -n "$ruta" ]] && echo "  - $(basename "$ruta")"
    done
