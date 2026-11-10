from flask import Flask
import os
import socket

app = Flask(__name__)

@app.route("/")
def home():
    # returnezi un dict din python - ce primeste de fapt clientul ? ce Content-Type si ce status code ? cum verifici asta cu curl ?
    return {
        "message": "DevOps Lab is running!",
        "application": "devops-lab",
        "version": os.getenv("APP_VERSION", "1.0.0"),  # de unde vine APP_VERSION ? cum o setezi cand pornesti containerul ? ce se intampla daca nu e setata ?
        "hostname": socket.gethostname()  # ce valoare vezi aici cand rulezi in container vs direct pe EC2 ? de ce difera ?
    }

@app.route("/health")
def health():
    # la ce ajuta un endpoint de health ? cine il apeleaza in practica ? care e diff intre liveness si readiness ?
    return {"status": "healthy"}, 200

if __name__ == "__main__":  # ce face conditia asta ? cand e adevarata si cand nu ?
    # de ce 0.0.0.0 si nu 127.0.0.1 ? ce se intampla in container daca pui 127.0.0.1 ?
    # app.run porneste serverul de development din Flask - e ok pentru productie ? ce ai folosi in loc si de ce ?
    app.run(host="0.0.0.0", port=5000)
