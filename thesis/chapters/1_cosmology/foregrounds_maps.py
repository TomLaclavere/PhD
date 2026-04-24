import numpy as np
import healpy as hp
import pysm3
import pysm3.units as u
import matplotlib.pyplot as plt
from pathlib import Path

# Configuration
NSIDE = 256
FREQ_GHZ_DUST = 353.0
FREQ_GHZ_SYNC = 30
OUTPUT_DIR = Path("Figures/foreground_maps")
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

freq_dust = FREQ_GHZ_DUST * u.GHz
freq_sync = FREQ_GHZ_SYNC * u.GHz


def planck_range(m, stokes):
    """Clip range following Planck map conventions (percentile-based)."""
    if stokes == "I":
        return max(0.0, float(np.percentile(m, 2))), float(np.percentile(m, 98))
    else:
        vmax = float(np.percentile(np.abs(m), 98))
        return -vmax, vmax


def save_mollview(m, stokes, title, filename, unit=r"$\mu K_{\rm CMB}$"):
    vmin, vmax = planck_range(m, stokes)
    cmap = "afmhot" if stokes == "I" else "RdBu_r"
    fig = plt.figure(figsize=(10, 5))
    hp.mollview(m, title=title, unit=unit, cmap=cmap, min=vmin, max=vmax, fig=fig.number, hold=True)
    hp.graticule()
    fig.savefig(filename, bbox_inches="tight")
    plt.close(fig)


# Dust (d1: modified blackbody with spatially varying spectral index and temperature)
sky_dust = pysm3.Sky(nside=NSIDE, preset_strings=["d1"])
dust_maps = sky_dust.get_emission(freq_dust)
dust_maps = dust_maps.to(u.uK_CMB, equivalencies=u.cmb_equivalencies(freq_dust))

dust_I = dust_maps[0].value
dust_Q = dust_maps[1].value
dust_U = dust_maps[2].value

for stokes, m in zip(["I", "Q", "U"], [dust_I, dust_Q, dust_U]):
    save_mollview(
        m,
        stokes=stokes,
        title=rf"Dust {stokes} — {FREQ_GHZ_DUST:.0f} GHz",
        filename=OUTPUT_DIR / f"dust_{stokes}_{FREQ_GHZ_DUST:.0f}GHz_nside{NSIDE}.pdf",
    )

print(f"Dust maps saved (I, Q, U) at {FREQ_GHZ_DUST} GHz, Nside={NSIDE}")
print(f"  I: min={dust_I.min():.2f}, max={dust_I.max():.2f} uK_CMB")
print(f"  Q: min={dust_Q.min():.2f}, max={dust_Q.max():.2f} uK_CMB")
print(f"  U: min={dust_U.min():.2f}, max={dust_U.max():.2f} uK_CMB")

# Synchrotron (s1: power law with spatially varying spectral index)
sky_sync = pysm3.Sky(nside=NSIDE, preset_strings=["s1"])
sync_maps = sky_sync.get_emission(freq_sync)
sync_maps = sync_maps.to(u.uK_CMB, equivalencies=u.cmb_equivalencies(freq_sync))

sync_I = sync_maps[0].value
sync_Q = sync_maps[1].value
sync_U = sync_maps[2].value

for stokes, m in zip(["I", "Q", "U"], [sync_I, sync_Q, sync_U]):
    save_mollview(
        m,
        stokes=stokes,
        title=rf"Synchrotron {stokes} — {FREQ_GHZ_SYNC:.0f} GHz",
        filename=OUTPUT_DIR / f"synchrotron_{stokes}_{FREQ_GHZ_SYNC:.0f}GHz_nside{NSIDE}.pdf",
    )

print(f"\nSynchrotron maps saved (I, Q, U) at {FREQ_GHZ_SYNC} GHz, Nside={NSIDE}")
print(f"  I: min={sync_I.min():.2f}, max={sync_I.max():.2f} uK_CMB")
print(f"  Q: min={sync_Q.min():.2f}, max={sync_Q.max():.2f} uK_CMB")
print(f"  U: min={sync_U.min():.2f}, max={sync_U.max():.2f} uK_CMB")

print(f"\nAll PDFs written to {OUTPUT_DIR}/")
