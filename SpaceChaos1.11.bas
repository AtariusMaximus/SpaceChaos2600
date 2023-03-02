 rem --------------------------------------------------------
 rem Space Chaos
 rem By Steve Engelhardt (Atarius Maximus)
 rem 6/7/22
 rem bB 1.5 DPC+ 32k
 rem --------------------------------------------------------
 
 rem ---------------Set Kernel Options-----------------------
 set kernel DPC+
 set kernel_options collision(playfield,player1)
 set smartbranching on
 set optimization inlinerand
 set optimization noinlinedata
 rem --------------------------------------------------------
 
 rem --------------Jump to the titlescreen-------------------
 goto title bank3
 rem --------------------------------------------------------

 bank 2
 temp1=temp1
start
 goto init bank5
initret
 M1x=80 : rem Reset Missile1 X Position to default
 rem ------------------BEGIN MAIN LOOP-----------------------
main
 rem ------Miscellaneous Options-----------------------------
 if switchreset then reboot 
 CTRLPF = $31
 player0y=s
 NUSIZ0=$35
 NUSIZ1=$15
 rem --------------------------------------------------------

 rem -----Set X Locations for Sprites------------------------
 player0x=i
 player2x=b
 player3x=c
 player4x=d
 player5x=e
 player7x=f
 player8x=o
 player9x=u
 rem --------------------------------------------------------
 
 rem ---------Ship Movement Counter--------------------------
 cooldown1=cooldown1+1
 if cooldown1>240 then cooldown1=0
 rem --------------------------------------------------------
 
 rem ----------Visual Timer----------------------------------
 ; n=n+1 ; debug (increase timer speed)
 if cooldown1=60 then n=n+1
 if cooldown1=120 then n=n+1
 if cooldown1=180 then n=n+1
 if cooldown1=240 then n=n+1
 if n<26 then n=26 ; rem reset to beginning if powerup takes timer below the starting point
 ballheight=5
 ballx=n:bally=0
 rem --------------------------------------------------------

 rem ----------Level Up--------------------------------------
 if ballx>128 then ballx=26:level=level+1:n=25:cooldown1=0:goto levelup bank6
levelupreturn
 rem --------------------------------------------------------
 
 rem ----------Missile Barrier Movement----------------------
 m=m+1
 if m>4 then m=1
 missile0height=8 : COLUM0=$3C
 if ballx>112 then COLUM0=cooldown1 ; flash barriers when time is almost out, removed in 1.0, readded in 1.05
 if missile0x<18 then missile0x=136
 on level goto L1 L2 L3 L4 L5 L6 L7 L8 L9 L10
L1
L2
 rem if cooldown1>205 then c=c-1
L6
 missile0y=34:missile0x=missile0x-1
 goto skipLx
L3
L7
 missile0y=62:missile0x=missile0x-1
 goto skipLx
L4
L8
 missile0y=118:missile0x=missile0x-1
 goto skipLx
L5
 missile0y=90:missile0x=missile0x-1
 goto skipLx
L9
L10
 if cooldown1>119 then c=c-1:f=f-1
 missile0y=62:missile0x=missile0x-1
skipLx
 rem --------------------------------------------------------

 rem -------Lives--------------------------------------------
 _NUSIZ1=$10
 rem player1x=150:player1y=158 : rem Player1 is the lives remaining sprite, place it on-screen
 if m=1 || m=3 then player1x=148:player1y=154
 if m=2 || m=4 then player1x=4:player1y=156
 rem --------------------------------------------------------
 
 rem -------Spaceman-----------------------------------------
 if !g{5} && g{0} then player6x=a:player6y=17 else player6x=0:player6y=200
 if q{0} && m<3 then NUSIZ6{3}=0:a=a+1
 if !q{0} && m<3 then NUSIZ6{3}=1:a=a-1
 if a<20 then q{0}=1
 if a>132 then q{0}=0
 rem --------------------------------------------------------
 
 rem ----------Disappearing Spaceman-------------------------
 rem if cooldown1>190 then g{0}=0 else g{0}=1
 rem --------------------------------------------------------

 rem -------Reset Enemies------------------------------------
 rem If your ship collides with an enemy, reset locations
 if g{4} then b=16 : c=136 : d=16 : e=136 : u=16 : f=136 : o=16 : goto skipsd
 rem --------------------------------------------------------

 rem -------Enemy Movement-----------------------------------
 if q{1} && level>2 then b=b+1
 if q{3} && level>4 then d=d+1
 if q{5} && level>6 then u=u+1
 if q{7} && level>8 then o=o+1
 
 if q{1} then player2y=34:b=b+1
 if b>136 then b=16
 if !q{1} then player2y=200
 
 if q{2} then player3y=48:c=c-1
 if c<16 then c=136
 if !q{2} then player3y=200
 
 if q{3} then player4y=62:d=d+1
 if d>136 then d=16
 if !q{3} then player4y=200
 
 if q{4} then player5y=76:e=e-1
 if e<16 then e=136
 if !q{4} then player5y=200
 
 if q{5} then player9y=90:u=u+1
 if u>136 then u=16
 if !q{5} then player9y=200
 
 if q{6} then player7y=104:f=f-1
 if f<16 then f=136
 if !q{6} then player7y=200
 
 if q{7} then player8y=118:o=o+1
 if o>136 then o=16
 if !q{7} then player8y=200
skipsd
 rem --------------------------------------------------------
 
 rem -------Respawn Enemies----------------------------------
 if P0y=34 && !q{7} then q{7}=1
 if P0y=48 && !q{6} then q{6}=1 
 if P0y=62 && !q{5} then q{5}=1
 if P0y=76 && !q{1} then q{1}=1
 if P0y=90 && !q{3} then q{3}=1
 if P0y=104 && !q{2} then q{2}=1
 if P0y=118 && !q{4} then q{4}=1
 rem if P0y=132 then q{1}=1:q{2}=1:q{3}=1:q{4}=1:q{5}=1:q{6}=1:q{7}=1 ; Respawn all enemies if you return to the bottom of the screen - removed in final version
 rem --------------------------------------------------------

 rem -------Collision between Ship and Barrier---------------
 if collision(player0,missile0) then missile0x=missile0x-30:goto shipdeath1 bank4
 rem --------------------------------------------------------

 rem -------Collision between Ship and Enemy-----------------
 if !collision(player0,player1) then goto skipcoll9
 if P0y=34  then g{4}=1:q{1}=0:goto shipdeath1 bank4
 if P0y=48  then g{4}=1:q{2}=0:goto shipdeath1 bank4
 if P0y=62  then g{4}=1:q{3}=0:goto shipdeath1 bank4
 if P0y=76  then g{4}=1:q{4}=0:goto shipdeath1 bank4
 if P0y=90  then g{4}=1:q{5}=0:goto shipdeath1 bank4
 if P0y=104 then g{4}=1:q{6}=0:goto shipdeath1 bank4
 if P0y=118 then g{4}=1:q{7}=0:goto shipdeath1 bank4
 rem --------------------------------------------------------
skipcoll9

 rem -------Collision between Ship's Missile and Enemy-------
 rem if collision(player1,missile1) then AUDV1=0
 if !collision(player1,missile1) then goto enemydeathreturn
 if missile1y>30  && missile1y<38  then q{1}=0:score=score+10:fire_debounce=3:goto enemydeath2 bank4: rem player2
 if missile1y>42  && missile1y<52  then q{2}=0:score=score+10:fire_debounce=3:goto enemydeath3 bank4: rem player3
 if missile1y>58  && missile1y<66  then q{3}=0:score=score+10:fire_debounce=3:goto enemydeath4 bank4: rem player4
 if missile1y>72  && missile1y<80  then q{4}=0:score=score+10:fire_debounce=3:goto enemydeath5 bank4: rem player5
 if missile1y>86  && missile1y<94  then q{5}=0:score=score+10:fire_debounce=3:goto enemydeath9 bank4: rem player9
 if missile1y>100 && missile1y<108 then q{6}=0:score=score+10:fire_debounce=3:goto enemydeath7 bank4: rem player7
 if missile1y>114 && missile1y<124 then q{7}=0:score=score+10:fire_debounce=3:goto enemydeath8 bank4: rem player8
 rem --------------------------------------------------------
 
enemydeathreturn

 rem -------Collision with Spaceman-------------------------- 
 if collision(player0,player1) then g{5}=1:player6y=200:AUDV0=5:AUDC0=5:AUDF0=15
 if !collision(player0,player1) && musiccounter>14 then AUDV0=0
 rem 
 rem If 
 rem   - You're at the bottom of the screen (P0y=132)
 rem       <and>
 rem   - You're carrying a rescued astronaut (g{5}=1)
 rem Then
 rem   * reset spaceman location to top of screen (player6x=28:player6y=12)
 rem   * turn off the "rescued spaceman flag (g{5}=0)
 rem   * add 100 points (score=score+100)
 rem   * add some bonus time (n=n-9)
 rem   * add to rescued counter (rescued=rescued+1)
 rem   * play quick audio sound (AUDV0=8 :AUDC0=7:AUDF0=spacecount)
 rem
 if P0y=132 && g{5} then g{5}=0 : player6x=28:player6y=12:score=score+100:n=n-3:rescued=rescued+1:AUDV0=8 :AUDC0=7:AUDF0=spacecount ; points & extra time when returning spaceman to the bottom dock
 rem if g{5} && cooldown1>120 then AUDV0=0
 rem --------------------------------------------------------
 
 rem --------Fire Missile Audio------------------------------
 musiccounter=musiccounter+1
 if musiccounter>15 then musiccounter=1
 if P0y=20 || P0y=132 then M1y=200:goto skipfiresound : rem skip fire sound if you're at the very top or bottom of the space station - v108 added m1y=200
 if fire_debounce=1 then AUDF1=musiccounter:AUDC1=1:AUDV1=15 
skipfiresound
 rem
 rem --------------------------------------------------------

 rem --------Player0 Horizontal Movement---------------------
 if !joy0left && !joy0right && P0x>60 && P0x<90 && P0y<30 then i=71:player0y=20
 if joy0down && P0y<30 then i=71
 rem (Top of the spaceship only)
 if P0y<30 then COLUM1=0:g{2}=1 else g{2}=0
 if P0x<22 then P0x=22
 if P0x>126 then P0x=126
 rem
 if !g{2} then goto skipmove
 if joy0left then P0x=P0x-1:g{1}=1: M1y=200 
 if joy0right then P0x=P0x+1:g{1}=0: M1y=200 
skipmove
 if joy0left then g{1}=1: M1y=200 
 if joy0right then g{1}=0: M1y=200 
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 rem --------------------------------------------------------

 rem -------Up/Down Movement for Player Ship-----------------
 rem j=0    : rem joy0up debounce
 rem k=0    : rem joy0down debounce
 rem y=0    : rem frameup counter for joyup
 rem z=1    : rem framedown counter for joydown
 rem dim frameup=y
 rem dim framedown=z


 if P0y=132 then goto skipj0down
  if joy0down && j=0 then j=2
  if !joy0down && j=2 then j=1
  if j=1 then P0y=P0y+14:j=0
skipj0down

 if P0y=20 then goto skipj0up
  if joy0up && k=0 then k=2
  if !joy0up && k=2 then k=1
  if k=1 then P0y=P0y-14:k=0
skipj0up

 rem <--Below is original v1.0 up/down code-->
 rem if joy0up && j=0 then j=1
 rem if !joy0up && j=1 then j=2
 rem if j=2 && P0y>20 then P0y=P0y-14:j=0
 rem if joy0down && k=0 then k=1
 rem if !joy0down && k=1 then k=2
 rem if k=2 && P0y<132 then P0y=P0y+14:k=0
 rem --------------------------------------------------------
  
 rem -------Player0 Missile Placement------------------------
 rem COLUM0=m
 NUSIZ1=$30
 missile1height=2
 missile1x=M1x:missile1y=M1y
skipmiss4
 rem --------------------------------------------------------

 rem Left Difficulty Switch for Firing
 rem A=autofire, B=standard fire

 rem -------------Fire Player Missile------------------------
 rem if bullet flag is set, then skip firing until the bullet 
 rem hits a target or leaves the screen

 rem -------------Auto-Fire (Left Difficulty Switch)---------
 rem g{7} flag for autofire 1=on 0=off
 rem if P0y=20 || P0=132 then M1y=200 ; no firing in top or bottom positions either auto or normal
 rem if P0y=132 then M1y=200
 if g{7} then goto autofire
 rem --------------------------------------------------------

normalfire 
 rem ---Normal fire, press button to fire individual shots---
 if fire_debounce=3 && M1x<>80 then M1x=80 ; resets missile if you switch to auto while bullet is mid-flight
 if fire_debounce=3 then M1y=P0y+2:goto skipfire1
 if P0y=34 then M1y=37  
 if P0y=48 then M1y=51  
 if P0y=62 then M1y=65  
 if P0y=76 then M1y=79  
 if P0y=90 then M1y=93  
 if P0y=104 then M1y=107 
 if P0y=118  then M1y=121
skipfire1

 if joy0fire then fire_debounce=2
 if !joy0fire && fire_debounce=2 then fire_debounce=1
 
 if fire_debounce=1 && !g{1} then M1x=M1x+3
 if fire_debounce=1 && g{1} then M1x=M1x-3
 
 if fire_debounce=2 then M1x=80:AUDV0=0:AUDV1=0:
 if M1x>144 && !g{1} then M1x=80:AUDV0=0:AUDV1=0:fire_debounce=3
 if M1x<17 && g{1} then M1x=80:AUDV0=0:AUDV1=0:fire_debounce=3
 if joy0left || joy0right then fire_debounce=3
 goto skipautofire

autofire
 rem ---Auto Fire---
 if joy0left || joy0right then M1x=80:AUDV1=0:goto skipautofire  ; reset to middle reset audio if you turn the other direction or hold the joystick in one direction l/r
 if P0y=34 then M1y=37  
 if P0y=48 then M1y=51  
 if P0y=62 then M1y=65  
 if P0y=76 then M1y=79  
 if P0y=90 then M1y=93  
 if P0y=104 then M1y=107 
 if P0y=118  then M1y=121
 if M1x>144 && !g{1} then M1x=80 ; reset bullet if it goes off the edge
 if M1x<17 && g{1} then M1x=80   ; reset bullet if it goes off the edge
 if !g{1} then M1x=M1x+3         ; move bullet l/r depending on direction you're facing
 if g{1} then M1x=M1x-3          ; move bullet l/r depending on direction you're facing
 if P0y>20 && P0y<132 then AUDF1=M1x:AUDC1=1:AUDV1=15 else AUDV1=0
skipautofire

 rem --------------------------------------------------------

 rem ------CXCLR and Drawscreen------------------------------
 rem Collisions never clear, because the DPC kernel isn't hitting CXCLR up front like the other kernels
 rem Workaround is adding a "CXCLR=1" prior to your drawscreen, or after your collision detections
 CXCLR=1
 drawscreen
 rem --------------------------------------------------------

 rem ----------Playfield Resolution--------------------------
 rem These indicate the playfield resolution
 rem  It's divided up into four vertical sections of the screen
 rem Setting DF4FRAC to 255 actually gives you 175 lines of usable playfield resolution
 rem
 DF0FRACINC=255
 DF1FRACINC=255
 DF2FRACINC=255
 DF3FRACINC=255
 DF4FRACINC=255
 DF6FRACINC=255
 rem --------------------------------------------------------
 
 rem -------Playfield, Background, Colors--------------------
  playfield:
  ................................
  .X............................X.
  .X............................X.
  .X............................X.
  .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
  ................................
  ...............XX...............
  .............XXXXXX.............
  ..........XXXXXXXXXXXX..........
  ........XXXXXXXXXXXXXXXX........
  .....XXXXXXXXXXXXXXXXXXXXXX.....
  ....XXXXXXXXXXX..XXXXXXXXXXX....
  ..XXXXXXXXXXXX....XXXXXXXXXXXX..
  .XXXXXXXXXXXXX.XX.XXXXXXXXXXXXX.
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXX..........XXXXXX..........XXX
  XX............XXXX............XX
  X..............XX..............X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X..............................X
  X............X....X............X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXX.........XXXXXX.........XXXX
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  X..X.........X....X.........X..X
  .XX...........XXXX...........XX.
  .XX...........XXXX...........XX.
  X..X.........X....X.........X..X
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXX....XXXXXXXXXXXX....XXXXXX
  XXXXX......XXXXXXXXXX......XXXXX
  XXXX........XXXXXXXX........XXXX
  XXXX........XX....XX........XXXX
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  .XX..........X....X..........XX.
  XXXX.........X....X.........XXXX
  XXXX.........XXXXXX.........XXXX
  X..X.........XX..XX.........X..X
  XXXX.........XXXXXX.........XXXX
  XXXX.........XXXXXX.........XXXX
  .XX...........XXXX...........XX.
  ................................
  ................................
  .............XXXXXX.............
  ............XXXXXXXX............
  ...........XXXXXXXXXX...........
  ..........XXXXXXXXXXXX..........
  .........XXXXXXXXXXXXXX.........
  ........XXXXXXXX.XXXXXXX........
  ........XXXXXXXXXXXXXXXX........
  .......XXXXXXXXXXXXX.XXXX.......
  .......XXXXXXXXXXXXXXXXXX.......
  ......XXXXXX.XXXXXXXXXXXXX......
  ......XXXXXX.XXXXXXXXXXXXX......
  .....XXXXXXXXXXXXXXXXXXXXXX.....
  .....XXXXXXXXXXXXXXXXXXXXXX.....
  ....XXXXXXXXXXXXXXXXXXXX.XXX....
  ....XXXX.XXXXXXXXXXXXXXX.XXX....
  ...XXXXX.XXXXXX.XXXXXXXXXXXXX...
  ...XXXXXXXXXXXX.XXXXXXXXXXXXX...
  ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
  ..XXXXXXXXXXXXXXXXXXXXXXXXXXXX..
  ..XXXXXXXXX.XXXXXXXXXXXXXXXXXX..
  ..XXXXXXXXX.XXXXXXXXX.XXXXXXXX..
  .XXXXXXXXXX.XXXXXXXXX.XXXXXXXXX.
  .XXXXXXXXXXXXXXXXXXXX.XXXXXXXXX.
  .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
  .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
  XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
end

 bkcolors:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $0E
 $0C
 $0C
 $0A
 $0A
 $08
 $06
 $08
 $06
 $04
 $02
 $02
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
end

 pfcolors:
 $2E
 $28
 $0E
 $0E
 $0E
 $0C
 $0C
 $0A
 $0A
 $08
 $08
 $06
 $06
 $04
 $06
 $04
 $94
 $96
 $96
 $94
 $04
 $40
 $04
 $84
 $86
 $86
 $84
 $04
 $40
 $04
 $84
 $86
 $86
 $84
 $04
 $40
 $04
 $94
 $96
 $96
 $94
 $04
 $40
 $04
 $84
 $86
 $86
 $84
 $04
 $40
 $04
 $84
 $86
 $86
 $84
 $04
 $40
 $04
 $94
 $96
 $96
 $94
 $04
 $04
 $04
 $06
 $06
 $06
 $06
 $04
 $40
 $40
 $04
 $90
 $92
 $94
 $92
 $94
 $96
 $98
 $96
 $98
 $9A
 $9A
 $9C
 $9C
 $9E
 $00
end

 rem --------Score Colors------------------------------------
 scorecolors:
 $0C
 $0A
 $0C
 $0A
 $0C
 $0A
 $0C
 $0A
end
 rem --------------------------------------------------------

 rem -------Set heights of Sprites---------------------------
 player6height=13
 player1height=17
 player2height=8
 player3height=8
 player4height=8
 player5height=8
 player0height=8
 player7height=8
 player8height=8
 player9height=8
 rem --------------------------------------------------------

 rem ----------Sprites---------------------------------------
 player7:
  %11111111
  %00011000
  %01100110
  %11111111
  %11111111
  %01100110
  %00011000
  %11111111
end

 player5:
  %11000011
  %01100110
  %00111100
  %00111100
  %00111100
  %00111100
  %01100110
  %11000011
end

 player4:
  %11100111
  %10100101
  %01011010
  %00111100
  %00111100
  %01011010
  %10100101
  %11100111
end
 player3:
  %01000010
  %10100101
  %10100101
  %11111111
  %11111111
  %10100101
  %10100101
  %01000010
end
 player2:
  %00011000
  %00111100
  %01111110
  %11100111
  %11111111
  %01111110
  %00111100
  %00011000
end

 rem spaceman sprite

 spacecount=spacecount+1
 if spacecount>15 then spacecount=0
 player6height=11
 if spacecount=5 then goto spaceman1
 if spacecount=10 then goto spaceman2
 if spacecount=15 then goto spaceman3
 goto spacemanend

spaceman1
  player6:
  %00000000 
  %00001100 
  %00001100 
  %00000000 
  %00011110 
  %00101101
  %00101101
  %00010100
  %00010100
  %00010100
  %00010100
end
 goto spacemanend

spaceman2 
  player6:
  %00000000 
  %00011000 
  %00011000 
  %00000000 
  %00011110 
  %00101101
  %01001101
  %00010100 
  %00010100 
  %00100010 
  %01000010 
end
 goto spacemanend

spaceman3
  player6:
  %00000000 
  %00000110 
  %00000110 
  %00000000 
  %00011110 
  %00101101
  %00011100
  %00001100
  %00001010
  %00010001 
  %00010001
end
spacemanend

 player8:
  %00000000
  %00011000
  %11011011
  %11111111
  %11111111
  %11011011
  %00000000
  %00000000
end

 player9:
  %01111110
  %11100111
  %01111110
  %11101111
  %11110111
  %01111110
  %11100111
  %01111110
end

 player0:
  %11000000
  %01111000
  %00111111
  %01111110
  %01111110
  %00111111
  %01111000
  %11000000
end

 rem Lives remaining sprites (Lower right of screen, flickered)
 if m=1 || m=3 then goto lvl
 if life=2 then goto life2
 if life=1 then goto life1

 player1:
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
  %00000000
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
  %00000000
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
end
 goto lifeskip

life2
 player1:
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
  %00000000
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
end
 goto lifeskip
 
life1
 player1:
  %11000000
  %01111111
  %00111100
  %01111111
  %11000000
end
lifeskip
 goto main

 rem ----------------------------------MAIN LOOP ENDS--------------------------------------------

 rem Ship Number Sprites (Lower Left of Screen, Flickered)
lvl
 if level=9 then goto lvl9
 if level=8 then goto lvl8
 if level=7 then goto lvl7
 if level=6 then goto lvl6
 if level=5 then goto lvl5
 if level=4 then goto lvl4
 if level=3 then goto lvl3
 if level=2 then goto lvl2
 if level=1 then goto lvl1

lvl9
 player1:
  %11111111
  %11111111
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
  %00000011
  %00000011
  %00000011
  %11111111
  %11111111
end
 goto lvlskip

lvl8
 player1:
  %11111111
  %11111111
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
end
 goto lvlskip
 
lvl7
 player1:
  %11111111
  %11111111
  %00000011
  %00000011
  %00000110
  %00001100
  %00011000
  %00110000
  %01100000
  %11000000
  %11000000
  %11000000
end
 goto lvlskip

lvl6
 player1:
  %11111111
  %11111111
  %11000000
  %11000000
  %11000000
  %11111111
  %11111111
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
end
 goto lvlskip
 
lvl5
 player1:
  %11111111
  %11111111
  %11000000
  %11000000
  %11000000
  %11111111
  %11111111
  %00000011
  %00000011
  %00000011
  %11111111
  %11111111
end
 goto lvlskip
 
lvl4
 player1:
  %11000001
  %11000011
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
  %00000011
  %00000011
  %00000011
  %00000011
  %00000011
end
 goto lvlskip

lvl3
 player1:
  %11111111
  %11111111
  %00000011
  %00000011
  %00000011
  %00111111
  %00111111
  %00000011
  %00000011
  %00000011
  %11111111
  %11111111
end
 goto lvlskip

lvl2
 player1:
  %11111111
  %11111111
  %00000011
  %00000011
  %00000011
  %11111111
  %11111111
  %11000000
  %11000000
  %11000000
  %11111111
  %11111111
end
 goto lvlskip
 
lvl1
 player1:
  %00011000
  %00111000
  %01111000
  %11011000
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
  %00011000
  %11111111
  %11111111
end
lvlskip
 rem the gameover sub jumps back here to redraw the ship number sprite at the lower left, this jumps back there.
 if g{6} then return otherbank

 goto main

 bank 3
 temp1=temp1
 
 rem -------------------Titlescreen------------------------
 
 rem -----------------Reset Variables----------------------
title
 a=13
 b=32
 c=60
 d=90
 e=110
 f=140
 h=0
 i=0
 j=0
 k=0
 m=0
 o=0
 u=0
 w=28:x=100
 y=16:z=106
 var6=0
 var8=0
 musiccounter=0
 musicData=0
 
   AUDV0=0
   AUDV1=0
   duration = 1
   goto MusicSetup
 rem --------------------------------------------------------
 
titleloop
 if joy0left then g{7}=0
 if joy0right then g{7}=1
 rem if g{7}  then player9x=135:player9y=171:player6x=0:player6y=0
 rem if !g{7} then player9x=136:player9y=171:player6x=135:player6y=171
  
 rem ----------Jump to Titlescreen Music Routine-------------
 goto GetMusic
GotMusic
 rem --------------------------------------------------------

 if switchreset then reboot 
 CTRLPF = $35
 
 rem -----------Titlescreen Playfield------------------------
 playfield:
 ................................
 ................................
 ................................
 ................................
 ................................
 .............XXXXXX.............
 .........XXXXXXXXXXXXXX.........
 .......XXXXXXXXXXXXXXXXXX.......
 ....XXXXXXXXXXXXXXXXXXXXXXXX....
 ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
 .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 .XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 .X..............................
 .X.....XXXXX.XXXXX.XXXXX.XXXXXX.
 .X.....XXXXX.XXXXX.XXXXX.XXXXXX.
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .X.....X...X.X...X.X.....X......
 .XXXXX.XXXXX.XXXXX.X.....XXXXX..
 .XXXXX.XXXXX.XXXXX.X.....XXXXX..
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 .....X.X.....X...X.X.....X......
 XXXXXX.X.....X...X.XXXXX.XXXXXX.
 XXXXXX.X.....X...X.XXXXX.XXXXXX.
 ................................
 ................................
 .XXXXX.X...X.XXXXX.XXXXX.XXXXXX.
 .XXXXX.X...X.XXXXX.XXXXX.XXXXXX.
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....X...X.X...X.X...X.X......
 .X.....XXXXX.XXXXX.X...X.XXXXXX.
 .X.....XXXXX.XXXXX.X...X.XXXXXX.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .X.....X...X.X...X.X...X......X.
 .XXXXX.X...X.X...X.XXXXX......X.
 .XXXXX.X...X.X...X.XXXXX......X.
 ..............................X.
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX.
 ..XXXXXXXXXXXXXXXXXXXXXXXXXXXX..
 ...XXXXXXXXXXXXXXXXXXXXXXXXXX...
 ......XXXXXXXXXXXXXXXXXXXX......
 .......XXXXXXXXXXXXXXXXX........
 ..........XXXXXXXXXXX...........
 ................................
 ................................
 .....XX.XX.XX.XXXX.X.XXX.XX.....
 ................................
 ................................
 ................................
 ................................
 ................................
 ....XX.X.XXXX.XXX.XX.XXX.XXX....
 ................................
 ................................
 ................................
 ................................
 ...X.XXXX.XX.XX.XXXXX.XXXXX.X...
 ................................
 ................................
 ................................
 ..XX.XX.XX.XX.XX.XX.XXXX.X.XXX..
 ................................
 ................................
 .X.XX.XXX.XXXXX.XXXX.XX.XXX.XXX.
 ................................
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 X..............................X
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 X..............................X
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
 ................................
 .X.XXX.XXX.X.XXXX.XXX.XX.XX.XXX.
 ................................
 ................................
 ..XX.XXX.XXXX.XXXX.XXXX.X.XX.X..
 ................................
 ................................
 ................................
 ...XXX.XXX.XXXXX.XXX.X.XXXX.X...
 ................................
 ................................
 ................................
 ................................
 ....X.XX.XXX.XX.XX.XXXXX.XXX....
 ................................
 ................................
 ................................
 ................................
 ................................
 .....X.XX.XXX.XXX.XXX.X.X.X.....
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 ................................
 XXX.X.X.XXX.XXX.XXX.X.XXX.XXX...
 X.X.X.X..X..X.X.X...X.X.X.X.....
 XXX.X.X..X..X.X.XX..X.XXX.XX....
 X.X.X.X..X..X.X.X...X.XX..X.....
 X.X.XXX..X..XXX.X...X.X.X.XXX...
end

 DF0FRACINC=255
 DF1FRACINC=255
 DF2FRACINC=255
 DF3FRACINC=255
 DF4FRACINC=255
 DF6FRACINC=255

 bkcolors:
 $06
 $04
 $02
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $02
 $04
 $06
 $08
 $08
 $90
 $98
 $96
 $94
 $92
 $90
 $90
 $90
 $90
 $90
 $08
 $08
 $08
 $08
 $08
end

 pfcolors:
 $0C
 $0C
 $38
 $3A
 $3A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0A
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $0E
 $3C
 $3C
 $38
 $00
 $E0
 $00
 $04
 $04
 $04
 $04
 $04
 $04
 $04
 $04
 $02
 $02
 $26
 $02
 $02
 $02
 $02
 $02
 $02
 $02
 $02
 $02
 $02
 $02
 $26
 $02
 $02
 $04
 $04
 $04
 $04
 $04
 $04
 $04
 $04
 $04
 $02
 $00
 $08
 $08
 $08
 $08
 $08
 $08
 $08
 $08
 $08
 $08
 $08
 $96
 $94
 $94
 $08
end

 rem set colors for the score
 scorecolors:
 $0E
 $0C
 $0C
 $0A
 $0A
 $0C
 $0C
 $0E
end

 rem ------------Fire Button Debounce-----------------------
 if o=1 then goto nojoy3
 if joy0fire then u=99
nojoy3
 if !joy0fire then o=0
 rem --------------------------------------------------------

 CTRLPF=$31
 
 musiccounter=musiccounter+1
 if musiccounter>32 then musiccounter=0:var8=var8+1
 if var8>3 then var8=99

 rem --------------Begin Game Sequence-----------------------
 if u=99 then w=w+1:y=y+1: AUDF0=15:AUDC0=8:AUDV0=12
 if u=99 && w>127 then AUDV0=0:AUDV1=0:player1y=200:NUSIZ7=$00:score=0:u=0:ballheight=0:NUSIZ9=$00:goto start bank2
 rem --------------------------------------------------------

launchret

 rem --------------Falling Starfield-------------------------
 m=m+1
 if m>5 then m=0
 if m=4 then a=a+2:b=b+4:c=c+2:d=d+2:e=e+3:f=f+1
 if m=5 then f=f+2
 
 if m=1 then goto star1
 if m=2 then goto star2
 if m=3 then goto star3
 
star1
 rem player9x=30:player9y=a-1
 player2x=128:player2y=b
 rem player3x=45:player3y=c-3
 player4x=112:player4y=d
 player5x=69:player5y=e-9
 player6x=148:player6y=f
 goto starend

star2
 rem player9x=158:player9y=a+12
 player2x=11:player2y=b+8
 rem player3x=59:player3y=c+6
 player4x=93:player4y=d+14
 player5x=22:player5y=e+5
 player6x=131:player6y=f+9
 goto starend
 
star3
 rem player9x=150:player9y=a+7
 player2x=28:player2y=b+13
 rem player3x=37:player3y=c+17
 player4x=101:player4y=d+14
 player5x=75:player5y=e+2
 player6x=84:player6y=f+3
 goto starend
 
starend

 if a>138 then a=1
 if b>137 then b=1
 if c>138 then c=1
 if d>138 then d=1
 if e>137 then e=1
 if f>138 then f=1
 rem --------------------------------------------------------

 NUSIZ0=$17
 NUSIZ7=$15
 
 rem place spaceship and rocket flame on-screen
 player0x=w:player0y=x
 player7x=y:player7y=z
 player1y=200
 
 ballheight=0
 rem ballx=9:bally=92
 
 CXCLR=1
 drawscreen

 player0color:
 $06
 $06
 $06
 $06
 $04
 $04
 $02
 $02
 $02
 $02
 $02
 $02
 $04
 $04
 $06
 $06
 $06
 $06
end

 player7color:
 $42
 $46
 $48
 $48
 $46
 $42
end

 player2color:
 $0A
end

 player4-6color:
 $0A
end

 player0height=18
 player0:
  %11000000
  %11000000
  %01111000
  %01111000
  %00111111
  %00111111
  %01111110
  %01111110
  %01111110
  %01111110
  %01111110
  %01111110
  %00111111
  %00111111
  %01111000
  %01111000
  %11000000
  %11000000
end

 player2height=1
 player2:
  %10000000
end

 player6height=1
 player6:
  %00000001
end

 player4height=1
 player4:
  %00000100
end

 player5height=1
 player5:
  %00001000
end

 player7height=6
 player7:
  %00011111
  %01111111
  %11111111
  %11111111
  %01111111
  %00011111
end



 rem sprite to indicate autofire
 rem if g{7} then goto autoon
 rem if !g{7} then goto autooff
 if g{7}  then player9x=135:player9y=171:player3x=0:player3y=0:goto autoon
 if !g{7} then player9x=136:player9y=171:player3x=135:player3y=171:goto autooff
 goto autoend

autoon
 rem ---------------------------
 player9color:
 $9A
 $9A
 $9A
 $9A
 $9A
end
 player9height=5
 player9:
  %11101001
  %10101101
  %10101011
  %10101001
  %11101001
end
 goto autoend
 rem ---------------------------

autooff
 rem ---------------------------
 player3color:
 $9A
 $9A
 $9A
 $9A
 $9A
end
 player3height=5
 player3:
  %11100000
  %10100000
  %10100000
  %10100000
  %11100000
end
 rem ---------------------------
 player9color:
 $9C
 $9C
 $9C
 $9C
 $9C
end
 player9height=5
 player9:
  %0011011
  %0010010
  %0011011
  %0010010
  %0010010
end
 rem ---------------------------
autoend

 player8height=1
 player8:
  %00010000
end

  goto titleloop

GetMusic

   rem  *  Check for end of current note
   duration = duration - 1
   if duration>0 then GotMusic


   rem  *  Retrieve channel 0 data
   temp4 = sread(musicData)
   temp5 = sread(musicData)
   temp6 = sread(musicData)


   rem  *  Check for end of data
   if temp4=255 then duration = 1 : goto MusicSetup


   rem  *  Play channel 0
   AUDV0 = temp4
   AUDC0 = temp5
   AUDF0 = temp6


   rem  *  Retrieve channel 1 data
   temp4 = sread(musicData)
   temp5 = sread(musicData)
   temp6 = sread(musicData)


   rem  *  Play channel 1
   AUDV1 = temp4
   AUDC1 = temp5
   AUDF1 = temp6


   rem  *  Set duration
   duration = sread(musicData)
   goto GotMusic


MusicSetup
  sdata musicData=var6
  8,6,19
  0,0,0
  9
  2,6,19
  0,0,0
  8
  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  38
  2,6,23
  0,0,0
  8

  8,6,19
  0,0,0
  9
  2,6,19
  0,0,0
  8
  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  38
  2,6,23
  0,0,0
  8

  8,6,19
  0,0,0
  9
  2,6,19
  0,0,0
  8
  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  38
  2,6,23
  0,0,0
  8

  8,6,19
  0,0,0
  9
  2,6,19
  0,0,0
  8
  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  38
  2,6,23
  0,0,0
  8



  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  15
  2,6,23
  0,0,0
  8
  8,6,23
  0,0,0
  11
  8,6,26
  0,0,0
  38
  2,6,26
  0,0,0
  8


  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8
  8,6,23
  0,0,0
  15
  2,6,23
  0,0,0
  8
  8,6,23
  0,0,0
  11
  8,6,26
  0,0,0
  38
  2,6,26
  0,0,0
  8




  8,6,19
  0,0,0
  32
  2,6,19
  0,0,0
  8

  8,6,23
  0,0,0
  15
  2,6,23
  0,0,0
  8

  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8

  8,6,29
  0,0,0
  49
  2,6,29
  0,0,0
  8

  8,6,29
  0,0,0
  43
  2,6,29
  0,0,0
  8

  8,6,19
  0,0,0
  32
  2,6,19
  0,0,0
  8

  8,6,23
  0,0,0
  15
  2,6,23
  0,0,0
  8

  8,6,26
  0,0,0
  9
  2,6,26
  0,0,0
  8

  8,6,29
  0,0,0
  49
  2,6,29
  0,0,0
  8

  8,6,29
  0,0,0
  43
  2,6,29
  0,0,0
  8

  8,6,17
  0,0,0
  9
  2,6,17
  0,0,0
  8
  8,6,15
  0,0,0
  9
  2,6,15
  0,0,0
  8
  8,6,14
  0,0,0
  32
  2,6,14
  0,0,0
  8
  8,6,14
  0,0,0
  11
  8,6,15
  0,0,0
  11
  8,6,17
  0,0,0
  9
  2,6,17
  0,0,0
  8
  8,6,19
  0,0,0
  38
  2,6,19
  0,0,0
  8


  8,6,17
  0,0,0
  9
  2,6,17
  0,0,0
  8
  8,6,15
  0,0,0
  9
  2,6,15
  0,0,0
  8
  8,6,14
  0,0,0
  32
  2,6,14
  0,0,0
  8
  8,6,14
  0,0,0
  11
  8,6,15
  0,0,0
  11
  8,6,17
  0,0,0
  9
  2,6,17
  0,0,0
  8
  8,6,19
  0,0,0
  38
  2,6,19
  0,0,0
  8
 
  255
end
   goto GotMusic
   
p1blank
 player1x=0:player1y=200
 return

p2blank
 player2x=0:player2y=200
 return

p3blank
 player3x=0:player3y=200
 return

p4blank
 player4x=0:player4y=200
 return

p5blank
 player5x=0:player5y=200
 return

p7blank
 player7x=0:player7y=200
 return

p8blank
 player8x=0:player8y=200
 return
 
p9blank
 player8x=0:player8y=200
 return

 bank 4
 temp1=temp1
 
shipdeathcomplete
 deathcount=0:g{4}=0
 if M1x>144 && !g{1} then M1x=87
 if M1x<17 && g{1} then M1x=74
 player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end
 player0x=75:s=132
 g{5}=0 
 drawscreen
  if life=3 then AUDV0=1:AUDV0=0:M1x=80:goto enemydeathreturn bank2
  if life=2 then AUDV0=1:AUDV0=0:M1x=80:goto enemydeathreturn bank2
  if life=1 then AUDV0=1:AUDV0=0:M1x=80:goto enemydeathreturn bank2: rem v51
  if life=0 then AUDV0=1:AUDV0=0:M1x=80:goto gameover2 bank6
 goto enemydeathreturn bank2 
  
shipdeath1
 player0height=8
 if life=3 then life=2:goto shipdeathb
 if life=2 then life=1:goto shipdeathb
 if life=1 then life=0:goto shipdeathb
 deathcount=0

 
shipdeathb
 if switchreset then reboot
 NUSIZ0=$35
 rem AUDF0=deathcount:AUDC0=14:AUDV0=10
 
 b=16 : c=136 : d=16 : e=136 : u=16 : f=136 : o=16
 
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=4 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=8 then AUDV0=12
 if deathcount=12 then AUDV0=10
 if deathcount=16 then AUDV0=8
 if deathcount=20 then AUDV0=6
 if deathcount=24 then AUDV0=4
 if deathcount=28 then AUDV0=2
 if deathcount=32 then AUDV0=1
 if deathcount=33 then goto shipdeathcomplete
 
 if deathcount=4 then player0:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=8 then player0:
 %00000000
 %00000000
 %00010000
 %00111000
 %00111000
 %00010000
 %00000000
 %00000000
end

 if deathcount=12 then player0:
 %00000000
 %00010000
 %01000100
 %00001000
 %10100000
 %01000100
 %00010000
 %00000000
end

 if deathcount=16 then player0:
 %00001000
 %01000000
 %00000001
 %00010100
 %10101000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=20 then player0:
 %10001000
 %00000001
 %00010100
 %00000001
 %10100000
 %00010100
 %00000001
 %10010100
end

 if deathcount=24 then player0:
 %10001001
 %01010100
 %00000010
 %01000001
 %10000010
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=28 then player0:
 %01010010
 %00001000
 %00000001
 %10000010
 %00000000
 %01000000
 %00000001
 %01001000
end

 if deathcount=32 then player0:
 %01000010
 %00000001
 %10000000
 %00000000
 %00000000
 %00000000
 %00000000
 %10000001
end
 drawscreen
 goto shipdeathb
 
enemydeath2
 player0height=10
 rem missile0x=0:missile0y=200
 player2y=player2y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player2:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player2:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player2:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player2:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player2:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player2:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player2:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2
 goto enemydeath2
 
enemydeath3
 player3height=10
 rem missile0x=0:missile0y=200
 player3y=player3y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player3:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player3:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player3:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player3:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player3:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player3:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player3:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath3 

enemydeath4
 player4height=10
 rem missile0x=0:missile0y=200
 player4y=player4y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player4:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player4:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player4:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player4:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player4:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player4:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player4:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath4

enemydeath5
 player5height=10
 rem missile0x=0:missile0y=200
 player5y=player5y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player5:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player5:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player5:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player5:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player5:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player5:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player5:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath5 

enemydeath6
 player6height=10
 rem missile0x=0:missile0y=200
 player6y=player6y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player6:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player6:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player6:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player6:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player6:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player6:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player6:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath6

enemydeath7
 player7height=10
 rem missile0x=0:missile0y=200
 player7y=player7y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player7:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player7:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player7:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player7:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player7:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player7:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player7:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath7 
 
enemydeath8
 player8height=10
 rem missile0x=0:missile0y=200
 player8y=player8y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player8:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player8:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player8:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player8:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player8:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player8:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player8:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath8

enemydeath9
 player9height=10
 rem missile0x=0:missile0y=200
 player9y=player9y-1
 NUSIZ0=$35
 deathcount=deathcount+1
 if deathcount=1 then AUDV0=0:AUDV1=0
 if deathcount=2 then AUDV0=14:AUDC0=8:AUDF0=15
 if deathcount=4 then AUDV0=12
 if deathcount=6 then AUDV0=10
 if deathcount=8 then AUDV0=8
 if deathcount=10 then AUDV0=6
 if deathcount=12 then AUDV0=4
 if deathcount=14 then AUDV0=2
 if deathcount=16 then AUDV0=1
 if g{1} then REFP0=8
 if !g{1} then REFP0=0
 
 if deathcount=2 then player9:
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
 %00000000
end

 if deathcount=4 then player9:
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
 %00000000
 %00000000
 %00010000
 %00000000
 %00000000
end

 if deathcount=6 then player9:
 %00000000
 %00010000
 %01000100
 %00000000
 %00000000
 %00000000
 %00000000
 %01000100
 %00010000
 %00000000
end

 if deathcount=8 then player9:
 %00001000
 %01000000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %00000100
 %01000001
 %00001000
end
 
 if deathcount=10 then player9:
 %10001000
 %00000001
 %00010100
 %00000000
 %00000000
 %00000000
 %00000000
 %00010100
 %00000001
 %10010100
end

 if deathcount=12 then player9:
 %10001001
 %01010100
 %00000010
 %00000000
 %00000000
 %00000000
 %00000000
 %00100000
 %01001010
 %10010001
end
 
 if deathcount=14 then player9:
 %01010010
 %00001000
 %00000001
 %00000000
 %00000000
 %00000000
 %00000000
 %01000000
 %00000001
 %01001000
end

 drawscreen
 if deathcount>14 then AUDV0=0:AUDV1=0:deathcount=0:M1x=80:goto enemydeathreturn bank2

 goto enemydeath9
 
 bank 5
 temp1=temp1
 
init

 rem ----------------Sprite Colors---------------------------
 player6color:
 $06
 $0E
 $0E
 $08
 $08
 $EA
 $EA
 $EA
 $0E
 $0E
 $0A
end
 player2color:
 $F0
 $F0
 $F2
 $00
 $00
 $F2
 $F0
 $F0
end
 player3color:
 $32
 $30
 $30
 $00
 $00
 $30
 $30
 $32
end
 player4color:
 $30
 $32
 $34
 $00
 $00
 $34
 $32
 $30
end
 player5color:
 $40
 $40
 $42
 $00
 $00
 $42
 $40
 $40
end
 player7color:
 $34
 $D4
 $D8
 $00
 $00
 $D8
 $D4
 $34
end
 player8color:
 $00
 $44
 $00
 $00
 $00
 $00
 $00
 $00
end
 player9color:
 $10
 $12
 $14
 $00
 $00
 $14
 $12
 $10
end
 player0color:
 $0E
 $0C
 $0A
 $06
 $06
 $0A
 $0C
 $0E
end
 player1color:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
end
 rem --------------------------------------------------------
 
 rem -------------Set Variables------------------------------
 a=16   : rem PLAYER6X - Spaceman/astronaut X Location
 b=16   : rem PLAYER2X
 c=16   : rem PLAYER3X
 d=16   : rem PLAYER4X
 e=16   : rem PLAYER5X
 f=16   : rem PLAYER7X
          rem g is a bit variable for various tasks noted below
 h=0    : rem timer1 
 i=71   : rem PLAYER0X
 j=0    : rem joy0up debounce
 k=0    : rem joy0down debounce
 l=0    : rem Death Animation Counter
 m=0    : rem overall frame counter
 n=25   : rem ball x location for visual timer
 o=16   : rem PLAYER8X
 p=0    : rem bit variable for tracking enemy sprite movement
 s=132  : rem PLAYER0Y
 t=3    : rem lives
 u=16   : rem PLAYER9X
          rem bit variable - missile1 movement based on level
 w=0    : rem M1y
 x=1    : rem M1x
 y=0    : rem Number of Astronauts rescued
 z=0    : rem Spaceman animation
 var0=0 : rem temp4
 var1=0 : rem  duration (audio)
 var2=0 : rem level counter
 var3=0 : rem  counter (audio)
 var4=0 : rem temp5
 var5=0 : rem music counter
 var6=8 : rem  musicData
 var7=0 : rem fire_debounce
 var8=2 : rem temp6
 rem --------------------------------------------------------
 
 rem -----------Dim Variables--------------------------------
 dim P0x=i
 dim P0y=s
 dim M1x=x
 dim M1y=w
 dim fire_debounce=var7
 dim frameup=y
 dim framedown=z
 dim p2x=b
 dim p3x=c
 dim p4x=d
 dim p5x=e
 dim p6x=a
 dim p7x=f
 dim p8x=o
 dim p9x=u
 dim level=var2
 dim deathcount=l
 dim life=t
 dim cooldown1=h
 dim duration=var1
 dim counter=var3
 dim musiccounter=var5
 dim spacecount=z
 dim spacemanx=a
 dim rescued=y
 rem --------------------------------------------------------
 
 rem -------Initialize Bit Variables-------------------------
 rem --> P bit variable to control l/r movement of sprites
 rem
 p{0}=1
 p{1}=1
 p{2}=1
 p{3}=1
 p{4}=1
 p{5}=1
 p{6}=1
 p{7}=1
 rem
 rem --> Q bit variable is to keep track of enemy death
 rem
 q{0}=0
 q{1}=1
 q{2}=1
 q{3}=1
 q{4}=1
 q{5}=1
 q{6}=1
 q{7}=1
 rem
 rem --> G bit variable for various flags described below
 rem
 g{0}=1 : rem flag for extra time powerup
 g{1}=1 : rem joystick last move was left=1 right=0
 g{2}=0 : rem PLAYER0 Flag for being able to move left or right
 g{3}=1 : rem PLAYER0 Flag for being able to move up or down
 g{4}=0 : rem ship death flag (1=dead, 0=alive)
 g{5}=0 : rem rescue spaceman flag (1=rescued, 0=not rescued)
 g{6}=0 : rem flag for ship number sprite

 rem --------------------------------------------------------
 
 rem --------------------------------------------------------
 rem Set Initial Y location of player ship
 player0y=s
 level=1
 missile0x=136
 rem --------------------------------------------------------
 
 rem -----Set X Locations for Sprites------------------------
 player0x=i
 player2x=b
 player3x=c
 player4x=d
 player5x=e
 player7x=f
 player8x=o
 player9x=u
 rem --------------------------------------------------------
 
 goto initret bank2
 
 bank 6
 temp1=temp1

  rem ----------Next Ship (Intermission) Screen--------------
levelup
 if level=10 then AUDV0=0:AUDV1=0:goto gameover2
 dim Reset_Restrainer = q
 pfclear
 AUDV0=0:AUDV1=0
 cooldown1=0
 rem *Bonus Points*
  if rescued>7 then score=score+600:rescued=0 ; Get 600 bonus points if you're rescued 8 or more astronauts
  if rescued>3 then score=score+300:rescued=0 ; Get 300 bonus points if you've rescued 4 or more astronauts

StartRestart
   playfield:
 ................................
   ................................
   ................................
   ................................
   ................................
   ........XXXXX.X...X.XXXXX.......
   ........X...X.X...X...X.........
   ........X...X.X...X...X.........
   ........X...X.X...X...X.........
   ........X...X.X...X...X.........
   ........X...X.X...X...X.........
   ........XXXXX.XXXXX...X.........
   ................................
   ................................
   ...........XXXXX.XXXXX..........
   ...........X...X.X..............
   ...........X...X.X..............
   ...........X...X.XXXX...........
   ...........X...X.X..............
   ...........X...X.X..............
   ...........XXXXX.X..............
   ................................
   ................................
   XXXXX.X...X.X...X.XXXX.XXX.X...X
   X...X.X...X.X...X.X....X...XX..X
   X...X..X.X...X.X..X....X...X.X.X
   X...X...X.....X...X.XX.XX..X..XX
   X...X..X.X....X...X..X.X...X...X
   X...X.X...X...X...X..X.X...X...X
   XXXXX.X...X...X...XXXX.XXX.X...X
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ...........XXXXX.X...X..........
   ...........X...X.XX..X..........
   ...........X...X.X.X.X..........
   ...........X...X.X..XX..........
   ...........X...X.X...X..........
   ...........X...X.X...X..........
   ...........XXXXX.X...X..........
   ................................
   ................................
   ...........XXXXX.XXXXX..........
   .............X...X...X..........
   .............X...X...X..........
   .............X...X...X..........
   .............X...X...X..........
   .............X...X...X..........
   .............X...XXXXX..........
   ................................
   ................................
   ........XXXXX.X...X.XXXXX.......
   ..........X...X...X.X...........
   ..........X...X...X.X...........
   ..........X...XXXXX.XXX.........
   ..........X...X...X.X...........
   ..........X...X...X.X...........
   ..........X...X...X.XXXXX.......
   ................................
   ................................
   .....X...X.XXXXX.X...X.XXXXX....
   .....XX..X.X.....X...X...X......
   .....X.X.X.X......X.X....X......
   .....X..XX.XXXX....X.....X......
   .....X...X.X......X.X....X......
   .....X...X.X.....X...X...X......
   .....X...X.XXXXX.X...X...X......
   ................................
   ................................
   .....XXXXX.X...X.XXXXX.XXXXX....
   .....X.....X...X...X...X...X....
   .....X.....X...X...X...X...X....
   .....XXXXX.XXXXX...X...XXXXX....
   .........X.X...X...X...X........
   .........X.X...X...X...X........
   .....XXXXX.X...X.XXXXX.X........
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
   ................................
end

   pfcolors:
   $4E
end
   bkcolors:
    $00
end
   bkcolors:
   $00
end
   bkcolors:
   $00
end
   pfscroll 255 6 6
   bkcolors:
   $00
end

 Reset_Restrainer{0} = 1
   
 a=13: b=32: c=60: d=90: e=110: f=140
  h=0: i=0: j=0: k=0: m=0
 
 w=28:x=80
 y=25:h=86

Main_Loop

 rem musiccounter=musiccounter+1
 rem if musiccounter>32 then musiccounter=0
 
 if l<253 then l=l+1
 if l>252 then l=253:AUDV0=0:AUDV1=0
 
 if l=2 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  15
 if l=21 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  14
 if l=41 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  13
 if l=61 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  12
 if l=81 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  11
 if l=101 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  10
 if l=121 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  9
 if l=141 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  8
 if l=161 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  7
 if l=181 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  6
 if l=201 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  5
 if l=221 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  4
 if l=241 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  3
 if l>241 && l<253 then AUDV0 = 12 : AUDC0 = 4: AUDF0 =  2
 if l=253  then AUDV0 = 0 : AUDC0 = 0: AUDF0 =  00
 
 if switchreset then reboot 
 missile1y=200
 missile0y=200
 
 player1x=0:player1y=200 ; level number and ships remaining sprite
 ballheight=5
 ballx=156:bally=200
 
 CTRLPF=$35
 NUSIZ0=$17
 rem place spaceship and rocket flame on-screen
 player0x=w:player0y=x
 player7x=y:player7y=h
   
 m=m+1
 if m>5 then w=w+1:y=y+1:m=0
 if m=4 then a=a+2:b=b+4:c=c+2:d=d+2:e=e+3:f=f+1
 if m=5 then f=f+2
 if y>124 then y=1
 if w>127 then w=4
 
 if m=1 then goto star4
 if m=2 then goto star5
 if m=3 then goto star6
 
star4
 player9x=30:player9y=a-1
 player2x=128:player2y=b
 player3x=45:player3y=c-3
 player4x=112:player4y=d
 player5x=69:player5y=e-9
 player6x=148:player6y=f
 goto starend2

star5
 player9x=158:player9y=a+12
 player2x=11:player2y=b+8
 player3x=59:player3y=c+6
 player4x=93:player4y=d+14
 player5x=22:player5y=e+5
 player6x=131:player6y=f+9
 goto starend2
 
star6
 player9x=150:player9y=a+7
 player2x=28:player2y=b+13
 player3x=37:player3y=c+17
 player4x=101:player4y=d+14
 player5x=75:player5y=e+2
 player6x=84:player6y=f+3
 goto starend2
 
starend2

 if a>138 then a=1
 if b>137 then b=1
 if c>138 then c=1
 if d>138 then d=1
 if e>137 then e=1
 if f>138 then f=1

 player0height=18
 player0:
  %11000000
  %11000000
  %01111000
  %01111000
  %00111111
  %00111111
  %01111110
  %01111110
  %01111110
  %01111110
  %01111110
  %01111110
  %00111111
  %00111111
  %01111000
  %01111000
  %11000000
  %11000000
end

 player0color:
 $06
 $06
 $06
 $06
 $04
 $04
 $02
 $02
 $02
 $02
 $02
 $02
 $04
 $04
 $06
 $06
 $06
 $06
end

 player7height=6
 player7:
  %00011111
  %01111111
  %11111111
  %11111111
  %01111111
  %00011111
end

 player7color:
 $42
 $46
 $48
 $48
 $46
 $42
end

 player9height=1
 player9:
  %00010000
end

 player2height=1
 player2:
  %10000000
end

 player3height=1
 player3:
  %00000001
end

 player4height=1
 player4:
  %00000100
end

 player5height=1
 player5:
  %00001000
end

 player6height=1
 player6:
  %01000000
end

 player8height=1
 player8:
  %00010000
end

 player2-6color:
 $0E
end

 player7-8color:
 $0E
end

   if joy0fire then goto nexlev

   pfscroll 255 0 0
   pfscroll 255 1 1 
   pfscroll 255 2 2  
   pfscroll 255 3 3 
   pfscroll 255 4 4 

skipscroll

   DF6FRACINC = 255 ; Background colors.
   DF4FRACINC = 255 ; Playfield colors.
   DF0FRACINC = 128 ; Column 0.
   DF1FRACINC = 128 ; Column 1.
   DF2FRACINC = 128 ; Column 2.
   DF3FRACINC = 128 ; Column 3.

   drawscreen

   if !switchreset then Reset_Restrainer{0} = 0 : goto Main_Loop
   if Reset_Restrainer{0} then goto Main_Loop
 
   goto StartRestart

nexlev

 a=16   : rem PLAYER6X - Top Bomb Dropping Enemy
 b=16   : rem PLAYER2X
 c=16   : rem PLAYER3X
 d=16   : rem PLAYER4X
 e=16   : rem PLAYER5X
 f=16   : rem PLAYER7X
          rem g is a bit variable for various tasks noted below
 h=0    : rem timer1 
 i=71   : rem PLAYER0X
 j=0    : rem joy0up debounce
 k=0    : rem joy0down debounce
 l=0    : rem Death Animation Counter
 m=0    : rem overall frame counter
 n=25   : rem ball x location for visual timer
 o=16   : rem PLAYER8X
 p=0    : rem bit variable for tracking enemy sprite movement
          rem bit var
 s=132  : rem PLAYER0Y
 u=16   : rem PLAYER9X
          rem bit variable - missile1 movement based on level
 w=0    : rem M1y
 x=1    : rem M1x
 y=0    : rem astronauts rescued
 z=1    : rem Spaceman animation counter
 var5=0 : rem musiccounter
 var6=0 : rem audio1
 var7=0 : rem fire_debounce
 missile0x=136
 
 rem g bit variable to control l/r movement of sprites
 p{0}=1: p{1}=1: p{2}=1: p{3}=1: p{4}=1: p{5}=1: p{6}=1: p{7}=1

 rem q bit variable is to keep track of enemy death
 q{0}=0: q{1}=1: q{2}=1: q{3}=1: q{4}=1: q{5}=1: q{6}=1: q{7}=1

 rem g bit variable for various functions
 g{0}=1 : rem flag for extra time powerup
 g{1}=1 : rem joystick last move was left=1 right=0
 g{2}=0 : rem PLAYER0 Flag for being able to move left or right
 g{3}=1 : rem PLAYER0 Flag for being able to move up or down
 g{4}=0 : rem ship death flag (1=dead, 0=alive)
 g{5}=0 : rem rescue spaceman flag (1=rescued, 0=not rescued)
 g{6}=0 : rem flag for displaying ship number on game over screen
 rem g{7}=0 : rem Flag for autofire 1=on 0=off
 
 player6color:
 $06
 $0E
 $0E
 $08
 $08
 $EA
 $EA
 $EA
 $0E
 $0E
 $0A
end
 
 player2color:
 $F0
 $F0
 $F2
 $00
 $00
 $F2
 $F0
 $F0
end

 player3color:
 $32
 $30
 $30
 $00
 $00
 $30
 $30
 $32
end

 player4color:
 $30
 $32
 $34
 $00
 $00
 $34
 $32
 $30
end

 player5color:
 $40
 $40
 $42
 $00
 $00
 $42
 $40
 $40
end

 player7color:
 $34
 $D4
 $D8
 $00
 $00
 $D8
 $D4
 $34
end

 player8color:
 $00
 $44
 $00
 $00
 $00
 $00
 $00
 $00
end

 player9color:
 $10
 $12
 $14
 $00
 $00
 $14
 $12
 $10
end

 player0color:
 $0E
 $0C
 $0A
 $06
 $06
 $0A
 $0C
 $0E
end

 player1color:
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
 $00
end

 goto levelupreturn bank2

 
gameover2
 fire_debounce=0
 pfclear
 t=0
 g{6}=1
  if g{6} then gosub lvl bank2
 l=0
gameover3

 if l<253 then l=l+1
 if l>252 then l=253:AUDV0=0:AUDV1=0
 
 if l=2 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  1
 if l=12 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  2
 if l=22 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  3
 if l=32 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  4
 if l=42 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  5
 if l=52 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  6
 if l=62 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  7
 if l=72 then AUDV0 = 12 : AUDC0 = 12: AUDF0 = 8
 if l=82 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  9
 if l=92 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  10
 if l=102 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  11
 if l=112 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  12
 if l=122 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  13
 if l=132 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  14
 if l=142 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  15
 if l=152 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  16
 if l=162 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  17
 if l=172 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  18
 if l=182 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  19
 if l=192 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  20
 if l=202 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  21
 if l=212 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  22
 if l=222 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  23
 if l=232 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  24
 if l=242 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  25
 if l>242 && l<253 then AUDV0 = 12 : AUDC0 = 12: AUDF0 =  27
 if l=253  then AUDV0 = 0 : AUDC0 = 0: AUDF0 =  0
 
 g{6}=0
 if g{6} then g{6}=0:gosub lvl bank2
 player1x=4:player1y=156

 m=m+1
 if m>5 then w=w+1:y=y+1:m=0
 if m=4 then a=a+2:b=b+4:c=c+2:d=d+2:e=e+3:f=f+1
 if m=5 then f=f+2
 if y>124 then y=1
 if w>127 then w=4
 
 if m=1 then goto star7
 if m=2 then goto star8
 if m=3 then goto star9
 
star7
 player9x=30:player9y=a-1
 player2x=128:player2y=b
 player3x=45:player3y=c-3
 player4x=112:player4y=d
 player5x=69:player5y=e-9
 player6x=148:player6y=f
 goto starend10

star8
 player9x=158:player9y=a+12
 player2x=11:player2y=b+8
 player3x=59:player3y=c+6
 player4x=93:player4y=d+14
 player5x=22:player5y=e+5
 player6x=131:player6y=f+9
 goto starend10
 
star9
 player9x=150:player9y=a+7
 player2x=28:player2y=b+13
 player3x=37:player3y=c+17
 player4x=101:player4y=d+14
 player5x=75:player5y=e+2
 player6x=84:player6y=f+3
 goto starend10
 
starend10

 if a>138 then a=1
 if b>137 then b=1
 if c>138 then c=1
 if d>138 then d=1
 if e>137 then e=1
 if f>138 then f=1
 drawscreen
 
 player0x=74:player0y=30
 
 if joy0fire then fire_debounce=2
 if !joy0fire && fire_debounce=2 then fire_debounce=1
 if fire_debounce=1 then goto gameover4
 
 ;player1y=200
 player2y=200
 player3y=200
 player4y=200
 player5y=200
 player6y=200
 player7y=200
 player8y=200
 player9y=200
 missile0y=200
 missile1y=200
 bally=200

 player0color:
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1A
 $1E
 $1E
 $1E
 $1E
 $1E
end

 rem NUSIZ0=$15
 player0height=89
 player0:
  %11111111
  %11111111
  %11000000
  %11000000  
  %11001111
  %11001111
  %11000011
  %11000011
  %11111111
  %00000000
  %11111111
  %11111111
  %11000011
  %11000011
  %11111111
  %11000011
  %11000011
  %11000011
  %11000011
  %00000000
  %11000011
  %11100111
  %11111111
  %11011011
  %11000011
  %11000011
  %11000011
  %11000011
  %11000011
  %00000000
  %11111111
  %11111111
  %11000000
  %11000000
  %11111000
  %11111000
  %11000000
  %11000000
  %11111111
  %11111111
  %00000000
  %00000000
  %00000000
  %00000000
  %00000000
  %00000000
  %00000000
  %00000000
  %11111111
  %11111111
  %11000011
  %11000011
  %11000011
  %11000011
  %11000011
  %11111111
  %11111111
  %00000000
  %11000011
  %11000011
  %11000011
  %11000011
  %11000011
  %11000011
  %01100110
  %00111100
  %00011000
  %00000000
  %11111111
  %11111111
  %11000000
  %11000000
  %11111000
  %11111000
  %11000000
  %11000000
  %11111111
  %11111111
  %00000000
  %11111111
  %11111111
  %11000011
  %11000011
  %11111111
  %11111111
  %11011000
  %11001100
  %11000110
  %11000011
end

  player9height=1
 player9:
  %00010000
end

 player2height=1
 player2:
  %10000000
end

 player3height=1
 player3:
  %00000001
end

 player4height=1
 player4:
  %00000100
end

 player5height=1
 player5:
  %00001000
end

 player6height=1
 player6:
  %01000000
end

 player8height=1
 player8:
  %00010000
end

 player2-6color:
 $0E
end

 player7-8color:
 $0E
end
 
 goto gameover3
 
gameover4

 a=16   : rem PLAYER6X - Top Bomb Dropping Enemy
 b=16   : rem PLAYER2X
 c=16   : rem PLAYER3X
 d=16   : rem PLAYER4X
 e=16   : rem PLAYER5X
 f=16   : rem PLAYER7X
          rem g is a bit variable for various tasks noted below
 h=0    : rem timer1 
 i=71   : rem PLAYER0X
 j=0    : rem joy0up debounce
 k=0    : rem joy0down debounce
 l=0    : rem Death Animation Counter
 m=0    : rem overall frame counter
 n=25   : rem ball x location for visual timer
 o=16   : rem PLAYER8X
 p=0    : rem bit variable for tracking enemy sprite movement
          rem bit var
 s=132  : rem PLAYER0Y
 t=3    : rem lives
 u=16   : rem PLAYER9X
          rem bit variable - missile1 movement based on level
 w=0    : rem M1y
 x=1    : rem M1x
 y=0    : rem astronauts rescued
 z=1    : rem spaceman animation counter
 var5=0 : rem musiccounter
 var6=0 : rem audio1
 var7=0 : rem fire_debounce
 missile0x=136
 
 rem g bit variable to control l/r movement of sprites
 p{0}=1: p{1}=1: p{2}=1: p{3}=1: p{4}=1: p{5}=1: p{6}=1: p{7}=1

 rem q bit variable is to keep track of enemy death
 q{0}=0: q{1}=1: q{2}=1: q{3}=1: q{4}=1: q{5}=1: q{6}=1: q{7}=1

 rem g bit variable for various functions
 g{0}=1 : rem flag for extra time power up
 g{1}=1 : rem joystick last move was left=1 right=0
 g{2}=0 : rem PLAYER0 Flag for being able to move left or right
 g{3}=1 : rem PLAYER0 Flag for being able to move up or down
 g{4}=0 : rem ship death flag (1=dead, 0=alive)
 g{5}=0 : rem rescue spaceman flag (1=rescued, 0=not rescued)
 g{6}=1 : rem fire_debounce
 g{7}=0 : rem Flag for autofire 1=on 0=off, reset to off on restart

 if g{7} then player9x=76:player9y=160
 if !g{7} then player9x=136:player9y=171:player3x=135:player3y=171
 
 drawscreen
 
  goto title bank3