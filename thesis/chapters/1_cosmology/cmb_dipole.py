import healpy as hp
import matplotlib.pyplot as plt
import numpy as np
import pysm3.units as u
from pysm3.models.dipole import CMBDipole

# CMB & Dipole parameters
nside = 256
amp = 3362.04 * u.uK_CMB
T_cmb = 2.7255 * u.K_CMB
dip_lon = 263.998 * u.deg
dip_lat = 48.253 * u.deg
freq = 150 * u.GHz

# Create Dipole map from PySM
dipole = CMBDipole(nside, amp, T_cmb, dip_lon, dip_lat)
dipole_map = dipole.get_emission(freq)

dipole_map = dipole_map.to(u.uK_CMB, equivalencies=u.cmb_equivalencies(freq))
map_mK = dipole_map.to_value("mK_CMB")
vmax = np.max(np.abs(map_mK)).round(3)

# Savefig
fig = plt.figure(figsize=(10, 7))

hp.mollview(
    map_mK,
    title="CMB Solar Dipole",
    unit=r"mK$_{\mathrm{CMB}}$",
    cmap="jet",
    min=-vmax,
    max=vmax,
    norm="linear",
    notext=False,
    xsize=2000,
    hold=True,
)

hp.graticule(color="gray", linestyle="--", alpha=0.5)
plt.savefig("Figures/cmb_dipole_pysm.pdf")
