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
mkdir -p Thesis/output/chapters
for f in Thesis/Chapters/*/main.tex Thesis/chapters/*/main.tex; do
  [ -f "$f" ] || continue
  chapter_dir=$(dirname "$f")
  
  chapter_folder_name=$(basename "$chapter_dir")
  chapter_filename=$(echo "$chapter_folder_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_-]//g')
  
  echo "▶ Building chapter in $chapter_dir → $chapter_filename.pdf"
  
  pushd "$chapter_dir"
  latexmk -quiet -pdf -interaction=nonstopmode \
    -outdir=../../output/chapters \
    -jobname="$chapter_filename" main.tex
  popd
  
done

# Generate index.html from template
./scripts/website/gen_chapters.sh