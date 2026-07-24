# 🤖 NextGen GenAI Student Lab

A beginner-friendly **Local GenAI Learning Platform** built using **Streamlit**, **FastAPI**, **Python**, and **Ollama**.

Run Large Language Models (LLMs) locally without any cloud API keys and learn how modern GenAI applications are built.

---

# Features

* Local AI Chat using Ollama
* FastAPI REST Backend
* Streamlit Web UI
* Beginner Friendly
* No OpenAI API Key Required
* Lightweight Architecture
* Extensible for RAG, AI Agents and MCP

---

# Architecture

```text
                    +------------------+
                    |   Streamlit UI   |
                    +------------------+
                             |
                             |
                    REST API (HTTP)
                             |
                             v
                    +------------------+
                    |     FastAPI      |
                    +------------------+
                             |
                             |
                       Python Utils
                             |
                             v
                    +------------------+
                    |      Ollama      |
                    +------------------+
                             |
                             |
                        Local LLM
```

---

# Repository Structure

```text
nextgen-genai-student-lab/

│
├── app.py
├── backend.py
├── config.py
├── utils.py
│
├── requirements.txt
├── README.md
├── LICENSE
├── .gitignore
│
├── setup.sh
├── start.sh
├── stop.sh
├── restart.sh
├── status.sh
├── update.sh
│
├── uploads/
├── documents/
├── prompts/
├── models/
├── logs/
```

---

# Prerequisites

* Python 3.10+
* Git
* curl
* wget
* zstd
* Linux (Rocky Linux, Ubuntu, Fedora, Debian)
* Internet connection (first-time model download)

---

# Clone Repository

```bash
git clone <repository-url>

cd nextgen-genai-student-lab
```

---

# Install

Run the setup script.

```bash
chmod +x *.sh

./setup.sh
```

The setup script automatically:

* Installs required Linux packages
* Installs Python dependencies
* Downloads and installs Ollama
* Starts Ollama
* Verifies Ollama health
* Downloads the default LLM (`llama3.2:3b`)

---

# Start Application

```bash
./start.sh
```

The script starts:

* Ollama
* FastAPI
* Streamlit

Example output:

```text
=========================================
 Services Started Successfully
=========================================

FastAPI
Local : http://localhost:8000
LAN   : http://192.168.1.25:8000
Docs  : http://192.168.1.25:8000/docs

Streamlit
Local : http://localhost:8501
LAN   : http://192.168.1.25:8501
```

---

# Stop Services

```bash
./stop.sh
```

---

# Restart Services

```bash
./restart.sh
```

---

# Check Service Status

```bash
./status.sh
```

---

# Update Application

```bash
./update.sh
```

---

# Access the Application

## Local Machine

Streamlit

```text
http://localhost:8501
```

FastAPI

```text
http://localhost:8000
```

Swagger API

```text
http://localhost:8000/docs
```

---

## Other Machines (LAN)

If your VM uses a **Bridged Adapter**, use the IP shown by `./start.sh`.

Example:

```text
http://192.168.1.25:8501
```

---

# REST APIs

## Health

```http
GET /health
```

Example

```json
{
    "application":"NextGen GenAI Student Lab",
    "version":"0.1.0",
    "ollama":true,
    "model":"llama3.2:3b"
}
```

---

## Installed Models

```http
GET /models
```

---

## Chat

```http
POST /chat
```

Request

```json
{
    "prompt":"Explain DevSecOps"
}
```

Response

```json
{
    "success":true,
    "response":"..."
}
```

---

# Configuration

Application settings are stored in

```text
config.py
```

Important configuration values:

* API_HOST
* API_PORT
* UI_HOST
* UI_PORT
* MODEL_NAME
* OLLAMA_HOST
* REQUEST_TIMEOUT

---

# Default Model

```text
llama3.2:3b
```

To use another model:

```bash
ollama pull qwen3:4b
```

Update `MODEL_NAME` in `config.py` or set the `MODEL_NAME` environment variable.

---

# Logs

Ollama

```bash
tail -f /tmp/ollama.log
```

Backend

```bash
tail -f /tmp/backend.log
```

Streamlit

```bash
tail -f /tmp/streamlit.log
```

---

# Firewall (Rocky Linux)

Allow external access:

```bash
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --permanent --add-port=8501/tcp
sudo firewall-cmd --reload
```

Verify:

```bash
sudo firewall-cmd --list-ports
```

---

# Troubleshooting

## Ollama not running

```bash
tail -f /tmp/ollama.log
```

Restart:

```bash
./restart.sh
```

---

## Backend not reachable

Check backend log:

```bash
tail -f /tmp/backend.log
```

Verify:

```text
http://localhost:8000/health
```

---

## Streamlit not opening

Check:

```bash
tail -f /tmp/streamlit.log
```

Verify:

```text
http://localhost:8501
```

---

## Download interrupted

Retry:

```bash
./setup.sh
```

If required:

```bash
rm -f /tmp/ollama-linux-amd64.tar.zst
```

Run setup again.

---

# Future Roadmap

Version 0.2

* Prompt Playground
* Multiple Model Selection
* Chat History
* Markdown Rendering

Version 0.3

* Chat with PDF
* RAG
* ChromaDB
* Vector Search

Version 0.4

* AI Agents
* MCP
* Function Calling
* Tool Integration

Version 1.0

* Authentication
* User Management
* Model Manager
* Training Labs
* AI Security Labs

---

# Technology Stack

* Python
* FastAPI
* Streamlit
* Ollama
* Requests
* Uvicorn

---

# License

MIT License

---

# Author

**Mukul Malhotra**

Corporate Trainer | DevSecOps Architect | GenAI Consultant

Happy Learning!
