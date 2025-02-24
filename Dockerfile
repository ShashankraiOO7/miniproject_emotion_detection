#BUILS STAGE STAGE 1

FROM python:3.10 AS build

WORKDIR  /app

#copy the requirements.txt file from the flask_app folder
COPY flask_app/requirements.txt  /app/

#install dependencies
RUN pip install --no-cache-dir -r requirements.txt

#copy the applicatin code and model files
COPY flask_app/ /app/
COPY models/vectorizer.pkl  /app/models/vectorizer.pkl

#DOWNLOAD ONLY THE NECESSARY NLTK data
RUN python -m nltk.downloader stopwords wordnet


#FINAL STAGE 
#Stage 2
FROM python:3.10-slim AS Final

WORKDIR /app

#COPY only the necessary NLTK data
COPY --from=build /app /app

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "3000", "app:app"]


