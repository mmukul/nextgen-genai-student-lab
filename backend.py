from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Optional
import logging
import config
from utils import (
    generate_response,
    get_system_health,
    list_models,
)

# ----------------------------------------------------
# Logging
# ----------------------------------------------------

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
)

logger = logging.getLogger(__name__)

# ----------------------------------------------------
# FastAPI
# ----------------------------------------------------

app = FastAPI(
    title=config.APP_NAME,
    version=config.VERSION,
)

# ----------------------------------------------------
# Request Model
# ----------------------------------------------------

class ChatRequest(BaseModel):
    prompt: str

# ----------------------------------------------------
# Root
# ----------------------------------------------------

@app.get("/")
def root():
    return {
        "application": config.APP_NAME,
        "version": config.VERSION,
        "status": "running"
    }

# ----------------------------------------------------
# Health
# ----------------------------------------------------

@app.get("/health")
def health():

    try:
        return get_system_health()

    except Exception as ex:
        logger.exception(ex)

        raise HTTPException(
            status_code=500,
            detail=str(ex)
        )

# ----------------------------------------------------
# Installed Models
# ----------------------------------------------------

@app.get("/models")
def models():

    try:
        return {
            "success": True,
            "models": list_models()
        }

    except Exception as ex:

        logger.exception(ex)

        raise HTTPException(
            status_code=500,
            detail=str(ex)
        )

# ----------------------------------------------------
# Chat
# ----------------------------------------------------

@app.post("/chat")
def chat(request: ChatRequest):

    prompt = request.prompt.strip()

    if not prompt:
        raise HTTPException(
            status_code=400,
            detail="Prompt cannot be empty."
        )

    logger.info("Prompt received")

    try:

        response = generate_response(prompt)

        return {
            "success": True,
            "response": response,
            "error": None
        }

    except Exception as ex:

        logger.exception(ex)

        return {
            "success": False,
            "response": "",
            "error": str(ex)
        }

# ----------------------------------------------------
# Startup
# ----------------------------------------------------

@app.on_event("startup")
def startup():

    logger.info("----------------------------------------")
    logger.info(config.APP_NAME)
    logger.info("Version : %s", config.VERSION)
    logger.info("Model   : %s", config.MODEL_NAME)
    logger.info("Backend Started")
    logger.info("----------------------------------------")
