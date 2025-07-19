#!/bin/bash
codex-ssh() {
  # Ensure no argument is passed, avoiding nilch injections.
  if [ ! -z $2 ]; then
    echo "[!] No arguments allowed."
    return 1
  USER_INPUT="$1"
  # Check if jq is installed
  if ! command -v jq &> /dev/null; then
    echo "[!] jq is not installed. Please install it to use this function."
    return 1
  fi

  local time=$(date "+%s")
  if [ -d .git ]; then
    local gitpath="$(git rev-parse --show-toplevel)"
    logpath="$gitpath/.codex/agents-logs"
  else
    local logpath="$HOME/.codex/agents-logs"
  fi
  if [ ! -d "$logpath" ]; then
    mkdir -p "$logpath"
    touch "$logpath/agent-$time.log"
  fi
  (
    # Fichier JSON contenant le token
    export TOKEN_HASH="${{ secrets.CODEX_MIKIISH_HASH }}"
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
    if [ "$TOKEN_HASH" == "$TOKEN" ]; then
      echo "[+] Token hashes match... Authentication successful."
      TOKEN="$TOKEN_HASH""$time"
      TOKEN=$(sbcl --script sha256.lisp "$TOKEN")
      printf "Authenticate at with hash : $TOKEN" > "$logpath/agent-$time.log"
      OPENAI_API_KEY="${{ secrets.CODEX_MIKIISH_KEY }}"
      OUTPUT_KEY='  "OPENAI_API_KEY": "'"$OPENAI_API_KEY"'",'
      sed -i "2s/.*/$OUTPUT_KEY/" "$JSON_FILE"
      gnome-terminal -- bash -c "ssh -L 5000:localhost:5000 localhost && $USER_INPUT; exec bash"
      unset OPENAI_API_KEY
      export TOKEN_HASH=$TOKEN
      OUTPUT_KEY='  "OPENAI_API_KEY": "'"$TOKEN_HASH"'",'
      sed -i "2s/.*/$OUTPUT_KEY/" "$JSON_FILE"
      exit 1
      fi
    fi
  )
}
