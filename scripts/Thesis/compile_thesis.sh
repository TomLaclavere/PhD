#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Compile full Thesis
# ========================================

mkdir -p Thesis/output
if [ -f Thesis/main.tex ]; then
  pushd Thesis
  latexmk -quiet -pdf -interaction=nonstopmode -outdir=output main.tex
  popd
else
  echo "Thesis/main.tex not found — skipping full thesis build"
fi

# Copy to website
cp Thesis/output/main.pdf website/Thesis/main.pdf