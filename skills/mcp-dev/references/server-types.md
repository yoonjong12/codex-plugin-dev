# MCP Server Types

## stdio (Local Process)

Launches a local process, communicates via stdin/stdout.

```json
{
  "my-server": {
    "command": "my-mcp-server",
    "args": ["--stdio"],
    "env": {
      "API_KEY": "${API_KEY}"
    }
  }
}
```

Best for: local CLI tools, language servers, file-based tools.

## SSE (Server-Sent Events)

Connects to a remote server using HTTP with SSE for streaming.

```json
{
  "remote-server": {
    "url": "https://mcp.example.com/sse"
  }
}
```

Best for: hosted services with real-time streaming, cloud APIs.

## HTTP (Request/Response)

Simple HTTP endpoint for synchronous tool calls.

```json
{
  "api-server": {
    "url": "https://api.example.com/mcp"
  }
}
```

Best for: simple REST-like tool endpoints, serverless functions.

## Authentication

For servers requiring authentication, use environment variables:

```json
{
  "authenticated-server": {
    "command": "server-binary",
    "args": ["--stdio"],
    "env": {
      "AUTH_TOKEN": "${MY_SERVICE_TOKEN}"
    }
  }
}
```

Never hardcode secrets in `.mcp.json`. Use environment variable references.
