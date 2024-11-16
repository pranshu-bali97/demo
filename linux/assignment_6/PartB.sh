#!/bin/bash

#Define a directory to store service information
SERVICE_DIR="/home/ubuntu204/services"

# Check if the services directory exists before creating it
if [ ! -d "$SERVICE_DIR" ]; then
    mkdir $SERVICE_DIR
fi

# Function to register a service
register_service() {
    local script_path="$1"
    local alias="$2"
    echo "Registering service: $alias"
    echo "$script_path" > "$SERVICE_DIR/$alias.service"
}

# Function to start a service
start_service() {
    local alias="$1"
    local script_path=$(<"$SERVICE_DIR/$alias.service")
    
    if [[ -n $script_path ]]; then
        nohup "$script_path" >/dev/null 2>&1 &
        echo "$!" > "$SERVICE_DIR/$alias.pid"
        echo "Started service: $alias"
    else
        echo "Service $alias not found."
    fi
}

# Function to show the status of a service
status_service() {
    local alias="$1"
    if [[ -f "$SERVICE_DIR/$alias.pid" ]]; then
        local pid=$(<"$SERVICE_DIR/$alias.pid")
        if ps -p $pid > /dev/null; then
            echo "Service $alias is running (PID: $pid)"
        else
            echo "Service $alias is not running."
        fi
    fi
}

# Function to kill a service
kill_service() {
    local alias="$1"
    if [[ -f "$SERVICE_DIR/$alias.pid" ]]; then
        local pid=$(<"$SERVICE_DIR/$alias.pid")
        kill $pid
        rm "$SERVICE_DIR/$alias.pid"
        echo "Killed service: $alias"
    else
        echo "Service $alias not found."
    fi
}

# Function to change the priority of a service
change_priority() {
    local priority="$1"
    local alias="$2"
    
    # Map textual priorities to numerical values
    case $priority in
        low)    priority_value=19 ;;
        med)    priority_value=0 ;;
        high)   priority_value=-20 ;;
        *)      echo "Invalid priority value.Use low, med or high." && exit 1 ;;
    esac

    if [[ -z "$alias" ]]; then
        echo "Alias is required to change priority."
        exit 1
    fi

    if [[ -f "$SERVICE_DIR/$alias.pid" ]]; then
        local pid=$(<"$SERVICE_DIR/$alias.pid")
        if ps -p $pid > /dev/null; then
            renice "$priority_value" -p "$pid"
            echo "Changed priority of service $alias to $priority."
        else
            echo "Service $alias is not running."
        fi
    fi 
}

# Function to list all registered services
list_services() {
    echo "Registered services:"
    ls $SERVICE_DIR | sed 's/.service//'
}

# Function to list details of a service
top_service() {
    local alias="$1"
    
    if [[ -z "$alias" ]]; then
        echo "Alias is required to check details."
        exit 1
    fi

    if [[ -f "$SERVICE_DIR/$alias.pid" ]]; then
        local pid=$(<"$SERVICE_DIR/$alias.pid")
        if ps -p $pid > /dev/null; then
            local state=$(ps -o state= -p $pid)
            local priority=$(ps -o pri= -p $pid)
            local script_path=$(<"$SERVICE_DIR/$alias.service")
            echo "Alias:$alias, PID:$pid, State:$state, Priority:$priority, Script:$script_path"
        else
            echo "Service $alias is not running."
        fi  
    fi  
}

# Main script logic
while getopts "o:s:a:p:" opt; do
    case $opt in
        o)
            operation="$OPTARG"
            ;;
        s)
            script_path="$OPTARG"
            ;;
        a)
            alias="$OPTARG"
            ;;
        p)
            priority="$OPTARG"
            ;;
        \?)
            echo "Invalid option: -$OPTARG" >&2
            exit 1
            ;;
    esac
done

case $operation in
    register)
        register_service "$script_path" "$alias"
        ;;
    start)
        start_service "$alias"
        ;;
    status)
        status_service "$alias"
        ;;
    kill)
        kill_service "$alias"
        ;;
    priority)
        change_priority "$priority" "$alias"
        ;;
    list)
        list_services
        ;;
    top)
        top_service "$alias"
        ;;
    *)
         ;;
esac
