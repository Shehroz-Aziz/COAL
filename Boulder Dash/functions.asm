[org 0x0100]
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
