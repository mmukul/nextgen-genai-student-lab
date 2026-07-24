#########################################################
# Summary
#########################################################

echo
echo "========================================="
echo " Services Started Successfully"
echo "========================================="
echo

echo "Ollama API"
echo "  http://localhost:11434"

echo
echo "FastAPI"
echo "  Local : http://localhost:8000"
echo "  LAN   : http://${IP_ADDRESS}:8000"

echo
echo "Streamlit"
echo "  Local : http://localhost:8501"
echo "  LAN   : http://${IP_ADDRESS}:8501"

echo
echo "Logs"
echo "-----------------------------------------"
echo "tail -f /tmp/ollama.log"
echo "tail -f /tmp/backend.log"
echo "tail -f /tmp/streamlit.log"
echo
