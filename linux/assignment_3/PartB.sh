#!/bin/bash

# Check if an argument is provided
if [ -z "$1" ]; then
    echo "Please provide a number."
    exit 1
fi

# Read the number from the argument
number=$1

# Check divisibility and print the appropriate output
if [ $((number % 15)) -eq 0 ]; then
    echo "tomcat"
elif [ $((number % 5)) -eq 0 ]; then
    echo "cat"
elif [ $((number % 3)) -eq 0 ]; then
    echo "tom"
else
    echo "The number $number is not divisible by 3, 5 and 15."
fi
