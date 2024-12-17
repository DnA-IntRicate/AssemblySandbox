; System call constants
SYS_WRITE equ 1
SYS_EXIT equ 60

; File descriptors
STDIN equ 0
STDOUT equ 1
STDERR equ 2

section .text
    global Print
    global PrintInt64

; Print a null-terminated string
Print:
    ; rsi = null-terminated string to print
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rdx, rsi        ; load string into rdx for calculating its length
    xor rcx, rcx        ; rcx will be the control register of the loop to find the length of the string in rsi

    .FindLength:
        cmp byte [rdx + rcx], 0     ; Have we reached the null terminator?
        je .EndOfString             ; If so, jump to .EndOfString
        inc rcx                     ; increment the loop counter
        jmp .FindLength             ; jump to top of loop (continue)

        .EndOfString:
            ; At this stage rcx now contains the length of the string
            mov rdx, rcx        ; copy length into rdx for sys_write
            syscall
            ret                 ; Return to caller

; Print a 64-bit integer
PrintInt64:
    ; rcx = int64 to print
    push rbp
    mov rbp, rsp
    sub rsp, 16

    xor rdx, rdx
    mov rax, rcx
    mov rbx, 10             ; Base 10
    lea rsi, [rsp + 16]     ; Pointer to end of buffer
    mov byte [rsi], 0       ; Null-terminate string

    ; Reverse-iterating conversion loop
    .Convert:
        dec rsi
        xor rdx, rdx
        div rbx
        add dl, '0'
        mov byte [rsi], dl
        test rax, rax
        jnz .Convert

    ;    xor rdx, rdx
    ;    div rbx         ; Divide rax by 10 (value in rbx), store modulo in rdx
    ;    add dl, '0'     ; Convert modulo to ASCII
    ;    mov byte [rsp], dl
    ;    test rax, rax
    ;    jnz .Convert    ; Jump not zero (rax)

    call Print

    mov rsp, rbp
    pop rbp
    ret

