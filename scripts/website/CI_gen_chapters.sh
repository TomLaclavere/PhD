#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="website/thesis"
CHAPTER_DIR="$OUTPUT_DIR/chapters"
WEB_DIR="thesis/chapters"
OUT_FILE="website/partials/chapters.html"

REPO_NAME="${GITHUB_REPOSITORY#*/}"
CURRENT_DATE="$(date +"%Y-%m-%d")"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"   # truncate file

for src_tex in thesis/chapters/*/*.tex; do
  [ -f "$src_tex" ] || continue

  chapter_dir="$(dirname "$src_tex")"
  chapter_name="$(basename "$chapter_dir" | sed 's/_/ /g')"
  chapter_slug="$(basename "$chapter_dir" | sed 's/[^a-zA-Z0-9_-]//g')"

  pdf_file="$CHAPTER_DIR/${chapter_slug}.pdf"
  [ -f "$pdf_file" ] || continue

  filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"
  fname="$(basename "$pdf_file")"

  cat >> "$OUT_FILE" <<EOF
<!-- Chapter: $chapter_name -->
<div class="card-grid">
  <div class="card thesis">
    <div class="card-header">
      <div class="card-icon"><i class="fas fa-file-alt"></i></div>
      <div class="card-title">$REPO_NAME – $chapter_name</div>
    </div>
    <div class="card-body">
      <div class="card-description">
        $chapter_name individual chapter.
      </div>
      <div class="card-meta">
        <div class="file-size">
          <i class="fas fa-hdd"></i>
          <span>$filesize</span>
        </div>
        <div>
          <i class="fas fa-calendar"></i>
          <span>$CURRENT_DATE</span>
        </div>
      </div>
      <div class="btn-group">
        <a href="$WEB_DIR/$fname" class="btn btn-block" download>
          Download $chapter_name
        </a>
        <a href="$WEB_DIR/$fname" class="btn btn-block btn-secondary" target="_blank" rel="noopener">
          Preview $chapter_name
        </a>
      </div>
    </div>
  </div>
</div>
EOF
done
