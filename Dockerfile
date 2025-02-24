# --- Builder Stage ---
    FROM python:3.10-slim as builder
    WORKDIR /install
    
    # Copy only the requirements first for caching
    COPY flask_app/requirements.txt .
    
    # Install Python dependencies into a custom prefix directory and download NLTK data
    RUN pip install --no-cache-dir --prefix=/install -r requirements.txt && \
        python -m nltk.downloader -d /install/nltk_data stopwords wordnet
    
    # --- Final Stage ---
    FROM python:3.10-slim
    WORKDIR /app
    
    # Copy installed packages and NLTK data from the builder stage
    COPY --from=builder /install /usr/local
    
    # Set environment variable so NLTK can locate its data
    ENV NLTK_DATA=/usr/local/nltk_data
    
    # Copy the rest of the application code and model
    COPY flask_app/ /app/
    COPY models/vectorizer.pkl /app/models/vectorizer.pkl
    
    # Expose the desired port
    EXPOSE 5000
    
    # Use Gunicorn in production with optimized worker and timeout settings
    CMD ["gunicorn", "--workers", "3", "--bind", "0.0.0.0:5000", "--timeout", "300", "app:app"]
    