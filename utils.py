"""
Utility functions for NextGen GenAI Student Lab
"""

import os
import requests

from config import *


# ---------------------------------------
# Create Required Directories
# ---------------------------------------

def create_directories():

    folders = [
        UPLOAD_DIR,
        DOCUMENT_DIR,
        PROMPT_DIR,
        MODEL_DIR,
        LOG_DIR
    ]

    for folder in folders:
        os.makedirs(folder, exist_ok=True)


# ---------------------------------------
# Check Ollama
# ---------------------------------------

def is_ollama_running():

    try:

        response = requests.get(
            OLLAMA_TAGS,
            timeout=5
        )

        return response.status_code == 200

    except Exception:

        return False


# ---------------------------------------
# Health Check
# ---------------------------------------

def get_system_health():

    return {
        "application": APP_NAME,
        "version": VERSION,
        "ollama": is_ollama_running(),
        "model": MODEL_NAME
    }


# ---------------------------------------
# AI Chat
# ---------------------------------------

def generate_response(prompt: str):

    payload = {
        "model": MODEL_NAME,
        "prompt": prompt,
        "stream": False
    }

    response = requests.post(
        OLLAMA_API,
        json=payload,
        timeout=REQUEST_TIMEOUT
    )

    response.raise_for_status()

    data = response.json()

    return data.get("response", "")


# ---------------------------------------
# Installed Models
# ---------------------------------------

def list_models():

    try:

        response = requests.get(
            OLLAMA_TAGS,
            timeout=10
        )

        response.raise_for_status()

        data = response.json()

        return [
            model["name"]
            for model in data.get("models", [])
        ]

    except Exception:

        return []
