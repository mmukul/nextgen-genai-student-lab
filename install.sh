#!/usr/bin/env bash
set -e

echo "===================================================="
echo "      NextGen GenAI Student Lab Installer"
echo "===================================================="

# --------------------------------------------------
# Detect OS & Install Dependencies
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
        git

elif command -v dnf >/dev/null 2>&1; then

    echo "Fedora detected..."

    sudo dnf upgrade -y

    sudo dnf install -y \
        python3 \
        python3-pip \
        curl \
        git

elif command -v yum >/dev/null 2>&1; then

    echo "RHEL/CentOS detected..."

    sudo yum update -y

    sudo yum install -y \
        python3 \
        python3-pip \
        curl \
        git

else

    echo "Unsupported Linux Distribution"

    exit 1

fi

# --------------------------------------------------
# Configure Firewall
# --------------------------------------------------

echo
echo "Configuring Firewall..."

# Ubuntu/Debian (UFW)

if command -v ufw >/dev/null 2>&1; then

    sudo ufw allow 8000/tcp
    sudo ufw allow 8501/tcp

    echo "Opened ports:"
    echo " 8000/tcp"
    echo " 8501/tcp"

fi

# Fedora/RHEL/Rocky (firewalld)

if command -v firewall-cmd >/dev/null 2>&1; then

    sudo systemctl enable firewalld --now

    sudo firewall-cmd --permanent --add-port=8000/tcp
    sudo firewall-cmd --permanent --add-port=8501/tcp
    sudo firewall-cmd --reload

    echo "Opened ports:"
    echo " 8000/tcp"
    echo " 8501/tcp"

fi

# --------------------------------------------------
# Python Environment
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
echo "Downloading Model..."

ollama pull llama3.2:3b

chmod +x *.sh

echo
echo "Installation Completed Successfully"
echo

./start.sh
