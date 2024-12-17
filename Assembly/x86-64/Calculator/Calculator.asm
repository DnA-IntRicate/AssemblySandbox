; System call constants
SYS_EXIT equ 60

section .data
    numA dq 400
    numB dq 10
    msg db "Hello there! My name is Jeff, I like fish curry and hate Roblox kids!", 0xA

section .text
    global _start
    extern Print
    extern PrintInt64

; Returns the sum of 2 integers
AddInt64:
    ; rcx = numA
    ; rdx = numB
    ; rax = Return value
    push rbp        ; Save the caller's stack base pointer to preserve the caller's stack frame
    mov rbp, rsp    ; Copy the stack pointer into the base pointer to establish this function's stack frame
    sub rsp, 16     ; Allocate space on the stack aligned to 16 bytes

    mov rax, rcx
    add rax, rdx

    mov rsp, rbp    ; Restore the stack pointer
    pop rbp         ; Restore the caller's stack frame
    ret

_start:
    lea rsi, [msg]
    call Print

    mov rcx, [numA]
    mov rdx, [numB]
    call AddInt64

    mov rcx, rax
    ; mov rcx, 21
    call PrintInt64

    ; Print a newline
    mov byte [rsi], 0xA
    mov byte [rsi + 1], 0x0
    call Print

    ; return 0;
    mov rax, SYS_EXIT
    xor rdi, rdi
    syscall
