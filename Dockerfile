FROM python:3.11-slim

WORKDIR /app

RUN useradd --create-home --shell /usr/sbin/nologin appuser

COPY app.py .

RUN chown appuser:appuser /app/app.py

USER appuser

CMD ["python", "app.py"]
