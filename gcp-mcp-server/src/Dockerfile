 # Añadimos --platform=linux/amd64
 FROM --platform=linux/amd64 python:3.10-slim
 WORKDIR /app

 COPY requirements.txt .
 RUN pip install --no-cache-dir -r requirements.txt
 COPY server.py .
 ENV PORT=8080

 CMD ["sh", "-c", "uvicorn server:app --host 0.0.0.0 --port ${PORT}"]
