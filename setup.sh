#!/bin/bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
VENV_DIR="$ROOT_DIR/.venv"

MODEL_NAME="llama3.2:3b"

echo "=========================================="
echo " NextGen GenAI Student Lab - Setup"
echo "=========================================="

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

if [ "$PKG" = "dnf" ]; then
    sudo dnf install -y \
        curl wget git vim jq tar zstd unzip \
        gcc make lsof \
        python3 python3-pip
else
    sudo apt update
    sudo apt install -y \
        curl wget git vim jq tar zstd unzip \
        gcc make lsof \
        python3 python3-pip python3-venv
fi

#########################################################
# Python Environment
#########################################################

python3 -m pip install --upgrade pip setuptools wheel

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
fi

source "$VENV_DIR/bin/activate"

#########################################################
# Install Python Packages
#########################################################

if [ ! -f requirements.txt ]; then
    echo "requirements.txt not found."
    exit 1
fi

pip install --upgrade -r requirements.txt

#########################################################
# Verify Packages
#########################################################

PACKAGES=(
    fastapi
    uvicorn
    streamlit
    requests
    pydantic
    dotenv
)

for pkg in "${PACKAGES[@]}"; do
    python3 -c "import ${pkg}" >/dev/null
    echo "✓ ${pkg}"
done

#########################################################
# Install Ollama
#########################################################

if command -v ollama >/dev/null 2>&1; then
    echo "✓ Ollama already installed"
else
    echo "Installing Ollama..."
    curl -fsSL https://ollama.com/install.sh | sh
fi

echo "Ollama Version: $(ollama --version)"

#########################################################
# Project Directories
#########################################################

mkdir -p \
    logs \
    uploads \
    documents \
    prompts \
    models \
    assets

#########################################################
# Create .env
#########################################################

if [ ! -f .env ]; then
cat > .env <<EOF
MODEL_NAME=$MODEL_NAME
BACKEND_PORT=8000
STREAMLIT_PORT=8501
OLLAMA_PORT=11434
EOF
fi

#########################################################
# Configure Firewall
#########################################################

echo
echo "========================================="
echo "Configuring Firewall"
echo "========================================="

        echo "Opening required ports..."
        firewall-cmd --permanent --add-port=${STREAMLIT_PORT}/tcp
        firewall-cmd --reload


#########################################################
# Summary
#########################################################

echo
=======
# Summary
#########################################################

echo
echo "=========================================="
echo "Setup Completed Successfully"
echo "=========================================="

python3 --version
pip --version
ollama --version

echo
echo "Model configured : $MODEL_NAME"
echo "Project folders  : Created"
echo
echo "Next Steps:"
echo "  source .venv/bin/activate"
echo "  ./start.sh"
