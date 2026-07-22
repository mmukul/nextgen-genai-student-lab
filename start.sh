#!/usr/bin/env bash

source .venv/bin/activate

echo "Starting Ollama..."

if ! pgrep -x ollama >/dev/null; then
    nohup ollama serve >/tmp/ollama.log 2>&1 &
fi

echo "Starting Backend..."

nohup uvicorn backend:app \
    --host 0.0.0.0 \
    --port 8000 \
    >/tmp/genai-api.log 2>&1 &

echo "Starting Streamlit..."

nohup streamlit run app.py \
    --server.address 0.0.0.0 \
    --server.port 8501 \
    >/tmp/genai-ui.log 2>&1 &

SERVER_IP=$(hostname -I | awk '{print $1}')

echo
echo "========================================="
echo "Installation Completed Successfully!"
echo "========================================="
echo
echo "UI"
echo "  http://localhost:8501"
echo "  http://$SERVER_IP:8501"
echo
echo "API"
echo "  http://$SERVER_IP:8000/docs"
echo
echo "Logs"
echo "  /tmp/ollama.log"
echo "  /tmp/genai-api.log"
echo "  /tmp/genai-ui.log"
echo
