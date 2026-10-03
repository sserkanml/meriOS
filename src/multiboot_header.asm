section .multiboot
align 8 


header_start:
    dd 0xE85250D6       ; Magic number
    dd 0x00000000       ; Architecture (0 for i386)
    dd header_end - header_start ; Header length
    dd -(0xE85250D6 + 0 + (header_end - header_start))  ; checksum

    dw 0    ; type
    dw 0    ; flags
    dd 8    ; type

header_end: