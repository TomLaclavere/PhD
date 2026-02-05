# PhD
Repository to store my PhD work for QUBIC Instrument. It includes my Thesis, publications, presentations and others.

# LaTeX Thesis – Build Instructions

## Requirements

- **LaTeX** (TeX Live recommended)
- **Biber** (modern bibliography processor)
- `latexmk` for automated compilation

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
latexmk -pdf -interaction=nonstopmode main.tex