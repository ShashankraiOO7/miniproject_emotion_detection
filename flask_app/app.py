# updated app.py

from flask import Flask, render_template,request
import mlflow
import pickle
import os
import pandas as pd

import numpy as np
import pandas as pd
import os
import re
import nltk
import string
from nltk.corpus import stopwords
from nltk.stem import WordNetLemmatizer
from preprocessing import normalize_text

import dagshub


#Setting up model Reprository/mlflow registory
mlflow.set_tracking_uri('https://dagshub.com/ShashankraiOO7/miniproject_emotion_detection.mlflow')
dagshub.init(repo_owner='ShashankraiOO7', repo_name='miniproject_emotion_detection', mlflow=True)
# Set up MLflow tracking URI


app = Flask(__name__)

# load model from model registry
def get_latest_model_version(model_name):
    client = mlflow.MlflowClient()
    latest_version = client.get_latest_versions(model_name, stages=["Production"])
    if not latest_version:
        latest_version = client.get_latest_versions(model_name, stages=["None"])
    return latest_version[0].version if latest_version else None

model_name = "my_model"
model_version = get_latest_model_version(model_name)

model_uri = f'models:/{model_name}/{model_version}'
model = mlflow.pyfunc.load_model(model_uri)

vectorizer = pickle.load(open('models/vectorizer.pkl','rb'))

@app.route('/')
def home():
    return render_template('web_page.html',result=None)

@app.route('/predict', methods=['POST'])
def predict():

    text = request.form['text']

    # clean
    text = normalize_text(text)

    # bow
    features = vectorizer.transform([text])

    # Convert sparse matrix to DataFrame
    #features_df = pd.DataFrame.sparse.from_spmatrix(features)
    #features_df = pd.DataFrame(features.toarray(), columns=[str(i) for i in range(features.shape[1])])

    # prediction
    result = model.predict(features)
    #return str(result)
    # show
    return render_template('web_page.html', result=result)

if __name__ == "__main__":
    app.run(debug=True)