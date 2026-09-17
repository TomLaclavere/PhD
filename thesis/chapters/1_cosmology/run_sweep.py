# -*- coding: utf-8 -*-
"""
One-shot runner: sweep spherical harmonics from l=0 to LMAX, sampling
m in {0, l//2, l} for each l (deduplicated), with a short rotation per
harmonic. Just run:
    python run_sweep.py
Edit LMAX and the settings below to change the range/pacing.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'sphericalharmonics'))
import shanimate_sweep

LMAX = 100

LM = []
for ell in range(LMAX + 1):
    for m in sorted(set([0, ell // 2, ell])):
        LM.append((ell, m))

args = argparse.Namespace(
    lm=LM,
    outfile='sweep.gif',
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
