#!/bin/bash
set -euo pipefail

###############################################################################
# NextGen GenAI Student Lab - stop.sh
###############################################################################

ROOT_DIR="$(cd "$(dirname "$0")" && pwd)"
LOG_DIR="$ROOT_DIR/logs"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

ok(){ echo -e "${GREEN}[OK] $1${NC}"; }
warn(){ echo -e "${YELLOW}[WARN] $1${NC}"; }
err(){ echo -e "${RED}[ERROR] $1${NC}"; }

stop_pid() {
    local name="$1"
    local pidfile="$2"

    if [ ! -f "$pidfile" ]; then
        warn "$name PID file not found."
        return
    fi

    local pid
    pid=$(cat "$pidfile")

    if kill -0 "$pid" >/dev/null 2>&1; then
        echo "Stopping $name (PID: $pid)..."
        kill "$pid"

        for _ in $(seq 1 10); do
            if ! kill -0 "$pid" >/dev/null 2>&1; then
                break
            fi
            sleep 1
        done

        if kill -0 "$pid" >/dev/null 2>&1; then
            warn "$name did not stop gracefully. Forcing..."
            kill -9 "$pid" >/dev/null 2>&1 || true
        fi

        ok "$name stopped."
    else
        warn "$name is not running."
    fi

    rm -f "$pidfile"
}

echo "=================================================="
echo " NextGen GenAI Student Lab - Stop"
echo "=================================================="

mkdir -p "$LOG_DIR"

stop_pid "Streamlit" "$LOG_DIR/streamlit.pid"
stop_pid "FastAPI" "$LOG_DIR/backend.pid"
stop_pid "Ollama" "$LOG_DIR/ollama.pid"

# Cleanup any orphan processes still listening on default ports
for port in 8501 8000 11434; do
    if command -v lsof >/dev/null 2>&1; then
        pids=$(lsof -ti tcp:$port || true)
        if [ -n "$pids" ]; then
            warn "Cleaning orphan process(es) on port $port"
            kill $pids >/dev/null 2>&1 || true
        fi
    fi
done

echo
echo "Logs are available in:"
echo "  $LOG_DIR"
echo
ok "All services stopped."
