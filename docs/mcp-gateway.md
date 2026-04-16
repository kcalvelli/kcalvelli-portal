# MCP Gateway

Universal MCP Gateway — aggregates multiple Model Context Protocol servers behind a single HTTP interface.

**Repository:** [kcalvelli/mcp-gateway](https://github.com/kcalvelli/mcp-gateway) · **Language:** Python (FastAPI)

## What it does

MCP Gateway collapses the "one MCP server per capability" problem into a single aggregation layer. Multiple stdio-based MCP servers — git, filesystem, GitHub, time, search, email, calendar — sit behind the gateway; clients talk to one HTTP endpoint and get access to all of them.

Three transports on one process:

- **REST API** for traditional HTTP tool calls
- **MCP HTTP Transport** — native MCP protocol over HTTP+SSE, 2025-06-18 spec
- **Dynamic OpenAPI** — per-tool endpoints generated at runtime for Open WebUI integration

A Web UI gives a visual orchestrator for managing servers and inspecting tools. Everything is declarative: NixOS and home-manager modules define which servers run, with what arguments, and what secrets they receive.

## Security model

No application-level authentication. Network security is provided by **Tailscale Services** — only devices on the tailnet can reach the gateway, and Tailscale provides device identity and end-to-end encryption. This is a deliberate choice: MCP is a high-trust protocol, and rebuilding auth at the application layer when the network already has it is noise.

## Architecture

See the [Gateway Components view](diagrams/gateway-components.svg) for the internal structure, and the [Cairn Containers view](diagrams/cairn-containers.svg) for how Gateway sits between clients (Companion, Open WebUI, Claude) and the proxied servers (Mail, DAV, Sentinel, Ultimate64 MCP, etc.).

## Run it

```nix
# flake.nix
inputs.mcp-gateway.url = "github:kcalvelli/mcp-gateway";

# home-manager
{
  imports = [ mcp-gateway.homeManagerModules.default ];

  services.mcp-gateway = {
    enable = true;
    autoEnable = [ "github" "time" ];
    servers.github = {
      enable = true;
      command = "${pkgs.github-mcp-server}/bin/github-mcp-server";
      args = [ "stdio" ];
    };
  };
}
```

Additional servers are one more `servers.<name> = { ... }` block each.
