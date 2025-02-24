# BUILD STAGE
FROM python:3.10 AS build

WORKDIR /app

# Copy the requirements.txt file from the flask_app folder
COPY flask_app/requirements.txt /app/

# Upgrade pip and install dependencies (including gunicorn)
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code and model files
COPY flask_app/ /app/
COPY models/vectorizer.pkl /app/models/vectorizer.pkl

# Download only the necessary NLTK data
RUN python -m nltk.downloader stopwords wordnet

# FINAL STAGE
FROM python:3.10-slim AS final

WORKDIR /app

# Copy everything from the build stage
COPY --from=build /app /app

# Double-check gunicorn installation (optional for debugging)
RUN pip install --upgrade pip
RUN pip install --no-cache-dir -r requirements.txt

EXPOSE 5000

# Start the Flask app with Gunicorn
CMD ["gunicorn", "--bind", "0.0.0.0:5000", "--timeout", "3000", "app:app"]
