# This Portal

An auto-updating engineering portfolio with GitHub discovery, Structurizr diagrams, and CI-driven content.

**Repository:** [kcalvelli/kcalvelli-portal](https://github.com/kcalvelli/kcalvelli-portal) · **Stack:** MkDocs Material + Structurizr DSL + GitHub Actions

## What it does

This is the site you're looking at. It exists so the operator doesn't have to hand-maintain a portfolio when new projects ship. The goals are boring and load-bearing:

- **Discovery.** A scheduled GitHub Action queries `gh repo list kcalvelli`, diffs against `projects.json`, and opens a PR for new or archived repos.
- **Diagrams that don't lie.** One Structurizr DSL file (`diagrams/cairn.dsl`) defines the model. Rendered to C4-PlantUML, exported to SVG in CI. No hand-authored diagrams to drift from reality.
- **Content that doesn't rot.** Per-project pages are regenerated from cached READMEs, so the prose never gets more than a week stale.

## Architecture

Source of truth:

- `projects.json` — the project catalog with `featured`, `status`, `tags`, and `highlight` fields
- `diagrams/cairn.dsl` — the Structurizr workspace (one model, six views)
- `scripts/render-diagrams.sh` — DSL → C4-PlantUML → SVG, using `nixpkgs#structurizr-cli` and `nixpkgs#plantuml-c4`

CI:

- On push, `mkdocs gh-deploy` builds and publishes
- On schedule (planned), a discovery Action refreshes the catalog and opens a PR

## Why this exists

Because a portfolio that goes stale during a job hunt is worse than no portfolio. Automation is the product.
