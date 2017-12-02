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
                        cmp bh,0Dh  ;Check if the user's second input is an Enter
                        jz Toolate   ; if not complete and jump to the double digit parser
                        mov ah,07
                        int 21h 
			jmp doublekill
TooLate:
                        cmp al,0Dh
                        jnz EnterRight ; if the first input is also an enter, query again for input
			sub bl,48
			JS EnterRight ; if the number is less than 48, more than 9 or 0 it will query again for input
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
			cmp bl,96  ;if the input is 00 it will query again for input
			pop bx
			jz EnterRight
			sub bl,48
			JS EnterRight
			sub bh,48  
			JS EnterRight ; if any of the numbers are less than 48 ascii jump
                        mov al,bl
                        mov ah,10
                        mul ah
                        add al,bh 
			push bx
			mov bl,Num 
			cmp bl,4 ; jump to different labels for different levels
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
                        mov dx, offset RightMsg ; query user again for input
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
		      add al,GridSize ; for the 3 place ship, you need the ship to start at the third line (2* grid size) to have a valid up direction
		      mov CheckUpThree, al
		      pop ax
		      push dx
		      mov dl,P13Ship[0]
                      cmp dl,CheckUpThree  ; if the ship has a valid up position check it, if not check down
		      pop dx
                      ja CheckUp 
CheckDown:               
                      cmp cl,1Fh ; if the input is not down, jmp
                      jnz intmp2
                      push ax
                      mov al,P13Ship ;if it is then we input the number in pship[0] and its grid size multiples in 1 and 2
		      add al,GridSize 
                      mov P13Ship[1],al
                      add al,GridSize 
                      mov P13Ship[2],al
		      pop ax
                      jmp CheckLeftRight
intjump1:
				jmp starttake
intmp2:
		      push ax ;if the input comes from the check down but has a valid check up position, EX 1 2 3 4 5, 3 has both up and down available to it
 		      mov al,GridSize
		      add al,GridSize
		      mov CheckUpThree, al ;check for a valid up position
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
                      mov al,P13Ship ;again input the number in the zero position and its gridsize multiples(negative here as we are going up not down)
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
		      mov bl, gridsize ; To check right i divid by the grid size and then check if its zero or grid size minus one, if its not i add the shi
		      div bl ; for example 1 2 3 4 5 will be 1 2 3 4 0 , i can't have a 3 place ship in 4 or 0 positions
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
                      jnz MiddleWare ;i then add the ship by getting the input in 0 position and +1 for each other position
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
                      mov al,P13Ship[0]  ; To check left i divide by the grid size and then check if its one or two ,if its not i add the ship
                      mov ah,0 
		      mov bl,gridsize ; for example 1 2 3 4 5 gets 1 2 3 4 0, i don't want 1 or 2 
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
                      mov P13Ship[1],al ; add ship by input and then minus one
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
                      sub al,GridSize ; it needs to be one line above the last line to be able to be put in the direction down
                      mov CheckDownTwo,al
		      pop bx
		      pop ax
                      mov bl,P12Ship[0]
		      push dx
		      mov dl,P12Ship[0]
                      cmp dl,CheckDownTwo ; if it is then check for down
		      pop dx
                      jb CheckDown2
	              push dx
	              mov dl,P12Ship[0] ; if its above grid size (first line) then it can be put up, jump for check up
	              cmp dl,GridSize
	              pop dx
                      ja JumpUp
intermediateJump4:
			jmp StartTake2  
JumpUp: 
		      push dx
	              mov dl,P12Ship[0] ; check for up as above
	              cmp dl,GridSize
	              pop dx
                      ja CheckUp2
		      jmp CheckLeftRightInt
CheckDown2:               
                      cmp cl,1Fh ; if the position is valid but no input check for up, as some positions are valid for both directions
                      jnz JumpUp
                      push ax     
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop3 ; We needed another intermediatejmp here as it needed to pop the AX
	              cmp al,P13Ship[0]
		      jz intermediateJmpPop3 ; here we are checking for conflicts between ship 1 and 2, if there's not we input the second ship
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
                      cmp cl,11h ; if not up or down check left or right
                      jnz checkLeftRight2
		      push ax     
		      mov al,P12Ship[0]
		      cmp al,P13Ship[1]
		      jz intermediateJmpPop2 ; same thing here
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
		      push bx ; in here we're going to divide and check if its not zero, if it is not then it can be put right
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
		      jz intermediateJmpPop ; same thing above
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
Pump2:		      cmp ah,0 ; jump to check left
		      ja CheckLeft2
		      jmp MiddleWare2
intermediateJmpPop:
				pop ax
				jmp intermediateJump1
intermediateJump:
			jmp intermediateJump1
	
CheckLeft2:       
	      push bx
		      mov al,P12Ship[0] ; if its valid then continue
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

            
editShip MACRO  
		            push ax ; this functions works by accessing the destroyedarr array and putting 1s in the places where there are ships
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
             
