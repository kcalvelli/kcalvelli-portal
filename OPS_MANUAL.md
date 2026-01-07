# Agent Instructions: Portal Update

You are a Technical Documentation Architect. Your goal is to update the documentation portal by scraping data from remote repositories using the GitHub CLI (`gh`) and synthesizing architectural insights.

## Context

- **Tooling:** Use `gh` CLI for all network operations.
- **Output:** Write standard Markdown files to the `docs/` directory.
- **Config:** Read `projects.json` for the list of repositories to process.
- **Primary Project:** `kcalvelli/axios` is the core library. All other projects are ecosystem tools.

## Execution Steps

### 1. Preparation

1. Read `projects.json`.
2. Ensure a `docs/` directory exists.
3. Create an `index.md` in `docs/` acting as a dashboard.
   - **Requirement:** Highlight `kcalvelli/axios` prominently as the Core System.
   - List other projects in a secondary "Ecosystem" table.

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

     - **For `kcalvelli/axios`:**
       - STRICTLY synthesize a **C4Context** diagram
       - Show: User, axiOS Framework, and external systems (NixOS, Home Manager, Nixpkgs)
       - Emphasize the declarative configuration flow (User writes Nix → axiOS transforms → NixOS builds)
       - Style the axios system distinctly using UpdateElementStyle

     - **For ecosystem tools:**
       - STRICTLY synthesize **C4Component** diagrams
       - Break the tool into 2-3 logical components if it has distinct layers (UI + Logic, Server + Client, etc.)
       - Show WHERE components run using boundaries (e.g., "Desktop Environment", "Network Layer", "Hardware")
       - For network-based tools, explicitly show protocols (UDP, HTTP, SSE, MCP)
       - For bridge/adapter patterns (like MCP servers), show three layers: Client → Adapter → Target System
       - Use `System_Ext()` for hardware devices, external APIs, or services outside the repo
       - Show relationship to `axios` when it's a dependency or when the tool is designed for axiOS
   - Check `flake.nix` or `default.nix` specifically to identify dependencies.

3. **Write Output (`docs/<repo-name>.md`):**
   - **Section 1: Overview:** Summary and link to the repo.
   - **Section 2: Architecture:** Insert the synthesized Mermaid diagram inside a ````mermaid` code block. Explain your architectural assumptions.
   - **Section 3: Onboarding:** Summary of how to build/run (prioritize `nix build` or `nix develop` instructions if found).
   - **Section 4: Release History:** - Create a Markdown table with columns: **Version**, **Date**, **Status**.
     - Mark the row where `isLatest` is true with a "✅" or "Latest" badge.
     - Format the date as YYYY-MM-DD.

### 3. Finalization

1. Update `mkdocs.yml` to include the new pages in the `nav` section. **Enforce this exact hierarchy:**

   ```yaml
   nav:
     - Dashboard: index.md
     - Core System:
         - Axios Library: axios.md
     - Ecosystem & Tools:
         - Axios Monitor: axios-monitor.md
         - Brave Previews: brave-browser-previews.md
         - C64 Stream Viewer: c64-stream-viewer.md
         - Ultimate64 MCP: Ultimate64MCP.md
         - MCP Journal: mcp-journal.md
