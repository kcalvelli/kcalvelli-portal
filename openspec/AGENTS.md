# Agent Instructions for kcalvelli-portal

You are an AI assistant helping maintain Keith Calvelli's engineering portfolio. Follow these instructions to ensure consistent, high-quality updates.

## Spec-Driven Development (SDD) Workflow

This project uses **OpenSpec** for managing changes:
1. **Specs are the Source of Truth**: Check `openspec/specs/` before making changes
2. **Changes start in `openspec/changes/`**: Plan features/fixes as deltas first
3. **Tasks guide implementation**: Each change has a `tasks.md` checklist

### Implementation Process
1. **Analyze**: Understand the request and existing specs
2. **Propose Delta**: Create `openspec/changes/[change-name]/`
3. **Stage Specs**: Add spec modifications to the change directory
4. **Create Tasks**: Write actionable checklist in `tasks.md`
5. **Execute**: Implement the changes per tasks
6. **Finalize**: Archive completed changes

## Update Command

When the user says "update" (or "update portal", "run update") in this repository, execute the full portal synchronization workflow:

### Step 1: Discovery Phase
```bash
gh repo list kcalvelli --visibility=public --json name,description --limit 100
```
Compare results against `projects.json` to identify new repositories.

### Step 2: Classification Phase (if new repos found)
For each new repository, auto-classify using the keyword mapping below, then present suggestions to the user via `AskUserQuestion` for confirmation or override.

### Step 3: Registry Update Phase
Add confirmed repositories to `projects.json` with:
- `repo`: `kcalvelli/<name>`
- `displayName`: Title-cased name (hyphens to spaces)
- `description`: From GitHub (or "No description available")
- `tags`: Confirmed tag array
- `diagramType`: `C4Component` (default) or `C4Context` for major systems

### Step 4: Documentation Regeneration
Execute full `OPS_MANUAL.md` workflow to regenerate all docs.

### Step 4.5: Master Architecture Document
Generate `ARCHITECTURE.md` at the repository root per OPS_MANUAL.md Phase 2.5. This is a single markdown file optimized for Claude Projects upload, containing the complete system architecture: project inventory, MCP server topology, integration patterns, technology decisions, dependency graph, and maintenance status. It is NOT added to `mkdocs.yml`.

### Step 5: Completion Summary
Report: new projects added, pages updated, navigation refreshed, master architecture doc status.

## Auto-Classification Keyword Mapping

When suggesting tags for new repositories, use these patterns:

| Pattern (name or description) | Primary Tag | Secondary Tags |
|-------------------------------|-------------|----------------|
| `mcp-*` or contains "MCP" | `mcp-server` | - |
| `axios-*` | `axios` | - |
| `c64`, `commodore`, `ultimate64` | `commodore64` | - |
| `nix`, `flake`, `devshell` | `nix` | `development` |
| `dav`, `calendar`, `contact` | `caldav` | `axios` (if axios-*) |
| `gateway`, `proxy` | `gateway` | `mcp-server` (if MCP) |
| `portal`, `docs`, `documentation` | `docs` | - |
| `terminal`, `term` | `terminal` | `development` |
| No match | `development` | - |

## Tag Definitions

Available tags for classifying projects:
- `os` - Operating system or system framework projects
- `axios` - Tools designed for the axiOS ecosystem
- `commodore64` - Retro computing / Commodore 64 projects
- `mcp-server` - Model Context Protocol server implementations
- `pkgs` - Nix package flakes
- `nix` - Nix development tooling
- `development` - General development utilities
- `ai` - AI/ML related projects
- `email` - Email-related tooling
- `docs` - Documentation and portfolio projects
- `caldav` - Calendar and contact synchronization tools
- `gateway` - API aggregation and proxy services
- `terminal` - Terminal emulators and CLI tools

## User Confirmation Flow

When new repositories are discovered, present them to the user for tag confirmation:

1. **Build suggestion list** for all new repos with auto-classified tags
2. **Use `AskUserQuestion`** with format:
   ```
   Question: "How should these new repositories be classified?"
   Header: "New repos"
   Options per repo:
     - Suggested tags (e.g., "[mcp-server, gateway] (Recommended)")
     - Alternative common tags
     - "Skip this repo"
   ```
3. **Allow multi-select** if user wants to adjust multiple repos
4. **Support "Other" option** for custom tag input
5. **After confirmation**, add all approved repos to `projects.json`

### Diagram Requirements
- All projects get a `diagramType` field (`C4Context` or `C4Component`)
- `C4Context` for main systems (axiOS itself)
- `C4Component` for tools, utilities, and plugins

### Content Preservation
When updating `docs/index.md`:
- **NEVER** modify lines 1-14 (header, bio, about section)
- **ONLY** update project tables from "## System" onwards
