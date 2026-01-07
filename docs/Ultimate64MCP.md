# Ultimate64 MCP

**MCP server for the Ultimate 64 series mainboards and cartridges.**

[View on GitHub](https://github.com/kcalvelli/Ultimate64MCP)

## Overview

A **Model Context Protocol (MCP)** server that enables AI assistants like Claude to control the Commodore 64 Ultimate hardware. It allows loading programs, managing disks, reading memory, and controlling the device via natural language.

## Architecture

The server translates MCP protocol requests into REST API calls understood by the Ultimate 64 hardware.

```mermaid
C4Container
    title Container Diagram for Ultimate64 MCP

    System_Ext(ai, "AI Assistant", "Claude / Cursor / IDE")
    System_Ext(u64, "Ultimate 64", "Hardware", "Exposes REST API Endpoint")

    Container_Boundary(server, "MCP Server (Docker/Python)") {
        Component(transport, "Transport Layer", "Stdio / SSE", "Handles JSON-RPC messages")
        Component(router, "Tool Router", "Python", "Maps tool names (e.g., ultimate_load_disk) to functions")
        Component(api_client, "API Client", "Python requests", "Translates to U64 REST calls")
    }

    Rel(ai, transport, "Sends Tools Calls (JSON-RPC)")
    Rel(transport, router, "Parses Request")
    Rel(router, api_client, "Invokes Logic")
    Rel(api_client, u64, "HTTP GET/POST /v1/...")
```

## Onboarding

You can run the server via Python or Docker.

**Python:**
```bash
git clone https://github.com/kcalvelli/Ultimate64MCP.git
cd Ultimate64MCP/mcp_hosted
pip install -r requirements.txt
python mcp_ultimate_server.py
```

**Docker:**
```bash
docker run -p 8000:8000 -e C64_HOST=192.168.1.64 ultimate64-mcp
```

## Release History

| Version | Date | Status |
| :--- | :--- | :--- |
| - | - | No releases found |