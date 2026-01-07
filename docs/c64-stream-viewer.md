# C64 Stream Viewer

**Wayland-native viewer for Ultimate64 video/audio streaming.**

[View on GitHub](https://github.com/kcalvelli/c64-stream-viewer)

## Overview

A Python-based viewer that decodes proprietary UDP packets from the Ultimate 64 hardware. It features a custom decoder for the 4-bit VIC-II color format and provides low-latency video and audio playback on Wayland systems.

## Architecture

The application listens for UDP packets from the Ultimate 64 and renders them using Pygame/SDL2.

```mermaid
C4Component
    title Component Diagram for C64 Stream Viewer

    Person(user, "User", "Viewer")
    Component(viewer, "Stream Viewer", "Python/Pygame", "Decodes and displays video/audio")
    System_Ext(u64, "Ultimate 64", "Hardware", "Streams UDP packets")

    Rel(user, viewer, "Views stream")
    Rel(u64, viewer, "Sends Video/Audio Packets", "UDP")
```

## Onboarding

To run the complete A/V viewer directly:

```bash
nix run github:kcalvelli/c64-stream-viewer#av
```

See the [README](https://github.com/kcalvelli/c64-stream-viewer) for installation and other modes (video-only, headless).

## Release History

| Version | Date | Status |
| :--- | :--- | :--- |
| v1.0.0 | 2025-12-31 | ✅ Latest |