import os

# -----------------------------------------------------
# Application
# -----------------------------------------------------

APP_NAME = "NextGen GenAI Student Lab"
VERSION = "0.1.0"

# -----------------------------------------------------
# Server Configuration
# -----------------------------------------------------

API_HOST = "0.0.0.0"
API_PORT = 8000

UI_HOST = "0.0.0.0"
UI_PORT = 8501

# -----------------------------------------------------
# Ollama Configuration
# -----------------------------------------------------

MODEL_NAME = os.getenv("MODEL_NAME", "llama3.2:3b")

OLLAMA_HOST = os.getenv("OLLAMA_HOST", "http://localhost:11434")

OLLAMA_API = f"{OLLAMA_HOST}/api/generate"
OLLAMA_TAGS = f"{OLLAMA_HOST}/api/tags"

REQUEST_TIMEOUT = 120

# -----------------------------------------------------
# Backend API
# -----------------------------------------------------

BACKEND_URL = f"http://localhost:{API_PORT}"

CHAT_API = f"{BACKEND_URL}/chat"
HEALTH_API = f"{BACKEND_URL}/health"
MODELS_API = f"{BACKEND_URL}/models"

# -----------------------------------------------------
# Directories
# -----------------------------------------------------

BASE_DIR = os.getcwd()

UPLOADS_DIR = os.path.join(BASE_DIR, "uploads")
DOCUMENTS_DIR = os.path.join(BASE_DIR, "documents")
PROMPTS_DIR = os.path.join(BASE_DIR, "prompts")
MODELS_DIR = os.path.join(BASE_DIR, "models")
LOGS_DIR = os.path.join(BASE_DIR, "logs")

# -----------------------------------------------------
# Streamlit
# -----------------------------------------------------

PAGE_TITLE = APP_NAME
PAGE_ICON = "🤖"
LAYOUT = "wide"
