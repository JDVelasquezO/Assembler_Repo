printString macro cadena
    mov dx, offset cadena   ; Mover donde empieza el mensaje
    mov ah, 09h             ; Imprime un caracter en pantalla
    int 21h
endm

printRegister macro registro
    push ax
    push dx

    mov dl, registro
    add dl, 48
    mov ah, 02h
    int 21h

    pop dx
    pop ax
endm

Imprimir8bits macro registro
    local cualquiera, noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,2
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,2
    noz:
    pop dx
    printRegister dl
    dec bx
    jnz noz
endm