# axiOS AI Chat

Family XMPP chat with AI assistant for the axios ecosystem.

## Overview

A family-oriented XMPP chat system with an integrated AI assistant, designed for the axios ecosystem. Like a private AIM, but only accessible within your Tailscale network, with an AI bot that can manage email, calendar, contacts, and more through MCP tools.

**Repository:** [kcalvelli/axios-ai-chat](https://github.com/kcalvelli/axios-ai-chat)

## Architecture

```mermaid
C4Component
    title axiOS AI Chat - Component Diagram

    Container_Boundary(tailnet, "Tailscale Network") {
        Component(clients, "XMPP Clients", "Conversations/Gajim/Dino", "Native chat applications")
        Component(prosody, "Prosody Server", "XMPP Server", "Message routing and presence")
        Component(bot, "axios-ai-bot", "Python", "AI assistant with intent routing")
    }

    System_Ext(claude, "Claude API", "LLM for natural language")
    System_Ext(gateway, "mcp-gateway", "Tool execution endpoint")

    Rel(clients, prosody, "XMPP", "Messages")
    Rel(prosody, bot, "XMPP", "@ai mentions")
    Rel(bot, claude, "API calls", "HTTPS")
    Rel(bot, gateway, "Tool execution", "HTTP/MCP")

    UpdateElementStyle(bot, $bgColor="#1168bd")
```

**Key Features:**
- **Private Family Messenger** - Accessible only within your Tailscale network
- **AI Assistant** - Chat with `@ai` to manage email, calendar, contacts
- **Native Clients** - Works with Conversations (Android), Gajim (Windows/Linux), Dino (Linux)
- **Dynamic Tool Discovery** - New MCP servers added to mcp-gateway are automatically available
- **Cost-Optimized** - Uses Haiku for intent classification, Sonnet for tool execution

## Onboarding

### Prerequisites
- NixOS with flakes enabled
- Tailscale configured
- mcp-gateway running

### Installation

Add to your `flake.nix`:

```nix
{
  inputs.axios-chat.url = "github:kcalvelli/axios-chat";

  outputs = { self, nixpkgs, axios-chat, ... }: {
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [
        axios-chat.nixosModules.default
        ./configuration.nix
      ];
    };
  };
}
```

### Configuration

```nix
services.axios-chat = {
  prosody = {
    enable = true;
    domain = "chat.home.ts.net";
    tailscaleIP = "100.64.0.1";
  };
  bot = {
    enable = true;
    xmppDomain = "chat.home.ts.net";
    xmppPasswordFile = config.age.secrets.ai-bot-password.path;
    anthropicKeyFile = config.age.secrets.anthropic-key.path;
    mcpGatewayUrl = "http://localhost:8085";
  };
};
```

## Release History

No releases yet.
