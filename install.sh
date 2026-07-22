#!/usr/bin/env bash

###############################################################################
# NextGen GenAI Student Lab
# One Click Installer
#
# Supported:
# Ubuntu
# Debian
# Rocky Linux
# Fedora
# RHEL
###############################################################################

set -e

PROJECT_NAME="NextGen GenAI Student Lab"

echo "======================================================="
echo "$PROJECT_NAME"
echo "One Click Installer"
echo "======================================================="

if ! command -v python3 >/dev/null 2>&1; then
    echo "Python3 is not installed."
    exit 1
fi

python3 installer.py
