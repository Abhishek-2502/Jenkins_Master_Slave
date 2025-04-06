# Use an official Python runtime as a parent image
FROM python:3.10-slim

# Set work directory
WORKDIR /app

# Install dependencies
COPY requirements.txt /app/
RUN pip install --no-cache-dir -r requirements.txt

# Copy the project
COPY . /app/

# Expose the port that the Flask app runs on
EXPOSE 5000

# Command to run the application
CMD ["python", "app.py"]
