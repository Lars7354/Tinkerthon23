# Base image for Banana model builds
FROM pytorch/pytorch:1.11.0-cuda11.3-cudnn8-runtime

WORKDIR /

# Install git and required libraries
RUN apt-get update && \
    apt-get install -y git libgl1-mesa-dev libglib2.0-0:i386 && \
    rm -rf /var/lib/apt/lists/*  # Clean up

# Install additional python packages
# torch is already installed in this image
RUN pip3 install --upgrade pip && \
    pip3 install diffusers --upgrade && \
    pip3 install invisible_watermark transformers accelerate safetensors

# Add and download your model weight files 
# (in this case we have a python script)
ADD download.py .
# RUN python3 download.py

# Add only the necessary code files
# Adjust this based on your actual code structure
ADD app.py .

# Expose the port
EXPOSE 8000

# Start the app in the container
CMD ["python3", "-u", "app.py"]
