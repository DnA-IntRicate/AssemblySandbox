; System call constants
SYS_READ equ 0
SYS_WRITE equ 1
SYS_EXIT equ 60

; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

section .text
    global _start

_start:
    ; Establish stack frame
    push rbp
    mov rbp, rsp
    sub rsp, 16         ; Allocate 16 bytes on the stack, this gives space for a 16-char string to be inputted

    ; Read input from the user
    mov rax, SYS_READ
    mov rdi, STDIN
    lea rsi, [rsp]
    mov rdx, 16
    syscall

    ; Print the input back to the user
    mov rax, SYS_WRITE
    mov rdi, STDOUT         
    syscall             ; No need to reload rsi and rdx here

    ; Restore stack frame
    mov rsp, rbp
    pop rbp

    ; return 0
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
