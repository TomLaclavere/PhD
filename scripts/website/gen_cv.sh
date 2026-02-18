#!/usr/bin/env bash
set -euo pipefail

OUT_FILE="website/partials/cv.html"
CURRENT_DATE="$(date +"%Y-%m-%d")"

mkdir -p "$(dirname "$OUT_FILE")"
mkdir -p website/cv

generate_card() {
  local pdf_file="$1"
  local language="$2"
  local title="$3"

  if [[ ! -f "$pdf_file" ]]; then
    echo "Warning: $pdf_file not found"
    return
  fi

  # Copy PDF
  cp "$pdf_file" "website/$pdf_file"

  # Metadata
  filesize="$(stat -c %s "$pdf_file" | numfmt --to=iec)"
  last_update="$(git log -1 --format=%cs -- "$pdf_file" 2>/dev/null || echo "$CURRENT_DATE")"

  cat >> "$OUT_FILE" <<EOF
<div class="card cv">
    <div class="card-header">
        <div class="card-icon">
            <i class="fas fa-file-contract"></i>
        </div>
        <div class="card-title">$title</div>
        <div class="card-subtitle">Complete Professional Profile</div>
    </div>

    <div class="card-body">
        <div class="card-description">
            Detailed curriculum vitae including education, research experience, publications, skills, and academic achievements.
        </div>

        <div class="card-meta">
            <div class="file-size">
                <i class="fas fa-file-pdf"></i>
                <span>PDF · $filesize</span>
            </div>

            <div class="meta-item">
                <i class="fas fa-language"></i>
                <span>$language</span>
            </div>

            <div>
                <i class="fas fa-calendar"></i>
                <time datetime="$last_update">Updated $last_update</time>
            </div>
        </div>

        <div class="btn-group" style="display:flex; gap:10px;">
            <a href="$pdf_file" class="btn" style="flex:1;" download>
                <i class="fas fa-download"></i>
                Download
            </a>

            <a href="$pdf_file" class="btn btn-secondary" style="flex:1;" target="_blank" rel="noopener">
                <i class="fas fa-eye"></i>
                Preview
            </a>
        </div>
    </div>
</div>

EOF
}

# Reset file
: > "$OUT_FILE"

# Generate both cards
generate_card "cv/cv_FR.pdf" "French" "CV – Version Française"
generate_card "cv/cv_EN.pdf" "English" "CV – English Version"

