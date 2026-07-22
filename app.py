import streamlit as st
import requests

API_URL = "http://localhost:8000"

st.set_page_config(
    page_title="NextGen GenAI Student Lab",
    page_icon="🤖",
    layout="wide"
)

st.title("🤖 NextGen GenAI Student Lab")

menu = st.sidebar.radio(
    "Navigation",
    ["🏠 Home", "💬 AI Chat", "ℹ️ System Status"]
)

# -------------------------------------------------
# Home
# -------------------------------------------------
if menu == "🏠 Home":

    st.header("Welcome")

    st.write("""
This is a beginner-friendly GenAI lab.

### Features

- 💬 AI Chat
- 📄 Chat with PDF (Coming Soon)
- 🧠 Prompt Playground (Coming Soon)
- 🤖 AI Agents (Coming Soon)
- 🔐 AI Security Labs (Coming Soon)

Built using:

- Streamlit
- FastAPI
- Ollama
- Llama 3.2
""")

# -------------------------------------------------
# AI Chat
# -------------------------------------------------
elif menu == "💬 AI Chat":

    st.header("Chat with Local AI")

    prompt = st.text_area(
        "Ask anything",
        height=180
    )

    if st.button("Send"):

        if prompt.strip() == "":
            st.warning("Please enter a prompt.")

        else:

            with st.spinner("Generating response..."):

                response = requests.post(
                    f"{API_URL}/chat",
                    json={
                        "prompt": prompt
                    }
                )

                result = response.json()

                st.subheader("Response")

                st.write(result["response"])

# -------------------------------------------------
# System Status
# -------------------------------------------------
elif menu == "ℹ️ System Status":

    st.header("System Status")

    try:

        status = requests.get(
            f"{API_URL}/health"
        ).json()

        st.success("Backend Running")

        st.write(status)

    except Exception:

        st.error("Backend is not running.")
