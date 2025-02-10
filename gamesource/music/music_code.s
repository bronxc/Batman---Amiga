
                ; Load Address and File Size
                ;   Memory Contents     Stsrt Address   End Address     Byte Size
                ;   --------------------------------------------------------------
                ;       Music           $00068f7c       $0007c60e       $00013692
                ;
                ;
                ; This is music and player routine for Level 2/4 - Batmobile & Batwing
                ;
                ; $00048000  Initialise Music Player    - Set up Player Samples & Instruments
                ; $00048004  Silence All Audio          - Stop Playing and Silence Audio
                ; $00048008  Stop Audio 
                ; $0004800c  Stop Audio
                ; $00048010  Init Song                  - Initialise Song to Play (D0 = song number)
                ; $00048014  Play SFX                   - Initialise & PLay SFX on 4th audio channel (if not already playing or is higher priority of one that is playing) - L0004822c
                ; $00048018  Play Song                  - Called every VBL to play music

                ;--------------------- includes and constants ---------------------------
                INCDIR      "include"
                INCLUDE     "hw.i"


                section music,code_c

                IFND TEST_BUILD_LEVEL
; Music Player Constants
AUDIO_PLAYER_INIT               EQU $00068f80                       ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU $00068f84                       ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU $00068f88                       ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU $00068f8c                       ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU $00068f90                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU $00068f94                       ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU $00068f98                       ; regular update (vblank to keep sounds/music playing)
                ENDC
                IFD TEST_BUILD_LEVEL
; Music Player Constants
AUDIO_PLAYER_INIT               EQU Init_Player                     ; initialise music/sfx player
AUDIO_PLAYER_SILENCE            EQU Stop_Playing                    ; Silence all audio
AUDIO_PLAYER_INIT_SFX_1         EQU Init_SFX_1                      ; Initialise SFX Audio Channnel
AUDIO_PLAYER_INIT_SFX_2         EQU Init_SFX_2                      ; same as init_sfx_1 above
AUDIO_PLAYER_INIT_SONG          EQU Init_Song                       ; initialise song to play - D0.l = song/sound 1 to 13
AUDIO_PLAYER_INIT_SFX           EQU Init_SFX                        ; initialise sfx to play - d0.l = sfx 5 to 13
AUDIO_PLAYER_UPDATE             EQU Play_Sounds                     ; regular update (vblank to keep sounds/music playing)
                ENDC    

;Chem.iff - Level Music - Constants
;----------------------------------
SFX_LEVEL_MUSIC     EQU         $01
SFX_LEVEL_COMPLETE  EQU         $02
SFX_LIFE_LOST       EQU         $03
SFX_TIMER_EXPIRED   EQU         $04
SFX_DRIP            EQU         $05
SFX_GASLEAK         EQU         $06
SFX_BATROPE         EQU         $07
SFX_BATARANG        EQU         $08
SFX_GRENADE         EQU         $09
SFX_GUYHIT          EQU         $0a
SFX_SPLASH          EQU         $0b
SFX_Ricochet        EQU         $0c
SFX_EXPLOSION       EQU         $0d


;TEST_MUSIC_BUILD SET 1             ; run a test build with imported GFX

        IFND TEST_MUSIC_BUILD
                IFND TEST_BUILD_LEVEL
                        org     $47fe4                                         ; original load address
                ENDC
        ELSE

kill_system
                lea     $dff000,a6
                move.w  #$7fff,INTENA(a6)
                move.w  #$7fff,DMACON(a6)
                move.w  #$7fff,INTREQ(a6)   
                lea     kill_system,a7                              ; initialise stack 
                bsr     init_system

                ;--------------------------------------------------------------
                ; TEST PROGRAM
                ; set song number below 'SOUND_TO_PLAY' for different songs/sfx
                ;   #$01 = Level 1 Music
                ;   #$02 = Level 1 Completed
                ;   #$03 = Player Live Lost
                ;   #$04 = Unknown/Unused Music - Level Timer Run out?
                ;   #$05 = Drip SFX
                ;   #$06 = Gas Leak
                ;   #$07 = Batrope
                ;   #$08 = Batarang
                ;   #$09 = Grenade
                ;   #$0a = Bad Guy Hit
                ;   #$0b = Splash (jack in the vat)
                ;   #$0c = Ricochet
                ;   #$0d = Explosion (grenade)
                ;--------------------------------------------------

SOUND_TO_PLAY   EQU     $01                                   ; valid range #$01 to #$0d

init_test_prg
                jsr     Init_Player                           ; init music routine/instruments

                lea     $dff000,a6
                lea     level_3_interrupt,a0
                move.l  a0,$6c.w
                move.W  #$c020,INTENA(a6)                       ; enable level 3 interrupt
                move.W  #$c020,INTENA(a6)                       ; enable level 3 interrupt

                moveq   #SOUND_TO_PLAY,d0                       ; song number to play
                jsr     Init_Song                               ; init song 1

loop
                jmp     loop     



                ;---------------- level 3 interrupt ----------------
                ; vertical blank interrupt handler.
                ; play the song at 25 frames per second.
                ;
level_3_interrupt
                movem.l d0-d7/a0-a6,-(a7)
                
                lea     $dff000,a6
                move.w  INTREQR(a6),d0
                and.w   #$0020,d0
                beq     .exit_isr

                jsr     check_change_sound

.play_music     ; play music @ 25 frames per second.
                eor.w   #$0001,frameskipper
                beq.s   .exit_isr
                jsr     Play_Sounds

.exit_isr
                ; clear level 3 interrut bits
                move.w  d0,INTREQ(a6)

                movem.l (a7)+,d0-d7/a0-a6
                rte


frameskipper:   dc.w    $0000                   ; used to only update music at 25 frames per second.
                                                ; otherwise it's too fast.


                ;--------------- check change sound ------------------
                ; check for mouse press and release, if so then
                ; increment the current sound.
                ; 
check_change_sound
                btst    #$6,$bfe001
                bne.s   .button_up
.button_down
                st.b    button_down
                bra.s   .end_button_check
.button_up
                cmp.b   #$ff,button_down
                bne.s   .end_button_check
.change_music
                sf.b    button_down
                addq.b  #$01,current_song
                cmp.b   #$0d,current_song
                ble.s   .change_song
.loop_id        
                move.b  #$01,current_song
.change_song       
                jsr     do_silence_all_audio
                moveq.l #$0,d0
                move.b  current_song,d0
                jsr     do_init_song
.end_button_check
                rts

                even
button_down     dc.b    $00
current_song    dc.b    SOUND_TO_PLAY
                even



                ; ------------------- kill system -----------------
                include "./lib/kill_system.s"

        ENDC    
   
original_start: ; original address $00068f7c
        dc.l    $00068F80


Init_Player
L00068f80           bra.w   do_initialise_music_player      ; $00069100
Stop_Player
L00068f84           bra.w   do_silence_all_audio            ; $00069114
Init_SFX_1
L00068f88           bra.w   do_init_sfx_channels            ; $00069168
Init_SFX_2
L00068f8c           bra.w   do_init_sfx_channels            ; $00069168
Init_Song
L00068f90           bra.w   do_init_song                    ; $000691ce
Init_SFX
L00068f94           bra.w   do_play_sfx                     ; $000691ac
Play_Sounds
L00068f98           bra.w   do_play_sounds                  ; $0006928e

L00068F9C   dc.w    $FFFF,$FFFF,$0000,$0101,$0000,$0000,$0000,$0000     ;................
L00068FAC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FBC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FCC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FDC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00068FEC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0001,$0000     ;................
L00068FFC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006900C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006901C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006902C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006903C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006904C   dc.w    $0000,$0002,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006905C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006906C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006907C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006908C   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L0006909C   dc.w    $0000,$0000,$0000,$0000,$0004,$0000,$0000,$0000     ;................
L000690AC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690BC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690CC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690DC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L000690EC   dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0008     ;................
L000690FC   dc.w    $0000,$0000,$41F9,$0006,$9D20,$43F9,$0006,$9BC8     ;....A.... C.....


do_initialise_music_player
L00069100           lea.l   L00069d20,a0
L00069106           lea.l   L00069bc8,a1
L0006910c           bsr.w   L00069990
L00069110           bra.w   L00069114 


do_silence_all_audio
L00069114           movem.l d0/a0-a1,-(a7)
L00069118           move.b  #$00,L00068fa2
L00069120           move.b  #$00,L00068fa3
L00069128           lea.l   L00068fa4,a0
L0006912e           lea.l   L00dff0a8,a1
L00069134           bsr.b   L0006914a
L00069136           bsr.b   L0006914a
L00069138           bsr.b   L0006914a
L0006913a           bsr.b   L0006914a
L0006913c           move.w  #$0000,L00068fa0
L00069144           movem.l (a7)+,d0/a0-a1
L00069148           rts  


L0006914a           move.w  #$0000,(a0)
L0006914e           move.w  #$0001,$004a(a0)
L00069154           move.w  #$0000,$004c(a0)
L0006915a           move.w  #$0000,(a1)
L0006915e           adda.w  #$0056,a0
L00069162           adda.w  #$0010,a1
L00069166           rts 


do_init_sfx_channels
L00069168           movem.l d0/d7/a0-a2,-(a7)
L0006916c           subq.w  #$01,d0
L0006916e           bmi.b   L00069176
L00069170           cmp.w   #$000f,d0
L00069174           bcs.b   L0006917a
L00069176           bsr.b   L00069114
L00069178           bra.b   L000691a6


L0006917a           lea.l   L0007bf2c,a2
L00069180           asl.w   #$03,d0
L00069182           adda.w  d0,a2
L00069184           lea.l   L00068fa4,a0
L0006918a           lea.l   L00dff0a8,a1
L00069190           moveq   #$03,d7
L00069192           tst.w   (a2)+ 
L00069194           bne.b   L000691a0 
L00069196           adda.w  #$0056,a0
L0006919a           adda.w  #$0010,a1
L0006919e           bra.b   L000691a2 
L000691a0           bsr.b   L0006914a
L000691a2           dbf.w   d7,L00069192
L000691a6           movem.l (a7)+,d0/d7/a0-a2
L000691aa           rts  


do_play_sfx
L000691ac           tst.w   L000690a6 
L000691b2           beq.b   L000691bc a
L000691b4           cmp.b   L00068fa3,d0
L000691ba           bcs.b   L000691cc
L000691bc           movem.l d0/d7/a0-a2,-(a7)
L000691c0           move.w  #$4000,d1
L000691c4           move.b  d0,L00068fa3 
L000691ca           bra.b   L000691dc
L000691cc           rts  


do_init_song
L000691ce           movem.l d0/d7/a0-a2,-(a7)
L000691d2           move.w  #$8000,d1
L000691d6           move.b  d0,L00068fa2 
L000691dc           clr.w   L000690fe 
L000691e2           subq.w  #$01,d0
L000691e4           bmi.b   L000691ec
L000691e6           cmp.w   #$000f,d0
L000691ea           bcs.b   L000691f4
L000691ec           bsr.w   L00069114
L000691f0           bra.w   L00069288 
L000691f4           lea.l   L0007bf2c,a0
L000691fa           asl.w   #$03,d0
L000691fc           adda.w  d0,a0
L000691fe           lea.l   L00068fa4,a1
L00069204           moveq   #$03,d7
L00069206           move.w  (a0)+,d0
L00069208           beq.b   L0006927a
L0006920a           lea.l   -$02(a0,d0.w),a2        ;$fe
L0006920e           moveq   #$00,d0
L00069210           move.w  d0,$004c(a1)
L00069214           move.l  d0,$0002(a1)
L00069218           move.l  d0,$000a(a1)
L0006921c           move.b  d0,$0013(a1)
L00069220           move.b  #$01,$0012(a1)
L00069226           move.w  d1,(a1)
L00069228           move.b  (a2)+,d0
L0006922a           bpl.b   L0006925e
L0006922c           sub.b   #$80,d0
L00069230           bne.b   L00069240
L00069232           movea.l $0002(a1),a2
L00069236           cmpa.w  #$0000,a2
L0006923a           bne.b   L00069228
L0006923c           clr.w   (a1)
L0006923e           bra.b   L0006927a
L00069240           subq.b  #$01,d0
L00069242           bne.b   L0006924a
L00069244           move.l  a2,$0002(a1)
L00069248           bra.b   L00069228


L0006924a           subq.b  #$01,d0
L0006924c           bne.b   L00069254
L0006924e           move.b  (a2)+,$0013(a1)
L00069252           bra.b   L00069228 
L00069254           subq.b  #$01,d0
L00069256           bne.b   L00069228
L00069258           move.b  (a2)+,$0012(a1)
L0006925c           bra.b   L00069228 

L0006925e           move.l  a2,$0006(a1)
L00069262           lea.l   L0007c008,a2
L00069268           ext.w   d0
L0006926a           add.w   d0,d0
L0006926c           adda.w  d0,a2
L0006926e           adda.w  (a2),a2
L00069270           move.l  a2,$000e(a1)
L00069274           move.w  #$0001,$0052(a1)
L0006927a           lea.l   $0056(a1),a1
L0006927e           dbf.w   d7,L00069206
L00069282           or.w    d1,L00068fa0
L00069288           movem.l (a7)+,d0/d7/a0-a2
L0006928c           rts  


do_play_sounds
L0006928e           lea.l   $00dff000,a6
L00069294           lea.l   L00069b88,a5
L0006929a           clr.w   L000690fc
L000692a0           tst.w   L00068fa0
L000692a6           beq.b   L00069304
L000692a8           addq.w  #$01,L000690fe
L000692ae           clr.w   L00068fa0
L000692b4           lea.l   L00068fa4,a4
L000692ba           move.w  (a4),d7
L000692bc           beq.b   L000692c8
L000692be           bsr.b   L00069312
L000692c0           move.w  d7,(a4)
L000692c2           or.w    d7,L00068fa0
L000692c8           lea.l   L00068ffa,a4
L000692ce           move.w  (a4),d7
L000692d0           beq.b   L000692dc
L000692d2           bsr.b   L00069312
L000692d4           move.w  d7,(a4)
L000692d6           or.w    d7,L00068fa0
L000692dc           lea.l   L00069050,a4
L000692e2           move.w  (a4),d7
L000692e4           beq.b   L000692f0
L000692e6           bsr.b   L00069312
L000692e8           move.w  d7,(a4)
L000692ea           or.w    d7,L00068fa0
L000692f0           lea.l   L000690a6,a4
L000692f6           move.w  (a4),d7
L000692f8           beq.b   L00069304
L000692fa           bsr.b   L00069312
L000692fc           move.w  d7,(a4)
L000692fe           or.w    d7,L00068fa0
L00069304           and.w   #$c000,L00068fa0 
L0006930c           bsr.w   L00069806
L00069310           rts 


L00069312           tst.w   $0052(a4)
L00069316           beq.w   L00069666
L0006931a           subq.w  #$01,$0052(a4)
L0006931e           bne.w   L00069666
L00069322           movea.l $000e(a4),a3
L00069326           bclr.l  #$0007,d7

L0006932a           move.b  (a3)+,d0
L0006932c           bpl.w   L00069512
L00069330           bclr.l  #$0003,d7
L00069334           cmp.b   #$a0,d0
L00069338           bcc.b   L0006932a
L0006933a           lea.l   cmd_jump_table(pc),a0       ;L00069350(pc),a0
L0006933e           sub.b   #$80,d0
L00069342           ext.w   d0
L00069344           add.w   d0,d0
L00069346           adda.w  d0,a0
L00069348           move.w  (a0),d0
L0006934a           beq.b   L0006932a
L0006934c           jmp     $00(a0,d0.w)


; jump table offsets from L00069350 (32 music commands)
cmd_jump_table   
L00069350   dc.w    music_command_01-(cmd_jump_table+00)        ;$00069350 + $0040 = $00069390 - CMD 01   
L00069352   dc.w    music_command_02-(cmd_jump_table+02)        ;$00069352 + $00BA = $0006940C - CMD 02
L00069354   dc.w    music_command_03-(cmd_jump_table+04)        ;$00069354 + $00C0 = $00069414 - CMD 03   
L00069356   dc.w    music_command_04-(cmd_jump_table+06)        ;$00069356 + $00C2 = $00069418 - CMD 04   
L00069358   dc.w    music_command_05-(cmd_jump_table+08)        ;$00069358 + $00C4 = $0006941C - CMD 05   
L0006935a   dc.w    music_command_06-(cmd_jump_table+10)        ;$0006935a + $00CE = $00069428 - CMD 06   
L0006935c   dc.w    music_command_07-(cmd_jump_table+12)        ;$0006935c + $00D4 = $00069430 - CMD 07   
L0006935e   dc.w    music_command_08-(cmd_jump_table+14)        ;$0006935e + $00DC = $0006943A - CMD 08  
L00069360   dc.w    music_command_09-(cmd_jump_table+16)        ;$00069360 + $00EA = $0006944A - CMD 09   
L00069362   dc.w    music_command_10-(cmd_jump_table+18)        ;$00069362 + $00F8 = $0006945A - CMD 10   
L00069364   dc.w    music_command_11-(cmd_jump_table+20)        ;$00069364 + $010A = $0006946E - CMD 11   
L00069366   dc.w    music_command_12-(cmd_jump_table+22)        ;$00069366 + $0140 = $000694A6 - CMD 12   
L00069368   dc.w    music_command_13-(cmd_jump_table+24)        ;$00069368 + $0156 = $000694BE - CMD 13   
L0006936a   dc.w    music_command_14-(cmd_jump_table+26)        ;$0006936a + $010C = $00069476 - CMD 14   
L0006936c   dc.w    music_command_15-(cmd_jump_table+28)        ;$0006936c + $0132 = $0006949E - CMD 15   
L0006936e   dc.w    music_command_16-(cmd_jump_table+30)        ;$0006936e + $0158 = $000694C6 - CMD 16  
L00069370   dc.w    music_command_17-(cmd_jump_table+32)        ;$00069370 + $016E = $000694DE - CMD 17   
L00069372   dc.w    $0000                                       ;$00069372 + $0000 = $00000000 - CMD 18   
L00069374   dc.w    $0000                                       ;$00069374 + $0000 = $00000000 - CMD 19   
L00069376   dc.w    $0000                                       ;$00069376 + $0000 = $00000000 - CMD 20   
L00069378   dc.w    $0000                                       ;$00069378 + $0000 = $00000000 - CMD 21   
L0006937a   dc.w    $0000                                       ;$0006937a + $0000 = $00000000 - CMD 22   
L0006937c   dc.w    $0000                                       ;$0006937c + $0000 = $00000000 - CMD 23   
L0006937e   dc.w    $0000                                       ;$0006937e + $0000 = $00000000 - CMD 24  
L00069380   dc.w    $0000                                       ;$00069380 + $0000 = $00000000 - CMD 25   
L00069382   dc.w    $0000                                       ;$00069382 + $0000 = $00000000 - CMD 26   
L00069384   dc.w    $0000                                       ;$00069384 + $0000 = $00000000 - CMD 27   
L00069386   dc.w    $0000                                       ;$00069386 + $0000 = $00000000 - CMD 28   
L00069388   dc.w    $0000                                       ;$00069388 + $0000 = $00000000 - CMD 29   
L0006938a   dc.w    $0000                                       ;$0006938a + $0000 = $00000000 - CMD 30   
L0006938c   dc.w    $0000                                       ;$0006938c + $0000 = $00000000 - CMD 31  
L0006938e   dc.w    $0000                                       ;$0006938e + $0000 = $00000000 - CMD 32 



music_command_01
L00069390           movea.l $000a(a4),a3
L00069394           cmpa.w  #$0000,a3
L00069398           bne.b   L0006932a
L0006939a           movea.l $0006(a4),a3
L0006939e           move.b  -$0001(a3),d0
L000693a2           subq.b  #$01,$0012(a4)
L000693a6           bne.b   L000693f6
L000693a8           move.b  #$01,$0012(a4)
L000693ae           move.b  #$00,$0013(a4)
L000693b4           move.b  (a3)+,d0
L000693b6           bpl.b   L000693f6
L000693b8           sub.b   #$80,d0
L000693bc           bne.b   L000693d8
L000693be           movea.l $0002(a4),a3
L000693c2           cmpa.w  #$0000,a3
L000693c6           bne.b   L000693b4
L000693c8           move.w  #$0001,$004a(a4)
L000693ce           move.w  #$0000,$004c(a4)
L000693d4           moveq   #$00,d7
L000693d6           rts  


L000693d8           subq.b  #$01,d0
L000693da           bne.b   L000693e2
L000693dc           move.l  a3,$0002(a4)
L000693e0           bra.b   L000693b4
L000693e2           subq.b  #$01,d0
L000693e4           bne.b   L000693ec
L000693e6           move.b  (a3)+,$0013(a4)
L000693ea           bra.b   L000693b4

L000693ec           subq.b  #$01,d0
L000693ee           bne.b   L000693b4
L000693f0           move.b  (a3)+,$0012(a4)
L000693f4           bra.b   L000693b4

L000693f6           move.l  a3,$0006(a4)
L000693fa           lea.l   L0007c008,a3
L00069400           ext.w   d0
L00069402           add.w   d0,d0
L00069404           adda.w  d0,a3
L00069406           adda.w  (a3),a3
L00069408           bra.w   L0006932a


music_command_02
L0006940c           move.l  a3,$000a(a4)
L00069410           bra.w   L0006932a

music_command_03
L00069414           bra.w   L0006932a

music_command_04
L00069418           bra.w   L0006932a

music_command_05
L0006941c           bset.l  #$0005,d7
L00069420           move.b  (a3)+,$0051(a4)
L00069424           bra.w   L0006932a

music_command_06
L00069428           bclr.l  #$0005,d7
L0006942c           bra.w   L0006932a


music_command_07
L00069430           add.w   #$0100,$0052(a4)
L00069436           bra.w   L0006932a

music_command_08
L0006943a           bclr.l  #$0004,d7
L0006943e           bset.l  #$0007,d7
L00069442           clr.w   $004c(a4)
L00069446           bra.w   L00069650

music_command_09
L0006944a           bset.l  #$0003,d7
L0006944e           move.b  (a3)+,$0024(a4)
L00069452           move.b  (a3)+,$0025(a4)
L00069456           bra.w   L0006932a

music_command_10
L0006945a           and.w   #$fff8,d7
L0006945e           bset.l  #$0000,d7
L00069462           move.b  (a3)+,$0021(a4)
L00069466           move.b  (a3)+,$0022(a4)
L0006946a           bra.w   L0006932a

music_command_11
L0006946e           bclr.l  #$0000,d7
L00069472           bra.w   L0006932a

music_command_14
L00069476           and.w   #$fff8,d7
L0006947a           bset.l  #$0001,d7
L0006947e           lea.l   $0007be3a,a0
L00069484           moveq   #$00,d0
L00069486           move.b  (a3)+,d0
L00069488           add.w   d0,d0
L0006948a           adda.w  d0,a0
L0006948c           adda.w  (a0),a0
L0006948e           move.b  (a0)+,$0032(a4)
L00069492           move.b  (a0)+,$0030(a4)
L00069496           move.l  a0,$0028(a4)
L0006949a           bra.w   L0006932a

music_command_15
L0006949e           bclr.l  #$0001,d7
L000694a2           bra.w   L0006932a


music_command_12
L000694a6           and.w   #$fff8,d7
L000694aa           bset.l  #$0002,d7
L000694ae           move.b  (a3)+,$0036(a4)
L000694b2           move.b  (a3)+,$0034(a4)
L000694b6           move.b  (a3)+,$0035(a4)
L000694ba           bra.w   L0006932a

music_command_13
L000694be           bclr.l  #$0002,d7
L000694c2           bra.w   L0006932a

music_command_16
L000694c6           lea.l   L0007bedc,a0
L000694cc           moveq   #$00,d0
L000694ce           move.b  (a3)+,d0
L000694d0           add.w   d0,d0
L000694d2           adda.w  d0,a0
L000694d4           adda.w  (a0),a0
L000694d6           move.l  a0,$0014(a4)
L000694da           bra.w   L0006932a

music_command_17
L000694de           lea.l   $00069bb8,a0
L000694e4           moveq   #$00,d0
L000694e6           move.b  (a3)+,d0
L000694e8           asl.w   #$04,d0
L000694ea           adda.w  d0,a0
L000694ec           move.w  (a0)+,$003c(a4)
L000694f0           move.l  (a0)+,$003e(a4)
L000694f4           move.w  (a0)+,$0042(a4)
L000694f8           move.l  (a0)+,$0044(a4)
L000694fc           move.w  (a0)+,$0048(a4)
L00069500           bclr.l  #$0006,d7
L00069504           tst.w   (a0)
L00069506           beq.w   L0006932a
L0006950a           bset.l  #$0006,d7
L0006950e           bra.w   L0006932a




                ; +ve pattern command data (end of pattern command loop)
                ; IN: A4 = Sound Channel Structure
                ; IN: A3 = Next Pattern Command Ptr
                ; IN: D0 = command data
                ; IN: D7 = Channel Ctrl Bits
process_sound_commands       
L00069512           btst.l  #$0006,d7
L00069516           bne.b   L0006951c
L00069518           add.b   $0013(a4),d0
L0006951c           move.b  d0,$004f(a4)
L00069520           btst.l  #$0000,d7
L00069524           beq.b   L00069530
L00069526           add.b   $0021(a4),d0
L0006952a           move.b  $0022(a4),$0023(a4)
L00069530           move.b  d0,$0050(a4)
L00069534           ext.w   d0
L00069536           sub.w   $003c(a4),d0
L0006953a           add.w   d0,d0
L0006953c           cmp.w   #$ffd0,d0
L00069540           blt.b   L00069548
L00069542           cmp.w   #$002c,d0
L00069546           ble.b   L0006955e

L00069548           move.b  $004f(a4),d1
L0006954c           move.b  $0050(a4),d2
L00069550           move.w  $003c(a4),d3
L00069554           move.w  $0054(a4),d4
L00069558           movea.l $0006(a4),a2
L0006955c           illegal

L0006955e           move.w  $00(a5,d0.w),$004a(a4)
L00069564           btst.l  #$0002,d7
L00069568           beq.b   L000695c4 
L0006956a           move.b  $0050(a4),d0
L0006956e           add.b   $0034(a4),d0
L00069572           ext.w   d0
L00069574           sub.w   $003c(a4),d0
L00069578           add.w   d0,d0
L0006957a           cmp.w   #$ffd0,d0
L0006957e           blt.b   L00069586
L00069580           cmp.w   #$002c,d0
L00069584           ble.b   L0006959c 

L00069586           move.b  $004f(a4),d1
L0006958a           move.b  $0050(a4),d2
L0006958e           move.w  $003c(a4),d3
L00069592           move.w  $0054(a4),d4
L00069596           movea.l $0006(a4),a2
L0006959a           illegal

L0006959c           move.w  $00(a5,d0.w),d0
L000695a0           sub.w   $004a(a4),d0
L000695a4           asr.w   #$01,d0
L000695a6           ext.l   d0
L000695a8           move.b  $0035(a4),d1
L000695ac           ext.w   d1
L000695ae           divs.w  d1,d0
L000695b0           move.w  d0,$003a(a4)
L000695b4           move.b  d1,$0039(a4)

L000695b8           add.b   d1,d1
L000695ba           move.b  d1,$0038(a4)
L000695be           move.b  $0036(a4),$0037(a4)
L000695c4           btst.l  #$0003,d7
L000695c8           beq.b   L0006961a
L000695ca           move.b  $0050(a4),d0
L000695ce           add.b   $0024(a4),d0
L000695d2           ext.w   d0
L000695d4           sub.w   $003c(a4),d0
L000695d8           add.w   d0,d0
L000695da           cmp.w   #$ffd0,d0
L000695de           blt.b   L000695e6
L000695e0           cmp.w   #$002c,d0
L000695e4           ble.b   L000695fc

L000695e6           move.b  $004f(a4),d1
L000695ea           move.b  $0050(a4),d2
L000695ee           move.w  $003c(a4),d3
L000695f2           move.w  $0054(a4),d4
L000695f6           movea.l $0006(a4),a2
L000695fa           illegal


L000695fc           move.w  $00(a5,d0.w),d0
L00069600           sub.w   $004a(a4),d0
L00069604           ext.l   d0
L00069606           moveq   #$00,d1
L00069608           move.b  $0025(a4),d1
L0006960c           divs.w  d1,d0
L0006960e           move.w  d0,$0026(a4)
L00069612           neg.w   d0
L00069614           muls.w  d1,d0
L00069616           sub.w   d0,$004a(a4)
L0006961a           btst.l  #$0001,d7
L0006961e           beq.b   L00069632
L00069620           move.b  #$01,$0033(a4)
L00069626           move.l  $0028(a4),(a4,$002c)
L0006962c           move.b  $0030(a4),(a4,$0031)
L00069632           bset.l  #$0004,d7
L00069636           move.l  $0014(a4),$0018(a4)
L0006963c           move.w  #$0001,$001e(a4)
L00069642           clr.w   $004c(a4)
L00069646           move.w  $0054(a4),d0
L0006964a           or.w    d0,L000690fc

; jmp destination from 'pattern command 08 ($87)'
L00069650           moveq   #$00,d0
L00069652           move.b  $0051(a4),d0
L00069656           btst.l  #$0005,d7
L0006965a           bne.b   L0006965e
L0006965c           move.b  (a3)+,d0
L0006965e           add.w   d0,$0052(a4)
L00069662           move.l  a3,$000e(a4)

; jmp destination from 'process_command_loop' when $0052(s) is not $0000
L00069666           btst.l  #$0007,d7
L0006966a           bne.w   L00069804

L0006966e           move.w  $004a(a4),d0
L00069672           btst.l  #$0003,d7
L00069676           beq.b   L0006968a
L00069678           subq.b  #$01,$0025(a4)
L0006967c           bne.b   L00069682
L0006967e           bclr.l  #$0003,d7
L00069682           sub.w   $0026(a4),d0
L00069686           bra.w   L0006975c


L0006968a           btst.l  #$0000,d7
L0006968e           beq.b   L000696d6
L00069690           subq.b  #$01,$0023(a4)
L00069694           bcc.w   L0006975c
L00069698           move.b  $004f(a4),d0
L0006969c           move.b  $0050(a4),d1
L000696a0           move.b  d0,$0050(a4)
L000696a4           ext.w   d0
L000696a6           sub.w   $003c(a4),d0
L000696aa           add.w   d0,d0
L000696ac           cmp.w   #$ffd0,d0
L000696b0           blt.b   L000696b8
L000696b2           cmp.w   #$002c,d0
L000696b6           ble.b   L000696ce
L000696b8           move.b  $004f(a4),d1
L000696bc           move.b  $0050(a4),d2
L000696c0           move.w  $003c(a4),d3
L000696c4           move.w  $0054(a4),d4
L000696c8           movea.l $0006(a4),a2
L000696cc           illegal


L000696ce           move.w  $00(a5,d0.w),d0
L000696d2           bra.w   L0006975c
L000696d6           btst.l  #$0001,d7
L000696da           beq.b   L00069738
L000696dc           subq.b  #$01,$0033(a4)
L000696e0           bne.b   L0006975c
L000696e2           movea.l $002c(a4),a0
L000696e6           move.b  (a0)+,d0
L000696e8           subq.b  #$01,$0031(a4)
L000696ec           bne.b   L000696f8
L000696ee           movea.l $0028(a4),a0
L000696f2           move.b  $0030(a4),$0031(a4)
L000696f8           move.l  a0,$002c(a4)
L000696fc           move.b  $0032(a4),$0033(a4)
L00069702           add.b   $0050(a4),d0
L00069706           ext.w   d0
L00069708           sub.w   $003c(a4),d0
L0006970c           add.w   d0,d0
L0006970e           cmp.w   #$ffd0,d0
L00069712           blt.b   L0006971a
L00069714           cmp.w   #$002c,d0
L00069718           ble.b   L00069730
L0006971a           move.b  $004f(a4),d1
L0006971e           move.b  $0050(a4),d2
L00069722           move.w  $003c(a4),d3
L00069726           move.w  $0054(a4),d4
L0006972a           movea.l $0006(a4),a2
L0006972e           illegal


L00069730           move.w  $00(a5,d0.w),d0
L00069734           bra.w   L0006975c
L00069738           btst.l  #$0002,d7
L0006973c           beq.b   L0006975c
L0006973e           subq.b  #$01,$0037(a4)
L00069742           bcc.b   L0006975c
L00069744           addq.b  #$01,$0037(a4)
L00069748           subq.b  #$01,$0039(a4)
L0006974c           bne.b   L00069758
L0006974e           neg.w   $003a(a4)
L00069752           move.b  $0038(a4),$0039(a4)
L00069758           add.w   $003a(a4),d0
L0006975c           move.w  d0,$004a(a4)
L00069760           btst.l  #$0004,d7
L00069764           beq.w   L00069804
L00069768           subq.w  #$01,$001e(a4)
L0006976c           bne.w   L000697ee
L00069770           movea.l $0018(a4),a0
L00069774           moveq   #$00,d0
L00069776           move.b  (a0)+,d0
L00069778           beq.b   L000697bc
L0006977a           bmi.b   L00069796
L0006977c           move.w  d0,$001e(a4)
L00069780           move.b  #$01,$001c(a4)
L00069786           move.b  #$01,$001d(a4)
L0006978c           move.b  (a0)+,$0020(a4)
L00069790           move.l  a0,$0018(a4)
L00069794           bra.b   L000697ee
L00069796           neg.b   d0
L00069798           move.w  d0,$001e(a4)
L0006979c           move.b  #$01,$0020(a4)
L000697a2           move.b  (a0)+,d0
L000697a4           bpl.b   L000697ac
L000697a6           neg.b   d0
L000697a8           neg.b   $0020(a4)
L000697ac           move.b  d0,$001c(a4)
L000697b0           move.b  #$01,$001d(a4)
L000697b6           move.l  a0,$0018(a4)
L000697ba           bra.b   L000697ee
L000697bc           move.b  (a0),d0
L000697be           beq.b   L000697ca
L000697c0           bpl.b   L000697c4
L000697c2           neg.b   d0
L000697c4           sub.w   $0052(a4),d0
L000697c8           bmi.b   L000697d0
L000697ca           bclr.l  #$0004,d7
L000697ce           bra.b   L00069804
L000697d0           neg.w   d0
L000697d2           move.w  d0,$001e(a4)
L000697d6           move.b  #$00,$001c(a4)
L000697dc           move.b  #$00,$001d(a4)
L000697e2           move.b  #$00,$0020(a4)
L000697e8           move.l  a0,$0018(a4)
L000697ec           bra.b   L00069804
L000697ee           subq.b  #$01,$001d(a4)
L000697f2           bne.b   L00069804
L000697f4           move.b  $001c(a4),$001d(a4)
L000697fa           move.b  $0020(a4),d0
L000697fe           ext.w   d0
L00069800           add.w   d0,$004c(a4)
L00069804           rts     




update_audio_custom_registers
L00069806           move.w  L000690fc,d0
L0006980c           beq.b   L0006987c
L0006980e           move.w  d0,$0096(a6)
L00069812           move.w  d0,d1
L00069814           lsl.w   #$07,d1
L00069816           move.w  d1,$009c(a6)
L0006981a           moveq   #$00,d2
L0006981c           moveq   #$01,d3
L0006981e           btst.l  #$0000,d0
L00069822           beq.b   L0006982c
L00069824           move.w  d3,$00a6(a6)
L00069828           move.w  d2,$00aa(a6)
L0006982c           btst.l  #$0001,d0
L00069830           beq.b   L0006983a
L00069832           move.w  d3,$00b6(a6)
L00069836           move.w  d2,$00ba(a6)
L0006983a           btst.l  #$0002,d0
L0006983e           beq.b   L00069848
L00069840           move.w  d3,$00c6(a6)
L00069844           move.w  d2,$00ca(a6)
L00069848           btst.l  #$0003,d0
L0006984c           beq.b   L00069856
L0006984e           move.w  d3,$00d6(a6)
L00069852           move.w  d2,$00da(a6)
L00069856           move.w  $001e(a6),d2
L0006985a           and.w   d1,d2
L0006985c           cmp.w   d1,d2
L0006985e           bne.b   L00069856
L00069860           moveq   #$02,d2
L00069862           move.w  $0006(a6),d3
L00069866           and.w   #$ff00,d3
L0006986a           move.w  $0006(a6),d4
L0006986e           and.w   #$ff00,d4
L00069872           cmp.w   d4,d3
L00069874           beq.b   L0006986a
L00069876           move.w  d4,d3
L00069878           dbf.w   d2,L0006986a

L0006987c           move.w  L00068f9c,d1
L00069882           move.w  L00068f9e,d2
L00069888           lea.l   L00068fa4,a0
L0006988e           move.w  d1,d3
L00069890           btst.b  #$0006,(a0)
L00069894           beq.b   L00069898
L00069896           move.w  d2,d3
L00069898           and.w   $004c(a0),d3
L0006989c           move.w  d3,$00a8(a6) 
L000698a0           move.w  $004a(a0),$00a6(a6)
L000698a6           btst.l  #$0000,d0
L000698aa           beq.b   L000698ba
L000698ac           move.w  $0042(a0),$00a4(a6)
L000698b2           move.l  $003e(a0),$00a0(a6)
L000698b8           bra.b   L000698c6
L000698ba           move.w  $0048(a0),$00a4(a6)
L000698c0           move.l  $0044(a0),$00a0(a6)
L000698c6           lea.l   L00068ffa,a0
L000698cc           move.w  d1,d3
L000698ce           btst.b  #$0006,(a0)
L000698d2           beq.b   L000698d6
L000698d4           move.w  d2,d3
L000698d6           and.w   $004c(a0),d3
L000698da           move.w  d3,$00b8(a6)
L000698de           move.w  $004a(a0),$00b6(a6)
L000698e4           btst.l  #$0001,d0
L000698e8           beq.b   L000698f8
L000698ea           move.w  $0042(a0),$00b4(a6)
L000698f0           move.l  $003e(a0),$00b0(a6)
L000698f6           bra.b   L00069904
L000698f8           move.w  $0048(a0),$00b4(a6)
L000698fe           move.l  $0044(a0),$00b0(a6)
L00069904           lea.l   L00069050,a0
L0006990a           move.w  d1,d3
L0006990c           btst.b  #$0006,(a0)
L00069910           beq.b   L00069914
L00069912           move.w  d2,d3
L00069914           and.w   $004c(a0),d3
L00069918           move.w  d3,$00c8(a6)
L0006991c           move.w  $004a(a0),$00c6(a6)
L00069922           btst.l  #$0002,d0
L00069926           beq.b   L00069936
L00069928           move.w  $0042(a0),$00c4(a6)
L0006992e           move.l  $003e(a0),$00c0(a6)
L00069934           bra.b   L00069942
L00069936           move.w  $0048(a0),$00c4(a6)
L0006993c           move.l  $0044(a0),$00c0(a6)
L00069942           lea.l   L000690a6,a0
L00069948           move.w  d1,d3
L0006994a           btst.b  #$0006,(a0)
L0006994e           beq.b   L00069952
L00069950           move.w  d2,d3
L00069952           and.w   $004c(a0),d3
L00069956           move.w  d3,$00d8(a6)
L0006995a           move.w  $004a(a0),$00d6(a6)
L00069960           btst.l  #$0003,d0
L00069964           beq.b   L00069974
L00069966           move.w  $0042(a0),$00d4(a6)
L0006996c           move.l  $003e(a0),$00d0(a6)
L00069972           bra.b   L00069980
L00069974           move.w  $0048(a0),$00d4(a6)
L0006997a           move.l  $0044(a0),$00d0(a6)
L00069980           or.w    #$8000,d0
L00069984           move.w  d0,$0096(a6)
L00069988           clr.w   L000690fc
L0006998e           rts  


                ;------------------- initialise music samples --------------------
                ; extract sample data ptrs and lengths from the IFF sample
                ; data.
                ;
                ; IN: a0    - music sample table address $4D52 - default_sample_data
                ; IN: a1    - music/song instrument data $4BFA - instrument_data
                ;
L00069990           move.l  (a0)+,d0
L00069992           beq.b   L000699ae
L00069994           move.w  (a0)+,(a1) 
L00069996           move.w  (a0)+,$000e(a1)
L0006999a           move.l  a0,-(a7)
L0006999c           lea.l   -8(a0,d0.l),a0      ; $f8
L000699a0           move.l  $0004(a0),d0
L000699a4           addq.l  #$08,d0
L000699a6           bsr.w   L000699b0
L000699aa           movea.l (a7)+,a0
L000699ac           bra.b   L00069990
L000699ae           rts     


                ; ------------------ process instrument  ----------------
                ; IN: A0 = ptr to start of 'FORM' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of sample including headers.
                ;
L000699b0           move.l  a1,-(a7)
L000699b2           bsr.w   L000699f4
L000699b6           movea.l (a7)+,a1
L000699b8           addq.l  #$02,a1
L000699ba           movea.l L00069b08,a0
L000699c0           move.l  (a0)+,d0
L000699c2           bclr.l  #$0000,d0
L000699c6           move.l  (a0)+,d1
L000699c8           bclr.l  #$0000,d1
L000699cc           movea.l L00069b30,a0
L000699d2           move.l  a0,(a1)+
L000699d4           adda.l  d0,a0
L000699d6           add.l   d1,d0
L000699d8           lsr.l   #$01,d0
L000699da           move.w  d0,(a1)+
L000699dc           tst.l   d1
L000699de           bne.b   L000699e8
L000699e0           lea.l   L00069d08,a0
L000699e6           moveq   #$02,d1
L000699e8           move.l  a0,(a1)+
L000699ea           lsr.l   #$01,d1
L000699ec           move.w  d1,(a1)+
L000699ee           addq.l  #$02,a1
L000699f0           rts  



; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************
;       START OF IFF '8SVX' FILE PROCESSING
; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************


                ;------------------ process sample data --------------------------
                ; Walks through the IFF 8SVX file format, storing the pointers to
                ; the BODY and VHDL chunks in the variables.
                ;
                ; Also, sets the error/status 'sample_status' - 0 = success
                ;
                ; IN: A0 = ptr to start of 'FORM' or 'CAT ' block of sample data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = remaining length of sample file including headers.
                ;
L000699f2           dc.w    $0000

L000699f4           clr.w   L000699f2
L000699fa           movem.l d0/a0,-(a7)
L000699fe           bra.w   L00069a02
L00069a02           tst.l   d0
L00069a04           beq.b   L00069a10
L00069a06           move.l  (a0)+,d1
L00069a08           subq.l  #$04,d0
L00069a0a           bsr.w   L00069a16
L00069a0e           bra.b   L00069a02
L00069a10           movem.l (a7)+,d0/a0
L00069a14           rts  


                ;------------------ process sample chunk ------------------
                ; process IFF sample data, top level of file structure.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a16           cmp.l   #'FORM',d1              ;#$464f524d,d1
L00069a1c           beq.w   L00069a74 
L00069a20           cmp.l   #'CAT ',d1              ;#$43415420,d1
L00069a26           beq.w   L00069a36
L00069a2a           move.w  #$0001,L000699f2
L00069a32           clr.l   d0
L00069a34           rts  



                ;--------------------- process CAT chunk --------------------------
                ; skips header and continues processing any further chunks 
                ; that are nested inside the CAT Chunk, data.
                ;
                ; IN: A0 = ptr to length of chunk data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a36           movem.l d0/a0,-(a7)
L00069a3a           move.l  (a0)+,d0
L00069a3c           move.l  d0,d1
L00069a3e           btst.l  #$0000,d1
L00069a42           beq.b   L00069a46
L00069a44           addq.l  #$01,d1
L00069a46           addq.l  #$04,d1
L00069a48           add.l   d1,$0004(a7)
L00069a4c           sub.l   d1,(a7)
L00069a4e           addq.l  #$04,(a0)
L00069a50           subq.l  #$04,d0
L00069a52           bra.b   L00069a02


                ;------------------- process LIST chunk -----------------
                ; skip the list chunk, and continue processing
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a54           movem.l d0/a0,-(a7)
L00069a58           move.l  (a0)+,d0
L00069a5a           move.l  d0,d1
L00069a5c           btst.l  #$0000,d1
L00069a60           beq.b   L00069a64
L00069a62           addq.l  #$01,d1
L00069a64           addq.l  #$04,d1
L00069a66           add.l   d1,$0004(a7)
L00069a6a           sub.l   d1,(a7)
L00069a6c           nop
L00069a6e           movem.l (a7)+,d0/a0
L00069a72           rts  



                ;---------------- process FORM chunk ------------------
                ; Expects to find an '8SVX' inner chunk of data.
                ; If not, then sets error/status flag = $0002
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data including length field.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069a74           movem.l d0/a0,-(a7)
L00069a78           move.l  (a0)+,d0
L00069a7a           move.l  d0,d1
L00069a7c           btst.l  #$0000,d1
L00069a80           beq.b   L00069a84
L00069a82           addq.l  #$01,d1
L00069a84           addq.l  #$04,d1
L00069a86           add.l   d1,$0004(a7)
L00069a8a           sub.l   d1,(a7)
L00069a8c           move.l  (a0)+,d1
L00069a8e           subq.l  #$04,d0
L00069a90           cmp.l   #'8SVX',d1              ;#$38535658,d1
L00069a96           beq.w   L00069aa8
L00069a9a           move.w  #$0002,L000699f2
L00069aa2           movem.l (a7)+,d0/a0
L00069aa6           rts



                ;------------------ process 8SVX chunk ---------------------
                ; loops through sample data until no bytes remaining.
                ; processes inner chunks of 8SVX chunk, including:-
                ;  - VHDL, BODY, NAME, ANNO
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0.l = length of remaining data.
                ; IN: D1.l = chunk identifier, i.e '8SVX'
                ;
L00069aa8           tst.l   d0
L00069aaa           beq.b   L00069ab6
L00069aac           move.l  (a0)+,d1
L00069aae           subq.l  #$04,d0
L00069ab0           bsr.w   L00069abc
L00069ab4           bra.b   L00069aa8
L00069ab6           movem.l (a7)+,d0/a0
L00069aba           rts  


                ;---------------- process inner 8SVX chunk --------------
                ; process data held inside the 8SVX chunk, this is only
                ; concerned with the VHDR and BODY chunks. it skips
                ; other chunks such as the NAME, ANNO meta data chunks.
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069abc           cmp.l   #'FORM',d1          ;#$464f524d,d1
L00069ac2           beq.b   L00069a74 
L00069ac4           cmp.l   #'LIST',d1          ;#$4c495354,d1
L00069aca           beq.b   L00069a54
L00069acc           cmp.l   #'CAT ',d1          ;#$43415420,d1
L00069ad2           beq.w   L00069a36 
L00069ad6           cmp.l   #'VHDR',d1          ;#$56484452,d1
L00069adc           beq.w   L00069b0c 
L00069ae0           cmp.l   #'BODY',d1          ;#$424f4459,d1
L00069ae6           beq.w   L00069b34
L00069aea           movem.l d0/a0,-(a7)
L00069aee           move.l  (a0)+,d0
L00069af0           move.l  d0,d1
L00069af2           btst.l  #$0000,d1
L00069af6           beq.b   L00069afa
L00069af8           addq.l  #$01,d1
L00069afa           addq.l  #$04,d1
L00069afc           add.l   d1,$0004(a7)
L00069b00           sub.l   d1,(a7)
L00069b02           movem.l (a7)+,d0/a0
L00069b06           rts  



                ;-------------------- process VHDR chunk ----------------------
                ; stores address of VHDR chunk in variable 'sample_vhdr_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069b08           dc.l    $00000000

L00069b0c           movem.l d0/a0,-(a7)
L00069b10           move.l  (a0)+,d0
L00069b12           move.l  d0,d1
L00069b14           btst.l  #$0000,d1
L00069b18           beq.b   L00069b1c
L00069b1a           addq.l  #$01,d1
L00069b1c           addq.l  #$04,d1
L00069b1e           add.l   d1,$0004(a7)
L00069b22           sub.l   d1,(a7)
L00069b24           move.l  a0,L00069b08
L00069b2a           movem.l (a7)+,d0/a0
L00069b2e           rts  



                ;------------------------- process body chunk ------------------------
                ; store address of the raw sample data in variable 'sample_body_ptr'
                ;
                ; IN: A0 = ptr to length of data.
                ; IN: A1 = ptr to Instrument Entry in Music Data.
                ; IN: D0 = length of remaining data.
                ; IN: D1.l = chunk identifier, e.g. FORM, CAT etc
                ;
L00069b30           dc.L    $00000000

L00069b34           movem.l d0/a0,-(a7)
L00069b38           move.l  (a0)+,d0
L00069b3a           move.l  d0,d1
L00069b3c           btst.l  #$0000,d1
L00069b40           beq.b   L00069b44
L00069b42           addq.l  #$01,d1
L00069b44           addq.l  #$04,d1
L00069b46           add.l   d1,$0004(a7)
L00069b4a           sub.l   d1,(a7)
L00069b4c           move.l  a0,L00069b30
L00069b52           movem.l (a7)+,d0/a0
L00069b56           rts  



; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************
;       END OF IFF '8SVX' FILE PROCESSING
; ************************************************************************************************************
; ************************************************************************************************************
; ************************************************************************************************************



                ; --------------------- Note Period Table ------------------------
                ;       - audio channel period values - note frequenies
                ;       - indexes to $00004bba clamped to -48 bytes or +44 bytes to remain in table range
                ;       - I've got the table running B to B (may be I'm a semi-tone out C to C - most likely) 
note_period_table      
L00069B58       dc.w    $06FE,$0699,$063B,$05E1,$058D,$053D,$04F2,$04AB     ;.....;.....=....
L00069B68       dc.w    $0467,$0428,$03EC,$03B4,$037F,$034D,$031D,$02F1     ;.g.(.......M....
L00069B78       dc.w    $02C6,$029E,$0279,$0255,$0234,$0214,$01F6,$01DA     ;.....y.U.4......

L00069B88       dc.w    $01BF,$01A6,$018F,$0178,$0163,$014F,$013C,$012B     ;.......x.c.O.<.+
L00069B98       dc.w    $011A,$010A,$00FB,$00ED,$00E0,$00D3,$00C7,$00BC     ;................
L00069BA8       dc.w    $00B2,$00A8,$009E,$0095,$008D,$0085,$007E,$0077     ;.............~.w


command_17_data
L00069BB8       dc.w    $0021,$0006,$9D0A,$000B,$0006,$9D0A,$000B,$0000     ;.!..............

instrument_data
L00069BC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069BF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C08       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C18       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C28       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C38       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C48       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C58       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C68       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C78       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C88       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069C98       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CA8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CB8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CC8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CD8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CE8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................
L00069CF8       dc.w    $0000,$0000,$0000,$0000,$0000,$0000,$0000,$0000     ;................

silient_repeat
L00069D08       dc.w    $0000 

L00069D0A       dc.w    $0074,$60DC,$82BB,$457E,$24A0,$8C00,$7460           ;...t`...E~$...t`
L00069D18       dc.w    $DC82,$BB45,$7E24,$A08C 


                ; ------ music sample data table (12 sample offsets & 2 word params) ------
                ; 12 sound samples in IFF 8SVX format.
                ; Table of address offsets below, not sure what the additional two 16 bit 
                ; parameters that follow the offset represent yet. maybe volume and something else.
                ;
raw_sample_data_table
.data_01        dc.l    sample_file_01-.data_01                 ; $00069DBC - $00069D20 = $00000009C
                dc.w    $0030,$0000 
L00069D28       dc.l    sample_file_02-.data_02                 ; $0006C1D0 - $00069D28 = $000024A8
                dc.w    $0032,$0000
                dc.l    sample_file_03-.data_03                 ; $0006D38E - $00069D30 = $0000365E
                dc.w    $000C,$FFFF 
L00069D38       dc.l    sample_file_04-.data_04                 ; $0006E7FA - $00069D38 = $00004AC2
                dc.w    $0018,$FFFF
                dc.l    sample_file_05-.data_05                 ; $0006FCB2 - $00069D40 = $00005F72
                dc.w    $0021,$0000 
L00069D48       dc.l    sample_file_06-.data_06                 ; $000708AC - $00069D48 = $00006B64
                dc.w    $002D,$0000
                dc.l    sample_file_07-.data_07                 ; $00071C7A - $00069D50 = $00007F2A
                dc.w    $0035,$FFFF 
L00069D58       dc.l    sample_file_08-.data_08                 ; $00071F38 - $00069D58 = $000081E0
                dc.w    $0037,$FFFF
                dc.l    sample_file_09-.data_09                 ; $00072B3E - $00069D60 = $00008DDE
                dc.w    $0018,$0000 
L00069D68       dc.l    sample_file_10-.data_10                 ; $00073C9A - $00069D68 = $00009F32
                dc.w    $0018,$0000
                dc.l    sample_file_11-.data_11                 ; $00075E04 - $00069D70 = $0000C094
                dc.w    $0018,$0000 
L00069D78       dc.l    sample_file_12-.data_12                 ;  - $00069D78 = $0000C7EA
                dc.w    $0018,$0000
                dc.l    sample_file_13-.data_13                 ;  - $00069D80 = $0000D0F2
                dc.w    $0018,$0000 
L00069D88       dc.l    sample_file_14-.data_14                 ;  - $00069D88 = $0000DF42
                dc.w    $0018,$0000
                dc.l    sample_file_15-.data_15                 ;  - $00069D90 = $0000E480
                dc.w    $0018,$0000 
L00069D98       dc.l    sample_file_16-.data_16                 ;  - $00069D98 = $0000F0CA
                dc.w    $0018,$0000
                dc.l    sample_file_17-.data_17                 ;  - $00069DA0 = $000109E8
                dc.w    $0018,$0000 
L00069DA8       dc.l    sample_file_18-.data_18                 ;  - $00069DA8 = $00011364
                dc.w    $0018,$0000
                dc.l    sample_file_19-.data_19                 ;  - $00069DB0 = $00011CEE
                dc.w    $0018,$0000 
L00069DB8       dc.w    $0000,$0000 


; Sample 01
sample_file_01

                ; --------------------- Sound Sample 1 -------------------
                ; Start Address: $00069DBC
                ; Name:          CRUNCHGUITAR-C4
                include "./music/sample_file_01.s"


; Sample 02
sample_file_02
                ; --------------------- Sound Sample 2 -------------------
                ; Start Address: $0006C1D0
                ; Name:          ORCH-HIT-EMAX-D4
                include "./music/sample_file_02.s"


; Sample 03
sample_file_03
                ; --------------------- Sound Sample 3 -------------------
                ; Start Address: $0006D38E
                ; Name:          HITBASS-C1
                include "./music/sample_file_03.s"



; Sample 04
sample_file_04
                ; --------------------- Sound Sample 4 -------------------
                ; Start Address: $0006E7FA
                ; Name:          HITSNARE-C2
                include "./music/sample_file_04.s"


; Sample 05
sample_file_05
                ; --------------------- Sound Sample 5 -------------------
                ; Start Address: $0006FCB2
                ; Name:          CRUNCHBASS-A2
                include "./music/sample_file_05.s"



; Sample 06
sample_file_06
                ; --------------------- Sound Sample 6 -------------------
                ; Start Address: $000708AC
                ; Name:         TIMELESS-A4     
                include "./music/sample_file_06.s"



; Sample 07
sample_file_07
                ; --------------------- Sound Sample 7 -------------------
                ; Start Address: $00071C7A
                ; Name:          KIT-HIHAT-C4
                include "./music/sample_file_07.s"


; Sample 08
sample_file_08
                ; --------------------- Sound Sample 8 -------------------
                ; Start Address: $00071F38
                ; Name:          KIT-OPENHAT-D4         
                include "./music/sample_file_08.s"


; Sample 09
sample_file_09
                ; --------------------- Sound Sample 9 -------------------
                ; Start Address: $00072B3E
                ; Name:         BATMOBILE.......       
                include "./music/sample_file_09.s"


; Sample 10
sample_file_10
                ; --------------------- Sound Sample 10 -------------------
                ; Start Address: $00073C9A
                ; Name:          SKID2
                include "./music/sample_file_10.s"


; Sample 11
sample_file_11
                ; --------------------- Sound Sample 11 -------------------
                ; Start Address: $00075E04
                ; Name:          HITCAR
00075E04 464F 524D 0000  ..........FORM..
00075E0A 0756 3853 5658 5648 4452 0000 0014 0000  .V8SVXVHDR......
00075E1A 06F6 0000 0000 0000 0020 1775 0100 0001  ......... .u....
00075E2A 0000 4E41 4D45 0000 0014 4849 5443 4152  ..NAME....HITCAR
00075E3A 0000 0000 0000 0000 0000 0000 0000 414E  ..............AN
00075E4A 4E4F 0000 0014 4175 6469 6F20 4D61 7374  NO....Audio Mast