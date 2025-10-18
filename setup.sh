#!/bin/bash
set -e

echo "📦 Updating system..."
sudo apt update -y
sudo apt upgrade -y

echo "📦 Installing core dependencies for Flask + Picamera2..."
sudo apt install -y \
    python3 python3-venv python3-pip python3-dev \
    python3-libcamera python3-picamera2 python3-kms++ python3-prctl python3-pil \
    libcamera-apps libcap-dev libjpeg-dev libopenjp2-7 libtiff6 libx11-6


echo "🧰 Setting up Python virtual environment..."
python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip setuptools wheel

echo "🐍 Installing Python packages..."
pip install -r requirements.txt

echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt clean

echo "✅ Setup complete! To start the app:"
echo "source venv/bin/activate"
echo "python app.py"
