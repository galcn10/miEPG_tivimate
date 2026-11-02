#!/bin/bash
# ============================================================================== 
# Script: miEPG.sh 
# Versión: 3.8
# Función: Combina múltiples XMLs, renombra canales, cambia logos y ajusta hora 
# ============================================================================== 

sed -i '/^ *$/d' epgs.txt
sed -i '/^ *$/d' canales.txt

rm -f EPG_temp* canales_epg*.txt

epg_count=0

echo "─── DESCARGANDO EPGs ───"

while IFS=, read -r epg; do
	((epg_count++))
    extension="${epg##*.}"
    if [ "$extension" = "gz" ]; then
        echo " │ Descargando y descomprimiendo: $epg"
        wget -O EPG_temp00.xml.gz -q "$epg"
        if [ ! -s EPG_temp00.xml.gz ]; then
            echo " └─► ❌ ERROR: El archivo descargado está vacío o no se descargó correctamente"
            continue
        fi
        if ! gzip -t EPG_temp00.xml.gz 2>/dev/null; then
            echo " └─► ❌ ERROR: El archivo no es un gzip válido"
            continue
        fi
        gzip -d -f EPG_temp00.xml.gz
    else
        echo " │ Descargando: $epg"
        wget -O EPG_temp00.xml -q "$epg"
        if [ ! -s EPG_temp00.xml ]; then
            echo " └─► ❌ ERROR: El archivo descargado está vacío o no se descargó correctamente"
            continue
        fi
    fi
	if [ -f EPG_temp00.xml ]; then
        listado="canales_epg${epg_count}.txt"
