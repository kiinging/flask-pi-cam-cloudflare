# 📷 Raspberry Pi Zero 2 W Security Camera (Flask + Picamera2)

This project turns a Raspberry Pi Zero 2 W into a **lightweight real-time security camera**, streaming video over your local network or securely over the internet with **Cloudflare Tunnel**.

### ✨ Features

* **Live MJPEG video streaming** in a browser
* **Timestamp overlay** on each frame
* **Low CPU & RAM usage** (optimized for Pi Zero 2 W)
* **Auto-start on boot** via `systemd`
* **Optional secure public access** via Cloudflare Tunnel (no port forwarding needed)

---

## 📚 Reference

* Official Picamera2 docs: [🔗 Raspberry Pi GitHub](https://github.com/raspberrypi/picamera2)

---

# 🚀 PART 1: Local Camera Setup

### 1️⃣ Clone the repository

```bash
git clone https://github.com/kiinging/flask-pi-cam-cloudflare.git
cd flask-pi-cam-cloudflare
```

### 2️⃣ Run the setup script

This will:

* Install system packages
* Create a Python virtual environment (PEP 668 compliant)
* Install all dependencies inside the venv

```bash
chmod +x setup.sh
./setup.sh
```

---
## 🧪 Testing

* **Test camera only**:

```bash
source venv/bin/activate
python cam_test.py
```

* **Monitor system**:

```bash
free     # RAM usage
htop     # CPU & processes
```

---
## 🛠 Auto-start with systemd

We use a virtual environment to avoid conflicts between apt-managed and pip-installed packages.

### 3️⃣ Install the systemd service

```bash
sudo cp camera_app.service /etc/systemd/system/
```

### 4️⃣ Reload systemd, enable & start the service

```bash
sudo systemctl daemon-reload
sudo systemctl enable camera_app
sudo systemctl start camera_app
```

### 5️⃣ Check status

```bash
sudo systemctl status camera_app
```

---

## 🌐 Local Access

Once running, open:

```
http://<pi-ip>:5000
```

---

# 🌍 PART 2: Cloudflare Tunnel (Secure Remote Access)

Cloudflare Tunnel lets you securely access your Pi camera from anywhere without exposing your home network.

---

### 1️⃣ Install cloudflared

```bash
wget https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-arm64.deb
sudo apt install ./cloudflared-linux-arm64.deb
```

### 2️⃣ Test temporary tunnel

```bash
cloudflared tunnel --url http://localhost:5000
```

You’ll get a temporary `.trycloudflare.com` link.
(This closes when you stop the command.)

---

### 3️⃣ Create a permanent tunnel

1. **Log in to Cloudflare**:

```bash
cloudflared login
```

Open the URL, select your domain, and authorize.
Pi will store the cert at:

```
/home/pizza/.cloudflared/cert.pem
```

2. **Create the tunnel**:

```bash
cloudflared tunnel create pi-camera
```

3. **Create tunnel config**:

```bash
nano /home/pizza/.cloudflared/config.yml
```

```yaml
tunnel: 09457b11-3125-47e2-bd6b-8cc7a67d37de
credentials-file: /home/pizza/.cloudflared/09457b11-3125-47e2-bd6b-8cc7a67d37de.json

ingress:
  - hostname: cam.plc-web.online
    service: http://localhost:5000
  - service: http_status:404
```

4. **Route the hostname**:

```bash
cloudflared tunnel route dns pi-camera cam.plc-web.online
```

5. **Start the tunnel**:

```bash
cloudflared tunnel run pi-camera
```

Your camera is now live at:

```
https://cam.plc-web.online
```

---

# 🔄 PART 3: Auto-start Cloudflare Tunnel on Boot

Create a systemd service for Cloudflare:

```bash
sudo cp cloudflared.service /etc/systemd/system/
```


Enable and start:

```bash
sudo systemctl daemon-reload
sudo systemctl enable cloudflared
sudo systemctl start cloudflared
```

Now both your camera app **and** Cloudflare Tunnel start automatically when you power on your Pi.

You can reboot the Pi with:
```bash
sudo reboot
```
---

## ⚡ Tips

* Keep your Pi updated: `sudo apt update && sudo apt upgrade -y`
* Check tunnel logs: `journalctl -u cloudflared -f`
* Check camera logs: `journalctl -u camera_app -f`

---


