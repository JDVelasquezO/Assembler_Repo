include macros.asm

.model small

.stack 64h

.data
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"
    pregunta db "Escoge tu coordenada de destino$"
    error db "Error de coordenadas de origen$"
    ok db "Todo bien$"
    espacio db " $"
    individual db " $"
    lineas db "|-$"
    salto db 0ah, "$"
    iteradorI dw 0
    iteradorJ dw 0
    iteradorK dw 0
    pointer1 dw 0
    pointer2 dw 0
    indice dw 0
    tablero db 64 dup(0), "$"
    pointerGeneral dw 0
    color db 0
    bufferP1 db 50 dup("$"), "$"

    fila dw 0
    columna dw 0

.code
    main proc
        mov ax, @data
        mov ds, ax

        imprimirMatriz

        ; mov fila, 5
        ; mov columna, 1
        ; mov bl, tablero[di]

        turnoBlanco:
        xor di, di
        xor si, si
        xor bx, bx

        imprimir pregunta, 15d
        ImprimirEspacio al
        leerHastaEnter bufferP1

        mov ah, bufferP1[0]
        mov bh, bufferP1[2]

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
            cmp cabecerasC[di], bh
            je asignar2
            inc di
            cmp di, 8d
            jmp ciclo2

        asignar2:
            mov columna, di

        obtenerIndice fila, columna
        mov si, indice

        ; Imprimir16bits si

        cmp tablero[si], 1d
        je seguirJugando
        jmp errorCasillas

        seguirJugando:
        imprimir ok, 15d
        jmp fin

        errorCasillas:
        imprimir error, 15d

        fin:

        ; printRegister bl
        ; ImprimirEspacio al
        ; Imprimir16bits di

        mov ax, 4C00H
        INT 21H
    main endp
end
