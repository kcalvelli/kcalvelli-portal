# Generate Master Architecture Document for Claude Projects

## Summary

Add a new generation step to the portal update pipeline that produces a single master markdown file (`ARCHITECTURE.md`) alongside the existing MkDocs HTML site. This document serves as an enterprise architecture reference optimized for upload to Claude Projects, enabling Claude to reason about the entire system landscape without additional context.

## Problem Statement

### Architecture Knowledge is Fragmented Across 15+ Pages

The portal currently generates individual `docs/<repo>.md` pages optimized for human browsing via MkDocs. Each page is self-contained with its own overview, C4 diagram, and onboarding section. However:

- **No single document captures cross-project relationships** (e.g., axiOS DAV provides data to axios-ai-mail via MCP)
- **MCP server topology is implicit** - the reader must visit 5+ pages and mentally reconstruct how Ultimate64MCP, mcp-journal, nix-devshell-mcp, mcp-gateway, and axios-dav interconnect
- **Technology decisions are scattered** - why Nix flakes everywhere, why Python for MCP servers, why Rust for stream processing, etc.

**Impact**: When using Claude Projects for enterprise architecture reasoning, uploading 15 separate markdown files loses the relational context. Claude cannot infer which projects compose into subsystems or how data flows across boundaries.

### No Machine-Optimized Output Format

The generated docs use MkDocs conventions: relative links (`[axiOS](axios.md)`), navigation-dependent structure, and Mermaid diagrams that render in browsers but are opaque to language models as raw text.

**Impact**: Uploading raw `docs/*.md` files to Claude Projects results in broken cross-references, redundant boilerplate, and missing system-level context.

## Existing Infrastructure Discovery

### Available Data Sources

The portal already collects and caches rich metadata during the update workflow:

| Source | Location | Content |
|--------|----------|---------|
| Project registry | `projects.json` | 15 projects with repos, tags, descriptions, diagram types |
| Tag taxonomy | `projects.json` → `tagDefinitions` | 14 categories with display names and ordering |
| Cached READMEs | `*_readme.md` | Full README content (6 projects currently cached) |
| Cached file listings | `*_files.json` | Repository file structure for stack detection |
| Cached flake.nix | `*_flake.nix` | Nix dependency graphs (6 projects) |
| Cached releases | `*_releases.json` | Release history and versions |
| Generated docs | `docs/<repo>.md` | Synthesized architecture sections with C4 diagrams |
| Repository info | `*_info.json` | GitHub descriptions and URLs |

### Current Pipeline (OPS_MANUAL.md)

```
Phase 0: Discovery → GitHub scrape, classify new repos
Phase 1: Preparation → Read projects.json, update index.md
Phase 2: Processing → Fetch data per repo, generate docs/<repo>.md
Phase 3: Finalization → Update mkdocs.yml, verify links
Phase 4: Completion → Summary report
```

The new step fits naturally as **Phase 2.5: Master Document Generation** — after all per-project docs exist but before finalization.

### What Does NOT Exist Yet

- No cross-project dependency mapping (must be inferred from tags, flake inputs, and README content)
- No explicit MCP server graph (must be derived from `mcp-server` tag and project descriptions)
- No technology rationale documentation (must be synthesized from stack analysis)
- Cached data is incomplete: only 6 of 15 projects have `*_readme.md`, `*_files.json`, `*_flake.nix` cached files — the remaining 9 projects added via automated discovery lack cached data

## Proposed Solution

### 1. New Output Artifact: `ARCHITECTURE.md`

A single markdown file generated at the repository root, containing a complete architectural reference structured for Claude Projects ingestion.

**Location**: `/home/keith/Projects/kcalvelli-portal/ARCHITECTURE.md`

**Why the repo root?** Version-controlled alongside `projects.json`, visible in GitHub, and easy to copy/upload to Claude Projects. Not placed in `docs/` because it is not a MkDocs page — it serves a different audience (AI context) and different format conventions.

### 2. Content Structure

The document follows a top-down architecture decomposition:

```markdown
# axiOS Enterprise Architecture Reference
## Generation Metadata
## System Context
## Project Inventory
### <Tag Category>
#### <Project Name>
## MCP Server Topology
## Integration Patterns
## Technology Decisions
## Dependency Graph
## Maintenance Status
```

See `design.md` for full section-by-section content specification.

### 3. Pipeline Integration

Add a new step to `OPS_MANUAL.md` between Phase 2 (Processing) and Phase 3 (Finalization):

```
Phase 2.5: Master Document Generation
  1. Read projects.json for complete project registry
  2. Read all docs/<repo>.md files for synthesized content
  3. Read cached data files (*_flake.nix, *_readme.md) where available
  4. Assemble ARCHITECTURE.md using deterministic template
  5. Write to repository root
```

### 4. Data Assembly Strategy

The master document is assembled from three tiers of data, with graceful degradation:

| Tier | Source | Availability | Used For |
|------|--------|-------------|----------|
| **Always available** | `projects.json` | All 15 projects | Inventory, tags, descriptions, categories |
| **Generated docs** | `docs/<repo>.md` | All 15 projects | Architecture diagrams, onboarding summaries |
| **Cached raw data** | `*_flake.nix`, `*_readme.md`, etc. | 6 projects (expanding) | Dependency details, technology rationale |

When cached data is missing for a project, the master document uses the synthesized `docs/<repo>.md` content and marks dependency information as "inferred from project description."

### 5. Determinism Guarantee

The output is deterministic: same `projects.json` + same `docs/*.md` + same cached files = identical `ARCHITECTURE.md`. This is achieved by:

- Processing projects in `projects.json` array order (stable)
- Sorting tag categories by `tagDefinitions.order` (stable)
- No timestamps except a generation metadata header with ISO 8601 date
- No random or non-deterministic content

### 6. Claude Projects Optimization

The markdown format is specifically optimized for Claude Projects context ingestion:

- **Flat heading structure**: No deeper than H4 to avoid context fragmentation
- **Explicit cross-references**: "See: Project X in section Y" instead of `[link](file.md)`
- **Inline descriptions**: All context self-contained, no external link dependencies
- **Structured data**: Tables for inventories, explicit key-value pairs for metadata
- **No Mermaid code blocks**: Diagrams are described in prose (Mermaid syntax is noise to Claude). The C4 diagrams from per-project docs are translated into structured text descriptions of components and relationships.

## Scope

**In Scope**:

- `ARCHITECTURE.md` generation step in OPS_MANUAL.md
- Content assembly from existing data sources (projects.json, docs/, cached data)
- Agent instructions for assembling each section
- Deterministic, idempotent output
- AGENTS.md update to include master doc in update workflow

**Out of Scope**:

- Automated upload to Claude Projects (manual copy/upload)
- Scheduled regeneration (triggered as part of existing manual "update" command)
- Scraping additional data beyond what the portal already collects
- Changes to existing per-project documentation format
- MkDocs integration (ARCHITECTURE.md is NOT a site page)

## User Experience Flow

```
User: "update"

Claude: [Existing phases 0-2 run as normal...]
        "Processing master architecture document..."
        "Assembling project inventory... 15 projects"
        "Mapping MCP server topology... 5 servers identified"
        "Analyzing integration patterns... 8 connections"
        "Writing ARCHITECTURE.md..."

        "Portal update complete!
         - New projects added: 0
         - Documentation pages updated: 15
         - Navigation sections: 8
         - Master architecture doc: ARCHITECTURE.md (updated)"
```

## Success Criteria

1. Running "update" produces `ARCHITECTURE.md` alongside existing outputs
2. Uploading `ARCHITECTURE.md` to Claude Projects enables Claude to answer:
   - "What MCP servers does Keith run and how do they connect?"
   - "What is the axiOS ecosystem and what projects compose it?"
   - "What technology stack does each project use and why?"
   - "Which projects depend on each other?"
   - "What is the current maintenance status of the C64 tools?"
3. The document is deterministic: re-running update with no changes produces identical output
4. All 15 projects appear in the document, even those without cached data
5. The document is self-contained: no broken references, no external link dependencies

## Dependencies

- Existing portal update workflow (OPS_MANUAL.md, AGENTS.md)
- `projects.json` as source of truth for project registry
- Generated `docs/<repo>.md` files (must run after Phase 2)
- GitHub CLI (`gh`) for any supplemental data fetching during generation

## Risks & Mitigations

| Risk | Impact | Mitigation |
|------|--------|------------|
| Incomplete cached data (9/15 projects) | Some sections sparse | Graceful degradation: use docs/<repo>.md content; flag gaps explicitly |
| Document grows too large for Claude Projects context | Claude truncates or loses detail | Target ~15-20KB; use concise summaries, not full READMEs |
| Cross-project relationships are incorrect | Claude receives wrong architecture model | Relationships derived from explicit tags and flake inputs only; no hallucinated connections |
| MCP topology changes frequently | Document becomes stale | Regenerated on every "update" run; stale data is self-correcting |
| Mermaid→prose translation loses diagram fidelity | Architecture descriptions are vague | Use structured component lists with explicit relationships, not free-form prose |
