#!/bin/bash
set -e
codex-ssh() {
    (
        export USER_INPUT="$1"
        export OPENAI_API_KEY="${{ secrets.CODEX_MIKIISH_KEY }}"
        gnome-terminal -- bash -c "ssh -L 5000:localhost:5000 localhost && $USER_INPUT; exec bash"
        unset OPENAI_API_KEY
    )
}
codexs() {
    local cmd="codex $*"
    USER_INPUT=$(echo "$cmd")
    codex-ssh "$USER_INPUT"
    echo "[+] Codex command executed with user input: $USER_INPUT"
}

# Codex SSH function
printf "alias codex=codexs\n" >> ~/.bashrc
export USER_INPUT='Lance envstp/dft_cfg.sh pour installer python, clone le repo git mikiish/Lisa, puis créer un venv python stp.'
codex-ssh "$USER_INPUT"