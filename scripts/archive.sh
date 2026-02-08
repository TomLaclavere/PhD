#!/usr/bin/env bash
set -euo pipefail

# Usage: ./archive_dir.sh <input_dir> <output_dir> [archive_name.zip]

INPUT_DIR="${1:?Missing input directory}"
OUTPUT_DIR="${2:?Missing output directory}"
ARCHIVE_NAME="${3:-$(basename "$INPUT_DIR").zip}"

INPUT_DIR="${INPUT_DIR%/}"

mkdir -p "$OUTPUT_DIR"

OUT_ZIP="$OUTPUT_DIR/$ARCHIVE_NAME"

if [ ! -d "$INPUT_DIR" ]; then
  echo "Error: '$INPUT_DIR' is not a directory" >&2
  exit 1
fi

zip -q -r "$OUT_ZIP" "$INPUT_DIR" \
  -x "**/.git/**" "**/*.aux" "**/*.log" "**/*.out" "**/*.toc"