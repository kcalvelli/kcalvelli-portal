+++
title = "This Portal"
description = "An engineering portfolio built with Zola, Structurizr DSL, and GitHub Actions."
weight = 1

[extra]
hook = "An engineering portfolio with auto-rendered C4 diagrams and content driven from a single catalog."
repo = "kcalvelli/kcalvelli-portal"
language = "Nix · Tera · CSS"
status = "active"
stack = "Zola · Structurizr DSL · GitHub Actions"
+++

## What it does

This is the site you're looking at. It exists so the operator doesn't have to hand-maintain a portfolio when new projects ship. The goals are boring and load-bearing:

- **Diagrams that don't lie.** One Structurizr DSL file (`diagrams/cairn.dsl`) defines the model. Rendered to C4-PlantUML, exported to SVG in CI. No hand-authored diagrams to drift from reality.
- **One catalog, many views.** `projects.json` is the source of truth; templates pull from it to build the landing page and section indexes.
- **Static output, no plugin churn.** Zola ships as a single Rust binary. No MkDocs-style plugin system to rot.

## Architecture

Source of truth:

- `projects.json` — the project catalog with `featured`, `status`, `tags`, and `highlight` fields
- `diagrams/cairn.dsl` — the Structurizr workspace (one model, six views)
- `scripts/render-diagrams.sh` — DSL → C4-PlantUML → SVG, using `nixpkgs#structurizr-cli` and `nixpkgs#plantuml-c4`

CI: on push, the publish Action installs Nix, runs the render script, builds with `zola build`, and deploys to GitHub Pages.

## Why this exists

Because a portfolio that goes stale during a job hunt is worse than no portfolio. Automation is the product.
