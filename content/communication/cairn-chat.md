+++
title = "Cairn Chat"
description = "A Prosody XMPP server packaged as a NixOS module, scoped to a Tailscale tailnet."
weight = 3

[extra]
hook = "A Prosody XMPP server packaged as a NixOS module, scoped to a Tailscale tailnet — never publicly exposed."
repo = "kcalvelli/cairn-chat"
language = "Nix"
status = "active"
stack = "Nix · Prosody · XMPP · Tailscale"
+++

## What it does

Cairn Chat runs a Prosody XMPP server bound exclusively to the tailnet: no public DNS, no public ports, no account system outside the tailnet's device identity. Multi-user chat via MUC (XEP-0045), file sharing via HTTP File Upload (XEP-0363), message archive with offline delivery via MAM.

Works with any XMPP client: Conversations on Android, Gajim, Dino on Linux, or an AI assistant connecting as a native XMPP client. The chat is also one of the channel adapters for [Cairn Companion](/ai/cairn-companion/) — the agent can participate in the same MUCs as other users.

## Why XMPP

Federation-capable, self-hostable, battle-tested, no accounts managed by a vendor. Combined with Tailscale, the auth story reduces to "is this device on the tailnet?" — no passwords to leak, no breach surface.

## Run it

```nix
inputs.cairn-chat.url = "github:kcalvelli/cairn-chat";

# configuration.nix
{
  imports = [ cairn-chat.nixosModules.default ];

  services.cairn-chat.prosody = {
    enable = true;
    domain = "chat.home.ts.net";
    tailscaleServe.enable = true;
    admins = [ "admin@chat.home.ts.net" ];

    muc.enable = true;
    httpFileShare.enable = true;
    messageArchive.enable = true;
  };
}
```
