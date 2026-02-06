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
./scripts/archive.sh Thesis/ website/Thesis

# ========================================
# Generate Pages
# ========================================

# ========================================
# Build HTML
# ========================================

envsubst < website/website.html.in > website/website.html
