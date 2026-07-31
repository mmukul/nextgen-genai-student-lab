#!/bin/bash
set -euo pipefail

###############################################################################
# NextGen GenAI Student Lab - start.sh
###############################################################################

APP_NAME="NextGen GenAI Student Lab"
ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$ROOT_DIR/logs"
mkdir -p "$LOG_DIR"

# Load environment
if [ -f "$ROOT_DIR/.env" ]; then
  set -a
  . "$ROOT_DIR/.env"
  set +a
fi

BACKEND_PORT=${BACKEND_PORT:-8000}
STREAMLIT_PORT=${STREAMLIT_PORT:-8501}
OLLAMA_PORT=${OLLAMA_PORT:-11434}
MODEL_NAME=${MODEL_NAME:-llama3.2:3b}

OLLAMA_LOG="$LOG_DIR/ollama.log"
BACKEND_LOG="$LOG_DIR/backend.log"
STREAMLIT_LOG="$LOG_DIR/streamlit.log"

GREEN='\033[0;32m'; RED='\033[0;31m'; BLUE='\033[0;34m'; NC='\033[0m'
ok(){ echo -e "${GREEN}[OK] $1${NC}"; }
info(){ echo -e "${BLUE}==> $1${NC}"; }
err(){ echo -e "${RED}[ERROR] $1${NC}"; exit 1; }

echo "=================================================="
echo " $APP_NAME"
echo "=================================================="

# Activate venv if present
[ -d "$ROOT_DIR/.venv" ] && . "$ROOT_DIR/.venv/bin/activate"

# Verify commands
for c in python3 uvicorn streamlit ollama curl lsof; do
 command -v "$c" >/dev/null 2>&1 || err "$c not installed. Run ./setup.sh"
done

# Verify files
for f in app.py backend.py config.py utils.py; do
 [ -f "$ROOT_DIR/$f" ] || err "Missing $f"
done

IP=$(hostname -I 2>/dev/null|awk '{print $1}')
[ -z "$IP" ] && IP=$(ip route get 1.1.1.1|awk '{print $7;exit}')

<<<<<<< HEAD

warn(){
    echo -e "\033[1;33m[WARN] $1${NC}"
}

wait_url() {

    local URL="$1"
    local NAME="$2"

    info "Waiting for ${NAME}..."

    for i in $(seq 1 60); do

        if curl -fs "$URL" >/dev/null 2>&1; then
            ok "${NAME} is ready"
            return 0
        fi

        sleep 2
    done

    echo
    err "${NAME} failed to start."
}


info "Checking Ollama..."

if ! curl -fs "http://127.0.0.1:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then

    info "Starting Ollama..."

    nohup ollama serve >"$OLLAMA_LOG" 2>&1 &

    OLLAMA_PID=$!

    echo "$OLLAMA_PID" > "$LOG_DIR/ollama.pid"

    for i in $(seq 1 60); do

        if ! kill -0 "$OLLAMA_PID" >/dev/null 2>&1; then

            echo
            cat "$OLLAMA_LOG"

            err "Ollama crashed."

        fi

        if curl -fs "http://127.0.0.1:${OLLAMA_PORT}/api/tags" >/dev/null 2>&1; then
            ok "Ollama started"
            break
        fi

        sleep 2

    done

else

    ok "Ollama already running"

fi

info "Checking model..."

if ollama list | awk 'NR>1{print $1}' | grep -qx "$MODEL_NAME"; then

    ok "$MODEL_NAME available"

else

    warn "$MODEL_NAME not found"

    info "Downloading model..."

    ollama pull "$MODEL_NAME"

    ok "Model downloaded"

fi

info "Starting FastAPI"

if ! lsof -Pi :"$BACKEND_PORT" -sTCP:LISTEN -t >/dev/null; then

    nohup python3 -m uvicorn backend:app \
        --host 0.0.0.0 \
        --port "$BACKEND_PORT" \
        >"$BACKEND_LOG" 2>&1 &

    BACKEND_PID=$!

    echo "$BACKEND_PID" > "$LOG_DIR/backend.pid"

    sleep 2

    if ! kill -0 "$BACKEND_PID" >/dev/null 2>&1; then

        cat "$BACKEND_LOG"

        err "FastAPI crashed."

    fi

else

    ok "FastAPI already running"

fi

wait_url "http://127.0.0.1:${BACKEND_PORT}/health" "FastAPI"



info "Starting Streamlit"

if ! lsof -Pi :"$STREAMLIT_PORT" -sTCP:LISTEN -t >/dev/null; then

    nohup streamlit run app.py \
        --server.address 0.0.0.0 \
        --server.port "$STREAMLIT_PORT" \
        >"$STREAMLIT_LOG" 2>&1 &

    STREAMLIT_PID=$!

    echo "$STREAMLIT_PID" > "$LOG_DIR/streamlit.pid"

    sleep 3

    if ! kill -0 "$STREAMLIT_PID" >/dev/null 2>&1; then

        cat "$STREAMLIT_LOG"

        err "Streamlit crashed."

    fi

else

    ok "Streamlit already running"

fi

wait_url "http://127.0.0.1:${STREAMLIT_PORT}" "Streamlit"


echo
echo "Firewall Ports"
echo "------------------------------------------------------------"
echo "Ollama      : ${OLLAMA_PORT}/tcp"
echo "FastAPI     : ${BACKEND_PORT}/tcp"
echo "Streamlit   : ${STREAMLIT_PORT}/tcp"

#########################################################
# Summary
#########################################################

echo
echo "============================================================"
echo "      NextGen GenAI Student Lab Started Successfully"
echo "============================================================"
echo

echo "Application Information"
echo "------------------------------------------------------------"
echo "Application  : ${APP_NAME}"
echo "Model        : ${MODEL_NAME}"
echo "Python       : $(python3 --version)"
echo "Ollama       : $(ollama --version)"
echo

echo "Services"
echo "------------------------------------------------------------"
echo "✓ Ollama     : Running"
echo "✓ FastAPI    : Running"
echo "✓ Streamlit  : Running"
echo

echo "Access URLs"
echo "------------------------------------------------------------"
echo "Ollama API"
echo "  Local      : http://localhost:${OLLAMA_PORT}"
echo

echo "FastAPI"
echo "  Local      : http://localhost:${BACKEND_PORT}"
echo "  LAN        : http://${IP}:${BACKEND_PORT}"
echo "  Swagger    : http://${IP}:${BACKEND_PORT}/docs"
echo "  Health     : http://localhost:${BACKEND_PORT}/health"
echo

echo "Streamlit"
echo "  Local      : http://localhost:${STREAMLIT_PORT}"
echo "  LAN        : http://${IP}:${STREAMLIT_PORT}"
echo

echo "Log Files"
echo "------------------------------------------------------------"
echo "Ollama       : ${OLLAMA_LOG}"
echo "FastAPI      : ${BACKEND_LOG}"
echo "Streamlit    : ${STREAMLIT_LOG}"
echo

echo "PID Files"
echo "------------------------------------------------------------"
echo "Ollama       : ${LOG_DIR}/ollama.pid"
echo "FastAPI      : ${LOG_DIR}/backend.pid"
echo "Streamlit    : ${LOG_DIR}/streamlit.pid"
echo

echo "Useful Commands"
echo "------------------------------------------------------------"
echo "Stop Services      : ./stop.sh"
echo "Restart Services   : ./restart.sh"
echo "Service Status     : ./status.sh"
echo "Update Components  : ./update.sh"
echo

echo "============================================================"
echo " All services are up and running."
echo " Happy Learning!"
echo "============================================================"
=======
wait_url(){
 URL=$1; NAME=$2
 for i in $(seq 1 60); do
   if curl -fs "$URL" >/dev/null 2>&1; then ok "$NAME ready"; return; fi
   sleep 2
 done
 err "$NAME failed"
}

info "Starting Ollama"
if ! curl -fs http://127.0.0.1:${OLLAMA_PORT}/api/tags >/dev/null 2>&1; then
 nohup ollama serve >"$OLLAMA_LOG" 2>&1 &
 echo $! >"$LOG_DIR/ollama.pid"
 wait_url http://127.0.0.1:${OLLAMA_PORT}/api/tags Ollama
else
 ok "Ollama already running"
fi

ollama list | awk '{print $1}' | grep -qx "$MODEL_NAME" || err "Model $MODEL_NAME not found. Run: ollama pull $MODEL_NAME"

info "Starting FastAPI"
if ! lsof -Pi :"$BACKEND_PORT" -sTCP:LISTEN -t >/dev/null; then
 nohup python3 -m uvicorn backend:app --host 0.0.0.0 --port "$BACKEND_PORT" >"$BACKEND_LOG" 2>&1 &
 echo $! >"$LOG_DIR/backend.pid"
fi
wait_url http://127.0.0.1:${BACKEND_PORT}/health FastAPI

info "Starting Streamlit"
if ! lsof -Pi :"$STREAMLIT_PORT" -sTCP:LISTEN -t >/dev/null; then
 nohup streamlit run app.py --server.address 0.0.0.0 --server.port "$STREAMLIT_PORT" >"$STREAMLIT_LOG" 2>&1 &
 echo $! >"$LOG_DIR/streamlit.pid"
fi
wait_url http://127.0.0.1:${STREAMLIT_PORT} Streamlit

echo
echo "==================== SUMMARY ===================="
echo "Python     : $(python3 --version)"
echo "Ollama     : $(ollama --version)"
echo "Model      : $MODEL_NAME"
echo
echo "Ollama     : http://localhost:${OLLAMA_PORT}"
echo "FastAPI    : http://localhost:${BACKEND_PORT}"
echo "Docs       : http://${IP}:${BACKEND_PORT}/docs"
echo "Streamlit  : http://${IP}:${STREAMLIT_PORT}"
echo
echo "Logs:"
echo "  $OLLAMA_LOG"
echo "  $BACKEND_LOG"
echo "  $STREAMLIT_LOG"
echo
echo "PID files:"
echo "  $LOG_DIR/ollama.pid"
echo "  $LOG_DIR/backend.pid"
echo "  $LOG_DIR/streamlit.pid"
