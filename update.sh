#!/usr/bin/env bash

source .venv/bin/activate

git pull

pip install -r requirements.txt

echo "Updated Successfully"
