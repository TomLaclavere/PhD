#!/usr/bin/env bash
set -euo pipefail

CHAPTERS_DIR="thesis/chapters"
WEBSITE_DIR="website/thesis/chapters"

mkdir -p "$WEBSITE_DIR"

for chapter_dir in "$CHAPTERS_DIR"/*/; do
  [[ -d "$chapter_dir" ]] || continue

  # Taking the first .tex file as the main one
  tex_file=$(find "$chapter_dir" -maxdepth 1 -name "*.tex" | head -n 1)
  [[ -f "$tex_file" ]] || continue

  chapter_name="$(basename "$chapter_dir")"
  tex_basename="$(basename "$tex_file")"

  echo "▶ Compile Chapter: $chapter_name"

  pushd "$chapter_dir" > /dev/null

  mkdir -p output

  # Trap to catch compilation error
  trap 'echo "Thesis compilation failed! Please refer to $chapter_dir output/$tex_basename.log for more details." >&2' ERR

  output=$(latexmk -quiet -pdf -interaction=nonstopmode \
                  -file-line-error -synctex=1 \
                  -outdir=output \
                  "$tex_basename" 2>&1)

  if grep -q "Nothing to do" <<< "$output"; then
    echo "  Chapter already up to date."
  else
    echo "  Chapter compiled!"
  fi

  pdf_file="output/${tex_basename%.tex}.pdf"

  popd > /dev/null

  if [[ -f "$chapter_dir$pdf_file" ]]; then
    # Copy outside output
    cp "$chapter_dir$pdf_file" "$chapter_dir/"

    # Copy to website
    cp "$chapter_dir$pdf_file" "$WEBSITE_DIR/"
  fi

  
done
