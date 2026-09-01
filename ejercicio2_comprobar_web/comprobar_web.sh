#!/bin/bash

# ─────────────────────────────────────────────
# comprobar_web.sh
# Comprueba si una URL devuelve HTTP 200
# Uso: ./comprobar_web.sh https://ejemplo.com
# ─────────────────────────────────────────────

LOG=~/scripts/comprobar_web.log

if [ $# -lt 1 ]; then
    echo "Uso: $0 <URL>"
    exit 1
fi

URL=$1
FECHA=$(date "+%Y-%m-%d %H:%M:%S")

CODIGO=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 "$URL")

if [ "$CODIGO" = "200" ]; then
    RESULTADO="OK"
else
    RESULTADO="FALLO"
fi

echo "[$FECHA] URL: $URL | Código: $CODIGO | Resultado: $RESULTADO" >> "$LOG"
echo "[$FECHA] URL: $URL | Código: $CODIGO | Resultado: $RESULTADO"
