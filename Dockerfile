# Use a suitable base image
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime AS base

# Set the working directory
WORKDIR /app

# Install git and other dependencies
RUN apt-get update && apt-get install -y git libgl1-mesa-dev libglib2.0-0:i386 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip and install python packages
RUN pip3 install --upgrade pip && \
    pip3 install diffusers invisible_watermark transformers accelerate safetensors

# Copy the requirements file and install dependencies
COPY requirements.txt .
RUN pip3 install -r requirements.txt

# Copy the download script and run it
COPY download.py .
RUN python3 download.py

# Copy the rest of the application code
COPY . .

# Expose the necessary port
EXPOSE 8000

# Run the application
CMD ["python3", "-u", "app.py"]
