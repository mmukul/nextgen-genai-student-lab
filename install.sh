#!/usr/bin/env bash
set -e

echo "======================================"
echo " NextGen GenAI Student Lab Installer"
echo "======================================"

# Check Python
if ! command -v python3 >/dev/null 2>&1; then
    echo "❌ Python3 is not installed."
    echo "Install Python 3.11+ and try again."
    exit 1
fi

echo "✅ Python Found"

# Create Virtual Environment
if [ ! -d ".venv" ]; then
    echo "Creating virtual environment..."
    python3 -m venv .venv
fi

source .venv/bin/activate

echo "Installing Python packages..."

pip install --upgrade pip

pip install -r requirements.txt

# Install Ollama if missing
if ! command -v ollama >/dev/null 2>&1; then

    echo "Installing Ollama..."

    curl -fsSL https://ollama.com/install.sh | sh

fi

echo "Downloading Llama model..."

ollama pull llama3.2:3b

chmod +x start.sh stop.sh update.sh

echo
echo "Installation Complete"
echo

./start.sh
