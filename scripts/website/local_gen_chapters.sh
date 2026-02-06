#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Configuration File for Local Generation
# ========================================

# repository information
export REPO_NAME="PhD"
export GITHUB_USERNAME="TomLaclavère"
export GITHUB_REPOSITORY="$GITHUB_USERNAME/$REPO_NAME"

export OUTPUT_DIR="Thesis/output"
export CHAPTER_DIR="$OUTPUT_DIR/chapters"
export CURRENT_DATE="$(date +"%Y-%m-%d")"

# Compile Chapters
./scripts/Thesis/compile_chapters.sh

# Generate index.html from template
./scripts/website/gen_chapters.sh