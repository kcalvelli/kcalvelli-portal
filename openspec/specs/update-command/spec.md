# Capability: Update Command

## Overview

Enable a natural language "update" trigger that initiates the full portal synchronization workflow within Claude Code.

## ADDED Requirements

### Requirement: Command Recognition
The system SHALL recognize "update" as a trigger to initiate portal synchronization when said in the kcalvelli-portal repository context.

#### Scenario: Recognize update keyword
**Given** the user is in the `kcalvelli-portal` repository
**When** the user says "update"
**Then** the portal update workflow is initiated

#### Scenario: Recognize variations
**Given** the user is in the `kcalvelli-portal` repository
**When** the user says "update portal", "update the portal", or "run update"
**Then** the portal update workflow is initiated

#### Scenario: Ignore in other contexts
**Given** the user mentions "update" in a general conversation
**When** discussing something unrelated to the portal workflow
**Then** the update workflow is NOT automatically triggered

---

### Requirement: Workflow Orchestration
The system SHALL execute a complete portal update following a defined sequence.

#### Scenario: Full update workflow
**Given** the update command is triggered
**When** the workflow executes
**Then** the following steps occur in order:
1. GitHub Discovery Phase
2. New Repository Classification (if any new repos)
3. User Confirmation (if any new repos)
4. Project Registry Update (if confirmed)
5. Documentation Regeneration (per OPS_MANUAL.md)
6. Navigation Update
7. Completion Summary

#### Scenario: No new repositories
**Given** the update command is triggered
**And** no new repositories are found
**When** the workflow executes
**Then** steps 2-4 are skipped
**And** documentation is regenerated for existing projects

#### Scenario: User cancels new repos
**Given** new repositories are presented for confirmation
**When** the user skips all of them
**Then** the workflow continues with documentation regeneration
**And** skipped repos remain undocumented

---

### Requirement: Progress Reporting
The system SHALL provide clear progress updates during the update workflow.

#### Scenario: Discovery progress
**Given** the update workflow is running
**When** GitHub discovery completes
**Then** the user sees "Scanning GitHub... Found X public repositories"

#### Scenario: Classification progress
**Given** new repositories are identified
**When** classification is performed
**Then** the user sees "Found Y new repos not in portfolio"
**And** suggested classifications are displayed

#### Scenario: Regeneration progress
**Given** documentation regeneration is running
**When** each project is processed
**Then** the user sees progress (e.g., "Processing axios-dav... 3/14")

#### Scenario: Completion summary
**Given** the workflow completes
**When** all steps are finished
**Then** the user sees a summary:
- Number of new projects added
- Number of documentation pages updated
- Confirmation that mkdocs.yml was updated

---

### Requirement: Error Handling
The system SHALL handle errors gracefully during the update workflow.

#### Scenario: GitHub API failure
**Given** the GitHub CLI fails to retrieve repositories
**When** the error is caught
**Then** the user sees an error message
**And** the workflow stops
**And** existing documentation is NOT modified

#### Scenario: Invalid projects.json
**Given** `projects.json` cannot be parsed
**When** the workflow attempts to read it
**Then** the user sees a validation error
**And** the workflow stops before making changes

#### Scenario: Partial failure during regeneration
**Given** documentation regeneration fails for one project
**When** the error is caught
**Then** the user sees which project failed
**And** the workflow continues with remaining projects
**And** the failed project is noted in the completion summary

## Constraints

- The update workflow runs synchronously (user waits for completion)
- No scheduled/automated triggers (manual only)
- Requires authenticated `gh` CLI
- Network connectivity required for GitHub API and repo data fetching
