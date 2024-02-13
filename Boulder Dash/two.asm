[org 0x0100]
;-------------------------------------------------------------------------------------------------------------
inst1:  db 'Choose Your Difficulty Level (From 1 to 3, 1 is Easiest): $'
inst2:  db 'Entered Wrong Input, Enter Again$'
inst3:  db '-> You have     Seconds to Complete      $'
inst4:  db '-> You have to Pick Atleast    Diamonds  $'
inst5:  db 'Your Game Starts in $'
inst6:  db 'Welcome to Rockford Challenges$'
inst7:  db 'Instructions:$'
inst8:  db 'LOADING...$'
inst9:  db 'RockFord:   Wall:   Boulder:   Target:   Dirt:   Diamond:   $'
inst10: db '-> RockFord Controlled by Arrow Keys    $'
inst11: db '-> Avoid Walking Under Boulder          $' 
inst12: db '-> RockFord has 2 lives for each level  $'
inst13: db '-> Collect Required Number of Diamonds  $'
inst14: db '-> Move through Dirt                    $'
inst15: db '-> You have   Levels, - Current Level:  $'
dash:   db '> > > Boulder Dash Game ////COAL COURSE PROJECT/////////// < < <$'
time:   db 'Time Left:$'   
line2:  db 'Move -> Arrow Keys   New Level -> LShift      Restart -> Space       Exit -> Esc$'                    
line3:  db 'Score:          Diamond Remaining:                 Lives:                Level:$'
error1: db 'Wrong Name Input Run File Again$'
error2: db 'Insufficient Or Extra Data in file (Wrong File)$'
error3: db 'File Not Opening (Wrong File Name or Not Exists)$'
crush:  db 35,'Boulder Crash!!!!!! Game Over!!! :('
win:    db 42,'You have made it to the Target! You Won :)'
timeupline: db 40,'You Failed :( Time is Up Restart or Exit'
faulty: db 77,'Your Cave File Contains Unwanted Character or More than one Targets or Starts$'
faulty2: db 42,'You Cannot Proceed!! Press Any key to Exit$'
notgo: db 45,'You Cannot Go Further as it is the last level'
opennings:  db 'Enter filename: Or Press Enter To Load Cave1.txt$'
comparable: db '.txt' 
constant:   db 'cave1.txt',0 
buffer: 
 times 1602 db 0
handle:     dw 0
uplevel: db 0
diff: dw 0 
otherfile: db 0
difficulty1: dw 40
difficulty2: dw 35
difficulty3: dw 30
storedifficulty1: dw 40
storedifficulty2: dw 35
storedifficulty3: dw 30
bytesread:  dw 0 
level:      dw 1
levels:     dw 3
score:      dw 0
remain:     dw 0
lives:      dw 2
tickcount:  dw 0
second:     dw 0
file:	    db 40 								                
	    db 0 									
   times 40 db 0 									        
ter:         db 0
ter2:        db 0
restart:     db 0
stopper:     db 0
won:         db 0
lost:        db 0
position:    dw 0
target:      dw 0
oldposition: dw 0
oldisr:      dd 0
oldtimer:    dd 0
oneplayer:   db 0
onetarget:   db 0
diamonds:    dw 0
giventime:   dw 0
Diamonds:    dw 0
diamondremain: dw 0
timeup:      db 0
;--------------------------------------------------------------------------------------------------------------
clearscreen:    
                push bp                 
                mov bp,sp              
                push es                 
                push di 
                push ax
                push cx
                mov ax,0xb800         
                mov es, ax 
                mov ax,0x0720 
                mov di,0
                mov cx,2000             
                cld
                 rep stosw
                pop cx
                pop ax
                pop di
                pop es
                pop bp
                ret 
;---------------------------------------------------------------------------------------------------------------
 printstr: 
                push bp 
                mov bp, sp 
                push es 
                push ax 
                push cx 
                push si 
                push di 
                mov ax, 0xb800 
                mov es, ax 
                mov di, [bp+8] 
                mov si, [bp+6] 
                mov cx, [bp+4] 
                mov ah, 0x87 
                nextchar: 
                 mov al, [si]
                 mov [es:di], ax 
                 add di, 2  
                 add si, 1
                loop nextchar
                pop di 
                pop si 
                pop cx 
                pop ax 
                pop es 
                pop bp 
                ret 6 
;---------------------------------------------------------------------------------------------------------------
 printstr2: 
                push bp 
                mov bp, sp 
                push es 
                push ax 
                push cx 
                push si 
                push di 
                mov ax, 0xb800 
                mov es, ax 
                mov di, [bp+8] 
                mov si, [bp+6] 
                mov cx, [bp+4] 
                mov ah, 0x07 
                nextchar2: 
                 mov al, [si]
                 mov [es:di], ax 
                 add di, 2  
                 add si, 1
                loop nextchar2
                pop di 
                pop si 
                pop cx 
                pop ax 
                pop es 
                pop bp 
                ret 6 
;----------------------------------------------------------------------------------------------------------------
printnum: 
                push bp 
                mov bp, sp 
                push es 
                push ax 
                push bx 
                push cx 
                push dx 
                push di 
                       
                mov ax, 0xb800 
                mov es, ax 
                mov ax, [bp+4] 
                mov bx, 10  
                mov cx, 0
                    
                nextdigit: 
                 mov dx, 0 
                 div bx 
                 add dl, 0x30
                 push dx 
                 inc cx 
                 cmp ax, 0 
                jnz nextdigit 
                mov di, [bp+6] 
                
                nextpos: 
                 pop dx
                 mov dh, 0x07 
                 mov [es:di], dx 
                 add di, 2
                loop nextpos
                pop di 
                pop dx 
                pop cx 
                pop bx 
                pop ax 
                pop es 
                pop bp 
                ret 4
;-----------------------------------------------------------------------------------------------------------------------------
printscore:
                pusha
                mov ah,02h
                mov bh,00h
                mov dl,00h                             
                mov dh,24
                int 10h
                mov dx, line3 						  
                mov ah, 9 								
                int 0x21

                mov di,3852
                push di
                mov ax,[cs:score]
                push ax
                call printnum

                mov di,3998
                push di
                mov ax,[cs:level]
                push ax
                call printnum

                mov di, 3908
                push di
                mov ax,[cs:score]
                mov bx,[cs:diamondremain]
                sub bx,ax
                cmp bx,0
                jge mext
                mov bx,0
        mext:    
                
                push bx
                call printnum

                mov di,3954
                push di
                mov ax,[cs:lives]
                push ax
                call printnum

                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
printtime:
                pusha
                mov ax,0xb800
                mov es,ax
                
                mov ah,02h
                mov bh,00h
                mov dl,68                               
                mov dh,00
                int 10h
                mov dx, time 						    
                mov ah, 9 								
                int 0x21
                
                mov bx,word[cs:remain]
                cmp bx,0
                jne timeisleft
                
                mov byte[cs:timeup], 1
                mov byte[cs:stopper], 1
                
                mov di,2120
                push di
                mov ax, timeupline+1
                push ax
                mov ah,0 
                mov al,byte[cs:timeupline]
                push ax
                call printstr
        timeisleft:
                
                mov di,156
                push di
                mov di,[cs:remain]
                push di
                call printnum
                
                cmp di,10
                jge printzero
                
                mov si,158
                mov word[es:si], 0x0720
        printzero:
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
faultytable:
                pusha
                
                mov ax,2084
                push ax
                mov ax,faulty+1
                push ax
                mov ah,0
                mov al,byte[cs:faulty]
                push ax
                call printstr

                mov ax,1964
                push ax
                mov ax,faulty2+1
                push ax
                mov ah,0
                mov al,byte[cs:faulty2]
                push ax
                call printstr
                
                call delay
                
                popa
                ret
;----------------------------------------------------------------------------------------------------------------
createtable:
                pusha
                
                call clearscreen
                xor ax,ax
                mov ax,0xb800
                mov es,ax




                mov ah,02h
                mov bh,00h
                mov dl,00                               
                mov dh,00
                int 10h
                mov dx, dash 						  
                mov ah, 9 								
                int 0x21

                mov ah,02h
                mov bh,00h
                mov dl,00                              
                mov dh,01
                int 10h
                mov dx, line2 						   
                mov ah, 9 								
                int 0x21

                mov di,320
                mov ah,0x0e
                mov al,0xdb
                mov cx,80
                cld
                 rep stosw
                mov di,3680
                mov cx,80
                rep stosw

                mov di,478
                mov cx,21
                loop2:
                 mov word[es:di],ax
                 add di,160
                 sub cx,1
                jnz loop2

                mov di,320
                mov cx,21
                loop3:
                 mov word[es:di],ax
                 add di,160
                 sub cx,1
                jnz loop3

                mov cx,1600
                mov si,buffer
                mov di,482
                mainloop:
                 mov bh,[cs:si]
                 cmp bh,'x'
                 jne next
                 
                 mov al,0xB1
                 mov ah,07h
                 jmp prnit
                next:   
                 cmp bh,'R'
                 jne next1
                 cmp byte[cs:oneplayer],1
                 jne first1
                 mov byte[cs:ter2], 1
                first1:
                 mov al,0x02
                 mov ah,20h
                 mov word[cs:position], di
                 mov byte[cs:oneplayer], 1
                 jmp prnit
                next1:  
                 cmp bh,'T'
                 jne next2
                 cmp byte[cs:onetarget],1
                 jne first2
                 mov byte[cs:ter2], 1
                first2:
                 mov al,0x7f
                 mov ah,50h
                 mov word[cs:target], di
                 mov byte[cs:onetarget],1
                 jmp prnit
                next2:  
                 cmp bh,'B'
                 jne next3
                 mov al,0x09
                 mov ah,0xC0
                 jmp prnit
                next3:  
                 cmp bh,'D'
                 jne next4
                 mov al,0x04
                 mov ah,0x3f
                 jmp prnit
                next4:  
                 cmp bh,'W'
                 jne next5
                 mov al,0xdb
                 mov ah,0x0e
                 jmp prnit
                next5:  
                 cmp bh,10
                 jne next6
                 jmp skipall
                next6:  
                 cmp bh,13
                 jne next7
                 jmp skipall
                next7:  
                 mov byte[cs:ter2], 1
                 jmp skipall
                prnit:  
                 mov word[es:di],ax
                skipall:  
                 call delay0
                 add di,2
                 add si,1
                 sub cx,1
                jnz mainloop

                call printscore
                
                popa
                ret

;------------------------------------------------------------------------------------------------------
delay0:          
                push cx
                mov cx, 0x00FF
                looop1:      
                loop looop1
                
		pop cx
		ret
;---------------------------------------------------------------------------------------------------
delay:          
                push cx
                mov cx, 0x00FF
                l1:      
                loop l1
                mov cx, 0xFFFF
                l3:
                loop l3
		pop cx
		ret

;---------------------------------------------------------------------------------------------------
delay2:          
                push cx
                mov cx, 0xFFFF
                loooop1:      loop loooop1
                            mov cx, 0xFFFF
                looop2:      loop looop2
                            mov cx, 0xFFFF
                looop3:      loop looop3
		        pop cx
		        ret
;----------------------------------------------------------------------------------------------------------
delay3:          
                push cx
                mov cx, 0xFFFF
                lp1:      loop lp1
                            mov cx, 0xFFFF
                lp2:      loop lp2
                            mov cx, 0xFFFF
                lp3:      loop lp3
                            mov cx, 0xFFFF
                lp4:      loop lp4
                            mov cx, 0xFFFF
                lp5:      loop lp5
                            mov cx, 0xFFFF
                lp6:      loop lp6
                            mov cx, 0xFFFF
                lp7:      loop lp7

		        pop cx
		        ret
;---------------------------------------------------------------------------------------------------------------------
delay4:

                push cx
                mov cx, 0xFFFF
                g1:     
                       call delay3
                loop g1
                pop cx
                ret
