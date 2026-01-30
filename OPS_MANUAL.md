# Agent Instructions: Portal Update

You are a Technical Documentation Architect. Your goal is to update the documentation portal by scraping data from remote repositories using the GitHub CLI (`gh`) and synthesizing architectural insights.

## Context

- **Tooling:** Use `gh` CLI for all network operations.
- **Output:** Write standard Markdown files to the `docs/` directory.
- **Config:** Read `projects.json` for the list of repositories and their metadata.
  - Each project has: `repo`, `displayName`, `description`, `tags[]`, and `diagramType`
  - `tagDefinitions` contains display information for each tag category

## Execution Steps

### 0. Discovery Phase (Run First)

Before processing existing projects, discover any new public repositories:

1. **Scrape GitHub for all public repos:**
   ```bash
   gh repo list kcalvelli --visibility=public --json name,description --limit 100
   ```

2. **Compare against `projects.json`:**
   - Extract the list of repo names currently in `projects.json`
   - Identify repos returned by GitHub that are NOT in `projects.json`
   - These are "new" repositories to be added

3. **For each new repository:**
   - Auto-classify using keyword patterns (see `openspec/AGENTS.md` for mapping)
   - Present suggested tags to user via `AskUserQuestion`
   - User confirms or modifies tags
   - Add to `projects.json` with:
     - `repo`: `kcalvelli/<name>`
     - `displayName`: Title-cased (e.g., `mcp-gateway` → `MCP Gateway`)
     - `description`: From GitHub API (or prompt user if empty)
     - `tags`: Confirmed tag array (first tag is primary)
     - `diagramType`: `C4Component` (default)

4. **Add new tag definitions if needed:**
   - If a new tag is used that's not in `tagDefinitions`, add it
   - Assign appropriate `displayName`, `description`, and `order`

5. **Skip discovery if user explicitly says "regenerate only"**

### 1. Preparation

1. Read `projects.json` and parse the `projects` array and `tagDefinitions` object.
2. Ensure a `docs/` directory exists.
3. **Update** `index.md` in `docs/` acting as a dashboard. **IMPORTANT: Preserve existing personalization!**
   - **DO NOT overwrite the header and bio sections** (lines before the first `## System` or tag section)
   - If updating an existing index.md, read it first and preserve:
     - The personalized title (e.g., "Keith Calvelli's Project Portfolio")
     - The welcome/bio paragraph
     - Any "About My Work" or similar sections before the project tables
   - **ONLY update the project tables** (from the first tag section onwards)
   - Group projects by their primary tag (first tag in the tags array)
   - Use `tagDefinitions` to get the display name and order for each section
   - Create a section for each tag category with a table of its projects
   - Include: displayName, description, and repository link for each project

### 2. Processing (Iterate for each repo)

For each repo in the list:

1. **Fetch Data:**
   - Get the Repository Description.
   - Read the `README.md`.
   - Read `CONTRIBUTING.md` (if it exists) for onboarding info.
   - **Releases:** Run `gh release list --limit 20 --json tagName,publishedAt,isLatest --order desc` to fetch the release history.

2. **Analyze for Architecture (Synthesis):**
   - List the files in the root and `src` to identify the stack (e.g., Nix flakes, Rust/Cargo, Python, Docker).
   - **Diagram Logic:**
     - **Constraint:** Do NOT depict internal implementation details such as specific threads, internal classes, individual script files, or functions. Focus on high-level logical blocks and external system interactions.

     - **General Requirements (ALL diagrams):**
       - Use `Container_Boundary()` to group related components when 2+ components exist in the same logical layer
       - ALWAYS specify technology stack in the third parameter (e.g., "Python/FastAPI", "Rust Binary", "GTK/JavaScript")
       - Add protocols and data formats to relationship descriptions (e.g., "Sends frames", "UDP", not just "Communicates with")
       - Use `BiRel()` for bidirectional communication instead of two separate `Rel()` calls
       - Add styling: `UpdateElementStyle()` for key components to create visual hierarchy
       - Use `UpdateLayoutConfig($c4ShapeInRow="3")` when there are 5+ elements for better spacing

     - **Use the `diagramType` field from projects.json to determine diagram type:**
       - **C4Context diagrams:** Show high-level system context with users, the system itself, and external systems
         - Example: User → Main System → External Dependencies
         - Emphasize the primary purpose and key external interactions
         - Style the main system distinctly using UpdateElementStyle
       - **C4Component diagrams:** Show internal architecture with logical components
         - Break the tool into 2-3 logical components if it has distinct layers (UI + Logic, Server + Client, etc.)
         - Show WHERE components run using boundaries (e.g., "Desktop Environment", "Network Layer", "Hardware")
         - For network-based tools, explicitly show protocols (UDP, HTTP, SSE, MCP)
         - For bridge/adapter patterns (like MCP servers), show three layers: Client → Adapter → Target System
         - Use `System_Ext()` for hardware devices, external APIs, or services outside the repo
   - Check `flake.nix` or `default.nix` specifically to identify dependencies.

3. **Write Output (`docs/<repo-name>.md`):**
   - **Section 1: Overview:** Summary and link to the repo.
   - **Section 2: Architecture:** Insert the synthesized Mermaid diagram inside a ````mermaid` code block. Explain your architectural assumptions.
   - **Section 3: Onboarding:** Summary of how to build/run (prioritize `nix build` or `nix develop` instructions if found).
   - **Section 4: Release History:** - Create a Markdown table with columns: **Version**, **Date**, **Status**.
     - Mark the row where `isLatest` is true with a "✅" or "Latest" badge.
     - Format the date as YYYY-MM-DD.

### 2.5. Master Document Generation

After all per-project docs are generated, assemble `ARCHITECTURE.md` at the repository root. This is a single master markdown file optimized for upload to Claude Projects, enabling Claude to reason about the entire system architecture without additional context.

**Important:** This file is NOT added to `mkdocs.yml` — it is not a MkDocs page. It serves a different audience (AI context) and uses different formatting conventions.

#### Data Sources

Read from three tiers, with graceful degradation when cached data is absent:

| Tier | Source | Availability |
|------|--------|-------------|
| Always available | `projects.json` | All projects — inventory, tags, descriptions |
| Generated docs | `docs/<repo>.md` | All projects — architecture, onboarding |
| Cached raw data | `*_flake.nix`, `*_readme.md`, `*_files.json`, `*_releases.json` | Subset of projects — dependencies, tech stack details |

#### Formatting Rules (Claude Projects Optimization)

- **Maximum heading depth:** H4 (`####`). No deeper.
- **No relative file links:** Use explicit section references (e.g., "See: Project Inventory > MCP Servers") instead of `[link](file.md)`.
- **No Mermaid code blocks:** Translate architecture diagrams into structured text descriptions (component lists, relationship descriptions). Mermaid syntax is noise to language models.
- **All content self-contained:** Every piece of information inline. No external link dependencies.
- **Size target:** 15-20KB total.

#### Determinism Rules

- Process projects in `projects.json` array order.
- Sort tag categories by `tagDefinitions.order`.
- No random content or variable formatting.
- Only non-deterministic element: generation date in header.

#### Document Assembly

Write `ARCHITECTURE.md` to the repository root with the following sections in order:

**1. Header Block:**

```markdown
# axiOS Enterprise Architecture Reference

> Auto-generated by kcalvelli-portal on YYYY-MM-DD.
> Source: projects.json (N projects, M categories)
> Upload this file to Claude Projects for complete system context.
```

- Date: ISO 8601 (YYYY-MM-DD)
- N = number of projects in `projects.json`
- M = number of keys in `tagDefinitions`

**2. System Context:**

- State total project count and category count from `projects.json`.
- Identify the core platform: project(s) with `diagramType: "C4Context"` (currently axiOS).
- Group remaining projects into named subsystems by tag affinity:
  - Projects tagged `ai` or `email` → **AI Services**
  - Projects tagged `mcp-server` → **MCP Infrastructure**
  - Projects tagged `commodore64` → **Retro Computing**
  - Projects tagged `development`, `pkgs`, or `docs` → **Developer Tooling**
  - Projects tagged `rpg`, `calendar`, or `orthodox` → **Other**
- A project may appear in multiple subsystems if it has multiple relevant tags.

**3. Project Inventory:**

- Iterate `tagDefinitions` sorted by `order`.
- For each tag, find projects whose primary tag (first in tags array) matches.
- Build a table per category with columns: Project, Repository, Tech Stack, Status, Description.
- **Tech Stack detection:**
  - Cached `*_files.json`: `Cargo.toml` → Rust, `pyproject.toml` → Python, `package.json` → Node.js
  - Cached `*_flake.nix`: language-specific build helpers (e.g., `rustPlatform`, `buildPythonPackage`)
  - Fallback: "Nix" (all projects are Nix flakes)
- **Status derivation:**
  - Cached `*_releases.json` with releases → "Released (vX.Y.Z)" using latest version
  - No releases or no cached data → "In Development"
- Description: copied verbatim from `projects.json`.

**4. MCP Server Topology:**

- Filter `projects.json` for projects tagged `mcp-server`.
- Also include projects whose description contains "MCP" (e.g., axios-dav mentions "MCP integration").
- For each MCP server, extract transport type and target system from:
  1. `docs/<repo>.md` architecture section (primary)
  2. Cached `*_readme.md` (supplemental)
  3. Project description in `projects.json` (fallback)
- Build a server inventory table with columns: Server, Transport, Target System, Claude Integration.
- Document mcp-gateway's special aggregation role.
- Describe the two MCP data flow paths in structured text:
  - Direct: Client → STDIO → Individual MCP server → Target system
  - Proxied: Client → HTTP → mcp-gateway → Proxied MCP servers → Target systems

**5. Integration Patterns:**

Identify and describe recurring architectural patterns. Each pattern includes: name, description, data/composition flow, and list of projects implementing it.

Required patterns:
- **NixOS Module Composition:** `axios`-tagged projects compose as NixOS modules into axiOS.
- **MCP Bridge/Adapter:** `mcp-server`-tagged projects follow Client → Adapter → Target System.
- **Nix Flake Distribution:** All projects packaged as Nix flakes.

Optional patterns (include if applicable projects exist):
- **Streaming Media Pipeline:** `commodore64`-tagged projects using hardware→network→display.

Keep each pattern to 3-5 sentences plus project list.

**6. Technology Decisions:**

Build a table with columns: Decision, Choice, Rationale, Projects.

Extract technology choices from:
- Cached `*_flake.nix` (build system, language, dependencies)
- Cached `*_files.json` (file structure → language detection)
- `docs/<repo>.md` architecture sections (protocols, frameworks)

Required rows at minimum: OS foundation, package management, MCP server language, documentation tooling. Add additional rows for other detected technologies (e.g., Rust for stream processing, specific transport protocols).

**7. Dependency Graph:**

Use text-based tree notation (NOT Mermaid).

- **Flake input dependencies:** Parse cached `*_flake.nix` for `inputs = { ... }` blocks. Where not cached, infer from tags (`axios`-tagged → likely imports axiOS). All projects depend on nixpkgs.
- **Runtime dependencies:** Extract from `docs/<repo>.md` architecture sections (e.g., mcp-gateway proxies other MCP servers, Ultimate64MCP connects to hardware).

**8. Maintenance Status:**

Build a table with columns: Project, Latest Release, Release Count, Health.

- Latest release and count from cached `*_releases.json`.
- Health classification:
  - Has releases → "Active"
  - No releases but has cached data → "In Development"
  - No cached data → "Unknown"

### 3. Finalization

1. Update `mkdocs.yml` to include the new pages in the `nav` section. **Generate navigation dynamically from projects.json:**

   - Start with `Dashboard: index.md`
   - Group projects by their primary tag (first tag in tags array)
   - Sort tag groups by the `order` field in `tagDefinitions`
   - Use the tag's `displayName` from `tagDefinitions` as the section header
   - Under each section, list projects using their `displayName` from projects.json
   - Link to `<repo-name>.md` (extract repo name from the full repo path)

   Example structure:
   ```yaml
   nav:
     - Dashboard: index.md
     - Core System:
         - Axios Library: axios.md
     - Axios Ecosystem:
         - Axios Monitor: axios-monitor.md
     - Commodore 64 Tools:
         - C64 Stream Viewer: c64-stream-viewer.md
         - Ultimate64 MCP: Ultimate64MCP.md
         - C64 Terminal: c64term.md
     - MCP Servers:
         - Ultimate64 MCP: Ultimate64MCP.md
         - MCP Journal: mcp-journal.md
     - Browser Tools:
         - Brave Previews: brave-browser-previews.md
   ```

2. **Verify all docs are linked** - Every project in `projects.json` should have a corresponding `.md` file and nav entry.

### 4. Completion Summary

After all steps complete, report to the user:

```
Portal update complete!
- New projects added: X
- Documentation pages updated: Y
- Navigation sections: Z
- Master architecture doc: ARCHITECTURE.md (updated)

All projects are now documented and accessible via mkdocs.
```

If some projects lacked cached data, note it: `Master architecture doc: ARCHITECTURE.md (updated, N projects with partial data)`

If any errors occurred (failed fetches, missing data), list them at the end for user review.
