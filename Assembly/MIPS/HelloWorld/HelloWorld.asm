.globl main

.data
    msg: .asciiz "Hello World!\n"

.text
    main:
        li $v0, 4   # Print String
        la $a0, msg
        syscall

        li $v0, 10  # Sys exit
        syscall
