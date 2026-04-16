# Cairn Monitor

A [DankMaterialShell](https://danklinux.com/) plugin for monitoring Cairn systems with integrated rebuild and update-tracking capabilities.

**Repository:** [kcalvelli/cairn-monitor](https://github.com/kcalvelli/cairn-monitor) · **Language:** QML · **Fork of:** [antonjah/nix-monitor](https://github.com/antonjah/nix-monitor)

## What it does

Cairn Monitor is a desktop widget — a DMS plugin — that lives in the shell's bar and gives you operational visibility into a Cairn host without leaving the desktop:

- **Generation count** — total NixOS system generations
- **Store size** — current Nix store disk usage with configurable warning threshold
- **Update status** — checks Cairn's flake for available updates; icon turns green/yellow/red accordingly
- **Detailed popout** — click the widget for a panel with summary cards, real-time command output console, and action buttons

The action buttons let you run `nixos-rebuild switch`, `nixos-rebuild boot`, or `nix-collect-garbage` directly from the desktop, without a terminal.

## Cairn-specific

This is a fork of [nix-monitor](https://github.com/antonjah/nix-monitor), heavily modified for Cairn. It expects Cairn as a flake input, uses Cairn's module structure, and tracks Cairn's library version instead of nixpkgs. **It won't work correctly on non-Cairn systems.** For general NixOS monitoring, use the upstream project. All credit for the original implementation to Anton Andersson.

## Run it

If you're using Cairn with the desktop module enabled (`modules.desktop = true`), this plugin is already installed and configured — no additional setup. Rebuild and the widget appears in DMS.
