import numpy as np
import healpy as hp
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors
from pathlib import Path

MAPS_DIR = Path(__file__).parent / "Figures" / "foreground_maps"
OUTPUT_DIR = MAPS_DIR
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

FITS_DUST_I = MAPS_DIR / "COM_CompMap_dust-commander_0256_R2.00.fits"
FITS_DUST_QU = MAPS_DIR / "COM_CompMap_QU-thermaldust-commander_2048_R3.00_full.fits"
FITS_SYNC_I = MAPS_DIR / "COM_CompMap_Synchrotron-commander_0256_R2.00.fits"
FITS_SYNC_QU = MAPS_DIR / "COM_CompMap_QU-synchrotron-commander_2048_R3.00_full.fits"

H_PLANCK = 6.626e-34
K_B = 1.381e-23
T_CMB = 2.725  # K

UNIT_LABEL = r"$\mu K_{\rm CMB}$"


def powerlaw_rj_ratio(nu1_hz, nu2_hz, beta_s=-3.0):
    """T_RJ ratio for a synchrotron power law: T_RJ ∝ ν^β_s."""
    return (nu2_hz / nu1_hz) ** beta_s


def mbb_rj_ratio(nu1_hz, nu2_hz, temp_k, beta):
    x1 = H_PLANCK * nu1_hz / (K_B * temp_k)
    x2 = H_PLANCK * nu2_hz / (K_B * temp_k)
    return (nu2_hz / nu1_hz) ** (beta + 1) * np.expm1(x1) / np.expm1(x2)


def rj_to_cmb(nu_hz):
    """Scalar conversion factor: T_CMB = T_RJ * rj_to_cmb(nu)."""
    x = H_PLANCK * nu_hz / (K_B * T_CMB)
    return np.expm1(x) ** 2 / (x**2 * np.exp(x))


def asym_range(m):
    finite = m[np.isfinite(m)]
    return float(np.percentile(finite, 2)), float(np.percentile(finite, 98))


def save_log(m, filename, title):
    finite = m[np.isfinite(m) & (m > 0)]
    vmin = float(np.percentile(finite, 2))
    vmax = float(np.percentile(finite, 98))
    fig = plt.figure(figsize=(10, 5))
    hp.mollview(
        m, title=title, cmap="jet", min=vmin, max=vmax, norm="log", fig=fig.number, hold=True
    )
    hp.graticule()
    fig.axes[-1].set_xlabel(UNIT_LABEL)
    fig.savefig(OUTPUT_DIR / filename, bbox_inches="tight")
    plt.close(fig)
    print(f"  saved {filename}")


def save_symlog(m, filename, title, linthresh=None):
    finite = m[np.isfinite(m)]
    if linthresh is None:
        linthresh = float(np.percentile(np.abs(finite), 10))
    vmax = float(np.percentile(np.abs(finite), 98))

    norm = mcolors.SymLogNorm(linthresh=linthresh, vmin=-vmax, vmax=vmax, base=10)
    projected = hp.mollview(m, return_projected_map=True)
    plt.close()
    projected = np.where(projected == hp.UNSEEN, np.nan, projected)

    fig, ax = plt.subplots(figsize=(10, 5))
    im = ax.imshow(
        projected, norm=norm, cmap="jet", origin="lower", interpolation="nearest", aspect="auto"
    )
    ax.set_title(title)
    ax.axis("off")
    fig.colorbar(im, ax=ax, label=UNIT_LABEL, fraction=0.046, pad=0.04)
    fig.savefig(OUTPUT_DIR / filename, bbox_inches="tight")
    plt.close(fig)
    print(f"  saved {filename}")


# Intensity at 353 GHz: convert from 545 GHz ref (µK_RJ) then to µK_CMB
print("Loading dust-commander Nside=256 (545 GHz ref)...")
maps_256 = hp.read_map(FITS_DUST_I, field=None)
I_ML, _, _, TEMP_ML, _, _, BETA_ML, _, _ = maps_256

I_353_rj = I_ML * mbb_rj_ratio(545e9, 353e9, TEMP_ML, BETA_ML)
I_353_cmb = I_353_rj * rj_to_cmb(353e9)

save_log(I_353_cmb, "dust_I_353GHz_commander.pdf", r"Dust $I$ — 353 GHz")

# Q and U at 353 GHz: convert µK_RJ → µK_CMB
print("Loading QU-thermaldust-commander Nside=2048 (353 GHz)...")
Q_STOKES, U_STOKES, _ = hp.read_map(FITS_DUST_QU, field=None)

conv = rj_to_cmb(353e9)
Q_cmb = Q_STOKES * conv
U_cmb = U_STOKES * conv

save_symlog(Q_cmb, "dust_Q_353GHz_commander.pdf", r"Dust $Q$ — 353 GHz")
save_symlog(U_cmb, "dust_U_353GHz_commander.pdf", r"Dust $U$ — 353 GHz")

# Synchrotron I at 30 GHz: extrapolate from 408 MHz ref with power law (β_s = -3)
print("Loading synchrotron-commander Nside=256 (408 MHz ref)...")
sync_I_ML, _, _ = hp.read_map(FITS_SYNC_I, field=None)

sync_I_30_rj = sync_I_ML * powerlaw_rj_ratio(408e6, 30e9)
sync_I_30_cmb = sync_I_30_rj * rj_to_cmb(30e9)

save_log(sync_I_30_cmb, "sync_I_30GHz_commander.pdf",
         r"Synchrotron $I$ — 30 GHz")

# Synchrotron Q and U at 30 GHz: convert µK_RJ → µK_CMB
print("Loading QU-synchrotron-commander Nside=2048 (30 GHz)...")
sync_Q, sync_U = hp.read_map(FITS_SYNC_QU, field=None)

sync_conv_30 = rj_to_cmb(30e9)
save_symlog(sync_Q * sync_conv_30, "sync_Q_30GHz_commander.pdf",
            r"Synchrotron $Q$ — 30 GHz")
save_symlog(sync_U * sync_conv_30, "sync_U_30GHz_commander.pdf",
            r"Synchrotron $U$ — 30 GHz")

print(f"\nAll PDFs written to {OUTPUT_DIR}/")
