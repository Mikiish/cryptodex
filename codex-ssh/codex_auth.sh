#!/bin/bash

# Fichier JSON contenant le token
JSON_FILE="$HOME/.codex/auth.json"
KEY_NAME="OPENAI_API_TOKEN"

# Check existence
if [ ! -f "$JSON_FILE" ]; then
  echo "[!] Fichier $JSON_FILE introuvable."
  exit 1
fi

# Extraction du token
TOKEN=$(jq -r --arg key "$KEY_NAME" '.[$key]' "$JSON_FILE")

if [ "$TOKEN" == "null" ] || [ -z "$TOKEN" ]; then
  echo "[!] Clé $KEY_NAME introuvable dans $JSON_FILE."
  exit 2
fi

# On affiche le hash pour vérification externe
HASH=$(echo -n "$TOKEN" | sha256sum | awk '{print $1}')
echo "[✓] Hash du token : $HASH"

# Lancement du terminal avec le token dans une variable d'env propre
gnome-terminal -- bash -c "API_TOKEN='$TOKEN' codex; exec bash"

# Auto-destruction : remplacement de la valeur par son hash
jq --arg key "$KEY_NAME" --arg new "$HASH" '.[$key]=$new' "$JSON_FILE" > tmp.$$ && mv tmp.$$ "$JSON_FILE"

echo "[✓] Clé consommée et remplacée par son hash."
