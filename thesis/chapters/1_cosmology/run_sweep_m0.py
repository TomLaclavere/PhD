# -*- coding: utf-8 -*-
"""
One-shot runner: sweep spherical harmonics from l=0 to LMAX, m=0 only
(zonal harmonics), with a short rotation per harmonic. Just run:
    python run_sweep_m0.py
Edit LMAX and the settings below to change the range/pacing.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'sphericalharmonics'))
import shanimate_sweep

LMAX = 100

LM = [(ell, 0) for ell in range(LMAX + 1)]

args = argparse.Namespace(
    lm=LM,
    outfile='sweep_m0.gif',
    inc=60,
    size=2,
    nframes=4,
    duration=0.15,
    nlon=400,
    nlat=800,
    dpi=150,
)

if __name__ == '__main__':
    print('{0} harmonics, {1} frames total, ~{2:.0f}s playtime'.format(
        len(LM), len(LM) * args.nframes, len(LM) * args.duration))
    shanimate_sweep.main(args)
