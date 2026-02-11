#!/usr/bin/env bash
set -euo pipefail

# Information
GITHUB_USER="TomLaclavere"
AUTHOR=$GITHUB_USER
REPO_NAME="3DPhysicsEngine"
OUT_FILE="website/partials/github/3dpe.html"

mkdir -p "$(dirname "$OUT_FILE")"
: > "$OUT_FILE"

# Find information on repo
repo_json=$(curl -s "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME")

if [[ $(echo "$repo_json" | jq 'has("message")') == "true" ]]; then
    echo "Error : Repo not find or private."
    exit 1
fi

# Extract information
name=$(echo "$repo_json" | jq -r '.name')
desc=$(echo "$repo_json" | jq -r '.description // "No description"')
size=$(echo "$repo_json" | jq -r '.size')
branch=$(echo "$repo_json" | jq -r '.default_branch')
updated=$(echo "$repo_json" | jq -r '.updated_at')
url=$(echo "$repo_json" | jq -r '.html_url')
language=$(echo "$repo_json" | jq -r '.language')
updated_fmt=$(date -d "$updated" +"%d %b %Y")

# commits count
tmpfile=$(mktemp)

branches=$(curl -s \
  "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/branches?per_page=100" \
  | jq -r '.[].name')

for branch in $branches; do
    page=1
    while :; do
        commits=$(curl -s \
          "https://api.github.com/repos/$GITHUB_USER/$REPO_NAME/commits?sha=$branch&per_page=100&page=$page")

        count=$(echo "$commits" | jq 'length')
        [[ "$count" -eq 0 ]] && break

        echo "$commits" | jq -r '.[].sha' >> "$tmpfile"

        page=$((page + 1))
    done
done

commit_count=$(sort -u "$tmpfile" | wc -l)

rm "$tmpfile"

# Generate HTML
cat >> "$OUT_FILE" <<EOF
<div class="card github">
    <div class="card-header github-card-header">
        <div class="card-icon"><i class="fab fa-github"></i></div>
        <div class="card-title"><a>$name</a></div>
    </div>
    <div class="card-body">
        <div class="card-description">
            $desc
        </div>
        <div class="card-meta">
            <div>
                <i class="fas fa-hdd"></i>
                <span>Size: ${size} KB</span>
            </div>
            <div>
                <i class="fas fa-code"></i>
                <span>${language}</span></div>
            <div>
                 <i class="fas fa-clipboard-list"></i>
                <span>${commit_count} commits</span>
            </div>
            <div>
                <i class="fas fa-clock"></i>
                <time datetime="$updated_fmt">Updated $updated_fmt</time>
            </div>
        </div>
        <a href="https://github.com/TomLaclavere/PhD" class="btn" target="_blank">
            View on GitHub <i class="fab fa-github"></i>
        </a>
    </div>
</div>
EOF