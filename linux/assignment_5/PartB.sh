#!/bin/bash

# Function to add a line at the top of a file
addLineTop() {
    file=$1
    line=$2

    if [[ -f "$file" ]]; then
        sed -i "1i $line" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to add a line at the bottom of a file
addLineBottom() {
    file=$1
    line=$2

    if [[ -f "$file" ]]; then
        echo "$line" >> "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to add a line at a specific line number
addLineAt() {
    file=$1
    lineNumber=$2
    line=$3

    if [[ -f "$file" ]]; then
        if ! [[ "$lineNumber" =~ ^[0-9]+$ ]] || [[ "$lineNumber" -lt 1 ]]; then
            echo "Invalid line number."
            exit 1
        fi
        sed -i "${lineNumber}i $line" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to replace the first occurrence of a word in a file
updateFirstWord() {
    file=$1
    word=$2
    word2=$3

    if [[ -f "$file" ]]; then
        sed -i "0,/$word/s//$word2/" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to replace all occurrences of a word in a file
updateAllWords() {
    file=$1
    word=$2
    word2=$3

    if [[ -f "$file" ]]; then
        sed -i "s/$word/$word2/g" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to insert a word at a specific position
insertWord() {
    file=$1
    word1=$2
    word2=$3
    insertWord=$4

    if [[ -f "$file" ]]; then
        sed -i "0,/$word1/s//${word1} $insertWord $word2/" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to delete a specific line from a file
deleteLine() {
    file=$1
    lineNumber=$2

    if [[ -f "$file" ]]; then
        if ! [[ "$lineNumber" =~ ^[0-9]+$ ]] || [[ "$lineNumber" -lt 1 ]]; then
            echo "Invalid line number."
            exit 1
        fi
        sed -i "${lineNumber}d" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Function to delete a line containing a specific word
deleteLineContainingWord() {
    file=$1
    word=$2

    if [[ -f "$file" ]]; then
        sed -i "/$word/d" "$file"
        echo "Updated content of $file:"
        cat "$file"
    else
        echo "File does not exist."
        exit 1
    fi
}

# Handle command line arguments
command=$1
shift

case "$command" in
    addLineTop)
        addLineTop "$@"
        ;;
    addLineBottom)
        addLineBottom "$@"
        ;;
    addLineAt)
        addLineAt "$@"
        ;;
    updateFirstWord)
        updateFirstWord "$@"
        ;;
    updateAllWords)
        updateAllWords "$@"
        ;;
    insertWord)
        insertWord "$@"
        ;;
    deleteLine)
        deleteLine "$@"
        ;;
    deleteLineContainingWord)
        deleteLineContainingWord "$@"
        ;;
    *)
        echo "Invalid command."
        exit 1
        ;;
esac
