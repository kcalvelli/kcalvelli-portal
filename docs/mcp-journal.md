# MCP Journal

**MCP server providing read-only access to systemd journalctl.**

[View on GitHub](https://github.com/kcalvelli/mcp-journal)

## Overview

A Model Context Protocol (MCP) server that allows AI assistants to query system logs via `journalctl` and check unit status on Linux systems. It is read-only and designed for debugging and monitoring.

## Architecture

The server securely wraps the `journalctl` command-line tool, exposing a structured query interface to the MCP client.

```mermaid
C4Container
    title Container Diagram for MCP Journal

    System_Ext(ai, "AI Assistant", "Claude / Cursor")
    
    Container_Boundary(app, "MCP Application") {
        Component(server, "MCP Server", "Python", "Stdio Transport for JSON-RPC")
        Component(tools, "Tool Logic", "Python", "Implements logs.query, logs.tail")
        Component(security, "Security Layer", "Python", "Validates args & Enforces Allowlist")
    }

    System_Ext(systemd, "systemd", "OS Service", "journalctl / systemctl")

    Rel(ai, server, "Queries logs via MCP")
    Rel(server, tools, "Dispatches request")
    Rel(tools, security, "Checks constraints")
    Rel(security, systemd, "Executes subprocess (journalctl)")
    Rel(systemd, tools, "Returns JSON logs")
```

## Onboarding

To run the server:

```bash
python3 src/mcp_journal.py
```

Or using Nix:

```bash
nix run github:kcalvelli/mcp-journal
```

## Release History

| Version | Date | Status |
| :--- | :--- | :--- |
| - | - | No releases found |