#!/bin/bash
set -x
# Function to add a team (simulated as a group)
addTeam() {
    local team=$1
    if getent group "$team" > /dev/null 2>&1; then
        echo "Team $team already exists."
    else
        sudo groupadd "$team"
        echo "Team $team created."
    fi
}

# Function to add a user to a team (simulated user creation and directory setup)
addUser() {
    local user=$1
    local team=$2
    if id "$user" > /dev/null 2>&1; then
        echo "User $user already exists."
    else
        sudo useradd -m -g "$team" -s /bin/bash "$user"
        echo "User $user edit to team $team."

        # Set home directory permissions
        # Owner: full access, Group: read and execute, Others: execute only
        sudo chmod 751 "/home/$user"

        # Create shared directories inside user's home
        sudo mkdir -p  "/home/$user/team"
        sudo mkdir -p  "/home/$user/ninja"
        
        # Set permissions for shared directories
        # Full access for team members
        sudo chmod 770 "/home/$user/team"
        # Full access for all ninja members
        sudo chmod 770 "/home/$user/ninja"

        # Add to ninja group (if required)
        sudo usermod -aG ninja "$user"

        echo "Directories for 'team' and 'ninja' are created for $user."
    fi
}

# Function to change a user's shell
changeShell() {
    local user=$1
    local shell=$2
    if id "$user" > /dev/null 2>&1; then
        sudo chsh -s "$shell" "$user"
        echo "Shell for $user changed to $shell."
    else
        echo "User $user does not exist."
    fi
}

# Function to change a user's password
changePasswd() {
    local user=$1
    if id "$user" > /dev/null 2>&1; then
        sudo passwd "$user"
    else
        echo "User $user does not exist."
    fi
}

# Function to delete a user
delUser() {
    local user=$1
    if id "$user" > /dev/null 2>&1; then
        sudo userdel -r "$user"
        echo "User $user have been deleted."
    else
        echo "User $user you are trying to deleted its does not exist.Please check try again"
    fi
}

# Function to delete a team (group)
delTeam() {
    local team=$1
    if getent group "$team" > /dev/null 2>&1; then
        sudo groupdel "$team"
        echo "Team $team deleted."
    else
        echo "Team $team you are trying does not exist.Please try again"
    fi
}

# Function to list users or teams
list() {
    local type=$1
    if [ "$type" == "User" ]; then
        echo "Listing all users:"
        awk -F':' '{ print $1}' /etc/passwd
    elif [ "$type" == "Team" ]; then
        echo "Listing of all groups:"
        awk -F':' '{ print $1}' /etc/group
    else
        echo "Invalid type.Use 'User' or 'Team'."
    fi
}

# Main function to handle command-line arguments
main() {
    case $1 in
        addTeam)
            addTeam "$2"
            ;;
        addUser)
            addUser "$2" "$3"
            ;;
        changeShell)
            changeShell "$2" "$3"
            ;;
        changePasswd)
            changePasswd "$2"
            ;;
        delUser)
            delUser "$2"
            ;;
        delTeam)
            delTeam "$2"
            ;;
        ls)
            list "$2"
            ;;
        *)
            echo "Usage: $0 {addTeam|addUser|changeShell|changePasswd|delUser|delTeam|ls}"
            ;;
    esac
}
main "$@
