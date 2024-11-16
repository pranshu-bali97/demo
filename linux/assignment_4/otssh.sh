#!/bin/bash

# Define the file to store SSH connections
CONFIG_FILE="/home/ubuntu204/.otssh_connections"

# Function to add a new SSH connection
add_connection() {
    echo "$1|$2|$3|$4|$5" >> "$CONFIG_FILE"
    echo "Connection $1 added."
}

# Function to list SSH connections
list_connections() {
    if [[ "$1" == "-d" ]]; then
        while IFS="|" read -r name host user port key; do
            cmd="ssh"
            [[ -n "$port" ]] && cmd+=" -p $port"
            [[ -n "$key" ]] && cmd+=" -i $key"
            cmd+=" $user@$host"
            echo "$name: $cmd"
        done < "$CONFIG_FILE"
    else
        awk -F "|" '{print $1}' "$CONFIG_FILE"
    fi
}

# Function to update an existing SSH connection
update_connection() {
    temp_file=$(mktemp)
    while IFS="|" read -r name host user port key; do
        if [[ "$name" == "$1" ]]; then
            echo "$1|$2|$3|$4|$5" >> "$temp_file"
            echo "Connection $1 updated."
        else
            echo "$name|$host|$user|$port|$key" >> "$temp_file"
        fi
    done < "$CONFIG_FILE"
    mv "$temp_file" "$CONFIG_FILE"
}

# Function to delete an SSH connection
delete_connection() {
    temp_file=$(mktemp)
    while IFS="|" read -r name host user port key; do
        [[ "$name" != "$1" ]] && echo "$name|$host|$user|$port|$key" >> "$temp_file"
    done < "$CONFIG_FILE"
    mv "$temp_file" "$CONFIG_FILE"
    echo "Connection $1 deleted."
}

# Function to connect to a server
connect() {
    while IFS="|" read -r name host user port key; do
        if [[ "$name" == "$1" ]]; then
            cmd="ssh"
            [[ -n "$port" ]] && cmd+=" -p $port"
            [[ -n "$key" ]] && cmd+=" -i $key"
            cmd+=" $user@$host"
            echo "Connecting to $name..."
            exec $cmd
            return
        fi
    done < "$CONFIG_FILE"
    echo "[ERROR]: Server information is not available, please add server first"
}

# Parse command-line arguments
case "$1" in
    -a)
        shift
        while getopts "n:h:u:p:i:" opt; do
            case "$opt" in
                n) name="$OPTARG" ;;
                h) host="$OPTARG" ;;
                u) user="$OPTARG" ;;
                p) port="$OPTARG" ;;
                i) key="$OPTARG" ;;
            esac
        done
        add_connection "$name" "$host" "$user" "$port" "$key"
        ;;
    ls)
        list_connections "$2"
        ;;
    -u)
        shift
        while getopts "n:h:u:p:i:" opt; do
            case "$opt" in
                n) name="$OPTARG" ;;
                h) host="$OPTARG" ;;
                u) user="$OPTARG" ;;
                p) port="$OPTARG" ;;
                i) key="$OPTARG" ;;
            esac
        done
        update_connection "$name" "$host" "$user" "$port" "$key"
        ;;
    rm)
        delete_connection "$2"
        ;;
    *)
        connect "$1"
        ;;
esac
