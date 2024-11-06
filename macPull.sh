#!/bin/bash

# Set up logging configuration to output to /tmp/output.txt
LOG_FILE="/tmp/output.txt"  # Use /tmp for the log file
exec > "$LOG_FILE" 2>&1

# Temporary directory for storing logs and files before creating the tarball
TEMP_DIR="/tmp/logs_$(openssl rand -hex 12)"

# Create the temporary directory
mkdir -p "$TEMP_DIR"

echo "Investigation started at $(date)"
echo "Log file: $LOG_FILE"
echo "Fetching logs for the last 24 hours..."

# Collect browser history (Safari, Chrome, Firefox) in parallel
collect_browser_history() {
    echo "Collecting browser history..."
    cp ~/Library/Safari/History.db "$TEMP_DIR/Safari_History.db" &
    cp ~/Library/Application\ Support/Google/Chrome/Default/History "$TEMP_DIR/Chrome_History" &
    cp ~/Library/Application\ Support/Firefox/Profiles/*.default*/places.sqlite "$TEMP_DIR/Firefox_History.sqlite" &
    wait
}

# Collect system and user information
collect_system_info() {
    echo "Collecting system information..."
    
    # Get the list of currently logged-in users
    echo "Getting logged-in users (w)..."
    w > "$TEMP_DIR/who_is_logged_in.txt"
    
    # Get the hostname of the system
    echo "Getting system hostname..."
    hostname > "$TEMP_DIR/hostname.txt"
    
    # Get the list of users on the machine (from /Users)
    echo "Getting list of users (ls /Users)..."
    ls /Users > "$TEMP_DIR/users_list.txt"
    
    # Check if Homebrew exists, then list installed packages
    if command -v brew &> /dev/null; then
        echo "Homebrew detected. Listing installed packages..."
        brew list > "$TEMP_DIR/homebrew_packages.txt"
    else
        echo "Homebrew not installed, skipping package list..."
    fi
    
    # List installed applications
    echo "Listing installed applications from /Applications..."
    ls /Applications > "$TEMP_DIR/installed_applications.txt"
    
    # Get system processes
    echo "Getting system processes..."
    ps aux > "$TEMP_DIR/ps_aux.txt"
    
    # Get real-time system usage (top)
    echo "Getting real-time system usage (top)..."
    top -l 1 -n 0 > "$TEMP_DIR/system_top.txt"
    
    # Get memory stats (vm_stat)
    echo "Getting memory stats (vm_stat)..."
    vm_stat > "$TEMP_DIR/vm_stats.txt"
    
    # Get disk usage (df -h)
    echo "Getting disk usage (df -h)..."
    df -h > "$TEMP_DIR/disk_usage.txt"
    
    # Get user login history
    echo "Getting user login history..."
    last > "$TEMP_DIR/user_logins.txt"
    
    # Get last logins
    echo "Getting last logins..."
    lastlog > "$TEMP_DIR/lastlog.txt"
    
    # Get kernel logs
    echo "Getting kernel logs..."
    dmesg > "$TEMP_DIR/kernel_logs.txt"
    
    # Get system uptime
    echo "Getting system uptime..."
    uptime > "$TEMP_DIR/system_uptime.txt"
    
    wait
}

# Collect networking info
collect_network_info() {
    echo "Collecting networking information..."
    echo "Getting networking configurations..."
    ifconfig > "$TEMP_DIR/network_config.txt"
    
    echo "Getting ARP table..."
    arp -a > "$TEMP_DIR/arp_table.txt"
    
    echo "Getting routing table..."
    netstat -rn > "$TEMP_DIR/routing_table.txt"
    
    # Get open network connections
    echo "Getting open network connections..."
    lsof -i > "$TEMP_DIR/open_network_connections.txt"
}

# Collect process and memory analysis
collect_process_and_memory_analysis() {
    echo "Collecting process and memory information..."
    ps aux > "$TEMP_DIR/ps_processes.txt"
    vm_stat > "$TEMP_DIR/vm_stats_memory.txt"
    top -l 1 -n 0 -o mem > "$TEMP_DIR/memory_usage.txt"
}

# Collect shell history files (bash, zsh, etc.)
collect_shell_history() {
    echo "Collecting shell history..."
    
    # Bash history
    if [ -f "$HOME/.bash_history" ]; then
        echo "Collecting bash history..."
        cp "$HOME/.bash_history" "$TEMP_DIR/bash_history.txt"
    else
        echo "No bash history found."
    fi
    
    # Zsh history
    if [ -f "$HOME/.zsh_history" ]; then
        echo "Collecting zsh history..."
        cp "$HOME/.zsh_history" "$TEMP_DIR/zsh_history.txt"
    else
        echo "No zsh history found."
    fi
    
    # Other shell history (if exists, you can extend this for other shells)
    # For example, collecting history for fish shell
    if [ -f "$HOME/.local/share/fish/fish_history" ]; then
        echo "Collecting fish shell history..."
        cp "$HOME/.local/share/fish/fish_history" "$TEMP_DIR/fish_history.txt"
    fi
}

# Call the functions in sequence
collect_browser_history
collect_system_info
collect_network_info
collect_process_and_memory_analysis
collect_shell_history  # Added collection of shell history

# Create a tarball with all the logs in the temporary directory
TARBALL_NAME="/tmp/$(openssl rand -hex 12).tar.gz"
echo "Creating tarball of logs: $TARBALL_NAME"
tar -czf "$TARBALL_NAME" -C "$TEMP_DIR" .

# Clean up by removing the temporary directory and its contents immediately after tarball creation
echo "Cleaning up temporary files..."
rm -rf "$TEMP_DIR"

# Final message
echo "Investigation complete. Logs stored in $TARBALL_NAME"
