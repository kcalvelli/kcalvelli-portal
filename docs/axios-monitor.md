# axiOS Monitor

**A DMS plugin for monitoring and managing axiOS systems.**

[View on GitHub](https://github.com/kcalvelli/axios-monitor)

## Overview

A plugin for [DankMaterialShell](https://danklinux.com/) specifically designed for axiOS. It allows users to monitor system generations, check for updates, and trigger system rebuilds directly from the desktop UI.

## Architecture

The plugin acts as a frontend for system management tasks, interacting with the Nix store and system rebuild commands.

```mermaid
C4Container
    title Container Diagram for axiOS Monitor

    Person(user, "User", "Desktop User")
    
    Container_Boundary(dms, "DankMaterialShell (Desktop)") {
        Component(widget, "Status Widget", "QML", "Displays icons & stats in panel")
        Component(popup, "Detail Popup", "QML", "Shows logs, version info & action buttons")
    }

    Container_Boundary(system, "System Context") {
        Component(scripts, "Helper Scripts", "Bash", "Parses flake.lock, checks updates")
        Component(nixos, "NixOS Rebuild", "System Command", "nixos-rebuild switch/boot")
        Component(store, "Nix Store", "Filesystem", "Checks usage size")
    }

    Rel(user, widget, "Views status")
    Rel(user, popup, "Clicks Rebuild / Update")
    Rel(widget, scripts, "Polls status")
    Rel(popup, nixos, "Executes rebuild")
    Rel(scripts, store, "Reads size")
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