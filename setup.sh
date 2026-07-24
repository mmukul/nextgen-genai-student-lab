#!/bin/bash

set -euo pipefail

MODEL="llama3.2:3b"
OLLAMA_URL="https://github.com/ollama/ollama/releases/latest/download/ollama-linux-amd64.tar.zst"
TMP_FILE="/tmp/ollama-linux-amd64.tar.zst"

echo "========================================="
echo " NextGen GenAI Student Lab Setup"
echo "========================================="
echo

#########################################################
# Detect Package Manager
#########################################################

if command -v dnf >/dev/null 2>&1; then
    PKG="dnf"
elif command -v apt >/dev/null 2>&1; then
    PKG="apt"
else
    echo "Unsupported Linux distribution."
    exit 1
fi

#########################################################
# Install System Packages
#########################################################

echo "Installing system packages..."

if [ "$PKG" = "dnf" ]; then

    sudo dnf install -y \
        curl \
        wget \
        git \
        vim \
        python3 \
        python3-pip \
        zstd \
        tar

else

    sudo apt update

    sudo apt install -y \
        curl \
        wget \
        git \
        vim \
        python3 \
        python3-pip \
        zstd \
        tar

fi

#########################################################
# Install Python Packages
#########################################################

echo
echo "Installing Python packages..."

python3 -m pip install --upgrade pip
python3 -m pip install -r requirements.txt

#########################################################
# Install Ollama
#########################################################

if ! command -v ollama >/dev/null 2>&1; then

    echo
    echo "Installing Ollama..."

    rm -f "$TMP_FILE"

    wget \
        --show-progress \
        --progress=bar:force \
        --tries=5 \
        -O "$TMP_FILE" \
        "$OLLAMA_URL"

    echo
    echo "Extracting..."

    sudo tar --zstd -xf "$TMP_FILE" -C /usr/local

    rm -f "$TMP_FILE"

fi

#########################################################
# Verify Installation
#########################################################

if ! command -v ollama >/dev/null 2>&1; then
    echo
    echo "ERROR: Ollama installation failed."
    exit 1
fi

echo
echo "Ollama Version : $(ollama --version)"
echo "OS             : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Architecture   : $(uname -m)"
echo

#########################################################
# Stop Existing Ollama
#########################################################

pkill -f "ollama serve" >/dev/null 2>&1 || true
sleep 2

#########################################################
# Start Ollama
#########################################################

rm -f /tmp/ollama.log

echo "Starting Ollama..."

nohup ollama serve >/tmp/ollama.log 2>&1 &

PID=$!

#########################################################
# Wait for Ollama
#########################################################

echo -n "Waiting for Ollama"

for i in {1..30}; do

    if ! kill -0 "$PID" 2>/dev/null; then

        echo
        echo
        echo "ERROR: Ollama crashed."

        echo
        echo "------------- LOG -------------"
        cat /tmp/ollama.log
        echo "-------------------------------"

        exit 1

    fi

    if curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then

        echo
        echo "Ollama started."

        break

    fi

    echo -n "."
    sleep 1

done

#########################################################
# Final Health Check
#########################################################

if ! curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then

    echo
    echo "ERROR: Ollama is not responding."

    cat /tmp/ollama.log

    exit 1

fi

#########################################################
# Pull Model
#########################################################

echo
echo "Checking model..."

if ! ollama list | grep -q "$MODEL"; then

    echo "Downloading model: $MODEL"

    ollama pull "$MODEL"

else

    echo "Model already installed."

fi

#########################################################
# Done
#########################################################

echo
echo "========================================="
echo " Setup Completed Successfully"
echo "========================================="
echo
echo "Installed:"
echo "  ✓ Python Packages"
echo "  ✓ Ollama"
echo "  ✓ Model: $MODEL"
echo
echo "Run the application:"
echo
echo "  ./start.sh"
echo
echo "Useful commands:"
echo
echo "  ./status.sh"
echo "  ./stop.sh"
echo "  ./restart.sh"
echo
