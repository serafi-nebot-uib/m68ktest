# img.py

Transform an image into a set of rectangles.

To achieve this, the following steps are performed:
    1. Scale the image to the specified `--size`
    2. Split the image into blocks of size `--block-size` (for proper functionality, should be a multiple of `--size`)
    3. For every block, calculate the average color (this transforms the image into pixel art).
    4. Join contiguous blocks of the same color to form rectangles.

Example:

The following command upscales to image `mario.png` to 512 pixels in width and 512 pixels in height, splits the image in blocks of 32x32, generates the rectangles, draws the image and shows it:

```
./img.py mario.png --block-size 32 --size 512x512 --show
```

The `--m68k` flag can be used to encode the generated rectangles into a format that can be used in Motorola 68000 assembly (see `img.x68` for a proof of concept implementation):

```
./img.py mario.png --block-size 32 --size 512x512 --m68k
	dc.l  $000037f8, $00800000, $01800040
	dc.l  $00043aed, $01200000, $01400020
	dc.l  $00043aec, $01800020, $01a00040
	dc.l  $00007eae, $00800040, $00c00060
	dc.l  $000480b3, $00c00040, $00e00060
	dc.l  $0046a2ff, $00a00040, $016000e0
	dc.l  $00419ff9, $01000040, $01200060
	dc.l  $000480b3, $01200040, $01400060
	dc.l  $00469ef3, $01400040, $01600060
	dc.l  $000480b3, $00600060, $00800080
	dc.l  $00419ff9, $00800060, $00a00080
	dc.l  $000480b2, $00a00060, $00c00080
	dc.l  $00419ffa, $00c00060, $00e00080
	dc.l  $00419ffa, $01000060, $01200080
	dc.l  $000882b7, $01200060, $01400080
	dc.l  $00419ffa, $01400060, $01600080
	dc.l  $0046a2ff, $01600060, $01800080
	dc.l  $00469ff4, $01800060, $01a00080
	dc.l  $000480b2, $00600080, $008000a0
	dc.l  $003d9df5, $00800080, $00a000a0
	dc.l  $000480b3, $00a00080, $00c000a0
	dc.l  $000882b7, $00c00080, $00e000a0
	dc.l  $0045a1fe, $01000080, $012000a0
	dc.l  $003d9df5, $01200080, $014000a0
	dc.l  $000480b2, $01400080, $016000a0
	dc.l  $00419ff9, $01600080, $018000a0
	dc.l  $00419ff9, $01800080, $01a000a0
	dc.l  $00469ef3, $01a00080, $01c000a0
	dc.l  $00007eae, $006000a0, $008000c0
	dc.l  $000480b3, $008000a0, $00a000c0
	dc.l  $00419ff9, $010000a0, $012000c0
	dc.l  $00007eae, $012000a0, $018000c0
	dc.l  $00047da7, $018000a0, $01a000c0
	dc.l  $00469ef3, $016000c0, $018000e0
	dc.l  $00007eae, $004000e0, $00a00140
	dc.l  $000079b2, $00a000e0, $00c00140
	dc.l  $00003bf3, $00c000e0, $00e00120
	dc.l  $00007eae, $00e000e0, $01000100
	dc.l  $00007dae, $010000e0, $01200100
	dc.l  $000479ac, $012000e0, $01400100
	dc.l  $000079b2, $00e00100, $01000120
	dc.l  $000075b6, $01000100, $01200120
	dc.l  $00003bf3, $01200100, $01400140
	dc.l  $00007eae, $01400100, $01c00140
	dc.l  $00047da7, $01800100, $01a00120
	dc.l  $000037f8, $00800120, $016001c0
	dc.l  $0046a2ff, $00400140, $00600180
	dc.l  $00419ff9, $00600140, $00800160
	dc.l  $000079b2, $00800140, $00a00160
	dc.l  $00043df8, $00a00140, $00c00160
	dc.l  $00419bfe, $00c00140, $00e00160
	dc.l  $00043df8, $01000140, $01200160
	dc.l  $00419bfe, $01200140, $01400160
	dc.l  $00003bf3, $01400140, $01600160
	dc.l  $000480b3, $01600140, $01800160
	dc.l  $0046a2ff, $01800140, $01c00180
	dc.l  $0045a1fe, $00600160, $00800180
	dc.l  $003d95fe, $00800160, $00a00180
	dc.l  $00043df8, $01400160, $01600180
	dc.l  $00419bfe, $01600160, $01800180
	dc.l  $00469ef3, $00400180, $006001a0
	dc.l  $004198f3, $00600180, $008001a0
	dc.l  $000037f7, $00c00180, $00e001a0
	dc.l  $00043aec, $00e00180, $010001a0
	dc.l  $00043aed, $01000180, $012001a0
	dc.l  $00043df7, $01600180, $018001a0
	dc.l  $00469ef3, $01800180, $01c001a0
	dc.l  $00043aec, $00c001a0, $00e001c0
	dc.l  $00043aec, $016001a0, $018001c0
	dc.l  $00007eae, $004001c0, $00a00200
	dc.l  $00047da7, $00a001c0, $00c00200
	dc.l  $00007eae, $014001c0, $01c00200
	dc.l  $00047da7, $018001c0, $01a001e0
```

## Dependencies

- numpy (for calculating the average color; will not be needed int he future)
- Pillow (for image processing)
