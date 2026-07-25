#########################################################
# Install Python Dependencies
#########################################################

echo
echo "Installing Python packages..."

python3 -m pip install --upgrade pip setuptools wheel

if [ -f requirements.txt ]; then
    pip install --no-cache-dir -r requirements.txt
else
    echo "ERROR: requirements.txt not found."
    exit 1
fi

#########################################################
# Verify Python Packages
#########################################################

echo
echo "Verifying Python packages..."

PACKAGES=(
    fastapi
    uvicorn
    streamlit
    requests
    pydantic
    dotenv
)

for pkg in "${PACKAGES[@]}"; do
    python3 -c "import ${pkg}" >/dev/null 2>&1 \
        && echo "✓ ${pkg}" \
        || {
            echo "✗ ${pkg} installation failed."
            exit 1
        }
done

#########################################################
# Verify Executables
#########################################################

echo
echo "Checking executables..."

command -v python3 >/dev/null || exit 1
command -v pip >/dev/null || command -v pip3 >/dev/null || exit 1
command -v uvicorn >/dev/null || exit 1
command -v streamlit >/dev/null || exit 1
command -v ollama >/dev/null || exit 1

echo "✓ Python"
echo "✓ Pip"
echo "✓ Uvicorn"
echo "✓ Streamlit"
echo "✓ Ollama"

echo
echo "========================================="
echo "Installed Versions"
echo "========================================="

python3 --version
pip --version

echo "FastAPI   : $(python3 -c 'import fastapi; print(fastapi.__version__)')"
echo "Uvicorn   : $(python3 -c 'import uvicorn; print(uvicorn.__version__)')"
echo "Streamlit : $(streamlit version | head -1)"
echo "Requests  : $(python3 -c 'import requests; print(requests.__version__)')"
echo "Pydantic  : $(python3 -c 'import pydantic; print(pydantic.__version__)')"
echo "Ollama    : $(ollama --version)"
