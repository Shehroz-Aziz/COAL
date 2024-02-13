[org 0x0100]
jmp main
;---------------------------------------------------------------------------------------------------
;Essential Data.
 opennings:     db 'Enter Your Good Name Here:$'
 input:         db 'Sagacious              '
 scores:        db 'SCORE:$'
 name3:         db 'Press Enter to Continue and Esc to exit'
 rule1:         db 'Welcome To Coin Khayega?$'
 hello:         db 'Hello: $'
 rule2:         db '> Use Arrow keys to Move the Fish$'
 rule3:         db '> 10 Points for Red, 50 for Green$'
 rule4:         db '> Red Coin Removes after 10 seconds$'
 rule5:         db '> Green Coin Removes after 50 seconds$'
 skort:         db 'Press Enter to Continue, Esc to exit'
 devel:         db '            Developers:'
 name1:         db '21L-7521 Sagacious Shehroz Aziz$'
 name2:         db '21L-5388 Minor Hammad Malik$'
 goodbye:       db '              Are You Sure You want to Quit Y/N?....$'
 buffer:	    db 40 								            ; Byte # 0: Max length of buffer
			    db 0 											; Byte # 1: number of characters on return
	   times 40 db 0 									        ; 40 Bytes for actual buffer space
 ;--------------------------------------------------------------------------------------------------------------
 cont:          db 0
 mountainsize:  dw 15
 mountainstart: dw 1440
 skyend:        dw 1600
 boatstart:     dw 2480
 boatwidth:     dw 20 
 boatheight:    dw 4
 chimney:       dw 4
 videobase:     dw 0xb800
 fish:          dw 0x673c
 oldisr:        dd 0
 oldtimer:      dd 0											; space for saving old isr
 exit:          db 0
 fishlocation:  dw 3600
 samundar:      dw 0x977E
 tick:          db 0
 stop:          db 0
 tasks:         db 2
 frequency:     db 3
 greentick:     db 0
 redtick:       db 0
 greenlife:     db 90
 redlife:       db 180
 redplace:      dw 3998
 greenplace:    dw 3998
 score:         dw 0000
 random1:       dw 0000
 random2:       dw 0000
 oldspace:      dw 0000
 exicution:     db 0000
 gotten:        db 0000
 ter:           dw 00000
 ;-------------------------------------------------------------------------------------------------------------
 pcb:	        dw 0, 0, 0, 0, 0 ; task0 regs[cs:pcb + 0]                   ;ax,bx,ip,cs,flags,bx storage area
                dw 0, 0, 0, 0, 0 ; task1 regs start at [cs:pcb + 10]
                dw 0, 0, 0, 0, 0 ; task2 regs start at [cs:pcb + 20]
 current:	    db 0 ; index of current task
 ;-------------------------------------------------------------------------------------------------------------
 ;Tone Frequency
 stor:          dw 0 
;---------------------------------------------------------------------------------------------------
newmainstart:
        pusha
        mov ax, 0x000D      ; set 320x200 graphics mode
        int 0x10            ; bios video services
        mov ax, 0x0C04      ; put pixel in red color
        xor bx, bx      ; page number 0
        mov cx, 240     ;x position 240
        mov dx, 000     ;y position 200
        mov bx, 80
        l112:
                push cx
                push dx
                push bx
                l111:     
                        int 0x10        ; bios video services
                        inc cx          ; decrease y position
                        dec bx
                jnz l111                ; decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc cx
                inc dx
                dec bx
        jnz l112
        mov cx, 000 ; x position 000
        mov dx, 120 ; y position 120
        mov bx, 1
        l114:
                push cx
                push dx
                push bx
                l113:     
                        int 0x10 ;bios video services
                        inc cx   ;decrease y position
                        dec bx
                jnz l113         ;decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc dx
                inc bx
                cmp bx,81
        jne l114
        mov cx, 100 ; x position 100
        mov dx, 180 ; y position 180
        mov bx, 200
        mov di, 2  ;2 lines
        l116:
                push cx
                push dx
                push bx
                l115:     
                        int 0x10 ; bios video services
                        inc cx ; decrease y position
                        dec bx
                jnz l115 ; decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc dx
                dec di
        jnz l116
        mov ax, 0x0C07 
        mov cx, 110     ; x position 110
        mov dx, 190     ; y position 190
        mov bx, 180
        mov di, 2 
        l118:
                push cx
                push dx
                push bx
                l117:     
                        int 0x10 ; bios video services
                        inc cx ; decrease y position
                        dec bx
                jnz l117 ; decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc dx
                dec di
        jnz l118
        mov ax, 0x0C04 ; put pixel in white color
        mov cx, 10 ; x position 10
        mov dx, 20 ; y position 20
        mov bx, 200
        mov di, 2 
        l1110:
                push cx
                push dx
                push bx
                l119:     
                        int 0x10 ; bios video services
                        inc cx ; decrease y position
                        dec bx
                jnz l119 ; decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc dx
                dec di
        jnz l1110
        mov ax, 0x0C07 ; put pixel in white color
        mov cx, 20 ; x position 20
        mov dx, 30 ; y position 30
        mov bx, 180
        mov di, 2 
        l1112:
                push cx
                push dx
                push bx
                l1111:     
                        int 0x10 ; bios video services
                        inc cx ; decrease y position
                        dec bx
                jnz l1111 ; decrease x position and repeat
                pop bx
                pop dx
                pop cx
                inc dx
                dec di
        jnz l1112
        mov ah,02h
        mov bh,00h
        mov dl,02h      ;Row no
        mov dh,01h      ;Col no
        int 10h
        mov dx, rule1                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,09h
        mov dh,05h
        int 10h
        mov dx, buffer+2                                                                      ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h                                                                            ;bit 0: update cursor after writing
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov cx,6                                                                              ;bits 2-7: reserved (0)
        mov dl,03h
        mov dh,05h                                                                            ;BL = attribute if string contains only characters
        push bp
        mov bp, hello                                                                         ;CX = number of characters in string                                                                            ;DH,DL = row,column at which to start writing
        int 0x10
        pop bp
        mov ah,02h
        mov bh,00h
        mov dl,01h
        mov dh,09h
        int 10h
        mov dx, rule2                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,01h
        mov dh,10
        int 10h
        mov dx, rule3                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,01h
        mov dh,11
        int 10h
        mov dx, rule4                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,01h
        mov dh,12
        int 10h
        mov dx, rule5                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,11
        mov dh,21
        int 10h
        mov dx, name2                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,02h
        mov bh,00h
        mov dl,7
        mov dh,19
        int 10h
        mov dx, name1                                                                         ; message to print
        mov ah, 9                                                                             ; service 9 – write string
        int 0x21
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h                                                                            ;bit 0: update cursor after writing
        mov bl,04h                                                                            ;bit 1: string contains alternating characters and attributes
        mov cx,23                                                                             ;bits 2-7: reserved (0)
        mov dl,7
        mov dh,17                                                                             ;BL = attribute if string contains only characters
        push bp
        mov bp,devel                                                                          ;CX = number of characters in string                                                                            ;DH,DL = row,column at which to start writing
        int 0x10
        pop bp
        mov ax, 1003h
        mov bl, 00h 
        mov bh, 00h
        int 0x10 

        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h                                                                            ;bit 0: update cursor after writing
        mov bl,87h                                                                            ;bit 1: string contains alternating characters and attributes
        mov cx,36                                                                             ;bits 2-7: reserved (0)
        mov dl,3
        mov dh,14                                                                             ;BL = attribute if string contains only characters
        push bp
        mov bp,skort                                                                          ;CX = number of characters in string                                                                            ;DH,DL = row,column at which to start writing
        int 0x10
        pop bp
        mov ah, 0           ; service 0 – get keystroke
        int 0x16            ; bios keyboard services
        cmp al,27
        jne noend
        mov byte[cs:exit],1
        noend:
        mov ax, 0x0003      ; 80x25 text mode
        int 0x10            ; bios video services
        popa
        ret
;---------------------------------------------------------------------------------------------------
delay:          
                push cx
                mov cx, 0xFFFF
                loop1:      loop loop1
                            mov cx, 0xFFFF
                loop2:      loop loop2
		        pop cx
		        ret
;---------------------------------------------------------------------------------------------------
musicwalakaam: 
 ;-----------------------------------------------------------------------------------------------------------
                delay2:          
                                push bx
                                mov bx, 0xFFFF
                                lol1:       
                                            dec bx
                                            cmp bx,0 
                                            jne lol1
                                            mov bx, 0xFFFF    ;Chota wala delay with bx
                                pop bx
                                ret
 ;----------------------------------------------------------------------
                sounder:
                mov al,10110110b    ;load control word
                out 43h,al          ;send it
                mov ax,[cs:stor]    ;tone frequency
                out 42h,al          ;send LSB
                mov al,ah           ;move MSB to AL
                out 42h,al          ;save it
                in al,61h           ;get port 61 state
                or al,00000011b     ;turn on speaker
                out 61h,al          ;speaker on now
                call delay2         ;go pause a little bit
                and al,11111100b    ;clear speaker enable
                out 61h,al          ;speaker off now
                call delay2
                ret
 ;--------------------------------------------------------------------------
                tone_1:
                push ax
                mov ax, 272
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;----------------------------------------------------------------------------
                tone_2:
                push ax
                mov ax, 294
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;----------------------------------------------------------------------------
                tone_3:
                push ax
                mov ax, 314
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;------------------------------------------------------------------------------
                tone_4:
                push ax
                mov ax, 330
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;--------------------------------------------------------------------------------
                tone_5:
                push ax
                mov ax, 350
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;-----------------------------------------------------------------------------------
                tone_6:
                push ax
                mov ax, 370
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;-------------------------------------------------------------------------------------
                tone_7:
                push ax
                mov ax, 392
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;--------------------------------------------------------------------------------------
                tone_8:
                push ax
                mov ax, 419
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;---------------------------------------------------------------------------------------
                tone_9:
                push ax
                mov ax, 440
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
 ;----------------------------------------------------------------------------------------
                tone_0:
                push ax
                mov ax, 475
                mov [cs:stor], ax
                call sounder        ;go generate the tone
                pop ax
                ret
;---------------------------------------------------------------------------------------------------
tasktwo:

        ;Gana Bjana
        call tone_0
        call tone_2
        call tone_4
        call tone_6
        call tone_8
        call tone_0
        call tone_9
        call tone_7
        call tone_5
        call tone_3
        call tone_1
        call tone_0
        call tone_5
        call tone_3
        call tone_6
        call tone_4
        call tone_1
        call tone_2
        call tone_1
        call tone_2
        call tone_3
        call tone_5
        call tone_7
        call tone_9
        call tone_8
        call tone_6
        call tone_4
        call tone_0
        call tone_4
        call tone_2
        call tone_0
        call tone_1
        call tone_2
        call tone_3
        call tone_5
        call tone_7
        call tone_8
        call tone_9
        call tone_6
        call tone_4
        call tone_6
        call tone_4
        call tone_9
        call tone_1
        call tone_2
        call tone_9
        call tone_4
        call tone_7
        call tone_8
        call tone_1					
		jmp tasktwo					; infinite task
;---------------------------------------------------------------------------------------------------
sound2:
        push bp
        mov bp,sp
        push ax
        push cx
        mov cx, 1
        looop2:         
        mov al, 0b6h
        out 43h, al

        ;load the counter 2 value for d3
        mov ax, 1fb4h
        out 42h, al
        mov al, ah
        out 42h, al

        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        ;call delay
        mov al, ah
        out 61h, al

        ;call delay

        ;load the counter 2 value for a3
        mov ax, 152fh
        out 42h, al
        mov al, ah
        out 42h, al

        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        call delay
        mov al, ah
        out 61h, al

        ;call delay
            
        ;load the counter 2 value for a4
        mov ax, 0A97h
        out 42h, al
        mov al, ah
        out 42h, al
            
        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        ;call delay
        mov al, ah
        out 61h, al

        ;call delay
        
        loop looop2

        pop cx
        pop ax
        pop bp
        ret

;---------------------------------------------------------------------------------------------------
sound:
        push bp
        mov bp,sp
        push ax
        push cx
        mov cx, 1
        looop1:         
        mov al, 0b6h
        out 43h, al

        ;load the counter 2 value for d3
        mov ax, 1fb4h
        out 42h, al
        mov al, ah
        out 42h, al

        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        call delay
        mov al, ah
        out 61h, al

        call delay

        ;load the counter 2 value for a3
        mov ax, 152fh
        out 42h, al
        mov al, ah
        out 42h, al

        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        call delay
        mov al, ah
        out 61h, al

        call delay
            
        ;load the counter 2 value for a4
        mov ax, 0A97h
        out 42h, al
        mov al, ah
        out 42h, al
            
        ;turn the speaker on
        in al, 61h
        mov ah,al
        or al, 3h
        out 61h, al
        call delay
        mov al, ah
        out 61h, al

        call delay
        
        loop looop1

        pop cx
        pop ax
        pop bp
        ret
;---------------------------------------------------------------------------------------------------
gerrandom:
            push bp
            mov bp,sp
            push ax
            push bx
            push cx
            push dx
            mov ah, 2ch                 ;Get time
            int 21h                     ;Time wali Interrupt
            mov word[cs:random1],dx     ;Minutes Green ke liye
            mov word[cs:random2],bx     ;Hours Red ke liye
            pop dx
            pop cx
            pop bx
            pop ax
            pop bp
            ret
;---------------------------------------------------------------------------------------------------
green: 
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ax, 0xb800
        mov es, ax
        mov di, word[cs:greenplace]         ;Purani Jagah         
        mov ax, word[cs:samundar]           ;Purani Chezz
        mov word[es:di], ax
        mov ax,word[cs:random1]             ;Random Number yehan ha 
        inc ax
        mov cl,34
        mul cl
        sub ax, 10
        mov dx, 0                           ;Random Calculations
        mov bx, 960
        div bx
        add dx,3040
        mov di,dx
        mov word[cs:greenplace], di         ;Nai Jagah
        mov word[es:di],0x2020              ;Green Sikka rakh do
        mov byte[cs:greentick], 0           ;Ab ho gya to time dobara shuru
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret 
;---------------------------------------------------------------------------------------------------
red: 
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ax, 0xb800
        mov es, ax
        mov di, word[cs:redplace]           ;Purani Jagah
        mov ax, word[cs:samundar]           ;Purani Chezz
        mov word[es:di], ax
        mov dh,0
        mov ax,word[cs:random2]             ;Random Number yehan ha
        inc ax
        mov cl,34
        mul cl
        sub ax, 10
        mov dx, 0                            ;Some Random Calculations
        mov bx, 960
        div bx
        add dx,3040
        mov di,dx
        mov word[cs:redplace], di           ;Nai Jagah for Later use
        mov word[es:di],0x4020              ;Lal Sikka rakh do
        mov byte[cs:redtick], 0             ;Ab ho gya to time dobara shuru
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret
;---------------------------------------------------------------------------------------------------
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
                    mov es, ax ; point es to video base 
                    mov ax, [bp+4] ; load number in ax 
                    mov bx, 10 ; use base 10 for division 
                    mov cx, 0 ; initialize count of digits 
                    
                    nextdigit: 
                    mov dx, 0 ; zero upper half of dividend 
                    div bx ; divide by 10 
                    add dl, 0x30 ; convert digit into ascii value 
                    push dx ; save ascii value on stack 
                    inc cx ; increment count of values 
                    cmp ax, 0 ; is the quotient zero 
                    jnz nextdigit ; if no divide it again 
                    mov di, 150 ; point di to top left column 
                    
                    nextpos: 
                    pop dx ; remove a digit from the stack 
                    mov dh, 0x30 ; use normal attribute 
                    mov [es:di], dx ; print char on screen 
                    add di, 2 ; move to next screen location 
                    loop nextpos ; repeat for all digits on stack
                    pop di 
                    pop dx 
                    pop cx 
                    pop bx 
                    pop ax 
                    pop es 
                    pop bp 
                    ret 2
;---------------------------------------------------------------------------------------------------
showscore:
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        push es
        mov ah, 01h
        mov ch, 00100000b
        mov ch, 20h
        int 0x10                            ;Cursor Gayab krny ki Ninja Technique
        mov ah,02h
        mov bh,00h
        mov dl,45h
        mov dh,00h
        int 10h
        mov dx, scores 						; message to print
		mov ah, 9 							; service 9 – write string
		int 0x21
        mov ah,02h
		mov cx,1
        mov bh,00h
        mov dl,25h
        mov dh,00h
		int 10h
        mov ax,word[cs:score]               ;Retriving the Score form Label
        push ax
        call printnum                       ;Isko decimal mein print krdo
        pop es
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret
;---------------------------------------------------------------------------------------------------
timers:
    push bp
    mov bp,sp
    push ax
    push cx
    push dx
    push es
    push di 
    push si
    push ds
    ;---------------------------------------------------------------------------------------------------------------
    call showscore
    inc byte[cs:greentick]
    inc byte[cs:redtick]
    inc byte[cs:tick]    
    inc word[cs:random1]
    inc word[cs:random2]      
    ;----------------------------------------------------------------------------------------------------------------    
    shiftings:
    mov dh, 0
    mov dl, byte[cs:frequency]
    cmp byte[cs:tick], dl
    jle coins
    mov ax, word[cs:skyend]
    sub ax, 160 ;space for Score
    mov cl,160
    div cl
    push ax
    mov ax,word[cs:videobase]
    push ax 
    ;shifting of sky
    call shiftsky
    mov ax,word[cs:videobase]
    push ax
    ;shifting of sea
    call shiftsea
    mov byte[cs:tick], 0
    ;---------------------------------------------------------------------------------
    coins:    
    mov ax, word[cs:videobase]                  
    mov es, ax
    mov dh, 0
    mov dl, byte[cs:greenlife]
    cmp byte[cs:greentick], dl
    jne nogreen                     ;Abhi waqt nahin ho baad mein ana
    call green
    ;---------------------------------------------------------------------------------
    nogreen:
    mov dl, byte[cs:redtick]
    cmp dl, byte[cs:redlife]
    jne end                         ;Abhi waqt nahin ho baad mein ana
    call red
    end:
    pop ds
    pop si
    pop di
    pop es
    pop dx
    pop cx
    pop ax 
    pop bp
    ret
;--------------------------------------------------------------------------------------------------- 
timer:
    push ax
    push bx
    cmp byte[cs:stop], 1
    je last
    mov byte[cs:gotten],0
    call timers                                 ;Asal maal isme hai
    last:                
            mov bl, [cs:current]				; read index of current task ... bl = 0
			mov ax, 10							; space used by one task
			mul bl								; multiply to get start of task.. 10x0 = 0
			mov bx, ax							; load start of task in bx....... bx = 0

			pop ax								; read original value of bx
			mov [cs:pcb+bx+2], ax				; space for current task's BX

			pop ax								; read original value of ax
			mov [cs:pcb+bx+0], ax				; space for current task's AX

			pop ax								; read original value of ip
			mov [cs:pcb+bx+4], ax				; space for current task

			pop ax								; read original value of cs
			mov [cs:pcb+bx+6], ax				; space for current task

			pop ax								; read original value of flags
			mov [cs:pcb+bx+8], ax					; space for current task

			inc byte [cs:current]				; update current task index...1
            mov al,byte[cs:tasks]
			cmp byte [cs:current], al			; is task index out of range
			jne skipreset						; no, proceed
			mov byte [cs:current], 0			; yes, reset to task 0

            skipreset:	mov bl, [cs:current]				; read index of current task
			mov ax, 10							; space used by one task
			mul bl								; multiply to get start of task
			mov bx, ax							; load start of task in bx... 10
			
			mov al, 0x20
			out 0x20, al						; send EOI to PIC

			push word [cs:pcb+bx+8]				; flags of new task... pcb+10+8
			push word [cs:pcb+bx+6]				; cs of new task ... pcb+10+6
			push word [cs:pcb+bx+4]				; ip of new task... pcb+10+4
			mov ax, [cs:pcb+bx+0]				; ax of new task...pcb+10+0
			mov bx, [cs:pcb+bx+2]				; bx of new task...pcb+10+2

            ;mov al, 0x20
	        ;out 0x20, al ; end of interrupt
	        iret ; return from interrupts
;---------------------------------------------------------------------------------------------------
khalia:
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        mov bx, word[cs:oldspace]
        cmp bx, 0x4020
                jne nest
                call red
                call sound2
                add word[cs:score], 10
    nest:
                cmp bx, 0x2020
                jne popping
                call green
                call sound2
                add word[cs:score], 50

    popping: pop dx
             pop cx
             pop bx
             pop ax
             pop bp
             ret
;---------------------------------------------------------------------------------------------------
keycheker:


                mov di,word[cs:fishlocation]
				mov si, di
                mov ax, 0xb800
				mov es, ax
                mov cl, 160									
                
                
                in  al, 0x60						        			      
                
                cmp al, 0x4B								
				jne nextright
				mov ax,di
				div cl
				cmp ah, 0                   ;edge condition
				jne notatleft               ;not at edge 
				add di,160
    notatleft:
				sub di,2
				mov ax, word[cs:samundar]
                mov word[es:si], ax
				mov word[cs:fishlocation],di
                mov ax, word[cs:fish]								
				mov bx, word[es:di]				
				mov word[cs:oldspace],bx
                call khalia
                stosw
                jmp nomatch									
    nextright:	cmp al, 0x4D								
				jne nextup
				mov ax,di
				div cl
				cmp ah, 158                     ;Edge Condition
				jne notatright 
				sub di,160	                    ;Staying in same line
    notatright:		add di,2
				mov ax, word[cs:samundar]
                mov word[es:si], ax
				mov word[cs:fishlocation],di
                mov ax,word[cs:fish]
                mov bx, word[es:di]
                mov word[cs:oldspace],bx									
				call khalia
                stosw
                jmp nomatch
				
    nextup:		cmp al, 0x48								
				jne nextdown
				sub di,160
				cmp di,3038
				jnle nosound1
				call sound
                jmp nomatch
                nosound1:
                mov ax, word[cs:samundar]
				mov word[es:si], ax
				mov word[cs:fishlocation],di
                mov ax,word[cs:fish]
                mov bx, word[es:di]
                mov word[cs:oldspace],bx									
				call khalia
                stosw					           
                jmp nomatch							

    nextdown:	cmp al, 0x50								
				jne nextesc
				add di, 160
				cmp di, 3998
				jng nosound2
                call sound
                jmp nomatch
                nosound2:
                mov ax, word[cs:samundar]
				mov word[es:si], ax
				mov word[cs:fishlocation],di
                mov ax,word[cs:fish]
                mov bx, word[es:di]
                mov word[cs:oldspace],bx										
                call khalia
                stosw					                    
                jmp nomatch
    nextesc: 	cmp al, 1
				jne nomatch
                mov byte[cs:stop], 1                ;Sab Kaam rok do
                jmp nomatch

    nomatch:    
                ret
;---------------------------------------------------------------------------------------------------
kbisr:			
                
                push ax
				push es
                push ds
                push di
                push si
                push cx
                push bx

                cmp byte[cs:stop],1                     ;Fish Movement 
                je something
                call keycheker
                jmp nothing
 something:
                
                cmp byte[cs:gotten],1
                je getkey
                call clearscreen
                mov ah,02h
                mov bh,00h                              
                mov dl,01h
                mov dh,09h
                int 10h
                mov dx, goodbye 						;Greetings Message
                mov ah, 9
                int 0x21
                mov byte[cs:gotten],1
                getkey:
                in  al, 0x60                             ;Jana ha ya Rukna ha jo bhi ha Isme daal do
                mov byte[cs:exicution],al
                

 nothing:       pop bx
				pop cx
				pop si
                pop di
                pop ds
                pop es
                pop ax
				jmp far [cs:oldisr] ; call the original ISR
;---------------------------------------------------------------------------------------------------
clearscreen:    
                push bp                 ;storing old base pointer
                mov bp,sp               ;moving sp into base pointer
                push es                 ;pushing locals into stack
                push di 
                push ax
                push cx
                mov ax,0xb800       ;retrieving video base from stack  
                mov es, ax 
                mov ax,0x0720 
                mov di,0
                mov cx,2000             ;Pixels on screen
                cld
                rep stosw
                pop cx
                pop ax
                pop di
                pop es
                pop bp
                ret 
;---------------------------------------------------------------------------------------------------
sky:    
                push bp
                mov bp,sp
                push es                 ;pushing locals into stack
                push di 
                push ax
                push cx
                mov ax, word[bp+6]      ;retrieving video base from stack  
                mov es, ax
                mov ax, 0x3020  
                mov cx, word[bp+4]      ;End of sky
                shr cx,1                ;Half for the number of iterations 
                mov di,0
                cld     
                rep stosw
                pop cx
                pop ax
                pop di
                pop es
                pop bp
                ret 4
;---------------------------------------------------------------------------------------------------
sea:    
                push bp
                mov bp,sp
                push es                 ;pushing locals into stack
                push di 
                push ax
                push cx
                mov ax,word[bp+6]       ;retrieving video base from stack  
                mov es,ax  
                mov di,word[bp+4]       ;di at Skyend(Sea Start)
                mov cx, 4000            ;End of screen
                sub cx,di               ;End-Sky part
                shr cx,1                ;Pixels=2/Address
                mov ax,0x977E           ;Blinking ~ on blue bg
                cld
                rep stosw
                pop cx
                pop ax
                pop di
                pop es
                pop bp
                ret 4
;---------------------------------------------------------------------------------------------------
mountain:
                push bp
                mov bp,sp
                push cx
                push si
                push di
                push ax
                push es
                push bx
                push dx
                mov bx,word[bp+8]       ;size of mountain in bx
                mov di,word[bp+6]       ;start of sky one line below
                mov ax,word[bp+4]       ;Video memory
                mov es,ax
                mov ax, 0x605e
                sub di,160              ;Jumping to upper line
                cld
                l1:         
                    mov si,di
                    mov cx,bx
                    rep stosw    
                    mov di,si
                    sub di,160
                    add di,2
                    sub bx,2            ;size decreases from both side so bx-2
                    cmp bx,0            ;Not used JNZ why? 
                jg l1                   ;Ans:Because when the size is odd it becomes -1 so cmp with 0 if equal to zero or less then stop rep
                pop dx
                pop bx
                pop es
                pop ax
                pop di 
                pop si
                pop cx
                pop bp
                ret 6
;---------------------------------------------------------------------------------------------------
boat:
                push bp
                mov bp,sp
                push ax
                push cx
                push di
                push si
                push es
                mov ax,word[bp+4]       ;Video memory
                mov es,ax
                mov di,word[bp+10]      ;Start of boat
                mov cx,word[bp+8]       ;Width of boat
                mov dx,word[bp+6]       ;Height of boat
                mov bx,2
                mov ax,0x7020
                cld
                l2:         
                    mov si,di
                    rep stosw 
                    mov cx,word[bp+8]
                    sub cx,bx
                    add bx,2
                    mov di,si
                    add di,160
                    add di,2
                    sub dx,1
                jnz l2
                mov cx,word[bp+12]      ;Chimney: Height of chimney in bx and width in ax
                mov bx,cx                      
                shr bx,1                ;Height is half of width     
                mov di,word[bp+10]      ;Starting index of boat
                mov dx,word[bp+8]       ;Width of boat
                add dx,cx               ;Adding width of chimney into width of boat to almost find half lol 
                shr dx,1                ;Almost half of boat width
                sub di,160              ;Upper line for chimney
                add di,dx               ;Adding half on the starting index
                mov ax,0x0020           ;Black Chimney in accumulator
                cld
                l3:             
                    mov si,di           ;restoring start of chimney
                    rep stosw
                    mov cx,word[bp+12]  ;restoring width of chimney
                    mov di,si
                    sub di,160          ;move to upwards line 
                    sub bx,1
                jnz l3
                sub di,2                ;smoke on chimney
                mov ax,0x7020 
                stosw                   ;put smoke 
                pop es
                pop si
                pop di
                pop cx
                pop ax
                pop bp
                ret 10
;---------------------------------------------------------------------------------------------------
shiftsky:         
                push bp
                mov bp,sp
                push ax
                push di
                push si
                push cx
                push es
                push ds
                push dx
                push bx
                mov ax,[bp+4]           ;video memory
                mov es,ax 
                mov ds,ax 
                mov si,160                ;screen begin
                mov di,si
                mov bx,[bp+6]           ;number of rows for sky 
                add si,2
                cld
                l4:         
                    mov dx,word[es:di]  ;boundary pixel stored
                    mov cx,79
                    rep movsw 
                    mov word[es:di],dx  ;the boundary pixel reprinted
                    add si,2
                    add di,2
                    sub bx,1
                jnz l4
                pop bx 
                pop dx  
                pop ds
                pop es
                pop cx
                pop si
                pop di
                pop ax
                pop bp
                ret 4 
;---------------------------------------------------------------------------------------------------
shiftsea:         
                push bp
                mov bp,sp
                push ax
                push di
                push si
                push cx
                push es
                push ds
                push dx
                push bx
                mov ax,[bp+4]           ;video memory
                mov es,ax 
                mov ds,ax
                mov si,1600             ;begin point of sea
                mov di,1600
                add si,158              ;to move to end of row as it is reverse shifted
                add di,158
                mov bx,9               ;number of rows for sea
                sub si,2
                std
                l5:         
                    mov dx,word[es:di]  ;store boundary pixel
                    mov cx,79
                    rep movsw 
                    mov word[es:di],dx  ;reprint boundary pixel
                    add si,318          ;to move again to end of next row 
                    add di,318 
                    sub bx,1
                jnz l5
                pop bx 
                pop dx  
                pop ds
                pop es
                pop cx
                pop si
                pop di
                pop ax
                pop bp
                ret 2
;---------------------------------------------------------------------------------------------------
mountains:
                push bp
                mov bp,sp
                push ax
                mov ax,word[bp+8]
                add ax,2
                push ax
                mov ax,word[bp+6]
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                mov ax,word[bp+8]
                push ax
                mov ax,word[bp+6]
                add ax,28
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                mov ax,word[bp+8]
                push ax
                mov ax,word[bp+6]
                add ax,52
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                mov ax,word[bp+8]
                push ax
                mov ax,word[bp+6]
                add ax,76
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                mov ax,word[bp+8]
                push ax
                mov ax,word[bp+6]
                add ax,100
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                mov ax,word[bp+8]
                add ax,3
                push ax
                mov ax,word[bp+6]
                add ax,124
                push ax 
                mov ax,word[bp+4]
                push ax
                call mountain
                pop ax
                pop bp
                ret 6
;---------------------------------------------------------------------------------------------------
boats:
                push bp
                mov bp,sp
                push ax
                mov ax, word[bp+12]
                push ax
                mov ax, word[bp+10]
                push ax
                mov ax, word[bp+8]
                push ax
                mov ax, word[bp+6]
                push ax
                mov ax,word[bp+4]
                push ax
                call boat
                mov ax, word[bp+12]
                sub ax,1
                push ax
                mov ax, word[bp+10]
                sub ax, 230
                push ax
                mov ax, word[bp+8]
                sub ax,3
                push ax
                mov ax, word[bp+6]
                sub ax,1
                push ax
                mov ax,word[bp+4]
                push ax
                call boat
                pop ax
                pop bp
                ret 10
;---------------------------------------------------------------------------------------------------
fishs:
                push bp
                mov bp,sp
                push ax
                push di
                mov ax,0xb800
                mov es,ax
                mov ax, word[fish]
                mov di, word[fishlocation]
                mov [es:di],ax
                pop di
                pop ax
                pop bp
                ret
;---------------------------------------------------------------------------------------------------
open:
        push bp
        mov bp,sp 
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        call clearscreen
        mov ah,02h
        mov bh,00h
        mov dl,25                               ;Aapka kya naam ha Humse kya kaam ha?
        mov dh,10
        int 10h
        mov dx, opennings 						; message to print
		mov ah, 9 								; service 9 – write string
		int 0x21 								; dos services
        mov ah,02h
        mov bh,00h
        mov dl,30
        mov dh,14
        int 10h
        
        mov dx, buffer 							; input buffer (ds:dx pointing to input buffer)
		mov ah, 0x0A 							; DOS' service A – buffered input
		int 0x21 								; dos services call
		mov bh, 0
		mov bl, [cs:buffer+1] 					; read actual size in bx i.e. no of characters user entered
		mov byte [cs:buffer+2+bx], '$' 			; append $ at the end of user input
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret
;---------------------------------------------------------------------------------------------------
welcome:
        push bp
        mov bp,sp
        push ax
        push bx
        push cx
        push dx
        push si
        push di
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h                                                                            ;bit 0: update cursor after writing
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov cx,6                                                                            ;bits 2-7: reserved (0)
        mov dh,05h                                                                            ;BH = page number
        mov dl,20h                                                                            ;BL = attribute if string contains only characters
        push bp
        mov bp,hello                                                                            ;CX = number of characters in string                                                                            ;DH,DL = row,column at which to start writing
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,05h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,26h
        mov cx,20                                                                            ;bits 2-7: reserved (0)
        mov bp,buffer+2                                                                            ;CX = number of characters in string                                                                            ;DH,DL = row,column at which to start writing
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,07h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,20
        mov cx,44                                                                            ;bits 2-7: reserved (0)
        mov bp,rule1                                                                            ;CX = number of characters in string 
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,08h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,20
        mov cx,44                                                                            ;bits 2-7: reserved (0)
        mov bp,rule2                                                                            ;CX = number of characters in string 
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,09h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,20
        mov cx,44                                                                            ;bits 2-7: reserved (0)
        mov bp,rule3                                                                            ;CX = number of characters in string 
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,0ah                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,20
        mov cx,44                                                                            ;bits 2-7: reserved (0)
        mov bp,rule4                                                                            ;CX = number of characters in string 
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,0bh                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,20
        mov cx,44                                                                            ;bits 2-7: reserved (0)
        mov bp,rule5                                                                            ;CX = number of characters in string 
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,14h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,48
        mov cx,31                                                                            ;bits 2-7: reserved (0)
        mov bp,name1
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,03h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,15h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,48
        mov cx,31                                                                            ;bits 2-7: reserved (0)
        mov bp,name2
        int 0x10
        mov ah,13h                                                                            ;AH = 13h
        mov al,00h                                                                            ;AL = write mode
        mov bh,00h
        mov bl,87h                                                                            ;bit 1: string contains alternating characters and attributes
        mov dh,16h                                                                            ;BH = page number                                                                            ;BL = attribute if string contains only characters
        mov dl,00h
        mov cx,32                                                                            ;bits 2-7: reserved (0)
        mov bp,name3
        int 0x10
        mov ah, 0								; service 0 – get keystroke
        int 0x16
        cmp al, 27
        jne noexit
        mov byte[cs:exit], 1
 ;-----------------------------------------------------------------------------------------------------------------
  noexit:        
        pop bp                                                                            ;ES:BP -> string to write
        pop di
        pop si
        pop dx
        pop cx
        pop bx
        pop ax
        pop bp
        ret
;---------------------------------------------------------------------------------------------------
main:
 call open
 call newmainstart
 call delay
 call delay
 call delay
 call delay
 
 
 mov word[cs:ter],terminate
 cmp byte[cs:exit],1
 jne nakrna
 jmp [cs:ter]
 nakrna:   

 call clearscreen
 xor ax, ax
 mov es, ax
 ;mov ax, 1100
 ;out 0x40, al
 ;mov al, ah
 ;out 0x40, al
 mov word [pcb+10+4], tasktwo			; initialize ip
 mov [pcb+10+6], cs						; initialize cs
 mov word [pcb+10+8], 0x0200				; initialize flags
 mov word [current], 0
 
 										; point es to IVT base
 mov ax, [es:9*4]
 mov [oldisr], ax								; save offset of old routine
 mov ax, [es:9*4+2]
 mov [oldisr+2], ax
 mov ax, [es:8*4]
 mov [oldtimer], ax								; save offset of old routine
 mov ax, [es:8*4+2]
 mov [oldtimer+2], ax
 xor ax, ax
 mov es, ax ; point es to IVT base								; save segment of old routine
 cli ; disable interrupts											; disable interrupts
 mov word [es:9*4], kbisr						; store offset at n*4
 mov [es:9*4+2], cs								; store segment at n*4+2
 mov word [es:8*4], timer; store offset at n*4
 mov [es:8*4+2], cs ; store segment at n*4+2
 sti
;Clear Screen
 call clearscreen
;random numbers
 call gerrandom     ;Random Numbers for the First Coins
;Sky 
 start:
 mov ax, word[videobase]
 push ax
 mov ax, word[skyend]
 push ax
 call sky
;Sea
 mov ax,word[videobase]
 push ax
 mov ax,word[skyend]
 push ax
 call sea
;calling coins
 call green
 call red
;Mountains (Calling mountain one by one in this)
 mov ax,word[mountainsize]
 push ax
 mov ax,word[skyend]
 push ax
 mov ax,word[videobase]
 push ax
 call mountains
;Boats (Calling boat one by one in it) 
 mov ax, word[chimney]
 push ax
 mov ax, word[boatstart]
 push ax
 mov ax, word[boatwidth]
 push ax
 mov ax, word[boatheight]
 push ax
 mov ax,word[videobase]
 push ax
 call boats
;Calling our beloved fish
 call fishs
;infinite loop
 mov byte[cs:exicution],0                ;Clearing place from Y and N
 infinte:
       
        cmp byte[cs:stop],1                     ;Rokna to nahin?
        jne noask
            handbrake:
            cmp byte[cs:exicution], 49          ;Abhi na jao q k "N" aya ha
            je noescap
            cmp byte[cs:exicution], 21          ;Chala ja Bhai "Y"
            je escap
            jmp done
            noescap: 
            mov byte[cs:stop],0x00              ;Kaam jari rakho bhai
            jmp done
            escap:  
            mov byte[cs:exit],1                 ;Phir milein ge Kahin 
            done:  
            je start 
        noask:
        cmp byte[cs:exit], 0x01																
        jne infinte
 termination:
;terminate Please!
 mov ah, 01h
 mov ch, 00001111b
 int 0x10                                   ;Cursor ki shakal wapis aye gi
 and al,11111100b                           ;clear speaker enable
 out 61h,al                                 ;speaker off now
 call clearscreen
 xor ax, ax
 mov es, ax
 mov ax, [oldisr]					        ; read old offset in ax
 mov bx, [oldisr+2]							; read old segment in bx			
 mov cx, [oldtimer]
 mov dx, [oldtimer+2]
 cli										; disable interrupts
 mov [es:9*4], ax						    ; restore old offset from ax
 mov [es:9*4+2], bx							; restore old segment from bx
 mov [es:8*4], cx
 mov [es:8*4+2], dx
 sti                                        ;interrupts khol deyo
 mov ah,02h
 mov bh,00h                              
 mov dl,00h
 mov dh,25
 int 10h
 terminate:  
            mov ax, 0x4c00                  ;Khatam tata bye bye 
            int 0x21