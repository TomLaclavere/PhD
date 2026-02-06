#!/usr/bin/env bash
set -euo pipefail

# ========================================
# Compile full thesis
# ========================================

mkdir -p thesis/output
if [ -f thesis/thesis.tex ]; then
  pushd thesis
  latexmk -quiet -pdf -interaction=nonstopmode -outdir=output thesis.tex
  popd
else
  echo "thesis/thesis.tex not found — skipping full thesis build"
fi

# Copy to website
cp thesis/output/thesis.pdf website/thesis/thesis.pdf