FROM python:3.10

WORKDIR  /app

copy flask_app/  /app/

copy models/vectorizer.pkl  /app/models/vectorizer.pkl

run pip install -r requirements.txt

run python -m nltk.downloader stopwords wordnet

expose 5000

CMD ["python","app.py"]


