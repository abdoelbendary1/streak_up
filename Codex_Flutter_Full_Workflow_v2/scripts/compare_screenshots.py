#!/usr/bin/env python3
"""Diagnostic overlay/difference only; NEVER a design-approval score."""
import argparse
from pathlib import Path

def main():
    p=argparse.ArgumentParser(description=__doc__)
    p.add_argument('--reference', type=Path, required=True)
    p.add_argument('--actual', type=Path, required=True)
    p.add_argument('--output-dir', type=Path, required=True)
    args=p.parse_args()
    try:
        from PIL import Image, ImageChops
    except ImportError as e:
        raise SystemExit('Pillow is required: python -m pip install Pillow') from e
    a=Image.open(args.reference).convert('RGBA')
    b=Image.open(args.actual).convert('RGBA')
    if a.size != b.size:
        raise SystemExit(f'Image sizes differ (reference={a.size}, actual={b.size}). Match/crop *equivalent app content* manually; automated stretching would mislead.')
    args.output_dir.mkdir(parents=True, exist_ok=True)
    Image.blend(a,b,0.5).save(args.output_dir / 'half_overlay.png')
    ImageChops.difference(a.convert('RGB'),b.convert('RGB')).save(args.output_dir / 'raw_difference.png')
    a.convert('RGB').save(args.output_dir / 'reference_used.png')
    b.convert('RGB').save(args.output_dir / 'actual_used.png')
    print('Created 50% overlay and raw difference. Differences can arise from fonts, OS rendering and timing; visually inspect and do NOT treat a pixel metric as acceptance.')

if __name__=='__main__': main()
