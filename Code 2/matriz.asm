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
    printReport db "Generando reporte...$"
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

    fila1 dw 0
    columna1 dw 0
    fila2 dw 0
    columna2 dw 0

    input db "reporte.htm", 00h ; nombre del archivo
    handle dw ? ; ? significa que puede guardar cualquier valor

    ; Cabecera de HTML
    doctype db "<!DOCTYPE html> $", 13, 10
    lang db "<html> $", 13, 10
    initHead db "<head> $", 13, 10
    metaCharset db "<meta charset=", 34, "UTF-8", 34, "> $", 13, 10
    linkBulma db "<link rel=", 34, "stylesheet", 34, "href=", 34, "https://cdn.jsdelivr.net/npm/bulma@0.9.3/css/bulma.min.css", 34, "> $", 13, 10
    titleReports db "<title>Reports</title> $", 13, 10
    finHead db "</head> $", 13, 10

    ; Cuerpo de HTML
    initBody db "<body> $", 13, 10

    ; Cabecera del Cuerpo
    initHeader db "<header> $", 13, 10
    initNav db "<nav class=", 34, "navbar has-background-link", 34, " role=", 34, "navigation", 34, " aria-label=", 34, "main navigation", 34, "> $", 13, 10
    initNavbar db "<div class=", 34, "navbar-brand", 34, "> $", 13, 10
    titleBody db "<h1 class=", 34, "title has-text-white", 34, ">Reportes</h1>", "$", 13, 10
    endNavbar db "</div> $", 13, 10
    endNav db "</nav> $", 13, 10
    endHeader db "</header> $", 13, 10

    ; Main del Cuerpo
    initMain db "<main class=", 34, "container mt-6", 34,"> $",13, 10
    initCols db "<div class=",34,"columns",34,"> $", 13, 10
    initTableCol db "<table class=",34,"column table", 34, "> $", 13, 10

    initTbody db "<tbody> $", 13, 10
    endTbody db "</tbody> $", 13, 10

    endTableCol db "</table> $", 13, 10
    endCols db "</div> $",13, 10
    endMain db "</main> $", 13, 10

    endBody db "</body> $",13, 10
    endHtml db "</html> $", 13, 10

    tdColor db "<td class=", 34, "has-background-grey-light", 34, "> $", 13, 10

    initColTable db "<div class=", 34, "column", 34,"> $", 13, 10
    endColTable db "</div> $", 13, 10
    labelTable db "<p class=", 34, "subtitle", 34,">Tablero</p>"
    tabForTable db "<table class=", 34, "table is-bordered", 34,"> $",13, 10

    initRowPlayers db "<tr> $",13, 10
    endRowPlayers db "</tr> $", 13, 10

    initTd db "<td> $"
    endTd db "</td> $"
.code
    main proc
        mov ax, @data
        mov ds, ax

        imprimirMatriz

        turnoBlanco:
        imprimir mensajeTurnoBlanco, 15d
        ImprimirEspacio al

        imprimir pregunta, 15d  ; Pregunta coordenadas de origen
        ImprimirEspacio al
        leerHastaEnter bufferP1

        xor bx, bx
        xor di, di
        xor si, si
        xor ax, ax
        
        mov ah, bufferP1[1]     ; Recibe coordenadas de origen y destino
        mov al, bufferP1[0]
        mov bh, bufferP1[4]
        mov bl, bufferP1[3]
        
        ; Pregunta si las coordenadas son iguales
        cmp ah, bh
        je malMovimientoHorizontal

        cmp al, bl
        je malMovimientoVertical

        asignarCoordenadas

        xor di, di
        xor si, si
        xor ax, ax

        obtenerIndice fila1, columna1
        mov si, indice
        cmp tablero[si], 1d
        je seguirJugando
        jmp errorCasillas

        seguirJugando:
        obtenerIndice fila2, columna2
        mov di, indice
        cmp tablero[di], 0d
        je moverFicha
        jmp errorDestino

        moverFicha:
        mov tablero[di], 1d
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
        GenerarReporte

        mov ax, 4C00H
        INT 21H
    main endp
end