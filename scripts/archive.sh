#!/usr/bin/env bash
set -euo pipefail

# Usage: ./archive_dir.sh <input_dir> <output_dir> [archive_name.tar.xz]

INPUT_DIR="${1:?Missing input directory}"
OUTPUT_DIR="${2:?Missing output directory}"
ARCHIVE_NAME="${3:-$(basename "$INPUT_DIR").tar.xz}"

INPUT_DIR="${INPUT_DIR%/}"

mkdir -p "$OUTPUT_DIR"

OUT_TAR="$OUTPUT_DIR/$ARCHIVE_NAME"

if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: '$INPUT_DIR' is not a directory" >&2
  exit 1
fi

tar -cJf "$OUT_TAR" \
  --exclude=".git/*" \
  --exclude="*.aux" \
  --exclude="*.log" \
  --exclude="*.out" \
  --exclude="*.toc" \
  --exclude="*.psd" \
  --exclude="*.xcf" \
  --exclude="*.ai" \
  --exclude="*.synctex.gz" \
  --exclude="*.fdb_latexmk" \
  --exclude="*.fls" \
  "$INPUT_DIR"
