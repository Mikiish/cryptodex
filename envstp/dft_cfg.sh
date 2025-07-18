#!/bin/bash
set -e

echo "[+] Mise à jour des paquets..."
sudo apt update -y && sudo apt upgrade -y

echo "[+] Installation des outils de développement essentiels..."
sudo apt install -y \
    build-essential \
    cmake \
    make \
    g++ \
    gcc \

echo "[+] Installation des outils de développement et de débogage pratiques..."
sudo apt install -y \
    git \
    curl \
    wget \
    nano \
    unzip \
    htop \
    jq

echo "[+] Installation des outils Python (pip, venv, setuptools)..."
sudo apt install -y \
    python3 \
    python3-pip \
    python3-venv \
    python3-setuptools \
    python3-dev \
    python3-wheel
