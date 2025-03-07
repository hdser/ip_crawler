FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY ip_crawler.py .

CMD ["python", "ip_crawler.py"]FROM python:3.9-slim

WORKDIR /app

# Copy requirements file and install dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Set up directory structure
RUN mkdir -p /app/logs /app/migrations

# Copy files into the container
COPY migrations/ /app/migrations/
COPY src/ /app/src/
COPY entrypoint.sh /app/

# Make entrypoint script executable
RUN chmod +x /app/entrypoint.sh

# Create non-root user for security
RUN useradd -m crawler
RUN chown -R crawler:crawler /app/logs

# Switch to non-root user
USER crawler

# Set Python path
ENV PYTHONPATH=/app

# Use entrypoint script
ENTRYPOINT ["/app/entrypoint.sh"]