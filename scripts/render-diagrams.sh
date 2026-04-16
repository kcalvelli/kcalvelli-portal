#!/usr/bin/env bash
# Render Structurizr DSL → C4-PlantUML → SVG into docs/diagrams/.
# Requires structurizr-cli and plantuml (with C4 bundled) on PATH.
# Enter the devshell first: `nix develop`

set -euo pipefail

# The Nix-packaged structurizr-cli bundles OpenJDK 21. Its launch script
# honors $JAVA_HOME over $PATH, so if the environment has JAVA_HOME set
# to an older JDK (which GitHub's ubuntu-latest runner does — JDK 17 by
# default), the CLI fails with UnsupportedClassVersionError. Clear it
# so the wrapper's PATH ordering wins.
unset JAVA_HOME

cd "$(dirname "$0")/.."

DSL="diagrams/cairn.dsl"
TMP="diagrams/out"
DEST="static/diagrams"

rm -rf "$TMP"
mkdir -p "$TMP" "$DEST"

echo ">>> Exporting DSL to C4-PlantUML..."
structurizr-cli export \
    -workspace "$DSL" \
    -format plantuml/c4plantuml \
    -output "$TMP"

echo ">>> Rendering PUML to SVG..."
(cd "$TMP" && plantuml -tsvg ./*.puml)

echo ">>> Copying to $DEST/ with clean names..."
declare -A RENAMES=(
    [structurizr-Landscape.svg]=cairn-landscape.svg
    [structurizr-CairnContext.svg]=cairn-context.svg
    [structurizr-CairnContainers.svg]=cairn-containers.svg
    [structurizr-GatewayComponents.svg]=gateway-components.svg
    [structurizr-CompanionComponents.svg]=companion-components.svg
    [structurizr-ReferenceDeployment.svg]=cairn-deployment.svg
)

for src in "${!RENAMES[@]}"; do
    dst="${RENAMES[$src]}"
    cp "$TMP/$src" "$DEST/$dst"
    echo "  $src → $DEST/$dst"
done

echo ">>> Done. $(ls "$DEST" | wc -l) diagrams in $DEST/"
