                ; This is music (I hope not the same shite format as the title screen)


                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"


                section chem,code_c


TEST_TITLEPRG SET 1             ; run a test build with imported GFX

        IFND TEST_TITLEPRG
                org     $47fe4                                         ; original load address
        ELSE

                ;--------------------------------------------------
                ; TEST PROGRAM
                ;--------------------------------------------------
start
                Add.w   #$1,d0
                move.w  d0,$dff180
                jmp start     

        ENDC    
   

L00047fe4               bra.b L00048000

L00047fe6               dc.w  $0001, $091a                      ; or.b #$1a,d1
L00047fea               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047fee               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ff2               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ff6               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ffa               dc.w  $0000, $0000                      ; or.b #$00,d0
L00047ffe               dc.w  $0000


L00048000               bra.w L00048180
L00048004               bra.w L00048194
L00048008               bra.w L000481e8
L0004800c               bra.w L000481e8
L00048010               bra.w L0004824e
L00048014               bra.w L0004822c
L00048018               bra.w L0004830e


L0004801c               dc.w  $ffff                             ; illegal
L0004801e               dc.w  $ffff                             ; illegal
L00048020               dc.w  $0000, $0101                      ; or.b #$01,d0
L00048024               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048028               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004802c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048030               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048034               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048038               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004803c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048040               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048044               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048048               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004804c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048050               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048054               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048058               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004805c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048060               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048064               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048068               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004806c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048070               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048074               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048078               dc.w  $0001, $0000                      ; or.b #$00,d1
L0004807c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048080               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048084               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048088               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004808c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048090               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048094               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048098               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004809c               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480a0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480a4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480a8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480ac               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480b0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480b4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480b8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480bc               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480c0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480c4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480c8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480cc               dc.w  $0000, $0002                      ; or.b #$02,d0
L000480d0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480d4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480d8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480dc               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480e0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480e4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480e8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480ec               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480f0               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480f4               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480f8               dc.w  $0000, $0000                      ; or.b #$00,d0
L000480fc               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048100               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048104               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048108               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004810c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048110               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048114               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048118               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004811c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048120               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048124               dc.w  $0004, $0000                      ; or.b #$00,d4
L00048128               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004812c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048130               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048134               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048138               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004813c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048140               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048144               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048148               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004814c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048150               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048154               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048158               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004815c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048160               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048164               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048168               dc.w  $0000, $0000                      ; or.b #$00,d0
L0004816c               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048170               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048174               dc.w  $0000, $0000                      ; or.b #$00,d0
L00048178               dc.w  $0000, $0008                      ; or.b #$08,d0
L0004817c               dc.w  $0000, $0000                      ; or.b #$00,d0


L00048180               lea.l   L00048d98,a0
L00048186               lea.l   L00048c40,a1
L0004818c               bsr.w   L00048a08
L00048190               bra.w   L00048194 (T)
L00048194               movem.l d0/a0-a1,-(a7)
L00048198               move.b  #$00,L00048022
L000481a0               move.b  #$00,L00048023
L000481a8               lea.l   L00048024,a0
L000481ae               lea.l   $00dff0a8,a1
L000481b4               bsr.b   L000481ca
L000481b6               bsr.b   L000481ca
L000481b8               bsr.b   L000481ca
L000481ba               bsr.b   L000481ca
L000481bc               move.w  #$0000,L00048020
L000481c4               movem.l (a7)+,d0/a0-a1
L000481c8               rts

L000481ca               move.w  #$0000,(a0)
L000481ce               move.w  #$0001,$004a(a0)
L000481d4               move.w  #$0000,$004c(a0)
L000481da               move.w  #$0000,(a1)
L000481de               adda.w  #$0056,a0
L000481e2               adda.w  #$0010,a1
L000481e6               rts

L000481e8               movem.l d0/d7/a0-a2,-(a7)
L000481ec               subq.w  #$01,d0
L000481ee               bmi.b   L000481f6
L000481f0               cmp.w   #$000d,d0
L000481f4               bcs.b   L000481fa
L000481f6               bsr.b   L00048194
L000481f8               bra.b   L00048226
L000481fa               lea.l   L0005847e,a2
L00048200               asl.w   #$03,d0
L00048202               adda.w  d0,a2
L00048204               lea.l   L00048024,a0
L0004820a               lea.l   $00dff0a8,a1
L00048210               moveq   #$03,d7
L00048212               tst.w   (a2)+
L00048214               bne.b   L00048220
L00048216               adda.w  #$0056,a0
L0004821a               adda.w  #$0010,a1
L0004821e               bra.b   L00048222
L00048220               bsr.b   L000481ca
L00048222               dbf.w   d7,L00048212
L00048226               movem.l (a7)+,d0/d7/a0-a2
L0004822a               rts 

L0004822c               tst.w   L00048126
L00048232               beq.b   L0004823c
L00048234               cmp.b   L00048023,d0
L0004823a               bcs.b   L0004824c
L0004823c               movem.l d0/d7/a0-a2,-(a7)
L00048240               move.w  #$4000,d1
L00048244               move.b  d0,L00048023
L0004824a               bra.b   L0004825c
L0004824c               rts  

L0004824e               movem.l d0/d7/a0-a2,-(a7)
L00048252               move.w  #$8000,d1
L00048256               move.b  d0,L00048022
L0004825c               clr.w   L0004817e
L00048262               subq.w  #$01,d0
L00048264               bmi.b   L0004826c
L00048266               cmp.w   #$000d,d0
L0004826a               bcs.b   L00048274
L0004826c               bsr.w   L00048194
L00048270               bra.w   L00048308
L00048274               lea.l   L0005847e,a0
L0004827a               asl.w   #$03,d0
L0004827c               adda.w  d0,a0
L0004827e               lea.l   L00048024,a1
L00048284               moveq   #$03,d7
L00048286               move.w  (a0)+,d0
L00048288               beq.b   L000482fa
L0004828a               lea.l   -2(a0,d0.W),a2                 ; $fe(a0,d0.W),a2
L0004828e               moveq   #$00,d0
L00048290               move.w  d0,$004c(a1)
L00048294               move.l  d0,$0002(a1)
L00048298               move.l  d0,$000a(a1)
L0004829c               move.b  d0,$0013(a1)
L000482a0               move.b  #$01,$0012(a1)
L000482a6               move.w  d1,(a1)

L000482a8               move.b  (a2)+,d0
L000482aa               bpl.b   L000482de
L000482ac               sub.b   #$80,d0
L000482b0               bne.b   L000482c0
L000482b2               movea.l $0002(a1),a2
L000482b6               cmpa.w  #$0000,a2
L000482ba               bne.b   L000482a8
L000482bc               clr.w   (a1)
L000482be               bra.b   L000482fa
L000482c0               subq.b  #$01,d0
L000482c2               bne.b   L000482ca
L000482c4               move.l  a2,$0002(a1) 
L000482c8               bra.b   L000482a8
L000482ca               subq.b  #$01,d0
L000482cc               bne.b   L000482d4
L000482ce               move.b  (a2)+,$0013(a1)
L000482d2               bra.b   L000482a8
L000482d4               subq.b  #$01,d0
L000482d6               bne.b   L000482a8
L000482d8               move.b  (a2)+,$0012(a1)
L000482dc               bra.b   L000482a8
L000482de               move.l  a2,$0006(a1)
L000482e2               lea.l   L000584e6,a2
L000482e8               ext.w   d0
L000482ea               add.w   d0,d0
L000482ec               adda.w  d0,a2
L000482ee               adda.w  (a2),a2
L000482f0               move.l  a2,$000e(a1)
L000482f4               move.w  #$0001,$0052(a1)
L000482fa               lea.l   $0056(a1),a1            ; next channel struct (86 bytes)
L000482fe               dbf.w   d7,L00048286

L00048302               or.w    d1,L00048020
L00048308               movem.l (a7)+,d0/d7/a0-a2
L0004830c               rts 


L0004830e               lea.l   $00dff000,a6
L00048314               lea.l   L00048c00,a5
L0004831a               clr.w   L0004817c
L00048320               tst.w   L00048020
L00048326               beq.b   L00048384
L00048328               addq.w  #$01,L0004817e
L0004832e               clr.w   L00048020
L00048334               lea.l   L00048024,a4
L0004833a               move.w  (a4),d7
L0004833c               beq.b   L00048348
L0004833e               bsr.b   L00048392
L00048340               move.w  d7,(a4)
L00048342               or.w    d7,L00048020
L00048348               lea.l   L0004807a,a4
L0004834e               move.w  (a4),d7
L00048350               beq.b   L$0004835c
L00048352               bsr.b   L$00048392
L00048354               move.w  d7,(a4)
L00048356               or.w    d7,L00048020
L0004835c               lea.l   L000480d0,a4
L00048362               move.w  (a4),d7
L00048364               beq.b   L00048370
L00048366               bsr.b   L00048392
L00048368               move.w  d7,(a4)
L0004836a               or.w    d7,L00048020
L00048370               lea.l   L00048126,a4
L00048376               move.w  (a4),d7
L00048378               beq.b   L00048384
L0004837a               bsr.b   L00048392
L0004837c               move.w  d7,(a4)
L0004837e               or.w    d7,L00048020
L00048384               and.w   #$c000,L00048020
L0004838c               bsr.w   L0004887e
L00048390               rts 


L00048392               subq.w  #$01,$0052(a4)
L00048396               bne.w   L000486de
L0004839a               movea.l $000e(a4),a3
L0004839e               bclr.l  #$0007,d7
L000483a2               move.b  (a3)+,d0
L000483a4               bpl.w   L0004858a
L000483a8               bclr.l  #$0003,d7
L000483ac               cmp.b   #$a0,d0
L000483b0               bcc.b   L000483a2
L000483b2               lea.l   $0014(pc),a0            ;  == $000483c8,a0
L000483b6               sub.b   #$80,d0
L000483ba               ext.w   d0
L000483bc               add.w   d0,d0
L000483be               adda.w  d0,a0
L000483c0               move.w  (a0),d0
L000483c2               beq.b   L000483a2
L000483c4               jmp     $00(a0,d0.W)


L000483c8               dc.w    $0040 
L000483ca               dc.W    $00ba              ;   or.w #$00ba,d0
L000483cc               dc.w    $00c0                   ;   illegal
L000483ce               dc.w    $00c2                   ;   illegal
L000483d0               dc.w    $00c4                   ;   illegal
L000483d2               dc.w    $00ce                   ;   illegal
L000483d4               dc.w    $00d4                   ; ; 00dc                [ cmp2.b (a4),d0 ]
L000483d6               dc.w    $00dc                   ;   illegal
L000483d8               dc.w    $00ea                   ; ; 00f8 010a           [ cmp2.b (a2,$010a) == $00064561,d0 ]
L000483da               dc.w    $00f8                   ; ; 010a 0140           [ cmp2.b $0140,d0 ]
L000483dc               dc.w    $010a
L000483de               dc.w    $0140              ;   movep.w (a2,$0140) == $00064597,d0
L000483e0               dc.w    $0156                   ;   bchg.b d0,(a6)
L000483e2               dc.w    $010c
L000483e4               dc.w    $0132              ;   movep.w (a4,$0132) == $00bfe233,d0
L000483e6               dc.w    $0158                   ;   bchg.b d0,(a0)+ [00]
L000483e8               dc.w    $016e
L000483ea               dc.w    $0000              ;   bchg.b d0,(a6,$0000) == $00dff000
L000483ec               dc.w    $0000
L000483ee               dc.w    $0000              ;   or.b #$00,d0
L000483f0               dc.w    $0000
L000483f2               dc.w    $0000              ;   or.b #$00,d0
L000483f4               dc.w    $0000
L000484f6               dc.w    $0000              ;   or.b #$00,d0
L000483f8               dc.w    $0000
L000483fa               dc.w    $0000              ;   or.b #$00,d0
L000483fc               dc.w    $0000
L000483fe               dc.w    $0000              ;   or.b #$00,d0
L00048400               dc.w    $0000
L00048402               dc.w    $0000              ;   or.b #$00,d0
L00048404               dc.w    $0000
L00048406               dc.w    $0000              ;   or.b #$00,d0

00048408 266c 000a                movea.l (a4,$000a) == $00bfe10b,a3
0004840c b6fc 0000                cmpa.w #$0000,a3
00048410 6690                     bne.b #$90 == $000483a2 (T)
00048412 266c 0006                movea.l (a4,$0006) == $00bfe107,a3
00048416 102b ffff                move.b (a3,-$0001) == $00064456 [3c],d0
0004841a 532c 0012                subq.b #$01,(a4,$0012) == $00bfe113
0004841e 664e                     bne.b #$4e == $0004846e (T)
00048420 197c 0001 0012           move.b #$01,(a4,$0012) == $00bfe113
00048426 197c 0000 0013           move.b #$00,(a4,$0013) == $00bfe114
0004842c 101b                     move.b (a3)+ [57],d0
0004842e 6a3e                     bpl.b #$3e == $0004846e (T)
00048430 0400 0080                sub.b #$80,d0
00048434 661a                     bne.b #$1a == $00048450 (T)
00048436 266c 0002                movea.l (a4,$0002) == $00bfe103,a3
0004843a b6fc 0000                cmpa.w #$0000,a3
0004843e 66ec                     bne.b #$ec == $0004842c (T)
00048440 397c 0001 004a           move.w #$0001,(a4,$004a) == $00bfe14b
00048446 397c 0000 004c           move.w #$0000,(a4,$004c) == $00bfe14d
0004844c 7e00                     moveq #$00,d7
0004844e 4e75                     rts  == $6000001a

00048450 5300                     subq.b #$01,d0
00048452 6606                     bne.b #$06 == $0004845a (T)
00048454 294b 0002                move.l a3,(a4,$0002) == $00bfe103
00048458 60d2                     bra.b #$d2 == $0004842c (T)
0004845a 5300                     subq.b #$01,d0
0004845c 6606                     bne.b #$06 == $00048464 (T)
0004845e 195b 0013                move.b (a3)+ [57],(a4,$0013) == $00bfe114
00048462 60c8                     bra.b #$c8 == $0004842c (T)
00048464 5300                     subq.b #$01,d0
00048466 66c4                     bne.b #$c4 == $0004842c (T)
00048468 195b 0012                move.b (a3)+ [57],(a4,$0012) == $00bfe113
0004846c 60be                     bra.b #$be == $0004842c (T)
0004846e 294b 0006                move.l a3,(a4,$0006) == $00bfe107
00048472 47f9 0005 84e6           lea.l $000584e6,a3
00048478 4880                     ext.w d0
0004847a d040                     add.w d0,d0
0004847c d6c0                     adda.w d0,a3
0004847e d6d3                     adda.w (a3) [5777],a3
00048480 6000 ff20                bra.w #$ff20 == $000483a2 (T)

00048484 294b 000a                move.l a3,(a4,$000a) == $00bfe10b
00048488 6000 ff18                bra.w #$ff18 == $000483a2 (T)

0004848c 6000 ff14                bra.w #$ff14 == $000483a2 (T)

00048490 6000 ff10                bra.w #$ff10 == $000483a2 (T)

00048494 08c7 0005                bset.l #$0005,d7
00048498 195b 0051                move.b (a3)+ [57],(a4,$0051) == $00bfe152
0004849c 6000 ff04                bra.w #$ff04 == $000483a2 (T)

000484a0 0887 0005                bclr.l #$0005,d7
000484a4 6000 fefc                bra.w #$fefc == $000483a2 (T)

000484a8 066c 0100 0052           add.w #$0100,(a4,$0052) == $00bfe153
000484ae 6000 fef2                bra.w #$fef2 == $000483a2 (T)

000484b2 0887 0004                bclr.l #$0004,d7
000484b6 08c7 0007                bset.l #$0007,d7
000484ba 426c 004c                clr.w (a4,$004c) == $00bfe14d
000484be 6000 0208                bra.w #$0208 == $000486c8 (T)

000484c2 08c7 0003                bset.l #$0003,d7
000484c6 195b 0024                move.b (a3)+ [57],(a4,$0024) == $00bfe125
000484ca 195b 0025                move.b (a3)+ [57],(a4,$0025) == $00bfe126
000484ce 6000 fed2                bra.w #$fed2 == $000483a2 (T)

000484d2 0247 fff8                and.w #$fff8,d7
000484d6 08c7 0000                bset.l #$0000,d7
000484da 195b 0021                move.b (a3)+ [57],(a4,$0021) == $00bfe122
000484de 195b 0022                move.b (a3)+ [57],(a4,$0022) == $00bfe123
000484e2 6000 febe                bra.w #$febe == $000483a2 (T)

000484e6 0887 0000                bclr.l #$0000,d7
000484ea 6000 feb6                bra.w #$feb6 == $000483a2 (T)

000484ee 0247 fff8                and.w #$fff8,d7
000484f2 08c7 0001                bset.l #$0001,d7
000484f6 41f9 0005 8378           lea.l $00058378,a0
000484fc 7000                     moveq #$00,d0
000484fe 101b                     move.b (a3)+ [57],d0
00048500 d040                     add.w d0,d0
00048502 d0c0                     adda.w d0,a0
00048504 d0d0                     adda.w (a0) [003c],a0
00048506 1958 0032                move.b (a0)+ [00],(a4,$0032) == $00bfe133
0004850a 1958 0030                move.b (a0)+ [00],(a4,$0030) == $00bfe131
0004850e 2948 0028                move.l a0,(a4,$0028) == $00bfe129
00048512 6000 fe8e                bra.w #$fe8e == $000483a2 (T)

00048516 0887 0001                bclr.l #$0001,d7
0004851a 6000 fe86                bra.w #$fe86 == $000483a2 (T)

0004851e 0247 fff8                and.w #$fff8,d7
00048522 08c7 0002                bset.l #$0002,d7
00048526 195b 0036                move.b (a3)+ [57],(a4,$0036) == $00bfe137
0004852a 195b 0034                move.b (a3)+ [57],(a4,$0034) == $00bfe135
0004852e 195b 0035                move.b (a3)+ [57],(a4,$0035) == $00bfe136
00048532 6000 fe6e                bra.w #$fe6e == $000483a2 (T)
00048536 0887 0002                bclr.l #$0002,d7
0004853a 6000 fe66                bra.w #$fe66 == $000483a2 (T)

0004853e 41f9 0005 842a           lea.l $0005842a,a0
00048544 7000                     moveq #$00,d0
00048546 101b                     move.b (a3)+ [57],d0
00048548 d040                     add.w d0,d0
0004854a d0c0                     adda.w d0,a0
0004854c d0d0                     adda.w (a0) [003c],a0
0004854e 2948 0014                move.l a0,(a4,$0014) == $00bfe115
00048552 6000 fe4e                bra.w #$fe4e == $000483a2 (T)

00048556 41f9 0004 8c30           lea.l $00048c30,a0
0004855c 7000                     moveq #$00,d0
0004855e 101b                     move.b (a3)+ [57],d0
00048560 e940                     asl.w #$04,d0
00048562 d0c0                     adda.w d0,a0
00048564 3958 003c                move.w (a0)+ [003c],(a4,$003c) == $00bfe13d
00048568 2958 003e                move.l (a0)+ [003c004a],(a4,$003e) == $00bfe13f
0004856c 3958 0042                move.w (a0)+ [003c],(a4,$0042) == $00bfe143
00048570 2958 0044                move.l (a0)+ [003c004a],(a4,$0044) == $00bfe145
00048574 3958 0048                move.w (a0)+ [003c],(a4,$0048) == $00bfe149
00048578 0887 0006                bclr.l #$0006,d7
0004857c 4a50                     tst.w (a0) [003c]
0004857e 6700 fe22                beq.w #$fe22 == $000483a2 (F)

00048582 08c7 0006                bset.l #$0006,d7
00048586 6000 fe1a                bra.w #$fe1a == $000483a2 (T)





