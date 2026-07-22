# 🤖 NextGen GenAI Student Lab

A lightweight, beginner-friendly GenAI learning platform that runs completely on your local machine using **Ollama**, **FastAPI**, and **Streamlit**.

The goal of this project is to provide an easy-to-install environment for students to learn Generative AI without requiring cloud APIs or GPU infrastructure.

---

# Features

- Local AI Chat
- FastAPI Backend
- Streamlit Web Interface
- Ollama Integration
- One-click Installation
- Automatic Model Download
- Health Check API
- Model Listing API
- Easy Start / Stop Scripts
- Lightweight Architecture
- Linux Compatible

---

# Technology Stack

| Component | Technology |
|-----------|------------|
| UI | Streamlit |
| Backend | FastAPI |
| AI Model | Ollama |
| Default Model | llama3.2:3b |
| Language | Python 3.11+ |
| OS | Ubuntu / Debian / Rocky / Fedora |

---

# Project Structure

```
genai-student-lab/
│
├── install.sh
├── start.sh
├── stop.sh
├── update.sh
│
├── requirements.txt
├── .env.example
├── README.md
├── LICENSE
├── .gitignore
│
├── backend.py
├── app.py
├── config.py
├── utils.py
│
├── logs/
│   ├── install.log
│   ├── backend.log
│   ├── streamlit.log
│   └── ollama.log
│
├── uploads/
├── documents/
├── prompts/
└── models/
```

---

# Prerequisites

- Python 3.11 or later
- Git
- Curl
- Internet connection (first installation only)

---

# Installation

Clone the repository.

```bash
git clone https://github.com/mmukul/nextgen-genai-student-lab.git

cd nextgen-genai-student-lab
```

Make scripts executable.

```bash
chmod +x *.sh
```

Run installation.

```bash
./install.sh
```

The installer performs the following tasks automatically:

- Updates OS packages
- Installs required dependencies
- Creates Python virtual environment
- Installs Python packages
- Installs Ollama
- Downloads the default AI model
- Creates required folders
- Opens firewall ports (if supported)
- Starts the backend
- Starts the Streamlit application

---

# Starting the Application

```bash
./start.sh
```

---

# Stopping the Application

```bash
./stop.sh
```

---

# Updating the Application

```bash
./update.sh
```

---

# Accessing the Application

## Streamlit UI

```
http://localhost:8501
```

## FastAPI Documentation

```
http://localhost:8000/docs
```

## Health Check

```
http://localhost:8000/health
```

---

# External Access

Find your server IP address.

```bash
hostname -I
```

Example

```
192.168.1.100
```

Access from another machine.

```
http://192.168.1.100:8501
```

FastAPI

```
http://192.168.1.100:8000/docs
```

---

# API Endpoints

## Home

```
GET /
```

Returns application information.

---

## Health

```
GET /health
```

Example response

```json
{
    "application": "NextGen GenAI Student Lab",
    "version": "0.1",
    "ollama": true,
    "model": "llama3.2:3b"
}
```

---

## Models

```
GET /models
```

Returns installed Ollama models.

---

## Chat

```
POST /chat
```

Example request

```json
{
    "prompt": "Explain Kubernetes."
}
```

Example response

```json
{
    "success": true,
    "response": "Kubernetes is..."
}
```

---

# Default AI Model

The installer automatically downloads

```
llama3.2:3b
```

You can install additional models.

```bash
ollama pull qwen3
```

```bash
ollama pull mistral
```

```bash
ollama pull gemma3
```

List installed models.

```bash
ollama list
```

---

# Logs

Application logs are stored in

```
logs/
```

Files

```
install.log
backend.log
streamlit.log
ollama.log
```

---

# Environment Variables

Create a `.env` file from `.env.example`.

Example

```
MODEL_NAME=llama3.2:3b

OLLAMA_HOST=http://localhost:11434

API_HOST=0.0.0.0

API_PORT=8000

UI_HOST=0.0.0.0

UI_PORT=8501
```

---

# Troubleshooting

## Check Ollama

```bash
ollama list
```

---

## Start Ollama

```bash
ollama serve
```

---

## Check Backend

```bash
curl http://localhost:8000/health
```

---

## Check Running Processes

```bash
ps -ef | grep streamlit
```

```bash
ps -ef | grep uvicorn
```

```bash
ps -ef | grep ollama
```

---

## View Logs

Backend

```bash
cat logs/backend.log
```

Streamlit

```bash
cat logs/streamlit.log
```

Ollama

```bash
cat logs/ollama.log
```

---

# Current Version

## v0.1

- AI Chat
- FastAPI Backend
- Streamlit UI
- Ollama Integration
- Health API
- Model API
- One-click Installer

---

# Roadmap

## v0.2

- Dashboard
- Better UI
- Chat History

## v0.3

- Prompt Playground
- Prompt Templates

## v0.4

- Model Manager

## v0.5

- Chat with PDF (RAG)

## v0.6

- AI Agents

## v0.7

- MCP Integration

## v0.8

- AI Security Labs

## v1.0

- Complete GenAI Student Learning Platform

---

# License

MIT License

---

# Author

**Mukul Malhotra**

DevOps | DevSecOps | GenAI | Application Security | Corporate Trainer

---
- 🤝 Contribute improvements

Happy Learning! 🚀
