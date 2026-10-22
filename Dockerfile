FROM python:3.12-slim

WORKDIR /app

# gpt4free is installed from the GitHub source tree (the PyPI package is a
# stale 0.0.0 build). This mirrors the upstream Docker recipe:
# requirements-slim.txt + the g4f package used in place.
RUN apt-get update \
    && apt-get install -y --no-install-recommends git ca-certificates \
    && rm -rf /var/lib/apt/lists/* \
    && git clone --depth 1 https://github.com/xtekky/gpt4free.git /tmp/g4f-src \
    && cp -r /tmp/g4f-src/g4f /app/g4f \
    && cp /tmp/g4f-src/requirements-slim.txt /app/requirements.txt \
    && rm -rf /tmp/g4f-src

RUN pip install --no-cache-dir -r /app/requirements.txt

COPY entrypoint.sh /app/entrypoint.sh
RUN chmod +x /app/entrypoint.sh

ENV PYTHONPATH=/app \
    PYTHONUNBUFFERED=1

EXPOSE 8080

CMD ["/app/entrypoint.sh"]
