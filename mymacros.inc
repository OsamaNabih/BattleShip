;-----------------MACROS------
ShowMessage MACRO MyMessage
            mov ah,9h
            mov dx,offset MyMessage
            int 21h
ENDM ShowMessage              



ShowThreeTimes MACRO MyMessage
               LOCAL AGAIN
                mov cx,3
                mov ah,9h
                mov dx,offset MyMessage
          AGAIN:int 21h 
                LOOP AGAIN
ENDM ShowThreeTimes 



DisplayChar  Macro char 
		mov ah,2 ;output whatever in dl as 1 char 
		mov dl,char
		int 21h
ENDM DisplayChar



DisplayCharDL Macro
		mov ah, 2
		int 21h
ENDM DisplayCharDL


DisplayDigit Macro Digit
		mov dl, Digit
		mov ah, 2
		add dl, 30h
		int 21h
ENDM DisplayDigit

NewLine     Macro
	DisplayChar 10
	DisplayChar 13
ENDM NewLine



ReadString Macro PromptMessage
	mov ah,0AH        	
	mov dx,offset PromptMessage                 
	int 21h 		
ENDM ReadString



DisplayNumber Macro
		LOCAL LABEL
		LOCAL SHIFT
		PUSHA
		PUSH AX
		MOV CH, 4
		LABEL:
			POP AX
			PUSH AX
			MOV CL, CH
			DEC CL
			SHIFT:
				SHR AX, 4
				DEC CL
				JNZ SHIFT
			AND AL, 00001111b
			DisplayDigit AL
			DEC CH
			JNZ LABEL
		POP AX
		POPA
		
ENDM DisplayNumber

Display2DigitNumInAX Macro
		LOCAL LBL
		PUSH AX
		MOV DL, 10
		DIV DL
		PUSH AX
		CMP AL, 10
		JB LBL

		PUSH AX
		MOV AH, 0
		POP AX

		LBL:
		DisplayDigit AL
		POP AX
		DisplayDigit AH
		POP AX
ENDM Display2DigitNumInAX

Display3DigitNumInAX Macro
		LOCAL TwoDigits
		LOCAL LeadingZero
		PUSH AX
		MOV DL, 100
		DIV DL
		
		CMP AL, 0
		JZ LeadingZero

		PUSH AX
		DisplayDigit AL
		POP AX
		MOV AL, 0
		JMP TwoDigits

		LeadingZero:
		PUSH AX
		DisplayDigit 0
		POP AX
		JMP TwoDigits

		TwoDigits:
		XCHG AH, AL
		Display2DigitNumInAX
		POP AX
ENDM Display3DigitNumInAx

ScrollUpScreen Macro
		MOV AX, 0600h
		MOV BH, 07
		MOV CX, 0
		MOV DX, 184FH
		INT 10H
ENDM ScrollUpScreen

ScrollDownScreen Macro
		MOV AX, 0600h
		MOV BH, 07
		MOV CX, 0
		MOV DX, 184FH
		INT 10H
ENDM ScrollUpScreen

SwitchToGraphicsMode Macro
		MOV AH, 00
		MOV AL, 13h
		INT 10H
ENDM SwitchToGraphicsMode

SwitchToTextMode Macro
		mov ah,00h
		mov al,02h
		int 10h 
ENDM SwitchToTextMode

MoveCursorToDLDH Macro
		MOV BH, 0
		MOV AH, 2
		INT 10H
ENDM MoveCursorToDLDH

MoveCursorToLocation Macro Xpos, Ypos
		MOV AH, 2
		MOV BH, 0
		MOV DL, Xpos
		MOV DH, Ypos
		INT 10h
ENDM MoveCursorToLocation

GetCursorInDLDH Macro
		MOV AH, 3H
		MOV BH, 0H
		INT 10H
ENDM GetCursorInDLDH


DrawHorizontalLine Macro StartX, EndX, Ypos
		LOCAL BACK
		MOV DX, Ypos
		MOV CX, StartX
		MOV AL, 7
		MOV AH, 0CH
	BACK:   INT 10H
		INC CX
		CMP CX, EndX
		JB BACK
ENDM DrawHorizontalLine

DrawVerticalLine Macro StartY, EndY, Xpos
		LOCAL BACK
		MOV CX, Xpos
		MOV DX, StartY
		MOV AL, 7
		MOV AH, 0CH
	BACK:   INT 10H
		INC DX
		CMP DX, EndY 
		JB BACK
ENDM DrawVerticalLine

DrawSquare Macro TopLeftX, TopLeftY, Length
		MOV AX, TopLeftX
		MOV BX, TopLeftY
		MOV SI, Length
		MOV DI, AX
		ADD DI, Length
		INC DI
		PUSH AX ;TopLeftX
		PUSH BX ;TopLeftY
		DrawHorizontalLine AX, DI, BX
		POP BX ;TopLeftY
		POP AX ;TopLeftX
		PUSH AX
		PUSH BX
		ADD BX, Length
		DrawHorizontalLine AX, DI, BX
		POP AX ;TopLeftY
		POP BX ;TopLeftX
		MOV DI, AX
		ADD DI, Length
		INC DI
		PUSH AX
		PUSH BX
		DrawVerticalLine AX, DI, BX
		POP BX
		POP AX
		ADD BX, Length
		DrawVerticalLine AX, DI, BX
ENDM DrawSquare

DrawGrid Macro TopLeftX, TopLeftY, Size, Length
		LOCAL Rows
		MOV AX, TopLeftX
		MOV BX, TopLeftY
		MOV SI, Length
		MOV DX, Size
		MOV BP, AX
		MOV CL, 0 ;row
		MOV CH, 0 ;col
	    Rows: 
			PUSH AX
			PUSH BX
			PUSH CX
			PUSH DX
			PUSH SI
			PUSH DI
			DrawSquare AX, BX, SI
			POP DI 
			POP SI
			POP DX
			POP CX
			POP BX 
			POP AX
			ADD AX, Length
			INC CL
			CMP CL, DL
			JNZ Rows
		MOV AX, BP	
		ADD BX, SI
		MOV CL, 0
		INC CH
		CMP CH, DL
		JNZ Rows	
ENDM DrawGrid

DrawHorizontalLineWithColor Macro StartX, EndX, Ypos, Color
		LOCAL BACK2
		MOV DX, Ypos
		MOV CX, StartX
		MOV AL, Color
		MOV AH, 0CH
	BACK2:   INT 10H
		INC CX
		CMP CX, EndX
		JBE BACK2
ENDM DrawHorizontalLineWithColor

DrawVerticalLineWithColor Macro StartX, EndX, Ypos, Color
		LOCAL BACK2
		MOV DX, Ypos
		MOV CX, StartX
		MOV AL, Color
		MOV AH, 0CH
	BACK2:   INT 10H
		INC CX
		CMP CX, EndX
		JBE BACK2
ENDM DrawVerticalLineWithColor

DrawFilledSquare Macro TopLeftX, TopLeftY, Length, Color
		LOCAL LABEL
		MOV SI, TopLeftX
		INC SI		;to not overwrite the edges
		MOV DI, TopLeftY
		INC DI		;to not overwrite the edges
		MOV BX, Length
		DEC BX		;to not overwrite the edges
		;INC BX 	;for a full sq
		MOV AL, Color
		MOV CX, DI
		ADD CX, Length
		DEC CX		;to not overwrite the edges
		;INC CX		;for a full sq
		ADD BX, SI
  LABEL:		
		PUSH CX
		DrawHorizontalLineWithColor SI, BX, DI, AL
		POP CX
		INC DI
		CMP DI, CX
		JNZ LABEL
ENDM DrawFilledSquare

WriteInScreenMemory Macro Xpos, Ypos, Value
		MOV AX, 0A000h
		MOV ES, AX
		MOV AX, Ypos
		MOV DI, 320
		MUL DI
		MOV DI, AX
		ADD DI, Xpos
		MOV AX, Value
		MOV CX, 1
		REP STOSW
ENDM WriteInScreenMemory

LabelSquares Macro Size, Nums, Color, FirstX, FirstY, model
		LOCAL LABEL, TWODIGIT, LABEL2
		;MOV AX, ES
		;PUSH AX
		MOV AX, DS
		MOV ES, AX
		MOV AX, Size		
		MOV BX, Size
		MUL BX
		MOV DI, AX
		MOV BP, offset Nums
		INC BP
		MOV AH, 13H
		MOV AL, 0
		MOV BH, 0
		MOV BL, Color
		MOV CX, 2
		MOV DH, FirstY
		MOV DL, FirstX
		MOV SI, 0
 LABEL: int 10h
		DEC DI
		;ADD DL, 3
		ADD DL, 2
		ADD DL, model
		
		ADD BP, 2
		INC SI
		CMP SI, Size
		JNZ LABEL
		MOV SI, 0
		MOV DL, FirstX
		
		;ADD DH, 3
		ADD DH, model
		ADD DH, 2
		
		CMP DI, 0000h
		JNZ LABEL   
		;POP AX
		;MOV ES, AX
ENDM LabelSquares


LabelSquaresBig Macro Size, Nums, Color, FirstX, FirstY
		LOCAL LABEL, TWODIGIT, LABEL2
		MOV AX, DS
		MOV ES, AX
		MOV AX, Size		
		MOV BX, Size
		MUL BX
		MOV DI, AX
		MOV BP, offset Nums
		INC BP
		MOV AH, 13H
		MOV AL, 0
		MOV BH, 0
		MOV BL, Color
		MOV CX, 2
		MOV DH, FirstY
		MOV DL, FirstX
		MOV SI, 0
 LABEL: int 10h
		DEC DI
		
		ADD DL, 3
		
		;ADD DL, 2
		
		
		ADD BP, 2
		
		INC SI
		CMP SI, Size
		JNZ LABEL
		MOV SI, 0
		MOV DL, FirstX
		
		
		ADD DH, 3
		
		;ADD DH, 2
		
		
		CMP DI, 0000h
		JNZ LABEL   
ENDM LabelSquaresBig

Delay Macro BigTime, LittleTime
		MOV CX, BigTime
		MOV DX, LittleTime
		MOV AL, 0
		MOV AH, 86H
		INT 15H
ENDM Delay

DrawRectangle Macro TopLeftX, TopLeftY, XLen, YLen
		MOV SI, TopLeftX
		ADD SI, XLen
		INC SI
		PUSH SI 
		PUSH DI 
		DrawHorizontalLine TopLeftX, SI, TopLeftY
		POP DI 
		POP SI
		MOV DI, TopLeftY
		ADD DI, YLen
		PUSH SI
		PUSH DI 
		DrawHorizontalLine TopLeftX, SI, DI
		POP DI
		POP SI
		INC DI
		PUSH SI
		PUSH DI 
		DrawVerticalLine TopLeftY, DI, TopLeftX
		POP DI
		POP SI
		DrawVerticalLine TopLeftY, DI, SI
ENDM DrawRectangle

DrawPixel Macro X, Y, Color
		MOV CX, X
		MOV DX, Y
		MOV AL, Color
		MOV AH, 0CH
		INT 10H
ENDM DrawPixel

Draw45Line Macro X1, Y1, X2, Y2, Color
		LOCAL DECX
		LOCAL DECY
		LOCAL AGAIN
		LOCAL DONE
		LOCAL SKIPX
		MOV DI, X2
		MOV BP, Y2
		MOV SI, X1
		MOV BX, Y1
		
 AGAIN: DrawPixel SI, BX, Color
		CMP SI, DI
		JZ DONE
		CMP SI, DI
		JA DECX
		INC SI
		JMP SKIPX
  DECX: DEC SI
		
 SKIPX: CMP BX, BP
		CMP BX, BP
		JZ DONE
		CMP BX, BP
		JA DECY
		INC BX
		JMP AGAIN
		
DECY:   DEC BX
		JMP AGAIN
		 
DONE:				
ENDM Draw45Line


MarkDamaged Macro TopLeftX, TopLeftY, BotRightX, BotRightY, Color
		Draw45Line TopLeftX, TopLeftY, BotRightX, BotRightY, Color
		Draw45Line TopLeftX, BotRightY, BotRightX, TopLeftY, Color
ENDM MarkDamaged

DrawFilledRectangle Macro TopLeftX, TopLeftY, Length, Width, Color
		LOCAL LABEL
		MOV SI, TopLeftX
		INC SI		;to not overwrite the edges
		MOV DI, TopLeftY
		INC DI		;to not overwrite the edges
		MOV BX, Length
		DEC BX		;to not overwrite the edges
		;INC BX 	;for a full sq
		MOV AL, Color
		MOV CX, DI
		ADD CX, Width
		DEC CX		;to not overwrite the edges
		;INC CX		;for a full sq
		ADD BX, SI
  LABEL:		
		PUSH CX
		DrawHorizontalLineWithColor SI, BX, DI, AL
		POP CX
		INC DI
		CMP DI, CX
		JNZ LABEL
ENDM DrawFilledRectangle

DrawRec Macro TopLeftX, TopLeftY, YLength, XWidth
		MOV AX, TopLeftX
		MOV BX, TopLeftY
		MOV SI, YLength
		MOV DI, AX
		ADD DI, XWidth
		INC DI
		PUSH AX ;TopLeftX
		PUSH BX ;TopLeftY
		DrawHorizontalLine AX, DI, BX
		POP BX ;TopLeftY
		POP AX ;TopLeftX
		PUSH AX
		PUSH BX
		ADD BX, YLength
		DrawHorizontalLine AX, DI, BX
		POP AX ;TopLeftY
		POP BX ;TopLeftX
		MOV DI, AX
		ADD DI, YLength
		INC DI
		PUSH AX
		PUSH BX
		DrawVerticalLine AX, DI, BX
		POP BX
		POP AX
		ADD BX, XWidth
		DrawVerticalLine AX, DI, BX
ENDM DrawRec


DrawFilledRec Macro TopLeftX, TopLeftY, YLength, XWidth, Color
		LOCAL LAB
		MOV SI, TopLeftX
		;INC SI		;to not overwrite the edges
		MOV DI, TopLeftY
		;INC DI		;to not overwrite the edges
		MOV BX, XWidth
		;DEC BX		;to not overwrite the edges
		INC BX 	;for a full sq
		MOV AL, Color
		MOV CX, DI
		ADD CX, YLength
		;DEC CX		;to not overwrite the edges
		INC CX		;for a full sq
		ADD BX, SI
  LAB:		
		PUSH CX
		DrawHorizontalLineWithColor SI, BX, DI, AL
		POP CX
		INC DI
		CMP DI, CX
		JNZ LAB
ENDM DrawFilledRec

DrawStatusBar Macro Ypos
		LOCAL AGAIN
		MOV DL, 0
		MOV DH, Ypos
		MoveCursorToDLDH
		MOV CX, 40
AGAIN:	DisplayChar '-'
		LOOP AGAIN
ENDM DrawStatusBar

DrawDashedHorizontalLine Macro StartX, EndX, Ypos
		LOCAL Again
		LOCAL Done
		MOV DX, Ypos
		MOV CX, StartX
Again:	MOV AL, 15
		MOV AH, 0CH
		INT 10H
		INC CX
		CMP CX, EndX
		JA Done
		MOV AX, CX
		MOV BL, 7
		DIV BL
		CMP AH, 0
		JNZ Again
		ADD CX, 2
		JMP Again
Done:
ENDM DrawDashedHorizontalLine

DrawDashedVerticalLine Macro StartY, EndY, Xpos
		Local Again 
		Local Done
		MOV DX, StartY
		MOV CX, Xpos
Again:	MOV AL, 15
		MOV AH, 0CH
		INT 10H
		INC DX
		CMP DX, EndY
		JA Done
		MOV AX, DX
		MOV BL, 7
		DIV BL
		CMP AH, 0
		JNZ Again
		ADD DX, 2
		JMP Again
Done:		
ENDM DrawDashedVerticalLine
;-----------------------------		
POPALL Macro
		POP BP
		POP SI
		POP DI
		POP DX
		POP CX
		POP BX
		POP AX
ENDM POPALL 

READMESSAGE MACRO MSG
      MOV DX, offset MSG
      MOV AH,0AH
      INT 21h 
ENDM READMESSAGE 
