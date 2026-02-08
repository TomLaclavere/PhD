#!/usr/bin/env bash
set -euo pipefail

# repository information
OUTPUT_DIR="website/thesis"
CHAPTER_DIR="$OUTPUT_DIR/chapters"
WEB_DIR="thesis/chapters"
OUT_FILE="website/partials/chapters.html"

CURRENT_DATE="$(date +"%Y-%m-%d")"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"   # truncate file

# Generate HTML
for src_tex in thesis/chapters/*/*.tex; do
  [ -f "$src_tex" ] || continue

  chapter_dir="$(dirname "$src_tex")"
  chapter_name="$(basename "$chapter_dir" | sed 's/_/ /g')"
  chapter_slug="$(basename "$chapter_dir" \
  | tr '[:upper:]' '[:lower:]' \
  | sed 's/ /_/g; s/[^a-z0-9_-]//g')"

  pdf_file="$CHAPTER_DIR/${chapter_slug}.pdf"
  [ -f "$pdf_file" ] || continue

  fname="$(basename "$pdf_file")"
  filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"
  src_size="$(du -sh "$chapter_dir" | awk '{print $1}')"
  fig_count="$(find "$chapter_dir" -type f \
  \( -name '*.png' -o -name '*.jpg' -o -name '*.pdf' \) \
  | wc -l | tr -d ' ')"
  last_update="$(git log -1 --format=%cs -- "$chapter_dir" 2>/dev/null || echo "$CURRENT_DATE")"

  cat >> "$OUT_FILE" <<EOF
<!-- Chapter: $chapter_name -->
<div class="card-header">
  <div class="card-icon"><i class="fas fa-file-alt"></i></div>
  <div class="card-title">PhD – $chapter_name</div>
</div>
<div class="card-body">
  <div class="card-description">
    $chapter_name individual chapter.
  </div>
  <div class="card-meta">
    <div>
        <i class="fas fa-file-pdf"></i>
        <span>PDF · $filesize</span>
    </div>
    <div>
        <i class="fas fa-folder-open"></i>
        <span>Sources · $src_size</span>
    </div>
    <div>
        <i class="fas fa-images"></i>
        <span>$fig_count figures</span>
    </div>
    <div>
        <i class="fas fa-clock"></i>
        <time datetime="$last_update">Updated $last_update</time>
    </div>
  </div>
  <div style="display: flex; gap: 10px; margin-bottom: 10px;"">
    <a href="$WEB_DIR/$fname" class="btn" style="flex: 1;" download>
        <i class="fas fa-download"></i>
        Download PDF
    </a>
    <a href="$WEB_DIR/$fname" class="btn btn-secondary" style="flex: 1;">
        <i class="fas fa-eye"></i>
        Preview PDF
    </a>
    </div>
    <div style="display: flex; gap: 10px;">
    <a href="$WEB_DIR/$chapter_slug.zip" class="btn" style="flex: 1;">
        <i class="fas fa-download"></i>
        Download ZIP
    </a>
    <a href="https://github.com/TomLaclavere/PhD/tree/main/thesis/chapters/$chapter_slug" class="btn btn-secondary" style="flex: 1;">
        <i class="fas fa-eye"></i>
        Preview on GitHub
    </a>
    </div>
</div>
EOF
done