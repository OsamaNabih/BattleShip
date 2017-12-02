;-----------------MACROS------

PRINTCHAR MACRO CHAR
      mov ah,2          
      mov dl,CHAR
      int 21h
ENDM PRINTCHAR



MOVECURSOR MACRO ROW,COL
      ;mov bh,00
	  
      MOV DH,ROW
      MOV DL,COL
      MOV AH,2
      INT 10H
ENDM MOVECURSOR 


GETKEYPRESSED MACRO
      MOV AH,0
      INT 16H
ENDM GETKEYPRESSED

READMESSAGE MACRO MSG
      MOV DX, offset MSG
      MOV AH,0AH
      INT 21h 
ENDM READMESSAGE 

CLEAR_SCREEN_UP MACRO 
      mov ax,0600h      ;Scroll Screen AH=06 (Scroll),AL=0 Entire Page
      mov bh,07         ;Normal attributes
      mov cx,0          ;from 0,0
      mov dx,184FH      ;To 18h,4fh
      int 10h   
ENDM CLEAR_SCREEN_UP

CLEAR_SCREEN_DOWN MACRO 
      mov ax,0700h      ;Scroll Screen AH=06 (Scroll),AL=0 Entire Page
      mov bh,07         ;Normal attributes
      mov cx,0          ;from 0,0
      mov dx,184FH      ;To 18h,4fh
      int 10h   
ENDM CLEAR_SCREEN_DOWN


GRAPHICS_MODE MACRO
      mov ah,0          ;Change video mode (Graphical MODE)
      mov al,13h        ;Max memory size 16KByte
                        ;AL:4 (320*200=64000 [2 bits for each pixel,4 colours])
                        ;AL:6 (640*200=128000[1 bit  for each pixel,2 colours B/W])
      int 10h
ENDM GRAPHICS_MODE

DRAW_HLINE MACRO LENGHT,CHAR
      LOCAL DRAW_LINE
      MOV CX , LENGHT
      ;MOVECURSOR ROW_1,COL NOT WORKING
      MOV DH,00H
            DRAW_LINE:
            mov ah,2          
            mov dl,CHAR
            int 21h
            DEC CX
            JNZ DRAW_LINE
ENDM DRAW_HLINE  

DRAW_VLINE MACRO LENGHT,CHAR
LOCAL DRAW_LINEV
MOV CX,LENGHT
       DRAW_LINEV:
      mov ah,2
      PUSH DX          
      mov dl,CHAR
      int 21h 
      POP DX
      INC DH
      MOVECURSOR DH,DL
      DEC CX
      JNZ DRAW_LINEV
      
ENDM DRAW_LINEV

INTRO_DRAW MACRO
		MOVECURSOR 0, 0
		SHOWMESSAGE FIR_PLAYER_NAME
        READMESSAGE FIR_NAME
		SHOWMESSAGE FIR_NAME_Data
		SHOWMESSAGE SEC_PLAYER_NAME
        READMESSAGE SEC_NAME
		SHOWMESSAGE SEC_NAME_Data
        MOVECURSOR 08,35H
        SHOWMESSAGE GAME_INTRO
ENDM INTRO_DRAW 


DRAW_CHAT MACRO MESSAGE_1 , MESSAGE_2
      MOVECURSOR 01,01
      PUSH DX
	  
	  ;GetCursorInDLDH
	 ; DisplayDigit DL
	  ;NewLine
	 ; DisplayDigit DH
	  ;NewLine
      SHOWMESSAGE FIR_NAME_Data
	  GetCursorInDLDH
	  NewLine
	  DisplayDigit DL
	  NewLine
	  DisplayDigit DH
	  NewLine
	  
	  ;SHOWMESSAGE SpaceColon
	  ;NewLine
	

      SHOWMESSAGE MESSAGE_1
	  
      MOVECURSOR 11,00
      DRAW_HLINE 80,'_'
      MOVECURSOR 13,01
      SHOWMESSAGE SEC_NAME_Data

	  SHOWMESSAGE SpaceColon
	  ;NewLine

      SHOWMESSAGE MESSAGE_2 
	  
      MOVECURSOR 15H,00
      DRAW_HLINE 80,'_'
      MOVECURSOR 16H,00
      SHOWMESSAGE GAME_INTRO
ENDM DRAW_CHAT

DRAW_PLAY_SCREEN MACRO 
      LOCAL LBL_CHOOSE
      LOCAL LBL_CHAT
      LOCAL LBL_LEVEL1
      LOCAL LBL_LEVEL2
      LOCAL LBL_END
      LOCAL LBL_PLAY
      LBL_CHOOSE:
      CLEAR_SCREEN_UP
      MOVECURSOR 00,00
      SHOWMESSAGE CHOOSE
      GETKEYPRESSED
      CMP AL,112
      JZ LBL_PLAY
      CMP AL,99
      JZ LBL_CHAT
      cmp al,81
      jz LBL_QUIT
      SHOWMESSAGE MSG_FAIL
      JMP LBL_CHOOSE
      LBL_QUIT:
      CLEAR_SCREEN_UP
      ;INTRO_DRAW

      LBL_PLAY:
      CLEAR_SCREEN_UP
      MOVECURSOR 01,00
      SHOWMESSAGE LEVEL1
      LBL_LEVEL_CHOOSE:
      GETKEYPRESSED
      CMP AL,49
      JZ LBL_LEVEL1
      CMP AL,50
      JZ LBL_LEVEL2
      CMP AL,51
      JZ LBL_CHOOSE
      SHOWMESSAGE MSG_FAIL
      JMP LBL_LEVEL_CHOOSE
      JMP LBL_END
      LBL_LEVEL1:
      MOV [THE_LEVEL],1
      JMP LBL_END
      LBL_LEVEL2:
      MOV [THE_LEVEL],2
      JMP LBL_END
      LBL_CHAT:
      CLEAR_SCREEN_UP
      DRAW_CHAT FIR_NAME_DATA , SEC_NAME_DATA
      JMP LBL_END
      ;LBL_NON:
      ;JMP LBL_CHOOSE
      LBL_END:
ENDM DRAW_PLAY_SCREEN

DRAW_PLAYGROUND MACRO
      GRAPHICS_MODE
      MOV BH,00
      MOVECURSOR 18,00
      DRAW_HLINE 10,3
      MOVECURSOR 19,00 
      SHOWMESSAGE GAME_INTRO 
      MOVECURSOR 21,00 
DRAW_HLINE 40,3
     ; MOVECURSOR
ENDM DRAW_PLAYGROUND



;-----------------------------S