        org     $1000

PWIDTH: equ     4
PHEIGHT: equ    2
PSIZE:  equ     PWIDTH*PHEIGHT

BOARDWIDTH: equ 10
BOARDHEIGHT: equ 20

piece:
        ds.b    1                               ; x
        ds.b    1                               ; y
        ds.b    1                               ; rx (rotate x index)
        ds.b    1                               ; ry (rotate y index)
        ; TODO: change cmat/pmat labels to hmat/vmat
        dc.l    cmat                            ; current matrix
        dc.l    pmat                            ; previous matrix

; current matrix data
        dc.b    PWIDTH                          ; number of columns
        dc.b    PHEIGHT                         ; number of rows
cmat:
        ds.b    PSIZE                           ; current matrix
        ds.w    0                               ; align

; previous matrix data
        dc.b    PHEIGHT                         ; number of columns 
        dc.b    PWIDTH                          ; number of rows
pmat:
        ds.b    PSIZE                           ; previous matrix
        ds.w    0                               ; align

        ds.b    16

; srcmat: dc.b    $00, $01, $02, $03, $04, $05, $06, $07
srcmat: dc.b    $01, $01, $00, $00, $00, $01, $01, $00

min:
        cmp.l   d0, d1
        bgt     .done
        move.l  d1, d0
.done:
        rts

max:
        cmp.l   d0, d1
        blt     .done
        move.l  d1, d0
.done:
        rts

piececheck:
        ; find intersection between board and piece
        lea.l   piece, a0
        clr.l   d0                              ; accumulator
        clr.l   d1                              ; start x
        clr.l   d2                              ; start y
        clr.l   d3                              ; end x
        clr.l   d4                              ; end y

        ; end y = min(end board y, end piece y);
        move.b  #PHEIGHT-1, d0
        add.b   1(a0), d0
        move.b  #BOARDHEIGHT-1, d1
        jsr     min
        move.b  d0, d4

        ; end x = min(end board x, end piece x)
        move.b  #PWIDTH-1, d0
        add.b   (a0), d0
        move.b  #BOARDWIDTH-1, d1
        jsr     min
        move.b  d0, d3

        ; start y = max(start board y, start piece y)
        move.b  1(a0), d0
        clr.b   d1
        jsr     max
        move.b  d0, d2

        ; start x = max(start baord x, start piece x)
        move.b  (a0), d0
        jsr     max
        move.b  d0, d1

        rts

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
        move.w  #$07<<8|$00, -(a7)              ; x, y
        jsr     pieceinit
        jsr     piececheck

        ; stop simulator
        move.b  #9, d0
        trap    #15

        end     start
