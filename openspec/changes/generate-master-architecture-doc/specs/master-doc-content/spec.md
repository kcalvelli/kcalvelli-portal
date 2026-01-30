# Capability: Master Document Content Specification

## Overview

Define the required sections, content rules, and data assembly logic for each section of `ARCHITECTURE.md`.

## ADDED Requirements

### Requirement: System Context Section
The document SHALL begin with a system context section that provides a high-level overview of the entire project ecosystem.

#### Scenario: Ecosystem summary
**Given** `projects.json` contains N projects across M tag categories
**When** the System Context section is assembled
**Then** it states the total project count and category count
**And** identifies the core platform (axiOS, the only `C4Context` project)
**And** groups remaining projects into named subsystems based on tag affinity

#### Scenario: Subsystem grouping
**Given** projects have tags including `ai`, `mcp-server`, `commodore64`, and `development`
**When** subsystems are identified
**Then** AI-tagged projects are grouped as "AI Services"
**And** MCP-server-tagged projects are grouped as "MCP Infrastructure"
**And** Commodore64-tagged projects are grouped as "Retro Computing"
**And** Development/pkgs/docs-tagged projects are grouped as "Developer Tooling"

---

### Requirement: Project Inventory Section
The document SHALL contain a complete inventory of all projects, grouped by primary tag category.

#### Scenario: Complete inventory
**Given** `projects.json` contains 15 projects
**When** the Project Inventory section is assembled
**Then** all 15 projects appear exactly once
**And** projects are grouped under their primary tag's `displayName`
**And** groups are ordered by `tagDefinitions.order`

#### Scenario: Project entry content
**Given** a project entry is being assembled
**When** data is collected
**Then** the entry includes: display name, repository path, tech stack, release status, and description
**And** tech stack is detected from cached `*_files.json` or `*_flake.nix` where available
**And** tech stack defaults to "Nix" when no cached data exists

#### Scenario: Release status derivation
**Given** a project has cached `*_releases.json`
**When** releases exist in the cached data
**Then** status shows "Released (vX.Y.Z)" with the latest version
**Given** a project has no releases or no cached release data
**When** status is determined
**Then** status shows "In Development"

---

### Requirement: MCP Server Topology Section
The document SHALL map all MCP server implementations, their transports, target systems, and interconnections.

#### Scenario: Server identification
**Given** projects tagged `mcp-server` exist in `projects.json`
**And** additional projects mention "MCP" in their description
**When** the MCP topology section is assembled
**Then** all MCP-capable projects are listed with transport type and target system

#### Scenario: Gateway aggregation
**Given** mcp-gateway exists as an MCP aggregation layer
**When** server relationships are documented
**Then** the document shows mcp-gateway's role as a proxy for other MCP servers
**And** lists which servers it can aggregate

#### Scenario: Data flow description
**Given** MCP servers use STDIO and HTTP transports
**When** the data flow is documented
**Then** two connection paths are described: direct STDIO and proxied HTTP via mcp-gateway
**And** the description uses structured text, not Mermaid diagrams

---

### Requirement: Integration Patterns Section
The document SHALL describe recurring architectural patterns across the project ecosystem.

#### Scenario: Pattern identification
**Given** multiple projects share similar architectural approaches
**When** integration patterns are documented
**Then** at least these patterns are described:
  - NixOS Module Composition (axiOS ecosystem projects)
  - MCP Bridge/Adapter (MCP server projects)
  - Nix Flake Distribution (all projects)
**And** each pattern lists the projects that implement it

#### Scenario: Pattern description
**Given** a pattern is being documented
**When** the pattern section is written
**Then** it includes: pattern name, brief description, composition/data flow, and project list
**And** the description is concise (3-5 sentences per pattern)

---

### Requirement: Technology Decisions Section
The document SHALL record key technology choices, their rationale, and which projects use them.

#### Scenario: Decision inventory
**Given** the ecosystem uses identifiable technology choices
**When** the technology decisions section is assembled
**Then** decisions are presented in a table with: Decision, Choice, Rationale, and Projects columns
**And** at minimum covers: OS foundation, package management, MCP server language, documentation tooling

#### Scenario: Technology extraction
**Given** cached `*_flake.nix` and `*_files.json` exist for some projects
**When** technology choices are identified
**Then** language is detected from file structure (Cargo.toml → Rust, pyproject.toml → Python, etc.)
**And** frameworks are detected from flake inputs and build helpers
**And** projects without cached data inherit technology from `docs/<repo>.md` content where available

---

### Requirement: Dependency Graph Section
The document SHALL map both build-time (flake input) and runtime dependencies between projects.

#### Scenario: Flake input dependencies
**Given** cached `*_flake.nix` files contain `inputs` blocks
**When** dependencies are extracted
**Then** flake input relationships are shown (e.g., "axios-monitor imports axiOS as flake input")
**And** relationships use text tree notation, not Mermaid

#### Scenario: Inferred dependencies
**Given** a project tagged `axios` lacks a cached `*_flake.nix`
**When** dependencies are determined
**Then** a dependency on axiOS is inferred from the tag
**And** all projects are shown as depending on nixpkgs

#### Scenario: Runtime dependencies
**Given** MCP servers connect to external systems
**When** runtime dependencies are documented
**Then** the document shows: mcp-gateway → other MCP servers, Ultimate64MCP → hardware, c64-stream-viewer → hardware

---

### Requirement: Maintenance Status Section
The document SHALL report the current health and release status of each project.

#### Scenario: Status table
**Given** all 15 projects need status reporting
**When** the maintenance status section is assembled
**Then** each project has: latest release version, release count, and health classification

#### Scenario: Health classification
**Given** a project's release and activity data is available
**When** health is classified
**Then** projects with recent releases are "Active"
**And** projects with commits but no releases are "In Development"
**And** projects with no cached data are "Unknown"

## Constraints

- All content is derived from existing data sources; no additional GitHub API calls beyond what the portal update already performs
- Section ordering follows the sequence defined in `design.md`
- Cross-project references within the document use explicit section paths (e.g., "See: Project Inventory > MCP Servers > MCP Journal")
