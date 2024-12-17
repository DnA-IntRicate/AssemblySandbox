global _start

; System calls
SYS_WRITE equ 1
SYS_EXIT equ 60

; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

section .data
    msg db "Hello, World!", 0xA
    msgLen equ $ - msg

section .text
_start:
    ; print msg
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    lea rsi, [msg]
    mov rdx, msgLen
    syscall

    ; return 0
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
