FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
#ce fac env asta 
WORKDIR /app
# ce e workdir
COPY requirements.txt .
# care e diff intre copy vs add 
RUN pip install --no-cache-dir -r requirements.txt
# de ce instalezi aici pip ? care e ordinea optima pentru un dockerfile ? cate layere sunt in dockerfileul asta ? ce se intampla daca updatezi app sau requirments 
#
COPY app.py .
# de ce ai adaugat user ce face userul asta ?
RUN useradd --create-home appuser
USER appuser
# de ce expus 5000 ?  de ce python3.12 ? care diff intre o img slim si una non slim ?
EXPOSE 5000

CMD ["python", "app.py"]

# ce s alea layere de docker si cum optimizezi? care e diff dintre cmd entrypoint? de ce ai folosit cmd  si ny entrypoint ? 
