from picamera2 import Picamera2
import time

# Create camera object
picam2 = Picamera2()

# Configure preview or capture settings (simple still config)
config = picam2.create_still_configuration()
picam2.configure(config)

# Start the camera
picam2.start()
time.sleep(2)  # Let the sensor warm up

# Capture and save image
picam2.capture_file("test.jpg")

print("Image saved as test.jpg")
