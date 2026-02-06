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
mkdir -p Thesis/output
if [ -f Thesis/main.tex ]; then
  pushd Thesis
  latexmk -quiet -pdf -interaction=nonstopmode -outdir=output main.tex
  popd
else
  echo "Thesis/main.tex not found — skipping full thesis build"
fi

# Generate index.html from template
./scripts/website/gen_thesis.sh