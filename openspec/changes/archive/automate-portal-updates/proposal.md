# Automate Portal Updates via GitHub Scraping

## Summary

Enable automatic discovery and documentation of public GitHub repositories when the user runs "update" in Claude Code. The system will:
1. Scrape all public repos from `kcalvelli` GitHub account
2. Detect new repositories not yet in `projects.json`
3. Auto-classify new repos with AI-suggested tags (user confirms)
4. Regenerate all documentation pages per existing `OPS_MANUAL.md`

## Problem Statement

### Manual Discovery is Error-Prone
Currently, adding a new project requires:
1. Manually editing `projects.json`
2. Choosing appropriate tags
3. Running documentation generation
4. Updating `mkdocs.yml` navigation

**Impact**: New repositories may be forgotten, and the portfolio becomes stale.

### No Single "Update" Command
The `OPS_MANUAL.md` describes the documentation generation process, but there's no trigger mechanism. The user must know to run the full process manually.

**Impact**: Updates are inconsistent and the workflow is unclear.

## Existing Infrastructure Discovery

### Current Files
- `projects.json` - Master project registry with 9 projects
- `OPS_MANUAL.md` - Detailed agent instructions for documentation generation
- `mkdocs.yml` - Site navigation (manually maintained)
- `docs/` - 10 generated documentation files

### Current Public Repos (via `gh repo list kcalvelli --visibility=public`)
14 total repositories, including 5 not yet in `projects.json`:
- `mcp-gateway` - Universal MCP Gateway with OAuth2
- `axios-dav` - CalDAV/CardDAV sync for NixOS
- `peregrinatio-rpg` - No description
- `orthoterm` - No description
- `kcalvelli-portal` - This repository itself

### Tag Classification System
Existing `tagDefinitions` in `projects.json`:
- `os`, `axios`, `commodore64`, `mcp-server`, `pkgs`, `nix`, `development`

May need additional tags for new repo types (e.g., `caldav`, `gaming`, `terminal`).

## Proposed Solution

### 1. "Update" Command Recognition

When user says "update" in this repository, Claude Code will:
1. Invoke the update workflow automatically
2. No slash command needed - natural language trigger

**Implementation**: Add recognition pattern to `AGENTS.md`

### 2. GitHub Repository Discovery

Run scraping to get all public repos:
```bash
gh repo list kcalvelli --visibility=public --json name,description --limit 100
```

Compare against `projects.json` to identify:
- **New repos**: Not in `projects.json`
- **Existing repos**: Already documented (refresh data)

### 3. Auto-Classification with Confirmation

For each new repository:
1. AI analyzes repo name and description
2. Suggests primary tag and secondary tags based on keywords:
   - `mcp-` prefix → `mcp-server`
   - `axios-` prefix → `axios`
   - `c64`, `commodore`, `ultimate64` → `commodore64`
   - `-nix`, `flake` keywords → `nix` or `pkgs`
   - `dav`, `calendar`, `contact` → new `caldav` tag
   - No clear match → `development` (generic)
3. Present suggestions to user via `AskUserQuestion`
4. User confirms or overrides tags
5. Add to `projects.json`

### 4. Documentation Regeneration

After `projects.json` is updated:
1. Execute full `OPS_MANUAL.md` workflow
2. Fetch README, releases, file structure for each repo
3. Generate/update `docs/<repo>.md` files
4. Update `docs/index.md` (preserve header/bio)
5. Regenerate `mkdocs.yml` navigation from `projects.json`

### 5. New Tag Definitions (if needed)

Add to `tagDefinitions` when repos don't fit existing categories:
```json
"caldav": {
  "displayName": "CalDAV/CardDAV",
  "description": "Calendar and contact synchronization tools",
  "order": 8
},
"gateway": {
  "displayName": "API Gateways",
  "description": "API aggregation and proxy services",
  "order": 9
}
```

## Scope

**In Scope**:
- Natural language "update" trigger recognition
- GitHub scraping for public repo discovery
- Auto-classification with user confirmation
- Full documentation regeneration per `OPS_MANUAL.md`
- Dynamic `projects.json` and `mkdocs.yml` updates
- Adding new tag definitions as needed

**Out of Scope**:
- Scheduled/automated updates (manual trigger only)
- Private repository handling
- Documentation hosting/deployment automation
- Repo deletion detection (only adds, doesn't remove)

## User Experience Flow

```
User: "update"

Claude: "Scanning GitHub for new repositories..."
        "Found 3 new repos not in portfolio:
         1. mcp-gateway - Universal MCP Gateway
         2. axios-dav - CalDAV/CardDAV sync
         3. orthoterm - (no description)

         Suggested classifications:
         - mcp-gateway → [mcp-server, gateway]
         - axios-dav → [axios, caldav]
         - orthoterm → [terminal, development]

         [Confirm] [Modify] [Skip some]"

User: [Confirms or adjusts]

Claude: "Added 3 projects to portfolio.
         Regenerating documentation...
         ✓ Updated 14 project pages
         ✓ Updated index.md dashboard
         ✓ Updated mkdocs.yml navigation

         Portal update complete!"
```

## Success Criteria

1. Running "update" triggers full discovery + regeneration workflow
2. New public repos are detected and added with appropriate tags
3. User gets confirmation before any new repos are added
4. Existing documentation is refreshed with latest data
5. No manual editing of `projects.json` required for new repos

## Dependencies

- GitHub CLI (`gh`) must be authenticated
- Network access to GitHub API
- Existing `OPS_MANUAL.md` workflow remains authoritative for documentation format

## Risks & Mitigations

| Risk | Mitigation |
|------|------------|
| Incorrect auto-classification | User confirmation step before adding |
| API rate limits | Batch requests, respect limits |
| Repo with no description | Use repo name for classification, mark for review |
| Breaking existing docs | Preserve header/bio in index.md, only update tables |
