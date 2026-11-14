FROM python:3.12-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_NO_CACHE_DIR=1 \
    MCP_TRANSPORT=http \
    MCP_HOST=0.0.0.0 \
    MCP_PORT=8000 \
    MCP_PATH=/mcp \
    LOG_FILE=""

WORKDIR /app

COPY pyproject.toml README.md ./
COPY src ./src
RUN pip install . && useradd --create-home --uid 10001 mcp

USER mcp

EXPOSE 8000

CMD ["mcp-justwatch"]
