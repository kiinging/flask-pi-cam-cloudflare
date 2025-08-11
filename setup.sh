#!/bin/bash
set -e  # exit if a command fails

echo "📦 Updating system..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing system-level dependencies..."
sudo apt install -y \
    python3-venv python3-dev python3-pip \
    libatlas-base-dev libjpeg-dev libopenjp2-7 libtiff6 libx11-6 \
    python3-picamera2 libcamera-apps python3-libcamera \
    python3-kms++ python3-pyqt5 python3-prctl python3-pil

echo "🐍 Creating virtual environment..."
# Create new venv that includes system packages
python3 -m venv venv --system-site-packages
source venv/bin/activate

echo "⬆️ Upgrading pip..."
pip install --upgrade pip

echo "📦 Installing Python packages from requirements.txt..."
pip install -r requirements.txt

echo "✅ Setup complete! Use 'source venv/bin/activate' to start the venv."

