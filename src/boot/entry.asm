bits 32

global _start

extern kernel_main

section .bss
stack_bottom:
    resb 4096 * 4

section .text    
_start:
    mov esp, stack_bottom + 4096 * 4
    call kernel_main
    jmp $ ; Infinite loop to halt the CPU after kernel_main returns

