#!/bin/bash

# Function to create a new tag
create_tag() {
    local tag_name="$1"
    if [ -z "$tag_name" ]; then
        echo "Tag name is required."
        exit 1
    fi
    
    # Create the tag
    git tag "$tag_name"
    echo "Tag '$tag_name' created."
}

# Function to list tags
list_tags() {
    echo "Listing tags:"
    git tag
}

# Function to delete a tag
delete_tag() {
    local tag_name="$1"
    if [ -z "$tag_name" ]; then
        echo "Tag name is required."
        exit 1
    fi
    
    # Delete the tag
    git tag -d "$tag_name"
    echo "Tag '$tag_name' deleted."
}

# Function to get user input
get_user_choice() {
    echo "Choose an option:"
    echo "1. Create a new tag"
    echo "2. List tags"
    echo "3. Delete a tag"
    echo "4. Exit"
    read -p "Enter your choice (1,2,3 or 4): " choice

    case $choice in
        1) 
            read -p "Enter the tag name: " tag_name
            create_tag "$tag_name" ;;
        2) 
            list_tags ;;
        3) 
            read -p "Enter the tag name to delete: " tag_name
            delete_tag "$tag_name" ;;
        4) 
            echo "Exiting."
            exit 0 ;;
        *) 
            echo "Invalid option.Please try again.!"
            get_user_choice ;;
    esac
}

# Main script execution
get_user_choice
