# **System Investigation and Logging Script for macOS**

This script is designed for macOS to collect detailed system logs, browser histories, shell history files, process information, network data, and more. It gathers a comprehensive set of logs and system data, then archives everything into a **tarball** for easy sharing and analysis. The script ensures that no traces of the collected data are left behind after the tarball is created, making it ideal for privacy-conscious investigations.

---

## **Introduction**

In today's **Digital Forensics and Incident Response (DFIR)** landscape, macOS endpoints often do not receive the same level of scrutiny as their Linux and Windows counterparts. While Linux and Windows systems have well-established logging mechanisms, macOS endpoints often fly under the radar when it comes to comprehensive log collection and analysis, and they make up over 35% of todays developer environments in the public sector.

This script helps fill that gap by collecting vital macOS system data and logs, and ensures the information is preserved in a way that aligns with best practices in forensics and incident response. It is designed specifically for **macOS** systems, as **Unix-based commands on macOS differ** from those used in Linux environments, making cross-platform tools and scripts less effective.

For future use, a separate script for **macOS unified log collection** will also be provided, focusing on the macOS-specific unified logging system (introduced in macOS Sierra and later), which records a wide range of system, security, and app events.

---

## **Features**

- **Collects system information** such as logged-in users, hostname, processes, system usage, and memory stats.
- **Gathers network information** including network configurations, ARP table, routing table, and open network connections.
- **Captures shell history** for various shells (e.g., Bash, Zsh, Fish) from the user's home directory.
- **Fetches browser histories** for Safari, Chrome, and Firefox (if available).
- **Lists installed applications** and Homebrew packages (if Homebrew is installed).
- **Generates a tarball** containing all collected data (including logs, histories, and system info).
- **Cleans up** by deleting all the collected files from the filesystem after the tarball is created, leaving no traces.

---

## **Prerequisites**

- **macOS** (The script is designed specifically for macOS, leveraging macOS-specific tools and system commands).
- **No sudo privileges** are required to run this script.
- If **Homebrew** is installed on the system, the script will list installed packages.
- The script assumes the user has **Bash**, **Zsh**, or **Fish** shell history files present.

---

## **Installation**

1. **Download or create the script**:
   - Save the script as a `.sh` file (e.g., `system_investigation.sh`).

2. **Make the script executable**:
   ```bash
   chmod +x system_investigation.sh
   ```

---

## **Usage**

Simply run the script without any arguments. The script will collect data for the past 24 hours, create a tarball, and store it in `/tmp/` along with an output log file.

### Running the Script

```bash
./system_investigation.sh
```

The script will do the following:
1. Collect system logs and data.
2. Archive the logs into a **tarball**.
3. Remove all temporary files once the tarball is created.
4. The tarball will be stored in `/tmp/` (or a system-defined temporary directory).

### Output Files

- **Output log**: `/tmp/output.txt`
- **Tarball**: A tarball containing all collected logs, system information, shell history, etc. The file name is randomly generated, e.g., `/tmp/abc123def456.tar.gz`.

---

## **Collected Data**

The script will gather the following types of data:

1. **System Information**:
   - Logged-in users (via `w` command).
   - Hostname of the system.
   - List of users on the system (via `ls /Users`).
   - List of installed Homebrew packages (if Homebrew is installed).
   - List of installed applications (from `/Applications`).
   - Process list (`ps aux`).
   - System uptime (`uptime`).
   - Memory stats (`vm_stat`).
   - Disk usage (`df -h`).
   - User login history (`last` command).
   - Kernel logs (`dmesg`).
   
2. **Networking Information**:
   - Network configuration (`ifconfig`).
   - ARP table (`arp -a`).
   - Routing table (`netstat -rn`).
   - Open network connections (`lsof -i`).

3. **Browser History**:
   - Safari history (`~/Library/Safari/History.db`).
   - Chrome history (`~/Library/Application Support/Google/Chrome/Default/History`).
   - Firefox history (`~/Library/Application Support/Firefox/Profiles/*.default*/places.sqlite`).

4. **Shell History**:
   - Bash history (`~/.bash_history`).
   - Zsh history (`~/.zsh_history`).
   - Fish history (`~/.local/share/fish/fish_history`, if present).

5. **Process and Memory Information**:
   - Process list (`ps aux`).
   - Memory usage (`top` command with memory sorting).
   - Real-time system usage (`top -l 1`).
   
6. **Homebrew Package List**:
   - If Homebrew is installed, the script will list all installed packages (`brew list`).

7. **Installed Applications**:
   - A list of all installed applications in `/Applications`.

---

## **Cleanup**

Once the tarball is successfully created, all **collected data files** (logs, histories, etc.) are **immediately deleted** from the system to ensure no traces are left behind. The tarball remains in the `/tmp/` directory (or your system's designated temporary directory).

---

## **Example**

### Example Output

```bash
Investigation started at Tue Oct 10 12:34:56 PDT 2024
Log file: /tmp/output.txt
Fetching logs for the last 24 hours...
Collecting system information...
Getting logged-in users (w)...
Getting system hostname...
Getting list of users (ls /Users)...
Getting list of installed applications from /Applications...
Creating tarball of logs: /tmp/abc123def456.tar.gz
Cleaning up temporary files...
Investigation complete. Logs stored in /tmp/abc123def456.tar.gz
```

### Tarball Contents

The tarball (`/tmp/abc123def456.tar.gz`) will contain:

- `who_is_logged_in.txt` – Logged-in users.
- `hostname.txt` – System hostname.
- `users_list.txt` – List of users on the system.
- `homebrew_packages.txt` – Installed Homebrew packages (if Homebrew is installed).
- `installed_applications.txt` – List of installed applications.
- `ps_aux.txt` – Process list.
- `system_top.txt` – System usage.
- `vm_stats.txt` – Memory stats.
- `disk_usage.txt` – Disk usage stats.
- `user_logins.txt` – User login history.
- `lastlog.txt` – Last login info.
- `kernel_logs.txt` – Kernel logs.
- `system_uptime.txt` – System uptime.
- `network_config.txt` – Network configuration.
- `arp_table.txt` – ARP table.
- `routing_table.txt` – Routing table.
- `open_network_connections.txt` – Open network connections.
- `Safari_History.db`, `Chrome_History`, `Firefox_History.sqlite` – Browser history files.
- `bash_history.txt`, `zsh_history.txt`, `fish_history.txt` – Shell history files (if they exist).

---

## **Notes**

- The script does **not require sudo privileges** to run, making it suitable for use on non-rooted machines.
- **Homebrew package listing** will only occur if Homebrew is installed on the system.
- The tarball created by the script contains all logs and data, but **no traces** of these files will remain on the system after the script finishes.
- The script runs a thorough investigation by default, covering logs from the last 24 hours. This can be customized if needed by modifying the script (though we have hardcoded the 24-hour period).

---

## **Future Improvements**

- A separate script will be developed specifically for **macOS Unified Log Collection**, focusing on Apple's unified logging system, which includes detailed logs of system, security, and application events across the macOS platform.
  
---

## **License**

This script is provided as-is, without warranty or support. You are free to use, modify, and distribute it as needed.

---

