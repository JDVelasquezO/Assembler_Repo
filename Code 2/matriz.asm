include macros.asm

.model small

.stack 64h

.data
    cabecerasF db "12345678$"
    cabecerasC db "ABCDEFGH$"
    espacio db " $"
    individual db " $"
    lineas db "|-$"
    salto db 0ah, "$"
    iteradorI dw 0
    iteradorJ dw 0
    iteradorK dw 0
    pointer1 dw 0
    pointer2 dw 0

.code
    main proc
        mov ax, @data
        mov ds, ax

        imprimirMatriz

    main endp
end