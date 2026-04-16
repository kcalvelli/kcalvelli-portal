# Brave Browser Previews

A Nix flake providing the latest Nightly and Beta builds of Brave Browser for `x86_64-linux`, auto-updated daily from Brave's GitHub releases.

**Repository:** [kcalvelli/brave-browser-previews](https://github.com/kcalvelli/brave-browser-previews) · **Language:** Nix

## What it does

Brave's Nightly and Beta channels aren't in nixpkgs on release day, and chasing nightly builds by hand is the exact kind of busywork Nix is supposed to prevent. This flake handles it:

- **Daily update Action** fetches the latest versions and SRI hashes directly from Brave's release API
- **Two channels:** `brave-nightly` (bleeding-edge — defaults to `--enable-features=BraveAIChatAgentProfile` for AI Agent testing) and `brave-beta`
- **Pure flake** — consume as a NixOS / home-manager input, no imperative install

A NixOS module is exported so you can configure Brave the same way you would `programs.chromium` — extensions, search provider defaults, policies.

## Run it

```nix
inputs.brave-previews = {
  url = "github:kcalvelli/brave-browser-previews";
  inputs.nixpkgs.follows = "nixpkgs";
};

# configuration.nix
imports = [ brave-previews.nixosModules.default ];

programs.brave-nightly = {
  enable = true;
  extensions = [ "cjpalhdlnbpafiamejdnhcphjbkeiagm" ]; # uBlock Origin
};
```

The update Action runs daily; the flake stays current with zero manual intervention.
