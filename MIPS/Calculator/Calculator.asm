.globl main

.data
    SYS_WRITE_INT: .byte 1
    SYS_WRITE: .byte 4
    SYS_READ_INT: .byte 5
    SYS_READ: .byte 8
    SYS_EXIT: .byte 10

    OP_ADD: .word 1
    OP_SUB: .word 2
    OP_MUL: .word 3
    OP_DIV: .word 4
    OP_MOD: .word 5
    OP_EXIT: .word 6

    NEWLINE: .asciiz "\n"
    prompt1: .asciiz "Enter a number: "
    prompt2: .asciiz "Enter another number: "
    prompt3: .asciiz "Enter the operation to use:\n1 - Addition\n2 - Subtraction\n3 - Multiplication\n4 - Division\n5 - Modulo\n6 - Exit\n"
    outputStr: .asciiz "\nThe answer is: "

.text
    # Print a string
    Print:
        # $a0 = the string to print
        # $a1 = 1 if this string should have a trailing newline, otherwise 0
        lb $v0, SYS_WRITE
        syscall

        beq $a1, 1, NewLine
        jr $ra

        NewLine:
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

    main:
        addi $sp, $sp, -8    # Allocate 8 bytes of stack space

        MainLoop:
            # Get the first number from the user and push it onto the stack
            la $a0, prompt1
            jal InputInt
            sw $t0, 0($sp)

            # Get the second number from the user and push it onto the stack
            la $a0, prompt2
            jal InputInt
            sw $t0, 4($sp)

            # Get the user's desired mathematical operation
            la $a0, prompt3
            jal InputInt

            # If-else-if chain
            lw $t1, OP_ADD
            beq $t0, $t1, Add
            lw $t1, OP_SUB
            beq $t0, $t1, Sub
            lw $t1, OP_MUL
            beq $t0, $t1, Mul
            lw $t1, OP_DIV
            beq $t0, $t1, Div
            lw $t1, OP_MOD
            beq $t0, $t1, Mod
            lw $t1, OP_EXIT
            beq $t0, $t1, Exit

            # Add the numbers
            Add:
                lw $t1, 0($sp)
                lw $t2, 4($sp)
                add $t0, $t1, $t2
                j Output

            # Subtract the one number from the other
            Sub:
                lw $t1, 0($sp)
                lw $t2, 4($sp)
                sub $t0, $t1, $t2
                j Output

            # Multiply the numbers
            Mul:
                lw $t1, 0($sp)
                lw $t2, 4($sp)
                mult $t1, $t2
                mflo $t0
                j Output

            # Divide the one number by the other
            Div:
                lw $t1, 0($sp)
                lw $t2, 4($sp)
                div $t1, $t2
                mflo $t0
                j Output

            # Divide the one number by the other and return the modulo
            Mod:
                lw $t1, 0($sp)
                lw $t2, 4($sp)
                div $t1, $t2
                mfhi $t0
                j Output

            # Print the result and continue the main loop
            Output:
                la $a0, outputStr
                xor $a1, $a1, $a1
                jal Print

                move $a0, $t0
                jal PrintInt

                la $a0, NEWLINE
                xor $a1, $a1, $a1
                jal Print

                j MainLoop

        # Exit the program
        Exit:
            addi $sp, $sp, 8    # Deallocate stack space
            lb $v0, SYS_EXIT
            syscall
