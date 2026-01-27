# Capability: GitHub Repository Sync

## Overview

Automatically discover and classify public GitHub repositories from the `kcalvelli` account for inclusion in the engineering portal.

## ADDED Requirements

### Requirement: Repository Discovery
The system SHALL scrape all public repositories from the `kcalvelli` GitHub account using the GitHub CLI.

#### Scenario: Discover new repositories
**Given** the user triggers an update
**When** the system queries GitHub with `gh repo list kcalvelli --visibility=public --json name,description --limit 100`
**Then** the system receives a list of all public repositories with names and descriptions

#### Scenario: Identify new repositories
**Given** the discovery returns a list of repositories
**And** `projects.json` contains the current project registry
**When** the system compares the two lists
**Then** repositories in GitHub but not in `projects.json` are identified as "new"

---

### Requirement: Auto-Classification
The system SHALL suggest tags for new repositories based on naming patterns and descriptions.

#### Scenario: MCP server classification
**Given** a new repository named `mcp-*` or containing "MCP" in description
**When** the system suggests tags
**Then** the primary tag suggestion is `mcp-server`

#### Scenario: axiOS ecosystem classification
**Given** a new repository named `axios-*`
**When** the system suggests tags
**Then** the primary tag suggestion is `axios`

#### Scenario: Commodore 64 classification
**Given** a new repository with name/description containing "c64", "commodore", or "ultimate64"
**When** the system suggests tags
**Then** the primary tag suggestion is `commodore64`

#### Scenario: Nix tooling classification
**Given** a new repository with name/description containing "nix", "flake", or "devshell"
**When** the system suggests tags
**Then** the primary tag suggestion is `nix` or `pkgs`

#### Scenario: CalDAV/CardDAV classification
**Given** a new repository with name/description containing "dav", "calendar", or "contact"
**When** the system suggests tags
**Then** the primary tag suggestion is `caldav`

#### Scenario: Gateway/proxy classification
**Given** a new repository with name/description containing "gateway" or "proxy"
**When** the system suggests tags
**Then** the primary tag suggestion is `gateway`

#### Scenario: Unknown classification
**Given** a new repository that doesn't match any keyword patterns
**When** the system suggests tags
**Then** the fallback tag suggestion is `development`

---

### Requirement: User Confirmation
The system SHALL present classification suggestions to the user for approval before adding to `projects.json`.

#### Scenario: Present new repositories
**Given** 3 new repositories are identified
**When** the system prepares for user confirmation
**Then** all 3 repositories are shown with their suggested tags
**And** the user can confirm, modify, or skip each repository

#### Scenario: User modifies tags
**Given** the system suggests `[mcp-server]` for a repository
**When** the user specifies `[mcp-server, gateway]` instead
**Then** the repository is added with the user-specified tags

#### Scenario: User skips repository
**Given** the user indicates a repository should be skipped
**When** processing the confirmation
**Then** the repository is NOT added to `projects.json`
**And** it will appear as "new" again on the next update

---

### Requirement: Project Registry Update
The system SHALL add confirmed repositories to `projects.json` with proper formatting.

#### Scenario: Add new project entry
**Given** the user confirms a repository named `axios-dav`
**And** suggests tags `[axios, caldav]`
**When** updating `projects.json`
**Then** a new entry is added:
```json
{
  "repo": "kcalvelli/axios-dav",
  "displayName": "axiOS DAV",
  "description": "<from GitHub>",
  "tags": ["axios", "caldav"],
  "diagramType": "C4Component"
}
```

#### Scenario: Generate display name
**Given** a repository named `mcp-gateway`
**When** generating the display name
**Then** the display name is "MCP Gateway" (title-cased, hyphen to space)

#### Scenario: Missing description
**Given** a repository with no GitHub description
**When** adding to `projects.json`
**Then** the description is set to "No description available"
**And** the user is prompted to provide a better description

## Constraints

- GitHub CLI (`gh`) must be authenticated
- Rate limiting: Maximum 100 repos per query (sufficient for personal account)
- No automatic removal: Only adds new repos, never removes existing ones
