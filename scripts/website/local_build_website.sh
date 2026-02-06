# ========================================
# Configuration File for Local Generation
# ========================================

# repository information
export REPO_NAME="PhD"
export GITHUB_USERNAME="TomLaclavere"
export GITHUB_REPOSITORY="$GITHUB_USERNAME/$REPO_NAME"

export OUTPUT_DIR="Thesis/output"
export CHAPTER_DIR="$OUTPUT_DIR/chapters"
export CURRENT_DATE="$(date +"%Y-%m-%d")"

# Compile thesis
./scripts/website/local_gen_thesis.sh

# Compiles chapter
./scripts/website/local_gen_chapters.sh

# Generate website
./scripts/website/build_website.sh