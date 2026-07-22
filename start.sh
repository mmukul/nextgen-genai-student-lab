#!/usr/bin/env bash

source .venv/bin/activate

# Start Ollama
if ! pgrep -x ollama >/dev/null; then
    echo "Starting Ollama..."
    nohup ollama serve >/tmp/ollama.log 2>&1 &
    sleep 5
fi

echo "Starting FastAPI..."

nohup uvicorn backend:app \
    --host 0.0.0.0 \
    --port 8000 \
    >/tmp/genai-api.log 2>&1 &

sleep 2

echo "Starting Streamlit..."

nohup streamlit run app.py \
    --server.address 0.0.0.0 \
    --server.port 8501 \
    >/tmp/genai-ui.log 2>&1 &
