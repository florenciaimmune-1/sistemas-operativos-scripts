#!/bin/bash

# ─────────────────────────────────────────────
# limpiar_carpeta.sh
# Limpia la carpeta actual: borra archivos que
# no contengan "importante" en el nombre.
# Si un archivo importante pesa más de 5 MB,
# lo comprime. Elimina carpetas vacías al final.
# ─────────────────────────────────────────────

echo "===== Inicio limpieza: $(date) ====="
echo "Directorio de trabajo: $(pwd)"
echo ""

# Recorrer todos los archivos (no directorios) de forma recursiva
find . -type f | while read -r archivo; do

    nombre=$(basename "$archivo")

    if echo "$nombre" | grep -q "importante"; then
        # El archivo contiene "importante" → conservar
        echo "[CONSERVAR] $archivo"

        # Comprobar si pesa más de 5 MB (5242880 bytes)
        tamanio=$(stat -c%s "$archivo")
        if [ "$tamanio" -gt 5242880 ]; then
            echo "  → Pesa más de 5 MB ($tamanio bytes). Comprimiendo..."
            gzip "$archivo"
            echo "  → Comprimido: ${archivo}.gz"
        fi
    else
        # No contiene "importante" → borrar
        echo "[BORRAR]    $archivo"
        rm -f "$archivo"
    fi

done

echo ""
echo "Eliminando carpetas vacías..."

# Eliminar directorios vacíos (de más profundo a más superficial)
find . -mindepth 1 -type d -empty -delete

echo ""
echo "===== Limpieza completada: $(date) ====="
