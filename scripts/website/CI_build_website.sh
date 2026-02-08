#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${GITHUB_REPOSITORY#*/}"
CURRENT_DATE="$(date +"%Y-%m-%d")"

export REPO_NAME CURRENT_DATE GITHUB_REPOSITORY

# ========================================
# Generate Sections
# ========================================

echo "> Generate HTML sections"
./scripts/website/gen_thesis.sh
./scripts/website/gen_chapters.sh

# ========================================
# Generate Archives
# ========================================
echo "> Generate archives"
./scripts/archive.sh thesis/ website/thesis

# ========================================
# Generate Pages
# ========================================
echo "> Assemble website"

export THESIS_HTML="$(< website/partials/thesis.html)"
export CHAPTERS_HTML="$(< website/partials/chapters.html)"

rm -rf website/partials

# ========================================
# Build HTML
# ========================================
echo "> Generate website"

envsubst < website/website.html.in > website/website.html

echo "Website generated: website/website.html"

