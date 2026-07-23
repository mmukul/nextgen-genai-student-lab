#!/bin/bash
set -euo pipefail

MODEL="llama3.2:3b"

echo "========================================="
echo " NextGen GenAI Student Lab Setup"
echo "========================================="
echo

# Install Python dependencies
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y curl git python3 python3-pip zstd
elif command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y curl git python3 python3-pip zstd
fi

# Install Python packages
pip3 install -r requirements.txt

# Install Ollama if missing
if ! command -v ollama >/dev/null 2>&1; then
    echo "Installing Ollama..."
    curl --http1.1 -fsSL https://ollama.com/install.sh | sh
fi

echo
echo "Ollama Version : $(ollama --version)"
echo "OS             : $(grep PRETTY_NAME /etc/os-release | cut -d= -f2 | tr -d '"')"
echo "Architecture   : $(uname -m)"
echo

# Stop existing instance
pkill -f "ollama serve" >/dev/null 2>&1 || true
sleep 2

rm -f /tmp/ollama.log

echo "Starting Ollama..."
nohup ollama serve >/tmp/ollama.log 2>&1 &
PID=$!

echo "Waiting for Ollama..."
for i in {1..20}; do

    if ! kill -0 "$PID" 2>/dev/null; then
        echo
        echo "ERROR: Ollama failed to start."
        echo
        cat /tmp/ollama.log
        exit 1
    fi

    if curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then
        echo "Ollama started."
        break
    fi

    sleep 1
done

if ! curl -fs http://localhost:11434/api/tags >/dev/null 2>&1; then
    echo "ERROR: Ollama is not responding."
    cat /tmp/ollama.log
    exit 1
fi

echo
echo "Checking model..."

if ! ollama list | grep -q "$MODEL"; then
    echo "Downloading $MODEL ..."
    ollama pull "$MODEL"
fi

echo
echo "========================================="
echo "Setup Completed Successfully"
echo "========================================="
echo
echo "Backend   : python backend.py"
echo "Frontend  : streamlit run app.py"
echo
