# NextGen GenAI Student Lab

A lightweight GenAI learning platform built using:

- Streamlit
- FastAPI
- Ollama
- Llama 3.2

---

# Installation

```bash
git clone https://github.com/mmukul/nextgen-genai-student-lab.git

cd nextgen-genai-student-lab

chmod +x *.sh

./install.sh
```

---

# Installer Performs

- Updates OS packages
- Upgrades installed packages
- Installs Python
- Installs pip
- Installs curl
- Installs Git
- Configures firewall
- Opens port **8000** (FastAPI)
- Opens port **8501** (Streamlit)
- Creates Python Virtual Environment
- Installs Python dependencies
- Installs Ollama
- Downloads the Llama 3.2 model
- Starts FastAPI
- Starts Streamlit

---

# Access

## Local Machine

```
http://localhost:8501
```

## Another Computer on the Same Network

Find the server IP:

```bash
hostname -I
```

Example:

```
192.168.1.100
```

Open:

```
UI
http://192.168.1.100:8501

API
http://192.168.1.100:8000/docs
```

---

# Firewall

The installer automatically opens:

| Port | Service |
|------|----------|
| 8000 | FastAPI |
| 8501 | Streamlit |

Supported firewall tools:

- UFW (Ubuntu/Debian)
- firewalld (Fedora/RHEL/Rocky/AlmaLinux)

---

# Start

```bash
./start.sh
```

# Stop

```bash
./stop.sh
```

# Update

```bash
./update.sh
```
