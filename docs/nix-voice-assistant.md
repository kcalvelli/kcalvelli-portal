# Nix Voice Assistant

NixOS package and module for [OHF-Voice/linux-voice-assistant](https://github.com/OHF-Voice/linux-voice-assistant) — a voice satellite that speaks ESPHome protocol to Home Assistant.

**Repository:** [kcalvelli/nix-voice-assistant](https://github.com/kcalvelli/nix-voice-assistant) · **Language:** Nix · **Platforms:** x86_64-linux, aarch64-linux (Raspberry Pi)

## What it does

linux-voice-assistant is an all-in-one voice satellite that replaces the two-service Wyoming stack (wyoming-satellite + wyoming-openwakeword) with a single process. This flake packages it for NixOS, with a module that handles PipeWire integration, mDNS auto-discovery, and firewall opening.

What you get in one service:

- Local wake word detection (OpenWakeWord + MicroWakeWord)
- Audio capture and playback via PipeWire/PulseAudio
- ESPHome protocol for Home Assistant auto-discovery
- Timers, media playback, volume control, mute

## Run it

```nix
# flake.nix
inputs.linux-voice-assistant.url = "github:kcalvelli/nix-voice-assistant";

# configuration.nix
{
  imports = [ inputs.linux-voice-assistant.nixosModules.default ];

  services.linux-voice-assistant = {
    enable = true;
    user = "youruser";
    openFirewall = true;
  };
}
```

Home Assistant auto-discovers the device via its ESPHome integration. No manual entry needed.
