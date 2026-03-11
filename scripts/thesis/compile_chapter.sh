#!/usr/bin/env bash
set -euo pipefail

CHAPTERS_DIR="thesis/chapters"
WEBSITE_DIR="website/thesis/chapters"

mkdir -p "$WEBSITE_DIR"

prefix="${1:?Missing chapter number}"

# Find the chapter directory starting with the given number
chapter_dir=$(find "$CHAPTERS_DIR" -maxdepth 1 -type d -name "${prefix}*" | sort | head -n 1)

[[ -n "$chapter_dir" ]] || { echo "No chapter starting with '$prefix'"; exit 1; }
[[ -d "$chapter_dir" ]] || exit 1

# Taking the first .tex file as the main one
tex_file=$(find "$chapter_dir" -maxdepth 1 -name "*.tex" | head -n 1)
[[ -f "$tex_file" ]] || exit 1

chapter_name="$(basename "$chapter_dir")"
tex_basename="$(basename "$tex_file")"

echo "> Compile Chapter: $chapter_name"

output_dir="$chapter_dir/output"
mkdir -p "$output_dir"

pushd thesis > /dev/null

# Trap for compilation errors
on_error() {
    echo "Chapter compilation failed! Please check logs in $output_dir/$tex_basename"
}

trap on_error ERR

output=$(latexmk -quiet -pdf -cd -interaction=nonstopmode \
        -file-line-error -synctex=1 \
        -outdir=output \
        "../$chapter_dir/$tex_basename" 2>&1)

trap - ERR
popd > /dev/null

if grep -q "Nothing to do" <<< "$output"; then
    echo "Chapter already up to date."
else
    echo "Chapter compiled!"
fi

pdf_file="$output_dir/${tex_basename%.tex}.pdf"

if [[ -f "$pdf_file" ]]; then
    # Copy PDF back to chapter folder
    cp "$pdf_file" "$chapter_dir/"

    # Copy PDF to website
    cp "$pdf_file" "$WEBSITE_DIR/"
fi