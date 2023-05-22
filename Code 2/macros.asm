imprimir macro cadena, color
    mov ax, @data
    mov ds, ax

    mov ah, 09h
    mov bl, color
    mov cx, lengthof cadena - 1
    int 10h
    lea dx, cadena
    int 21h
endm

printRegister macro register
	push ax
	push dx

	mov dl,register
	add dl,48 		; Se le suma 48 por el codigo ascii
	mov ah,02h
	int 21h

	pop dx
	pop ax
endm

ImprimirEspacio macro registro
	push ax
	push dx

	mov registro, 13
	CrearEspacio al
	mov registro, 10
	CrearEspacio al

	pop dx
	pop ax
endm

imprimirMatriz macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2, regreso1, quitChars, blackToken, moveCellImpair, regresoImpair1, validateImpair, incrementForImpairBlack, incrementForImpair, validateImpair, pairFile, regresoPair1, validatePair, moveCell, fin, fillRow, fillRow2

    imprimir espacio, 0d    ; color negro
    imprimir espacio, 0d
    xor si, si
    ; Ciclo para imprimir las cabeceras de columnas de la matriz
    ciclo:
        ; Se mueve hacia una variable que simula un caracter, porque el macro imprimir
        ; realiza la impresion hasta que encuentra el simbolo de final de cadena
        mov bl, cabecerasC[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        imprimir espacio, 0d
        imprimir espacio, 0d
        inc si
        cmp si, 8d
        jnz ciclo

    imprimir salto, 0d
    xor si, si
    mov iteradorK, 0d
    ciclo2: ; Ciclo que imprime las caberas de las filas
        xor di, di
        mov bl, cabecerasF[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        mov iteradorI, 0d

        ciclo3: ;ciclo que imprime los valores de las celdas
            cmp si, 0
            je pairFile
            cmp si, 1
            je pairFile
            cmp si, 2
            je pairFile
            cmp si, 3
            je quitChars
            cmp si, 4
            je quitChars
            cmp si, 5
            je blackToken
            cmp si, 6
            je blackToken
            cmp si, 7
            je blackToken
            mov individual, " "

            ; printRegister ah
            regreso1:
            imprimir individual, color
            inc di
            inc iteradorI

            cmp iteradorI, 8d
            jz reinicio

            imprimir espacio, 0d
            mov bl, lineas[0]
            mov individual[0], bl
            imprimir individual, 15d
            imprimir espacio, 0d
            jmp ciclo3

        quitChars:
            mov individual, " "
            jmp regreso1

        blackToken:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moveCellImpair

            regresoImpair1:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validateImpair
            mov individual, " "
            jmp regreso1

        moveCellImpair:
            cmp di, 0
            je incrementForImpair
            jmp regresoImpair1

        validateImpair:
            mov color, 14d
            mov individual[0], "B"

            cmp si, 5
            je fillRow2
            cmp si, 7
            je fillRow2

            mov pointer1, si
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 1d
            xor di, di
            mov di, pointerGeneral

            jmp regreso1

        fillRow2:
            mov pointer1, si
            dec di
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            inc di
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 1d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        pairFile:
            xor ax, ax
            xor dx, dx
            mov ax, si
            mov bl, 2
            div bl
            cmp ah, 0
            jne moveCell

            regresoPair1:
            xor ax, ax
            xor dx, dx
            mov ax, di
            mov bl, 2
            div bl
            cmp ah, 0
            je validatePair
            mov individual, " "
            jmp regreso1

        moveCell:
            cmp di, 0
            je incrementForImpair
            jmp regresoPair1

        incrementForImpair:
            inc di
            jmp regresoPair1

        validatePair:
            ; inc di
            mov color, 14d
            mov individual[0], "N"

            cmp si, 1
            je fillRow

            mov pointer1, si
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 2d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        fillRow:
            mov pointer1, si
            dec di
            mov pointer2, di
            obtenerIndice pointer1, pointer2
            inc di
            mov pointerGeneral, di
            xor di, di
            mov di, indice
            mov tablero[di], 2d
            xor di, di
            mov di, pointerGeneral
            jmp regreso1

        reinicio: ;ciclo que imprime la linea divisoria entre filas
            ; printRegister ah
            cmp si, 8d
            jz reinicio2
            mov iteradorI, 0d
            imprimir salto, 0d
            imprimir espacio, 0d
            imprimir espacio, 0d
            ciclo4:
                mov bl, lineas[1]
                mov individual[0], bl
                imprimir individual, 15d
                inc iteradorI
                cmp iteradorI, 32d
                jnz ciclo4

        reinicio2:
            imprimir salto, 0d
            inc si
            inc iteradorK
            cmp si, 8d
            jnz ciclo2
    fin:
endm


obtenerIndice macro row, column
    ;posicion[i][j] en el arreglo = i * numero columnas + j
    mov ax, row
    mov bx, 8d
    mul bx
    add ax, column
    mov indice, ax
endm

Imprimir8bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov al,registro
    mov cx,10
    mov bx,3
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,3
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm

Imprimir16bits macro registro
    local cualquiera,noz
    xor ax,ax
    mov ax,registro
    mov cx,10
    mov bx,5
    cualquiera:
    xor dx,dx
    div cx
    push dx
    dec bx
    jnz cualquiera
    mov bx,5
    noz:
    pop dx
    ImprimirNumero dl
    dec bx
    jnz noz
endm

ImprimirNumero macro registro
    push ax
    push dx


    mov dl,registro
    ;ah = 2
    add dl,48
    mov ah,02h
    int 21h


    pop dx
    pop ax
endm

ImprimirEspacio macro registro
	push ax
	push dx

	mov registro, 13
	CrearEspacio al
	mov registro, 10
	CrearEspacio al

	pop dx
	pop ax
endm

CrearEspacio macro registro
	push ax
	push dx

	mov dl,registro
	mov ah,02h
	int 21h

	pop dx
	pop ax
endm

getIn macro
    mov ah, 01h
    int 21h
endm

leerHastaEnter macro entrada
    local salto, fin

    xor bx, bx ;Limpiando el registro
    salto:
        mov ah, 01h
        int 21h
        cmp al, 0dh ;Verificar si es un salto de linea lo que se esta leyendo
        je fin
        mov entrada[bx], al
        inc bx
        jmp salto

    fin:
        mov al, 24h ;Agregando un signo de dolar para eliminar el salto de linea
        mov entrada[bx], al
endm

asignarCoordenadasOrigen macro
    ciclo:
        cmp cabecerasF[di], ah
        je asignar
        inc di
        cmp di, 8d
        jmp ciclo

    asignar:
        mov fila, di

    xor di, di
    ciclo2:
        cmp cabecerasC[di], ch
        je asignar2
        inc di
        cmp di, 8d
        jmp ciclo2

    asignar2:
        mov columna, di

    obtenerIndice fila, columna
    mov si, indice
endm

asignarCoordenadasDestino macro
    cicloDestino:
        cmp cabecerasF[di], ah
        je asignarDestino
        inc di
        cmp di, 8d
        jmp cicloDestino

    asignarDestino:
        mov fila, di

    xor di, di
    ciclo2Destino:
        cmp cabecerasC[di], ch
        je asignar2Destino
        inc di
        cmp di, 8d
        jmp ciclo2Destino

    asignar2Destino:
        mov columna, di

    obtenerIndice fila, columna
    mov cx, indice
endm

reImprimirMatriz macro
    local ciclo, ciclo2, ciclo3, ciclo4, reinicio, reinicio2, fin

    imprimir espacio, 0d    ; color negro
    imprimir espacio, 0d
    xor si, si
    ; Ciclo para imprimir las cabeceras de columnas de la matriz
    ciclo:
        ; Se mueve hacia una variable que simula un caracter, porque el macro imprimir
        ; realiza la impresion hasta que encuentra el simbolo de final de cadena
        mov bl, cabecerasC[si]
        mov individual[0], bl
        imprimir individual, 15d
        imprimir espacio, 0d
        imprimir espacio, 0d
        imprimir espacio, 0d
        inc si
        cmp si, 8d
        jnz ciclo

        imprimir salto, 0d
        xor si, si
        mov iteradorJ, 0d
        ciclo2: ; Ciclo que imprime las caberas de las filas
            xor di, di
            mov bl, cabecerasF[si]
            mov individual[0], bl
            imprimir individual, 15d
            imprimir espacio, 0d

            mov iteradorI, 0d
            ciclo3: ;ciclo que imprime los valores de las filas
                mov di, iteradorJ
                verificarValor1 tablero[di]
                inc iteradorJ
                imprimir individual, color

                inc iteradorI ;validacion para hacer linea divisioria
                cmp iteradorI, 8d
                jz reinicio

                imprimir espacio, 0d
                mov bl, lineas[0]
                mov individual[0], bl
                imprimir individual, 15d
                imprimir espacio, 0d
                jmp ciclo3

            reinicio: ;ciclo que imprimie la linea divisoria entre filas
                cmp si, 8d
                jz reinicio2
                mov iteradorI, 0d
                imprimir salto, 0d
                imprimir espacio, 0d
                imprimir espacio, 0d
                ciclo4:
                    mov bl, lineas[1]
                    mov individual[0], bl
                    imprimir individual, 15d
                    inc iteradorI
                    cmp iteradorI, 32d
                    jnz ciclo4

            reinicio2:
            imprimir salto, 0d
            inc si
            cmp si, 8d
            jnz ciclo2

    fin:
endm

verificarValor1 macro valor
    local cero, uno, dos, tres, cuatro, fin

    cmp valor, 0
    jz cero

    cmp valor, 1
    jz uno

    cmp valor, 2
    jz dos

    dos:
        mov color, 14d
        mov individual[0], "N"
        jmp fin

    uno:
        mov color, 11d
        mov individual[0], "B"
        jmp fin

    cero:
        mov color, 0d
        mov individual[0], " "

    fin:
endm
