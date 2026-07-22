#!/usr/bin/env bash

echo "Stopping services..."

pkill -f streamlit || true

pkill -f uvicorn || true

echo "Stopped."
