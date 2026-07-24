"""
=========================================================
NextGen GenAI Student Lab
Configuration
=========================================================
"""

import os

# =========================================================
# Application
# =========================================================

APP_NAME = "NextGen GenAI Student Lab"
VERSION = "0.1.0"

# =========================================================
# Server Configuration
# =========================================================

API_HOST = os.getenv("API_HOST", "0.0.0.0")
API_PORT = int(os.getenv("API_PORT", "8000"))

UI_HOST = os.getenv("UI_HOST", "0.0.0.0")
UI_PORT = int(os.getenv("UI_PORT", "8501"))

# =========================================================
# Backend API
# =========================================================

BACKEND_URL = os.getenv(
    "BACKEND_URL",
    f"http://localhost:{API_PORT}"
)

CHAT_API = f"{BACKEND_URL}/chat"
HEALTH_API = f"{BACKEND_URL}/health"
MODELS_API = f"{BACKEND_URL}/models"

# =========================================================
# Ollama Configuration
# =========================================================

OLLAMA_HOST = os.getenv(
    "OLLAMA_HOST",
    "http://localhost:11434"
)

OLLAMA_API = f"{OLLAMA_HOST}/api/generate"
OLLAMA_TAGS = f"{OLLAMA_HOST}/api/tags"

MODEL_NAME = os.getenv(
    "MODEL_NAME",
    "llama3.2:3b"
)

REQUEST_TIMEOUT = int(
    os.getenv("REQUEST_TIMEOUT", "120")
)

# =========================================================
# Streamlit
# =========================================================

PAGE_TITLE = APP_NAME
PAGE_ICON = "🤖"
LAYOUT = "wide"

# =========================================================
# Project Directories
# =========================================================

BASE_DIR = os.path.dirname(
    os.path.abspath(__file__)
)

UPLOADS_DIR = os.path.join(BASE_DIR, "uploads")
DOCUMENTS_DIR = os.path.join(BASE_DIR, "documents")
PROMPTS_DIR = os.path.join(BASE_DIR, "prompts")
MODELS_DIR = os.path.join(BASE_DIR, "models")
LOGS_DIR = os.path.join(BASE_DIR, "logs")

# =========================================================
# Logging
# =========================================================

LOG_LEVEL = os.getenv(
    "LOG_LEVEL",
    "INFO"
)

BACKEND_LOG = "/tmp/backend.log"
STREAMLIT_LOG = "/tmp/streamlit.log"
OLLAMA_LOG = "/tmp/ollama.log"

# =========================================================
# Future Features
# =========================================================

ENABLE_CHAT_HISTORY = False
ENABLE_RAG = False
ENABLE_FILE_UPLOAD = False
ENABLE_AGENTS = False
ENABLE_MCP = False

# =========================================================
# Default Prompts
# =========================================================

SYSTEM_PROMPT = """
You are a helpful AI assistant.
Answer clearly and accurately.
Keep responses beginner friendly.
""".strip()

# =========================================================
# Startup Banner
# =========================================================

def print_configuration():

    print("=" * 60)
    print(APP_NAME)
    print("=" * 60)
    print(f"Version        : {VERSION}")
    print(f"Backend Host   : {API_HOST}")
    print(f"Backend Port   : {API_PORT}")
    print(f"Streamlit Port : {UI_PORT}")
    print(f"Ollama Host    : {OLLAMA_HOST}")
    print(f"Model          : {MODEL_NAME}")
    print(f"Project Folder : {BASE_DIR}")
    print("=" * 60)
