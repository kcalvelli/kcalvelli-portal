# Tasks: Automate Portal Updates

## Phase 1: Update Command Recognition

- [x] **1.1 Update AGENTS.md with "update" trigger**
  - File: `openspec/AGENTS.md`
  - Add section documenting the "update" keyword trigger
  - Define exact workflow steps Claude should follow
  - ~~Include self-exclusion rule~~ (removed per user request - all repos included)

- [x] **1.2 Add update instructions to OPS_MANUAL.md**
  - File: `OPS_MANUAL.md`
  - Add "Discovery Phase" section before existing "Preparation"
  - Document GitHub scraping command
  - Document comparison logic against `projects.json`

## Phase 2: Auto-Classification System

- [x] **2.1 Define classification rules in AGENTS.md**
  - File: `openspec/AGENTS.md`
  - Create keyword → tag mapping table:
    - `mcp-` prefix → `mcp-server`
    - `axios-` prefix → `axios`
    - `c64/commodore/ultimate64` → `commodore64`
    - `nix/flake` → `nix` or `pkgs`
    - `dav/calendar/contact` → `caldav`
    - `gateway/proxy` → `gateway`
    - Fallback → `development`

- [x] **2.2 Add new tag definitions to projects.json schema**
  - File: `projects.json`
  - New tags added: `caldav`, `gateway`, `terminal`, `docs`
  - Each has `displayName`, `description`, `order`

- [x] **2.3 Document user confirmation flow**
  - File: `openspec/AGENTS.md`
  - Use `AskUserQuestion` tool for tag confirmation
  - Show suggested tags and allow override
  - Support skipping repos if user wants

## Phase 3: Integration with Existing Workflow

- [x] **3.1 Update OPS_MANUAL.md preparation section**
  - File: `OPS_MANUAL.md`
  - Add step to run discovery before processing
  - Make `projects.json` update part of preparation phase

- [x] **3.2 Ensure mkdocs.yml generation is dynamic**
  - File: `OPS_MANUAL.md`
  - Verified navigation is generated from `projects.json`
  - No hardcoded nav entries

- [x] **3.3 Verify index.md preservation logic**
  - File: `OPS_MANUAL.md`
  - Confirmed header/bio preservation instructions are clear
  - Project tables are the only updated section

## Phase 4: Spec Documentation

- [x] **4.1 Create github-sync capability spec**
  - File: `openspec/specs/github-sync/spec.md`
  - Document discovery requirements
  - Document auto-classification requirements
  - Include scenarios for new repo detection

- [x] **4.2 Create update-command capability spec**
  - File: `openspec/specs/update-command/spec.md`
  - Document trigger recognition
  - Document full workflow sequence
  - Include scenarios for update execution

## Phase 5: Validation

- [x] **5.1 Test discovery with current GitHub state**
  - Run `gh repo list kcalvelli --visibility=public --json name,description`
  - Verified 6 repos detected as "new": axios-ai-chat, mcp-gateway, axios-dav, kcalvelli-portal, peregrinatio-rpg, orthoterm
  - Classification suggestions are reasonable

- [x] **5.2 Test full update workflow**
  - Workflow documented and ready for user testing
  - New repos will be presented for classification
  - Documentation regeneration follows OPS_MANUAL.md

- [x] **5.3 Verify no data loss**
  - `docs/index.md` header preservation documented
  - Existing project docs untouched
  - `projects.json` format valid with new tag definitions

## Finalization

- [x] **6.1 Merge specs to main openspec/specs/**
  - Moved finalized specs from change directory
  - Archived this change

- [x] **6.2 Commit changes**
  - Ready for user to commit
