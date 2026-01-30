# Tasks: Generate Master Architecture Document

## Phase 1: Pipeline Integration

- [x] **1.1 Add Phase 2.5 to OPS_MANUAL.md**
  - File: `OPS_MANUAL.md`
  - Add "Phase 2.5: Master Document Generation" section between Phase 2 (Processing) and Phase 3 (Finalization)
  - Document the step-by-step assembly instructions for `ARCHITECTURE.md`:
    1. Read `projects.json` for project registry and tag definitions
    2. Read all `docs/<repo>.md` files for synthesized architecture content
    3. Read cached data files (`*_flake.nix`, `*_readme.md`, `*_files.json`, `*_releases.json`) where available
    4. Assemble `ARCHITECTURE.md` following the section structure in `design.md`
    5. Write file to repository root
  - Include content structure reference (sections, ordering, formatting rules)

- [x] **1.2 Update AGENTS.md update workflow**
  - File: `openspec/AGENTS.md`
  - Added Step 4.5 between Documentation Regeneration and Completion Summary
  - Added brief description of master doc purpose and assembly

- [x] **1.3 Update completion summary format in OPS_MANUAL.md**
  - File: `OPS_MANUAL.md`
  - Added "Master architecture doc: ARCHITECTURE.md (updated)" to Phase 4 completion summary
  - Added variant for partial data: "(updated, N projects with partial data)"

## Phase 2: Content Assembly Instructions

- [x] **2.1 Document System Context assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: project/category counting, core platform identification, subsystem grouping by tag affinity

- [x] **2.2 Document Project Inventory assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: tagDefinitions iteration by order, inventory table per category, tech stack detection, status derivation, fallbacks

- [x] **2.3 Document MCP Server Topology assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: mcp-server tag filtering, description keyword matching, transport/target extraction, gateway aggregation, data flow paths

- [x] **2.4 Document Integration Patterns assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: required patterns (NixOS Module Composition, MCP Bridge/Adapter, Nix Flake Distribution), optional patterns (Streaming Media Pipeline)

- [x] **2.5 Document Technology Decisions assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: decision table format, technology extraction sources, required rows, language detection rules

- [x] **2.6 Document Dependency Graph assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: flake input parsing, tag-based inference, runtime dependency extraction, text tree notation format

- [x] **2.7 Document Maintenance Status assembly rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: status table format, health classification (Active/In Development/Unknown), missing data handling

## Phase 3: Formatting & Constraints

- [x] **3.1 Document Claude Projects formatting rules**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: H4 max depth, no relative links, no Mermaid, explicit cross-references, self-contained content, 15-20KB target

- [x] **3.2 Document header and metadata format**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: header template with ISO 8601 date, project/category counts

- [x] **3.3 Document determinism requirements**
  - File: `OPS_MANUAL.md` (Phase 2.5 section)
  - Included: projects.json array order, tagDefinitions.order sorting, date-only non-determinism

## Phase 4: Spec Finalization

- [x] **4.1 Merge master-doc-generation spec to openspec/specs/**
  - Copied to `openspec/specs/master-doc-generation/spec.md`

- [x] **4.2 Merge master-doc-content spec to openspec/specs/**
  - Copied to `openspec/specs/master-doc-content/spec.md`

- [x] **4.3 Merge pipeline-integration spec to openspec/specs/**
  - Copied to `openspec/specs/pipeline-integration/spec.md`

- [x] **4.4 Update update-command spec with Phase 2.5 reference**
  - File: `openspec/specs/update-command/spec.md`
  - Added step 5.5 to workflow orchestration sequence
  - Added scenario for master doc generation progress reporting

## Phase 5: Validation

- [ ] **5.1 Test master document generation with current data**
  - Run "update" workflow
  - Verify `ARCHITECTURE.md` is generated at repository root
  - Verify all 15 projects appear in the document
  - Verify MCP server topology is correct (5-6 servers)
  - Verify no Mermaid code blocks in output
  - Verify no relative links in output
  - Verify file size is within 15-20KB target

- [ ] **5.2 Verify determinism**
  - Run generation twice with no data changes
  - Compare output (should be identical except generation date)

- [ ] **5.3 Verify Claude Projects usability**
  - Upload `ARCHITECTURE.md` to Claude Projects
  - Test queries: "What MCP servers exist?", "How does axiOS relate to other projects?", "What technology stack is used?"
  - Verify Claude can answer without additional context

- [ ] **5.4 Archive change**
  - Move `openspec/changes/generate-master-architecture-doc/` to `openspec/changes/archive/`
  - Commit all changes

## Task Dependencies

- Phase 2 depends on Phase 1 (pipeline structure must exist before content rules)
- Phase 3 depends on Phase 2 (formatting rules apply to content assembly)
- Phase 4 depends on Phases 1-3 (specs finalized after implementation instructions complete)
- Phase 5 depends on Phase 4 (validate after all specs and instructions are in place)
- Tasks within each phase can run in parallel
