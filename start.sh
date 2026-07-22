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
>/tmp/genai-ui.log 2>&1 &

sleep 5

echo
echo "Application Started"
echo

python3 -m webbrowser http://localhost:8501
