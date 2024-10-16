        org     $1000

PORT:   equ     6969

host:   dc.b    '127.0.0.1',0
ip:     ds.b    16

txsize: equ     3
txbuff: dc.b    $01,$00,$69

rxsize: equ     1024
rxbuff: ds.b    rxsize

        ds.w    0

start:
        ; network client init
        move.b  #100, d0
        move.l  #(PORT<<16|1), d1
        lea.l   host, a2
        trap    #15

        ; get current ip
        move.b  #105, d0
        lea.l   ip, a2
        trap    #15

        ; send data
        move.b  #106, d0
        move.l  #(PORT<<16|txsize), d1
        lea.l   txbuff, a1
        lea.l   host, a2
        trap    #15

        ; receive data
        move.b  #107, d0
        move.l  #rxsize, d1
        lea.l   rxbuff, a1
        trap    #15

        ; close connection
        move.b #104, d0
        trap #15

        ; halt simulator
        move.b  #9, d0
        trap    #15

        end     start
