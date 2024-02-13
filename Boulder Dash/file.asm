[org 0x0100]
;----------------------------------------------------------------------------------------------------------------
inputfilename:
                pusha
                call clearscreen
                
                mov ah,02h
                mov bh,00h
                mov dl,00                               
                mov dh,00
                int 10h
                mov dx, opennings 						
		mov ah, 9 								
		int 0x21 						

                mov ah,02h
                mov bh,00h
                mov dl,00
                mov dh,1
                int 10h
                mov dx, file 							
		mov ah, 0x0A 							
		int 0x21
                
                cmp byte[cs:file+1],0
                je go2 								

                mov bh, 0
                mov bl, [cs:file+1] 					
                mov byte [cs:file+2+bx], 0 			
                mov si, file
                add si, 2
                mov cl, byte[cs:file+1]
                mov ch, 0
                sub cx, 4                                           
                add si,cx
                mov cx,4
                mov bx,comparable
                loop1:
                 mov dl,byte[si]
                 mov dh,byte[bx]
                 cmp dl,dh
                 jne enddings
                 inc si
                 inc bx
                 sub cx,1
                 jnz loop1
                 jmp go

        enddings:
                mov ah,02h
                mov bh,00h
                mov dl,0                              
                mov dh,1
                int 10h
                mov dx, error1 						  
                mov ah, 9 								
                int 0x21
                mov byte[cs:ter], 1
                jmp end2 

        go:
                call openfile
                jmp end2

        go2:
                call openfile2

                end2:
                popa
                ret
;---------------------------------------------------------------------------------------------------------------
openfile:
                pusha
                mov byte[cs:otherfile], 1
                mov word[cs:levels], 1
                mov ah, 3dh 
                mov dx, file+2 
                mov al, 0 
                int 21h 
                jc err1 
                
                mov word[cs:handle], ax 
                mov ah, 3fh
                mov bx, word[cs:handle] 
                mov dx, buffer 
                mov cx, 1601
                int 21h 
                jc err1 

                mov word[cs:bytesread], ax 
                mov bx,word[cs:bytesread]
                mov byte[cs:buffer+bx],'$'
                mov di,1600
                cmp word[cs:bytesread],di
                jl err2

                mov ah, 3Eh 
                mov bx, word[cs:handle] 
                int 21h 
                jc err1 
                
                jmp end1

        err1:
                mov dx, error3
                mov ah, 9h 
                int 21h ;
                mov byte[cs:ter], 1
                jmp end1
                
        err2:
                mov dx, error2
                mov ah, 9h 
                int 21h 
                mov ah, 3Eh 
                mov bx, word[handle] 
                int 21h 
                mov byte[cs:ter], 1
                jmp end1

        end1:
                popa
                ret
;-----------------------------------------------------------------------------------------------------------------
openfile2:
                pusha
                mov ah, 3dh 
                mov dx, constant 
                mov al, 0 
                int 21h 
                jc errr1 

                mov word[cs:handle], ax 
                mov ah, 3fh 
                mov bx, word[cs:handle] 
                mov dx, buffer 
                mov cx, 1601
                int 21h 
                jc errr1 

                mov word[cs:bytesread], ax
                mov bx,word[cs:bytesread]
                mov byte[cs:buffer+bx],'$'
                mov di,1600
                cmp word[cs:bytesread],di
                jl errr2
                
                mov ah, 3Eh 
                mov bx, word[cs:handle] 
                int 21h 
                jc errr1 
                
                jmp endd1

        errr1:
                mov dx, error3
                mov ah, 9h 
                int 21h
                mov byte[cs:ter], 1
                jmp endd1
        errr2:
                mov dx, error2
                mov ah, 9h 
                int 21h 
                mov ah, 3Eh 
                mov bx, word[cs:handle] 
                int 21h 
                mov byte[cs:ter], 1
                jmp endd1

        endd1:
                popa
                ret
