# MCP JustWatch Server

A Model Context Protocol (MCP) server built to provide access to JustWatch streaming availability data. Search for movies and TV shows and find out where they're available to stream across different platforms and countries.

## Features

- **Search Content**: Search for movies and TV shows by title with detailed metadata
- **Streaming Availability**: Get comprehensive information about where content is available to stream
- **Multi-Country Support**: Query streaming availability across multiple countries simultaneously
- **Detailed Information**: Access IMDb/TMDb scores, genres, runtime, release dates, and more
- **Offer Details**: Get pricing, quality (HD/4K), and direct URLs to streaming platforms

## Technology Stack

This server is built using:
- **[FastMCP](https://github.com/jlowin/fastmcp)**: A modern, decorator-based framework for building MCP servers with minimal boilerplate
- **[simple-justwatch-python-api](https://github.com/Electronic-Mango/simple-justwatch-python-api)**: GraphQL-based wrapper for the JustWatch API

## Installation

### Prerequisites

- Python 3.11 or higher
- pip or uv package manager

### From Release

Skip to "As an MCP Server" as a section to automatically download the package inside common MCP clients.

### From Source

1. Clone the repository:
```bash
git clone <repository-url>
cd mcp-justwatch
```

2. Install the package:
```bash
pip install -e .
```

### For Development

Install with development dependencies:
```bash
pip install -e ".[dev]"
```

## Usage

### As an MCP Server

This server is designed to be used with MCP clients. Add it to your MCP client configuration:

#### Claude Desktop Configuration

Add to your `claude_desktop_config.json` to automatically download the package at the start of the session using `uvx`.

```json
{
  "mcpServers": {
    "justwatch": {
      "command": "uvx",
      "args": ["mcp-justwatch", "python", "-m", "mcp_justwatch.server"]
    }
  }
}
```

Or if installed in a virtual environment:

```json
{
  "mcpServers": {
    "justwatch": {
      "command": "/path/to/venv/bin/python",
      "args": ["-m", "mcp_justwatch.server"]
    }
  }
}
```

#### Other MCP Hosts

See the `mcphost-config.yaml` example file for configuration with other MCP hosts.

### Self-Hosted with Docker (Dockge + Cloudflare Tunnel)

The server can run as a remote MCP server over Streamable HTTP, for use as a custom connector in Claude or ChatGPT.

1. Clone into your Dockge stacks directory (default `/opt/stacks`):
   ```bash
   git clone https://github.com/samuelzamvil/mcp-justwatch.git /opt/stacks/mcp-justwatch
   ```
2. In Dockge, open the `mcp-justwatch` stack, set the `.env` values (see `.env.example`), then click **Start**.
3. Expose it through a Cloudflare Tunnel, using either:
   - **Bundled cloudflared**: in Cloudflare Zero Trust, create a tunnel, add a public hostname with service `http://mcp-justwatch:8000`, then set `TUNNEL_TOKEN=<token>` and `COMPOSE_PROFILES=tunnel` in `.env`.
   - **Existing tunnel**: point a public hostname at `http://<docker-host-ip>:8000` (or `HOST_PORT`).
4. Add the connector in your client using `https://<your-hostname><MCP_PATH>`, e.g. `https://justwatch.example.com/mcp`:
   - Claude: Settings > Connectors > Add custom connector.
   - ChatGPT: Settings > Apps & Connectors > Advanced > Developer mode, then create a connector with no authentication.

The server has no authentication. Anyone with the URL can run JustWatch searches through it, so set `MCP_PATH` to something hard to guess (e.g. `/mcp-8f3k2q9x`).

| Variable | Default | Purpose |
| --- | --- | --- |
| `HOST_PORT` | `8000` | Port published on the Docker host |
| `MCP_PATH` | `/mcp` | URL path of the MCP endpoint |
| `TUNNEL_TOKEN` | | Cloudflare Tunnel token (bundled cloudflared only) |
| `COMPOSE_PROFILES` | | Set to `tunnel` to start the bundled cloudflared |

Outside Docker, the same mode is available with `MCP_TRANSPORT=http mcp-justwatch` (also reads `MCP_HOST`, `MCP_PORT`, `MCP_PATH`).

## Development

### Running Tests

```bash
pytest
```

### Code Formatting

Format code with Black:
```bash
black src tests
```

Lint with Ruff:
```bash
ruff check src tests
```

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## Disclaimer

This project uses the [simple-justwatch-python-api](https://github.com/Electronic-Mango/simple-justwatch-python-api), an unofficial JustWatch API wrapper. This API is in no way affiliated, associated, authorized, endorsed by, or in any way officially connected with JustWatch. This is an independent and unofficial project. Use at your own risk and discretion.
