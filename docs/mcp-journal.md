# MCP Journal

**MCP server providing read-only access to systemd journalctl.**

[View on GitHub](https://github.com/kcalvelli/mcp-journal)

## Overview

A Model Context Protocol (MCP) server that allows AI assistants to query system logs via `journalctl` and check unit status on Linux systems. It is read-only and designed for debugging and monitoring.

## Architecture

The server wraps `journalctl` commands to expose logs to the MCP client.

```mermaid
C4Component
    title Component Diagram for MCP Journal

    System_Ext(ai, "AI Assistant", "Claude/Cursor")
    Component(mcp, "MCP Server", "Python", "Queries journalctl")
    System_Ext(journald, "systemd-journald", "System Service", "Log storage")

    Rel(ai, mcp, "Queries logs via MCP", "Stdio")
    Rel(mcp, journald, "Reads logs", "journalctl")
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