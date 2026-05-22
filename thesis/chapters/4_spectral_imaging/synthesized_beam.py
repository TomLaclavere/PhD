import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import LogNorm

# QUBIC instrument parameters (QUBIC papers VII & VIII)
N_horn = 20  # horns per side (20x20 = 400 total)
delta_h = 14e-3  # horn pitch [m]
D_f = 0.3  # focal length [m]
freq = 150e9  # frequency [Hz]
lam = 3e8 / freq  # wavelength [m] = 2 mm
fwhm_deg = 12.9  # horn beam FWHM at 150 GHz [deg]

sigma_sec = np.deg2rad(fwhm_deg) / (2 * np.sqrt(2 * np.log(2)))  # [rad]
sigma_prim = D_f * sigma_sec  # [m]


def B_prim(xf, yf):
    return np.exp(-(xf**2 + yf**2) / (2 * sigma_prim**2))


def B_sec(nx, ny):
    return np.exp(-(nx**2 + ny**2) / (2 * sigma_sec**2))


def array_factor_1d(u):
    """sin²(N π Δ u / λ) / sin²(π Δ u / λ), with limit N² at u=0."""
    arg = np.pi * delta_h * u / lam
    with np.errstate(invalid="ignore", divide="ignore"):
        af = np.sin(N_horn * arg) ** 2 / np.sin(arg) ** 2
    return np.where(np.abs(np.sin(arg)) < 1e-10, N_horn**2, af)


def synth_beam(xf, yf, nx, ny):
    ux = xf / D_f - nx
    uy = yf / D_f - ny
    return B_prim(xf, yf) * B_sec(nx, ny) * array_factor_1d(ux) * array_factor_1d(uy)


n_pts = 500
n_max = np.deg2rad(20)
n_vals = np.linspace(-n_max, n_max, n_pts)
NX, NY = np.meshgrid(n_vals, n_vals)
n_deg = np.rad2deg(n_vals)

# Central detector (xf=yf=0)
beam_center = synth_beam(0.0, 0.0, NX, NY)
beam_center /= beam_center.max()

log_norm = LogNorm(vmin=1e-3, vmax=1)
kw2d = dict(cmap="jet", norm=log_norm)  # , shading="auto")
mid = n_pts // 2

# title_base = (
#     f"QUBIC Synthesized Beam — {freq / 1e9:.0f} GHz, "
#     f"N={N_horn}×{N_horn}, Δh={delta_h * 1e3:.0f} mm, Df={D_f * 1e2:.0f} cm"
# )
title_base = f"QUBIC Synthesized Beam for central detector ($x_f=y_f=0$) — {freq / 1e9:.0f} GHz"

# Figure 1: central detector
fig1, axes1 = plt.subplots(1, 2, figsize=(12, 5))
fig1.suptitle(title_base, fontsize=14)
im0 = axes1[0].pcolormesh(n_deg, n_deg, np.clip(beam_center, 1e-4, None), **kw2d)
axes1[0].set_title("Synthesized beam pattern (log scale)")
axes1[0].set_xlabel("$n_x$ [deg]")
axes1[0].set_ylabel("$n_y$ [deg]")
fig1.colorbar(im0, ax=axes1[0], label="Normalized intensity (log)")

sec = B_sec(n_vals, 0.0)
af = array_factor_1d(0.0 / D_f - n_vals) / N_horn**2
axes1[1].plot(n_deg, sec, label="$B_{sec}(\\vec{n})$", lw=1.5)
# axes1[1].plot(n_deg, af, label="Array factor (norm.)", lw=1.5, linestyle="--")
axes1[1].plot(n_deg, beam_center[mid, :], label="$B_{synth}$", lw=1.5, color="C2")
axes1[1].set_xlabel("$n_x$ [deg]")
axes1[1].set_ylabel("Normalized intensity")
axes1[1].set_title("1D cut along $n_x$ ($n_y=0$)")
axes1[1].legend()
axes1[1].grid(True, alpha=0.3)

fig1.tight_layout()
fig1.savefig("Figures/synthesized_beam.pdf", bbox_inches="tight", dpi=150)
print("Saved synthesized_beam.pdf")
