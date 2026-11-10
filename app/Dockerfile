# tagul 3.12-slim arata mereu spre aceeasi imagine ? ce inseamna sa fixezi imaginea dupa digest (sha256) si cand ai face asta ?
# nu exista .dockerignore in repo - ce e build context si ce ajunge in el cand dai docker build ?
# scrie comenzile exacte cu care buildezi si pornesti containerul pe server. care e diff intre -p 5000:5000 si -p 127.0.0.1:5000:5000 ?
# ce se intampla cu containerul dupa un reboot al serverului ? ce e o restart policy ?
# unde tii imaginea dupa build ? ce e un registry si cum ajunge imaginea de pe laptop / pipeline pe EC2 ?
# nu ai HEALTHCHECK - ce face instructiunea asta si cum ai lega-o de /health din app.py ?
FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app.py .

RUN useradd --create-home appuser
USER appuser

EXPOSE 5000

CMD ["python", "app.py"]
