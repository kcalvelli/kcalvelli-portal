+++
title = "Cairn Sentinel"
description = "Autonomous system operations and monitoring for NixOS hosts over Tailscale."
weight = 3

[extra]
hook = "Autonomous system operations and monitoring for NixOS hosts over Tailscale."
repo = "kcalvelli/cairn-sentinel"
language = "Rust"
status = "active"
stack = "Rust · Tailscale · MCP"
featured = true
highlight = "Fleet-wide monitoring and remote ops for NixOS machines, glued together by Tailscale and exposed to AI agents via MCP."
+++

## What it does

Cairn Sentinel is the operations layer for a Cairn fleet. It watches every NixOS host over a Tailnet and exposes what it sees — service health, host telemetry, disk pressure, temperatures, GPU state, fleet-wide health checks — as MCP tools. AI agents (and humans) can query fleet state and take remote actions (restart a service, reboot a host) through a single authenticated entry point.

The problem it solves: operating a multi-machine Linux fleet without a heavyweight orchestrator. Tailscale is already the network layer; Sentinel adds the control plane.

## Capabilities

- **Read-side:** `list_hosts`, `query_host`, `host_disk`, `host_gpu`, `host_temperatures`, `system_status`, `view_logs`, `check_fleet_health`
- **Write-side:** `restart_service`, `reboot_host`
- **Transport:** MCP over HTTP, routed through [MCP Gateway](/ai/mcp-gateway/) for authenticated remote access

## Architecture

Sentinel runs as a user-level service on a designated fleet-ops host. It discovers peers via Tailscale, queries each host's systemd journal and telemetry over the Tailnet, and aggregates results. Agents call Sentinel tools via MCP Gateway, which proxies to Sentinel's MCP endpoint.

See the [deployment view](/diagrams/cairn-deployment.svg) for how Sentinel sits in a reference fleet topology.

## Run it

Sentinel is NixOS-flake-packaged. Add as an input and enable the home-manager module on whichever host should be the ops hub.

```nix
inputs.cairn-sentinel.url = "github:kcalvelli/cairn-sentinel";
```

Status: actively developed. See the repo for the current capability set.
