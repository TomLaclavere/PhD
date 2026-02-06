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

export REPO_NAME CURRENT_DATE chapter_count chapter_text GITHUB_REPOSITORY

# Generate chapters HTML using directory names from source
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

  CHAPTERS_HTML+="<!-- Chapter: $chapter_name -->
  <div class=\"pdf-card\">
    <div class=\"pdf-card-header\">
      <div class=\"pdf-icon\"><i class=\"fas fa-file-alt\"></i></div>
      <div class=\"pdf-title\">$REPO_NAME – $chapter_name</div>
      <div class=\"pdf-description\">Individual chapter</div>
    </div>
    <div class=\"pdf-card-body\">
      <div class=\"pdf-meta\">
        <span>$filesize</span>
        <span>$fname</span>
      </div>
      <a href=\"chapters/$fname\" class=\"download-btn\">
        <i class=\"fas fa-download\"></i> Download $chapter_name
      </a>
    </div>
  </div>
  "
done

export CHAPTERS_HTML

# Generate final HTML with chapters embedded in the correct location
TEMP_CHAPTERS=$(mktemp)
echo "$CHAPTERS_HTML" > "$TEMP_CHAPTERS"
envsubst < "website/Thesis/thesis.html.in" > "website/Thesis/thesis.html"
sed -i "/<!-- Chapters will be inserted here -->/r $TEMP_CHAPTERS" "website/Thesis/thesis.html"
sed -i "/<!-- Chapters will be inserted here -->/d" "website/Thesis/thesis.html"
rm "$TEMP_CHAPTERS"
