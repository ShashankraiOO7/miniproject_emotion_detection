#AWS Login
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 222634383382.dkr.ecr.ap-south-1.amazonaws.com

docker pull 222634383382.dkr.ecr.ap-south-1.amazonaws.com/emotiondetection:1.0



# Check if the container is already running or exists
docker stop my-container || true
docker rm my-container || true

# Run the Docker container
docker run -d -p 80:5000 -e DAGSHUB_PAT=af702d31152ac81e1e55a4ca3ec2a47270c60970 --name shashankraiCICD  222634383382.dkr.ecr.ap-south-1.amazonaws.com/emotiondetection:1.2
