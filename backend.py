from fastapi import FastAPI
from pydantic import BaseModel
import requests
import os

app = FastAPI(
    title="NextGen GenAI Student Lab",
    version="0.1"
)

OLLAMA_URL = os.getenv(
    "OLLAMA_URL",
    "http://localhost:11434/api/generate"
)

MODEL = os.getenv(
    "MODEL_NAME",
    "llama3.2:3b"
)


class ChatRequest(BaseModel):
    prompt: str


@app.get("/")
def home():
    return {
        "application": "NextGen GenAI Student Lab",
        "status": "Running"
    }


@app.get("/health")
def health():

    try:

        response = requests.get(
            "http://localhost:11434/api/tags",
            timeout=5
        )

        if response.status_code == 200:

            return {
                "backend": "Running",
                "ollama": "Connected"
            }

    except Exception:

        return {
            "backend": "Running",
            "ollama": "Not Running"
        }


@app.post("/chat")
def chat(request: ChatRequest):

    payload = {
        "model": MODEL,
        "prompt": request.prompt,
        "stream": False
    }

    try:

        response = requests.post(
            OLLAMA_URL,
            json=payload,
            timeout=300
        )

        data = response.json()

        return {
            "response": data.get("response", "")
        }

    except Exception as ex:

        return {
            "response": "",
            "error": str(ex)
        }
