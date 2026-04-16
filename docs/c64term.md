# C64 Terminal

A Commodore 64 aesthetic wrapper for Ghostty + Fish — full PETSCII palette, blinking block cursor, authentic boot screen.

**Repository:** [kcalvelli/c64term](https://github.com/kcalvelli/c64term) · **Language:** Nix · **Requires:** Ghostty, Fish

## What it does

Exactly what it sounds like. C64 Terminal is a packaged preset for Ghostty and Fish that recreates the C64 look: blue background (`#3e31a2`), light-blue text (`#7c70da`), the full 16-color PETSCII palette, block cursor, and a boot-screen imitation showing your host's RAM with a "READY." prompt.

Not an emulator. Just a terminal that feels like the thing you grew up with.

## Run it

```bash
nix run github:kcalvelli/c64term
```

Or as a flake input for NixOS / home-manager:

```nix
inputs.c64term.url = "github:kcalvelli/c64term";

environment.systemPackages = [
  inputs.c64term.packages.${pkgs.stdenv.hostPlatform.system}.c64term
];
```

Launch with `c64term`.
