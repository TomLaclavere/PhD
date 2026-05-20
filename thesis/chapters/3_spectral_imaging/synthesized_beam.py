import numpy as np
import matplotlib.pyplot as plt

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


n_pts = 600
n_max = np.deg2rad(35)
n_vals = np.linspace(-n_max, n_max, n_pts)
NX, NY = np.meshgrid(n_vals, n_vals)
n_deg = np.rad2deg(n_vals)

# Central detector (xf=yf=0)
beam_center = synth_beam(0.0, 0.0, NX, NY)
beam_center /= beam_center.max()

# Off-center detector (shift peak to ~8° from center)
xf_off = D_f * np.deg2rad(15)
beam_off = synth_beam(xf_off, 0.0, NX, NY)
beam_off /= beam_off.max()

fig, axes = plt.subplots(2, 2, figsize=(12, 10))
fig.suptitle(
    f"QUBIC Synthesized Beam — {freq / 1e9:.0f} GHz, "
    f"N={N_horn}×{N_horn}, Δh={delta_h * 1e3:.0f} mm, Df={D_f * 1e2:.0f} cm",
    fontsize=13,
)

from matplotlib.colors import LogNorm

log_norm = LogNorm(vmin=1e-4, vmax=1)
kw2d = dict(cmap="inferno", shading="auto", norm=log_norm)

im0 = axes[0, 0].pcolormesh(n_deg, n_deg, np.clip(beam_center, 1e-4, None), **kw2d)
axes[0, 0].set_title("2D beam — central detector ($x_f=y_f=0$)")
axes[0, 0].set_xlabel("$n_x$ [deg]")
axes[0, 0].set_ylabel("$n_y$ [deg]")
fig.colorbar(im0, ax=axes[0, 0], label="Normalized intensity (log)")

im1 = axes[0, 1].pcolormesh(n_deg, n_deg, np.clip(beam_off, 1e-4, None), **kw2d)
axes[0, 1].set_title(f"2D beam — off-center detector ($x_f$={xf_off * 1e3:.1f} mm)")
axes[0, 1].set_xlabel("$n_x$ [deg]")
axes[0, 1].set_ylabel("$n_y$ [deg]")
fig.colorbar(im1, ax=axes[0, 1], label="Normalized intensity (log)")

# 1D cuts along nx (ny=0 slice)
mid = n_pts // 2
axes[1, 0].plot(n_deg, beam_center[mid, :], lw=1.5, label="Central detector")
axes[1, 0].plot(
    n_deg, beam_off[mid, :], lw=1.5, linestyle="--", label=f"Off-center ({xf_off * 1e3:.1f} mm)"
)
axes[1, 0].set_xlabel("$n_x$ [deg]")
axes[1, 0].set_ylabel("Normalized intensity")
axes[1, 0].set_title("1D cuts along $n_x$ ($n_y = 0$)")
axes[1, 0].legend()
axes[1, 0].grid(True, alpha=0.3)

# Individual contributions for the central detector
sec = B_sec(n_vals, 0.0)
af = array_factor_1d(0.0 / D_f - n_vals) / N_horn**2  # normalized to 1
axes[1, 1].plot(n_deg, sec, label="$B_{sec}(\\vec{n})$", lw=1.5)
axes[1, 1].plot(n_deg, af, label="Array factor (norm.)", lw=1.5, linestyle="--")
axes[1, 1].plot(n_deg, beam_center[mid, :], label="$B_{synth}$ (central)", lw=1.5, color="C2")
axes[1, 1].set_xlabel("$n_x$ [deg]")
axes[1, 1].set_ylabel("Normalized amplitude")
axes[1, 1].set_title("Beam components (central detector, $n_y=0$)")
axes[1, 1].legend()
axes[1, 1].grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("synthesized_beam.pdf", bbox_inches="tight", dpi=150)
plt.savefig("synthesized_beam.png", bbox_inches="tight", dpi=150)
plt.show()
print("Saved synthesized_beam.pdf and synthesized_beam.png")
