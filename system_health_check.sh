#!/bin/bash

# Define thresholds
CPU_THRESHOLD=80
MEMORY_THRESHOLD=80
DISK_THRESHOLD=80

# Define log file
LOG_FILE="/var/log/system_health.log"

# Function to check CPU usage
check_cpu_usage() {
    local cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    if (( $(echo "$cpu_usage > $CPU_THRESHOLD" | bc -l) )); then
        echo "$(date) - CPU usage is above threshold: ${cpu_usage}%" | tee -a $LOG_FILE
    fi
}

# Function to check memory usage
check_memory_usage() {
    local memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
    if (( $(echo "$memory_usage > $MEMORY_THRESHOLD" | bc -l) )); then
        echo "$(date) - Memory usage is above threshold: ${memory_usage}%" | tee -a $LOG_FILE
    fi
}

# Function to check disk space usage
check_disk_space() {
    local disk_usage=$(df / | grep / | awk '{ print $5 }' | sed 's/%//g')
    if [ "$disk_usage" -gt "$DISK_THRESHOLD" ]; then
        echo "$(date) - Disk space usage is above threshold: ${disk_usage}%" | tee -a $LOG_FILE
    fi
}

# Function to check running processes
check_running_processes() {
    local process_count=$(ps aux | wc -l)
    if [ "$process_count" -gt 100 ]; then
        echo "$(date) - Number of running processes is high: ${process_count}" | tee -a $LOG_FILE
    fi
}

# Create log file if it doesn't exist
if [ ! -f $LOG_FILE ]; then
    touch $LOG_FILE
fi

# Run checks
check_cpu_usage
check_memory_usage
check_disk_space
check_running_processes

