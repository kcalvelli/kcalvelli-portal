# Capability: Master Document Generation

## Overview

Generate a single master architecture markdown document (`ARCHITECTURE.md`) from the portal's existing data sources, producing a self-contained reference optimized for Claude Projects ingestion.

## ADDED Requirements

### Requirement: Document Assembly
The system SHALL assemble `ARCHITECTURE.md` from `projects.json`, generated `docs/<repo>.md` files, and cached repository data during the portal update workflow.

#### Scenario: Generate from complete data
**Given** `projects.json` contains 15 projects
**And** all 15 `docs/<repo>.md` files exist
**And** cached data files exist for at least some projects
**When** the master document generation step executes
**Then** `ARCHITECTURE.md` is written to the repository root
**And** all 15 projects appear in the document

#### Scenario: Generate with partial cached data
**Given** cached data files (`*_flake.nix`, `*_readme.md`) exist for only 6 projects
**When** the master document generation step executes
**Then** `ARCHITECTURE.md` is generated successfully
**And** projects without cached data use information from `docs/<repo>.md` and `projects.json`
**And** no sections are empty or omitted due to missing cached data

#### Scenario: Deterministic output
**Given** `projects.json`, `docs/*.md`, and cached data files are unchanged
**When** the master document generation step runs twice
**Then** both runs produce identical `ARCHITECTURE.md` content (excluding the generation date in the header)

---

### Requirement: Output Location and Format
The system SHALL write `ARCHITECTURE.md` to the repository root as a standalone markdown file.

#### Scenario: File placement
**Given** the master document generation step completes
**When** the file is written
**Then** `ARCHITECTURE.md` exists at the repository root (same level as `projects.json`)
**And** the file is valid markdown
**And** the file is not added to `mkdocs.yml` navigation

#### Scenario: Overwrite on regeneration
**Given** `ARCHITECTURE.md` already exists from a previous run
**When** the master document generation step executes
**Then** the existing file is fully replaced with the new version
**And** no content from the previous version is preserved or merged

---

### Requirement: Claude Projects Formatting
The system SHALL format the document for optimal Claude Projects context ingestion.

#### Scenario: Heading depth limit
**Given** the document is being assembled
**When** sections are structured
**Then** no heading is deeper than H4 (`####`)

#### Scenario: No relative links
**Given** the document contains project cross-references
**When** referencing other projects within the document
**Then** references use section names (e.g., "See: axiOS in Project Inventory > System")
**And** no relative file links (e.g., `[link](file.md)`) appear in the document

#### Scenario: No Mermaid code blocks
**Given** per-project docs contain Mermaid C4 diagrams
**When** architecture information is included in the master document
**Then** Mermaid code blocks are NOT copied into the master document
**And** architecture is described using structured text (component lists, relationship descriptions)

#### Scenario: Self-contained content
**Given** the document is uploaded to Claude Projects without any other files
**When** Claude reads the document
**Then** all project names, descriptions, relationships, and technology choices are inline
**And** no information requires following external links to understand

## Constraints

- Maximum target size: 20KB (to leave room in Claude Projects context for conversation)
- Processing order follows `projects.json` array order for projects and `tagDefinitions.order` for categories
- Generation date in header uses ISO 8601 format (YYYY-MM-DD)
