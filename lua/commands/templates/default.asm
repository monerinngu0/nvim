default rel

%include "io.asm"

section .data

section .text
    global main

main:
    sub rsp, 8${CURSOR}
    add rsp, 8
    xor eax, eax
    ret
