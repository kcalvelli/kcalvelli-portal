+++
title = "Cairn"
description = "A modular NixOS distribution — the platform everything else runs on."
weight = 1

[extra]
hook = "A modular NixOS framework for building reproducible systems with Home Manager, modern desktops, and curated development tools."
repo = "kcalvelli/cairn"
language = "Nix"
status = "released"
stack = "Nix · NixOS · home-manager"
featured = true
highlight = "Declarative NixOS framework with 14 releases, running a multi-machine fleet daily."
+++

## What it does

Cairn is a NixOS framework and library you import into your own flake to build NixOS configurations. Think of it as a curated collection of modules, packages, and home-manager configs that work together. You maintain ~30 lines of your own Nix; Cairn provides everything else — desktop environment, development tools, system configuration.

It ships **per-user home profiles** so the same system can host a power-user tiling workflow for one account and a mouse-driven ChromeOS-like desktop for another. Both share the visual theme, PWA catalog, media stack, and Flatpak support; the desktop ergonomics differ per user.

## Architecture

Cairn's place in the broader ecosystem is shown in the [Cairn Containers view](/diagrams/cairn-containers.svg). It's the platform other Cairn-prefixed projects (Monitor, Mail, DAV, Chat, Companion, Gateway, Sentinel) extend via NixOS and home-manager modules.

## Run it

Fresh NixOS install:

```bash
bash <(curl -sL https://raw.githubusercontent.com/kcalvelli/cairn/master/scripts/install.sh)
```

Flakes already enabled:

```bash
nix run --refresh github:kcalvelli/cairn#init
```

The installer offers three modes: scripted setup, add-host to an existing Cairn config, or AI-assisted configuration with Claude Code. Full instructions in [docs/INSTALLATION.md](https://github.com/kcalvelli/cairn/blob/master/docs/INSTALLATION.md).
