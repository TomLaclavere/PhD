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

sigma_prim = np.deg2rad(fwhm_deg) / (2 * np.sqrt(2 * np.log(2)))  # [rad]
sigma_sec = D_f * sigma_prim  # [m]


def B_prim(nx, ny):
    return np.exp(-(nx**2 + ny**2) / (2 * sigma_prim**2))


def B_sec(xf, yf):
    return np.exp(-(xf**2 + yf**2) / (2 * sigma_sec**2))


def array_factor_1d(u):
    """sin²(N π Δ u / λ) / sin²(π Δ u / λ), with limit N² at u=0."""
    arg = np.pi * delta_h * u / lam
    with np.errstate(invalid="ignore", divide="ignore"):
        af = np.sin(N_horn * arg) ** 2 / np.sin(arg) ** 2
    return np.where(np.abs(np.sin(arg)) < 1e-10, N_horn**2, af)


def synth_beam(xf, yf, nx, ny):
    ux = xf / D_f - nx
    uy = yf / D_f - ny
    return B_prim(nx, ny) * B_sec(xf, yf) * array_factor_1d(ux) * array_factor_1d(uy)


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

title_base = f"QUBIC Synthesized Beam for central detector ($x_f=y_f=0$) - {freq / 1e9:.0f} GHz"

# Figure 1: 2D synthesized beam pattern
fig1, ax1 = plt.subplots(figsize=(6, 5))
fig1.suptitle(title_base, fontsize=14)
im0 = ax1.pcolormesh(n_deg, n_deg, np.clip(beam_center, 1e-4, None), **kw2d)
ax1.set_title("Synthesized beam pattern (log scale)")
ax1.set_xlabel("$n_x$ [deg]")
ax1.set_ylabel("$n_y$ [deg]")
fig1.colorbar(im0, ax=ax1, label="Normalized intensity (log)")

fig1.tight_layout()
fig1.savefig("Figures/synthesized_beam_2d.pdf", bbox_inches="tight", dpi=150)
print("Saved synthesized_beam_2d.pdf")

# Figure 2: 1D cut along n_x
fig2, ax2 = plt.subplots(figsize=(6, 5))
fig2.suptitle(title_base, fontsize=14)
prim = B_prim(n_vals, 0.0)
af = array_factor_1d(0.0 / D_f - n_vals) / N_horn**2
ax2.plot(n_deg, prim, label="$B_{prim}(\\vec{n})$", lw=1.5)
# ax2.plot(n_deg, af, label="Array factor (norm.)", lw=1.5, linestyle="--")
ax2.plot(n_deg, beam_center[mid, :], label="$B_{synth}$", lw=1.5, color="C2")
ax2.set_xlabel("$n_x$ [deg]")
ax2.set_ylabel("Normalized intensity")
ax2.set_title("1D cut along $n_x$ ($n_y=0$)")
ax2.legend()
ax2.grid(True, alpha=0.3)

fig2.tight_layout()
fig2.savefig("Figures/synthesized_beam_1d.pdf", bbox_inches="tight", dpi=150)
print("Saved synthesized_beam_1d.pdf")
