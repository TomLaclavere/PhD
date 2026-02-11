#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Compile LaTeX
# ========================================
echo "-> Compile LaTeX files"
./scripts/thesis/compile_thesis.sh
./scripts/thesis/compile_chapters.sh

# ========================================
# Generate Archives
# ========================================
echo "-> Generate archives"
./scripts/archive.sh thesis/ website/thesis
./scripts/thesis/archive_chapters.sh

# ========================================
# Generate Sections
# ========================================

echo "-> Generate HTML sections"
./scripts/website/gen_publications.sh
./scripts/website/gen_thesis.sh
./scripts/website/gen_chapters.sh
./scripts/website/gen_cv.sh
./scripts/website/gen_conferences.sh
./scripts/website/gen_stats.sh
./scripts/website/gen_github.sh

# ========================================
# Generate Pages
# ========================================
echo "-> Assemble website"

export STATS_HTML="$(< website/partials/stats.html)"
export PUBLICATIONS_HTML="$(< website/partials/publications.html)"
export THESIS_HTML="$(< website/partials/thesis.html)"
export CHAPTERS_HTML="$(< website/partials/chapters.html)"
export CV_HTML="$(< website/partials/cv.html)"
export CONFERENCES_HTML="$(< website/partials/conferences.html)"
export GITHUB_HTML="$(< website/partials/github/github.html)"
export GITHUB_FILE_HTML="$(< website/partials/github_file.html)"

rm -rf website/partials

# ========================================
# Build HTML
# ========================================
echo "-> Generate website"

envsubst < website/website.html.in > website/website.html

echo "Website generated: website/website.html"

