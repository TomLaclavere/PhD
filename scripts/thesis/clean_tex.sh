#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Check for --pdf flag
REMOVE_PDF=false
for arg in "$@"; do
  case "$arg" in
    --pdf|-p)
      REMOVE_PDF=true
      ;;
  esac
done

echo "LaTeX cleaning in : $ROOT_DIR"

# LaTeX classical extensions
LATEX_EXTENSIONS=(
  aux bbl bcf blg run.xml log
  toc out lof lot
  fls fdb_latexmk
  synctex.gz
  maf
)

# Cleaning thesis root (excluding Figures)
echo "-> Thesis cleaning"
for ext in "${LATEX_EXTENSIONS[@]}"; do
  find "$ROOT_DIR/thesis" -maxdepth 1 -type f -name "*.${ext}" -delete
done

# minitoc files in root
find "$ROOT_DIR/thesis" -maxdepth 1 -type f -name "*.mtc*" -delete

# Recursive cleaning in chapters/
CHAPTERS_DIR="$ROOT_DIR/thesis/chapters"
if [[ -d "$CHAPTERS_DIR" ]]; then
  echo "-> Chapters cleaning recursively"

  for ext in "${LATEX_EXTENSIONS[@]}"; do
    find "$CHAPTERS_DIR" -type f -name "*.${ext}" -delete
  done

  find "$CHAPTERS_DIR" -type f -name "*.mtc*" -delete
fi

# Cleaning output folders (all output/ recursively)
echo "-> Removing output folders"
find "$ROOT_DIR/thesis" -type d -name output -exec rm -rf {} +

if $REMOVE_PDF; then
  echo "-> Removing generated PDFs"

  # Chapters PDFs (excluding Figures directories)
  if [[ -d "$CHAPTERS_DIR" ]]; then
    find "$CHAPTERS_DIR" \
      -path "*/Figures/*"  -o \
      -type f -name "*.pdf" -delete
  fi

  # Thesis root PDFs (excluding Figures)
  find "$ROOT_DIR/thesis" -maxdepth 1 \
    -path "$ROOT_DIR/thesis/Figures/*"  -o \
    -type f -name "*.pdf" -delete

  # Website PDFs (also safe exclude)
  WEBSITE_DIR="$ROOT_DIR/website"
  if [[ -d "$WEBSITE_DIR" ]]; then
    find "$WEBSITE_DIR" \
      -path "*/Figures/*"  -o \
      -type f -name "*.pdf" -delete
  fi
fi

echo "Cleaning done!"
