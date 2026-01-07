# axiOS Monitor

**A DMS plugin for monitoring and managing axiOS systems.**

[View on GitHub](https://github.com/kcalvelli/axios-monitor)

## Overview

A plugin for [DankMaterialShell](https://danklinux.com/) specifically designed for axiOS. It allows users to monitor system generations, check for updates, and trigger system rebuilds directly from the desktop UI.

## Architecture

The plugin integrates into the desktop shell and communicates with the underlying NixOS system.

```mermaid
C4Component
    title Component Diagram for axiOS Monitor

    Person(user, "User", "NixOS User")
    Component(plugin, "axiOS Monitor", "DankMaterialShell Plugin", "UI for system updates")
    System_Ext(nixos, "NixOS System", "OS", "Handles rebuilds")
    System_Ext(github, "GitHub", "Remote", "Checks for updates")

    Rel(user, plugin, "Interacts with")
    Rel(plugin, nixos, "Triggers rebuilds")
    Rel(plugin, github, "Checks version")
```

## Onboarding

If you are using axiOS with the desktop module enabled, this plugin is **automatically configured**.

For manual installation (on axiOS), add to your home-manager config:
```nix
programs.axios-monitor.enable = true;
```

## Release History

| Version | Date | Status |
| :--- | :--- | :--- |
| - | - | No releases found |