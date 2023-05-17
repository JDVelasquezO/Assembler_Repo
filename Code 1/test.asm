include macros.asm

.model small

.stack 64h

; Aquí van todas las declaraciones de variables
.data
    variable db 'Cualquier Cosa', '$'
    esPar db 'Es par', '$'
    esImpar db 'Es impar', '$'
    debug db 'Aqui llego', '$'
    listaNumeros db 5, 10, 15, 20, 25

.code
    main proc
        mov ax, @data
        mov ds, ax

        ; printString variable

        mov si, 0   ; i = 0
        inicio:
            xor ax, ax
            xor dx, dx
            ; ax = al ah
            mov al, listaNumeros[si]    ; al = listaNumeros[i]
            mov bl, 2
            div bl  ; ah = 5 / 2

            ; printString debug
            cmp ah, 0
            je pares
            jmp impares

            pares:
                printString esPar
                jmp continue

            impares:
                printString esImpar

            continue:
            inc si      ; i++
            cmp si, 5   ; if (i != 5)
        jne inicio      ; goto inicio
        jmp fin

        fin:
        mov ax, 4C00H
        int 21h
    main endp
end
