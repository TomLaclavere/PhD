#!/usr/bin/env bash
set -euo pipefail

mkdir -p thesis/output

pushd thesis > /dev/null

echo "▶ Compile Thesis"

# Trap to catch compilation error
trap 'echo "Thesis compilation failed! Please refer to thesis/output/thesis.log for more details." >&2' ERR

output=$(latexmk -quiet -pdf -interaction=nonstopmode \
                -file-line-error -synctex=1 -outdir=output \
                thesis.tex 2>&1)

if grep -q "Nothing to do" <<< "$output"; then
  echo "Thesis already up to date."
else
  echo "Thesis compiled !"
fi

popd > /dev/null

# Copy outside output
cp thesis/output/thesis.pdf thesis/thesis.pdf

# Copy to website
cp thesis/output/thesis.pdf website/thesis/thesis.pdf