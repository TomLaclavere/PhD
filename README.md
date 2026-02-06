# PhD

[![Website](https://img.shields.io/badge/Website-bd93f9?style=for-the-badge&logo=google-chrome&logoColor=white)](https://tomlaclavere.github.io/PhD/website/website.html)

[![PhD Thesis](https://img.shields.io/badge/PhD-Thesis-ff79c6?style=for-the-badge&logo=read-the-docs&logoColor=white)](https://tomlaclavere.github.io/PhD/website/Thesis/thesis.html)

[![License: CC-BY-4.0](https://img.shields.io/badge/License-50fa7b?style=for-the-badge&logo=creative-commons&logoColor=white)](https://creativecommons.org/licenses/by/4.0/legalcode)

[![GitHub Repo Size](https://img.shields.io/github/repo-size/tomlaclavere/PhD?style=for-the-badge&logo=github&logoColor=white)](https://github.com/tomlaclavere/PhD)

[![Last Commit](https://img.shields.io/github/last-commit/tomlaclavere/PhD?style=for-the-badge&logo=git&logoColor=white)](https://github.com/tomlaclavere/PhD/commits/main)

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
