#!/usr/bin/env bash
# Render Structurizr DSL → C4-PlantUML → SVG into docs/diagrams/.
# Uses nixpkgs#structurizr-cli and nixpkgs#plantuml-c4 on demand.

set -euo pipefail

cd "$(dirname "$0")/.."

DSL="diagrams/cairn.dsl"
TMP="diagrams/out"
DEST="docs/diagrams"

mkdir -p "$TMP" "$DEST"

echo ">>> Exporting DSL to C4-PlantUML..."
nix run nixpkgs#structurizr-cli -- export \
    -workspace "$DSL" \
    -format plantuml/c4plantuml \
    -output "$TMP"

echo ">>> Rendering PUML to SVG..."
(cd "$TMP" && nix run nixpkgs#plantuml-c4 -- -tsvg ./*.puml)

echo ">>> Copying to docs/diagrams/ with clean names..."
declare -A RENAMES=(
    [structurizr-Landscape.svg]=cairn-landscape.svg
    [structurizr-CairnContext.svg]=cairn-context.svg
    [structurizr-CairnContainers.svg]=cairn-containers.svg
    [structurizr-GatewayComponents.svg]=gateway-components.svg
    [structurizr-CompanionComponents.svg]=companion-components.svg
    [structurizr-ProductionDeployment.svg]=cairn-deployment.svg
)

for src in "${!RENAMES[@]}"; do
    dst="${RENAMES[$src]}"
    cp "$TMP/$src" "$DEST/$dst"
    echo "  $src → docs/diagrams/$dst"
done

echo ">>> Done. $(ls "$DEST" | wc -l) diagrams in $DEST/"
