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

All projects are now documented and accessible via mkdocs.
```

If any errors occurred (failed fetches, missing data), list them at the end for user review.
