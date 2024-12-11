.globl main

.data
    SYS_WRITE_INT: .byte 1
    SYS_WRITE: .byte 4
    SYS_READ_INT: .byte 5
    SYS_READ: .byte 8
    SYS_EXIT: .byte 10

    NEWLINE: .asciiz "\n"
    prompt1: .asciiz "Enter a number: "
    prompt2: .asciiz "Enter another number: "

.text
    # Print a string with a trailing newline
    Print:
        # $a0 = the string to print
        lb $v0, SYS_WRITE
        syscall
        la $a0, NEWLINE
        syscall
        jr $ra

    # Print an integer with a trailing newline
    PrintInt:
        # $a0 = the integer to print
        lb $v0, SYS_WRITE_INT
        syscall
        lb $v0, SYS_WRITE
        la $a0, NEWLINE
        syscall
        jr $ra

    # Read integer input from the user
    InputInt:
        # $a0 = the input prompt
        # $t0 = return value
        lb $v0, SYS_WRITE
        syscall
        lb $v0, SYS_READ_INT
        syscall             # User-inputted integer should now be in $v0
        move $t0, $v0
        jr $ra

    # Adds 2 integers together
    Sum:
        # $a0 = integer a
        # $a1 = integer b
        # $t0 = return value
        add $t0, $a0, $a1
        jr $ra

    main:
        addi $sp, $sp, -8    # Allocate 8 bytes of stack space

        # Get the first number from the user and push it onto the stack
        la $a0, prompt1
        jal InputInt
        sw $t0, 0($sp)

        # Get the second number from the user and push it onto the stack
        la $a0, prompt2
        jal InputInt
        sw $t0, 4($sp)

        # Add the 2 numbers together
        lw $a0, 0($sp)
        lw $a1, 4($sp)
        jal Sum

        # Print the sum of the 2 numbers
        move $a0, $t0
        jal PrintInt

        addi $sp, $sp, 8    # Deallocate stack space
        lb $v0, SYS_EXIT
        syscall
