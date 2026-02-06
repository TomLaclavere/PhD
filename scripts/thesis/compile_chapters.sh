#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Compile thesis chapters
# ========================================

mkdir -p thesis/output/chapters
for f in thesis/chapters/*/*.tex ; do
  [ -f "$f" ] || continue
  chapter_dir=$(dirname "$f")
  
  chapter_folder_name=$(basename "$chapter_dir")
  chapter_filename=$(echo "$chapter_folder_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_-]//g')
  
  echo "▶ Building chapter in $chapter_dir → $chapter_filename.pdf"
  
  pushd "$chapter_dir"
  mkdir -p output
  latexmk -quiet -cd -pdf -interaction=nonstopmode \
    -outdir=output \
    -auxdir=output \
    "$chapter_filename.tex"
  popd
  cp thesis/output/chapters/*.pdf thesis/chapters/$chapter_folder_name/
done

# Copy chapters to website
mkdir -p website/thesis/chapters
cp thesis/output/chapters/*.pdf website/thesis/chapters/