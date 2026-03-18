import numpy as np
import matplotlib.pyplot as plt


H0 = 0.070
Omega_m0 = 0.315
Omega_r0 = 9e-5
Omega_L0 = 0.685

M_sun = 1.98847e30
Gyr_to_s = 3.15576e16
Mpc_to_m = 3.0856e22

G = 6.6742e-11 * (1 / Mpc_to_m) ** 3 * M_sun * Gyr_to_s**2


def a(t, t0=0.0):
    return (t / t0) if t0 != 0 else 1e-10


def Omega_m(t, om0=Omega_m0, or0=Omega_r0, ol0=Omega_L0):
    at = a(t)
    return om0 / (or0 * at**-1 + om0 + ol0 * at**3)


def Omega_r(t, om0=Omega_m0, or0=Omega_r0, ol0=Omega_L0):
    at = a(t)
    return or0 / (or0 + om0 * at + ol0 * at**4)


def Omega_L(t, om0=Omega_m0, or0=Omega_r0, ol0=Omega_L0):
    at = a(t)
    return ol0 / (or0 * at**-4 + om0 * at**-3 + ol0)


def rho_c(t, om0=Omega_m0, or0=Omega_r0, ol0=Omega_L0):
    at = a(t)
    return (3 / (8 * np.pi * G)) * H0**2 * (or0 * at**-4 + om0 * at**-3 + ol0)


a_vals = np.logspace(-5, 0, 500)

rho_r = Omega_r0 * a_vals**-4
rho_m = Omega_m0 * a_vals**-3
rho_L = Omega_L0 * np.ones_like(a_vals)

a_eq = a_eq = Omega_r0 / Omega_m0
a_lambda = (Omega_m0 / Omega_L0) ** (1 / 3)

plt.figure(figsize=(8, 6))
plt.loglog(a_vals, rho_r, label="Radiation (ρ ∝ a⁻⁴)", color="green")
plt.loglog(a_vals, rho_m, label="Matter (ρ ∝ a⁻³)", color="red")
plt.loglog(a_vals, rho_L, label="Cosmological constant (ρ ∝ const)", color="blue")

plt.axvline(a_eq, color="orange", linestyle="--", alpha=0.5)
plt.text(a_eq, 1e1, "Equality Matter-Radiation", rotation=90, va="bottom", ha="right")
plt.axvline(a_lambda, color="purple", linestyle="--", alpha=0.5)
plt.text(a_lambda, 1e1, "Equality Matter-Λ", rotation=90, va="bottom", ha="right")

plt.xlabel("Scale factor a")
plt.ylabel("Energy density ρ (arbitrary units)")
plt.title("Evolution of Energy Densities")
plt.legend()
plt.grid(True, which="both", ls="--", alpha=0.5)
plt.ylim()
plt.savefig("thesis/chapters/1_cosmology/Figures/energy_density.pdf")
# plt.show()
