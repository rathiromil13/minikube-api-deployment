#!/bin/bash

# Variables
DOCKER_IMAGE_NAME="flask-app-image"
HELM_CHART_DIR="./flask-app-chart"
RELEASE_NAME="flask-app-release"

#Download the model file
wget https://gww-ds-mldevops.s3.amazonaws.com/pipeline_tfidfnb.onnx -P ./api/

# Start Minikube (if not already running)
minikube start

#Initialize the metrics server
minikube addons enable metrics-server

# Set Minikube's Docker environment
eval $(minikube -p minikube docker-env)

# Build the Docker image
docker build -t $DOCKER_IMAGE_NAME .

# Load the tagged image into Minikube's Docker daemon
minikube image load $DOCKER_IMAGE_NAME

# Install or upgrade Helm chart
helm upgrade --install $RELEASE_NAME $HELM_CHART_DIR

# Display Helm release status
helm status $RELEASE_NAME