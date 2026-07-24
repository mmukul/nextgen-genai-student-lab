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

#########################################################
# Detect IP Address
#########################################################

IP_ADDRESS=$(hostname -I 2>/dev/null | awk '{print $1}')

if [ -z "${IP_ADDRESS}" ]; then
    IP_ADDRESS=$(ip route get 1.1.1.1 | awk '{print $7; exit}')
fi

#########################################################
# Verify Ollama Installation
#########################################################

if ! command -v ollama >/dev/null 2>&1; then
    echo "ERROR: Ollama is not installed."
    echo "Run ./setup.sh first."
    exit 1
fi

echo "Ollama Version : $(ollama --version)"
echo "IP Address     : ${IP_ADDRESS}"
echo

#########################################################
# Start Ollama
#########################################################

if curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then

    echo "Ollama is already running."

else

    echo "Starting Ollama..."

    rm -f /tmp/ollama.log

    nohup ollama serve >/tmp/ollama.log 2>&1 &

    PID=$!

    echo -n "Waiting for Ollama"

    for i in {1..30}; do

        if ! kill -0 "$PID" 2>/dev/null; then

            echo
            echo
            echo "ERROR: Ollama crashed."

            echo
            cat /tmp/ollama.log

            exit 1

        fi

        if curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then

            echo
            echo "Ollama started."

            break

        fi

        echo -n "."
        sleep 1

    done

fi

#########################################################
# Final Ollama Health Check
#########################################################

if ! curl -fs "http://localhost:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then

    echo
    echo "ERROR: Ollama is not responding."

    cat /tmp/ollama.log

    exit 1

fi

#########################################################
# Start FastAPI
#########################################################

if lsof -Pi :"${BACKEND_PORT}" -sTCP:LISTEN -t >/dev/null; then

    echo "Backend already running."

else

    echo "Starting Backend..."

    rm -f /tmp/backend.log

    nohup python3 -m uvicorn backend:app \
        --host 0.0.0.0 \
        --port ${BACKEND_PORT} \
        >/tmp/backend.log 2>&1 &

fi

#########################################################
# Wait for Backend
#########################################################

echo -n "Waiting for Backend"

for i in {1..20}; do

    if curl -fs "http://localhost:${BACKEND_PORT}/health" >/dev/null 2>&1; then

        echo
        echo "Backend started."

        break

    fi

    echo -n "."
    sleep 1

done

#########################################################
# Start Streamlit
#########################################################

if lsof -Pi :"${STREAMLIT_PORT}" -sTCP:LISTEN -t >/dev/null; then

    echo "Streamlit already running."

else

    echo "Starting Streamlit..."

    rm -f /tmp/streamlit.log

    nohup streamlit run app.py \
        --server.address 0.0.0.0 \
        --server.port ${STREAMLIT_PORT} \
        >/tmp/streamlit.log 2>&1 &

fi

#########################################################
# Wait for Streamlit
#########################################################

echo -n "Waiting for Streamlit"

for i in {1..20}; do

    if curl -fs "http://localhost:${STREAMLIT_PORT}" >/dev/null 2>&1; then

        echo
        echo "Streamlit started."

        break

    fi

    echo -n "."
    sleep 1

done

#########################################################
# Summary
#########################################################

echo
echo "========================================="
echo " Services Started Successfully"
echo "========================================="
echo

echo "Ollama API"
echo "  Local : http://localhost:${OLLAMA_PORT}"

echo
echo "FastAPI"
echo "  Local : http://localhost:${BACKEND_PORT}"
echo "  LAN   : http://${IP_ADDRESS}:${BACKEND_PORT}"
echo "  Docs  : http://${IP_ADDRESS}:${BACKEND_PORT}/docs"

echo
echo "Streamlit"
echo "  Local : http://localhost:${STREAMLIT_PORT}"
echo "  LAN   : http://${IP_ADDRESS}:${STREAMLIT_PORT}"

echo
echo "Logs"
echo "-----------------------------------------"
echo "tail -f /tmp/ollama.log"
echo "tail -f /tmp/backend.log"
echo "tail -f /tmp/streamlit.log"

echo
