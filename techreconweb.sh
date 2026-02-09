#!/bin/bash
export PATH="$HOME/go/bin:$PATH"

# =========================
# Recon automático básico
# Uso: ./recon.sh -u https://objetivo.com
# =========================

while getopts "u:" opt; do
  case $opt in
    u) URL="$OPTARG" ;;
    *)
      echo "Uso: $0 -u https://objetivo.com"
      exit 1
      ;;
  esac
done

if [ -z "$URL" ]; then
  echo "❌ Falta la URL"
  echo "Uso: $0 -u https://objetivo.com"
  exit 1
fi

echo "🎯 Objetivo: $URL"
echo "=============================="

# Normalizar dominio para nombres de archivo
DOMAIN=$(echo "$URL" | sed 's~https\?://~~' | sed 's~/.*~~')

mkdir -p recon/$DOMAIN
cd recon/$DOMAIN || exit 1

echo "[+] Ejecutando httpx..."
echo "$URL" | httpx \
  -title \
  -tech-detect \
  -status-code \
  -silent \
  | tee httpx.txt

echo ""
echo "[+] Ejecutando nuclei (tech)..."
nuclei \
  -u "$URL" \
  -tags tech \
  -severity info,low,medium \
  -silent \
  | tee nuclei-tech.txt

echo ""
echo "✅ Recon terminado"
echo "📁 Resultados en: recon/$DOMAIN/"

