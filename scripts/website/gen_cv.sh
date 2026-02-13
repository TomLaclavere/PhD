#!/usr/bin/env bash
set -euo pipefail

# Repository information
OUT_FILE="website/partials/cv.html"
CURRENT_DATE="$(date +"%Y-%m-%d")"
mkdir -p "$(dirname "$OUT_FILE")"
mkdir -p website/cv

pdf_file_fr="cv/cv_FR.pdf"
cp "$pdf_file_fr" "website/$pdf_file_fr"
filesize_fr="$(stat -c %s "$pdf_file_fr" | numfmt --to=iec)"
last_update_fr="$(git log -1 --format=%cs -- cv 2>/dev/null || echo "$CURRENT_DATE")"

pdf_file_en="cv/cv_EN.pdf"
cp "$pdf_file_en" "website/$pdf_file_en"
filesize_en="$(stat -c %s "$pdf_file_en" | numfmt --to=iec)"
last_update_en="$(git log -1 --format=%cs -- cv 2>/dev/null || echo "$CURRENT_DATE")"

# Generate HTML
cat > "$OUT_FILE" <<EOF
<div class="card-meta">
<div class="file-size">
    <i class="fas fa-file-pdf"></i>
    <span>PDF</span>
</div>
<div class="file-size">
    <i class="fas fa-hdd"></i>
    <span>$filesize_fr</span>
</div>
<div class="meta-item">
    <i class="fas fa-language"></i>
    <span>French</span>
</div>
<div>
    <i class="fas fa-calendar"></i>
    <time datetime="$last_update_fr">Updated $last_update_fr</time>
</div>
</div>
<div style="display: flex; gap: 10px;">
    <a href="$pdf_file_fr" class="btn" style="flex: 1"; download>
        <i class="fas fa-download"></i>
        Download
    </a>
    <a href="$pdf_file_fr" class="btn btn-secondary" style="flex: 1;">
        <i class="fas fa-eye"></i>
        Preview 
    </a>
</div>

<div class="card-meta">
<div class="file-size">
    <i class="fas fa-file-pdf"></i>
    <span>PDF</span>
</div>
<div class="file-size">
    <i class="fas fa-hdd"></i>
    <span>$filesize_en</span>
</div>
<div class="meta-item">
    <i class="fas fa-language"></i>
    <span>French</span>
</div>
<div>
    <i class="fas fa-calendar"></i>
    <time datetime="$last_update_en">Updated $last_update_en</time>
</div>
</div>
<div style="display: flex; gap: 10px;">
    <a href="$pdf_file_en" class="btn" style="flex: 1"; download>
        <i class="fas fa-download"></i>
        Download
    </a>
    <a href="$pdf_file_en" class="btn btn-secondary" style="flex: 1;">
        <i class="fas fa-eye"></i>
        Preview 
    </a>
</div>
EOF