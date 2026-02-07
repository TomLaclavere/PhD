#!/usr/bin/env bash
set -euo pipefail

REPO_NAME="${GITHUB_REPOSITORY#*/}"
CURRENT_DATE="$(date +"%Y-%m-%d")"

export REPO_NAME CURRENT_DATE GITHUB_REPOSITORY

# ========================================
# Generate Sections
# ========================================

THESIS_HTML="$(./scripts/website/gen_thesis.sh)"
CHAPTERS_HTML="$(./scripts/website/gen_chapters.sh)"

export THESIS_HTML CHAPTERS_HTML

# ========================================
# Generate Archives
# ========================================
./scripts/archive.sh thesis/ website/thesis

# ========================================
# Generate Pages
# ========================================

# ========================================
# Build HTML
# ========================================
echo "> Generate Website"

envsubst < website/website.html.in > website/website.html
