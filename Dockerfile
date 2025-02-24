# --- Builder Stage ---
    FROM python:3.10-slim as builder

    # Create a working directory for dependencies
    WORKDIR /install
    
    # Copy only requirements for layer caching
    COPY requirements.txt .  
    
    # Install dependencies in the default location
    RUN pip install --no-cache-dir -r requirements.txt
    
    # Download NLTK data (this will work only if nltk is installed)
    RUN python -m nltk.downloader stopwords wordnet
    
    # --- Final Stage ---
    FROM python:3.10-slim
    
    # Copy installed dependencies from builder stage
    COPY --from=builder /usr/local /usr/local
    
    # NLTK data environment variable
    ENV NLTK_DATA=/usr/local/nltk_data
    
    # Create the working directory for your app
    WORKDIR /app
    
    # Copy the rest of your app code
    COPY . /app
    
    # Expose port 5000
    EXPOSE 5000
    
    # Start your Flask/Gunicorn app
    CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
    