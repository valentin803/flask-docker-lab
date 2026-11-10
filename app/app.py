from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    return {
        "message": "DevOps Lab is running!",
        "application": "devops-lab",
        "version": os.getenv("APP_VERSION", "1.0.0"),
        "hostname": socket.gethostname()
    }

@app.route("/health")
def health():
    return {"status": "healthy"}, 200

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000)
