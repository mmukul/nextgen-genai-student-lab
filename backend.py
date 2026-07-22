"""
NextGen GenAI Student Lab
FastAPI Backend
Version: 0.1
"""

import logging

from fastapi import FastAPI, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel

from config import APP_NAME, VERSION
from utils import (
    create_directories,
    generate_response,
    get_system_health,
    list_models,
)

# ----------------------------------------------------
# Logging
# ----------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(message)s",
)

logger = logging.getLogger(__name__)

# ----------------------------------------------------
# Initialize
# ----------------------------------------------------

create_directories()

app = FastAPI(
    title=APP_NAME,
    version=VERSION,
    description="NextGen GenAI Student Lab API",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------------------------------
# Request Model
# ----------------------------------------------------

class ChatRequest(BaseModel):
    prompt: str

# ----------------------------------------------------
# Routes
# ----------------------------------------------------

@app.get("/")
def home():
    return {
        "application": APP_NAME,
        "version": VERSION,
        "status": "Running",
    }


@app.get("/health")
def health():
    return get_system_health()


@app.get("/models")
def models():
    return {
        "success": True,
        "models": list_models(),
    }


@app.post("/chat")
def chat(request: ChatRequest):
    """
    Generate response using Ollama.
    """

    prompt = request.prompt.strip()

    if not prompt:
        raise HTTPException(
            status_code=400,
            detail="Prompt cannot be empty.",
        )

    logger.info("Prompt: %s", prompt)

    try:

        response = generate_response(prompt)

        logger.info("Response generated successfully.")

        return {
            "success": True,
            "response": response,
        }

    except Exception as ex:

        logger.exception("Chat generation failed")

        raise HTTPException(
            status_code=500,
            detail=str(ex),
        )
