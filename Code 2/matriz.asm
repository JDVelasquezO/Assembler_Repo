include macros.asm

.model small

.stack 64h

.data
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"
    pregunta db "Escoge tu coordenada de origen$"
    pregunta2 db "Escoge tu coordenada de destino$"
    error db "Error de coordenadas de origen$"
    error2 db "Error de coordenadas de destino$"
    mensajeTurnoBlanco db "Turno de blancos:$"
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
    bufferP1 db 3 dup("$"), "$"
    bufferP2 db 3 dup("$"), "$"

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
        imprimir mensajeTurnoBlanco, 15d
        ImprimirEspacio al
        xor di, di
        xor si, si
        xor bx, bx

        imprimir pregunta, 15d
        ImprimirEspacio al
        leerHastaEnter bufferP1

        mov ah, bufferP1[0]
        mov ch, bufferP1[2]

        asignarCoordenadasOrigen

        ; Imprimir16bits si

        cmp tablero[si], 1d
        je seguirJugando
        jmp errorCasillas

        seguirJugando:
        ; imprimir ok, 15d
        ImprimirEspacio al
        imprimir pregunta2, 15d
        ImprimirEspacio al
        leerHastaEnter bufferP2
        xor ax, ax
        xor cx, cx
        xor bx, bx
        xor di, di

        mov ah, bufferP2[0]
        mov ch, bufferP2[2]

        asignarCoordenadasDestino
        cmp tablero[bx], 0d
        je moverFicha
        jmp errorDestino

        moverFicha:
        mov tablero[bx], 1d
        mov tablero[si], 0d
        imprimir ok, 15d

        ImprimirEspacio al
        xor di, di
        xor bx, bx
        reImprimirMatriz

        jmp fin

        errorDestino:
        imprimir error2, 15d
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
