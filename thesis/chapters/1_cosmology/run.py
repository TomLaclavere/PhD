# -*- coding: utf-8 -*-
"""
One-shot runner for shanimate_multi.py: no CLI flags needed, just run
    python run.py
Edit LM and the settings below to change what gets rendered.
"""

import argparse
import os
import sys

sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'sphericalharmonics'))
import shanimate_multi

LM = [(0, 0), (1, 0), (1, 1), (2, 0), (2, 1), (2, 2),
      (3, 0), (3, -2), (3, 3), (4, 0), (4, -1), (4, 3)]

args = argparse.Namespace(
    lm=LM,
    outfile='multipoles.gif',
    inc=60,
    size=1,
    nframes=24,
    duration=1,
    nlon=200,
    nlat=500,
    dpi=300,
)

if __name__ == '__main__':
    shanimate_multi.main(args)
