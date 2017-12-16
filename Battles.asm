include mymacros.inc
include Macros.inc
include Yasmeen.inc
.model small
.stack 256

.data
;osama's input

P1Score db 5
P2Score db 5
FairWarning db 'Take a good look at the grid, then      choose your ship positions$'
PlayerTurnMsg1 DB "Player 1 turn$"
PlayerTurnMsg2 DB "Player 2 turn$"

;0: Main menu (welcome screen)
;1: Levels menu
;2: in game
;3: chat module
Screen DB 0
Level DB 1
GameEnd DB 0

;if HostGuest = 0, then this player is the guest, if HostGuest = 1, then this player is the host
;The host plays on the 0 turn, and the guest plays on the 1 term
HostGuest db 0
sentChat equ 1
receivedChat equ 2
sentPlay equ 3
receivedPlay equ 4
RequestStatus DB 0
SentChatRequest DB 'You have sent a chat request$'
ReceivedChatRequest DB 'You have received a chat request$'
SentPlayRequest DB 'You have sent a play request$'
ReceivedPlayRequest DB 'You have received a play request$'
LineStatusRegister equ 3FDH

Divider db '--------------------------------------------------------------------------------$'
P1CursorX db 00H
P1CursorY db 01H
P2CursorX db 00H
P2CursorY db 13
InputChar db 'A'
ReceivedChar db 'A'
Waiting db 'Waiting for the other player$'
ChatMSG DB 'Press F1 to send a chat request$'
PlayMSG DB 'Press F2 to send a play request$'
HowToExitChat DB 'Press ESC to exit chat$'
Level1MSG DB 'Press 1 to select level 1$'
Level2MSG DB 'Press 2 to select level 2$'

F1 EQU 3BH
F2 EQU 3CH
F3 EQU 3DH
F4 EQU 3EH

ExplosionX DW 50
ExplosionY DW 45
ExplosionHeight DW 2
ExplosionWidth DW 1

;00: Empty Unhit Square
;01: Unhit Ship Square
;02: Hit Empty Square
;03: Hit Ship Square
DestroyedArr1 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h, 00H
DestroyedArr2 db 00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h,00h, 00H


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


Level1 DB 'Level 1$'
Level2 DB 'Level 2$'
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
var DW ?
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
RightMsg db 'Please enter a number from 1 to 16 and then press enter$'
RightMsg2 DB 'Please enter a number from 1 to 25 and then press enter$'
ShipOne db ' for ship 1',10,13,'$'
DifferentShip db 'Place your second ship away from your first',10,13,'$'
ShipTwo db ' for ship 2',10,13,'$' 
LeftMsg db 'Please enter a suitable direction, WASD for gamers!',10,13,'$'          
ShipLeft db 'Please enter a suitable direction away from your first ship, WASD for gamers!',10,13,'$'
GridSize db 4
;end

P1FRX DW 49     ; the start of the left grid +10
P1FRY DW 125
P1FRH DW 10
P1FRW DW 11	; i added a pixel so it could be equal to the small box 
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

P1R1Topleftx dw 40  ; should be the start of the left grid 	
P1R1Toplefty dw 135
P1R1Ylength  dw 25
P1R1Xwidth   dw 30

P1R2Topleftx dw 48 ; the start of the left grid +8 
P1R2Toplefty dw 135
P1R2Ylength  dw 15
P1R2Xwidth   dw 14

BTopleftx dw 150  
BToplefty dw 55
BYlength  dw 50
BXwidth   dw 20


P2R1Topleftx dw 200  ; should be the start of the left grid 	
P2R1Toplefty dw 135
P2R1Ylength  dw 25
P2R1Xwidth   dw 30

P2R2Topleftx dw 208
P2R2Toplefty dw 135
P2R2Ylength  dw 15
P2R2Xwidth   dw 14

P2FRX DW 209    ; the start of the left grid +10
P2FRY DW 125
P2FRH DW 10
P2FRW DW 11
P2FRC DB 9


BFStartx   dw 151; plus the x of the powerbar  by 1 
BFEndX dw 169 ; minus the x of the end of the power bar by 1 
BFYpos  dw 104
PlayerTurn db 0 ; 0 first player , 1 second player  ; should change after every hit is done 



P1GridEndx dw 111	
P2GridEndx dw 271

BigTime dw 10
LittleTime dw 3000




.code
Main proc 
mov ax,@data
mov ds,ax

;SwitchToGraphicsMode
ScrollUpScreen
	CALL ConfigurePorts
	CALL ReadUsernames
	org 50d
	CALL DrawMainMenu
	;CALL DrawWelcomeScreen
	;CALL SelectMode


		;CALL ClearStatusBar
		;CALL ResetCursorToStatusBar
		
		
		
	;	MOV BL, PlayerTurn
	;	MOV BH, 0
	;	CMP BL, 0
	;	JZ Turn11
		
	;	ShowMessage SEC_NAME_Data
	;	Mov AL, SEC_NAME_ACTUAL_SIZE
	;	MoveCursorToLocation AL, 21
	;	JMP MoveOn1
		
;Turn11: Mov AL, FIR_NAME_ACTUAL_SIZE
;		MoveCursorToLocation AL, 21 
;MoveOn1:	




GameLogic:
		CALL ClearStatusBar
		CALL ResetCursorToStatusBar
		MOV BH, PLayerTurn
		CMP BH, HostGuest
		JNZ Turn1
	    ShowMessage SEC_NAME_Data
		Mov AL, SEC_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 24
		ShowMessage Turn
		JMP Player2
		
Turn1:  ShowMessage FIR_NAME_Data
		Mov AL, FIR_NAME_ACTUAL_SIZE
		MoveCursorToLocation AL, 24
		ShowMessage Turn
		JMP Player1
		
Player1: ; here is refered as the player with cannon under Player1 Grid 
		Call HideCannon1Proc      ;i hide the opponent cannon and appear his own cannon and then check if he is using a special card or the opponent
		Call DrawCannon2Proc	  ; is using a special card or excaping the game same for Player2, and he can move his cannon if he pressed the attack button which is space
		; then i go take the Power to Hit the exact square in the Grid 
KeepTaking1:

CheckReceiving:		
		MOV DX, 3FDH	;Line Status Register
		IN AL, DX
		AND AL, 1
		JZ NoReceived

		;If Ready read the Value in Receive data register
		MOV DX, 03F8H
		IN AL, DX
		MOV AH, AL
		cmp ah,2dh ; X Key to Defend from an opponent
		JZ Defense1Step
NoReceived:		
		
		mov ah,1                ; i keep looping untill i take any kind of Key pressed 
		int 16h
		JZ CheckReceiving 
		
		mov ah,0
		int 16h

		Call CheckTransmitterHoldingRegister
		
		mov dx,3F8h
		mov al,ah
		out dx,al
		
		
		cmp ah, F3
		JZ ExitStepNoWinStep
		cmp ah,2ch  ; Z key to attack twice
		Jz Attack1 
		cmp ah,A ; letter A
		JZ  MoveLeft2Step
		cmp ah,D ; rightkey 
		JZ  MovRight2Step
		cmp ah,39h  ; space
		JZ ShowPower1Step
		JMP KeepTaking1
		
Player2:
		Call HideCannon2Proc	; Same as the Previous Player with Different controls 
		Call DrawCannon1Proc
KeepTaking2:
		mov ah,1                ; i keep looping untill i take any kind of Key pressed 
		int 16h
		JZ CheckReceiving2
		
		mov ah,0
		int 16h

		Call CheckTransmitterHoldingRegister
		
		mov dx,3F8h
		mov al,ah
		out dx,al
CheckReceiving2:			
		MOV DX, 3FDH	;Line Status Register
		IN AL, DX
		AND AL, 1
		JZ NoReceived2		
		
		;If Ready read the Value in Receive data register
		MOV DX, 03F8H
		IN AL, DX
		MOV AH, AL
		cmp ah, F3
		JZ ExitStepNoWin
		cmp ah,2ch ;  Z Key to Attack Twice
		Jz Attack2
		cmp ah,A ; letter A
		JZ  MoveLeft1Step
		cmp ah,D ; rightkey 
		JZ  MovRight1
		cmp ah,39h  ; space
		JZ ShowPower1Step
		JMP KeepTaking2
		
NoReceived2:		
		cmp ah,2dh ; X Key to Defend from an opponent
		JZ Defense2
		JMP KeepTaking2
Defense1Step: JMP Defense1
ExitStepNoWinStep: JMP ExitStepNoWin
MovRight2Step: JMP MovRight2	
MoveLeft2Step:   jmp MovLeft2		
MoveLeft1Step:   jmp Movleft1	
SHowPower1Step:  jmp ShowPower1	
Attack1: ;  check if Player on the Right of the map used an attack Card
		mov al,UseAttackOne
		Xor al,00000001b
		mov UseAttackOne,al
		jmp GameLogic 
Defense1:; check if Player on the Right of the map used a Defense Card
		mov al,UseDefenseOne
		Xor al,00000001b
		mov UseDefenseOne,al
		jmp GameLogic
Attack2: ; Check if Player on the left of the map used an attack card 
		mov al,UseAttackTwo
		Xor al,00000001b
		mov UseAttackTwo,al
		jmp GameLogic
Defense2: ; check if player on the left of the map used a defense card 
		mov al,UseDefenseTwo
		Xor al,00000001b
		mov UseDefenseTwo,al
		
		jmp GameLogic
ExitStepNoWin: JMP NoWin
ExitStep: JMP Exit

GameLogicStep:   jmp GameLogic
	
		 
MovRight1: ; check if it is possible to move to the right so i dont move more than the size of the grid (always be beneath the grid)
		mov ax,P1R1Topleftx
		add ax,P1R1Xwidth
		cmp ax,P1GridEndx  ; the end of grid 1 
		JAE GameLogicStep
		mov cx,16  ; the width of the grid 
MoveR1:	; Move by calling MoveR1Proc and then jump to take another Key
		call MoveR1Proc
		dec cx
		cmp cx,0
		JNZ MoveR1
		JMP GameLogicStep
MovRight2: ; check if it is possible to move to the right so i dont move more than the size of the grid (always be beneath the grid)
		mov ax,P2R1Topleftx
		add ax,P2R1Xwidth
		cmp ax,P2GridEndx
		JAE GameLogicStep
		mov cx,16
MoveR2:; Move by calling MoveR2Proc and then jump to take another Key
		Call MoveR2Proc
		dec cx
		cmp cx,0
		JNZ MoveR2
		JMP GameLogicStep		
MovLeft1: ; check if it is possible to move to the left of the grid so i dont move more than the size of the grid (always be beneath the grid)
		mov ax,P1R1Topleftx
		cmp ax,P1GridStartX  ; i think it should be the left of the grid minus 16 not sure wether to make it like that or not ; afkslha for now 
		JBE  GameLogicStep	
		mov cx,16	 ; the width of the grid
MoveL1: ;move by calling MoveL1Proc and then jump to take another key 
		call MoveL1Proc
		dec cx
		cmp cx,0
		JNZ MoveL1
		JMP GameLogicStep
MovLeft2:; check if it is possible to move to the left of the grid so i dont move more than the size of the grid (always be beneath the grid)
		mov ax,P2R1Topleftx
		cmp ax,P2GridStartX 
		JBE GameLogicStep
		mov cx,16	
MoveL2: ;move by calling MoveL2Proc and then jump to take another key 
		call MoveL2Proc
		dec cx
		cmp cx,0
		JNZ MoveL2
		JMP GameLogicStep
		; There is always 2 Proc. for every move for each cannon one for each Player 
		
ShowPower1: ; i draw the power bar when he presses space to get the right power
		mov BFYpos,104 ; reset the starting place for the next time we hit a ship
		call DrawPowerBar
		JMP ChoosePower1
Step:	jmp ShowPower1
ShowPowerStep:	jmp ShowPower1
ChoosePower1: ; i keep filling the bar and unfilling it untill the player Fire his projectile 
		mov bl,PlayerTurn
		CMP BL, HostGuest
		JNZ MyTurn
		
		;Check if received
		MOV DX, 3FDH
		IN AL, DX
		AND AL, 1
		JNZ TakeValue
		JMP CheckMe
		
MyTurn:
		mov ah,1
		int 16h
		JNZ TakeValue  ; take the ypos in cx and send it to the game logic so what ever the calculation u want to perform
CheckMe:call FillBarProc
		mov ax,BFYpos
		cmp ax,56
		JNZ ChoosePower1		
		
UnFill:
		mov bl,PlayerTurn
		CMP BL, HostGuest
		JZ CheckMe2
MyTurn2:
		mov ah,1
		int 16h
		JMP CheckMe2
Recv:	MOV DX, 3FDH
		IN AL, DX
		AND AL, 1
		
CheckMe2:JNZ TakeValue
		call UnFillBarProc
		mov ax,BFYpos
		cmp ax,104
		JNZ UnFill
		JMP ChoosePower1


ShowPowerStepStep: JMP ShowPowerStep		
TakeValue:  ; if he Fired his Projectile i remove the powerbar then i check wether a defense card was activated by the other opponent so the grid wouldnt take any damage
			call RemoveBarProc
			mov bl,PlayerTurn
			CMP BL, HostGuest
			jnz TakeBuffer
;Read the value received in data register
			CALL CheckDataReady
			MOV DX, 03F8H
			IN AL, DX
			MOV AH, AL
			PUSH AX 
			CALL CheckTransmitterHoldingRegister
			mov dx,3F8h
			mov al,ah
			out dx,al
			POP AX
			JMP CheckInput
			
TakeBuffer:			
			mov ah,0
			int 16h
			
			CALL CheckTransmitterHoldingRegister
			
			mov dx,3F8h
			mov al,ah
			out dx,al
			
			
			
			CALL CheckDataReady
			MOV DX, 03F8H
			IN AL, DX
			
CheckInput:	push ax 
			
			mov al,UseDefenseOne ; defense was activated 
			cmp al,1
			jz DefenseOneStep
			
			mov al,UseDefenseTwo; defense was activated 
			cmp al,1
			jz DefenseTwoStep
			
			pop ax

		
			cmp ah,39h  ; space
			JNZ ShowPowerStepStep
			
			;Trying to fix the bar delay
			MOV BL, PLayerTurn
			CMP BL, HostGuest
			JNZ SendExplosionY
			CALL CheckDataReady
			MOV DX, 03F8H
			IN AL, DX
			
			MOV AH, 0
			MOV ExplosionY, AX
			JMP Shoot
SendExplosionY: mov ax,BFYpos ; to put the y pos at a value so i can calculate where to hit in the grid
				mov ExplosionY,ax
				PUSH AX
				CALL CheckTransmitterHoldingRegister
				mov dx,3F8h
				POP AX
				out dx,al
				
Shoot:			
			MOV AL, PlayerTurn
			CMP AL, HostGuest
			JNZ Stepcannon
			JMP Step2cannon
			
			
			
AftCannon:	cmp GridSizeOS,4
			jz StepMappingGrid4x4 ; here i put the y position of the powerbar in a variable to mape it to the grid4x4
			jmp MappingGrid5x5 ; here i put the y position of the powerbar in a variable to mape it to the grid5x5
	
			
			
DefenseOneStep: JMP DefenseOne			
			
			
			
AftMapping:	CALL CalculateExplosion
			CALL ShootTorpedo
			CALL CalculateScore
			
			
NoShoot:	mov al,UseAttackOne ;check if the player used a attack card 
			cmp al,1
			jz AttackOne
			
			mov al,UseAttackTwo ;check if the player used a attack card 
			cmp al,1
			jz AttackTwo
			
		
		CALL CheckWin
		MOV BL, GameEnd
		CMP BL, 1
		JZ ExitStep2
			
ShiledActivate:			mov al,PlayerTurn ; i change the Player Turn and MoveOn with the game 
						Xor al,00000001b
						mov PlayerTurn,al
			
Continue:	JMP GameLogicStep  ; Continue is a label for the cards only 
StepMappingGrid4x4: jmp MappingGrid4x4	
DefenseTwoStep: JMP DefenseTwo		
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
			Jmp ShiledActivate
Stepcannon: jmp Player1Cannon
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

Step2cannon: JMP Player2Cannon
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
	 
NoHit: 	CALL ClearStatusBar
		CALL ResetCursorToStatusBar
		ShowMessage BadShot
		Mov AX, 1000
		MOV BigTime, AX
		MOV AX, 3000
		MOV LittleTime, AX
		CALL DelayProc
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
		mov ax,99
		mov ExplosionY,ax
		jmp AftMapping
G5Row4:
		mov ax,83
		mov ExplosionY,ax
		jmp AftMapping
G5Row3:
		mov ax,67
		mov ExplosionY,ax
		jmp AftMapping
G5Row2:
		mov ax,51
		mov ExplosionY,ax
		jmp AftMapping
G5row1:
		mov ax,35
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

Exit: 
	  SwitchToTextMode
	  ScrollUpScreen
	  SwitchToGraphicsMode
	  Call DrawFrame
	  MOV BL, PlayerTurn
	  CMP BL, HostGuest
	  JNZ OneWon
	  MoveCursorToLocation 14, 4
	   ShowMessage sec_NAME_Data
	  Mov AL, SEC_NAME_ACTUAL_SIZE
		INC AL
		ADD AL, 14
		MoveCursorToLocation AL, 4
		ShowMessage Win
	  JMP Freeze
OneWon:	MoveCursorToLocation 14, 4
		ShowMessage FIR_NAME_Data
		Mov AL, FIR_NAME_ACTUAL_SIZE
		INC AL
		ADD AL, 14
		MoveCursorToLocation AL, 4
		ShowMessage Win
		Freeze:
NoWin:MoveCursorToLocation 0, 23	
ReadString P1
Mov Ah,4ch
int 21h
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
		MOV DX, 189
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
DrawPlayersBars	proc
		MOV DX, 181
		MOV CX, 0
AgainAgain2:	MOV AL, 15
		MOV AH, 0CH
		INT 10H
		SUB DX, 8
		INT 10H
		ADD DX, 8
		INC CX
		CMP CX, 320
		JZ Done
		MOV AX, CX
		MOV BL, 7
		DIV BL
		CMP AH, 0
		JNZ AgainAgain2
		ADD CX, 2
		JMP AgainAgain2
DrawPlayersBars endp 
;......................................................................................................................................................
DisplayPlayersChats	proc
		MoveCursorToLocation 0, 23
		ShowMessage SEC_NAME_Data
		MOV DI, offset SEC_NAME
		INC DI
		MoveCursorToLocation [DI], 23
		DisplayChar ':'
		MoveCursorToLocation 0, 22
		ShowMessage FIR_NAME_Data
		MOV DI, offset SEC_NAME
		INC DI
		MoveCursorToLocation [DI], 22
		DisplayChar ':'
		RET
DisplayPlayersChats endp
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
		CALL DrawPlayersBars
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
		DrawFilledRec 0, 190, 10, 320, 0
		RET
ClearStatusBar endp
;......................................................................................................................................................
ResetCursorToStatusBar proc
		MoveCursorToLocation 0, 24
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
ReadUsernames proc
		SwitchToTextMode
		MOVECURSOR 0, 0
		SHOWMESSAGE FIR_PLAYER_NAME
        READMESSAGE FIR_NAME
		;Transmit
		DisplayChar 10
		ShowMessage Waiting
		;CALL Sync
		
		MOV CX, 17 ;Total size of the buffer size + actual size + data
		MOV DI, offset FIR_NAME
		MOV SI, offset SEC_NAME
Send:		
		CALL CheckTransmitterHoldingRegister

;If empty put the VALUE in Transmit Data Register
		MOV DX, 3F8H
		MOV AL, [DI]
		OUT DX, AL
		INC DI
		
;Receive:
		;Check that Data Ready
		CALL CheckDataReady

;If ready read the VALUE in Receive Data Register
		MOV DX, 03F8H
		IN AL, DX
		MOV [SI], AL
		INC SI
		
		
		DEC CX
		JNZ Send
		RET
ReadUsernames endp
;......................................................................................................................................................
DrawFrame proc
		DrawDashedHorizontalLine 94, 208, 19
		DrawDashedHorizontalLine 94, 208, 52

		DrawDashedVerticalLine 19, 52, 208
		DrawDashedVerticalLine 19, 52, 94
		RET
DrawFrame endp
;......................................................................................................................................................
PlayMode proc
		SwitchToGraphicsMode
		Call DrawWelcomeGrid 
		MoveCursorToLocation 0, 0
		CALL ReadShips	   
		
		SwitchToGraphicsMode
		CALL DrawUI
		Call CalculateScore
		RET
PlayMode endp
;......................................................................................................................................................
AdjustVariables proc
		MOV AL, Level
		CMP AL, 1
		JNZ Level2Vars
		MOV AX, 4		;Grid Size
		MOV GridSizeOS, AX
		MOV GridSize, AL
		MOV AX, 47		;First player grid X
		MOV P1GridStartX, AX
		MOV AX, 43		;First player and second player grid Y 
		MOV P1GridStartY, AX
		MOV P2GridStartY, AX
		MOV AX, 207		;Second player grid X
		MOV P2GridStartX, AX
		JMP VariablesAdjusted	
Level2Vars:
		MOV AX, 5		;Grid Size
		MOV GridSizeOS, AX
		MOV GridSize, AL
		MOV AX, 47		;First player grid X
		MOV P1GridStartX, AX
		MOV AX, 35		;First player and second player grid Y 
		MOV P1GridStartY, AX
		MOV P2GridStartY, AX
		MOV AX, 191		;Second player grid X
		MOV P2GridStartX, AX
		MOV AL, 6		;First player label X, first and second player label Y
		MOV Grid1LabelStartX, AL
		MOV Grid1LabelStartY, AL
		MOV Grid2LabelStartY, AL
		MOV AL, 26		;Second player label X
		MOV Grid2LabelStartX, AL
		MOV AX,P2R1Topleftx
		SUB AX,GridSideLength 
		MOV P2R1Topleftx,AX
		MOV AX, P2R2Topleftx 
		SUB AX, GridSideLength
		MOV P2R2Topleftx,Ax
		MOV AX,P2FRX 
		SUB AX,GridSideLength
		MOV P2FRX,AX
		MOV AX,P1GridEndx
		ADD AX, GridSideLength
		MOV P1GridEndx,AX
VariablesAdjusted:

		RET
AdjustVariables endp
;......................................................................................................................................................
ResetVariables proc
		MOV AX, 4		;Grid Size
		MOV GridSizeOS, AX
		MOV GridSize, AL
		MOV AX, 47		;First player grid X
		MOV P1GridStartX, AX
		MOV AX, 43		;First player and second player grid Y 
		MOV P1GridStartY, AX
		MOV P2GridStartY, AX
		MOV AX, 207		;Second player grid X
		MOV P2GridStartX, AX
		MOV AL, 0
		MOV P1CursorX, AL
		MOV P2CursorX, AL
		MOV AL, 1
		MOV P1CursorY, AL
		MOV AL, 13
		MOV P2CursorY, AL
		RET
ResetVariables endp
;......................................................................................................................................................
DrawLevelsMenu proc
		CALL DrawFrame
		MoveCursorToLocation 14, 7
		ShowMessage GameName
		MoveCursorToLocation 14, 11
		DisplayChar 16
		DisplayChar 32
		ShowMessage Level1
		MoveCursorToLocation 14, 13
		DisplayChar 32
		DisplayChar 32
		ShowMessage Level2
		MoveCursorToLocation 15, 11
		MOV AL, 1
		MOV Screen, AL
		RET
DrawLevelsMenu endp
;......................................................................................................................................................
ReadShips proc 
					SwitchToTextMode
                    ShowMessage PlayerOneMsg
					MOV BL, Level
					CMP BL, 2
					JZ OneTo25
                    ShowMessage RightMsg
					JMP TakeShips
OneTo25:			ShowMessage RightMsg2
TakeShips:          ShowMessage ShipOne
                    TakeInput GridSize
                    add P13Ship[0],al
                    TakeDirections  P13Ship GridSize
                    ShowMessage RightMsg
                    ShowMessage ShipTwo 
StartP12:
                    TakeInput GridSize 
                    cmp al,P13Ship[0] 
                    je Skip
                    cmp al,P13Ship[1] 
                    je Skip	
                    cmp al,P13Ship[2] 
                    je Skip
                    jmp correct		
Skip:               ShowMessage DifferentShip
                    jmp StartP12  
correct:        
                    add P12Ship[0],al  
                    TakeDirections2  P12Ship P13Ship GridSize
		            push bx 
	                push DI
		            mov bx,offset DestroyedArr1
                    mov DI, offset P13Ship  
                    dec bx
                    editShip
					
					;CALL Sync
					ShowMessage Waiting
					MOV AL, GridSize
					MUL AL
					MOV CX, AX
					MOV DI, offset DestroyedArr1
					MOV SI, offset DestroyedArr2
SendLoop:
					CALL CheckTransmitterHoldingRegister
					;If empty put the VALUE in Transmit Data Register
					MOV DX, 3F8H
					MOV AL, [DI]
					OUT DX, AL
					INC DI
		
;Receive
					;Check that Data Ready
					CALL CheckDataReady

					;If ready read the VALUE in Receive Data Register
					MOV DX, 03F8H
					IN AL, DX
					MOV [SI], AL
					INC SI
					DEC CX
					JNZ SendLoop
					RET
ReadShips endp
;......................................................................................................................................................
DrawWelcomeGrid proc
			;Model 1 for a spaced out grid filling up a big portion of the screen, it is changed to 0 later on
								;in order to fit both grids into the UI
		MOV CL, 1
		MOV model, CL
		MOV CX, 24	;Spaces out labels require a larger Side Length for the grid's squares
		MOV GridSideLength, CX
		LabelSquares GridSizeOS, Nums, Grid1LabelColor, 13, 8, model
		DrawGrid 99, 56, GridSizeOS, GridSideLength
		
		MOV CL, 0		;Resetting the model for the game UI
		MOV model, CL
		MOV CX, 16			;Resetting the side length
		MOV GridSideLength, CX
		
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
		MOV DX, P1FRY					;The Y of the filled rectangle at the top of the cannon, in order to draw the projectile starting from this point
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
		
		MOV DI, GridSizeOS
		INC DI
		;MOV BH, 0		;In this loop I check if the top of the projectile crosses a grid line, then I change the eraser color to grey instead of black
		MOV SI, P1GridStartY	;We check by starting at the top Y of the grid, and incrementing the side lengths N times, where N is grid size, to check if the projectile
		DEC SI					;has the same Y
		SUB SI, GridSideLength
		
CHECK:	ADD SI, GridSideLength
		;INC BH
		DEC DI
		CMP DX, SI
		JZ GREY
		;CMP BH, 5
		CMP DI, 0
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
;......................................................................................................................................................
CalculateExplosion proc
		MOV AL, PlayerTurn
		CMP AL, HostGuest
		JNZ P2G
		MOV CX, P1GridStartX
		JMP YCOORD
P2G:	MOV CX, P2GridStartX	
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
		MOV CH, 0
		DIV CL
		MOV CL, AL
		MOV AX, GridSideLength
		MOV AH, 0
		MUL BL
		MOV BL, PlayerTurn
		CMP BL, HostGuest
		JNZ G2
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
		CMP BL, HostGuest
		JNZ G22
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
		CMP BL, HostGuest
		JNZ DEST2
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
Display3DigitNumInAXProc proc
		Display3DigitNumInAX
		RET
Display3DigitNumInAXProc endp
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
		CMP AL, HostGuest
		JNZ P1T
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
		
		;BX = LeftX
		;SI = RightX
		;DX = UpY
		;BP = DownY
		

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
		CMP CH, GridSize
		JNZ NEXTIT
		ADD DX, GridSideLength
		ADD BP, GridSideLength
		MOV CH, 0
		
		PUSH CX
		MOV CL, 0
MoveBackwards:
		SUB BX, GridSideLength
		SUB SI, GridSideLength
		INC CL
		CMP CL, GridSize
		JNZ MoveBackwards
		
		POP CX 
		

		
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
;......................................................................................................................................................
Sync proc
SyncLBL:	CALL CheckTransmitterHoldingRegister
		MOV DX, 3F8H
		MOV AL, 'K'
		OUT DX, AL
		
		CALL CheckDataReady
		MOV DX, 03F8H
		IN AL, DX
		CMP AL, 'K'
		JNZ SyncLBL
		RET
Sync endp
;......................................................................................................................................................
RunChat proc
		SwitchToTextMode
		Clear_Screen_up
		MoveCursorToLocation 0, 11
		ShowMessage Divider
		CALL DrawExitChat
		Call DisplayUsernames
		MoveCursorToLocation 0, 1
		MYLOOP:
			MOV AH, 1 
			INT 16H
			JZ Receive2Step
	
			MOV AH, 0
			INT 16H
			MOV InputChar, AL
			
			MOV CL, P1CursorX
			MOV CH, P1CursorY
			MoveCursorToLocation CL, CH
			CMP InputChar, 13	;Enter key scan code
			JZ EnterKey
			JMP Display
MYLOOPSTEP: JMP MYLOOP		
Receive2Step: JMP Receive2		
EnterKey:   
			MOV BL, 10
			MOV InputChar, BL
Display:
			DisplayChar InputChar
			CMP InputChar, 8
			JNZ NotBackspace
			DisplayChar 0
			DisplayChar 8
NotBackspace:
			GetCursorInDLDH
			MOV P1CursorX, DL
			MOV P1CursorY, DH
	
			CMP DH, 11
			JB CheckReceive
			MOV DH, 1
			MOV P1CursorY, DH
		CLEAR_SCREEN_UP_FROM_TO 0000, 0A4Eh	;From (0,1) to (79, 10)
		Call DisplayUsernames
CheckReceive:
		;Check that Transmitted Holding Register is Empty
		CALL CheckTransmitterHoldingRegister

			;If empty put the VALUE in Transmit Data Register
			MOV DX, 3F8H	;Transmit data register
			MOV AL, InputChar
			OUT DX, AL
	
			;Go Back To Main Menu
			MOV AL, InputChar
			CMP AL, 1BH   ;Escape ASCII
			JNZ KeepChatting
			CALL GoToMainMenu
KeepChatting:	
			Receive2:
			;Check that Data Ready
			MOV DX, 3FDH	;Line Status Register
			IN AL, DX
			AND AL, 1
			JZ MYLOOPSTEP

			;If Ready read the Value in Receive data register
			MOV DX, 03F8H
			IN AL, DX
			MOV ReceivedChar, AL
			
			;Go back to main menu
			CMP AL, 1BH  ;Escape ASCII
			JNZ KeepChatting2
			CALL GoToMainMenu
KeepChatting2:			
			MOV CL, P2CursorX
			MOV CH, P2CursorY
			MoveCursorToLocation CL, CH
			DisplayChar ReceivedChar
			CMP ReceivedChar, 8
			JNZ NotBackspace2
			DisplayChar ' '
			DisplayChar 8
			
NotBackspace2:				
			GetCursorInDLDH
			MOV P2CursorX, DL
			MOV P2CursorY, DH
	
			CMP DH, 23
			JB Done2
			MOV DH, 13
			MOV P2CursorY, DH
			CLEAR_SCREEN_DOWN_FROM_TO 0D00h, 184Fh  ;From (0,13) to (79, 24)
			CALL DrawExitChat
		Done2:	
		JMP MYLOOP
		RET
RunChat endp
;......................................................................................................................................................
CheckTransmitterHoldingRegister proc
			MOV DX, LineStatusRegister
AGAIN4:		IN AL, DX
			AND AL, 00100000b
			JZ AGAIN4
		RET
CheckTransmitterHoldingRegister	endp
;......................................................................................................................................................
CheckDataReady proc
		MOV DX, 3FDH
CHK2:	IN AL, DX
		AND AL, 1
		JZ CHK2
		RET
CheckDataReady endp
;......................................................................................................................................................
ConfigurePorts proc
		;Set Divisor Latch Access Bit
		MOV DX, 3FBH
		MOV AL, 10000000b
		OUT DX, AL

		;Set LSB byte of the Baud Rate Divisor Latch register
		MOV DX, 3F8H
		MOV AL, 0CH
		OUT DX, AL

		;Set MSB byte of the Baud Rate Divisor Latch register
		MOV DX, 3F9H
		MOV AL, 00H
		OUT DX, AL

		;Set port configuration
		MOV DX, 3FBH
		MOV AL, 00011011b
			;0:Access to Receiver buffer, Transmitter buffer
			;0:Set Break disabled
			;011:Even Parity
			;0:One Stop Bit
			;11:8bits
		OUT DX, AL
		RET
ConfigurePorts endp
;......................................................................................................................................................
DisplayUsernames proc
		MoveCursorToLocation 0, 12
		ShowMessage SEC_NAME_Data
		MOV DI, offset SEC_NAME
		INC DI
		MoveCursorToLocation [DI], 12
		DisplayChar ':'
		MoveCursorToLocation 0, 0
		ShowMessage FIR_NAME_Data
		MOV DI, offset SEC_NAME
		INC DI
		MoveCursorToLocation [DI], 0
		DisplayChar ':'
		RET
DisplayUsernames endp
;......................................................................................................................................................
HandleRequests proc
		CALL DrawStatusBarProc
MYLOOP2:
	Sending:
			MOV AH, 1
			INT 16H
			JZ ReceivingStep
			MOV AH, 0
			INT 16H
			MOV BL, RequestStatus
			CMP BL, sentChat
			JZ ReceivingStep
			
			CMP AH, F1
			JNZ NotF1Pressed
			MOV BL, RequestStatus
			CMP BL, receivedChat
			PUSHF
			CALL CheckTransmitterHoldingRegister
			MOV DX, 3F8H	;Transmit data register
			MOV AL, AH
			OUT DX, AL
			POPF
			JZ GoToChatAsGuestStep
		
			
			Call CheckTransmitterHoldingRegister
			;If empty put the VALUE in Transmit Data Register
			MOV DX, 3F8H	;Transmit data register
			MOV AL, AH
			OUT DX, AL
			
			MOV BL, 1
			MOV RequestStatus, BL
			CALL ClearStatusBar
			CALL ResetCursorToStatusBar
			ShowMessage SentChatRequest
			JMP MYLOOP2
ReceivingStep: JMP Receiving			
NotF1Pressed:		
			CMP AH, F2
			JNZ NotF2Pressed
			MOV BL, RequestStatus
			CMP BL, sentPlay
			JZ Receiving
			CMP BL, receivedPlay
			PUSHF
			CALL CheckTransmitterHoldingRegister
			MOV DX, 3F8H	;Transmit data register
			MOV AL, AH
			OUT DX, AL
			POPF
			JZ GoToPlayAsGuestStep
			
			Call CheckTransmitterHoldingRegister
			;If empty put the VALUE in Transmit Data Register
			MOV DX, 3F8H	;Transmit data register
			MOV AL, AH
			OUT DX, AL
			MOV BL, 3
			MOV RequestStatus, BL
			CALL ClearStatusBar
			CALL ResetCursorToStatusBar
			ShowMessage SentPlayRequest
			JMP MYLOOP2
GoToChatAsGuestStep: JMP GoToChatAsGuest			
MYLOOP2Step: JMP MYLOOP2
NOTF2Pressed:


Receiving:
			;Check that Data Ready
			MOV DX, 3FDH	;Line Status Register
			IN AL, DX
			AND AL, 1
			JZ MYLOOP2Step

			;If Ready read the Value in Receive data register
			MOV DX, 03F8H
			IN AL, DX
			CMP AL, F1
			JNZ NotF1Received
			MOV BL, RequestStatus
			CMP BL, receivedChat
			JZ MYLOOP2Step
			CMP BL, sentChat
			JZ GoToChatAsHost
			MOV BL, receivedChat
			MOV RequestStatus, BL
			CALL ClearStatusBar
			CALL ResetCursorToStatusBar
			ShowMessage ReceivedChatRequest
			JMP MYLOOP2Step
GoToPlayAsGuestStep: JMP GoToPlayAsGuest			
NotF1Received:
			CMP AL, F2
			JNZ NotF2Received
			MOV BL, RequestStatus
			CMP BL, receivedPlay
			JZ MYLOOP2Step
			CMP BL, sentPlay
			JZ GoToPlayAsHost
			MOV BL, receivedPlay
			MOV RequestStatus, BL
			CALL ClearStatusBar
			CALL ResetCursorToStatusBar
			ShowMessage ReceivedPlayRequest
			JMP MYLOOP2Step

NotF2Received:

GoToChatAsGuest: 	MOV AL, 0
					JMP GoToChat
GoToChatAsHost:		MOV AL, 1					
GoToChat:			MOV HostGuest, AL
					MOV RequestStatus, 0
					CALL RunChat
					JMP EndofProc
GoToPlayAsGuest:	CALL CheckDataReady
					MOV DX, 03F8H
					IN AL, DX
					MOV Level, AL
					CALL CheckTransmitterHoldingRegister
					MOV DX, 3F8H	;Transmit data register
					OUT DX, AL
					MOV AL, 0
					JMP GoToPlay
GoToPlayAsHost:		CALL SelectLevels
ChooseLevel:		MOV AH, 1
					INT 16H
					JZ ChooseLevel
					MOV AH, 0
					INT 16H
					;CMP AH, 02
					;MoveCursorToLocation 0, 0
					;ShowMessage ChatMSG
					CMP AL, 31H
					JZ Lvl1
					;CMP AH, 03
					CMP AL, 32H
					JZ Lvl2
					JMP ChooseLevel
					
Lvl2:				MOV AH, 2
					JMP LevelSelected
Lvl1:				MOV AH, 1
LevelSelected:		MOV Level, AH
					CALL CheckTransmitterHoldingRegister
					MOV DX, 3F8H	;Transmit data register
					MOV AL, AH
					OUT DX, AL
					CALL CheckDataReady
					MOV DX, 03F8H
					IN AL, DX
					MOV AL, 1
GoToPlay:			MOV HostGuest, AL
					MOV RequestStatus, 0
					CALL AdjustVariables
					CALL PlayMode
					JMP EndofProc
EndofProc:		
		RET
HandleRequests endp
;......................................................................................................................................................
DrawMainMenu proc
		SwitchToGraphicsMode
		CALL DrawFrame
		MoveCursorToLocation 14, 4
		ShowMessage GameName
		MoveCursorToLocation 4, 11
		DisplayChar 4
		DisplayChar 32
		ShowMessage ChatMSG
		MoveCursorToLocation 4, 13
		DisplayChar 4
		DisplayChar 32
		ShowMessage PlayMSG
		;MoveCursorToLocation 15, 11
		CALL DrawStatusBarProc
		CALL HandleRequests
		RET
DrawMainMenu endp
;......................................................................................................................................................
SelectLevels proc	 
		ScrollDownScreen
		MoveCursorToLocation 4, 9
		DisplayChar 4
		DisplayChar 32
		ShowMessage Level1MSG
		MoveCursorToLocation 4, 11
		DisplayChar 4
		DisplayChar 32
		ShowMessage Level2MSG
		RET
SelectLevels endp
;......................................................................................................................................................
GoToMainMenu proc
		POP AX
		CALL ResetVariables
		MOV AX, 50	;IP value to go to main menu
		PUSH AX
		RET
GoToMainMenu endp
;......................................................................................................................................................
DrawExitChat proc
		MoveCursorToLocation 0, 23
		ShowMessage Divider
		ShowMessage HowToExitChat
		RET
DrawExitChat endp
end
