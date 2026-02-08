#!/usr/bin/env bash
set -euo pipefail

# Repository information
OUTPUT_DIR="website/publications"
WEB_DIR="publications"
OUT_FILE="website/partials/publications.html"
CURRENT_DATE="$(date +"%Y-%m-%d")"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"  

# Generate HTML
for paper_dir in "$WEB_DIR"/*/; do
    [[ -d "$paper_dir" ]] || continue
    
    paper_name="$(basename "$paper_dir" | sed 's/_/ /g')"

    # Find PDF in folder
    pdf_file=$(find "$paper_dir" -maxdepth 1 -name "*.pdf" | head -n 1)
    [ -f "$pdf_file" ] || { echo "No PDF found in $paper_dir, skipping"; continue; }
    fname="$(basename "$pdf_file")"

    filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"
    src_size="$(du -sh "$paper_dir" | awk '{print $1}')"
    fig_count="$(find "$paper_dir" -type f \( -name '*.png' -o -name '*.jpg' -o -name '*.pdf' \) | wc -l | tr -d ' ')"
    last_update="$(git log -1 --format=%cs -- "$paper_dir" 2>/dev/null || echo "$CURRENT_DATE")"

    cat >> "$OUT_FILE" <<EOF
<div class="card publication">
    <div class="card-header">
        <div class="card-icon">
            <i class="fas fa-file-signature"></i>
        </div>
        <div class="card-title">$paper_name</div>
        <div class="card-subtitle">Author(s)</div>
    </div>
    <div class="card-body">
        <div class="card-description">
            Short abstract or description of the paper goes here.
        </div>
        <div style="display: flex; gap: 10px; margin-bottom: 10px;">
            <a href="$pdf_file" class="btn" style="flex: 1;" download>
                <i class="fas fa-download"></i>
                Download PDF
            </a>
            <a href="$pdf_file" class="btn btn-secondary" style="flex: 1;">
                <i class="fas fa-eye"></i>
                Preview PDF
            </a>
        </div>
    </div>
</div>
EOF
done
