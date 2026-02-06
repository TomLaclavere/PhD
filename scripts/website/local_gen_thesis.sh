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
export CURRENT_DATE="$(date +"%Y-%m-%d")"

# Compile Full Thesis 
./scripts/Thesis/compile_thesis.sh

# Generate index.html from template
./scripts/website/gen_thesis.sh