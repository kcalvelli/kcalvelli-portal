+++
title = "Cairn DAV"
description = "Declarative CalDAV/CardDAV sync for NixOS with MCP integration."
weight = 2

[extra]
hook = "Declarative CalDAV/CardDAV synchronization for NixOS with MCP integration — calendars, contacts, and AI read/write access in one module."
repo = "kcalvelli/cairn-dav"
language = "Python"
status = "active"
stack = "Python · vdirsyncer · khal · khard · MCP"
+++

## What it does

Cairn DAV gives NixOS first-class, declarative calendar and contact sync. Everything's in Nix — no manual config files, no copy-paste OAuth dance. Providers supported:

- **Google Calendar & Contacts** — OAuth handled declaratively
- **CalDAV/CardDAV** — any standard provider (Fastmail, Nextcloud, iCloud)
- **HTTP/ICS subscriptions** — read-only feeds for holidays, sports, liturgical calendars

On top of the sync layer sits an **MCP server**: AI agents can read events, create new ones, and search contacts. That's the seam where [Cairn Mail](@/communication/cairn-mail.md)'s "create reminder from this email" action tag actually fires.

Works standalone or as part of the Cairn ecosystem.

## Run it

```nix
inputs.cairn-dav.url = "github:kcalvelli/cairn-dav";

# configuration.nix
{
  imports = [ inputs.cairn-dav.nixosModules.default ];

  services.pim.calendar = {
    enable = true;
    defaultCalendar = "Family";
    accounts.google = {
      type = "google";
      tokenFile = "/home/you/.vdirsyncer/google_token.json";
      clientId = "your-client-id.apps.googleusercontent.com";
      clientSecretFile = "/run/agenix/google-client-secret";
    };
    sync = {
      frequency = "5m";
      conflictResolution = "remote";
    };
  };
}
```

The home-manager companion module reads the same `services.pim.*` config and generates the vdirsyncer / khal / khard configs on the user side.
