#!/bin/bash

# Check for correct number of arguments
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <size> <type>"
    exit 1
fi

size=$1
type=$2

# Check if size is a valid positive integer
if ! [[ "$size" =~ ^[0-9]+$ ]] || [ "$size" -le 0 ]; then
    echo "Error: Size must be a positive integer."
    exit 1
fi

# Print star pattern based on type
case $type in
    t1)
        for (( i=1; i<=size; i++ )); do
            # Print leading spaces for right-aligned triangle
            printf '%*s' "$((size - i))" ""
            # Print stars
            printf '%0.s*' $(seq 1 "$i")
            echo  # Move to the next line
        done
        ;;
    t2)
        for (( i=1; i<=size; i++ )); do
            # Print stars for left-aligned triangle
            printf '%0.s*' $(seq 1 "$i")
            echo  # Move to the next line
        done
        ;;
    t3)
        for (( i=0; i<size; i++ )); do
            # Print leading spaces for centered triangle
            printf '%*s' "$((size - i))" ""
            # Print stars (odd number)
            printf '%0.s*' $(seq 1 "$((2 * i + 1))")
            echo  # Move to the next line
        done
        ;;
    t4)
        for (( i=size; i>=1; i-- )); do
            # Print stars for inverted triangle
            printf '%0.s*' $(seq 1 "$i")
            echo  # Move to the next line
        done
        ;;
    t5)
        for (( i=size; i>=1; i-- )); do
            # Print leading spaces for right-aligned inverted triangle
            printf '%*s' "$((size - i + 1))" ""
            # Print stars
            printf '%0.s*' $(seq 1 "$i")
            echo  # Move to the next line
        done
        ;;
    t6)
        for (( i=0; i<size; i++ )); do
            # Print leading spaces for centered hollow pyramid
            printf '%*s' "$((size - i))" ""
            # Print stars
            if [ "$i" -eq 0 ]; then
                printf '%0.s*' $(seq 1 "$((2 * size - 1))")  # Full line of stars for the first row
            else
                printf '*'
                if [ "$i" -lt "$((size - 1))" ]; then
                    printf '%*s' "$((2 * (size - i - 1) - 1))" ""  # Spaces in the middle
                    printf '*'
                fi
            fi
            echo  # Move to the next line
        done
        ;;
    t7)
        # Print the top part of the diamond
        for (( i=0; i<size; i++ )); do
            # Print leading spaces for centered pyramid
            printf '%*s' "$((size - i))" ""
            # Print stars (odd number)
            printf '%0.s*' $(seq 1 "$((2 * i + 1))")
            echo  # Move to the next line
        done
        
        # Print the bottom part of the diamond
        for (( i=size-1; i>0; i-- )); do
            # Print leading spaces for centered inverted pyramid
            printf '%*s' "$((size - i + 1))" ""
            # Print stars (odd number)
            printf '%0.s*' $(seq 1 "$((2 * i - 1))")
            echo  # Move to the next line
        done
        ;;
    *)
        echo "Unknown pattern type: $type"
        exit 1
        ;;
esac
