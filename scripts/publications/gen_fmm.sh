#!/usr/bin/env bash
set -euo pipefail

# Paper information
NAME="Spectral Imaging with QUBIC: building frequency maps from Time-Ordered-Data using Bolometric Interferometry"
ABSTRACT="This paper presents spectral-imaging with QUBIC, a method to reconstruct sub-frequency CMB polarization maps from time-ordered data, enabling improved foreground mitigation and unbiased estimation of primordial fluctuations through bolometric interferometry."
JOURNAL="JCAP 2026"

# Authors
AUTHORS="M. Regnier, T. Laclavère, et al."

# Path information
PAPER_DIR="publications/FMM"
OUT_FILE="website/partials/publications/FMM.html"
CURRENT_DATE="$(date +"%Y-%m-%d")"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"

# PDF
pdf_file="$(find "$PAPER_DIR" -maxdepth 1 -name '*.pdf' | head -n 1)"
if [[ ! -f "$pdf_file" ]]; then
  echo "No PDF found in $PAPER_DIR"
  exit 1
fi

fname="$(basename "$pdf_file")"
filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"
last_update="$(git log -1 --format=%cs -- "$PAPER_DIR" 2>/dev/null || echo "$CURRENT_DATE")"

# Copy PDF to website
mkdir -p "website/$PAPER_DIR"
cp "$pdf_file" "website/$PAPER_DIR/"

# ZIP archive
./scripts/archive.sh "$PAPER_DIR" "website/$PAPER_DIR"

# Compute optional metadata
src_size=$(du -sh "$PAPER_DIR" 2>/dev/null | awk '{print $1}')
fig_count=$(find "$PAPER_DIR" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.pdf' \) | wc -l)

# HTML generation
cat >> "$OUT_FILE" <<EOF
<div class="card publication">
  <div class="card-header">
    <div class="card-icon">
      <i class="fas fa-file-signature" aria-hidden="true"></i>
    </div>
    <div class="card-title" title="$NAME">$NAME</div>
    <div class="card-subtitle">$AUTHORS</div>
  </div>

  <div class="card-body">
    <div class="card-description">
      $ABSTRACT
    </div>

    <div class="card-meta">
      <div>
        <i class="fas fa-file-pdf" aria-hidden="true"></i>
        <span>PDF · $filesize</span>
      </div>
      <div>
        <i class="fas fa-folder" aria-hidden="true"></i>
        <span>Sources · $src_size</span>
      </div>
      <div>
        <i class="fas fa-images" aria-hidden="true"></i>
        <span>$fig_count figures</span>
      </div>
      <div>
        <i class="fas fa-clock" aria-hidden="true"></i>
        <span>$JOURNAL</span>
      </div>
    </div>

    <div class="btn-group" style="display: flex; gap: 10px; margin-top: 10px;">
      <a href="$pdf_file" class="btn btn-block" download>
        <i class="fas fa-download" aria-hidden="true"></i>
        Download PDF
      </a>

      <a href="$pdf_file" class="btn btn-block btn-secondary" target="_blank" rel="noopener">
        <i class="fas fa-eye" aria-hidden="true"></i>
        Preview PDF
      </a>
    </div>

    <div class="btn-group" style="display: flex; gap: 10px; margin-top: 10px;">
      <a href="$PAPER_DIR/$(basename "$PAPER_DIR").zip" class="btn" style="flex: 1;">
        <i class="fas fa-download" aria-hidden="true"></i>
        Download ZIP
      </a>
      <a href="https://arxiv.org/abs/2409.18698" class="btn btn-secondary" style="flex: 1;" target="_blank" rel="noopener">
        <i class="fas fa-eye" aria-hidden="true"></i>
        Preview on arXiv
      </a>
    </div>
  </div>
</div>
EOF
