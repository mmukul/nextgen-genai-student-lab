# --------------------------------------------------
# Install Ollama
# --------------------------------------------------

if ! command -v ollama >/dev/null 2>&1; then

    echo
    echo "Installing Ollama..."

    curl -LO https://ollama.com/download/ollama-linux-amd64.tar.zst && file ollama-linux-amd64.tar.zst

fi

echo
echo "Starting Ollama..."

# Start only if not already running
if ! pgrep -x ollama >/dev/null; then
    nohup ollama serve >/tmp/ollama.log 2>&1 &
fi

echo "Waiting for Ollama to start..."

for i in {1..30}; do
    if curl -s http://localhost:11434/api/tags >/dev/null; then
        echo "Ollama is ready."
        break
    fi
    sleep 2
done

# Final check
if ! curl -s http://localhost:11434/api/tags >/dev/null; then
    echo "ERROR: Ollama failed to start."
    echo "Check the log:"
    echo "  cat /tmp/ollama.log"
    exit 1
fi

echo
echo "Downloading AI model..."

ollama pull llama3.2:3b

# --------------------------------------------------
# Validate Installation
# --------------------------------------------------

echo
echo "========================================="
echo "Validating Installation..."
echo "========================================="

echo "Checking Python..."
python3 --version

echo "Checking Pip..."
pip --version

echo "Checking Ollama..."
ollama --version

echo "Checking Model..."

if ollama list | grep -q "llama3.2:3b"; then
    echo "✓ Model Installed"
else
    echo "✗ Model Missing"
    exit 1
fi

echo "Checking Backend..."

if curl -s http://localhost:8000/health >/dev/null; then
    echo "✓ Backend Running"
else
    echo "✗ Backend Failed"
fi

echo "Checking Streamlit..."

if curl -s http://localhost:8501 >/dev/null; then
    echo "✓ Streamlit Running"
else
    echo "✗ Streamlit Failed"
fi
