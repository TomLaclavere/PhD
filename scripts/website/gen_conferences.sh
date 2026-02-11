#!/usr/bin/env bash
set -euo pipefail

# Information
PARTIALS_DIR="website/partials/conferences" 
OUT_FILE="website/partials/conferences.html"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"

# Generate each HTML
./scripts/conferences/gen_gdr.sh

# Generate publication HTML
for file in "$PARTIALS_DIR"/*.html; do
    [[ -f "$file" ]] || continue
    
    cat "$file" >> "$OUT_FILE"
    echo -e "\n" >> "$OUT_FILE"  
done
