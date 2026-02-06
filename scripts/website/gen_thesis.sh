#!/usr/bin/env bash
set -euo pipefail

pdf_file="Thesis/main.pdf"
filesize="$(ls -lh "$pdf_file" | awk '{print $5}')"

cat <<EOF
<div class="card thesis">
    <div class="card-header">
        <div class="card-icon">
            <i class="fas fa-book"></i>
        </div>
        <div class="card-title">Complete Thesis</div>
        <div class="card-subtitle">PhD Thesis</div>
    </div>
    <div class="card-body">
        <div class="card-description">
            Complete PhD thesis document including all chapters, references, and appendices.
        </div>
        <div class="card-meta">
            <div class="file-size">
                <i class="fas fa-hdd"></i>
                <span>$filesize</span>
            </div>
            <div>
                <i class="fas fa-calendar"></i>
                <span>$CURRENT_DATE</span>
            </div>
        </div>
        
        <div class="btn-group">
            <a href="../$pdf_file" class="btn btn-block" download>
                <i class="fas fa-download"></i>
                Download Full Thesis
            </a>

            <a href="../$pdf_file" class="btn btn-block btn-secondary" target="_blank" rel="noopener">
                <i class="fas fa-eye"></i>
                Preview Full Thesis
            </a>
        </div>
    </div>
</div>

<div class="card thesis">
  <div class="card-header">
    <div class="card-icon">
      <i class="fas fa-folder-open"></i>
    </div>
    <div class="card-title">Thesis Source Files</div>
    <div class="card-subtitle">LaTeX Source Code</div>
  </div>

  <div class="card-body">
    <div class="card-description">
      Complete LaTeX source files including chapters, figures, and custom packages used in the thesis.
    </div>

    <div class="card-meta">
      <div class="file-size">
        <i class="fas fa-code"></i>
        <span>LaTeX Files</span>
      </div>
      <div>
        <i class="fas fa-folder"></i>
        <span>Multiple Files</span>
      </div>
    </div>

    <div class="btn-group">
      <a href="Thesis/Thesis.zip" class="btn btn-block">
        <i class="fas fa-download"></i>
        Download ZIP
      </a>

      <a href="https://github.com/TomLaclavere/PhD/tree/main/Thesis" class="btn btn-block btn-secondary" target="_blank" rel="noopener">
        <i class="fas fa-eye"></i>
        Browse on GitHub
        </a>
    </div>
  </div>
</div>


EOF
