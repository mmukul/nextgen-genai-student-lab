"""
NextGen GenAI Student Lab
FastAPI Backend
Version: 0.1
"""

from fastapi import FastAPI
from pydantic import BaseModel
from fastapi.middleware.cors import CORSMiddleware

from config import APP_NAME, VERSION
from utils import (
    create_directories,
    get_system_health,
    generate_response,
    list_models
)

# ----------------------------------------------------
# Initialization
# ----------------------------------------------------

create_directories()

app = FastAPI(
    title=APP_NAME,
    version=VERSION,
    description="FastAPI Backend for NextGen GenAI Student Lab"
)

# ----------------------------------------------------
# CORS
# ----------------------------------------------------

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# ----------------------------------------------------
# Request Models
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
        "status": "Running"
    }


@app.get("/health")
def health():
    """
    Returns application health.
    """
    return get_system_health()


@app.get("/models")
def models():
    """
    Returns installed Ollama models.
    """
    return {
        "models": list_models()
    }


@app.post("/chat")
def chat(request: ChatRequest):

    print("Prompt:", request.prompt)

    try:
        response = generate_response(request.prompt)

        print("Response:", response)

        return {
            "success": True,
            "response": response
        }

    except Exception as ex:
        print("ERROR:", ex)

        return {
            "success": False,
            "response": "",
            "error": str(ex)
        }


# ----------------------------------------------------
# Run Directly
# ----------------------------------------------------

if __name__ == "__main__":

    import uvicorn
    from config import API_HOST, API_PORT

    uvicorn.run(
        "backend:app",
        host=API_HOST,
        port=API_PORT,
        reload=True
    )
