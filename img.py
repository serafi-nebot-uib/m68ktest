#!/usr/bin/env python3

from __future__ import annotations

import numpy as np
from collections import deque
from PIL import Image, ImageDraw

def img_to_mat(path: str, psize: int, width: int | None = None, height: int | None = None) -> list:
  img = Image.open(path)

  # resize width and height to be a multiple of psize
  size = s if None not in (s := (width, height)) else img.size
  width, height = (x // psize * psize for x in size) # type: ignore[operator]
  arr = np.array(img.resize((width, height), Image.Resampling.LANCZOS).convert("RGBA"))

  mat = []
  for y in range(0, height, psize):
    row = []
    for x in range(0, width, psize):
      block = arr[y:y+psize, x:x+psize]
      avgc = np.mean(block, axis=(0, 1)).astype(int)
      row.append(avgc.tolist())
    mat.append(row)
  return mat

def mat_to_img(mat: list, psize: int):
  width, height = len(mat[0]) * psize, len(mat) * psize
  img = Image.new("RGBA", (width, height))
  draw = ImageDraw.Draw(img)
  for y, row in enumerate(mat):
    for x, color in enumerate(row):
      draw.rectangle((x*psize, y*psize, (x+1)*psize, (y+1)*psize), fill=tuple(color))
  return img

def rec_to_img(rec: list, width: int, height: int):
  img = Image.new("RGBA", (width, height))
  draw = ImageDraw.Draw(img)
  for c, r in rec: draw.rectangle(r, fill=tuple(c))
  return img

def mat_to_rec(mat: list, psize: int) -> list:
  rows, cols = len(mat[0]), len(mat)
  vis = [[False for _ in range(cols)] for _ in range(rows)]

  def flood_fill(x, y, color):
    q = deque([(x, y)])
    min_x, min_y, max_x, max_y = x, y, x, y
    while q:
      curr_x, curr_y = q.popleft()
      if 0 <= curr_x < cols and 0 <= curr_y < rows and not vis[curr_y][curr_x] and mat[curr_y][curr_x] == color:
        vis[curr_y][curr_x] = True
        min_x, min_y = min(min_x, curr_x), min(min_y, curr_y)
        max_x, max_y = max(max_x, curr_x), max(max_y, curr_y)
        for dx, dy in ((0, 1), (1, 0), (0, -1), (-1, 0)): q.append((curr_x + dx, curr_y + dy))
    return tuple(x*psize for x in (min_x, min_y, max_x+1, max_y+1))

  return [(mat[y][x], flood_fill(x, y, mat[y][x])) for y in range(rows) for x in range(cols) if not vis[y][x] and mat[y][x][3] > 128]

WIDTH, HEIGHT = 64, 64
PSIZE = 4

def rec_m68k_enc(color: list, coords: list) -> str:
  r, g, b, *_ = color
  sx, sy, ex, ey, *_ = coords
  return f"dc.l  $00{b:02x}{g:02x}{r:02x}, ${sx:04x}{sy:04x}, ${ex:04x}{ey:04x}"

def rec_to_m68k(rec: list) -> list: return [rec_m68k_enc(color, coords) for color, coords in rec]

if __name__ == "__main__":
  mat = img_to_mat("/Users/hexdhog/Documents/UIB/CS/Y2/EC/m68ktest/tetris/blau.png", PSIZE, WIDTH, HEIGHT)
  rec = mat_to_rec(mat, PSIZE)
  # print(rec)
  # img = rec_to_img(rec, WIDTH, HEIGHT)
  # img.show()

  # print(f"mat: {len(mat)*len(mat[0])}; rec: {len(rec)}")

  print("\t" + "\n\t".join(rec_to_m68k(rec)))
