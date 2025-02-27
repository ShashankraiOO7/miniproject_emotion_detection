#AWS Login
aws ecr get-login-password --region ap-south-1 | docker login --username AWS --password-stdin 222634383382.dkr.ecr.ap-south-1.amazonaws.com

docker pull 222634383382.dkr.ecr.ap-south-1.amazonaws.com/emotiondetection:1.3



# Check if the container 'campusx-app' is running
if [ "$(docker ps -q -f name=shashankraiCICD)" ]; then
    # Stop the running container
    docker stop shashankraiCICD
fi

# Check if the container 'campusx-app' exists (stopped or running)
if [ "$(docker ps -aq -f name=shashankraiCICD)" ]; then
    # Remove the container if it exists
    docker rm shashankraiCICD
fi

# Run the Docker container
docker run -d -p 80:5000 -e DAGSHUB_PAT=af702d31152ac81e1e55a4ca3ec2a47270c60970 --name shashankraiCICD  222634383382.dkr.ecr.ap-south-1.amazonaws.com/emotiondetection:1.3
