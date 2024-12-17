#!/bin/bash

while true
do
    echo -e "Enter the operation to use:\n1 - Addition\n2 - Subtraction\n3 - Multiplication\n4 - Division\n5 - Modulo\n6 - Power\n7 - Exit"
    read operation

    if [[ "$operation" == "7" ]]; then
        break
    fi

    echo -n "Enter a number: "
    read numA
    echo -n "Enter another number: "
    read numB

    ans=0
    if [[ "$operation" == "1" ]]; then
        ans=$((numA + numB))
    elif [[ "$operation" == "2" ]]; then
        ans=$((numA - numB))
    elif [[ "$operation" == "3" ]]; then
        ans=$((numA * numB))
    elif [[ "$operation" == "4" ]]; then
        ans=$((numA / numB))
    elif [[ "$operation" == "5" ]]; then
        ans=$((numA % numB))
    elif [[ "$operation" == "6" ]]; then
        ans=$((numA ** numB))
    fi

    echo -e "\nThe answer is: $ans.\n"
done
