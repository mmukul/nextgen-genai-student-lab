import os
import logging
import requests

import config

logger = logging.getLogger(__name__)


# -----------------------------------------------------
# Create Required Directories
# -----------------------------------------------------

def create_directories():

    directories = [
        config.UPLOADS_DIR,
        config.DOCUMENTS_DIR,
        config.PROMPTS_DIR,
        config.MODELS_DIR,
        config.LOGS_DIR,
    ]

    for directory in directories:
        os.makedirs(directory, exist_ok=True)


# -----------------------------------------------------
# Check Ollama Status
# -----------------------------------------------------

def is_ollama_running():

    try:

        response = requests.get(
            config.OLLAMA_TAGS,
            timeout=5,
        )

        return response.status_code == 200

    except Exception:

        return False


# -----------------------------------------------------
# System Health
# -----------------------------------------------------

def get_system_health():

    return {
        "application": config.APP_NAME,
        "version": config.VERSION,
        "ollama": is_ollama_running(),
        "model": config.MODEL_NAME,
    }


# -----------------------------------------------------
# Installed Models
# -----------------------------------------------------

def list_models():

    if not is_ollama_running():
        raise Exception("Ollama is not running.")

    response = requests.get(
        config.OLLAMA_TAGS,
        timeout=config.REQUEST_TIMEOUT,
    )

    response.raise_for_status()

    data = response.json()

    return [
        model["name"]
        for model in data.get("models", [])
    ]


# -----------------------------------------------------
# Generate AI Response
# -----------------------------------------------------

def generate_response(prompt: str):

    if not prompt.strip():
        raise ValueError("Prompt cannot be empty.")

    if not is_ollama_running():
        raise Exception("Ollama is not running.")

    payload = {
        "model": config.MODEL_NAME,
        "prompt": prompt,
        "stream": False,
    }

    logger.info("Sending request to Ollama...")

    try:

        response = requests.post(
            config.OLLAMA_API,
            json=payload,
            timeout=config.REQUEST_TIMEOUT,
        )

    except requests.exceptions.Timeout:
        raise Exception("Ollama request timed out.")

    except requests.exceptions.ConnectionError:
        raise Exception("Unable to connect to Ollama.")

    except Exception as ex:
        raise Exception(str(ex))

    if response.status_code != 200:

        try:
            error = response.json()
        except Exception:
            error = response.text

        raise Exception(
            f"Ollama Error ({response.status_code}): {error}"
        )

    data = response.json()

    if "response" not in data:
        raise Exception("Invalid response received from Ollama.")

    logger.info("Response received successfully.")

    return data["response"]


# -----------------------------------------------------
# Verify Selected Model
# -----------------------------------------------------

def model_exists():

    return config.MODEL_NAME in list_models()
