#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Compile thesis chapters
# ========================================

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

# Copy chapters to website
mkdir -p website/Thesis/chapters
cp Thesis/output/chapters/*.pdf website/Thesis/chapters/