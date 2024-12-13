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
    OP_POW: .word 6
    OP_EXIT: .word 7

    NEWLINE: .asciiz "\n"
    prompt1: .asciiz "Enter the operation to use:\n1 - Addition\n2 - Subtraction\n3 - Multiplication\n4 - Division\n5 - Modulo\n6 - Power\n7 - Exit\n"
    prompt2: .asciiz "Enter a number: "
    prompt3: .asciiz "Enter another number: "
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
        nop

        NewLine:
            la $a0, NEWLINE
            syscall

        jr $ra
        nop

    # Print an integer with a trailing newline
    PrintInt:
        # $a0 = the integer to print
        lb $v0, SYS_WRITE_INT
        syscall

        lb $v0, SYS_WRITE
        la $a0, NEWLINE
        syscall

        jr $ra
        nop

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
        nop

    main:
        addi $sp, $sp, -12    # Allocate 12 bytes of stack space

        MainLoop:
            # Get the user's desired mathematical operation
            la $a0, prompt1
            jal InputInt
            nop
            sw $t0, 0($sp)

            # If the user chose to exit
            lw $t1, OP_EXIT
            beq $t0, $t1, Exit

            # Get the first number from the user and push it onto the stack
            la $a0, prompt2
            jal InputInt
            nop
            sw $t0, 4($sp)

            # Get the second number from the user and push it onto the stack
            la $a0, prompt3
            jal InputInt
            nop
            sw $t0, 8($sp)

            # If-else-if chain
            lw $t0, 0($sp)
            lw $t1, OP_ADD
            beq $t0, $t1, Add
            nop
            lw $t1, OP_SUB
            beq $t0, $t1, Sub
            nop
            lw $t1, OP_MUL
            beq $t0, $t1, Mul
            nop
            lw $t1, OP_DIV
            beq $t0, $t1, Div
            nop
            lw $t1, OP_MOD
            beq $t0, $t1, Mod
            nop
            lw $t1, OP_POW
            beq $t0, $t1, Pow
            nop

            # Add the numbers
            Add:
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                add $t0, $t1, $t2
                j Output
                nop

            # Subtract the one number from the other
            Sub:
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                sub $t0, $t1, $t2
                j Output
                nop

            # Multiply the numbers
            Mul:
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                mult $t1, $t2
                mflo $t0
                j Output
                nop

            # Divide the one number by the other
            Div:
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                div $t1, $t2
                mflo $t0
                j Output
                nop

            # Divide the one number by the other and return the modulo
            Mod:
                lw $t1, 4($sp)
                lw $t2, 8($sp)
                div $t1, $t2
                mfhi $t0
                j Output
                nop

            # Raise the one number to the power of the other number
            Pow:
                lw $t1, 4($sp)
                lw $t2, 8($sp)      # The power we are raising to
                li $t0, 1
                beq $t2, $zero, Output   # Handle if the power is 0
                nop

                PowerLoop:
                    mul $t0, $t0, $t1
                    addi $t2, $t2, -1
                    bne $t2, $zero, PowerLoop   # Loop till $t2 == 0
                    nop

                j Output
                nop

            # Print the result and continue the main loop
            Output:
                la $a0, outputStr
                xor $a1, $a1, $a1
                jal Print
                nop

                move $a0, $t0
                jal PrintInt
                nop

                la $a0, NEWLINE
                xor $a1, $a1, $a1
                jal Print
                nop

                j MainLoop
                nop

        # Exit the program
        Exit:
            addi $sp, $sp, 12    # Deallocate stack space
            lb $v0, SYS_EXIT
            syscall
