#!/usr/bin/env python3

from __future__ import annotations

import sys
from PIL import Image, ImageDraw

if __name__ == "__main__":
  img = Image.open(sys.argv[1])
  width, height = img.size
  width, height = 640, 480
  img = img.convert("RGB").resize((width, height), Image.Resampling.LANCZOS)
  pix = img.load()

  for y in range(height):
    l = []
    for x in range(width):
      r, g, b, *_ = pix[x, y]
      print("        dc.l", f"$00{r:02x}{g:02x}{b:02x}")

  print(width, height)
