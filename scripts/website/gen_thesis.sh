#!/usr/bin/env bash
set -euo pipefail

# repository information
OUT_FILE="website/partials/thesis.html"
mkdir -p "$(dirname "$OUT_FILE")"

pdf_file="thesis/thesis.pdf"
THESIS_SRC_DIR="thesis"
CURRENT_DATE="$(date +"%Y-%m-%d")"

filesize="$(stat -c %s "$pdf_file" | numfmt --to=iec)"
src_size="$(du -sh "$THESIS_SRC_DIR" | awk '{print $1}')"
tex_count="$(find "$THESIS_SRC_DIR" -name '*.tex' | wc -l | tr -d ' ')"
file_count="$(find "$THESIS_SRC_DIR" -type f | wc -l | tr -d ' ')"
fig_count="$(find "$THESIS_SRC_DIR" -type f \( -name '*.png' -o -name '*.jpg' -o ! -path "$pdf_file" \) | wc -l | tr -d ' ')"
chapter_count="$(find "$THESIS_SRC_DIR/chapters" -mindepth 1 -maxdepth 1 -type d | wc -l | tr -d ' ')"
last_update="$(git log -1 --format=%cs -- thesis 2>/dev/null || echo "$CURRENT_DATE")"

# Generate HTML
cat > "$OUT_FILE" <<EOF
<div class="card thesis">
    <div class="card-header">
        <div class="card-icon">
            <i class="fas fa-book"></i>
        </div>
        <div class="card-title">Complete Thesis</div>
        <div class="card-subtitle">PhD Thesis</div>
    </div>
    <div class="card-body">
        <div class="card-description">
            Complete PhD Thesis document including all chapters, references, and appendices.
        </div>
        <div class="card-meta">
            <div class="file-size">
                <i class="fas fa-file-pdf"></i>
                <span>PDF</span>
            </div>
            <div>
                <i class="fas fa-hdd"></i>
                <span>$filesize</span>
            </div>
            <div>
                <i class="fas fa-book"></i>
                <span>$chapter_count chapters</span>
            </div>
            <div>
                <i class="fas fa-clock"></i>
                <time datetime="$last_update">Updated $last_update</time>
            </div>
        </div>
        <div style="display: flex; gap: 10px;">
            <a href="$pdf_file" class="btn" style="flex: 1;" download>
                <i class="fas fa-download"></i>
                Download
            </a>
            <a href="$pdf_file" class="btn btn-secondary" style="flex: 1;">
                <i class="fas fa-eye"></i>
                Preview 
            </a>
        </div>
    </div>
</div>
<div class="card thesis">
    <div class="card-header">
        <div class="card-icon">
        <i class="fas fa-folder-open"></i>
        </div>
        <div class="card-title">Thesis Source Files</div>
        <div class="card-subtitle">LaTeX Source Code</div>
    </div>

    <div class="card-body">
        <div class="card-description">
        Complete LaTeX source files including chapters, figures, and custom packages used in the thesis.
        </div>

        <div class="card-meta">
            <div>
                <i class="fas fa-hdd"></i>
                <span>${src_size}</span>
            </div>
            <div>
                <i class="fas fa-layer-group"></i>
                <span>${file_count} files</span>
            </div>
            <div>
                <i class="fas fa-images"></i>
                <span>${fig_count} figures</span>
            </div>
            <div>
                <i class="fas fa-clock"></i>
                <time datetime="$last_update">Updated $last_update</time>
            </div>
        </div>

        <div class="btn-group">
        <div style="display: flex; gap: 10px;">
            <a href="thesis/thesis.zip" class="btn" style="flex: 1;">
                <i class="fas fa-download"></i>
                Download ZIP
            </a>
            <a href="https://github.com/TomLaclavere/PhD/tree/main/thesis" class="btn btn-secondary" style="flex: 1;">
                <i class="fas fa-eye"></i>
                Preview on GitHub
            </a>
        </div>
    </div>
</div>

EOF
