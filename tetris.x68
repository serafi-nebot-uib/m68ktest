        org     $1000

PWIDTH: equ     4
PHEIGHT: equ    2
PSIZE:  equ     PWIDTH*PHEIGHT

piece:
        ds.b    1                               ; x
        ds.b    1                               ; y
        ds.b    1                               ; rx (rotate x index)
        ds.b    1                               ; ry (rotate y index)
        dc.l    cmat                            ; current matrix
        dc.l    pmat                            ; previous matrix

; horizontal matrix data
        dc.b    PWIDTH                          ; number of columns
        dc.b    PHEIGHT                         ; number of rows
cmat:
        ds.b    PSIZE                           ; current matrix
        ds.w    0                               ; align

; vertical matrix data
        dc.b    PHEIGHT                         ; number of columns 
        dc.b    PWIDTH                          ; number of rows
pmat:
        ds.b    PSIZE                           ; previous matrix
        ds.w    0                               ; align

        ds.b    16

; srcmat: dc.b    $00, $01, $02, $03, $04, $05, $06, $07
srcmat: dc.b    $01, $01, $00, $00, $00, $01, $01, $00

pieceinit:
; arguments:
;       sp+0 (x pos)
;       sp+1 (y pos)
;       sp+2 (rx idx)
;       sp+3 (ry idx)
;       sp+4 - sp+7 (src piece matrix address)
;---------------------------------------------
; d0: loop counter [0..PSIZE-1]
; d1: src piece matrix offset for pmat
; d2: temporary calculations
; d3: current piece matrix cell value (a0+d0)
; a0: src piece matrix address

        ; TODO: store and restore used registers
        move.l  4(a7), (piece)
        move.l  8(a7), a0
        move.l  a0, a1
        lea.l   cmat, a2
        clr.l   d0
        clr.l   d1
.copy:
        ; copy matrix data to cmat
        move.b  (a0)+, d3
        move.b  d3, (a2)+

        ; TODO: does this work with other matrix dimensions?
        ; TODO: this whole calculation can probably be optimised
        ; copy matrix data to pmat
        ; cmat -> pmat:
        ;       pmat[((size) - 1) - ((i % width) * height) - int(i < width)] = cmat[i]
        ; NOTE: magic formula works for 4x2, does it work for other dimensions?
        move.w  d0, d1
        divu    #PWIDTH, d1
        move.l  #16, d2
        lsr.l   d2, d1                          ; calculate the remainder
        mulu.w  #-PHEIGHT, d1
        add.w   #PSIZE-1, d1
        cmp.w   #PWIDTH, d0
        bge     .fh
        subq.w  #1, d1
.fh:
        ; TODO: indexed mode possible? to avoid loading a3 everytime
        lea.l   pmat, a3
        ; clear higher word from possible calculation overflow
        andi.l  #$0000ffff, d1
        add.l   d1, a3
        move.b  d3, (a3)

        addq.w  #1, d0
        cmp.w   #PSIZE, d0
        blt     .copy
        rts

start:

        move.l  #srcmat, -(a7)                  ; source piece layout matrix
        move.w  #$01<<8|$01, -(a7)              ; rx, ry
        move.w  #$aa<<8|$bb, -(a7)              ; x, y
        jsr     pieceinit

        ; stop simulator
        move.b  #9, d0
        trap    #15

        end     start
