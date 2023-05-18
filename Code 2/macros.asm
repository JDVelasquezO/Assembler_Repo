imprimirColor macro cadena, color
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    mov bl, color
    mov cx, lengthof cadena - 1
    int 10h
    lea dx, cadena
    int 21h
endm

imprimirMatriz macro 

    imprimirColor espacio, 0d
    imprimirColor espacio, 0d
    ; Imprime Cabeceras de Columnas
    xor si, si
    ciclo:
        mov bl, cabecerasC[si]
        mov individual[0], bl
        imprimirColor individual, 15d
        imprimirColor espacio, 0d
        imprimirColor espacio, 0d
        imprimirColor espacio, 0d
        inc si
        cmp si, 8d
        jnz ciclo
    
    ; Imprime cabeceras de filas
    imprimirColor salto, 0d
    xor si, si
    ciclo2:
        xor di, di
        mov bl, cabecerasF[si]
        mov individual[0], bl
        imprimirColor individual, 15d
        imprimirColor espacio, 0d
        mov iteradorI, 0d

        ciclo3:
            cmp si, 0
            je filaPar
            cmp si, 1
            je filaPar
            cmp si, 2
            je filaPar
            cmp si, 3
            je caracterVacio
            cmp si, 4
            je caracterVacio
            cmp si, 5
            je token

            regreso:
            imprimirColor individual, color
            inc di
            inc iteradorI
            cmp iteradorI, 8d
            jz reinicio

            imprimirColor espacio, 0d
            mov bl, lineas[0]
            mov individual, bl
            imprimirColor individual, 15d
            imprimirColor espacio, 0d
            jmp ciclo3

        caracterVacio:
            mov individual, " "
            jmp regreso

        token:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moverCeldaImpar

            regresoImpar:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validarImpar
            mov individual, " "
            jmp regreso

        moverCeldaImpar:
            cmp di, 0
            je incrementaImpar
            jmp regresoImpar

        validarImpar:
            mov color, 14d
            mov individual[0], "B"
            cmp si, 5
            je llenarFila
            cmp si, 7
            je llenarFila

        llenarFila:
            mov pointer1, si
            dec di
            mov pointer2, di
            

        filaPar:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moverCelda

            regresoPar:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validarPar
            mov individual, " "
            jmp regreso

        moverCelda:
            cmp di, 0
            je incrementaImpar
            jmp regresoPar

        incrementaImpar:
            inc di
            jmp regresoPar

        reinicio:
            cmp si, 8d
            jz reinicio2

        reinicio2:
            imprimirColor salto, 0d
            inc si
            inc iteradorK
            cmp si, 8d
            jnz ciclo2
endm