        org     $1000

rec:
        dc.l    $00762401, $00000000, $00040004
        dc.l    $00762503, $00040000, $00080004
        dc.l    $00762502, $00080000, $000c0004
        dc.l    $00762401, $00000000, $00400040
        dc.l    $00772503, $00000004, $00040008
        dc.l    $00fcfaf9, $00040004, $00080008
        dc.l    $00f3d2bc, $00080004, $000c0008
        dc.l    $00e18647, $000c0004, $00100008
        dc.l    $00e18547, $00100004, $00300008
        dc.l    $00e18546, $00300004, $00340008
        dc.l    $00de682d, $00340004, $00380008
        dc.l    $00dc5820, $00380004, $003c0008
        dc.l    $00762502, $00000008, $0004000c
        dc.l    $00f3d2bc, $00040008, $0008000c
        dc.l    $00eca382, $00080008, $000c000c
        dc.l    $00de6027, $000c0008, $0010000c
        dc.l    $00de5f27, $00100008, $0030000c
        dc.l    $00de5f26, $00300008, $0034000c
        dc.l    $00db5a22, $00340008, $0038000c
        dc.l    $00cb521e, $00380008, $003c000c
        dc.l    $00e18647, $0004000c, $00080010
        dc.l    $00de6027, $0008000c, $000c0010
        dc.l    $00de5c22, $000c000c, $00100010
        dc.l    $00de6226, $0010000c, $00140010
        dc.l    $00de6326, $0014000c, $002c0010
        dc.l    $00de6226, $002c000c, $00300010
        dc.l    $00de5c22, $0030000c, $00340010
        dc.l    $00d55620, $0034000c, $00380034
        dc.l    $00a8451a, $0038000c, $003c0034
        dc.l    $00e18547, $00040010, $00080030
        dc.l    $00de5f27, $00080010, $000c0034
        dc.l    $00de6226, $000c0010, $00100014
        dc.l    $00de7530, $00100010, $00140014
        dc.l    $00db6e2e, $00140010, $002c0014
        dc.l    $00de7530, $002c0010, $00300014
        dc.l    $00de6226, $00300010, $00340014
        dc.l    $00de6326, $000c0014, $0010002c
        dc.l    $00db6e2e, $00100014, $0014002c
        dc.l    $00c53f20, $00140014, $00180018
        dc.l    $00c54020, $00180014, $00280018
        dc.l    $00c53f20, $00280014, $002c0018
        dc.l    $00db6e2e, $002c0014, $0030002c
        dc.l    $00de6326, $00300014, $0034002c
        dc.l    $00c54020, $00140018, $00180028
        dc.l    $00c64121, $00180018, $00280028
        dc.l    $00c54020, $00280018, $002c0028
        dc.l    $00c53f20, $00140028, $0018002c
        dc.l    $00c54020, $00180028, $0028002c
        dc.l    $00c53f20, $00280028, $002c002c
        dc.l    $00de6226, $000c002c, $00100030
        dc.l    $00de7530, $0010002c, $00140030
        dc.l    $00db6e2e, $0014002c, $002c0030
        dc.l    $00de7530, $002c002c, $00300030
        dc.l    $00de6226, $0030002c, $00340030
        dc.l    $00e18546, $00040030, $00080034
        dc.l    $00de5c22, $000c0030, $00100034
        dc.l    $00de6226, $00100030, $00140034
        dc.l    $00de6326, $00140030, $002c0034
        dc.l    $00de6226, $002c0030, $00300034
        dc.l    $00de5c22, $00300030, $00340034
        dc.l    $00de682d, $00040034, $00080038
        dc.l    $00db5a22, $00080034, $000c0038
        dc.l    $00d55620, $000c0034, $00340038
        dc.l    $00d85720, $00340034, $00380038
        dc.l    $00cb521e, $00380034, $003c0038
        dc.l    $00dc5820, $00040038, $0008003c
        dc.l    $00cb521e, $00080038, $000c003c
        dc.l    $00a8451a, $000c0038, $0034003c
        dc.l    $00cb521e, $00340038, $0038003c
        dc.l    $00dc5820, $00380038, $003c003c

        dc.l    $ffffffff                       ; end sequence

scrwidth equ    640                             ; screen width
scrheight equ   480                             ; screen height

start:
        jsr     scrinit

        ; drawrec subroutine call
        move.l  #rec, -(a7)                     ; bitmap address
        move.w  #100, -(a7)                     ; y pos
        move.w  #0, -(a7)                       ; x pos
.loop:
        jsr     drawrec
        jsr     scrplot
        addq.w  #2, (a7)
        bra     .loop
        sub     #8, a7                          ; pop stack

        ; halt simulator
        move.b  #9, d0
        trap    #15

scrinit:
        movem.l d0-d1, -(a7)

        ; set screen resolution
        move.b  #33, d0
        move.l  #scrwidth<<16|scrheight, d1
        trap    #15

        ; set windowed mode
        move.l  #1, d1
        trap    #15

        ; clear screen
        move.b  #11, d0
        move.l  #$ff00, d1
        trap    #15

        ; enable double buffer
        move.b  #92, d0
        move.b  #17, d1
        trap    #15

        movem.l (a7)+, d0-d1
        rts

scrplot:
        movem.l d0-d1, -(a7)

        ; change screen buffer
        move.b  #94, d0
        trap    #15

        ; clear screen
        move.b  #11, d0
        move.l  #$ff00, d1
        trap    #15

        movem.l (a7)+, d0-d1
        rts

drawrec:
; arguments:
;       sp+0 (x pos)                    -> d3
;       sp+1 (y pos)                    -> d4
;       sp+2 (bitmap address high word) -> a0
;       sp+3 (bitmap address low word)  -> a0
        movem.w d0-d6, -(a7)
        move.l  a0, -(a7)

        ; get subroutine arguments
        movem.w 22(a7), d5-d6
        move.l  26(a7), a0

.loop:
        ; set fill color
        move.l  (a0)+, d1
        move.l  d1, d2
        eor.l   #$ffffffff, d2                  ; detect end sequence
        beq     .done
        move.b  #80, d0
        trap    #15
        move.b  #81, d0
        trap    #15

        ; get source coordinates
        move.w  (a0)+, d1
        move.w  (a0)+, d2
        move.w  (a0)+, d3
        move.w  (a0)+, d4

        ; draw rectangle
        move.b  #87, d0
        add.w   d5, d1
        add.w   d5, d3
        add.w   d6, d2
        add.w   d6, d4
        trap    #15
        bra     .loop

.done:
        move.l  (a7)+, a0
        movem.w (a7)+, d0-d6
        rts

        end     start
