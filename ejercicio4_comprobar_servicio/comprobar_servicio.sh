#!/bin/bash

# ─────────────────────────────────────────────
# comprobar_servicio.sh
# Comprueba si un servicio está activo.
# Si no lo está, intenta levantarlo.
# Uso: ./comprobar_servicio.sh <nombre_servicio>
# ─────────────────────────────────────────────

LOG=~/scripts/comprobar_servicio.log

if [ $# -lt 1 ]; then
    echo "Uso: $0 <nombre_servicio>"
    exit 1
fi

SERVICIO=$1
FECHA=$(date "+%Y-%m-%d %H:%M:%S")

# Comprobar si el servicio está activo
if systemctl is-active --quiet "$SERVICIO"; then
    echo "[$FECHA] $SERVICIO: ACTIVO" >> "$LOG"
    echo "[$FECHA] $SERVICIO: ACTIVO"
else
    echo "[$FECHA] $SERVICIO: INACTIVO — intentando levantar..." >> "$LOG"
    echo "[$FECHA] $SERVICIO: INACTIVO — intentando levantar..."

    # Intentar levantar el servicio
    sudo systemctl start "$SERVICIO"

    # Comprobar si arrancó correctamente
    if systemctl is-active --quiet "$SERVICIO"; then
        echo "[$FECHA] $SERVICIO: levantado correctamente" >> "$LOG"
        echo "[$FECHA] $SERVICIO: levantado correctamente"
    else
        echo "[$FECHA] $SERVICIO: ERROR — no se pudo levantar" >> "$LOG"
        echo "[$FECHA] $SERVICIO: ERROR — no se pudo levantar"
    fi
fi
