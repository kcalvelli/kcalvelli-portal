# OpenSpec: Prompt Engineering Guide for Claude Projects

> Upload this file to a Claude.ai Project to enable Claude to generate high-quality `openspec:proposal` prompts for any repository using OpenSpec.
> Generated from the kcalvelli-portal reference implementation on 2026-01-30.

## What is OpenSpec?

OpenSpec is an AI-native spec-driven development (SDD) framework. It provides a structured workflow where changes to a codebase are proposed, specified, implemented, and archived through a set of markdown artifacts and a CLI tool. The framework is designed for use with Claude Code, where three slash commands (`/openspec:proposal`, `/openspec:apply`, `/openspec:archive`) drive the lifecycle.

The core idea: **specs are the source of truth**. Every change starts as a proposal with BDD-style requirement specifications. Code is only written after the proposal is approved.

## The OpenSpec Lifecycle

```
1. PROPOSAL  ──>  2. APPLY  ──>  3. ARCHIVE
   (design)         (build)        (finalize)
```

### Stage 1: Proposal (`/openspec:proposal`)

The user describes what they want. Claude Code:
1. Explores the codebase and reads `openspec/project.md`, existing specs, and related code
2. Scaffolds a change directory under `openspec/changes/<change-id>/`
3. Creates `proposal.md`, `tasks.md`, optionally `design.md`
4. Writes BDD-style spec deltas in `changes/<change-id>/specs/<capability>/spec.md`
5. Validates with `openspec validate <change-id> --strict`
6. **No code is written.** Only design documents.

### Stage 2: Apply (`/openspec:apply`)

After the user reviews and approves:
1. Claude reads `proposal.md`, `design.md`, and `tasks.md`
2. Works through tasks sequentially, writing code
3. Marks each task complete in `tasks.md`
4. Merges spec deltas to `openspec/specs/`

### Stage 3: Archive (`/openspec:archive`)

After deployment/verification:
1. Runs `openspec archive <change-id> --yes`
2. Moves the change to `openspec/changes/archive/<change-id>/`
3. Specs in `openspec/specs/` become the authoritative record

## Directory Structure

```
<project-root>/
├── openspec/
│   ├── project.md                         # Project goals, tech stack, rules
│   ├── AGENTS.md                          # Agent instructions and workflows
│   ├── specs/                             # Authoritative merged specs
│   │   ├── <capability-name>/
│   │   │   └── spec.md                    # BDD requirements + scenarios
│   │   └── ...
│   └── changes/                           # Active and archived changes
│       ├── <change-id>/                   # Active change (in progress)
│       │   ├── proposal.md                # Problem statement + solution
│       │   ├── design.md                  # Detailed specification (optional)
│       │   ├── tasks.md                   # Implementation checklist
│       │   └── specs/                     # Staged spec deltas
│       │       ├── <capability>/spec.md
│       │       └── ...
│       └── archive/                       # Completed changes
│           └── <change-id>/
│               └── ...
```

## Artifact Formats

### proposal.md

The proposal is the core artifact. It justifies the change, describes the solution, and scopes the work. A well-structured proposal has these sections:

```markdown
# <Verb-Led Title Describing the Change>

## Summary
1-3 sentences explaining what the change does and why.

## Problem Statement
### <Problem 1 Title>
What's wrong today. Concrete description with impact.
### <Problem 2 Title>
Another dimension of the problem, if applicable.

## Existing Infrastructure Discovery
### Current Files / Current State
What already exists that this change builds on or modifies.
Tables showing available data, current capabilities, etc.
### What Does NOT Exist Yet
Explicit gaps the proposal fills.

## Proposed Solution
### 1. <Solution Component>
Description of the first part of the solution.
### 2. <Solution Component>
Description of the second part.
(Continue as needed)

## Scope
**In Scope**: Bulleted list of what IS included.
**Out of Scope**: Bulleted list of what is NOT included.

## User Experience Flow
```
Concrete example showing the user interaction.
What the user types, what they see in response.
```

## Success Criteria
Numbered list of verifiable outcomes.

## Dependencies
What must exist or be available for this change to work.

## Risks & Mitigations
| Risk | Impact | Mitigation |
|------|--------|------------|
| What could go wrong | How bad | How to prevent/handle |
```

#### What makes a great proposal.md:

1. **Verb-led change ID**: `automate-portal-updates`, `generate-master-architecture-doc`, `add-email-classification`. The ID should describe the action, not the thing.
2. **Concrete problem statement**: Not "things could be better" but "currently requires 4 manual steps, new repos are missed for weeks."
3. **Infrastructure discovery**: Shows the author explored the codebase. Lists specific files, their contents, what data is available. This grounds the proposal in reality.
4. **Scoped solution**: Each numbered subsection is a distinct deliverable. No vague hand-waving.
5. **Explicit scope boundaries**: "Out of Scope" prevents feature creep and sets expectations.
6. **UX flow**: A concrete walkthrough showing the before/after user experience.
7. **Testable success criteria**: Each criterion can be verified as pass/fail.

### tasks.md

Tasks are organized into phases with checkboxes. Each task is small, verifiable, and references specific files.

```markdown
# Tasks: <Change Name>

## Phase 1: <Phase Name>

- [ ] **1.1 <Task description in imperative form>**
  - File: `path/to/file`
  - <What to do, in detail>
  - <Expected outcome>

- [ ] **1.2 <Next task>**
  - File: `path/to/file`
  - <Details>

## Phase 2: <Next Phase>

- [ ] **2.1 <Task>**
  ...

## Phase N: Validation

- [ ] **N.1 Test <feature> with <scenario>**
- [ ] **N.2 Verify <constraint>**
- [ ] **N.3 Archive change**
```

#### What makes great tasks:

1. **Phased organization**: Group related work. Common phases: Setup, Core Implementation, Integration, Spec Finalization, Validation.
2. **File references**: Every task that modifies a file names the file.
3. **Small scope**: Each task should be completable in one focused step. If a task description needs multiple paragraphs, break it into subtasks.
4. **Validation phase**: Always end with testing/verification tasks.
5. **Dependencies visible**: If Phase 2 depends on Phase 1, that's implicit from ordering. Cross-phase dependencies should be noted.

### design.md (Optional)

Include `design.md` when:
- The solution spans multiple systems or files
- There are architectural trade-offs to discuss
- The implementation needs detailed specifications beyond what proposal.md covers
- Content structure, data formats, or algorithms need explicit definition

Skip `design.md` when:
- The change is straightforward (single file, clear approach)
- The proposal.md fully specifies the solution

A design doc typically contains:
- Design principles
- Detailed content/data structure specifications
- Size budgets or performance constraints
- Handling of edge cases and missing data
- Section-by-section assembly logic (for generated outputs)

### spec.md (BDD Specifications)

Specs use a strict Behavior-Driven Development format. Each spec file represents one **capability** — a cohesive unit of functionality.

```markdown
# Capability: <Capability Name>

## Overview
1-2 sentences describing what this capability provides.

## ADDED Requirements

### Requirement: <Requirement Name>
The system SHALL <requirement statement>.

#### Scenario: <Scenario Name>
**Given** <precondition>
**And** <additional precondition>
**When** <trigger or action>
**Then** <expected outcome>
**And** <additional outcome>

#### Scenario: <Another Scenario>
**Given** <precondition>
**When** <trigger>
**Then** <outcome>

---

### Requirement: <Next Requirement>
The system SHALL <statement>.

#### Scenario: <Scenario>
...

## Constraints
- <Hard constraint or limitation>
- <Another constraint>
```

#### Spec conventions:

1. **Section headers**: Use `## ADDED Requirements` for new specs, `## MODIFIED Requirements` when changing existing specs, `## REMOVED Requirements` when deprecating.
2. **Requirement format**: Always starts with "The system SHALL..." — this is a formal requirement statement.
3. **Scenario format**: Given/When/Then with **bold** keywords. Each scenario tests one specific behavior.
4. **One capability per spec**: Don't mix unrelated requirements. Split into separate spec folders.
5. **Horizontal rules**: Use `---` between requirements for visual separation.
6. **Cross-references**: When one spec depends on another, mention it explicitly: "See: Capability X, Requirement Y."
7. **Constraints section**: Hard limitations, preconditions, or invariants that apply to all requirements.

## The OpenSpec CLI

Key commands available in Claude Code:

| Command | Purpose |
|---------|---------|
| `openspec list` | List active changes with task progress |
| `openspec list --specs` | List all merged specs |
| `openspec show <id>` | Display a change or spec |
| `openspec show <id> --json --deltas-only` | Machine-readable spec deltas |
| `openspec show <spec> --type spec` | Display a specific spec |
| `openspec validate <id> --strict` | Validate a change (must pass before sharing) |
| `openspec validate --all` | Validate all changes and specs |
| `openspec archive <id> --yes` | Archive a completed change |
| `openspec init` | Initialize OpenSpec in a new project |
| `openspec update` | Refresh OpenSpec instruction files |

## How to Write a Good Proposal Prompt

When asking Claude to generate an `openspec:proposal`, the quality of your prompt directly determines the quality of the proposal. Here is what to include:

### Prompt Template

```
<Action verb> <what> for/in <context>

<2-4 sentences of context explaining the current state and what you want to change.>

Key requirements:
1. <Specific requirement>
2. <Specific requirement>
3. <Specific requirement>

Context: <Any additional technical details, constraints, or preferences.>
```

### Good Prompt Examples

**Example 1: Feature addition**
```
Add email classification with local LLM for axiOS AI Mail

The axios-ai-mail project currently fetches emails via IMAP but has no
classification. Add a local LLM classification pipeline using Ollama that
tags emails as important, newsletter, social, or spam. Store classifications
in SQLite with Alembic migrations.

Key requirements:
1. Classification runs on fetch, not on-demand
2. Uses Ollama API (already available on axiOS systems)
3. SQLite database with schema migrations
4. MCP tool to query classifications
5. NixOS module option to configure the Ollama model

Context: The project is a Python MCP server packaged as a Nix flake.
See the existing flake.nix for package structure.
```

**Example 2: Workflow automation**
```
Automate portal updates via GitHub scraping

Currently adding new projects to the engineering portal requires manually
editing projects.json. The portal should auto-discover new public repos
when the user says "update" in Claude Code.

Key requirements:
1. Natural language trigger (user says "update")
2. GitHub discovery via `gh repo list`
3. Auto-classify repos by naming patterns with user confirmation
4. Regenerate all docs after registry update
5. No automatic removal of existing projects

Context: The kcalvelli-portal project at /home/keith/Projects/kcalvelli-portal
is an MkDocs-based site. It already has projects.json and OPS_MANUAL.md.
```

**Example 3: Infrastructure change**
```
Add HTTP transport with OAuth2 to MCP Gateway

The mcp-gateway currently only supports STDIO transport for proxied MCP
servers. Add HTTP+SSE transport so remote clients can connect with
OAuth2 authentication.

Key requirements:
1. SSE endpoint for streaming MCP responses
2. OAuth2 authorization code flow
3. Token storage in NixOS module configuration
4. Rate limiting per client
5. Health check endpoint

Context: Built with FastAPI/uvicorn, packaged as Nix flake. See the
existing flake.nix and src/mcp_gateway/ for current architecture.
```

### What makes these prompts effective:

1. **Verb-led title**: Starts with an action verb (Add, Automate, Extend, Refactor)
2. **Current state**: Explains what exists today so Claude can ground the proposal
3. **Numbered requirements**: Specific, testable items — not vague wishes
4. **Technical context**: Points to relevant files, mentions the tech stack
5. **Scope hints**: Implicitly scopes by stating what IS needed (Claude infers what isn't)

### Common prompt anti-patterns to avoid:

| Anti-Pattern | Problem | Better Alternative |
|-------------|---------|-------------------|
| "Make it better" | No measurable outcome | "Add X capability that does Y" |
| "Refactor everything" | Unbounded scope | "Refactor the auth module to use JWT instead of sessions" |
| No context given | Claude can't ground the proposal | Include project path, key files, tech stack |
| Too many requirements (10+) | Proposal becomes unfocused | Split into 2-3 separate proposals |
| Implementation details in prompt | Constrains the design prematurely | State the "what" not the "how" |

## Project-Specific Context (kcalvelli-portal)

This section provides the context Claude needs for proposals in the kcalvelli-portal project specifically.

### Project Purpose
Auto-updating engineering portfolio site documenting Keith Calvelli's 15 public GitHub projects with architectural diagrams, onboarding guides, and release information.

### Tech Stack
- MkDocs with Material theme (static site generator)
- Mermaid.js (C4 Context and Component diagrams)
- GitHub CLI (`gh`) for data fetching
- GitHub Pages for hosting
- OpenSpec for spec-driven development

### Key Files
| File | Purpose |
|------|---------|
| `projects.json` | Master project registry (15 projects, 14 tag categories) |
| `OPS_MANUAL.md` | Agent instructions for documentation generation pipeline |
| `ARCHITECTURE.md` | Master architecture reference for Claude Projects |
| `mkdocs.yml` | Site navigation and theme configuration |
| `docs/` | Generated documentation pages (one per project) |
| `docs/index.md` | Landing page with project dashboard (lines 1-14 are protected) |
| `openspec/project.md` | Project goals and non-negotiable rules |
| `openspec/AGENTS.md` | Agent workflows (update command, classification, etc.) |

### Existing Capabilities (Merged Specs)
| Spec | What It Covers |
|------|---------------|
| `github-sync` | Repository discovery, auto-classification, user confirmation, registry update |
| `update-command` | Natural language trigger, workflow orchestration, progress reporting, error handling |
| `master-doc-generation` | ARCHITECTURE.md assembly, output format, Claude Projects formatting |
| `master-doc-content` | Content sections: system context, inventory, MCP topology, patterns, dependencies |
| `pipeline-integration` | Phase 2.5 sequencing, OPS_MANUAL/AGENTS updates, completion summary |

### Update Pipeline Phases
```
Phase 0: Discovery      → GitHub scrape, classify new repos
Phase 1: Preparation    → Read projects.json, update index.md
Phase 2: Processing     → Fetch data per repo, generate docs/<repo>.md
Phase 2.5: Master Doc   → Generate ARCHITECTURE.md from all sources
Phase 3: Finalization   → Update mkdocs.yml, verify links
Phase 4: Completion     → Summary report
```

### Available Tags
`os`, `axios`, `commodore64`, `mcp-server`, `pkgs`, `nix`, `development`, `ai`, `email`, `docs`, `caldav`, `gateway`, `terminal`

### Non-Negotiable Rules
- Lines 1-14 of `docs/index.md` (header, bio, about) are NEVER overwritten
- Every project MUST have at least one tag from `tagDefinitions`
- All project data comes from live GitHub sources (no manual content fabrication)
- Updates are manual-trigger only (user says "update")

## Worked Example: From Prompt to Proposal

### The Prompt
```
Generate Master Architecture Document for Claude Projects

Extend the portal generator to produce a master markdown document alongside
the HTML site -- a single, comprehensive architectural reference file
optimized for upload to Claude Projects.

Key requirements:
1. Generated as a new step in the existing OPS_MANUAL.md pipeline
2. Reads from projects.json, cached repo data, and generated docs/
3. Produces a single deterministic markdown file
4. Content includes: system overview, project inventory, MCP server graph,
   inter-project dependencies, technology stack rationale
5. Markdown formatting optimized for Claude Projects (flat structure,
   no relative links)
6. Regenerated on every portal update (idempotent)
7. Version-controlled in the repo root
```

### What Claude Produced

**Change ID**: `generate-master-architecture-doc` (verb-led, descriptive)

**Artifacts created**:
- `proposal.md` — 200 lines covering problem (fragmented architecture knowledge, no machine-optimized format), infrastructure discovery (3-tier data sources), 6-part solution, scope, UX flow, 5 success criteria, 5 risks with mitigations
- `design.md` — Detailed section-by-section content specification, size budget (15-20KB), determinism rules, Claude Projects formatting constraints, missing data handling strategies
- `tasks.md` — 21 tasks across 5 phases (Pipeline Integration, Content Assembly, Formatting, Spec Finalization, Validation)
- 3 spec deltas: `master-doc-generation`, `master-doc-content`, `pipeline-integration`

**Why this worked well**:
1. The prompt gave 7 numbered requirements — each became a testable criterion
2. "Extend the portal generator" told Claude to integrate with existing pipeline, not build standalone
3. "Optimized for Claude Projects" was specific enough to derive formatting rules (no Mermaid, flat headings, no relative links)
4. "Deterministic" became a formal requirement with its own scenarios
5. Context about existing data sources was brief but sufficient for Claude to discover the rest

## Checklist: Before Submitting a Proposal Prompt

- [ ] Does the prompt start with an action verb? (Add, Automate, Extend, Refactor, etc.)
- [ ] Is the current state described? (What exists today)
- [ ] Are requirements numbered and specific?
- [ ] Is the project/repo context provided? (path, key files, tech stack)
- [ ] Is the scope implicitly or explicitly bounded?
- [ ] Are there fewer than 8 requirements? (Split if more)
- [ ] Does each requirement describe "what" not "how"?
- [ ] Would you know if the change was done correctly from the requirements alone?
