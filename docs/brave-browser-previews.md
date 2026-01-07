# Brave Browser Previews

**A Nix Flake that provides the latest Nightly and Beta versions of Brave Browser for Linux.**

[View on GitHub](https://github.com/kcalvelli/brave-browser-previews)

## Overview

This repository provides an automated way to get the latest **Brave Nightly** and **Brave Beta** builds on NixOS. It is automatically updated daily to track official Brave GitHub releases. It includes both a NixOS module for declarative configuration and standalone packages.

## Architecture

This project relies on GitHub Actions to automate the fetching of upstream binaries and updating of the Nix flake.

```mermaid
C4Container
    title Container Diagram for Brave Browser Previews

    System_Ext(github_actions, "GitHub Actions", "CI/CD", "Runs daily cron")
    
    Container_Boundary(repo, "Repository Context") {
        Component(script, "update.sh", "Bash Script", "Queries API & Prefetches binaries")
        Component(flake, "flake.nix", "Nix Flake", "Exports packages & modules")
        Component(json, "Version Data", "Nix Files", "Contains versions & SRI hashes")
    }

    System_Ext(brave_api, "Brave Releases", "GitHub API", "Source of upstream binaries")
    Person(user, "User", "NixOS User")

    Rel(github_actions, script, "Executes")
    Rel(script, brave_api, "Queries latest Nightly/Beta")
    Rel(script, json, "Updates hashes in")
    Rel(flake, json, "Reads versions from")
    Rel(user, flake, "Imports as input or runs via nix run")
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