        org     $1000

bm:
        dc.l    $00ff0000, $00ff0000, $00ff0000, $00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000
        dc.l    $00ff0000, $00ff0000, $00ff0000, $00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000
        dc.l    $00ff0000, $00ff0000, $00ff0000, $00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000
        dc.l    $00ff0000, $00ff0000, $00ff0000, $00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000
        dc.l    $00ff0000, $00ff0000, $00ff0000, $00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000,$00ff0000

        dc.l    $0000ff00, $0000ff00, $0000ff00, $0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00
        dc.l    $0000ff00, $0000ff00, $0000ff00, $0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00
        dc.l    $0000ff00, $0000ff00, $0000ff00, $0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00
        dc.l    $0000ff00, $0000ff00, $0000ff00, $0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00
        dc.l    $0000ff00, $0000ff00, $0000ff00, $0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00,$0000ff00

        dc.l    $000000ff, $000000ff, $000000ff, $000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff
        dc.l    $000000ff, $000000ff, $000000ff, $000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff
        dc.l    $000000ff, $000000ff, $000000ff, $000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff
        dc.l    $000000ff, $000000ff, $000000ff, $000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff
        dc.l    $000000ff, $000000ff, $000000ff, $000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff,$000000ff


start:
        ; drawbm subroutine call
        move.l  #bm, -(a7)                      ; bitmap address
        move.w  #15, -(a7)                       ; height
        move.w  #22, -(a7)                       ; width
        move.w  #0, -(a7)                       ; y pos
        move.w  #0, -(a7)                       ; x pos
        jsr     drawbm
        sub     #12, a7                         ; pop stack

        ; halt simulator
        move.b  #9, d0
        trap    #15

drawbm:
; arguments:
;       0 -> x pos (d3)
;       1 -> y pos (d4)
;       2 -> width (d5)
;       3 -> height (d6)
;       4 -> bitmap address high word (a0)
;       5 -> bitmap address low word (a0)
        movem.w d0-d6, -(a7)
        move.l  a0, -(a7)

        ; get subroutine arguments
        movem.w 22(a7), d0-d4
        move.l  30(a7), a0

        ; store x, y for later use
        move.w  d3, d4 ;
        move.w  d2, d3
        move.w  d0, d5                          ; d5 -> x pos
        move.w  d1, d6                          ; d6 -> y pos
.draw:
        ; set pen color
        move.b  #80, d0
        move.l  (a0)+, d1
        ; btst.l  #25, d1                         ; check if higher byte is set (draw only if set)
        ; beq     .itrx
        ; andi.l  #$00ffffff, d1                  ; unless the higher byte is set to 0, the colour is not displayed correctly
        trap    #15

        ; draw pixel
        move.b  #82, d0
        move.w  d5, d1
        move.w  d6, d2
        trap    #15
.itrx:
        ; iterate through every column
        addq.w  #1, d5
        cmp.w   d5, d3
        bne     .draw
        move.w  #0, d5
.itry:
        ; iterate throught every row
        addq.w  #1, d6
        cmp.w   d6, d4
        bne     .draw

        move.l  (a7)+, a0
        movem.w (a7)+, d0-d6
        rts

        end     start
