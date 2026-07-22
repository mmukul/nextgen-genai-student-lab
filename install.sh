#!/usr/bin/env bash
set -e

echo "===================================================="
echo "      NextGen GenAI Student Lab Installer"
echo "===================================================="

# --------------------------------------------------
# Detect Operating System
# --------------------------------------------------

if command -v apt >/dev/null 2>&1; then

    echo "Ubuntu/Debian detected..."

    sudo apt update
    sudo apt upgrade -y

    sudo apt install -y \
        python3 \
        python3-venv \
        python3-pip \
        curl \
        git \
        zstd

elif command -v dnf >/dev/null 2>&1; then

    echo "Fedora/RHEL/Rocky Linux detected..."

    sudo dnf upgrade -y

    sudo dnf install -y \
        python3 \
        python3-pip \
        curl \
        git \
        firewalld \
        zstd

elif command -v yum >/dev/null 2>&1; then

    echo "CentOS detected..."

    sudo yum update -y

    sudo yum install -y \
        python3 \
        python3-pip \
        curl \
        git \
        firewalld \
        zstd

else

    echo "Unsupported Linux Distribution"

    exit 1

fi

# --------------------------------------------------
# Configure Firewall
# --------------------------------------------------

echo
echo "Configuring Firewall..."

if command -v firewall-cmd >/dev/null 2>&1; then

    echo "Starting firewalld..."

    sudo systemctl enable firewalld
    sudo systemctl start firewalld

    echo "Opening TCP Port 8000 (FastAPI)..."
    sudo firewall-cmd --permanent --add-port=8000/tcp

    echo "Opening TCP Port 8501 (Streamlit)..."
    sudo firewall-cmd --permanent --add-port=8501/tcp

    echo "Reloading firewall..."
    sudo firewall-cmd --reload

    echo
    echo "Firewall Rules"

    sudo firewall-cmd --list-ports

fi

# --------------------------------------------------
# Python Virtual Environment
# --------------------------------------------------

echo
echo "Creating Python Virtual Environment..."

if [ ! -d ".venv" ]; then
    python3 -m venv .venv
fi

source .venv/bin/activate

python -m pip install --upgrade pip

pip install -r requirements.txt

# --------------------------------------------------
# Install Ollama
# --------------------------------------------------

if ! command -v ollama >/dev/null 2>&1; then

    echo
    echo "Installing Ollama..."

    curl -fsSL https://ollama.com/install.sh | sh

fi

echo
echo "Downloading AI Model..."

ollama pull llama3.2:3b

chmod +x *.sh

echo
echo "Installation Completed Successfully"
echo

./start.sh
