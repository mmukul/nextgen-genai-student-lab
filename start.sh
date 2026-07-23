#!/bin/bash

set -euo pipefail

BACKEND_PORT=8000
STREAMLIT_PORT=8501
OLLAMA_PORT=11434

echo "========================================="
echo " NextGen GenAI Student Lab"
echo " Starting Services"
echo "========================================="
echo

#----------------------------------------------------
# Check Ollama
#----------------------------------------------------

if ! command -v ollama >/dev/null 2>&1; then
    echo "❌ ERROR: Ollama is not installed."
    echo "Run ./setup.sh first."
    exit 1
fi

echo "Ollama Version : $(ollama --version)"
echo

#----------------------------------------------------
# Start Ollama
#----------------------------------------------------

if curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then
    echo "✅ Ollama is already running."
else
    echo "Starting Ollama..."

    rm -f /tmp/ollama.log

    nohup ollama serve >/tmp/ollama.log 2>&1 &
    OLLAMA_PID=$!

    echo -n "Waiting for Ollama"

    for i in {1..20}; do

        if ! kill -0 "$OLLAMA_PID" 2>/dev/null; then
            echo
            echo "❌ ERROR: Ollama crashed."
            echo
            echo "========== Ollama Log =========="
            cat /tmp/ollama.log
            echo "================================"
            exit 1
        fi

        if curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then
            echo
            echo "✅ Ollama started."
            break
        fi

        echo -n "."
        sleep 1
    done

    if ! curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then
        echo
        echo "❌ ERROR: Ollama is not responding."
        cat /tmp/ollama.log
        exit 1
    fi
fi

#----------------------------------------------------
# Start Backend
#----------------------------------------------------

if lsof -Pi :${BACKEND_PORT} -sTCP:LISTEN -t >/dev/null ; then
    echo "✅ Backend already running."
else
    echo "Starting Backend..."
    nohup python3 backend.py >/tmp/backend.log 2>&1 &
fi

#----------------------------------------------------
# Wait for Backend
#----------------------------------------------------

echo -n "Waiting for Backend"

for i in {1..15}; do

    if curl -fs "http://localhost:${BACKEND_PORT}/health" >/dev/null 2>&1; then
        echo
        echo "✅ Backend started."
        break
    fi

    echo -n "."
    sleep 1
done

#----------------------------------------------------
# Start Streamlit
#----------------------------------------------------

if lsof -Pi :${STREAMLIT_PORT} -sTCP:LISTEN -t >/dev/null ; then
    echo "✅ Streamlit already running."
else
    echo "Starting Streamlit..."
    nohup streamlit run app.py >/tmp/streamlit.log 2>&1 &
fi

sleep 5

#----------------------------------------------------
# Summary
#----------------------------------------------------

echo
echo "========================================="
echo " Services Started Successfully"
echo "========================================="
echo
echo "🤖 Ollama    : http://localhost:${OLLAMA_PORT}"
echo "⚙️ Backend   : http://localhost:${BACKEND_PORT}"
echo "🌐 Streamlit : http://localhost:${STREAMLIT_PORT}"
echo
echo "Useful Commands"
echo "---------------"
echo "tail -f /tmp/ollama.log"
echo "tail -f /tmp/backend.log"
echo "tail -f /tmp/streamlit.log"
echo
