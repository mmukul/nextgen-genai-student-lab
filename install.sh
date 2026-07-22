#!/usr/bin/env bash
set -e

echo "======================================"
echo " NextGen GenAI Student Lab Installer"
echo "======================================"

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    echo "Updating Ubuntu/Debian packages..."
    sudo apt update
    sudo apt upgrade -y
    sudo apt install -y python3 python3-venv python3-pip curl git vim

elif command -v dnf >/dev/null 2>&1; then
    echo "Updating Fedora packages..."
    sudo dnf upgrade -y
    sudo dnf install -y python3 python3-pip curl git vim

elif command -v yum >/dev/null 2>&1; then
    echo "Updating RHEL/CentOS packages..."
    sudo yum update -y
    sudo yum install -y python3 python3-pip curl git vim

else
    echo "Unsupported Linux distribution."
    exit 1
fi

echo "Checking Python..."

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 installation failed."
    exit 1
fi

echo "Creating virtual environment..."

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate

echo "Upgrading pip..."
python -m pip install --upgrade pip

echo "Installing Python packages..."
pip install -r requirements.txt

if ! command -v ollama >/dev/null 2>&1; then
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

echo "Downloading AI model..."
ollama pull llama3.2:3b

chmod +x start.sh stop.sh update.sh

echo
echo "Installation completed successfully!"
echo

./start.sh
