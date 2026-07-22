"""
NextGen GenAI Student Lab
Utility Functions
Version: 0.1
"""

import logging
import os
import requests

from config import (
    APP_NAME,
    VERSION,
    MODEL_NAME,
    OLLAMA_API,
    OLLAMA_TAGS,
    REQUEST_TIMEOUT,
    UPLOAD_DIR,
    DOCUMENT_DIR,
    PROMPT_DIR,
    MODEL_DIR,
    LOG_DIR,
)

# ----------------------------------------------------
# Logging
# ----------------------------------------------------

logger = logging.getLogger(__name__)

# ----------------------------------------------------
# Create Required Directories
# ----------------------------------------------------

def create_directories():
    """
    Create all required application folders.
    """

    directories = [
        UPLOAD_DIR,
        DOCUMENT_DIR,
        PROMPT_DIR,
        MODEL_DIR,
        LOG_DIR,
    ]

    for directory in directories:
        os.makedirs(directory, exist_ok=True)


# ----------------------------------------------------
# Check Ollama
# ----------------------------------------------------

def is_ollama_running():
    """
    Check whether Ollama server is running.
    """

    try:

        response = requests.get(
            OLLAMA_TAGS,
            timeout=5,
        )

        return response.status_code == 200

    except Exception:

        return False


# ----------------------------------------------------
# Health Check
# ----------------------------------------------------

def get_system_health():
    """
    Returns application health.
    """

    return {
        "application": APP_NAME,
        "version": VERSION,
        "ollama": is_ollama_running(),
        "model": MODEL_NAME,
    }


# ----------------------------------------------------
# Installed Models
# ----------------------------------------------------

def list_models():
    """
    Returns installed Ollama models.
    """

    try:

        response = requests.get(
            OLLAMA_TAGS,
            timeout=10,
        )

        response.raise_for_status()

        data = response.json()

        models = []

        for model in data.get("models", []):

            if "name" in model:
                models.append(model["name"])

        return models

    except Exception as ex:

        logger.exception("Unable to fetch model list.")

        raise Exception(
            f"Unable to retrieve Ollama models.\n{ex}"
        )


# ----------------------------------------------------
# Generate AI Response
# ----------------------------------------------------

def generate_response(prompt: str):
    """
    Generate AI response using Ollama.
    """

    if not prompt.strip():
        raise Exception("Prompt cannot be empty.")

    payload = {
        "model": MODEL_NAME,
        "prompt": prompt,
        "stream": False,
    }

    logger.info("Sending prompt to Ollama...")

    try:

        response = requests.post(
            OLLAMA_API,
            json=payload,
            timeout=REQUEST_TIMEOUT,
        )

    except requests.exceptions.ConnectionError:

        raise Exception(
            "Cannot connect to Ollama.\n"
            "Please ensure 'ollama serve' is running."
        )

    except requests.exceptions.Timeout:

        raise Exception(
            "Ollama request timed out."
        )

    except Exception as ex:

        raise Exception(str(ex))

    # --------------------------------------------
    # Handle HTTP Errors
    # --------------------------------------------

    if response.status_code != 200:

        try:

            error = response.json()

        except Exception:

            error = response.text

        raise Exception(
            f"Ollama Error ({response.status_code})\n\n{error}"
        )

    # --------------------------------------------
    # Parse Response
    # --------------------------------------------

    try:

        data = response.json()

    except Exception:

        raise Exception(
            "Invalid JSON response received from Ollama."
        )

    answer = data.get("response")

    if answer is None or answer.strip() == "":

        raise Exception(
            "Ollama returned an empty response."
        )

    logger.info("Response generated successfully.")

    return answer.strip()
