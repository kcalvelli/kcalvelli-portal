# Project: kcalvelli-portal

## Goal
Maintain an auto-updating engineering portfolio site that documents Keith Calvelli's public GitHub projects with architectural diagrams, onboarding guides, and release information.

## System Overview
This is a static documentation site built with MkDocs Material that showcases public GitHub repositories. The portal scrapes repository metadata, READMEs, and release information to generate standardized documentation pages with Mermaid architecture diagrams.

Key files:
- `projects.json` - Master list of projects with display names, tags, and diagram types
- `OPS_MANUAL.md` - Agent instructions for documentation generation
- `mkdocs.yml` - Site navigation and theme configuration
- `docs/` - Generated documentation pages

## User Types
1. **Portfolio Viewers**: Visitors exploring Keith's projects and technical capabilities
2. **Keith (Maintainer)**: Updates the portal when new projects are added or existing ones change

## Tech Stack
- **Static Site Generator**: MkDocs with Material theme
- **Diagrams**: Mermaid.js (C4 Context and Component diagrams)
- **Data Sources**: GitHub API via `gh` CLI
- **Hosting**: GitHub Pages

## Constitution & Non-Negotiable Rules

### Content Guidelines
- **Preserve Personalization**: The index.md header, bio, and "About My Work" sections MUST NOT be overwritten during updates
- **Factual Accuracy**: All project descriptions and releases come from live GitHub data
- **Tag Classification**: Every project MUST have at least one tag from `tagDefinitions`

### Update Process
- Updates are triggered manually by running "update" in Claude Code
- New repositories are discovered by scraping `gh repo list kcalvelli --visibility=public`
- All public repos are included (including this portal itself)
- Existing projects are refreshed with latest README and release data
