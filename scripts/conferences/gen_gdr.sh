#!/usr/bin/env bash
set -euo pipefail

# Paper information
NAME="Spectral Imaging with QUBIC: Component separation methods using Bolometric Interferometry"
ABSTRACT="This presentation introduces QUBIC, a bolometric interferometer designed to detect CMB B-modes by combining high-sensitivity bolometers with interferometric control of systematics. It introduces two spectral-imaging–based component separation methods, Frequency Map-Making (FMM) and Component Map-Making (CMM), which exploit the instrument’s intrinsic spectral resolution to enhance foreground mitigation and improve cosmological constraints."
CONFERENCE="GDR CoPhy"
LOCATION="15 April 2025, ENS Paris"

# Path information
PAPER_DIR="conferences/GDR_CoPhy"
OUT_FILE="website/partials/conferences/GDR_CoPhy.html"

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

# Copy PDF to website
mkdir -p "website/$PAPER_DIR"
cp "$pdf_file" "website/$PAPER_DIR/"

# ODP
odp_file="$(find "$PAPER_DIR" -maxdepth 1 -name '*.odp' | head -n 1)"
if [[ ! -f "$odp_file" ]]; then
  echo "No ODP found in $PAPER_DIR"
  exit 1
fi
odpsize="$(ls -lh "$odp_file" | awk '{print $5}')"

# Copy ODP to website
cp "$odp_file" "website/$PAPER_DIR/"

# HTML generation
cat >> "$OUT_FILE" <<EOF
<div class="card conference">
  <div class="card-header">
    <div class="card-icon">
      <i class="fas fa-file-signature" aria-hidden="true"></i>
    </div>
    <div class="card-title" title="$NAME">$NAME</div>
  </div>

  <div class="card-body">
    <div class="card-description">
      $ABSTRACT
    </div>

    <div class="card-meta">

      <div class="meta-item">
        <i class="fas fa-file-pdf"></i>
        <span><strong>PDF</strong> · $filesize</span>
      </div>

      <div class="meta-item">
        <i class="fas fa-file-powerpoint"></i>
        <span><strong>ODP</strong> · $odpsize</span>
      </div>

      <div class="meta-item">
        <i class="fas fa-map-marker-alt"></i>
        <span>$LOCATION</span>
      </div>

      <div class="meta-item">
        <i class="fas fa-calendar-alt"></i>
        <span>$CONFERENCE</span>
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
      <a href="$PAPER_DIR/$(basename "$PAPER_DIR").odp" class="btn" style="flex: 1;">
        <i class="fas fa-download" aria-hidden="true"></i>
        Download ODP
      </a>
      <a href="https://indico.ijclab.in2p3.fr/event/11301/contributions/37280/" class="btn btn-secondary" style="flex: 1;" target="_blank" rel="noopener">
        <i class="fas fa-eye" aria-hidden="true"></i>
        Preview on Indico
      </a>
    </div>
  </div>
</div>
EOF
