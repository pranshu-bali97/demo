#!/bin/bash

# Function to create users based on input
create_users() {
    echo "Enter usernames to create (space-separated):"
    #Read multiple username into array
    read -a usernames  
    for username in "${usernames[@]}"; do
        echo "Creating user: $username"
        #add user with passwd
        sudo adduser "$username" --gecos ""  
    done
}

#Function to create groups
create_groups() {
    local groups=("linux" "sigma" "alpha")
    for group in "${groups[@]}"; do
        echo "Creating group: $group"
        sudo groupadd "$group"
    done
}

# Function to change primary and secondary group for users
change_group_membership() {
    #Change primary group to sigma
    sudo usermod -g sigma neha  
    sudo usermod -g sigma abhishek  
    #add to secondary group linux
    sudo usermod -aG linux neha  
    sudo usermod -aG linux abhishek 
}

# Function to create users nkhil and priyashi and add to groups
create_nkhil_priyashi() {
    sudo adduser nkhil --gecos ""  
    #Create user nkhil
    sudo adduser priyashi --gecos "" 
    #Create user priyashi
    sudo usermod -aG linux nkhil 
    #Add nkhil to linux group
    sudo usermod -aG alpha nkhil 
    #Add nkhil to alpha group
    sudo usermod -aG linux priyashi 
    #Add priyashi to linux group
    sudo usermod -aG alpha priyashi 
    #Add priyashi to alpha group
}

# Function to change home directory permissions
set_home_directory_permissions() {
    for user in neha vipul abhishek nkhil priyashi; do
        sudo chmod 700 /home/"$user" 
        #User should have full access
        sudo chmod 750 /home/"$user" 
        #Set execute for group
        #Set execute for others
        sudo chmod o+x /home/"$user"  
    done
}

# Function to create directory structure
create_directory_structure() {
    for user in neha vipul abhishek nkhil priyashi; do
        sudo mkdir -p /home/"$user"/team
        sudo mkdir -p /home/"$user"/linux
    done
}

# Function to change permissions for team and linux directories
set_directory_permissions() {
    for user in nkhil priyashi; do
        #first change the ownr of usr
        sudo chown "$user":team /home/"$user"/team
        #change the permission full access
        sudo chmod 770 /home/"$user"/team
        #change the ownr of usr
        sudo chown "$user":linux_trainers /home/"$user"/linux
        #full access of permission
        sudo chmod 770 /home/"$user"/linux
    done
}

# Function to check access
check_access() {
    alpha_user=$1 
    sigma_dir=$2
    if [[ -z "$alpha_user" || -z "$sigma_dir" ]]; then
        echo "Usage: check_access <alpha_user> <sigma_directory>"
        exit 1
    fi

    # Check if user exists
    if id "$alpha_user" &>/dev/null; then
        echo "Checking access for alpha team user '$alpha_user' to sigma team directory '$sigma_dir'..."

        # Check if the user can access the sigma directory
        sudo -u "$alpha_user" test -r "$sigma_dir" && echo "User '$alpha_user' has READ access to $sigma_dir." || echo "User '$alpha_user' does NOT have READ access to $sigma_dir."
        sudo -u "$alpha_user" test -x "$sigma_dir" && echo "User '$alpha_user' has EXECUTE access to $sigma_dir." || echo "User '$alpha_user' does NOT have EXECUTE access to $sigma_dir."
    else
        echo "User '$alpha_user' does not exist."
    fi
}

#Call the function with parameters (alpha user and sigma directory)
check_access "alpha_user_name" "/home/sigma_team"

#Function to change user shell
change_user_shell() {
    sudo usermod -s /usr/sbin/nologin vipul 
   #Change vipul to a service user
}

# Function to force password change on next login
force_password_change() {
    sudo chage -d 0 abhishek 
    #Force abhishek to change password on next login
}

# Function to change user password
change_user_password() {
    echo "Enter the username for whom you want to change the password:"
    read username  
    echo "Enter the password for $username"
    sudo passwd "$username"
}

# Call the function to change user password
change_user_password

# Function to list users and groups
list_users_groups() {
    echo "Users:"
    #List all users
    cut -d: -f1 /etc/passwd  
    echo "Groups:"
    # List all groups
    cut -d: -f1 /etc/group  
}

# Function to check neha's shell
check_user_shell() {
    echo "Enter the username whose shell you want to check:"
    read username
    user_shell=$(getent passwd "$username" | cut -d: -f7) 
    #Extract the shell from the user entry
    echo "$username's default shell: $user_shell"
}

# Call the function to check the shell of the user
check_user_shell

# Function to check default permissions
check_default_permissions() {
    echo "Default permissions:"
    umask
}

# Function to delete users and groups
delete_user_group() {
    echo "Deleting user vipul."
    sudo deluser vipul
    echo "Deleting group linux."
    sudo groupdel linux
}
