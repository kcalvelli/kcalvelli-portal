# Capability: Pipeline Integration

## Overview

Integrate `ARCHITECTURE.md` generation into the existing portal update workflow, ensuring it runs at the correct phase and is reported in the completion summary.

## ADDED Requirements

### Requirement: Pipeline Sequencing
The master document generation step SHALL execute after all per-project documentation is generated (Phase 2) and before finalization (Phase 3).

#### Scenario: Correct execution order
**Given** the portal update workflow is running
**When** Phase 2 (Processing) completes for all projects
**Then** Phase 2.5 (Master Document Generation) executes
**And** Phase 2.5 completes before Phase 3 (Finalization) begins

#### Scenario: Dependencies on Phase 2 output
**Given** Phase 2.5 needs to read `docs/<repo>.md` files
**When** Phase 2.5 starts
**Then** all `docs/<repo>.md` files from Phase 2 exist and are up-to-date
**And** `projects.json` reflects any new projects added in Phase 0

---

### Requirement: OPS_MANUAL.md Update
The system SHALL add Phase 2.5 instructions to `OPS_MANUAL.md`.

#### Scenario: New phase documentation
**Given** `OPS_MANUAL.md` documents Phases 0-4
**When** the pipeline integration change is applied
**Then** a new "Phase 2.5: Master Document Generation" section is added between Phase 2 and Phase 3
**And** the section describes the assembly steps for `ARCHITECTURE.md`
**And** the section references `design.md` content structure

---

### Requirement: AGENTS.md Update
The system SHALL update `AGENTS.md` to include master document generation in the update workflow.

#### Scenario: Update workflow steps
**Given** `AGENTS.md` documents a 5-step update workflow (Discovery → Classification → Registry → Documentation → Summary)
**When** the pipeline integration change is applied
**Then** a step for master document generation is added after Documentation Regeneration
**And** the step is described as: "Generate ARCHITECTURE.md from assembled data"

---

### Requirement: Completion Summary Update
The completion summary SHALL report master document generation status.

#### Scenario: Successful generation
**Given** `ARCHITECTURE.md` was generated successfully
**When** the completion summary is displayed
**Then** it includes a line: "Master architecture doc: ARCHITECTURE.md (updated)"

#### Scenario: Generation with gaps
**Given** `ARCHITECTURE.md` was generated but some projects lacked cached data
**When** the completion summary is displayed
**Then** it includes: "Master architecture doc: ARCHITECTURE.md (updated, N projects with partial data)"

---

### Requirement: Idempotent Regeneration
The master document generation SHALL be idempotent — re-running produces the same result without side effects.

#### Scenario: Repeated runs
**Given** `ARCHITECTURE.md` already exists from a previous update
**When** the update workflow runs again with no data changes
**Then** `ARCHITECTURE.md` is overwritten with identical content
**And** no other files are affected by the master document generation step

#### Scenario: Incremental data improvement
**Given** a previous run generated `ARCHITECTURE.md` with 6 projects having full cached data
**And** a new update run caches data for 3 additional projects
**When** the master document generation step executes
**Then** `ARCHITECTURE.md` reflects the newly available data for those 3 projects
**And** previously complete project sections remain unchanged

## Constraints

- Phase 2.5 does NOT modify any `docs/<repo>.md` files or `projects.json`
- Phase 2.5 does NOT add `ARCHITECTURE.md` to `mkdocs.yml` navigation
- Phase 2.5 reads from the filesystem only; no additional network calls
- The update command recognition ("update", "update portal") does NOT change — master doc generation is automatic as part of the existing trigger

## Related Capabilities

- **Update Command** (`openspec/specs/update-command/spec.md`): Phase 2.5 extends the workflow orchestration requirement
- **GitHub Repository Sync** (`openspec/specs/github-sync/spec.md`): New projects discovered in Phase 0 appear in the master document
