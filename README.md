# PhD

[![PhD Thesis](https://img.shields.io/badge/PhD-Thesis-blue?style=flat)](https://tomlaclavere.github.io/PhD/index.html)
[![License: CC-BY-4.0](https://img.shields.io/badge/License-CC--BY--4.0-lightgrey?style=flat)](https://creativecommons.org/licenses/by/4.0/legalcode)
[![GitHub Repo Size](https://img.shields.io/github/repo-size/tomlaclavere/PhD?style=flat)](https://github.com/tomlaclavere/PhD)
[![Last Commit](https://img.shields.io/github/last-commit/tomlaclavere/PhD?style=flat)](https://github.com/tomlaclavere/PhD/commits/main)

Repository to store my PhD work for QUBIC Instrument. It includes my Thesis, publications, presentations and others.

# LaTeX Thesis – Build Instructions

## Requirements

- **LaTeX** (TeX Live recommended)
- **Biber** (modern bibliography processor)
- **latexmk** for automated compilation

This ensures all required packages are installed, including:

- `amsmath`, `graphicx`, `url`, `subfiles`, `caption`, `subcaption`, `multirow`, `xcolor`, `titlesec`, `minitoc`, `hyperref`
- `biblatex` with `backend=biber`

---

## Installation by Operating System

| OS | Command |
|----|---------|
| **Ubuntu / Debian** | ```bash sudo apt update sudo apt install -y texlive-latex-extra texlive-bibtex-extra biber latexmk ``` |
| **Fedora** | ```bash sudo dnf install -y texlive-collection-latex texlive-collection-latexrecommended texlive-collection-latexextra biber latexmk ``` |
| **Arch Linux / Manjaro** | ```bash sudo pacman -S --needed texlive-core texlive-latexextra texlive-bibtexextra biber latexmk ``` |
| **macOS (Homebrew)** | ```bash brew install --cask mactex sudo tlmgr install biber latexmk ``` |


---

## Compiling the Thesis

From the thesis root folder:

```bash
cd Thesis
latexmk -pdf -interaction=nonstopmode -outdir=output main.tex
