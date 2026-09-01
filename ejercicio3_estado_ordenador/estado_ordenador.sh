#!/bin/bash

# ─────────────────────────────────────────────
# estado_ordenador.sh
# Comprueba CPU, RAM y disco cada minuto.
# Si CPU y RAM superan el 60% durante 3
# comprobaciones seguidas, reinicia la máquina.
# ─────────────────────────────────────────────

LOG=~/scripts/estado_ordenador.log
CONTADOR_FILE=~/scripts/.contador_alertas

# Obtener uso de CPU (parte entera, sin coma)
CPU=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}' | cut -d, -f1)

# Obtener uso de RAM en %
RAM=$(free | grep Mem | awk '{printf "%.0f", $3/$2 * 100}')

# Obtener uso del disco raíz en %
DISCO=$(df / | tail -1 | awk '{print $5}' | tr -d '%')

FECHA=$(date "+%Y-%m-%d %H:%M:%S")

# Guardar en log
echo "[$FECHA] CPU: ${CPU}% | RAM: ${RAM}% | Disco: ${DISCO}%" >> "$LOG"
echo "[$FECHA] CPU: ${CPU}% | RAM: ${RAM}% | Disco: ${DISCO}%"

# Leer contador actual
if [ -f "$CONTADOR_FILE" ]; then
    CONTADOR=$(cat "$CONTADOR_FILE")
else
    CONTADOR=0
fi

# Comprobar si CPU y RAM superan el 60%
if [ "$CPU" -gt 60 ] && [ "$RAM" -gt 60 ]; then
    CONTADOR=$((CONTADOR + 1))
    echo $CONTADOR > "$CONTADOR_FILE"
    echo "  ⚠ Alerta $CONTADOR/3: CPU=${CPU}% RAM=${RAM}%" >> "$LOG"
    echo "  ⚠ Alerta $CONTADOR/3"

    if [ "$CONTADOR" -ge 3 ]; then
        echo "[$FECHA] REINICIANDO: CPU y RAM por encima del 60% durante 3 comprobaciones." >> "$LOG"
        rm -f "$CONTADOR_FILE"
        sudo reboot
    fi
else
    echo 0 > "$CONTADOR_FILE"
fi
