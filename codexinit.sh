#!/bin/bash
set -e

echo "[+] Updating Package..."
sudo apt update -y
sudo apt install -y npm
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
fi
cdxpath="$HOME/.codex"
touch "$cdxpath/config.toml"
printf 'model = "codex-mini-latest"\n' >> "$cdxpath/config.toml"
printf 'model_reasoning_effort = "high"\n' >> "$cdxpath/config.toml"
printf 'approval_policy = "on-failure"\n' >> "$cdxpath/config.toml"
printf 'sandbox_mode = "workspace-write"\n' >> "$cdxpath/config.toml"



