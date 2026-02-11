#!/usr/bin/env bash
set -euo pipefail

CONF_DIR="conferences"
PUB_DIR="publications"
THESIS_FILE="website/thesis/thesis.pdf"
OUT_FILE="website/partials/stats.html"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"

# Count only first-level non-hidden directories
conference_count=$(find "$CONF_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".*" | wc -l | tr -d ' ')
publication_count=$(find "$PUB_DIR" -mindepth 1 -maxdepth 1 -type d ! -name ".*" | wc -l | tr -d ' ')

# Plural helper
plural() {
    [[ "$1" -gt 1 ]] && echo "s" || echo ""
}

# Thesis block
if [[ -f "$THESIS_FILE" ]]; then
    thesis_block='
<a href="#thesis" class="stat-link">
    <div class="stat-item">
        <i class="fas fa-file-alt stat-icon"></i>
        <div>
            <div style="font-weight: 600;">Complete Thesis</div>
            <div style="font-size: 0.9rem;">Available for download</div>
        </div>
    </div>
</a>'
else
    thesis_block=""
fi

# Generate HTML
cat >> "$OUT_FILE" <<EOF
<a href="#conferences" class="stat-link">
    <div class="stat-item">
        <i class="fas fa-microphone-alt stat-icon"></i>
        <div>
            <div style="font-weight: 600;" id="conference-count">
                ${conference_count} Conference$(plural "$conference_count")
            </div>
            <div style="font-size: 0.9rem;">Presentations & Talks</div>
        </div>
    </div>
</a>

<a href="#publications" class="stat-link">
    <div class="stat-item">
        <i class="fas fa-newspaper stat-icon"></i>
        <div>
            <div style="font-weight: 600;" id="publication-count">
                ${publication_count} Publication$(plural "$publication_count")
            </div>
            <div style="font-size: 0.9rem;">Papers & Articles</div>
        </div>
    </div>
</a>

$thesis_block

<div class="stats">
    <div class="stat-item">
        <i class="fab fa-github stat-icon"></i>
        <div>
            <div style="font-weight: 600;">5 Repositories</div>
            <div style="font-size: 0.9rem;">Including Thesis & Analysis</div>
        </div>
    </div>
    <div class="stat-item">
        <i class="fas fa-code-branch stat-icon"></i>
        <div>
            <div style="font-weight: 600;">42 Commits</div>
            <div style="font-size: 0.9rem;">In the last year</div>
        </div>
    </div>
</div>
EOF
