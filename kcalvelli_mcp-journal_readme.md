# MCP Journal Server

A Model Context Protocol (MCP) server providing read-only access to systemd journalctl.

**Linux-only** - Requires systemd and journalctl.

[![Status](https://img.shields.io/badge/status-working%20MVP-brightgreen)]()
[![Tests](https://img.shields.io/badge/tests-9%2F9%20passing-brightgreen)]()
[![Python](https://img.shields.io/badge/python-3.8%2B-blue)]()
[![Platform](https://img.shields.io/badge/platform-Linux-blue)]()

## Overview

This MCP server exposes three tools for querying systemd journal logs and unit status:

- **logs.query** - Flexible journal queries with filtering
- **logs.tail** - Recent logs (last 1 minute)
- **units.status** - Systemd unit status (allowlist-protected)

Perfect for AI assistants to help debug system issues, analyze logs, and monitor services on Linux systems.

## Quick Start

```bash
# Run the server
python3 src/mcp_journal.py

# Run tests
python3 TESTS/acceptance_harness.py
```

## Requirements

- **Linux system with systemd** (Ubuntu, Fedora, Arch, NixOS, etc.)
- Python 3.8+
- User in `systemd-journal` group

**Note:** This tool requires systemd and journalctl, which are Linux-only.

## Usage with MCP Clients

### Cline (VSCode Extension)

This is the recommended MCP client for Linux.

1. Install [Cline extension](https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev) in VSCode
2. Open Cline settings and add MCP server:

```json
{
  "mcpServers": {
    "journal": {
      "command": "python3",
      "args": ["/absolute/path/to/mcp-journal/src/mcp_journal.py"]
    }
  }
}
```

**For NixOS users:**
```json
{
  "mcpServers": {
    "journal": {
      "command": "nix",
      "args": ["run", "github:kcalvelli/mcp-journal"]
    }
  }
}
```

### MCP Inspector (Testing)

```bash
# Install MCP Inspector
npm install -g @modelcontextprotocol/inspector

# Test the server
mcp-inspector python3 src/mcp_journal.py
```

### Using the Server

Once configured, ask:
- "Show me the last 20 nginx error logs"
- "What's the status of my SSH service?"
- "Find all logs from the last hour matching 'timeout'"

## Example Queries

```bash
# Get last 10 journal entries
echo '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"logs.query","arguments":{"limit":10}}}' | \
    python3 src/mcp_journal.py 2>/dev/null | jq .

# Tail nginx logs
echo '{"jsonrpc":"2.0","id":2,"method":"tools/call","params":{"name":"logs.tail","arguments":{"unit":"nginx.service"}}}' | \
    python3 src/mcp_journal.py 2>/dev/null | jq .

# Check systemd-journald status
echo '{"jsonrpc":"2.0","id":3,"method":"tools/call","params":{"name":"units.status","arguments":{"unit":"systemd-journald.service"}}}' | \
    python3 src/mcp_journal.py 2>/dev/null | jq .
```

## Architecture

```
MCP Client (Claude) → stdio → mcp_journal.py → journalctl/systemctl
```

See `IMPLEMENTATION.md` for detailed architecture.

## Security

- ✅ Read-only (no system modifications)
- ✅ Runs as invoking user (no privilege escalation)
- ✅ Allowlist for units.status (prevents enumeration)
- ✅ Resource limits (max 2000 entries, 30s timeout)
- ✅ No shell injection (uses subprocess argv arrays)

See `SPECS/08-security.md` for full threat model.

## Testing

```bash
# Full acceptance suite (9 tests)
python3 TESTS/acceptance_harness.py

# Quick smoke tests
bash TESTS/smoke-test.sh
```

All tests passing ✅

## Documentation

- **[IMPLEMENTATION.md](IMPLEMENTATION.md)** - Implementation details and usage
- **[PLAN.md](PLAN.md)** - Full implementation plan (8 phases, 73 tasks)
- **[TASKS.md](TASKS.md)** - Detailed task tracking
- **[SPECS/](SPECS/)** - Complete specifications (9 documents, 1872 lines)
  - 01-constitution.md - Core constraints
  - 02-architecture.md - System design
  - 03-cli.md - Command-line interface
  - 04-tools.md - Tool specifications
  - 05-interface.mcp.json - MCP interface (canonical)
  - 06-data-schemas.json - Field mappings
  - 07-testing.md - Test strategy
  - 08-security.md - Security model
  - 09-nix.md - Nix packaging

## Project Status

### ✅ Completed (MVP)

- [x] Python MCP server implementation (543 lines)
- [x] All 3 tools: logs.query, logs.tail, units.status
- [x] Field mapping per specification
- [x] Allowlist enforcement
- [x] Acceptance test harness (9 tests)
- [x] Smoke tests
- [x] Complete specifications (9 docs)
- [x] Implementation plan (8 phases)

### 🚧 In Progress

- [ ] `--allow-units` CLI flag
- [ ] Nix packaging (flake.nix)
- [ ] Unit tests with mocks

### 📋 Planned

- [ ] Rate limiting (v1.1)
- [ ] Field-level redaction (v1.1)
- [ ] CI/CD workflows
- [ ] PyPI publishing (optional)

See `TASKS.md` for complete task breakdown (73 tasks across 8 phases).

## Contributing

See `CONTRIBUTING.md` (to be created) for development setup.

To get started:

```bash
git clone <repo>
cd mcp-journal
python3 TESTS/acceptance_harness.py  # Run tests
```

## License

MIT License - see [LICENSE](LICENSE) file for details

## Links

- MCP Protocol: https://modelcontextprotocol.io
- Cline VSCode Extension: https://marketplace.visualstudio.com/items?itemName=saoudrizwan.claude-dev
- systemd: https://systemd.io
- journalctl: https://man.archlinux.org/man/journalctl.1

---

**Built with ❤️ for the MCP ecosystem**
