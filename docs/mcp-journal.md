# MCP Journal

**Repo:** [kcalvelli/mcp-journal](https://github.com/kcalvelli/mcp-journal)

An MCP server that provides read-only access to `journalctl`. This enables AI agents to debug system issues by reading system logs safely.

## Architecture

```mermaid
graph LR
    subgraph AI Client
        Claude[Claude / Cursor]
    end

    subgraph System
        MJ[mcp-journal]
        JCTL[journalctl]
        Logs[System Logs]
    end

    Claude <-->|MCP Protocol| MJ
    MJ -->|Exec| JCTL
    JCTL -->|Read| Logs
```

## Onboarding

Run the server:

```bash
nix run github:kcalvelli/mcp-journal
```

**Security Note:** The server needs permission to read logs (usually requires user to be in `systemd-journal` group).

## Latest Status

**Release:** *Rolling*
