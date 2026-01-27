# Engineering Portal

Auto-updating portfolio site with GitHub discovery and architectural documentation.

## Overview

This repository contains the source for Keith Calvelli's engineering portfolio - a static documentation site built with MkDocs Material that showcases public GitHub projects with architectural diagrams, onboarding guides, and release information.

**Repository:** [kcalvelli/kcalvelli-portal](https://github.com/kcalvelli/kcalvelli-portal)

## Architecture

```mermaid
C4Component
    title Engineering Portal - Component Diagram

    Container_Boundary(portal, "Engineering Portal") {
        Component(projects, "projects.json", "JSON", "Project registry with tags and metadata")
        Component(ops, "OPS_MANUAL.md", "Markdown", "Agent instructions for documentation generation")
        Component(docs, "docs/", "Markdown", "Generated documentation pages")
        Component(mkdocs, "mkdocs.yml", "YAML", "Site configuration and navigation")
    }

    System_Ext(github, "GitHub API", "Repository data source")
    System_Ext(claude, "Claude Code", "AI assistant for updates")
    Person(user, "Portfolio Viewer", "Visits the documentation site")

    Rel(claude, projects, "Reads/updates", "JSON")
    Rel(claude, github, "Scrapes repos", "gh CLI")
    Rel(claude, docs, "Generates", "Markdown + Mermaid")
    Rel(ops, claude, "Instructs", "Agent workflow")
    Rel(user, docs, "Views", "HTTPS")

    UpdateElementStyle(portal, $bgColor="#1168bd")
```

**Key Components:**
- **projects.json** - Master registry of all documented projects with display names, descriptions, tags, and diagram types
- **OPS_MANUAL.md** - Detailed instructions for the documentation generation workflow
- **OpenSpec** - Spec-driven development framework for managing changes

## Onboarding

### Prerequisites
- Nix with flakes enabled
- GitHub CLI (`gh`) authenticated

### Build the Site

```bash
# Enter development environment
nix develop

# Serve locally
mkdocs serve

# Build static site
mkdocs build
```

### Update the Portal

When in Claude Code, simply say "update" to:
1. Discover new public repositories from GitHub
2. Auto-classify with tag suggestions
3. Regenerate all documentation pages
4. Update navigation

## Release History

No releases yet.
