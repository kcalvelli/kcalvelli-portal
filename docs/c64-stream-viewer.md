# C64 Stream Viewer

A Wayland-native video viewer for Ultimate64 streaming. Decodes the proprietary UDP packet format the hardware uses for A/V output.

**Repository:** [kcalvelli/c64-stream-viewer](https://github.com/kcalvelli/c64-stream-viewer) · **Language:** Python · **Latest release:** v1.0.0

## What it does

The Ultimate64 mainboard broadcasts video and audio as UDP packets on the LAN. C64 Stream Viewer catches those packets, decodes the 4-bit VIC-II color format, and displays the result in a Wayland-native window. Result: you can watch the C64 from anywhere on the network, without an HDMI cable.

Specs:

- Native Wayland rendering via SDL2/pygame
- Custom packet decoder for Ultimate64's 4-bit VIC-II color format
- Real-time display at 14–17 FPS
- PAL (384×272) and NTSC (384×240) auto-detection
- Hardware-accelerated scaling
- 16-bit stereo audio at 47976 Hz

## Run it

As a flake input for system-wide install:

```nix
inputs.c64-stream-viewer.url = "github:kcalvelli/c64-stream-viewer";

environment.systemPackages = [
  inputs.c64-stream-viewer.packages.x86_64-linux.av
];
```

Or one-shot without installing:

```bash
nix run github:kcalvelli/c64-stream-viewer
```

Three package variants: `av` (video + audio), `video` (video only), `headless` (audio only).
