import mlflow
mlflow.set_tracking_uri('https://dagshub.com/ShashankraiOO7/miniproject_emotion_detection.mlflow')


import dagshub
dagshub.init(repo_owner='ShashankraiOO7', repo_name='miniproject_emotion_detection', mlflow=True)

import mlflow
with mlflow.start_run():
  mlflow.log_param('parameter name', 'value')
  mlflow.log_metric('metric name', 1)