#!/bin/bash
set -e

echo "[+] Updating Package..."
sudo apt update -y
sudo apt install -y npm curl git jq
echo "[+] Cloning repo from source..."
DIR="codex"
DIR_DEV="codex-dev"
if [ ! -d "$DIR" ]; then
  echo "[+] Cloning from git@github.com:openai/codex into $DIR..."
  git clone "https://github.com/openai/codex.git" "$DIR"
else
  if [ ! -d "$DIR_DEV" ]; then
    echo "[+] Creating directory $DIR_DEV..."
    cp -r "$DIR" "$DIR_DEV"
  else
    echo "[+] Directory $DIR_DEV already exists, ignoring step..."
  fi
  rm -rf "$DIR"
  echo "[+] Cloning from git@github.com:openai/codex into $DIR..."
  git clone "https://github.com/openai/codex.git" "$DIR"
fi

echo "[+] Curling nvm version from github.com..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
echo "[+] NVM installed, loading nvm..."
export NVM_DIR="$HOME/.nvm"
. "$NVM_DIR/nvm.sh"
nvm install 24
nvm use 24
nvm alias default 24

echo "[+] Installing codex from node."
npm install -g @openai/codex
if [ -d .git ]; then
  gitpath="$(git rev-parse --show-toplevel)"
  mkdir -p "$gitpath/.codex"
  cdxpath="$gitpath/.codex"
else
  cdxpath="$HOME/.codex"
fi
mkdir -p "$cdxpath"
export OPENAI_API_KEY="${{ secrets.OPENAI_API_KEY }}"
cat <<EOF > "$cdxpath/auth.json"
{
  "OPENAI_API_KEY": "$OPENAI_API_KEY"
}
EOF
if [ -z $USER_INPUT ]; then
  echo "[!] USER_INPUT is not set, using default command."
  export USER_INPUT='Lance envstp/dft_cfg.sh pour installer python, clone le repo git mikiish/Lisa, puis créer un venv python stp.'
else
  echo "[+] Using user input: $USER_INPUT"
fi
gnome-terminal -- bash -c "codex exec \"$USER_INPUT\"; exec bash"

echo "[+] Codex installed, run \"[codex login]\" to authenticate your ChatGPT account. Then do the following steps :"
echo "[+] 1) Create ~/.codex/config.toml file to setup your models and parameters."
echo "[+] --- Visit [codex/blob/rust-v0.8.0/codex-cli/src/utils/model-info.ts] file for more informations on models availables."
echo "[+] 2) You can authenticate using API keys for automatic completion using agents such as well... Codex itself. Ah!"
echo "[+] --- See openai official documentation here : [https://github.com/openai/codex/?tab=readme-ov-file]"
echo "[+] 3) Create a ~/your-project-repo/.codex folder and create an AGENT.md file."
echo "[+] --- From your project folder, write a haiku." 
echo "[+] --- Example : see examples.md"
