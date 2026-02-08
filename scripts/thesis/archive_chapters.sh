#!/usr/bin/env bash
set -euo pipefail

# Config
CHAPTERS_DIR="thesis/chapters"
OUTPUT_DIR="website/thesis/chapters"
ARCHIVER="./scripts/archive.sh"

# Checks
[[ -d "$CHAPTERS_DIR" ]] || { echo "$CHAPTERS_DIR not found"; exit 1; }
[[ -x "$ARCHIVER" ]] || { echo "archive.sh not executable"; exit 1; }

mkdir -p "$OUTPUT_DIR"

# Archive each chapter
for chapter_path in "$CHAPTERS_DIR"/*; do
    [[ -d "$chapter_path" ]] || continue

    chapter_name="$(basename "$chapter_path")"
    archive_name="${chapter_name}.zip"

    "$ARCHIVER" \
        "$chapter_path" \
        "$OUTPUT_DIR" \
        "$archive_name"
done

