import numpy as np
import matplotlib.pyplot as plt
from astropy import units as u
from astropy.coordinates import SkyCoord, AltAz, EarthLocation
from astropy.time import Time, TimeDelta

# QUBIC observing site (Alto Chorrillos, Salta, Argentina)
SITE = EarthLocation(lat=-24.1844 * u.deg, lon=-66.8714 * u.deg, height=4820 * u.m)

# Targeted low-dust sky patch
PATCH = SkyCoord(ra=0 * u.deg, dec=-57 * u.deg, frame="icrs")
PATCH_NAME = "low_dust_region"

# Cryogenic pulse-tube elevation limits and QUBIC synthesized beam width
HOR_DOWN, HOR_UP = 30, 70  # deg
BEAM_FWHM = 13  # deg
MARGIN = BEAM_FWHM / 2  # deg, half beam width added on each side of the hard limits

DATE_OBS = Time("2025-06-06 00:00:00")
SIDEREAL_DAY = TimeDelta(23.9344696 * u.hour)
N_SAMPLES = 2000

plt.rcParams.update({"font.size": 14})

times = DATE_OBS + np.linspace(0, 1, N_SAMPLES) * SIDEREAL_DAY
lst = times.sidereal_time("apparent", longitude=SITE.lon).hour
alt = PATCH.transform_to(AltAz(obstime=times, location=SITE)).alt.deg

order = np.argsort(lst)
lst, alt = lst[order], alt[order]

visible = (alt >= HOR_DOWN) & (alt <= HOR_UP)
frac_visible = visible.mean() * 100

window_low, window_up = HOR_DOWN - MARGIN, HOR_UP + MARGIN

alt_visible = np.where(visible, alt, np.nan)
alt_not_visible = np.where(visible, np.nan, alt)

fig, ax = plt.subplots(figsize=(9, 6))

span_extended = ax.axhspan(
    window_low,
    window_up,
    color="0.85",
    label=f"Extended margin, cryostat limits $\\pm$ beam half-width ({window_low:.1f}°–{window_up:.1f}°)",
)
span_hard = ax.axhspan(
    HOR_DOWN,
    HOR_UP,
    color="0.65",
    label=f"Cryostat elevation limits ({HOR_DOWN}°–{HOR_UP}°)",
)
line_not_visible, = ax.plot(lst, alt_not_visible, "--", color="0.5", label="Patch center not visible")
line_visible, = ax.plot(
    lst,
    alt_visible,
    "-",
    color="tab:blue",
    lw=2,
    label="Patch center visible",
)

ax.set_xlabel("Local Sidereal Time (LST) [h]")
ax.set_ylabel("Elevation [°]")
ax.set_xlim(0, 24)
ax.set_xticks(np.arange(0, 25, 3))
ax.set_title(
    # f"Observation window : {PATCH_NAME} on {DATE_OBS.iso[:10]}\n"
    f"Patch center within cryostat limits [{HOR_DOWN}°, {HOR_UP}°] for {frac_visible:.1f}% of the sidereal day"
)
ax.legend(
    handles=[line_visible, line_not_visible, span_hard, span_extended],
    loc="upper center",
    frameon=True,
    fontsize=11,
)

fig.tight_layout()
fig.savefig("Figures/patch_visible_time.pdf", bbox_inches="tight", dpi=150)
print("Saved Figures/patch_visible_time.pdf")
