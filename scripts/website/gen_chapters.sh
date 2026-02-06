#!/usr/bin/env bash
set -euo pipefail

OUTPUT_DIR="website/Thesis"
CHAPTER_DIR="$OUTPUT_DIR/chapters"
WEB_DIR="Thesis/chapters"

REPO_NAME="${GITHUB_REPOSITORY#*/}"
CURRENT_DATE="$(date +"%Y-%m-%d")"

chapter_count=$(ls "$CHAPTER_DIR"/chapter*.pdf 2>/dev/null | wc -l || true)

if [ "$chapter_count" -eq 1 ]; then
  chapter_text="chapter"
else
  chapter_text="chapters"
fi

CHAPTERS_HTML=""

for src_dir in Thesis/Chapters/*/main.tex Thesis/chapters/*/main.tex; do
  [ -f "$src_dir" ] || continue

  chapter_dir=$(dirname "$src_dir")
  chapter_name=$(basename "$chapter_dir" | sed 's/_/ /g')

  chapter_folder_name=$(basename "$chapter_dir")
  chapter_filename=$(echo "$chapter_folder_name" | sed 's/ /_/g' | sed 's/[^a-zA-Z0-9_-]//g')
  pdf_file="$CHAPTER_DIR/${chapter_filename}.pdf"

  [ -f "$pdf_file" ] || continue

  fname="$(basename "$pdf_file")"
  filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"

  CHAPTERS_HTML+="
<!-- Chapter: $chapter_name -->
<div class=\"card-grid\">
  <div class=\"card thesis\">
    <div class=\"card-header\">
      <div class=\"card-icon\"><i class=\"fas fa-file-alt\"></i></div>
      <div class=\"card-title\">$REPO_NAME – $chapter_name</div>
    </div>
    <div class=\"card-body\">
      <div class=\"card-description\">
        $chapter_name individual chapter.
      </div>
      <div class=\"card-meta\">
        <div class=\"file-size\">
          <i class=\"fas fa-hdd\"></i>
          <span>$filesize</span>
        </div>
        <div>
          <i class=\"fas fa-calendar\"></i>
          <span>$CURRENT_DATE</span>
        </div>
      </div>
      <div class="btn-group">
            <a href=\"$WEB_DIR/$fname\" class=\"btn btn-block\" download>
                <i class=\"fas fa-download\"></i>
                Download $chapter_name
            </a>

            <a href=\"$WEB_DIR/$fname\" class=\"btn btn-block btn-secondary\" target=\"_blank\" rel=\"noopener\">
                <i class=\"fas fa-eye\"></i>
                Preview $chapter_name
            </a>
        </div>
    </div>
  </div>
</div>
"
done

echo "$CHAPTERS_HTML"
