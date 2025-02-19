import re
from flask import Flask, render_template, request
import mlflow
import pickle
import os
import numpy as np
import pandas as pd
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
import string

# Set up DagsHub credentials for MLflow tracking
dagshub_token = os.getenv("DAGSHUB_PAT")
if not dagshub_token:
    raise EnvironmentError("DAGSHUB_PAT environment variable is not set")

os.environ["MLFLOW_TRACKING_USERNAME"] = dagshub_token
os.environ["MLFLOW_TRACKING_PASSWORD"] = dagshub_token

dagshub_url = "https://dagshub.com"
repo_owner = "ShashankraiOO7"
repo_name = "miniproject_emotion_detection"

# Set up MLflow tracking URI (adjust this URI as needed)
mlflow.set_tracking_uri(f"{dagshub_url}/{repo_owner}/{repo_name}/mlflow")

# Text preprocessing functions
def lemmatization(text):
    lemmatizer = WordNetLemmatizer()
    return " ".join([lemmatizer.lemmatize(word) for word in text.split()])

def remove_stop_words(text):
    stop_words = set(stopwords.words("english"))
    return " ".join([word for word in text.split() if word not in stop_words])

def removing_numbers(text):
    return ''.join([char for char in text if not char.isdigit()])

def lower_case(text):
    return text.lower()

def removing_punctuations(text):
    text = re.sub(f"[{re.escape(string.punctuation)}]", ' ', text)
    text = re.sub('\s+', ' ', text).strip()
    return text

def removing_urls(text):
    return re.sub(r'https?://\S+|www\.\S+', '', text)

def normalize_text(text):
    text = lower_case(text)
    text = remove_stop_words(text)
    text = removing_numbers(text)
    text = removing_punctuations(text)
    text = removing_urls(text)
    text = lemmatization(text)
    return text

app = Flask(__name__)

# Load model from MLflow model registry
def get_latest_model_version(model_name):
    client = mlflow.MlflowClient()
    latest_version = client.get_latest_versions(model_name, stages=["Production"])
    if not latest_version:
        latest_version = client.get_latest_versions(model_name, stages=["None"])
    if not latest_version:
        raise ValueError(f"No versions found for model '{model_name}'")
    return latest_version[0].version

model_name = "my_model"
model_version = get_latest_model_version(model_name)
model_uri = f"models:/{model_name}/{model_version}"
model = mlflow.pyfunc.load_model(model_uri)

# Load vectorizer
vectorizer_path = 'models/vectorizer.pkl'
if not os.path.exists(vectorizer_path):
    raise FileNotFoundError(f"Vectorizer file not found: {vectorizer_path}")
vectorizer = pickle.load(open(vectorizer_path, 'rb'))

@app.route('/')
def home():
    return render_template('index.html', result=None)

@app.route('/predict', methods=['POST'])
def predict():
    text = request.form['text']
    # Clean and normalize text
    text = normalize_text(text)
    # Convert text to BOW features
    features = vectorizer.transform([text])
    # Convert to DataFrame
    features_df = pd.DataFrame(features.toarray(), columns=[str(i) for i in range(features.shape[1])])
    # Get prediction
    result = model.predict(features_df)
    return render_template('index.html', result=result[0])

if __name__ == "__main__":
    app.run(debug=True)
