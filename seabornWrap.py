import subprocess
import sys
import os
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path

def install_seaborn():
    """Check if Seaborn is installed, and install it if necessary."""
    try:
        import seaborn  # Try to import seaborn first
        print("Seaborn is already installed.")
    except ImportError:
        print("Seaborn not found, installing...")

        # Check if Homebrew is available (macOS)
        if subprocess.run(["command", "-v", "brew"], capture_output=True, text=True).returncode == 0:
            print("Homebrew found. Installing Seaborn via Homebrew...")
            try:
                # Try to install Seaborn using Homebrew (brew install python3, then pip3)
                subprocess.run(["brew", "install", "python3"], check=True)  # Install Python3 with Homebrew
                subprocess.run(["pip3", "install", "seaborn"], check=True)  # Install Seaborn via pip3
                print("Seaborn installed successfully via Homebrew and pip3.")
            except subprocess.CalledProcessError as e:
                print(f"Error installing Seaborn via Homebrew: {e}")
        else:
            # Fall back to using pip3
            print("Homebrew not found. Installing Seaborn via pip3...")
            try:
                subprocess.run([sys.executable, "-m", "pip", "install", "seaborn"], check=True)
                print("Seaborn installed successfully via pip3.")
            except subprocess.CalledProcessError as e:
                print(f"Error installing Seaborn via pip3: {e}")
                sys.exit(1)  # Exit if installation fails

def run_bash_script(script_path):
    """Run the Bash script and capture the output."""
    try:
        result = subprocess.run(["bash", script_path], capture_output=True, text=True, check=True)
        print(f"Script executed successfully. Output saved to: /tmp/output.txt")
        return result.stdout
    except subprocess.CalledProcessError as e:
        print(f"Error executing script: {e}")
        print(e.output)
        return None

def load_and_analyze_data(log_dir):
    """Analyze system information logs using Pandas and Seaborn."""
    
    # Load system processes
    ps_file = Path(log_dir) / "ps_aux.txt"
    if ps_file.exists():
        ps_df = pd.read_csv(ps_file, sep=r'\s+', header=None, comment='#')
        ps_df.columns = ['USER', 'PID', 'CPU', 'MEM', 'VSZ', 'RSS', 'TTY', 'STAT', 'START', 'TIME', 'COMMAND']
        print(ps_df.head())
        
        # Example analysis: Top 10 processes by memory usage
        ps_df_sorted = ps_df[['USER', 'MEM', 'COMMAND']].sort_values(by='MEM', ascending=False).head(10)
        sns.barplot(x='MEM', y='COMMAND', data=ps_df_sorted)
        plt.title("Top 10 processes by memory usage")
        plt.show()
    else:
        print("No process data found.")

    # Load memory stats (from vm_stat)
    vm_file = Path(log_dir) / "vm_stats.txt"
    if vm_file.exists():
        with open(vm_file, 'r') as f:
            vm_stats = f.readlines()
            print(vm_stats[:10])  # Print the first 10 lines for inspection

    # Load disk usage (df -h)
    disk_usage_file = Path(log_dir) / "disk_usage.txt"
    if disk_usage_file.exists():
        disk_df = pd.read_csv(disk_usage_file, delim_whitespace=True, header=None)
        disk_df.columns = ['Filesystem', 'Size', 'Used', 'Avail', 'Use%', 'Mounted']
        print(disk_df.head())
        
        # Example analysis: Bar plot of disk usage
        sns.barplot(x='Use%', y='Filesystem', data=disk_df)
        plt.title("Disk Usage")
        plt.show()

# Main Function to Orchestrate the Script Execution and Analysis
def main():
    # Ensure Seaborn is installed
    install_seaborn()

    # Define paths
    bash_script_path = "/path/to/your/bash/script.sh"  # Update this path
    log_dir = "/tmp/logs_..."  # This should be the directory created by the Bash script

    # Step 1: Run the Bash Script
    run_bash_script(bash_script_path)
    
    # Step 2: Load and Analyze the Output Logs
    load_and_analyze_data(log_dir)

if __name__ == "__main__":
    main()
