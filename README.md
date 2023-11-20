# Top K Terms Prediction Flask API on Minikube

This application is developed to deploy a Flask API on Minikube with load balancing capabilities for predicting the top K terms given a search query.

## Prerequisites

Make sure you have the following dependencies installed:
- Docker
- Minikube
- kubectl
- hey

## Getting Started

To run the application, follow these steps:

1. Run the build script:
    ```bash
    ./build.sh
    ```
    This script starts Minikube, builds the Docker image, and deploys the application on Minikube.

2. Run `minikube service flask-app-service` to start the service. The logs will show service IP and open Swagger API.

3. Use curl to test the API:
    ```bash
    curl -X POST -H "Content-Type: application/json" -d '{"query":"cordless drill", "topk": 10}' http://{service_ip}/predict
    ```
    Replace `{service_ip}` with the service IP obtained from step 3.

4. Run Load testing using Hey

    ```bash
    hey -q 50 -z 5m -t 80 -c 50 -m POST -H "Content-Type: application/json" -d '{"query":"cordless drill", "topk": 10}' http://{service_ip}/predict
    ```

    ```bash
    hey -q 100 -z 5m -t 80 -c 100 -m POST -H "Content-Type: application/json" -d '{"query":"cordless drill", "topk": 10}' http://{service_ip}/predict
    ```
5. Update /etc/hosts to include minikube ip with host as app.minikube.local

## File Structure

- `/api/app.py`: Contains the code for the API endpoint to predict the top K terms based on a search query.
- `/app/model.py`: Helper functions to load the model and perform predictions.
- `/app/model_file`: The model file used by the API.
- `flask-app-chart`: Helm chart for deploying the Flask app on Minikube.
- `requirements.txt`: Python dependencies required by the application.
- `Dockerfile`: Configuration file for building the Docker container with the Flask app.
- `build.sh`: Script to start the service and deploy the application on Minikube.
- Load Test Results: The directory contains the pdf of load testing results.

## Usage

- Once the application is deployed, interact with the Flask API at the specified endpoint to get predictions for top K terms.
- Use appropriate HTTP requests with the provided endpoint to predict top terms based on search queries.
