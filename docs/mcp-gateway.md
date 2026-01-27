# MCP Gateway

Universal MCP Gateway - Aggregates MCP servers with REST, MCP HTTP transport, and OAuth2 authentication.

## Overview

MCP Gateway aggregates multiple MCP (Model Context Protocol) servers behind a single interface, providing REST API access, native MCP HTTP transport support, and dynamic OpenAPI generation for tool integration.

**Repository:** [kcalvelli/mcp-gateway](https://github.com/kcalvelli/mcp-gateway)

## Architecture

```mermaid
C4Component
    title MCP Gateway - Component Diagram

    Container_Boundary(gateway, "MCP Gateway") {
        Component(rest, "REST API", "FastAPI", "Tool management and execution")
        Component(mcp, "MCP Transport", "HTTP", "Native MCP protocol (2025-06-18)")
        Component(openapi, "Dynamic OpenAPI", "JSON", "Per-tool endpoints for Open WebUI")
        Component(ui, "Web UI", "HTML/JS", "Visual orchestrator")
    }

    System_Ext(servers, "MCP Servers", "git, github, filesystem, etc.")
    System_Ext(clients, "AI Clients", "Claude Code, Open WebUI, etc.")
    System_Ext(tailscale, "Tailscale", "Network security")

    Rel(clients, rest, "HTTP", "Tool calls")
    Rel(clients, mcp, "MCP HTTP", "Native protocol")
    Rel(gateway, servers, "stdio", "Server communication")
    Rel(tailscale, gateway, "Secures", "Network access")

    UpdateElementStyle(gateway, $bgColor="#1168bd")
```

**Key Features:**
- **REST API** - Tool management and execution via HTTP
- **MCP HTTP Transport** - Native MCP protocol support (2025-06-18 spec)
- **Dynamic OpenAPI** - Per-tool endpoints for Open WebUI integration
- **Web UI** - Visual orchestrator for managing servers and tools
- **Declarative Config** - NixOS/home-manager modules for server configuration
- **Tailscale Integration** - Network-level security via Tailscale Services

## Onboarding

### Installation

Add to your `flake.nix`:

```nix
{
  inputs.mcp-gateway.url = "github:kcalvelli/mcp-gateway";

  outputs = { self, nixpkgs, mcp-gateway, ... }: {
    nixpkgs.overlays = [ mcp-gateway.overlays.default ];

    home-manager.users.youruser = {
      imports = [ mcp-gateway.homeManagerModules.default ];

      services.mcp-gateway = {
        enable = true;
        autoEnable = [ "git" "github" ];
        servers = {
          git = {
            enable = true;
            command = "${pkgs.mcp-server-git}/bin/mcp-server-git";
          };
        };
      };
    };
  };
}
```

### API Endpoints

| Endpoint | Description |
|----------|-------------|
| `GET /api/servers` | List all configured servers |
| `GET /api/tools` | List all available tools |
| `POST /api/tools/{server}/{tool}` | Execute a tool |

## Release History

No releases yet.
