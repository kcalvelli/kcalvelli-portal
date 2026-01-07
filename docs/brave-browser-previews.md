# Brave Browser Previews

**A Nix Flake that provides the latest Nightly and Beta versions of Brave Browser for Linux.**

[View on GitHub](https://github.com/kcalvelli/brave-browser-previews)

## Overview

This repository provides an automated way to get the latest **Brave Nightly** and **Brave Beta** builds on NixOS. It is automatically updated daily to track official Brave GitHub releases. It includes both a NixOS module for declarative configuration and standalone packages.

## Architecture

This project functions as a bridge between Brave's binary releases and the Nix ecosystem.

```mermaid
C4Component
    title Component Diagram for Brave Browser Previews

    Person(user, "User", "NixOS User")
    Component(flake, "Flake", "Nix Flake", "Provides Brave packages and modules")
    System_Ext(brave_releases, "Brave Releases", "GitHub Releases", "Source of binaries")

    Rel(user, flake, "Imports as input or runs via nix run")
    Rel(flake, brave_releases, "Fetches nightly/beta binaries daily")
```

## Onboarding

You can run the browsers directly without installation:

```bash
# Run Nightly
nix run github:kcalvelli/brave-browser-previews#brave-nightly

# Run Beta
nix run github:kcalvelli/brave-browser-previews#brave-beta
```

For NixOS installation, add it as a flake input and import the module. See the [README](https://github.com/kcalvelli/brave-browser-previews) for details.

## Release History

| Version | Date | Status |
| :--- | :--- | :--- |
| - | - | No releases found |