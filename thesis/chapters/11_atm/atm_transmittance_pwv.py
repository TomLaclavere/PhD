import re
import shutil
import subprocess
from io import StringIO

import matplotlib.pyplot as plt
import numpy as np

# Requires the am atmospheric model (S. Paine, doi:10.5281/zenodo.640645)
# installed and on PATH. Site model: QUBIC_site.amc (see file for details).
AM_BIN = "am"
SITE_AMC = "QUBIC_site.amc"

F_MIN, F_MAX, F_STEP = 0, 400, 0.2  # GHz
PWV_VALUES_MM = [0.5, 1.0, 2.0, 3.0, 5.0]
QUBIC_BANDS_GHZ = [(131.25, 168.75), (192.25, 247.5)]
O2_LINES_GHZ = [60, 118.75]
H2O_LINES_GHZ = [22.235, 183.31, 325.153, 380.197]

if shutil.which(AM_BIN) is None:
    raise RuntimeError(
        f"'{AM_BIN}' not found on PATH. Install am first (see https://doi.org/10.5281/zenodo.640645)."
    )


def run_am(scale_factor):
    args = [
        AM_BIN,
        SITE_AMC,
        str(F_MIN),
        "GHz",
        str(F_MAX),
        "GHz",
        str(F_STEP),
        "GHz",
        "0",
        "deg",
        str(scale_factor),
    ]
    result = subprocess.run(args, capture_output=True, text=True)
    return result.stdout, result.stderr


# Calibrate: the Nscale factor is relative to the model's own nominal
# tropospheric H2O column, not an absolute PWV. Run once at scale=1 and
# read am's reported total column (in um_pwv) to convert target PWV -> scale.
_, calib_stderr = run_am(1.0)
match = re.search(r"total \(\d+ layers\):.*?h2o.*?\(([\d.]+)\s*um_pwv\)", calib_stderr, re.DOTALL)
nominal_pwv_mm = float(match.group(1)) / 1000

# Spectra
fig, ax = plt.subplots(figsize=(8, 5))
for pwv_mm in PWV_VALUES_MM:
    scale_factor = pwv_mm / nominal_pwv_mm
    stdout, _ = run_am(scale_factor)
    f, tau, tx, Trj, Tb = np.loadtxt(StringIO(stdout), unpack=True)
    ax.plot(f, tx, lw=1, label=f"PWV = {pwv_mm:.1f} mm")

for band_lo, band_hi in QUBIC_BANDS_GHZ:
    ax.axvspan(band_lo, band_hi, color="tab:green", alpha=0.2)
    ax.text(
        (band_lo + band_hi) / 2,
        1.02,
        "QUBIC",
        ha="center",
        color="darkgreen",
        fontsize=8,
        fontweight="bold",
    )

for f_line in O2_LINES_GHZ:
    ax.axvline(f_line, color="tab:blue", lw=0.7, ls="--", alpha=0.6)
    ax.text(f_line, 1.02, "O$_2$", ha="center", color="tab:blue", fontsize=8)
for f_line in H2O_LINES_GHZ:
    ax.axvline(f_line, color="tab:red", lw=0.7, ls="--", alpha=0.6)
    ax.text(f_line, 1.02, "H$_2$O", ha="center", color="tab:red", fontsize=8)

ax.set_xlim(F_MIN, F_MAX)
ax.set_ylim(0, 1.05)
ax.set_xlabel("Frequency [GHz]")
ax.set_ylabel("Zenith transmittance")
ax.set_title("Simulated QUBIC site atmospheric transmittance (am)")
ax.legend()
ax.grid(True, alpha=0.3)

fig.tight_layout()
fig.savefig("Figures/atm_transmittance_pwv.pdf", bbox_inches="tight", dpi=150)
print("Saved Figures/atm_transmittance_pwv.pdf")
fig.savefig("Figures/atm_transmittance_pwv.png", bbox_inches="tight", dpi=150)
print("Saved Figures/atm_transmittance_pwv.png")
