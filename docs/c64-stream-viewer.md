# C64 Stream Viewer

**Repo:** [kcalvelli/c64-stream-viewer](https://github.com/kcalvelli/c64-stream-viewer)

A Wayland-native video and audio viewer for the Ultimate64 Commodore 64 implementation. It decodes proprietary UDP streams to display C64 video and audio on your modern desktop.

## Architecture

```mermaid
graph TD
    subgraph Hardware
        U64[Ultimate64 Device]
    end

    subgraph Host Machine
        subgraph App
            CSV[c64-stream-viewer]
            PyAudio[PyAudio/PortAudio]
            SDL[SDL2 / PyGame]
        end
        Wayland[Wayland Compositor]
    end

    U64 -->|UDP 11000 Video| CSV
    U64 -->|UDP 11001 Audio| CSV
    CSV -->|TCP 64 Control| U64
    
    CSV -->|Audio| PyAudio
    CSV -->|Video| SDL
    SDL --> Wayland
```

## Onboarding

**Try without installing:**
```bash
nix run github:kcalvelli/c64-stream-viewer#av
```

**Variants:**
- `#av`: Audio + Video (Recommended)
- `#video`: Video only
- `#headless`: Stats only

## Latest Status

**Version:** v1.0.0  
**Published:** 2025-12-31

**Features:**
- Native Wayland rendering
- Perfect audio quality (47976 Hz)
- Packet loss detection
