include mymacros.inc
include Macros.inc
include Yasmeen.inc
.model small
.stack 128

.data
;osama's input
;00: Empty Unhit Square
;01: Unhit Ship Square
;02: Hit Empty Square
;03: Hit Ship Square
DestroyedArr1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h, 00h
DestroyedArr2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h, 00h
P1Score db 5
P2Score db 5
FairWarning db 'Take a good look at the grid, then      choose your ship positions$'
PlayerTurnMsg1 DB "Player 1 turn$"
PlayerTurnMsg2 DB "Player 2 turn$"

GameEnd DB 0

FRX DW 67       ; the start of the left grid +10, currently 70
FRY DW 125;was 40 (or 127)
FRH DW 9
FRW DW 9
FRC DB 4

ExplosionX DW 50
ExplosionY DW 45
ExplosionHeight DW 2
ExplosionWidth DW 1

MarkX1 DW ?
MarkX2 DW ?
MarkY1 DW ?
MarkY2 DW ?
MarkColor DB 7
MarkColor2 DB 7


CannonHeight DW 35
TargetY DW 0051
CannonCenter DW 50 ;center of square +1


GridSizeOS DW 4
P1GridStartX DW 47
P1GridStartY DW 43
P2GridStartX DW 207
P2GridStartY DW 43
GridSideLength DW 16

Grid1LabelStartX DB 6
Grid1LabelStartY DB 6
Grid2LabelStartX DB 26
Grid2LabelStartY DB 6
Grid1LabelColor DB 110
Grid2LabelColor DB 5



NiceShot DB "Nice shot, you damaged a ship$"
BadShot DB "Oops, you missed the enemy grid$"
MehShot DB "You have already shot that square$"
AttackActive DB "Player ", ?," has activated his attack card$"
DefendActive DB "Player ", ?," has activated his defense card$"
Turn DB "'s turn$"
Win DB " won$"
left    equ     4bh
right   equ     4dh
up      equ     48h
down    equ     50h

R1Topleftx dw 57  ; should be the start of the left grid 	
R1Toplefty dw 137	;was 50
R1Ylength  dw 25
R1Xwidth   dw 30

R2Topleftx dw 65  ; the start of the left grid +8 
R2Toplefty dw 137	;was 50
R2Ylength  dw 15
R2Xwidth   dw 15



P1 LABEL BYTE
P1BufferSize db 30
P1Size db 7
P1Name db 'Player1 won$'

P2 LABEL BYTE
P2BufferSize db 30
P2Size db 7
P2Name db 'Player2 won$'

;Score db 'Remaining Ships:$'
Score db 'Squares:$'

model db 0

Nums db 'a010203040506070809101112131415161718192021222324252627282930313233343536$'
mes db 5, ?, 5 DUP ('$')
;end 

;Yasmeen's Input
GameName db 'BATTLESHIP$' 
FIR_PLAYER_NAME db 'First player: please enter your name', 10, 13, '$'
SEC_PLAYER_NAME db 10, 13, 'Second player: please enter your name',10,13,'$' 
PLAY 			DB 'Play$'
CHAT 			DB 'Chat$'
        
FIR_NAME LABEL BYTE
FIR_NAME_SIZE db 15
FIR_NAME_ACTUAL_SIZE db ?     
FIR_NAME_Data db 16 dup('$')

SEC_NAME LABEL BYTE
SEC_NAME_SIZE db 15
SEC_NAME_ACTUAL_SIZE db ?     
SEC_NAME_Data db 16 dup('$')
;end

;wagih's input
P13Ship db 00h, 99h,99h
P12Ship db 00h, 99h
P23Ship db 00h, 99h,99h
P22Ship db 00h, 99h
PowerUpAttackP1 db 00h
PowerUpAttackP2 db 00h
PowerUpDefenseP1 db 00h
PowerUpDefenseP2 db 00h
UseAttackOne db 00h
UseAttackTwo db 00h
UseDefenseOne db 00h
UseDefenseTwo db 00h
CheckDownTwo db 00h
CheckDownThree db 00h
CheckUpThree db 00h
tempVar2 db 00h 
tempVar db 00h   
PlayerOneMsg db "It's player one's input",10,13,'$'
PlayerTwoMsg db "It's player two's input",10,13,'$'
RightMsg db ' Please enter a number from 0 to 15 and then press enter$'
ShipOne db ' for ship 1',10,13,'$'
DifferentShip db 'Place your second ship away from your first',10,13,'$'
ShipTwo db ' for ship 2',10,13,'$' 
LeftMsg db 'Please enter a suitable direction, WASD for gamers!',10,13,'$'          
ShipLeft db 'Please enter a suitable direction away from your first ship, WASD for gamers!',10,13,'$'
GridSize db 4
;end

P1FRX DW 47       ; the start of the left grid +10
P1FRY DW 125
P1FRH DW 10
P1FRW DW 11 		; i added a pixel so it could be equal to the small box 
P1FRC DB 9


left    equ     4bh
right   equ     4dh
up      equ     48h
down    equ     50h

EscapeKey equ 01h

W 		equ     11h 
A		equ		1Eh
S  		equ		1Fh
D 		equ  	20h

P1R1Topleftx dw 37  ; should be the start of the left grid 	
P1R1Toplefty dw 135
P1R1Ylength  dw 25
P1R1Xwidth   dw 30

P1R2Topleftx dw 45  ; the start of the left grid +8 
P1R2Toplefty dw 135
P1R2Ylength  dw 15
P1R2Xwidth   dw 15

BTopleftx dw 150  
BToplefty dw 55
BYlength  dw 50
BXwidth   dw 20


P2R1Topleftx dw 197  ; should be the start of the left grid 	
P2R1Toplefty dw 135
P2R1Ylength  dw 25
P2R1Xwidth   dw 30

P2R2Topleftx dw 205
P2R2Toplefty dw 135
P2R2Ylength  dw 15
P2R2Xwidth   dw 15

P2FRX DW 207     ; the start of the left grid +10
P2FRY DW 125
P2FRH DW 10
P2FRW DW 10
P2FRC DB 9


BFStartx   dw 151; plus the x of the powerbar  by 1 
BFEndX dw 169 ; minus the x of the end of the power bar by 1 
BFYpos  dw 104
PlayerTurn db 0 ; 0 first player , 1 second player  ; should change after every hit is done 


BigTime dw 10
LittleTime dw 3000




.code
Main proc 
mov ax,@data
mov ds,ax

;SwitchToGraphicsMode
CLEAR_SCREEN_DOWN
		
	SwitchToGraphicsMode
		

	CALL DrawWelcomeScreen
	CALL SelectMode
	CLEAR_SCREEN_UP
	
	SwitchToGraphicsMode
	Call DrawWelcomeGrid 
	
	MoveCursorToLocation 0, 0
	CALL ReadShips	   
	;MoveCursorToLocation 0, 20

SwitchToGraphicsMode
CALL DrawUI
Call CalculateScore
CALL ClearStatusBar
CALL ResetCursorToStatusBar

;DrawRec R1Topleftx, R1Toplefty, R1Ylength, R1Xwidth
;DrawRec R2Topleftx, R2Toplefty, R2Ylength, R2Xwidth
;DrawHorizontalLineWithColor
;DrawFilledRec FRX, FRY, FRH, FRW, P1FRC
;DrawHorizontalLineWithColor 69, 310, 50, 0

		CALL ClearStatusBar
		CALL ResetCursorToStatusBar
		MOV BL, PlayerTurn
		MOV BH, 0
		CMP BL, 0
		JZ Turn11
		
		ShowMessage SEC_NAME_Data
		Mov AL, SEC_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 21
		JMP MoveOn1
		
Turn11: Mov AL, FIR_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 21 
MoveOn1:	






GameLogic:
	
		mov ah,1
		int 16h
		JZ GameLogic
		
		
		CALL ClearStatusBar
		CALL ResetCursorToStatusBar
		MOV BH, 0
		MOV BL, PlayerTurn
		CMP BL, 0
		JZ Turn1
	    ShowMessage SEC_NAME_Data
		Mov AL, SEC_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 21
		ShowMessage Turn
		JMP MoveOn
		
Turn1: ShowMessage FIR_NAME_Data
		Mov AL, FIR_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 21
		ShowMessage Turn
MoveOn:		
		
		
		
		
		mov bl,PLayerTurn ; i used bx as i am not sure what will happen in the buffer
		cmp bl,1  ; should be 0 not one as player1 is the first one but 1 makes more sense as the cannon of player one is under player's two grid 
		JZ Player1
		JMP Player2
		
Player1:
		Call HideCannon2Proc
		Call DrawCannon1Proc
		mov ah,0
		int 16h 
		cmp ah, EscapeKey
		JZ ExitStepNoWin
		cmp ah,34h  ; . key to attack twice
		Jz Attack1 
		cmp ah,2dh ; X Key to Defend from an opponent
		Jz Defense2	
		cmp ah,Left ; Leftkey 
		JZ  MoveLeft1Step
		cmp ah,Right ; rightkey 
		JZ  MovRight1
		cmp ah,39h  ; space
		JZ ShowPower1Step
		JMP GameLogic
Player2:
		Call HideCannon1Proc		
		Call DrawCannon2Proc				
		mov ah,0
		int 16h
		cmp ah, EscapeKey
		JZ ExitStepNoWin
		cmp ah,2ch ;  Z Key to Attack Twice
		Jz Attack2
		cmp ah,35h  ; / Key to Defend from an opponent 
		Jz Defense1
		cmp ah,A ; letter A
		JZ  MoveLeft2Step
		cmp ah,D ; rightkey 
		JZ  MovRight2
		cmp ah,39h  ; space
		JZ ShowPower1Step
		JMP GameLogic
		
Attack1:
		mov al,UseAttackOne
		Xor al,00000001b
		mov UseAttackOne,al
		jmp GameLogic ; not sure if it should become game logic or after attack ; afks 
Defense1:
		mov al,UseDefenseOne
		Xor al,00000001b
		mov UseDefenseOne,al
		jmp GameLogic
Attack2: 
		mov al,UseAttackTwo
		Xor al,00000001b
		mov UseAttackTwo,al
		jmp GameLogic
Defense2:
		mov al,UseDefenseTwo
		Xor al,00000001b
		mov UseDefenseTwo,al
		
		jmp GameLogic
ExitStepNoWin: JMP NoWin
ExitStep: JMP Exit
MoveLeft2Step:   jmp MovLeft2		
MoveLeft1Step:   jmp Movleft1
GameLogicStep:   jmp GameLogic
SHowPower1Step:  jmp ShowPower1		
		 
MovRight1:
		mov ax,P1FRX
		add ax,P1FRW
		cmp ax,101  ; the end of grid 1 
		JA GameLogicStep
		mov cx,16  ; the width of the grid 
MoveR1:	
		call MoveR1Proc
		dec cx
		cmp cx,0
		JNZ MoveR1
		JMP GameLogicStep
MovRight2:
		mov ax,P2FRX
		add ax,P2FRW
		cmp ax,261
		JA GameLogicStep
		mov cx,16
MoveR2:
		Call MoveR2Proc
		dec cx
		cmp cx,0
		JNZ MoveR2
		JMP GameLogicStep		
MovLeft1: 
		mov ax,P1FRX
		cmp ax,47  ; i think it should be the left of the grid minus 16 not sure wether to make it like that or not ; afkslha for now 
		JBE  GameLogicStep	
		mov cx,16	 ; the width of the grid
MoveL1:
		call MoveL1Proc
		dec cx
		cmp cx,0
		JNZ MoveL1
		JMP GameLogicStep
MovLeft2:
		mov ax,P2FRX
		cmp ax,207 
		JBE GameLogicStep
		mov cx,16	
MoveL2:
		call MoveL2Proc
		dec cx
		cmp cx,0
		JNZ MoveL2
		JMP GameLogicStep
		
		
ShowPower1:
		mov BFYpos,104 ; reset the starting place for the next time we hit a ship
		call DrawPowerBar
		JMP ChoosePower1
Step:	jmp ShowPower1
ChoosePower1:
		mov ah,1
		int 16h
		JNZ TakeValue  ; take the ypos in cx and send it to the game logic so what ever the calculation u want to perform
		call FillBarProc
		mov ax,BFYpos
		cmp ax,56
		JNZ ChoosePower1
		
UnFill:
		mov ah,1
		int 16h
		JNZ TakeValue
		call UnFillBarProc
		mov ax,BFYpos
		cmp ax,104
		JNZ UnFill
		JMP ChoosePower1
				
TakeValue:
			call RemoveBarProc
			
			mov ah,0
			int 16h
			push ax 
			
			mov al,UseDefenseOne
			cmp al,1
			jz DefenseOne
			
			mov al,UseDefenseTwo
			cmp al,1
			jz DefenseTwo
			
			pop ax

		;	cmp ah,2dh
		;	JZ DefendFromOpponent2 ; i will use my shiled to defend from player 2 The 2 beside Opponent Refers to The Player 1	as the naming convetion is mixed up 
		;	cmp ah,35h
		;	JZ DefendFromOpponent1 ; i will use my shiled to defend from Player 1 The 1 beside Opponent Refers to The Player 2 as the naming convetion is mixed up 
			cmp ah,39h  ; space
			JNZ Step
			mov ax,BFYpos ; to put the y pos at a value so i can calculate where to hit in the grid 
			mov ExplosionY,ax
			mov al,PlayerTurn
			cmp al,0
			jz Stepcannon
			jmp Player2Cannon
AftCannon:	cmp GridSizeOS,4
			jz StepMappingGrid4x4
			jmp MappingGrid5x5
	
			
			
			
			
			
			
AftMapping:	CALL CalculateExplosion
			CALL ShootTorpedo
			CALL CalculateScore
			
			
NoShoot:	mov al,UseAttackOne 
			cmp al,1
			jz AttackOne
			
			mov al,UseAttackTwo
			cmp al,1
			jz AttackTwo
			
		;	mov al,UseDefenseOne
		;	cmp al,1
		;	jz DefenseOne
		
		;	mov al,UseDefenseTwo
		;	cmp al,1
		;	jz DefenseTwo
		CALL CheckWin
		MOV BL, GameEnd
		CMP BL, 1
		JZ ExitStep2
			
ShiledActivate:			mov al,PlayerTurn
						Xor al,00000001b
						mov PlayerTurn,al
			
Continue:	JMP GameLogicStep  ; Continue is a label for the cards only 
StepMappingGrid4x4: jmp MappingGrid4x4		
AttackOne:	call UseSwordTwo ; here we use two as osos named them from the convention of the left game and right game and i play it from the first turn
			add al,3  ; any number besides 1 or 0 
			mov UseAttackOne,al
			Jmp Continue;
			
AttackTwo:	
			call UseSwordOne	; here we use two as osos named them from the convention of the left game and right game and i play it from the first turn
			add al,3  ; any number besides 1 or 0 so u dont use the power more than once
			mov UseAttackTwo,al
			Jmp Continue;
			
DefenseOne:	
			pop ax
			call UseShiledTwo ; here we use two as osos named them from the convention of the left game and right game and i play it from the first turn
DefenseOneAfterPop:   ; this labbel that i push ax before and i have to pop in every time except when he is using the defense card before the other one using powerbar
			mov al,UseAttackTwo
			cmp al,1
			Jz DisableAttackTwo
DisAttackTwo:mov al,UseDefenseOne
			add al,3  ; any number besides 1 or 0 
			mov UseDefenseOne,al
			Jmp ShiledActivate;
DefenseTwo:
			
			pop ax
			Call UseShiledOne  ; here we use two as osos named them from the convention of the left game and right game and i play it from the first turn
DefenseTwoAfterPOP:			;; this labbel that i push ax before and i have to pop in every time except when he is using the defense card before the other one using powerbar
			mov al,UseAttackOne
			cmp al,1
			JZ DisableAttackOne
DisAttackOne:mov al,UseDefenseTwo
			add al,3  ; any number besides 1 or 0 
			mov UseDefenseTwo,al
			Jmp ShiledActivate;
Stepcannon: jmp Player1Cannon
ExitStep2: JMP ExitStep3
DisableAttackOne:
				Call UseSwordTwo
				mov al,UseAttackOne
				add al,3
				mov UseAttackOne,al
				JMP DisAttackOne
				
	
			
DisableAttackTwo:
				Call UseSwordOne
				mov al,UseAttackTwo
				add al,3
				mov UseAttackTwo,al
				JMP DisAttackTwo
				
		
MappingGrid4x4:
		 mov ax,ExplosionY 
		 cmp ax,100
		 ja NoHit
		 cmp ax,90
		 ja G4Row4
		 cmp ax,80
		 ja G4Row3
		 cmp ax,70
		 ja G4Row2
		 cmp ax,60
		 ja G4Row1
		 jmp NoHit
MappingGrid5x5:
		 mov ax,ExplosionY 
		 cmp ax,100
		 ja NoHit
		 cmp ax,92
		 ja G5Row5
		 cmp ax,84
		 ja G5Row4
		 cmp ax,76
		 ja G5Row3
		 cmp ax,68
		 ja G5Row2
		 cmp ax,60
		 ja G5Row1
		 jmp NoHit
ExitStep3: JMP Exit		 
	 
NoHit: 
		jmp NoShoot ; shiled activate doesnt hit and change the turn so it make sense to jump on it without changing the name 
G4Row4:
		mov ax,91
		mov ExplosionY,ax
		jmp AftMapping
G4Row3:
		mov ax,75
		mov ExplosionY,ax
		jmp AftMapping
		
G4Row2:
		mov ax,59
		mov ExplosionY,ax
		jmp AftMapping
		
G4Row1:
		mov ax,43
		mov ExplosionY,ax
		jmp AftMapping
		
G5Row5:
		mov ax,107
		mov ExplosionY,ax
		jmp AftMapping
G5Row4:
		mov ax,91
		mov ExplosionY,ax
		jmp AftMapping
G5Row3:
		mov ax,75
		mov ExplosionY,ax
		jmp AftMapping
G5Row2:
		mov ax,59
		mov ExplosionY,ax
		jmp AftMapping
G5row1:
		mov ax,43
		mov ExplosionY,ax
		jmp AftMapping
Player1Cannon:
			mov ax,P2FRX
			mov ExplosionX,ax	
			jmp AftCannon
Player2Cannon:
			mov ax,P1FRX
			mov ExplosionX,ax
			jmp AftCannon
;DefendFromOpponent1:
;		mov al,UseDefenseOne
;		Xor al,00000001b
;		mov UseDefenseOne,al
;		jmp DefenseOneAfterPOP	
			

;DefendFromOpponent2:
;		mov al,UseDefenseTwo
;		Xor al,00000001b
;		mov UseDefenseTwo,al
;		jmp DefenseTwoAfterPOP

Exit: 
	  SwitchToTextMode
	  ScrollUpScreen
	  SwitchToGraphicsMode
	  Call DrawFrame
	  MOV BL, PlayerTurn
	  CMP BL, 0
	  JZ OneWon
	  MoveCursorToLocation 14, 7
	   ShowMessage sec_NAME_Data
	  Mov AL, SEC_NAME_ACTUAL_SIZE
		INC AL
		ADD AL, 14
		MoveCursorToLocation AL, 7
		ShowMessage Win
	  ;ShowMessage SEC_NAME_Data
	 ; MoveCursorToLocation 20, 7
	  ;ShowMessage Win
	  JMP Freeze
OneWon:	MoveCursorToLocation 14, 7
		ShowMessage FIR_NAME_Data
		Mov AL, FIR_NAME_ACTUAL_SIZE
		INC AL
		ADD AL, 14
		MoveCursorToLocation AL, 7
		ShowMessage Win
		;ShowMessage fir_NAME_Data
		;MoveCursorToLocation 20, 7
		;ShowMessage Win  
		Freeze:
NoWin:MoveCursorToLocation 0, 23	
ReadString P1
Mov Ah,4ch
int 21h
; HLT
Main endp
;.......................................................................................................................................................
MoveR1Proc      Proc
		push cx
		DrawFilledRec P1R1Topleftx, P1FRY, CannonHeight, P1R1Xwidth, 0
		mov ax,P1R1Topleftx 
		inc ax
		mov P1R1Topleftx,ax
		mov ax,P1R2Topleftx
		inc ax
		mov P1R2Topleftx,ax
		mov ax,P1FRX
		inc ax
		mov P1FRX,ax
		
	
		
		DrawRec P1R1Topleftx, P1R1Toplefty, P1R1Ylength, P1R1Xwidth
		DrawRec P1R2Topleftx, P1R2Toplefty, P1R2Ylength, P1R2Xwidth
		DrawFilledRec P1FRX, P1FRY, P1FRH, P1FRW, 9
		
		mov ax,1000
		mov BigTime,ax
		mov ax,10
		mov LittleTime,ax
		
		CALL DelayProc
		;;Delay BigTime,LittleTime
		pop cx    
		ret
MoveR1Proc      endp
;.......................................................................................................................................................

MoveL1Proc    proc
		push cx
		DrawFilledRec P1R1Topleftx, P1FRY, CannonHeight, P1R1Xwidth, 0
		mov ax,P1R1Topleftx 
		dec ax
		mov P1R1Topleftx,ax
		mov ax,P1R2Topleftx
		dec ax
		mov P1R2Topleftx,ax
		mov ax,P1FRX
		dec ax
		mov P1FRX,ax
		DrawRec P1R1Topleftx, P1R1Toplefty, P1R1Ylength, P1R1Xwidth
		DrawRec P1R2Topleftx, P1R2Toplefty, P1R2Ylength, P1R2Xwidth
		DrawFilledRec P1FRX, P1FRY, P1FRH, P1FRW, 9
		
		
			mov ax,1000
		mov BigTime,ax
		mov ax,10
		mov LittleTime,ax
		
		CALL DelayProc
		;;Delay BigTime,LittleTime
		pop cx
		ret
MoveL1Proc    endp
;.......................................................................................................................................................

FillBarProc   Proc
		DrawHorizontalLineWithColor BFStartx,BFEndX,BFYpos,15
		mov ax,BFYpos
		dec ax
		mov BFYpos,ax
		mov ax,1000
		mov BigTime,ax
		mov ax,LittleTime
		mov ax,10
		mov LittleTime,ax
		CALL DelayProc
		;Delay BigTime,LittleTime
		ret
FillBarProc   endp
;.......................................................................................................................................................

UnFillBarProc	Proc
		DrawHorizontalLineWithColor BFStartx,BFEndX,BFYpos,0
		mov ax,BFYpos
		inc ax
		mov BFYpos,ax
		mov ax,BigTime
		mov ax,1000
		mov BigTime,ax
		mov ax,LittleTime
		mov ax,10
		mov LittleTime,ax
		CALL DelayProc
		;Delay BigTime,LittleTime
		ret
UnFillBarProc   endp

;.......................................................................................................................................................
RemoveBarProc   Proc
		DrawFilledRec BTopleftx, BToplefty, BYlength, Bxwidth, 0
		ret 
RemoveBarProc   endp
;.......................................................................................................................................................
DrawCannon1Proc    Proc

		DrawRec P1R1Topleftx, P1R1Toplefty, P1R1Ylength, P1R1Xwidth
		DrawRec P1R2Topleftx, P1R2Toplefty, P1R2Ylength, P1R2Xwidth
		DrawFilledRec P1FRX, P1FRY, P1FRH, P1FRW, 9
		ret
DrawCannon1Proc   endp
;.......................................................................................................................................................
DrawCannon2Proc	  proc
	
		DrawRec P2R1Topleftx, P2R1Toplefty, P2R1Ylength, P2R1Xwidth
		DrawRec P2R2Topleftx, P2R2Toplefty, P2R2Ylength, P2R2Xwidth
		DrawFilledRec P2FRX, P2FRY, P2FRH, P2FRW, 9
		ret
DrawCannon2Proc  endp
;.......................................................................................................................................................
DrawPowerBar    proc
		DrawRec BTopleftx,BToplefty,BYlength,Bxwidth
		ret
DrawPowerBar  endp
;.......................................................................................................................................................
MoveR2Proc      Proc
		push cx
		DrawFilledRec P2R1Topleftx, P2FRY, CannonHeight, P2R1Xwidth, 0
		mov ax,P2R1Topleftx 
		inc ax
		mov P2R1Topleftx,ax
		mov ax,P2R2Topleftx
		inc ax
		mov P2R2Topleftx,ax
		mov ax,P2FRX
		inc ax
		mov P2FRX,ax
		
	
		
		DrawRec P2R1Topleftx, P2R1Toplefty, P2R1Ylength, P2R1Xwidth
		DrawRec P2R2Topleftx, P2R2Toplefty, P2R2Ylength, P2R2Xwidth
		DrawFilledRec P2FRX, P2FRY, P2FRH, P2FRW, 9
		
		
		PUSH AX
		PUSH BX
		MOV AX, 10
		MOV BX, 1000
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		;;Delay BigTime,LittleTime
		pop cx    
		ret
MoveR2Proc      endp
;.......................................................................................................................................................
MoveL2Proc    proc
		push cx
		DrawFilledRec P2R1Topleftx, P2FRY, CannonHeight, P2R1Xwidth, 0
		mov ax,P2R1Topleftx 
		dec ax
		mov P2R1Topleftx,ax
		mov ax,P2R2Topleftx
		dec ax
		mov P2R2Topleftx,ax
		mov ax,P2FRX
		dec ax
		mov P2FRX,ax
		DrawRec P2R1Topleftx, P2R1Toplefty, P2R1Ylength, P2R1Xwidth
		DrawRec P2R2Topleftx, P2R2Toplefty, P2R2Ylength, P2R2Xwidth
		DrawFilledRec P2FRX, P2FRY, P2FRH, P2FRW, 9
		
		
		
		PUSH AX
		PUSH BX
		MOV AX, 10
		MOV BX, 1000
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		;;Delay BigTime,LittleTime
		pop cx
		ret
MoveL2Proc    endp
;.......................................................................................................................................................
HideCannon1Proc  proc
		DrawFilledRec P1R1Topleftx, P1FRY, CannonHeight, P1R1Xwidth, 0
		ret
HideCannon1Proc  endp

;.......................................................................................................................................................
HideCannon2Proc  proc
		DrawFilledRec P2R1Topleftx, P2FRY, CannonHeight, P2R1Xwidth, 0
		ret
HideCannon2Proc  endp
;......................................................................................................................................................	
DrawSwordP1    proc		
		DrawRec 17, 64, 10, 4
		DrawRec 10, 61, 2 ,18
		DrawRec 15, 33, 28, 8
		DrawRec 5, 23, 55, 28
		RET
DrawSwordP1    endp
;......................................................................................................................................................
DrawShieldP1 proc
		DrawRec 5, 85, 55, 28			;was 48, 12
		
		Draw45Line 9, 110, 19, 120, 15
		Draw45Line 9, 109, 19, 119, 15

		Draw45Line 19, 120, 29, 110, 15
		Draw45Line 19, 119, 29, 109, 15
		
		DrawPixel 29, 108, 15
		DrawPixel 28, 108, 15
		DrawPixel 27, 109, 15

		DrawPixel 9, 108, 15
		DrawPixel 10, 108, 15
		DrawPixel 11, 109, 15
		DrawHorizontalLineWithColor 11, 27, 109, 15
		RET
DrawShieldP1 endp
;......................................................................................................................................................
DrawSwordP2    proc
		DrawRec 296, 64, 10, 4
		DrawRec 289, 61, 2 ,18
		DrawRec 294, 33, 28, 8
		DrawRec 284, 23, 55, 28
		DrawHorizontalLineWithColor 296, 300, 64, 9
		RET
DrawSwordP2    endp
;......................................................................................................................................................
DrawShieldP2 proc
		DrawRec 284, 85, 55, 28			;was 48, 12
		
		Draw45Line 288, 110, 298, 120, 15
		Draw45Line 288, 109, 298, 119, 15

		Draw45Line 298, 120, 308, 110, 15
		Draw45Line 298, 119, 308, 109, 15
		
		DrawPixel 308, 108, 15
		DrawPixel 307, 108, 15
		DrawPixel 306, 109, 15

		DrawPixel 288, 108, 15
		DrawPixel 289, 108, 15
		DrawPixel 290, 109, 15
		DrawHorizontalLineWithColor 290, 306, 109, 15
		RET
DrawShieldP2 endp
;......................................................................................................................................................
DrawStatusBarProc  proc
		MOV DX, 165
		MOV CX, 0
AgainAgain:	MOV AL, 15
		MOV AH, 0CH
		INT 10H
		INC CX
		CMP CX, 320
		JZ Done
		MOV AX, CX
		MOV BL, 7
		DIV BL
		CMP AH, 0
		JNZ AgainAgain
		ADD CX, 2
		JMP AgainAgain
Done:	RET
DrawStatusBarProc endp
;......................................................................................................................................................
DrawPlayers proc
		MoveCursorToLocation 7,0
		ShowMessage FIR_NAME_Data
		MOV SI, offset P1
		INC SI
		MOV CL, 36
		SUB CL, DS:[SI]
		SUB CL, 3
		MoveCursorToLocation CL, 0
		SUB CL, 1
		ShowMessage SEC_NAME_Data
		MoveCursorToLocation CL, 1
		ShowMessage Score
		DisplayDigit P2Score
		CALL DrawScores
		RET
DrawPlayers endp

DrawScores proc
		MoveCursorToLocation 6,1
		ShowMessage Score
		DisplayDigit P1Score
		MOV SI, offset P1
		INC SI
		MOV CL, 36
		SUB CL, DS:[SI]
		SUB CL, 4
		MoveCursorToLocation CL, 1
		ShowMessage Score
		DisplayDigit P2Score
		RET
DrawScores endp
;......................................................................................................................................................
DrawUI proc
		Call DrawStatusBarProc
		Call DrawPlayers

		DrawGrid P1GridStartX, P1GridStartY, GridSizeOS, GridSideLength	;X = 38, Y = 27 for 6x6, X = 46, Y = 35 for 5x5
		DrawGrid P2GridStartX, P2GridStartY, GridSizeOS, GridSideLength ;X = 182, Y = 27 for 6x6, X = 190, Y = 35 for 5x5
		Call DrawSwordP1
		Call DrawShieldP1
		Call DrawSwordP2
		Call DrawShieldP2
		RET
DrawUI endp
;......................................................................................................................................................
ClearStatusBar proc		;Clears the bar by drawing over it in black
		DrawFilledRec 0, 166, 35, 320, 0
		RET
ClearStatusBar endp
;......................................................................................................................................................
ResetCursorToStatusBar proc
		MoveCursorToLocation 0, 21
		RET
ResetCursorToStatusBar endp
;......................................................................................................................................................
UseSwordOne proc

	DrawFilledRec 6, 24, 53, 25,0   ;5, 23, 55, 28
	ret
UseSwordOne endP
;......................................................................................................................................................
UseSwordTwo Proc
	DrawFilledRec 285, 24, 53, 25,0
	ret
UseSwordTwo endp
;......................................................................................................................................................
UseShiledOne Proc
	DrawFilledRec 6, 86, 52, 25	,0
	ret
UseShiledOne endp
;......................................................................................................................................................
UseShiledTwo Proc
	DrawFilledRec	285, 86, 52, 25,0
	ret
UseShiledTwo endp
;......................................................................................................................................................
DrawWelcomeScreen proc
		CALL DrawFrame
		MoveCursorToLocation 14, 7
		ShowMessage GameName
		MoveCursorToLocation 15, 11
		DisplayChar 16
		DisplayChar 32
		ShowMessage PLAY
		MoveCursorToLocation 15, 13
		DisplayChar 32
		DisplayChar 32
		ShowMessage CHAT
		MoveCursorToLocation 15, 11
		RET
DrawWelcomeScreen endp
;......................................................................................................................................................
ReadUsernames proc
		SwitchToTextMode
		MOVECURSOR 0, 0
		SHOWMESSAGE FIR_PLAYER_NAME
        READMESSAGE FIR_NAME
		SHOWMESSAGE SEC_PLAYER_NAME
        READMESSAGE SEC_NAME
		RET
ReadUsernames endp
;......................................................................................................................................................
DrawFrame proc
		DrawDashedHorizontalLine 94, 208, 43
		DrawDashedHorizontalLine 94, 208, 76

		DrawDashedVerticalLine 43, 76, 208
		DrawDashedVerticalLine 43, 76, 94
		RET
DrawFrame endp
;......................................................................................................................................................
SelectMode proc
Check2:	MOV AH, 1
		INT 16H
		JZ Check2
		MOV AH, 0
		INT 16H
		CMP AL, 13 ;Enter key
		JZ CheckMode
		CMP AH, down
		JZ MoveDown
		CMP AH, up
		JZ MoveUp
		JMP Check2
		
MoveDown:
		 GetCursorInDLDH
		 CMP DH, 13		;This is the farthest down it can be, so we won't do anything
		 JAE Check2
		 MoveCursorToLocation 15, DH
		 PUSH DX
		 DisplayChar 0	;Write NULL to remove the old arrow
		 POP DX
		 ADD DH, 2		;Move the Y position 2 by 2 downwards
		 MoveCursorToLocation DL, DH
		 DisplayChar 16		;Display Arrow
		 JMP Check2
		 
MoveUp:
		 GetCursorInDLDH
		 CMP DH, 11		;This is the farthest up it can be, rest of the logic is same as MoveDown
		 JBE Check2
		 MoveCursorToLocation 15, DH
		 PUSH DX
		 DisplayChar 0
		 POP DX
		 SUB DH, 2
		 MoveCursorToLocation DL, DH
		 DisplayChar 16
		 JMP Check2
CheckMode: GetCursorInDLDH Macro
		 CMP DH, 11
		 JZ PlayMode
		 CMP DH, 13
		 JZ ChatMode
		 JMP Check2
ChatMode:JMP Check2
		 
PlayMode:CLEAR_SCREEN_UP
		CALL ReadUsernames
		RET
SelectMode endp
;......................................................................................................................................................
ReadShips proc 
										SwitchToTextMode
			    mov ah,09h
                    mov dx, offset PlayerOneMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset RightMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset ShipOne
                    int 21h
                    TakeInput 4
                    add P13Ship[0],al
                    TakeDirections  P13Ship 4
                    mov ah,09h
                    mov dx, offset RightMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset ShipTwo
                    int 21h 
StartP12:
                    TakeInput 4  
                    cmp al,P13Ship[0] 
                    je Skip
                    cmp al,P13Ship[1] 
                    je Skip	
                    cmp al,P13Ship[2] 
                    je Skip
                    jmp correct		
Skip:               mov ah,09h
                    mov dx, offset DifferentShip
                    int 21h
                    jmp StartP12  
correct:        
                    add P12Ship[0],al  
                    TakeDirections2  P12Ship P13Ship 4
		            push bx 
	                push DI
		            mov bx,offset DestroyedArr1
                    mov DI, offset P13Ship  
                    dec bx
                    editShip
                    mov ah,09h
                    mov dx, offset PlayerTwoMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset RightMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset ShipOne
                    int 21h
                    TakeInput 5
                    add P23Ship[0],al
                    TakeDirections  P23Ship 4 
                    mov ah,09h
                    mov dx, offset RightMsg
                    int 21h
                    mov ah,09h
                    mov dx, offset ShipTwo
                    int 21h 
StartP22:
                    TakeInput 4
                    cmp al,P23Ship[0] 
                    je Skip2
                    cmp al,P23Ship[1] 
                    je Skip2	
                    cmp al,P23Ship[2] 
                    je Skip2
                    jmp correct2		
Skip2:              mov ah,09h
                    mov dx, offset DifferentShip
                    int 21h
                    jmp StartP22  
correct2:        
                    add P22Ship[0],al  
                    TakeDirections2  P22Ship P23Ship 4
		            push bx 
	                push DI
		            mov bx,offset DestroyedArr2
                    mov DI, offset P23Ship
                    dec bx
                    editShip
					RET
ReadShips endp
;......................................................................................................................................................
DrawWelcomeGrid proc
		MOV BX, offset model	;Model 1 for a spaced out grid filling up a big portion of the screen, it is changed to 0 later on
								;in order to fit both grids into the UI
		MOV CL, 1
		MOV [BX], CL
		MOV BX, offset GridSideLength	;Spaces out labels require a larger Side Length for the grid's squares
		MOV CX, 24
		MOV [BX], CX
		LabelSquares GridSizeOS, Nums, Grid1LabelColor, 13, 8, model
		DrawGrid 99, 56, GridSizeOS, GridSideLength
		
		MOV BX, offset model
		MOV CL, 0			;Resetting the model for the game UI
		MOV [BX], CL
		MOV BX, offset GridSideLength
		MOV CX, 16			;Resetting the side length
		MOV [BX], CX
		
		ShowMessage FairWarning
		MOV SI, 80
AGAIN:	;Delay so the user has enough time to see the grid

		PUSH AX
		PUSH BX
		MOV AX, 20
		MOV BX, 4000
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		
		
		DEC SI
		CMP SI, 0
		JNZ AGAIN
		MOV AX, 10
		MOV BX, 1000
		MOV BigTime, AX
		MOV LittleTime, BX
		RET
DrawWelcomeGrid endp
;......................................................................................................................................................
;This function draws the projectile fired from the cannon, draws the explosion effect, and marks the square with a grey or red X
;It uses the ExplosionX and ExplosionY variables as the destination the projectile travels to
ShootTorpedo proc
		MOV CX, ExplosionX
		MOV DX, FRY					;The Y of the filled rectangle at the top of the cannon, in order to draw the projectile starting from this point
		SUB DX, 3
		MOV AL, 41
		MOV AH, 0CH
		MOV BL, 0
Upwards:	
		INT 10H
		
		INC CX
		INC DX
		INT 10H
		INC CX
		INC DX
		INT 10H
		
		
		INC BL		;The first time this loop runs I need it to not draw black or grey to erase itself, cause it will erase the cannon
		CMP BL, 1
		JBE NOUNFILL
		
		MOV BH, 0		;In this loop I check if the top of the projectile crosses a grid line, then I change the eraser color to grey instead of black
		MOV SI, P1GridStartY	;We check by starting at the top Y of the grid, and incrementing the side lengths N times, where N is grid size, to check if the projectile
		DEC SI					;has the same Y
		SUB SI, GridSideLength
		
CHECK:	ADD SI, GridSideLength
		INC BH
		CMP DX, SI
		JZ GREY
		CMP BH, 5
		JNZ CHECK
		MOV AL, 0
		JMP BLACK
GREY:	MOV AL, 7		
BLACK:	PUSH DX
		PUSH CX
		PUSH AX
		;Manually drawn points that make up the projectile
		
		INC DX
		INT 10H
		DEC CX
		INT 10H
		DEC CX
		INT 10H
		DEC CX
		INT 10H
		DEC CX
		INT 10H
		
		POP AX
		POP CX 
		POP DX
NOUNFILL:
		MOV AL, 41
		DEC CX
		DEC CX
		DEC CX
		DEC CX
		INT 10H
		INC CX
		DEC DX
		INT 10H
		INC CX
		INT 10H
		SUB DX, 2
		
		

		
		;PUSH CX
		;PUSH DX
		;PUSH AX
		;Delay
		PUSH AX					;Delay so the player can view the projectile
		PUSH BX
		MOV AX, 10
		MOV BX, 1300
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		

		
		;POP AX
		;POP DX
		;POP CX
		
		CMP DX, TargetY	
		JA Upwards
		
		
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH SI
		PUSH DI
		PUSH BP
		CALL UpdateMarksProc		;After we've hit our target, we need to re-draw all the marks in case we erase
									;some of them on our way up
		POP BP
		POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		
		
		
		
		PUSH CX
		SUB CX, 3
		PUSH DX
		
		
		DrawFilledRec CX, Targety, 3, 4, 0			;Erase the projectile
		
		
		CALL DrawGridsProc
		POP DX 
		POP CX
		DEC CX
		MOV ExplosionX, CX
		MOV ExplosionY, DX
		;MOV BP, 0
		MOV CX, 0
		MOV AX, 2
		MOV ExplosionHeight, AX
		MOV AX, 1
		MOV ExplosionWidth, AX
Explode:		
		PUSH CX
		MOV CX, ExplosionX
		DEC CX
		MOV ExplosionX, CX
		MOV DX, ExplosionY
		DEC DX
		MOV ExplosionY, DX
		DrawFilledRec ExplosionX, ExplosionY, ExplosionHeight, ExplosionWidth, 41		
		;We create the effect of an explosion by gradually drawing orange rectangles, each time 
		;Increasing the width and height, while decreasing its X position

		;Delay
		PUSH AX
		PUSH BX
		MOV AX, 10
		MOV BX, 6000
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		
		
		
		MOV AX, ExplosionHeight
		INC AX
		INC AX
		MOV ExplosionHeight, AX
		MOV AX, ExplosionWidth
		INC AX
		INC AX
		MOV ExplosionWidth, AX
		
		
		POP CX
		INC CX
		CMP CX, 6
		JBE Explode
		
	
		
		;Delay
		PUSH AX
		PUSH BX
		MOV AX, 10
		MOV BX, 3000
		MOV BigTime, AX
		MOV LittleTime, BX
		CALL DelayProc
		POP BX
		POP AX
		

		
		MOV AX, ExplosionHeight
		SUB AX, 2
		MOV ExplosionHeight, AX
		MOV AX, ExplosionWidth
		SUB AX, 2
		MOV ExplosionWidth, AX
		MOV AL, 0
		DrawFilledRec ExplosionX, ExplosionY, ExplosionHeight, ExplosionWidth, 0		;Erase the explosion
		
		MOV AX, ExplosionX
		MOV DX, ExplosionY
		ADD AX, GridSideLength
		SUB AX, 2
		ADD DX, GridSideLength
		SUB DX, 2
		
		;Stuff added to color the mark properly
		
		
		
		PUSH AX
		PUSH DX
		Draw45Line ExplosionX, ExplosionY, AX, DX, MarkColor		;Draw the first line of the X going from top left to bot right
		
		POP DX
		POP AX
		Draw45Line ExplosionX, DX, AX, ExplosionY, MarkColor		;Draw the second line of the X going from bot left to top right
		RET 
ShootTorpedo endp
;......................................................................................................................................................
DrawGridsProc proc
		DrawGrid P1GridStartX, P1GridStartY, GridSizeOS, GridSideLength
		DrawGrid P2GridStartX, P2GridStartY, GridSizeOS, GridSideLength
		RET
DrawGridsProc endp
;......................................................................................................................................................
;This proc counts the number of 1's in each player's Array and updates the player's score variable accordingly
CalculateScore proc
		MOV AX, GridSizeOS
		MOV BX, GridSizeOS
		MUL BX
		MOV DX, AX		;no. of squares
		MOV DI, offset DestroyedArr1
		MOV SI, offset DestroyedArr2
		MOV BL, 1	;unhit ship square
		MOV BH, 2	;empty hit
		MOV AH, 3	;hit ship square
		MOV CL, 0	;P1square count
		MOV BP, 0	;loop count
		MOV AL, 0	;P2square count
Traverse:	
		CMP [DI], BL
		JNZ Nope
		INC CL
Nope:	CMP [SI], BL
		JNZ Nope2
		INC AL
Nope2:  
		INC SI
		INC DI
		INC BP
		CMP BP, DX
		JNZ Traverse
		MOV [P1Score], CL
		MOV [P2Score], AL
		CALL DrawScores
		RET
CalculateScore endp

CalculateExplosion proc
		MOV AL, PlayerTurn
		CMP AL, 0
		JZ P2G
		MOV CX, P1GridStartX
		JMP YCOORD
P2G:		MOV CX, P2GridStartX	
YCOORD: MOV DX, P1GridStartY
		MOV AX, ExplosionX
		SUB AX, CX
		MOV BX, GridSideLength
		;MOV BH, 0
		DIV BL
		MOV AH, 0
		MOV BX, AX
		
		
		PUSH BX
		
		
		MOV AX, GridSideLength
		MOV AH, 0
		MOV CL, 2
		DIV CL
		MOV CL, AL
		MOV AX, GridSideLength
		MOV AH, 0
		MUL BL
		MOV BL, PlayerTurn
		CMP BL, 0
		JZ G2
		ADD AX, P1GridStartX
		JMP CONT
G2:		ADD AX, P2GridStartX
CONT:	MOV CH, 0
		ADD AX, CX
		INC AX
		MOV ExplosionX, AX
	
		;Display3DigitNumInAX
		;DisplayChar ','
		
		
		
		
		MOV AX, ExplosionY
		SUB AX, DX
		MOV BX, GridSideLength
		;MOV BH, 0
		DIV BL
		MOV AH, 0
		MOV Bx, Ax
		
		
		PUSH BX
		
		
		MOV AX, GridSideLength
		MOV AH, 0
		MOV CL, 2
		DIV CL
		MOV CL, AL
		MOV AX, GridSideLength
		MOV AH, 0
		MUL BL
		MOV BL, PlayerTurn
		CMP BL, 0
		JZ G22
		ADD AX, P1GridStartY
		JMP CONT2
G22:	ADD AX, P2GridStartY
CONT2:	MOV CH, 0
		ADD AX, CX
		;INC AX
		MOV ExplosionY, AX
	
		;Display3DigitNumInAX
		
		
		POP BX
		;MOV BH, 0
		MOV AX, GridSizeOS
		;MOV AH, 0
		XCHG AX, BX
		MUL BL
		POP BX
		MOV BH, 0
		ADD AX, BX		;Now AX has the index of the square to be hit
		
		
		;MOV CurrSQ, AX
		
		
		MOV BL, PlayerTurn
		CMP BL, 0
		JZ DEST2
		MOV DI, offset DestroyedArr1
		JMP CONTINUEOS
DEST2:	MOV DI, offset DestroyedArr2
CONTINUEOS:ADD DI, AX
		MOV BL, [DI]
		CMP BL, 0
		JZ EmptySq
		CMP BL, 2
		JZ EmptySq
		MOV AL, 3
		MOV BL, 4
		MOV MarkColor, BL
		JMP ShipSq
EmptySq:MOV AL, 2
		MOV BL, 7
		MOV MarkColor, BL
ShipSq:	MOV [DI], AL
		JMP ShipSq2
		
ShipSq2:		
		MOV AX, ExplosionY
		MOV TargetY, AX
		RET
CalculateExplosion endp
;......................................................................................................................................................
;This procedure is sometimes used for debugging reasons
;Display3DigitNumInAXProc proc
;		Display3DigitNumInAX
;		RET
;Display3DigitNumInAXProc endp

;......................................................................................................................................................
;This proc loops on the Array of each player and draws the marks accordingly, whether it was a hit ship or an empty hit 
;It draws each of them with its respective color
UpdateMarksProc proc
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH SI
		PUSH DI
		PUSH BP
		
		
		
		MOV AL, PlayerTurn
		CMP AL, 0
		JZ P1T
		MOV DI, offset DestroyedArr1
		MOV BX, P1GridStartX
		INC BX
		
		JMP P2T
		
P1T:	MOV DI, offset DestroyedArr2
		MOV BX, P2GridStartX
		INC BX
P2T:	MOV DX, P1GridStartY
		INC DX
		MOV CL, GridSize
		MOV AL, CL
		MUL CL
		MOV CL, AL		;NOW CL = total square num
		
		
		MOV SI, BX
		ADD SI, GridSideLength
		SUB SI, 2
		MOV BP, DX
		ADD BP, GridSideLength
		SUB BP, 2
		
		MOV CH, 0
Traverse2:	
		MOV AL, 2
		CMP [DI], AL
		JB NotHit
		CMP [DI], AL
		JZ GreySQ
		MOV AH, 4
		MOV MarkColor2, AH
		JMP MARK
		
		
GreySQ:	MOV AH, 7
		MOV MarkColor2, AH
		
MARK:   MOV MarkX1, BX
		MOV MarkX2, SI
		MOV MarkY1, DX
		MOV MarkY2, BP
		
		
		
		PUSH AX
		PUSH BX
		PUSH CX
		PUSH DX
		PUSH SI
		PUSH DI
		PUSH BP
		CALL MarkDamagedProc
		POP BP
		POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		

		
		
		
NotHit:	
		ADD BX, GridSideLength
		ADD SI, GridSideLength
		INC CH 
		CMP CH, 4
		JNZ NEXTIT
		ADD DX, GridSideLength
		ADD BP, GridSideLength
		MOV CH, 0
		SUB BX, GridSideLength
		SUB BX, GridSideLength
		SUB BX, GridSideLength
		SUB BX, GridSideLength
		SUB SI, GridSideLength
		SUB SI, GridSideLength
		SUB SI, GridSideLength
		SUB SI, GridSideLength

		
NEXTIT:		
		INC DI
		DEC CL
		JNZ Traverse2
		
		
		POP BP
		POP DI
		POP SI
		POP DX
		POP CX
		POP BX
		POP AX
		
		RET
UpdateMarksProc endp
;......................................................................................................................................................
MarkDamagedProc proc
		MarkDamaged MarkX1, MarkY1, MarkX2, MarkY2, MarkColor2
		RET
MarkDamagedProc endp 
;......................................................................................................................................................
;Checks if any player has 0 number of 1s in his array, updates the GameEnd variable accordingly, 0 = no win, 1 = a player one
;We know which player won since this function is called every turn and we check on the variable each turn
CheckWin proc
		MOV BL, P1Score
		CMP BL, 0
		JNZ CheckP2
		MOV BH, 2
		MOV DI, offset Win
		ADD DI, 7
		MOV [DI], BH
		MOV BL, 1
		MOV GameEnd, BL
CheckP2:MOV BL, P2Score
		CMP BL, 0
		JNZ E5la3
		MOV BH, 1
		MOV DI, offset Win
		ADD DI, 7
		MOV [DI], BH
		MOV BL, 1
		MOV GameEnd, BL
E5la3:	RET
CheckWin endp
;......................................................................................................................................................
DelayProc proc
		PUSH AX
		PUSH BX
		
		MOV AX, BigTime
		
OUTERL:	MOV BX, LittleTime
INNERL:		DEC BX
		JNZ INNERL
		DEC AX
		JNZ OUTERL
		POP BX
		POP AX
		RET
DelayProc endp
end
