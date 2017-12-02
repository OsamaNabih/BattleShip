TakeInput Macro Num
local START
local Fin
local TooLate
local doublekill
local places 
local afterplaces
local Done
local Five
local Four
local Complete
local EnterRight
START:                  mov ah,07
                        int 21h
                        mov bl,al
                        mov ah,07
                        int 21h
                        mov bh,al
                        cmp bh,0Dh
                        jz Toolate
                        mov ah,07
                        int 21h 
			jmp doublekill
TooLate:
                        cmp al,0Dh
                        jnz EnterRight 
			sub bl,48
			JS EnterRight
			cmp bl,9
			ja EnterRight
			cmp bl,0
			je EnterRight
                        mov al,bl 
                        jmp Fin            
doublekill:             
                        cmp al,0Dh
                        jnz EnterRight 
			push bx
  			add bl,bh	
			cmp bl,96
			pop bx
			jz EnterRight
			sub bl,48
			JS EnterRight
			sub bh,48  
			JS EnterRight
                        mov al,bl
                        mov ah,10
                        mul ah
                        add al,bh
			push bx
			mov bl,Num 
			cmp bl,4
			pop bx
			jnz Five
                        
Four:			
			cmp al,16
			ja EnterRight
			jmp Fin			

Five:
                        cmp al,25
                        ja EnterRight
                        jmp Fin
EnterRight:              

                        mov ah,09h
                        mov dx, offset RightMsg
                        int 21h 
			mov ah,2
			mov dl,10
			int 21h
			mov ah,2
			mov dl,13
			int 21h
                        jmp START           
Fin:                   
ENDM      TakeInput 
TakeDirections MACRO P13Ship, GridSize 
local StartTake
local CheckDown   
local CheckUp 
local checkLeftRight
local CheckRight      
local CheckLeft
local MiddleWare41
local MiddleWare42
local AfterMiddleWare41
local Fin2
local AfterMiddleWare42
local intjump
local intmp2
local intjump1
local MiddleWare
StartTake:           
                      mov ah,09h
                      mov dx, offset LeftMsg
                      int 21h 
                      mov ah,0
			int 16h
                      mov cl,ah
                      mov bl,P13Ship[0]
		      push ax
 		      mov al,GridSize
		      add al,GridSize
		      mov CheckUpThree, al
		      pop ax
		      push dx
		      mov dl,P13Ship[0]
                      cmp dl,CheckUpThree
		      pop dx
                      ja CheckUp 
CheckDown:               
                      cmp cl,1Fh
                      jnz intmp2
                      push ax
                      mov al,P13Ship
		      add al,GridSize 
                      mov P13Ship[1],al
                      add al,GridSize 
                      mov P13Ship[2],al
		      pop ax
                      jmp CheckLeftRight
intjump1:
				jmp starttake
intmp2:
		      push ax
 		      mov al,GridSize
		      add al,GridSize
		      mov CheckUpThree, al
		      pop ax
		      push dx
		      mov dl,P13Ship[0]
                      cmp dl,CheckUpThree
		      pop dx
                      ja CheckUp
			jmp checkLeftRight
CheckUp:                       
                      cmp cl,11h
                      jnz checkLeftRight
                      push ax
                      mov al,P13Ship
		      sub al,GridSize 
                      mov P13Ship[1],al
                      sub al,GridSize 
                      mov P13Ship[2],al
		      pop ax
                      jmp checkLeftRight 
checkLeftRight:
                      jmp CheckRight
intjump:
				jmp intjump1
CheckRight:           	
		      push ax
		      push bx
                      mov al,P13Ship[0]
                      mov ah,0 
		      mov bl, gridsize
		      div bl
		      cmp ah,0
		      je MiddleWare41
		      mov bl,gridsize
		      sub bl,1
		      cmp ah,bl
		      je MiddleWare41
		      pop bx
		      pop ax
			  jmp AfterMiddleWare41
MiddleWare41:
				pop bx
		      pop ax
			  jmp CheckLeft
AfterMiddleWare41:
                      cmp cl,20h
                      jnz MiddleWare
                      push ax
                      mov al,P13Ship
		      add al,1
                      mov P13Ship[1],al
                      add al,1
                      mov P13Ship[2],al
		      pop ax
CheckLeft:          
		      push ax
		      push bx
                      mov al,P13Ship[0]
                      mov ah,0 
		      mov bl,gridsize
		      div bl
		      cmp ah,1
		      je MiddleWare42
		      cmp ah,2
		      je MiddleWare42
			  pop bx
		      pop ax
			  jmp AfterMiddleWare42
		      
MiddleWare42:
			pop bx
		      pop ax
			  jmp MiddleWare
AfterMiddleWare42:
                      cmp cl,1Eh
                      jnz MiddleWare
		      push ax
                      mov al,P13Ship
		      sub al,1
                      mov P13Ship[1],al
                      sub al,1
                      mov P13Ship[2],al
		      pop ax             
MiddleWare:                 
                      cmp P13Ship[1],99h
                      jz intjump
                     jnz Fin2
Fin2:                  
ENDM TakeDirections 


TakeDirections2 MACRO P12Ship, P13Ship, GridSize 
local StartTake2
local CheckNotPlace
local CheckDown2 
local CheckUp2
local checkLeftRight2 
local CheckRight2
local Pump2
local CheckLeft2
local intermediateJmpPop3
local intermediateJmpPop2
local intermediateJmpPop
local MiddleWare2
local Fin3
local intermediateJump
local intermediateJump1
local intermediateJump2
local intermediateJump3
local intermediateJump4
local CheckLeftInt
local CheckLeftRightInt
local JumpUp
StartTake2:           
                      mov ah,09h
                      mov dx, offset ShipLeft
                      int 21h
			mov ah,0
			int 16h
                      mov cl,ah
CheckNotPlace:  
		      push ax
		      push bx
		      mov al,GridSize
	              mov bl,GridSize
                      mul bl
                      sub al,GridSize
                      mov CheckDownTwo,al
		      pop bx
		      pop ax
                      mov bl,P12Ship[0]
		      push dx
		      mov dl,P12Ship[0]
                      cmp dl,CheckDownTwo
		      pop dx
                      jb CheckDown2
	              push dx
	              mov dl,P12Ship[0]
	              cmp dl,GridSize
	              pop dx
                      ja JumpUp
intermediateJump4:
			jmp StartTake2  
JumpUp: 
		      push dx
	              mov dl,P12Ship[0]
	              cmp dl,GridSize
	              pop dx
                      ja CheckUp2
		      jmp CheckLeftRightInt
CheckDown2:               
                      cmp cl,1Fh
                      jnz JumpUp
                      push ax     
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop3
	              cmp al,P13Ship[0]
		      jz intermediateJmpPop3
		      cmp al, P13Ship[2]
                      jz intermediateJmpPop3
		      add al,GridSize 
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop3
		      cmp al,P13Ship[0]
		      jz intermediateJmpPop3
		      cmp al,P13Ship[2]
		      jz intermediateJmpPop3
		      mov ah,P12Ship[0]
		      add ah,GridSize 
		      mov P12Ship[1],ah
		      pop ax
                      jmp checkLeftRight2
intermediateJump3:
			jmp intermediateJump4
intermediateJmpPop3:
					pop ax
					jmp intermediateJump4
CheckLeftRightInt: 
				jmp checkLeftRight2
CheckUp2:                       
                      cmp cl,11h
                      jnz checkLeftRight2
		      push ax     
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop2
		      cmp al, P13Ship[2]
                      jz intermediateJmpPop2
                      cmp al,P13Ship[0]
		      jz intermediateJmpPop2
		      sub al,GridSize 
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop2
		      cmp al,P13Ship[2]
		      jz intermediateJmpPop2
                      cmp al,P13Ship[0]
		      jz intermediateJmpPop2
		      mov ah,P12Ship[0]
		      sub ah,GridSize 
		      mov P12Ship[1],ah
		      pop ax
                      jmp checkLeftRight2
intermediateJump2:
			jmp intermediateJump3
intermediateJmpPop2:
					pop ax
					jmp intermediateJump3
checkLeftRight2:
                      mov al,P12Ship[0]
                      mov ah,0 
                      jmp checkRight2
intermediateJump1:
			jmp intermediateJump2
CheckRight2:           
		      push bx
		      mov bl,gridsize
		      div bl
		      cmp ah,0
			  pop bx
		      je CheckLeft2
                      cmp cl,20h
                      jnz Pump2
		     push ax     
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop
		      cmp al, P13Ship[2]
                      jz intermediateJmpPop
                      cmp al,P13Ship[0]
		      jz intermediateJmpPop
		      add al,1
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop
		      cmp al,P13Ship[2]
		      jz intermediateJmpPop
                      cmp al,P13Ship[0]
		      jz intermediateJmpPop
		      mov ah,P12Ship[0]
		      add ah,1
		      mov P12Ship[1],ah
		      pop ax
Pump2:		      cmp ah,0
		      ja CheckLeft2
		      jmp MiddleWare2
intermediateJmpPop:
				pop ax
				jmp intermediateJump1
intermediateJump:
			jmp intermediateJump1
	
CheckLeft2:       
	      push bx
		      mov al,P12Ship[0]
		      mov ah,0
		      mov bl,gridsize
		      div bl
		      cmp ah,1
			  pop bx  
		      je MiddleWare2 
              cmp cl,1Eh
              jnz MiddleWare2
              push ax    
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop
		      cmp al, P13Ship[2]
              jz intermediateJmpPop
              cmp al,P13Ship[0]
		      jz intermediateJmpPop
		      sub al,1
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop
		      cmp al,P13Ship[2]
		      jz intermediateJmpPop
              cmp al,P13Ship[0]
		      jz intermediateJmpPop
		      mov ah,P12Ship[0]
		      sub ah,1
		      mov P12Ship[1],ah
		      pop ax
MiddleWare2:                 
                      cmp P12Ship[1],99h
                      jz intermediateJump
                      jnz Fin3
Fin3:                  
			mov CheckDownTwo,00h
			mov CheckDownThree,00h
			mov CheckUpThree,00h
			mov tempVar2,00h 
			mov tempVar,00h 
ENDM TakeDirections2

DestroyPiece MACRO Num, PNum
local DropShip
local DropEmpty
local Endit
            push ax 
            push bx  
            push DI
			PUSH SI
			MOV SI, 2
            mov DI,offset DestroyedArr1
            mov al,PNum
            mov ah,0
            mov bl,25
            mul al
            mov bl,Num
            mov bh,00h
            add bl,al
            mov ax,0
            mov al,[bx+DI]
            cmp al,0
            je DropEmpty
            cmp al,1
            je DropShip 
            ja EndIt
DropShip:   
            mov [bx+DI],si
            jmp EndIt
			MOV SI, 3
DropEmpty:  mov [bx+DI],SI
EndIt:  POP SI
		pop DI
	    pop bx
	    pop ax

ENDM DestroyPiece
            
editShip MACRO  
		            push ax
                            add bl, [DI]   	
		            ;mov [bx],1
			    mov al, 1
		           mov [bx], al	
		            sub bl, [DI]  
		            inc DI
	                    add bl, [DI]   
		            mov [bx],al
		            sub bl, [DI] 
		            inc DI
		            add bl, [DI]   
		            mov [bx],al
		            sub bl, [DI]  
		            inc DI
                    add bl, [DI]   
		            mov [bx],al
		            sub bl, [DI] 
		            inc DI
	                add bl, [DI]   
		            mov [bx],al
					POP ax
		            pop DI
		            pop bx 
ENDM editship               
             
