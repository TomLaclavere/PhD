#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="Thesis/output"
CHAPTER_DIR="$OUTPUT_DIR/chapters"

REPO_NAME="${GITHUB_REPOSITORY#*/}"
CURRENT_DATE="$(date +"%Y-%m-%d")"

chapter_count=$(ls "$CHAPTER_DIR"/chapter*.pdf 2>/dev/null | wc -l || true)

if [ "$chapter_count" -eq 1 ]; then
  chapter_text="chapter"
else
  chapter_text="chapters"
fi

export REPO_NAME CURRENT_DATE chapter_count chapter_text

# Base HTML
envsubst < "$OUTPUT_DIR/index.html.in" > "$OUTPUT_DIR/index.html"

# Append chapters
index=1
for f in "$CHAPTER_DIR"/chapter*.pdf; do
  [ -f "$f" ] || continue

  fname="$(basename "$f")"
  filesize="$(ls -lh "$f" | awk '{print $5}')"

  cat >> "$OUTPUT_DIR/index.html" <<EOF

<!-- Chapter $index -->
<div class="pdf-card">
  <div class="pdf-card-header">
    <div class="pdf-icon"><i class="fas fa-file-alt"></i></div>
    <div class="pdf-title">$REPO_NAME – Chapter $index</div>
    <div class="pdf-description">Individual chapter</div>
  </div>
  <div class="pdf-card-body">
    <div class="pdf-meta">
      <span>$filesize</span>
      <span>$fname</span>
    </div>
    <a href="chapters/$fname" class="download-btn">
      <i class="fas fa-download"></i> Download Chapter $index
    </a>
  </div>
</div>
EOF

  index=$((index + 1))
done
