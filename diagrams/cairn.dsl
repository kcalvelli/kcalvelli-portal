// Structurizr DSL — the Cairn ecosystem model.
// One workspace, many views. Render via:
//   structurizr-cli export -workspace cairn.dsl -format mermaid
//   structurizr-cli export -workspace cairn.dsl -format plantuml
//
// NOTE (Sid, 2026-04-16): This is a first-pass spike. Relationships marked
// with "TODO" need Keith's review — I'm inferring some based on operating
// context, not fresh code reads.

workspace "Cairn" "Modular NixOS platform and AI infrastructure for a self-hosted fleet" {

    model {

        // === People ===
        operator = person "Operator"      "Platform maintainer and admin"
        users    = person "Household Users" "Non-admin users of the deployment"

        // === External systems ===
        claude = softwareSystem "Claude (Anthropic)" "External LLM API" {
            tags "External"
        }
        ollama = softwareSystem "Ollama" "Local LLM runtime — external service" {
            tags "External"
        }
        hass = softwareSystem "Home Assistant" "Home automation hub — external" {
            tags "External"
        }
        u64 = softwareSystem "Ultimate 64" "Commodore 64 hardware — external" {
            tags "External Hardware"
        }
        tailscale = softwareSystem "Tailscale" "Mesh VPN — external" {
            tags "External"
        }

        // === Cairn — the platform ===
        cairn = softwareSystem "Cairn" "Modular NixOS distribution and AI infrastructure" {

            nixCore = container "Cairn Core" "Flake-based NixOS modules, home-manager, overlays" "Nix"
            monitor = container "Cairn Monitor" "Desktop widget for NixOS system status" "QML / KDE / DMS"

            companion = container "Cairn Companion" "Customizable persona wrapper around Claude Code" "Rust" {
                companionCore    = component "Companion Core"   "Persona, memory, conversation loop"
                companionTools   = component "User-scope Tools" "journal, notify, clipboard, screenshot, apps"
                companionMcp     = component "MCP Client"       "Connects to MCP Gateway for remote tools"
            }

            sentinel = container "Cairn Sentinel" "Fleet monitoring and remote ops over Tailscale" "Rust"

            gateway = container "MCP Gateway" "Aggregates MCP servers behind REST, MCP HTTP, OAuth2" "Python / FastAPI" {
                gatewayRest     = component "REST API"            "Tool management and execution"
                gatewayMcpHttp  = component "MCP HTTP Transport"  "Native MCP protocol over HTTP+SSE"
                gatewayOpenapi  = component "Dynamic OpenAPI"     "Per-tool endpoints for Open WebUI"
                gatewayUi       = component "Web UI"              "Visual orchestrator"
                gatewayAuth     = component "OAuth2"              "Auth for remote clients"
            }

            mail = container "Cairn Mail" "AI-classified email with local LLMs" "Python + Alembic / SQLite"
            dav  = container "Cairn DAV"  "Declarative CalDAV / CardDAV sync with MCP" "Python + vdirsyncer"
            chat = container "Cairn Chat" "Multi-user XMPP chat with AI assistant" "Python / slixmpp"
        }

        // === Retro Computing ===
        retro = softwareSystem "Retro Computing Tools" "Commodore 64 bridge to modern Linux" {
            u64mcp       = container "Ultimate64 MCP"  "MCP bridge to U64 REST API" "Python"
            streamViewer = container "C64 Stream Viewer" "UDP A/V stream viewer"      "Python / GStreamer / Wayland"
            c64term      = container "C64 Terminal"      "C64-aesthetic terminal"      "Nix"
        }

        // === Adjacent / Standalone ===
        sidAssistant = softwareSystem "Sid Assistant" "Local-first HA conversation agent" {
            tags "Adjacent"
        }

        // === Relationships — People → Systems ===
        operator -> companion    "Codes and chats via"
        operator -> nixCore      "Configures, deploys, maintains"
        operator -> sentinel     "Operates fleet via"
        operator -> retro        "Uses"
        users -> chat            "Messages through"
        users -> mail            "Sends and reads email via"
        users -> companion       "Converses with"

        // === Relationships — Companion core ===
        companion -> claude   "Delegates reasoning to" "HTTPS"
        companion -> gateway  "Invokes remote tools via" "MCP HTTP"
        // companionTools are local — they live in the companion process, not remote

        // === Relationships — Gateway fan-out ===
        gateway -> mail     "Proxies tool calls to" "stdio / MCP"
        gateway -> dav      "Proxies tool calls to" "stdio / MCP"
        // TODO: confirm transport for sentinel
        gateway -> sentinel "Proxies tool calls to" "MCP"
        gateway -> u64mcp   "Proxies tool calls to" "stdio / MCP"

        // === Relationships — Ecosystem services ===
        mail -> ollama     "Classifies inbound mail with" "HTTP"
        chat -> claude     "AI responses via" "HTTPS"
        sentinel -> tailscale "Reaches fleet over"
        sentinel -> nixCore   "Monitors hosts running"

        // === Relationships — Retro ===
        u64mcp       -> u64 "Controls" "REST over LAN"
        streamViewer -> u64 "Receives A/V from" "UDP over LAN"

        // === Relationships — Adjacent ===
        sidAssistant -> hass "Conversation agent for"

        // === Deployment ===
        // Representative topology — Cairn is designed for small fleets with
        // a mix of interactive, always-on, and mobile hosts.
        deploymentEnvironment "Reference" {
            deploymentNode "Primary Workstation" "Desktop with interactive services" "NixOS" {
                containerInstance nixCore
                containerInstance companion
                containerInstance gateway
                containerInstance monitor
            }
            deploymentNode "Always-On Server" "Headless host for stateful services" "NixOS" {
                containerInstance mail
                containerInstance dav
                containerInstance chat
                containerInstance sentinel
            }
            deploymentNode "Mobile Host" "Laptop with core platform only" "NixOS" {
                containerInstance nixCore
            }
            deploymentNode "Tailnet" "Mesh VPN connecting the fleet" "Tailscale" {
                softwareSystemInstance tailscale
            }
        }
    }

    views {

        systemLandscape "Landscape" "The full picture: Cairn, adjacent systems, external dependencies, and the people who use them." {
            include *
            autolayout lr
        }

        systemContext cairn "CairnContext" "Where Cairn sits in the world." {
            include *
            autolayout lr
        }

        container cairn "CairnContainers" "The services inside Cairn." {
            include *
            autolayout
        }

        component gateway "GatewayComponents" "How MCP Gateway is structured internally." {
            include *
            autolayout lr
        }

        component companion "CompanionComponents" "How Cairn Companion is structured internally." {
            include *
            autolayout lr
        }

        deployment cairn "Reference" "ReferenceDeployment" "Representative deployment topology for a small Cairn fleet." {
            include *
            autolayout lr
        }

        styles {
            element "Person" {
                background "#1a5490"
                color "#ffffff"
                shape person
            }
            element "Software System" {
                background "#2d6fb4"
                color "#ffffff"
            }
            element "Container" {
                background "#4a90d4"
                color "#ffffff"
            }
            element "Component" {
                background "#7ab4e0"
                color "#1a1a1a"
            }
            element "External" {
                background "#888888"
                color "#ffffff"
            }
            element "External Hardware" {
                background "#6b4a2a"
                color "#ffffff"
                shape hexagon
            }
            element "Adjacent" {
                background "#aaaaaa"
                color "#1a1a1a"
            }
        }
    }
}
