[org 0x0100]
jmp start
%include "two.asm"
%include "file.asm"
;-----------------------------------------------------------------------------------------------------------------
initialscreen:
                pusha
                
                call clearscreen
                
                mov ah, 01h
                mov ch, 00100000b
                int 0x10

                mov ax,0xb800
                mov es,ax
                
                mov ah,02h
                mov bh,00h
                mov dl,08                               
                mov dh,13
                int 10h
                mov dx, inst1 						    
                mov ah, 9 								
                int 0x21
                
                cmp byte[cs:uplevel], 1
                je noinput

                cmp byte[cs:restart], 1
                je noinput

                call getinput
        noinput:                
                call clearscreen
                
                mov ah,02h
                mov bh,00h
                mov dl,10                              
                mov dh,24
                int 10h
                mov dx, inst9 						    
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,25                               
                mov dh,05
                int 10h
                mov dx, inst6 						  
                mov ah, 9 								
                int 0x21

                
                mov ah,02h
                mov bh,00h
                mov dl,34                               
                mov dh,9
                int 10h
                mov dx, inst7 						   
                mov ah, 9 								
                int 0x21
                

                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,11
                int 10h
                mov dx, inst15 						   
                mov ah, 9 								
                int 0x21

                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,12
                int 10h
                mov dx, inst10 						   
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,13
                int 10h
                mov dx, inst11 						    
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,14
                int 10h
                mov dx, inst12 						    
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,15
                int 10h
                mov dx, inst13 						   
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,16
                int 10h
                mov dx, inst14 						   
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,17
                int 10h
                mov dx, inst3						   
                mov ah, 9 								
                int 0x21
                
                mov ah,02h
                mov bh,00h
                mov dl,20                               
                mov dh,18
                int 10h
                mov dx, inst4 						    
                mov ah, 9 								
                int 0x21
                
                mov di,2784
                push di
                mov di,word[cs:giventime]
                push di
                call printnum
                
                mov di,2976
                push di
                mov di,word[cs:diamondremain]
                push di
                call printnum
                
                mov di,1878
                push di
                mov di,word[cs:level]
                push di
                call printnum


                mov di,1824
                push di
                mov di,word[cs:levels]
                push di
                call printnum

                mov di,3880
                mov ax,0x2002
                mov word[es:di], ax

                mov di,3896
                mov ax,0x0EDB
                mov word[es:di], ax

                mov di,3918
                mov ax,0xC009
                mov word[es:di], ax

                mov di,3938
                mov ax,0x507f
                mov word[es:di], ax

                mov di,3954
                mov ax,0x07B1
                mov word[es:di], ax

                mov di,3976
                mov ax,0x3f04
                mov word[es:di], ax
                                
                call loadingscreen
                
                popa
                ret
;---------------------------------------------------------------------------------------------------------------
loadingscreen:
                pusha
                
                mov ax,0xb800
                mov es,ax
                
                mov al,00
                mov ah,02h
                mov bh,00h
                mov dl,34                              
                mov dh,20
                int 10h
                mov dx, inst8 						   
                mov ah, 9 								
                int 0x21
                
                mov cx,20
                mov di,3420
                loop4:
                 mov word[es:di],0x7020
                 add di,2
                 call delay3
                 call delay3
                loop loop4

                mov ah,02h
                mov bh,00h
                mov dl,52                               
                mov dh,0
                int 10h
                mov dx, inst5 						    
                mov ah, 9 								
                int 0x21

                mov cx,3
                mov di,156
                mov ah,0x07
                loop5:
                 mov al,cl
                 add al,0x30
                 mov word[es:di],ax
                 call delay3
                 call delay3
                 call delay3
                 call delay3
                loop loop5
                
                popa
                ret
;---------------------------------------------------------------------------------------------------------------
sound:
                pusha
                mov al,00
                mov ah,02h
                mov bh,00h
                mov dl,20                              
                mov dh,0
                int 0x10        
                mov ah, 0x0E  
                mov al, 7     
                int 0x10    

                popa
                ret

;-----------------------------------------------------------------------------------------------------------------------
counter:
                pusha
                
                mov cx,1600
                mov di,0
                mov si,buffer
                mov ax,0
                mov bx,80
                
                countloop:
                 mov dh, byte[cs:si]
                 cmp dh,'D'
                 jne nodiamond
                 cmp ax, bx
                 jle incer
                 mov di,si
                 sub di,bx
                 mov dl, byte[cs:di]
                 cmp dl,'B'
                 je nodiamond
                incer:
                 inc word[cs:Diamonds]
                nodiamond:
                 inc si
                 inc ax
                 cmp ax,cx
                jl countloop
                
                popa 
                ret
;-----------------------------------------------------------------------------------------------------------------
getinput:
                pusha
        getagain:
                mov ah,02h
                mov bh,00h
                mov dl,08                               
                mov dh,13
                int 10h
                mov dx, inst1 						   
                mov ah, 9 								
                int 0x21        
                
                mov ah,0 
                int 0x16
                
                cmp al,0x31
                jne two
                mov word[cs:diff], 1
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty1]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
                jmp taken
        two:
                cmp al,0x32
                jne three
                mov word[cs:diff], 2
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty2]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
                jmp taken
        three:
                cmp al,0x33
                jne notaken
                mov word[cs:diff], 3
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty3]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
                jmp taken
        notaken:
                mov ah,02h
                mov bh,00h
                mov dl,26                               
                mov dh,05
                int 10h
                mov dx, inst2 						    
                mov ah, 9 								
                int 0x21
                jmp getagain
        taken:
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
calculatetime:
                pusha
        
                cmp word[cs:diff], 1
                jne two2
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty1]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
                jmp taken2
        two2:
                cmp word[cs:diff], 2
                jne three2
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty2]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
                jmp taken2
        three2:
                cmp word[cs:diff], 3
                jne taken2
                mov ax,word[cs:Diamonds]
                mov bx,ax
                shr ax,1
                shr bx,2
                add ax,bx
                mov word[cs:diamondremain], ax
                mov cx,word[cs:difficulty3]
                mul cx
                mov cx,18
                div cx
                mov ah,0
                mov word[cs:giventime],ax
        taken2:
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
hookkb:
                pusha
                xor ax,ax
                mov es,ax
                
                mov ax, [es:9*4]
                mov [cs:oldisr], ax								
                mov ax, [es:9*4+2]
                mov [cs:oldisr+2], ax
                
                mov ax, [es:8*4]
                mov [cs:oldtimer], ax								
                mov ax, [es:8*4+2]
                mov [cs:oldtimer+2], ax
                
                cli 											
                mov word [es:9*4], kbisr						
                mov [es:9*4+2], cs
                mov word [es:8*4], timer
                mov [es:8*4+2], cs	
                sti
                
                popa
                ret
;----------------------------------------------------------------------------------------------------------------
unhookandend:
                pusha
                
                mov ah, 01h
                mov ch, 00001111b
                int 0x10 
                
                xor ax,ax
                mov es,ax
                
                mov ax, [cs:oldisr]					         
                mov bx, [cs:oldisr+2]							
                
                mov cx, [cs:oldtimer]
                mov dx, [cs:oldtimer+2]
                
                cli										
                mov [es:9*4], ax						    
                mov [es:9*4+2], bx
                mov [es:8*4], cx
                mov [es:8*4+2], dx							
                sti
                
                popa
                ret

;-------------------------------------------------------------------------------------------------------------------
kbisr:
                pusha
                mov ax,0xb800
                mov es,ax
                
                mov di,[cs:position]
                mov word[cs:oldposition],di
                
                in  al, 0x60
                
                cmp byte[cs:stopper], 1
                je n41
;=================================================================================================================
                cmp al, 0x4B
                jne n1

                sub di,2
                cmp di,word[cs:target]
                jne notarget1

                mov dx,word[cs:score]
                cmp dx,word[cs:diamondremain]
                jl makesound0

        notarget1:
                cmp word[es:di], 0x0EDB
                je makesound0
                
                cmp word[es:di], 0xC009
                je makesound0
                
                mov si,di
                sub si,160
                mov bx, word[es:di]
                mov word[es:di], 0x2002
                cmp word[es:si], 0xC009
                jne notend1
                
                dec word[cs:lives]
                call printscore

                cmp word[cs:lives], 0
                je endgame1

        notend1:
                mov word[cs:position], di
                add di,2
                mov word[es:di], 0x0720
                jmp nomatch1

                ;----------------------------;
                 n41: jmp n42
                 makesound0: jmp makesound1
                ;----------------------------;
;======================================================================================================================
        n1:      
                cmp al, 0x4D
                jne n2
                
                
                add di,2
                cmp di,word[cs:target]
                jne notarget2
                
                mov dx,word[cs:score]
                cmp dx,word[cs:diamondremain]
                jl makesound1

        notarget2:
                cmp word[es:di], 0x0EDB
                je makesound1
                
                cmp word[es:di], 0xC009
                je makesound1
                
                mov si,di
                sub si,160
                mov bx, word[es:di]
                mov word[es:di], 0x2002
                cmp word[es:si], 0xC009
                jne notend2
                
                dec word[cs:lives]
                call printscore
                
                cmp word[cs:lives], 0
                je endgame1

        notend2:
                mov word[cs:position], di
                sub di,2
                mov word[es:di], 0x0720
                jmp nomatch1

                ;---------------------------;
                 makesound1: jmp makesound
                 endgame1: jmp endgame
                 nomatch1: jmp nomatch
                 n42: jmp n4
                ;---------------------------;
;====================================================================================================================
        n2:      
                cmp al, 0x48
                jne n3

                sub di,160
                cmp di,word[cs:target]
                jne notarget3
                
                mov dx,word[cs:score]
                cmp dx,word[cs:diamondremain]
                jl makesound02

        notarget3:
                cmp word[es:di], 0x0EDB
                je makesound02
                
                cmp word[es:di], 0xC009
                je makesound02 
                
                mov si,di
                sub si,160
                mov bx, word[es:di]
                mov word[es:di], 0x2002
                cmp word[es:si], 0xC009
                jne notend3
                
                dec word[cs:lives]
                call printscore
                
                cmp word[cs:lives], 0
                je endgame2

        notend3:
                mov word[cs:position], di
                add di,160
                mov word[es:di], 0x0720
                jmp nomatch
                
                ;-----------------------------;
                 makesound02: jmp makesound2
                ;------------------------------;
;====================================================================================================================
        n3:      
                cmp al, 0x50
                jne n4

                add di,160
                cmp di,word[cs:target]
                jne notarget4
                
                mov dx,word[cs:score]
                cmp dx,word[cs:diamondremain]
                jl makesound2

        notarget4:
                cmp word[es:di], 0x0EDB
                je makesound2
                
                cmp word[es:di], 0xC009
                je makesound2 
                
                mov si,di
                sub si,160
                mov bx, word[es:di]
                mov word[es:di], 0x2002
                cmp word[es:si], 0xC009
                je endgame2
                
                mov word[cs:position], di
                sub di,160
                mov word[es:di], 0x0720
                jmp nomatch

                ;---------------------------;
                 makesound2: jmp makesound
                 endgame2: jmp endgame
                ;--------------------------;
;===================================================================================================================
        n4:
                cmp al, 1
                jne n5
                
                mov byte[cs:ter],1
                jmp nomatch

;====================================================================================================================
        n5:      
                cmp al, 57
                jne n6
                
                mov byte[cs:ter], 1
                mov byte[cs:restart], 1
                mov byte[cs:stopper], 1
                jmp nomatch
;=====================================================================================================================
        n6:     
                cmp al, 42
                jne nomatch
                cmp byte[cs:won], 1
                jne nomatch
                mov ax, word[cs:level]
                cmp ax, word[cs:levels]
                jge cannotgo
                mov byte[cs:stopper], 1
                mov byte[cs:ter], 1
                mov byte[cs:restart], 1
                mov byte[cs:uplevel], 1
                jmp nomatch
;=====================================================================================================================
        cannotgo:
                mov ax,2284
                push ax
                mov ax, notgo+1
                push ax
                mov ah,0
                mov al, byte[cs:notgo]
                push ax
                call printstr2
                jmp nomatch
;=====================================================================================================================
        makesound:
                call sound
                jmp nomatch
;======================================================================================================================
        endgame: 
                mov byte[cs:stopper], 1
                mov byte[cs:timeup], 1
                mov di,[cs:oldposition]
                mov word[es:di], 0x0720
                
                mov ax,2132
                push ax
                mov ax, crush+1
                push ax
                mov ah,0
                mov al, byte[cs:crush]
                push ax
                call printstr
                
                jmp popping
;=========================================================================================================================
        nomatch:
                mov ax,word[cs:position]
                
                cmp word[cs:target],ax
                jne nowin
                
                mov byte[cs:won], 1
                mov byte[cs:stopper], 1
                
                mov ax,2126
                push ax
                mov ax, win+1
                push ax
                mov ah,0
                mov al, byte[cs:win]
                push ax
                call printstr
                
                mov word[cs:position], -1
;====================================================================================================================
        nowin:   
                cmp bx,0x3f04
                jne popping
                
                inc word[cs:score]
                call printscore
;====================================================================================================================
        popping:         
                popa
                jmp far [cs:oldisr]
;----------------------------------------------------------------------------------------------------------------
timer:
                pusha
                cmp word[cs:timeup], 1
                je skipit
                
                mov ax,word[cs:tickcount]
                cmp ax,18
                jl nosecond
                
                mov word[cs:tickcount], 0
                dec word[cs:remain]
                cmp byte[cs:stopper],1
                je skipit
                
                call printtime
;=======================================================================================================================
        nosecond:
                inc word[cs:tickcount]
;======================================================================================================================= 
        skipit:
                mov al, 0x20
                out 0x20, al
                popa
                iret
;-----------------------------------------------------------------------------------------------------------------
newlevel:
                pusha
                
                call clearscreen
                call clearscreen
                call allzero
                
                inc word[cs:level]
                mov cx, word[cs:level]
                mov ch, 0
                add cl, 0x30
                mov byte[cs:constant+4], cl
                sub byte[cs:difficulty1], 3
                sub byte[cs:difficulty2], 3
                sub byte[cs:difficulty3], 3
                
                call openfile2
                call counter
                call calculatetime
                call initialscreen
                call createtable
                
                mov byte[cs:uplevel], 0
                mov byte[cs:stopper], 0
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
zerolevel:
                pusha
                call clearscreen
                call clearscreen
                
                mov cl, 0x31
                
                mov byte[cs:constant+4], cl
                mov ax, word[cs:storedifficulty1]
                mov word[cs:difficulty1], ax
                mov ax, word[cs:storedifficulty2]
                mov word[cs:difficulty2], ax
                mov ax, word[cs:storedifficulty3]
                mov word[cs:difficulty3], ax
                
                call openfile2
                call counter
                call calculatetime
                call initialscreen
                call createtable
                
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
restarting: 
                pusha
                mov byte[cs:score], 0
                mov word[cs:level], 1
                
                cmp byte[cs:otherfile], 1
                je iszero
                
                call allzero
                call zerolevel
                jmp jump1
        iszero: 
                call openfile
                call allzero
                call counter
                call calculatetime
                call initialscreen
                call createtable
                
        jump1:
                mov byte[cs:restart], 0
                mov byte[cs:stopper], 0
                popa 
                ret
;----------------------------------------------------------------------------------------------------------------
allzero:
                pusha  
                mov word[cs:Diamonds], 0
                mov byte[cs:lost], 0
                mov byte[cs:won], 0
                
                mov byte[cs:ter], 0
                
                mov byte[cs:timeup], 0
                mov byte[cs:lives], 2
                mov byte[cs:second], 0
                
                mov ax, word[cs:giventime]
                mov word[cs:remain], ax
                call printscore
                
                popa
                ret 
;-----------------------------------------------------------------------------------------------------------------
start:
                call inputfilename
                
                cmp byte[cs:ter],1
                je nextestestest
                
                call counter
                call calculatetime
                call initialscreen
        table:
                call delay2
                call createtable

                cmp byte[cs:ter2],1
                jne notfaulty
                
                mov di,2084
                push di
                mov di, faulty+1
                push di
                mov ah,0
                mov al,byte[cs:faulty]
                push ax
                call printstr2
                
                mov di,2278
                push di
                mov di, faulty2+1
                push di
                mov ah,0
                mov al,byte[cs:faulty2]
                push ax
                call printstr2
                
                mov ah,00h
                int 0x16
                
                call clearscreen
                jmp nextestestest
                
                cmp byte[cs:restart], 1
                je nohook

        notfaulty:
                call hookkb
                call allzero

        nohook:
                call delay2

        infinite:
                cmp byte[cs:ter], 1
                jne infinite
                
                cmp byte[cs:restart], 1
                jne clear
                
                cmp byte[cs:uplevel], 1
                jne nolevelup

                call delay3

                call newlevel
                
                jmp nohook

        ;--------------------------------
         nextestestest: jmp nextestest
        ;--------------------------------

        nolevelup:
                call restarting
                jmp nohook

        clear:
                call clearscreen
        nextest:
                call unhookandend

        nextestest
                mov ah, 4ch 
                int 21h 