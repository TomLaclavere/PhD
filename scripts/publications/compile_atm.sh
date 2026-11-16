#!/usr/bin/env bash
# Compile publications/Atm/main.tex into main.pdf (build files in output/)
#   ./compile_atm.sh         compile once
#   ./compile_atm.sh watch   recompile on every save
#   ./compile_atm.sh clean   remove auxiliary files
set -e
cd "$(dirname "$0")/../../publications/Atm"

case "$1" in
    watch) latexmk -pdf -pvc -synctex=1 -interaction=nonstopmode -outdir=output main.tex ;;
    clean) latexmk -c -outdir=output main.tex ;;
    *)     latexmk -pdf -synctex=1 -interaction=nonstopmode -halt-on-error -outdir=output main.tex
           cp output/main.pdf main.pdf
           cp output/main.synctex.gz main.synctex.gz ;;
esac
