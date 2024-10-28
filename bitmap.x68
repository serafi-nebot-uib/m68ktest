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
        move.w  #15, -(a7)                      ; height
        move.w  #22, -(a7)                      ; width
        move.w  #0, -(a7)                       ; y pos
        move.w  #0, -(a7)                       ; x pos
        jsr     drawbm
        sub     #12, a7                         ; pop stack

        ; halt simulator
        move.b  #9, d0
        trap    #15

drawbm:
; arguments:
;       sp+0 (x pos)                    -> d3
;       sp+1 (y pos)                    -> d4
;       sp+2 (width)                    -> d5
;       sp+3 (height)                   -> d6
;       sp+4 (bitmap address high word) -> a0
;       sp+5 (bitmap address low word)  -> a0
        movem.w d0-d6, -(a7)
        move.l  a0, -(a7)

        ; get subroutine arguments
        movem.w 22(a7), d3-d6
        move.l  30(a7), a0
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
        move.w  d3, d1
        move.w  d4, d2
        trap    #15
.itrx:
        ; iterate through every column
        addq.w  #1, d3
        cmp.w   d3, d5
        bne     .draw
        move.w  #0, d3
.itry:
        ; iterate throught every row
        addq.w  #1, d4
        cmp.w   d4, d6
        bne     .draw

        move.l  (a7)+, a0
        movem.w (a7)+, d0-d6
        rts

        end     start
