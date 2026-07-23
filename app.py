import requests
import streamlit as st

import config

# -----------------------------------------------------
# Page Configuration
# -----------------------------------------------------

st.set_page_config(
    page_title=config.PAGE_TITLE,
    page_icon=config.PAGE_ICON,
    layout=config.LAYOUT,
)

# -----------------------------------------------------
# Sidebar
# -----------------------------------------------------

st.sidebar.title(config.APP_NAME)

page = st.sidebar.radio(
    "Navigation",
    [
        "🏠 Home",
        "💬 AI Chat",
        "🩺 System Status",
    ],
)

# -----------------------------------------------------
# Home
# -----------------------------------------------------

if page == "🏠 Home":

    st.title(config.APP_NAME)

    st.write(f"Version **{config.VERSION}**")

    st.success("Welcome to the NextGen GenAI Student Lab.")

    st.markdown("""
### Features

- Local AI Chat
- Ollama Integration
- FastAPI Backend
- Streamlit UI
- Beginner Friendly

---
Future Versions

- Prompt Playground
- Chat History
- Chat with PDF
- RAG
- AI Agents
- MCP
""")

# -----------------------------------------------------
# AI Chat
# -----------------------------------------------------

elif page == "💬 AI Chat":

    st.title("AI Chat")

    prompt = st.text_area(
        "Enter your prompt",
        height=180,
    )

    if st.button("Generate Response"):

        if not prompt.strip():
            st.warning("Please enter a prompt.")
            st.stop()

        with st.spinner("Generating response..."):

            try:

                response = requests.post(
                    config.CHAT_API,
                    json={"prompt": prompt},
                    timeout=180,
                )

                response.raise_for_status()

                result = response.json()

                if result["success"]:

                    st.success("Response Generated")

                    st.write(result["response"])

                else:

                    st.error(result["error"])

            except requests.exceptions.ConnectionError:

                st.error(
                    "Unable to connect to Backend."
                )

            except requests.exceptions.Timeout:

                st.error(
                    "Request timed out."
                )

            except Exception as ex:

                st.exception(ex)

# -----------------------------------------------------
# System Status
# -----------------------------------------------------

elif page == "🩺 System Status":

    st.title("System Status")

    if st.button("Refresh"):

        try:

            response = requests.get(
                config.HEALTH_API,
                timeout=10,
            )

            response.raise_for_status()

            health = response.json()

            st.json(health)

            if health["ollama"]:

                st.success("Ollama is running.")

            else:

                st.error("Ollama is not running.")

        except Exception as ex:

            st.exception(ex)
