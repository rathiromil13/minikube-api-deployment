# Use the official Python base image
FROM python:3.7

# Set the locale
RUN apt-get update && apt-get install -y locales && \
    sed -i -e 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen

ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Set the working directory in the container
WORKDIR /app

# Copy requirements.txt from the root directory to the container
COPY ../requirements.txt .
#COPY ../pipeline_tfidfnb.onnx .

# Install Python dependencies
RUN pip install -r requirements.txt

# Copy the app.py file from the api directory to the container
COPY ../api/. .


# Expose the port number that Gunicorn will listen on
EXPOSE 8000

# Command to run the Flask app using Gunicorn
CMD ["gunicorn", "-w", "2", "-b", "0.0.0.0:8000", "app:app"]
