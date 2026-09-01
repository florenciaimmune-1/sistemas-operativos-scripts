#!/bin/bash

# ─────────────────────────────────────────────
# organizador_archivos.sh
# Organiza los archivos de una carpeta por
# fecha de modificación y extensión.
# Uso: ./organizador_archivos.sh <ruta_carpeta>
# ─────────────────────────────────────────────

if [ $# -lt 1 ]; then
    echo "Uso: $0 <ruta_carpeta>"
    exit 1
fi

CARPETA=$1

if [ ! -d "$CARPETA" ]; then
    echo "Error: la carpeta '$CARPETA' no existe"
    exit 1
fi

echo "===== Organizando: $CARPETA ====="

# Recorrer solo los archivos directos de la carpeta (no subdirectorios)
find "$CARPETA" -maxdepth 1 -type f | while read -r archivo; do

    # Obtener fecha de modificación
    FECHA=$(stat -c %y "$archivo" | cut -d' ' -f1)

    # Obtener extensión (en minúsculas)
    NOMBRE=$(basename "$archivo")
    EXTENSION="${NOMBRE##*.}"

    # Si no tiene extensión, usar "sin_extension"
    if [ "$EXTENSION" = "$NOMBRE" ]; then
        EXTENSION="sin_extension"
    fi
    EXTENSION=$(echo "$EXTENSION" | tr '[:upper:]' '[:lower:]')

    # Crear carpeta destino: fecha/extension
    DESTINO="$CARPETA/$FECHA/$EXTENSION"
    mkdir -p "$DESTINO"

    # Mover el archivo
    mv "$archivo" "$DESTINO/"
    echo "[MOVIDO] $NOMBRE → $FECHA/$EXTENSION/"

done

echo ""
echo "===== Resultado final ====="
find "$CARPETA" -type f | sort
