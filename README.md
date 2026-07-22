# NextGen GenAI Student Lab

A lightweight local GenAI platform built with:

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

# What the Installer Does

- Updates operating system packages
- Installs Python
- Installs Git
- Installs curl
- Creates a Python virtual environment
- Installs Python dependencies
- Installs Ollama
- Downloads the Llama 3.2 model
- Configures firewalld
- Opens ports **8000** and **8501**
- Starts the application

---

# Firewall Configuration (firewalld)

The installer executes the following commands automatically:

```bash
sudo systemctl enable firewalld

sudo systemctl start firewalld

sudo firewall-cmd --permanent --add-port=8000/tcp

sudo firewall-cmd --permanent --add-port=8501/tcp

sudo firewall-cmd --reload

sudo firewall-cmd --list-ports
```

Expected output:

```
8000/tcp 8501/tcp
```

---

# Access the Application

Local machine:

```
http://localhost:8501
```

From another computer on the same network:

```
http://<SERVER-IP>:8501
```

API Documentation:

```
http://<SERVER-IP>:8000/docs
```

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
http://192.168.1.100:8501
```

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

---

# Verify Firewall

```bash
sudo firewall-cmd --list-ports
```

Expected output:

```
8000/tcp 8501/tcp
```
