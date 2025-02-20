from python:3.10

workdir  /app

copy flask_app/  /app/

copy models/vectorizer.pkl  /app/models/vectorizer.pkl

run pip install -r requirements.txt

run python -m nltk.downloader stopwords wordnet

expose 5000

cmd ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "120", "app:app"]


