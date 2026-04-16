#!/usr/bin/env bash
# Portfolio drift detector.
#
# Queries GitHub for the current public, non-archived repo list under the
# configured user. Diffs against projects.json. For new repos, appends a
# stub entry and creates a placeholder content page. For repos that have
# disappeared (archived or deleted), removes the entry and its content
# page.
#
# Exits 0 in all cases. If drift was detected, writes a summary to
# $GITHUB_OUTPUT (drift=true|false, summary=markdown string) so the CI
# workflow can decide whether to open a PR.
#
# Requires on PATH: gh, jq (both in the Nix devshell).

set -euo pipefail

cd "$(dirname "$0")/.."

USER="kcalvelli"
CATALOG="projects.json"
CONTENT_DIR="content"

# ---------------------------------------------------------------------------
# Fetch current GitHub state
# ---------------------------------------------------------------------------

echo ">>> Querying GitHub for current public repos..."
gh repo list "$USER" --visibility=public --limit 100 \
    --json name,description,primaryLanguage,pushedAt,isArchived,repositoryTopics \
    > /tmp/gh_repos.json

# Filter out archived repos and extract normalized list
jq '[.[] | select(.isArchived == false)]' /tmp/gh_repos.json > /tmp/gh_active.json

github_repos=$(jq -r '.[].name' /tmp/gh_active.json | sort)
catalog_repos=$(jq -r '.projects[].repo | split("/")[1]' "$CATALOG" | sort)

new_repos=$(comm -13 <(echo "$github_repos") <(echo "$catalog_repos") || true)
missing_repos=$(comm -23 <(echo "$github_repos") <(echo "$catalog_repos") || true)

# Wait, those are reversed. comm -23: lines unique to file1 (catalog), -13: unique to file2 (github)
# Let me reorder: new = in github not in catalog = comm -13 <(catalog) <(github)
new_repos=$(comm -13 <(echo "$catalog_repos") <(echo "$github_repos") || true)
missing_repos=$(comm -23 <(echo "$catalog_repos") <(echo "$github_repos") || true)

if [ -z "$new_repos" ] && [ -z "$missing_repos" ]; then
    echo ">>> No drift detected. Portfolio is current."
    if [ -n "${GITHUB_OUTPUT:-}" ]; then
        echo "drift=false" >> "$GITHUB_OUTPUT"
    fi
    exit 0
fi

echo ">>> Drift detected."
echo "    New repos: $(echo "$new_repos" | grep -c . || true)"
echo "    Missing repos: $(echo "$missing_repos" | grep -c . || true)"

# ---------------------------------------------------------------------------
# Classification heuristic
# ---------------------------------------------------------------------------
# Picks a section slug for a new repo. Not perfect; the PR body flags
# auto-classifications so the reviewer can move the file if wrong.
classify() {
    local name="$1"
    local desc="${2:-}"
    local combined
    combined=$(echo "$name $desc" | tr '[:upper:]' '[:lower:]')

    case "$combined" in
        *"mcp"*|*"companion"*|*"sentinel"*|*"assistant"*|*"agent"*)
            echo "ai" ;;
        *"chat"*|*"mail"*|*"dav"*|*"xmpp"*)
            echo "communication" ;;
        *"c64"*|*"commodore"*|*"ultimate64"*|*"vic-ii"*)
            echo "retro" ;;
        *"ortho"*|*"saint"*|*"liturg"*|*"placemat"*)
            echo "orthodox" ;;
        *"rpg"*|*"tabletop"*|*"peregrinat"*)
            echo "orthodox" ;;
        *)
            echo "platform" ;;
    esac
}

# Title-case a repo name for display
displayname() {
    local name="$1"
    # Start with the raw name; apply known special cases
    case "$name" in
        Ultimate64MCP) echo "Ultimate64 MCP" ;;
        *)
            # Replace dashes with spaces, title-case words
            echo "$name" | tr '-' ' ' | awk '{
                for (i=1; i<=NF; i++) {
                    $i = toupper(substr($i,1,1)) substr($i,2)
                }
                print
            }'
            ;;
    esac
}

# ---------------------------------------------------------------------------
# Apply changes
# ---------------------------------------------------------------------------

summary=""
summary+="## Portfolio drift detected\n\n"

# --- Additions ---
if [ -n "$new_repos" ]; then
    summary+="### New repositories (${new_repos:+$(echo "$new_repos" | grep -c .)})\n\n"
    summary+="These repos exist on GitHub but weren't in \`projects.json\`. I've added stubs; review the section placement and content.\n\n"

    while IFS= read -r name; do
        [ -z "$name" ] && continue

        # Idempotency guard: skip if already present (shouldn't happen given
        # the diff above, but protects against re-runs with uncommitted state)
        if jq -e --arg repo "$USER/$name" \
               '.projects | map(.repo) | contains([$repo])' \
               "$CATALOG" > /dev/null; then
            echo "    ! $name already in catalog, skipping"
            continue
        fi

        # Fetch metadata
        repo_data=$(jq --arg n "$name" '.[] | select(.name == $n)' /tmp/gh_active.json)
        description=$(echo "$repo_data" | jq -r '.description // ""')
        language=$(echo "$repo_data" | jq -r '.primaryLanguage.name // "Unknown"')

        section=$(classify "$name" "$description")
        display=$(displayname "$name")
        slug=$(echo "$name" | tr '[:upper:]' '[:lower:]')

        echo "    + $name → $section/$slug.md"

        # Append to projects.json
        jq --arg repo "$USER/$name" \
           --arg name "$display" \
           --arg desc "$description" \
           --arg section "$section" \
           --arg lang "$language" \
           '.projects += [{
               repo: $repo,
               displayName: $name,
               description: $desc,
               tags: [$section],
               status: "early",
               needs_review: true
           }]' "$CATALOG" > "$CATALOG.tmp"
        mv "$CATALOG.tmp" "$CATALOG"

        # Create content stub
        mkdir -p "$CONTENT_DIR/$section"
        target="$CONTENT_DIR/$section/$slug.md"
        cat > "$target" <<EOF
+++
title = "$display"
description = "$description"
weight = 99

[extra]
hook = "$description"
repo = "$USER/$name"
language = "$language"
status = "early"
stack = "$language"
needs_review = true
+++

<!-- Auto-generated by scripts/discover.sh. Review section placement,
     expand the body from the repo's README, and remove the
     needs_review flag when finished. -->

## What it does

Auto-generated stub. See the [repository](https://github.com/$USER/$name) for the current README.
EOF

        summary+="- **$display** (\`$USER/$name\`, $language) → placed in \`$section/\`\n"
        if [ -n "$description" ]; then
            summary+="  - $description\n"
        fi
    done <<< "$new_repos"
    summary+="\n"
fi

# --- Removals ---
if [ -n "$missing_repos" ]; then
    summary+="### Removed or archived (${missing_repos:+$(echo "$missing_repos" | grep -c .)})\n\n"
    summary+="These were in \`projects.json\` but are no longer public on GitHub (archived or deleted). I've removed them from the catalog and deleted their content pages.\n\n"

    while IFS= read -r name; do
        [ -z "$name" ] && continue

        # Find section from catalog entry before removing
        section=$(jq -r --arg repo "$USER/$name" \
            '.projects[] | select(.repo == $repo) | .tags[0] // "platform"' \
            "$CATALOG")

        echo "    - $name (was in $section/)"

        # Remove from projects.json
        jq --arg repo "$USER/$name" \
           '.projects |= map(select(.repo != $repo))' \
           "$CATALOG" > "$CATALOG.tmp"
        mv "$CATALOG.tmp" "$CATALOG"

        # Delete content page if present
        slug=$(echo "$name" | tr '[:upper:]' '[:lower:]')
        target="$CONTENT_DIR/$section/$slug.md"
        if [ -f "$target" ]; then
            rm "$target"
            summary+="- **$name** — removed \`$target\`\n"
        else
            summary+="- **$name** — removed catalog entry (no content page found)\n"
        fi
    done <<< "$missing_repos"
    summary+="\n"
fi

summary+="---\n\n*Opened automatically by the discovery workflow. Review, adjust, and merge when ready.*\n"

# ---------------------------------------------------------------------------
# Emit outputs for the workflow
# ---------------------------------------------------------------------------

# Write the summary to a file so the workflow can pass it to gh pr create
# via --body-file, avoiding multi-line string escaping in $GITHUB_OUTPUT.
SUMMARY_FILE="${GITHUB_WORKSPACE:-.}/discovery-summary.md"
printf '%b' "$summary" > "$SUMMARY_FILE"

if [ -n "${GITHUB_OUTPUT:-}" ]; then
    echo "drift=true" >> "$GITHUB_OUTPUT"
    echo "summary_file=$SUMMARY_FILE" >> "$GITHUB_OUTPUT"
fi

echo ">>> Done. Summary written to $SUMMARY_FILE"
echo ">>> See diff for changes."
