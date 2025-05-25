# Use the official Python image from the Docker Hub
FROM archlinux:latest

# Set the working directory in the container
WORKDIR /app

# Update repositories
#RUN apt update

# Install requirements
RUN pacman -Syu --noconfirm ffmpeg python python-pip wget

# Copy all files into the container
COPY . .

# Install requirements
RUN pip install --no-cache-dir --break-system-packages -r requirements.txt

# Run app.py when the container launches
CMD ["python3", "ytmdm.py"]