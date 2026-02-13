#!/usr/bin/env bash
set -euo pipefail

### Information on repository file
OUT_FILE="website/partials/github_file.html"

last_update="$(git log -1 --format=%cs -- . 2>/dev/null || echo "$CURRENT_DATE")"

# Copy GitHub info
cp README.md website/
cp LICENCE.md website/
cp CITATION.cff website/

cat >> "$OUT_FILE" <<EOF
<p style="margin-top: 10px; font-size: 0.85rem;">
    <i class="fas fa-sync-alt"></i> Last updated: <span id="last-updated">$last_update</span>
</p>
EOF

### Information on github repositories
OUT_FILE="website/partials/github/github.html"
PARTIALS_DIR="website/partials/github" 

# Generate each HTML
./scripts/github/gen_3dpe.sh
./scripts/github/gen_qubic.sh
./scripts/github/gen_phd.sh

# Build HTML
for file in "$PARTIALS_DIR"/*.html; do
    [[ -f "$file" ]] || continue
    
    cat "$file" >> "$OUT_FILE"
    echo -e "\n" >> "$OUT_FILE"  
done