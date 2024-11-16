#!/bin/bash

# Function to find top n processes by memory
top_process() {
    n=$1
    type=$2
    if [[ $type == "memory" ]]; then
        echo "Top $n processes by memory usage:"
        ps aux --sort=-%mem | head -n $((n + 1)) 
    elif [[ $type == "cpu" ]]; then
        echo "Top $n processes by CPU usage:"
        ps aux --sort=-%cpu | head -n $((n + 1))
    else
        echo "Invalid type."
    fi
}

# Function to kill the process with the least priority
kill_least_priority_process() {
    pid=$(ps -eo pid,pri --sort=pri | awk 'NR==2 {print $1}')
    if [[ -n $pid ]]; then
        kill $pid
        echo "Killed process with PID: $pid"
    else
        echo "No pid found.Please try again."
    fi
}

##Function to find the running duration of a process by name or PID
running_duration() {
    process=$1
    ##Check if the argument is a number (PID)
    if [[ $process =~ ^[0-9]+$ ]]; then
       ##elapsed time by PID
        ps -p $process -o etime
    else
        ##Get the PID of the process by name
        pid=$(pgrep -f "$process")
        if [[ -n $pid ]]; then
         ##elapsed time by process name
            ps -p $pid -o etime
        else
            echo "Process name not found."
        fi
    fi
}

##Function to list orphan processes
list_orphan_processes() {
    echo "Orphan processes:"
    ps -eo pid,ppid,cmd | awk '$2 == 1 {print $0}'
}

# Function to list zombie processes
list_zombie_processes() {
    echo "Zombie processes:"
    ps aux | awk '$8 == "Z"'

}

# Function to kill a process by name or PID
kill_process() {
    echo "Do you want to kill a process by:"
    echo "1) Process Name"
    echo "2) Process ID (PID)"
    read -p "Enter your choice (1 or 2): " choice

    if [ "$choice" -eq 1 ]; then
        read -p "Enter the process name: " process_name
        pkill "$process_name" && echo "Processes named '$process_name' have been terminated."
    elif [ "$choice" -eq 2 ]; then
        read -p "Enter the process ID (PID): " pid
        if [[ "$pid" =~ ^[0-9]+$ ]]; then
            kill "$pid" && echo "Process with PID $pid has been terminated."
        else
            echo "Invalid PID."
        fi
    else
        echo "Invalid choice."
    fi
}

# Function to list processes that are waiting for resources
list_waiting_processes() {
    echo "Processes waiting for resources:"
    ps -eo pid,stat,cmd | awk '$2 ~ /D/ {print $0}'
}

# Main script logic
case $1 in
    topProcess)
        top_process $2 $3
        ;;
    killLeastPriorityProcess)
        kill_least_priority_process
        ;;
    RunningDurationProcess)
        running_duration $2
        ;;
    listOrphanProcess)
        list_orphan_processes
        ;;
    listZoombieProcess)
        list_zombie_processes
        ;;
    killProcess)
        kill_process $2
        ;;
    ListWaitingProcess)
        list_waiting_processes
        ;;
    *) ;;      
esac
