# Ultimate64 MCP

A Model Context Protocol server that lets AI assistants control a real Commodore 64 through the [Ultimate64](https://ultimate64.com/) hardware's REST API.

**Repository:** [kcalvelli/Ultimate64MCP](https://github.com/kcalvelli/Ultimate64MCP) · **Language:** Python · **Status:** Alpha

## What it does

The Commodore 64 Ultimate is a real Commodore 64 — cycle-accurate FPGA hardware from Gideon's Logic, not an emulator — with USB, ethernet, HDMI, and a REST API for remote control. This MCP server bridges that REST API into MCP tools, so Claude, ChatGPT, Cursor, or any MCP-speaking agent can:

- Load and run programs (PRG, SID, MOD)
- Read and write C64 memory directly
- Mount and create disk images (D64, D71, D81)
- Control drive emulation
- Manage device configuration
- Stream audio and video (Ultimate 64 mainboards only)

37 tools covering the full Ultimate device API. Also works with the **Ultimate 64** mainboard and **Ultimate II+** cartridge — all three share the same REST API.

## Transports

Dual-mode transport: STDIO for local Claude Code / Desktop, SSE for remote/hosted deployments. Docker image available for containerized deployment with non-root defaults.

## Run it

```bash
nix run github:kcalvelli/Ultimate64MCP
```

Or via MCP Gateway for authenticated tailnet access.
