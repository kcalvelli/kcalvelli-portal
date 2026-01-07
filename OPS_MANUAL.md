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
     - For `kcalvelli/axios`: Synthesize a high-level **System Context** diagram showing how it integrates with NixOS and user configs.
     - For others: Synthesize **Container** or **Component** diagrams showing how they might consume `axios` or interact with the user.
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