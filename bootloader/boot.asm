org 7C00H

BASE_OF_STACK    EQU 7C00H

BASE_OF_LOADER   EQU 1000H
OFFSET_OF_LOADER EQU 0000H ; 1000H << 4 + 0H = 10000H

NUM_ROOT_DIR_SECTORS   EQU 14
SECTOR_ROOT_DIR_START  EQU 19
SECTOR_FAT1_START      EQU 1

start:
    ; ------- init the register -------
    mov ax, cs
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, BASE_OF_STACK

    ; ------- scroll up window -------
    mov ax, 0600H  ; function code
    mov bx, 0700H  ; set the background to grey
    mov cx, 0000H  ; upper row and left column number
    mov dx, 184FH  ; lower row and right column number
    int 10H

    ; ------- set cursor position -------
    mov ax, 0200H  ; function code
    mov bx, 0000H  ; set page number(bh) to 0
    mov dx, 0021H  ; set row and column
    int 10H

    ; ------- display on screen -------
    mov ax, 1301H  ; write string, cursor moved
    mov bx, 000BH  ; video page number = 0, color is light cyan(0x0B)
    mov dx, 0310H  ; row and column coordinate
    mov cx, 15     ; length of string
    push ax
    mov ax, ds     ; ds:bp = pointer to string
    mov es, ax
    pop ax
    mov bp, boot_message
    int 10H

    ; ------ reset floppy ------
    xor ah, ah
    xor dl, dl
    int 13H
    jmp $

boot_message:
    db "MuOS is booting"

    times 510 - ($ - $$) db 0
    dw 0xAA55