#!/usr/bin/env bash
set -euo pipefail

# Information
PARTIALS_DIR="website/partials/publications" 
OUT_FILE="website/partials/publications.html"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"

# Generate each HTML
./scripts/publications/gen_cmm.sh
./scripts/publications/gen_fmm.sh
./scripts/publications/gen_moriond2024.sh

# Generate publication HTML
for file in "$PARTIALS_DIR"/*.html; do
    [[ -f "$file" ]] || continue
    
    cat "$file" >> "$OUT_FILE"
    echo -e "\n" >> "$OUT_FILE"  
done
