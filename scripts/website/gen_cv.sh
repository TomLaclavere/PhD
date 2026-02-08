#!/usr/bin/env bash
set -euo pipefail

# Repository information
OUT_FILE="website/partials/cv.html"
CURRENT_DATE="$(date +"%Y-%m-%d")"
mkdir -p "$(dirname "$OUT_FILE")"
mkdir -p website/cv

pdf_file="cv/cv_FR.pdf"
cp "$pdf_file" "website/$pdf_file"
filesize="$(stat -c %s "$pdf_file" | numfmt --to=iec)"
last_update="$(git log -1 --format=%cs -- cv 2>/dev/null || echo "$CURRENT_DATE")"

# Generate HTML
cat > "$OUT_FILE" <<EOF
      <div class="card-meta">
        <div class="file-size">
            <i class="fas fa-file-pdf"></i>
            <span>PDF</span>
        </div>
        <div class="file-size">
            <i class="fas fa-hdd"></i>
            <span>$filesize</span>
        </div>
        <div class="meta-item">
            <i class="fas fa-language"></i>
            <span>French</span>
        </div>
        <div>
            <i class="fas fa-calendar"></i>
            <time datetime="$last_update">Updated $last_update</time>
        </div>
      </div>
      <div style="display: flex; gap: 10px;">
          <a href="$pdf_file" class="btn" style="flex: 1"; download>
              <i class="fas fa-download"></i>
              Download
          </a>
          <a href="$pdf_file" class="btn btn-secondary" style="flex: 1;">
              <i class="fas fa-eye"></i>
              Preview 
          </a>
      </div>
EOF