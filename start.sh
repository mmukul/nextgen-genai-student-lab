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
