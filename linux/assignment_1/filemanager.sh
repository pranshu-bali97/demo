#!/bin/bash

while true;do
    echo "File Manager Utility"
    echo "1. Create a Directory"
    echo "2. Delete a Directory"
    echo "3. List Content of a Directory"
    echo "4. List Only Files in a Directory"
    echo "5. List Only Directories in a Directory"
    echo "6. List All (Files and Directories)"
    echo "7. Create a File"
    echo "8. Add Content to a File"
    echo "9. Add Content at Beginning of a File"
    echo "10. Show Top N Lines of a File"
    echo "11. Show Last N Lines of a File"
    echo "12. Show Specific Line Number in File"
    echo "13. Show Line Range in File"
    echo "14. Move/Copy a File"
    echo "15. Delete a File"
    echo "16. Exit"
    echo "Choose an option:"
    read choice

    if [ "$choice" -eq 1 ]; then
        echo "Enter directory name to create:"
        read dir_name
        mkdir "$dir_name" && echo "Directory created: $dir_name"

    elif [ "$choice" -eq 2 ]; then
        echo "Enter directory name to delete:"
        read dir_name
        rmdir "$dir_name" && echo "Directory deleted: $dir_name"

    elif [ "$choice" -eq 3 ]; then
        echo "Enter directory to list contents:"
        read dir_name
        ls "$dir_name"

    elif [ "$choice" -eq 4 ]; then
        echo "Enter directory to list files:"
        read dir_name
        find "$dir_name" -maxdepth 1 -type f

    elif [ "$choice" -eq 5 ]; then
        echo "Enter directory to list directories:"
        read dir_name
        find "$dir_name" -maxdepth 1 -type d

    elif [ "$choice" -eq 6 ]; then
        echo "Enter directory to list all (files and directories):"
        read dir_name
        ls -l "$dir_name"

    elif [ "$choice" -eq 7 ]; then
        echo "Enter file name to create:"
        read file_name
        touch "$file_name" && echo "File created: $file_name"

    elif [ "$choice" -eq 8 ]; then
        echo "Enter file name to add content:"
        read file_name
        echo "Enter the content:"
        read content
        echo "$content" >> "$file_name" && echo "Content added"

    elif [ "$choice" -eq 9 ]; then
        echo "Enter file name to add content at the beginning:"
        read file_name
        echo "Enter the content:"
        read content
        echo -e "$content\n$(cat "$file_name")" > "$file_name" && echo "Content added at the beginning"

    elif [ "$choice" -eq 10 ]; then
        echo "Enter file name:"
        read file_name
        echo "Enter number of top lines to display:"
        read n
        head -n "$n" "$file_name"

    elif [ "$choice" -eq 11 ]; then
        echo "Enter file name:"
        read file_name
        echo "Enter number of last lines to display:"
        read n
        tail -n "$n" "$file_name"

    elif [ "$choice" -eq 12 ]; then
        echo "Enter file name:"
        read file_name
        echo "Enter the line number to display:"
        read line_num
        head -n "$line_num" "$file_name" | tail -n 1

    elif [ "$choice" -eq 13 ]; then
        echo "Enter file name:"
        read file_name
        echo "Enter the start line number:"
        read start
        echo "Enter the end line number:"
        read end
        head -n "$end" "$file_name" | tail -n +$start

    elif [ "$choice" -eq 14 ]; then
        echo "Enter Source file name"
        read sourcefile_name
        echo "Enter Destination file name:"
        read dest_name 
        echo "For move or copy of the file.Please select the m for move and c for copy"
        read opt
        if [ "$opt" == "m" ]; then
            mv "$sourcefile_name" "$dest_name" && echo "File moved"
        elif [ "$opt" == "c" ]; then
            cp "$sourcefile_name" "$dest_name" && echo "File copied"
        else
            echo "Invalid option"
        fi

    elif [ "$choice" -eq 15 ]; then
        echo "Enter file name to delete:"
        read file_name
        rm "$file_name" && echo "File deleted"

    elif [ "$choice" -eq 16 ]; then
        echo "Exiting..."
        exit 0
    fi
done
