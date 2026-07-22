#!/usr/bin/env bash

source .venv/bin/activate

echo "Starting FastAPI..."

nohup uvicorn backend:app \
    --host 0.0.0.0 \
    --port 8000 \
    >/tmp/genai-api.log 2>&1 &

sleep 3

echo "Starting Streamlit..."

nohup streamlit run app.py \
    --server.address 0.0.0.0 \
    --server.port 8501 \
    >/tmp/genai-ui.log 2>&1 &

sleep 5

SERVER_IP=$(hostname -I | awk '{print $1}')

echo
echo "=============================================="
echo " NextGen GenAI Student Lab Started"
echo "=============================================="
echo
echo "Local UI"
echo "  http://localhost:8501"
echo
echo "Network UI"
echo "  http://${SERVER_IP}:8501"
echo
echo "Swagger"
echo "  http://${SERVER_IP}:8000/docs"
echo
