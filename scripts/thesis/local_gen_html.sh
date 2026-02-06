#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Configuration File for Local Generation
# ========================================

# repository information
export REPO_NAME="PhD"
export GITHUB_USERNAME="TomLaclavère"
export GITHUB_REPOSITORY="$GITHUB_USERNAME/$REPO_NAME"

export OUTPUT_DIR="thesis/output"
export CHAPTER_DIR="$OUTPUT_DIR/chapters"
export CURRENT_DATE="$(date +"%Y-%m-%d")"

# Compile Full thesis 
mkdir -p thesis/output
if [ -f thesis/thesis.tex ]; then
  pushd thesis
  latexmk -quiet -pdf -interaction=nonstopmode -outdir=output thesis.tex
  popd
else
  echo "thesis/thesis.tex not found — skipping full thesis build"
fi

# Compile chapters
mkdir -p thesis/output/chapters
for f in thesis/chapters/*/thesis.tex thesis/chapters/*/thesis.tex; do
  [ -f "$f" ] || continue
  chapter_dir=$(dirname "$f")
  
  chapter_folder_name=$(basename "$chapter_dir")
  chapter_filename=$(echo "$chapter_folder_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_-]//g')
  
  echo "▶ Building chapter in $chapter_dir → $chapter_filename.pdf"
  
  pushd "$chapter_dir"
  latexmk -quiet -pdf -interaction=nonstopmode \
    -outdir=../../output/chapters \
    -jobname="$chapter_filename" thesis.tex
  popd
  
done

# Generate index.html from template
./scripts/thesis/gen_html.sh