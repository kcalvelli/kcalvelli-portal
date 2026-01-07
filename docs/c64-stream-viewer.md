# C64 Stream Viewer

**Wayland-native viewer for Ultimate64 video/audio streaming.**

[View on GitHub](https://github.com/kcalvelli/c64-stream-viewer)

## Overview

A Python-based viewer that decodes proprietary UDP packets from the Ultimate 64 hardware. It features a custom decoder for the 4-bit VIC-II color format and provides low-latency video and audio playback on Wayland systems.

## Architecture

The application is a multi-threaded Python pipeline that processes UDP streams in real-time.

```mermaid
C4Container
    title Container Diagram for C64 Stream Viewer

    Person(user, "User", "Viewer")
    System_Ext(u64, "Ultimate 64", "Hardware", "Broadcasts UDP Stream")

    Container_Boundary(app, "Application") {
        Component(net, "Network Thread", "Python/Socket", "Receives UDP packets on ports 11000 (Video) / 11001 (Audio)")
        Component(decoder, "Packet Decoder", "Python/NumPy", "Decodes VIC-II 4-bit color & PCM audio")
        Component(renderer, "Renderer", "Pygame/SDL2", "Renders to Wayland Surface")
    }

    Rel(u64, net, "Sends UDP Stream")
    Rel(net, decoder, "Passes Raw Bytes")
    Rel(decoder, renderer, "Passes RGB Frames / Audio Samples")
    Rel(user, renderer, "Watches")
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