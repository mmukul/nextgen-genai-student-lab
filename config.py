"""
Configuration for NextGen GenAI Student Lab
"""

import os
from dotenv import load_dotenv

load_dotenv()

# ---------------------------------------
# Application
# ---------------------------------------

APP_NAME = "NextGen GenAI Student Lab"
VERSION = "0.1"

# ---------------------------------------
# Backend
# ---------------------------------------

API_HOST = os.getenv("API_HOST", "0.0.0.0")
API_PORT = int(os.getenv("API_PORT", "8000"))

# ---------------------------------------
# Streamlit
# ---------------------------------------

UI_HOST = os.getenv("UI_HOST", "0.0.0.0")
UI_PORT = int(os.getenv("UI_PORT", "8501"))

# ---------------------------------------
# Ollama
# ---------------------------------------

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

# ---------------------------------------
# Directories
# ---------------------------------------

BASE_DIR = os.path.dirname(os.path.abspath(__file__))

UPLOAD_DIR = os.path.join(BASE_DIR, "uploads")

DOCUMENT_DIR = os.path.join(BASE_DIR, "documents")

PROMPT_DIR = os.path.join(BASE_DIR, "prompts")

MODEL_DIR = os.path.join(BASE_DIR, "models")

LOG_DIR = os.path.join(BASE_DIR, "logs")

# ---------------------------------------
# Timeout
# ---------------------------------------

REQUEST_TIMEOUT = 300
