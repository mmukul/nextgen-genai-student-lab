# --------------------------------------------------
# Install Ollama
# --------------------------------------------------

if ! command -v ollama >/dev/null 2>&1; then

    echo
    echo "Installing Ollama..."

    curl -fsSL https://ollama.com/install.sh | sh

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
