#!/usr/bin/env bash
set -euo pipefail

CHAPTERS_DIR="thesis/chapters"
WEBSITE_DIR="website/thesis/chapters"

mkdir -p "$WEBSITE_DIR"

prefix="${1:?Missing chapter number}"

# Find the chapter directory starting with the given prefix
chapter_dir=$(find "$CHAPTERS_DIR" -maxdepth 1 -mindepth 1 -type d -name "${prefix}*" | sort | head -n 1)

[[ -n "$chapter_dir" ]] || { echo "No chapter starting with '$prefix'"; exit 1; }

chapter_basename="$(basename "$chapter_dir")"

# Enforce convention: <chapter_dir>/<chapter_dir>.tex
tex_file="$chapter_dir/$chapter_basename.tex"

if [[ ! -f "$tex_file" ]]; then
    echo "Expected main TeX file '$tex_file' not found." >&2
    echo "Ensure each chapter follows the convention:" >&2
    echo "  <chapter_dir>/<chapter_dir>.tex" >&2
    exit 1
fi

chapter_name="$chapter_basename"
tex_basename="$(basename "$tex_file")"

echo "> Compile Chapter: $chapter_name"

output_dir="$chapter_dir/output"
mkdir -p "$output_dir"

pushd thesis > /dev/null

on_error() {
    echo "Chapter compilation failed! Please check logs in $output_dir/$tex_basename"
}

trap on_error ERR

output=$(latexmk -quiet -pdf -cd -interaction=nonstopmode \
        -file-line-error -synctex=1 \
        -outdir=output \
        "../$tex_file" 2>&1)

trap - ERR
popd > /dev/null

if grep -q "Nothing to do" <<< "$output"; then
    echo "Chapter already up to date."
else
    echo "Chapter compiled!"
fi

pdf_file="$output_dir/${tex_basename%.tex}.pdf"

if [[ -f "$pdf_file" ]]; then
    cp "$pdf_file" "$chapter_dir/"
    cp "$pdf_file" "$WEBSITE_DIR/"
fi