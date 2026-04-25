# ==== Build Stage ====

FROM python:3.12-slim AS builder

#Установка curl для healthchek
RUN apt-get update && apt-get install -y curl && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# ==== Final Stage ====


#Создаем non-root пользователя
FROM python:3.12-slim

RUN useradd -m -s /bin/bash appuser

WORKDIR /app

COPY --from=builder /root/.local /home/appuser/.local

COPY app/ .

#Меняем владельца на appuser
RUN chown -R appuser:appuser /app /home/appuser

#Переключаемся на non-root пользователя
USER appuser

ENV PATH=/home/appuser/.local/bin:$PATH
EXPOSE 5000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:5000/health || exit 1

CMD ["gunicorn", "-b", "0.0.0.0:5000", "main:app"]
