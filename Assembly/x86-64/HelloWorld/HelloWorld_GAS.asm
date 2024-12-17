.intel_syntax noprefix

.section .data
	msg: .asciz "Hello, World!\n"
	msgLen = . - msg

.section .text
.global _start
_start:
	// Print msg
	mov rax, 1
	mov rdi, 1
	lea rsi, [msg]
	mov rdx, msgLen
	syscall

	// sys_exit
	mov rax, 60
	xor rdi, rdi
	syscall
