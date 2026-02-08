# PhD

[![Website](https://img.shields.io/badge/Website-bd93f9?style=for-the-badge&logo=google-chrome&logoColor=white)](https://tomlaclavere.github.io/PhD/website.html)

[![PhD Thesis](https://img.shields.io/badge/PhD-thesis-ff79c6?style=for-the-badge&logo=read-the-docs&logoColor=white)](https://tomlaclavere.github.io/PhD/Thesis/thesis.html)

[![Licence: CC-BY-4.0](https://img.shields.io/badge/Licence-50fa7b?style=for-the-badge&logo=creative-commons&logoColor=white)](https://creativecommons.org/licenses/by/4.0/legalcode)

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

# Scripts
This repository includes many Bash scripts to perform LaTeX compilation, HTML generation, or other basic tasks. The scripts are all stored in the scripts/ directory, and a detailed explanation for each of them can be found in scripts/README.md.
If one of the Bash scripts is not executable, run :

```bash
chmod +x scripts/*.sh
```

Here, we give a short description of the main features. 

## Thesis

### Compile PhD Thesis

To compile the thesis LaTeX files and generate the PDF file, run :

```bash
./scripts/thesis/compile_thesis.sh
```

PDF will be stored in thesis/thesis.pdf

### Compile individual chapters

The TeX files for each chapter are written to be compiled together to build the full thesis in thesis.tex, or to be compiled individually for easier reading. To compile all chapters in standalone versions, run :

```bash
./scripts/thesis/compile_chapters.sh
```

The PDF will be stored in thesis/chapters/CHAPTER_NAME/CHAPTER_NAME.pdf

### Cleaning LaTeX outputs

To clean the output files of the LaTeX compilation, you can run :

```bash
./scripts/thesis/clean_tex.sh
```

This file will explore the thesis/ repository to delete the outputs of LaTeX compilation. There is also an option to remove all PDFs generated from LaTeX, even the ones copied in website/ repository. For that, add the argument : 

```bash
./scripts/thesis/clean_tex.sh -p
 # or
./scripts/thesis/clean_tex.sh --pdf
```

## Website

### Generate Website

To generate the HTML files for the website, the scripts will use HTML templates to generate all the files. For that, run : 

```bash
./scripts/website/build_website.sh
```