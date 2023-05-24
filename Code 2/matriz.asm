include macros.asm

.model small

.stack 64h

.data
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"
    pregunta db "Escoge tu coordenada$"
    error db "Error de coordenadas de origen$"
    error2 db "Error de coordenadas de destino$"
    errorVertical db "Movimiento vertical prohibido$"
    errorHorizontal db "Movimiento horizontal prohibido$"
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
    bufferP1 db 5 dup("$"), "$"

    fila1 dw 0
    columna1 dw 0
    fila2 dw 0
    columna2 dw 0

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

        imprimir pregunta, 15d  ; Pregunta coordenadas de origen
        ImprimirEspacio al
        leerHastaEnter bufferP1

        xor cx, cx
        xor dx, dx

        mov cl, bufferP1[0]     ; Recibe coordenadas de origen y destino
        mov ch, bufferP1[1]
        mov dl, bufferP1[3]
        mov dh, bufferP1[4]

        ; Pregunta si las coordenadas son iguales
        cmp ch, dh
        je malMovimientoVertical

        cmp cl, dl
        je malMovimientoHorizontal

        asignarCoordenadasOrigen
        cmp tablero[si], 1d
        je seguirJugando
        jmp errorCasillas

        seguirJugando:
        asignarCoordenadasDestino
        ; Imprimir16bits bx
        cmp tablero[bx], 0d
        je moverFicha
        jmp errorDestino

        moverFicha:
        xor bx, bx
        xor di, di

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
        jmp fin

        malMovimientoVertical:
        imprimir errorVertical, 15d
        jmp fin

        malMovimientoHorizontal:
        imprimir errorHorizontal, 15d

        fin:

        ; printRegister bl
        ; ImprimirEspacio al
        ; Imprimir16bits di

        mov ax, 4C00H
        INT 21H
    main endp
end
