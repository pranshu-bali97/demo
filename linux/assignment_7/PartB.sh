#!/bin/bash

# Function to list branches
list_branches() {
    echo "Listing branches:"
    git branch | sed 's/^..//'
}

# Function to create a new branch
create_branch() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Branch name is required."
        exit 1
    fi
    git branch "$branch_name"
    echo "Branch '$branch_name' created."
}

# Function to delete a branch
delete_branch() {
    local branch_name="$1"
    if [ -z "$branch_name" ]; then
        echo "Branch name is required."
        exit 1
    fi
    git branch -d "$branch_name"
    echo "Branch '$branch_name' deleted."
}

# Function to merge two branches
merge_branches() {
    local source_branch="$1"
    local target_branch="$2"
    
    if [ -z "$source_branch" ] || [ -z "$target_branch" ]; then
        echo "Both source and target branch names are required."
        exit 1
    fi
    
    # Switch to target branch
    git checkout "$target_branch"
    
    # Merge source branch into target branch
    git merge "$source_branch"
    echo "Merged '$source_branch' into '$target_branch'."
}

# Function to rebase one branch onto another
rebase_branches() {
    local source_branch="$1"
    local target_branch="$2"
    
    if [ -z "$source_branch" ] || [ -z "$target_branch" ]; then
        echo "Both source and target branch names are required."
        exit 1
    fi
    
    # Checkout the target branch
    git checkout "$target_branch"
    
    # Rebase the source branch onto the target branch
    git rebase "$source_branch"
    echo "Rebased '$source_branch' onto '$target_branch'."
}

# Function to get user input
get_user_choice() {
    echo "Choose an option:"
    echo "1. List branches"
    echo "2. Create a new branch"
    echo "3. Delete a branch"
    echo "4. Merge two branches"
    echo "5. Rebase a branch onto another"
    echo "6. Exit"
    read -p "Enter your choice (1,2,3,4,5 or 6): " choice

    case $choice in
        1) list_branches ;;
        2) 
            read -p "Enter the branch name: " branch_name
            create_branch "$branch_name" ;;
        3) 
            read -p "Enter the branch name to delete: " branch_name
            delete_branch "$branch_name" ;;
        4) 
            read -p "Enter the source branch name: " source_branch
            read -p "Enter the target branch name: " target_branch
            merge_branches "$source_branch" "$target_branch" ;;
        5) 
            read -p "Enter the source branch name for rebase: " source_branch
            read -p "Enter the target branch name to rebase onto: " target_branch
            rebase_branches "$source_branch" "$target_branch" ;;
        6) 
            echo "Exiting."
            exit 0 ;;
        *) 
            echo "Invalid option.Please try again.!"
            get_user_choice ;;
    esac
}

# Main script execution
get_user_choice
