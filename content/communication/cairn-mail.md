+++
title = "Cairn Mail"
description = "Self-hosted email with AI-powered classification via local LLMs."
weight = 1

[extra]
hook = "An AI-powered inbox organizer for NixOS — self-hosted, declarative, with local LLM classification. No cloud AI dependencies."
repo = "kcalvelli/cairn-mail"
language = "Python"
status = "active"
stack = "Python · Ollama · Alembic"
+++

## What it does

Cairn Mail combines direct provider integration (Gmail, IMAP) with local AI classification to automatically organize an inbox. Messages are tagged (`work`, `finance`, `personal`, `shopping`, or a user-defined taxonomy), prioritized, and filed — all on the machine running the service, with nothing leaving for cloud AI processing.

On top of classification it ships a modern split-pane web UI with threading, bulk operations, attachments, and full keyboard navigation. A mobile-optimized PWA mode with Material You icon theming on Android 13+ and touch gestures.

## Action Tags

Tag a message with a special action and an MCP tool fires: **add contact** pulls the sender into the address book, **create reminder** turns mentioned dates into calendar events. Custom actions can invoke any MCP tool. Requires [Cairn DAV](/communication/cairn-dav/) and [MCP Gateway](/ai/mcp-gateway/) to be present.

## Run it

Designed for Cairn users — the default config assumes Cairn conventions (agenix for secrets, `~/.config/nixos_config` for configuration). Non-Cairn NixOS users can adapt paths and secret management.

```nix
inputs.cairn-mail.url = "github:kcalvelli/cairn-mail";
```

See the repo's [Quick Start](https://github.com/kcalvelli/cairn-mail/blob/main/docs/QUICKSTART.md) for end-to-end setup.
