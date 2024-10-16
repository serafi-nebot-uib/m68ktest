#!/usr/bin/env python3

import numpy as np
from collections import deque
from PIL import Image, ImageDraw

def img_to_mat(path: str, psize: int) -> list:
  img = Image.open(path)

  # resize width and height to be a multiple of psize
  width, height = (s // psize * psize for s in img.size)
  img = img.convert("RGBA")
  arr = np.array(img)

  mat = []
  for y in range(0, height, psize):
    row = []
    for x in range(0, width, psize):
      block = arr[y:y+psize, x:x+psize]
      avgc = np.mean(block, axis=(0, 1)).astype(int)
      row.append(avgc.tolist())
    mat.append(row)
  return mat

def mat_to_img(mat: list, psize: int) -> Image:
  width, height = len(mat[0]) * psize, len(mat) * psize
  img = Image.new("RGBA", (width, height))
  draw = ImageDraw.Draw(img)
  for y, row in enumerate(mat):
    for x, color in enumerate(row):
      draw.rectangle((x*psize, y*psize, (x+1)*psize, (y+1)*psize), fill=tuple(color))
  return img

def rec_to_img(rec: list, width: int, height: int) -> Image:
  img = Image.new("RGBA", (width, height))
  draw = ImageDraw.Draw(img)
  for c, r in rec: draw.rectangle(r, fill=tuple(c))
  return img

def mat_to_rec(mat: list) -> list:
  rows, cols = len(mat[0]), len(mat)
  vis = [[False for _ in range(cols)] for _ in range(rows)]
  rec = []

  def flood_fill(x: list, y: list, color: list):
    q = deque([(x, y)])
    min_x, min_y, max_x, max_y = x, y, x, y
    while q:
      curr_x, curr_y = q.popleft()
      if 0 <= curr_x < cols and 0 <= curr_y < rows and not vis[curr_y][curr_x] and mat[curr_y][curr_x] == color:
        vis[curr_y][curr_x] = True
        min_x, min_y = min(min_x, curr_x), min(min_y, curr_y)
        max_x, max_y = max(max_x, curr_x), max(max_y, curr_y)
        for dx, dy in ((0, 1), (1, 0), (0, -1), (-1, 0)): q.append((curr_x + dx, curr_y + dy))
    return (min_x, min_y, max_x, max_y)

  for y in range(rows):
    for x in range(cols):
      if not vis[y][x] and mat[y][x][3] != 0:
        r = flood_fill(x, y, mat[y][x])
        rec.append((mat[y][x], r))

  return rec

PSIZE = 16

def rec_to_m68k(color: list, coords: list):
  r, g, b, *_ = color
  sx, sy, ex, ey, *_ = (x * PSIZE for x in coords) # manual resize to make it look bigger, shouldn't be done here
  ex += PSIZE
  ey += PSIZE
  return f"dc.l  $00{b:02x}{g:02x}{r:02x}, ${sx:04x}{sy:04x}, ${ex:04x}{ey:04x}"

if __name__ == "__main__":
  mat = img_to_mat("mario.png", PSIZE)
  rec = mat_to_rec(mat)

  # img = mat_to_img(mat, PSIZE)
  # img.show()

  # print(rec)
  # img = rec_to_img(rec, len(mat[0]), len(mat))
  # img.show()

  # print(f"mat: {len(mat)*len(mat[0])}; rec: {len(rec)}")

  for color, coords in rec: print(rec_to_m68k(color, coords))
