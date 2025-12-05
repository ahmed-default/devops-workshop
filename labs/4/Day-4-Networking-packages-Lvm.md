# Day 3: System Administration 

***

 ## Topic Lis

1. **Process Management**
2. **System Services and Daemons**
3. **Networking**
4. **System Logs and Troubleshooting**
5. **Package Management**
6. **System Performance Monitoring**
7. **Hands-on Practice**
8. **Key Takeaways**



## 2. Process Management

### Understanding Processes
- **Process**: Running instance of a program
- **PID**: Process ID (unique identifier)
- **Parent Process**: Process that started another process
- **Child Process**: Process started by another process

### Process Monitoring Commands
```bash
# List running processes
ps
ps aux                    # Detailed list
ps -ef                    # Alternative format
ps aux | grep processname # Find specific process

# Real-time process monitoring
top
htop                      # Enhanced version (if installed)

# Process tree
pstree
pstree -p                 # Show PIDs
```


```yaml
anahur      2922  0.0  0.0   8384  1652 pts/2    S    17:31   0:00 sleep 100
```
ps aux
### Common Process States

| **Code** | **State** | **Description** |
|----------|-----------|-----------------|
| **R** | Running | Currently executing or ready to run |
| **S** | Sleeping | Waiting for an event (interruptible) |
| **D** | Uninterruptible Sleep | Waiting for I/O, cannot be interrupted |
| **T** | Stopped | Suspended by job control signal (Ctrl+Z) |
| **Z** | Zombie | Terminated but not yet cleaned up by parent |
| **I** | Idle | Kernel idle thread |

| **Field** | **Value** | **Meaning** |
|-----------|-----------|-------------|
| **USER** | `anahur` | Process owned by user "anahur" |
| **PID** | `2922` | Process ID (unique identifier for this process) |
| **%CPU** | `0.0` | Using 0.0% of CPU (process is idle/sleeping) |
| **%MEM** | `0.0` | Using approximately 0.0% of physical memory |
| **VSZ** | `8384` | Virtual memory size in kilobytes (8.4 MB total allocated) |
| **RSS** | `1652` | Resident Set Size in kilobytes (1.6 MB actually in RAM) |
| **TTY** | `pts/2` | Pseudo-terminal #2 (connected to a terminal session) |
| **STAT** | `S` | Process state (see detailed explanation below) |
| **START** | `17:31` | Process started at 5:31 PM |
| **TIME** | `0:00` | Total CPU time consumed (0 minutes, 0 seconds) |
| **COMMAND** | `sleep 100` | The command running: sleep for 100 seconds |
### Modifiers (Additional Characters)

| **Code** | **Meaning**    | **Description**                           |
| -------- | -------------- | ----------------------------------------- |
| **<**    | High Priority  | Process has elevated priority (nice < 0)  |
| **N**    | Low Priority   | Process has reduced priority (nice > 0)   |
| **L**    | Locked Pages   | Has pages locked in memory (real-time)    |
| **s**    | Session Leader | Leader of a session                       |
| **l**    | Multi-threaded | Has multiple threads (using CLONE_THREAD) |
| **+**    | Foreground     | In foreground process group of terminal   |
|          |                |                                           |
|          |                |                                           |

```bash
python3 -m http.server 8080 > logs.log 2>&1 &
```
### Process Control
```bash
# Start process in background
command &
nohup command &           # Continue after logout

# View background jobs
jobs
jobs -l                   # Show PIDs

# Bring job to foreground
fg %1                     # Job number 1
fg                        # Last background job

# Send process to background
Ctrl + Z                  # Suspend process
bg                        # Resume in background

# Kill processes
kill PID                  # Send TERM signal
kill -9 PID               # Force kill (SIGKILL)
kill -15 PID              # Graceful termination (SIGTERM)
killall processname       # Kill all processes with name
pkill processname         # Kill by pattern
```

### Process Information
```bash
# Detailed process information
ps -o pid,ppid,cmd,etime,pcpu,pmem

# Process memory usage
ps -o pid,cmd,%mem  

# Process CPU usage
ps -o pid,cmd,%cpu 

# Process by user
ps -u username
```

## 3. System Services and Daemons

### Understanding Services
- **Service**: Background process that provides system functionality
- **Daemon**: Another term for service
- **Init System**: Manages services (systemd, SysV, Upstart)

### systemd Service Management
```bash
# List all services
systemctl list-units --type=service
systemctl list-units --type=service --state=running

# Service status
systemctl status servicename
systemctl is-active servicename
systemctl is-enabled servicename

# Start/stop/restart services
sudo systemctl start servicename
sudo systemctl stop servicename
sudo systemctl restart servicename
sudo systemctl reload servicename

# Enable/disable services
sudo systemctl enable servicename
sudo systemctl disable servicename

# View service logs
journalctl -u servicename
journalctl -u servicename -f    # Follow logs
```

### Common Services
```bash
# Web server
sudo systemctl status apache2
sudo systemctl status nginx

# Database
sudo systemctl status mysql
sudo systemctl status postgresql

# Network
```

### Creating Custom Services
```bash
# Create service file
sudo nano /etc/systemd/system/myservice.service

[Unit]
Description=My Custom Service
After=network.target

[Service]
Type=simple
User=anahur
WorkingDirectory=/home/anahur
ExecStart=/usr/bin/python3 -m http.server 8080
Restart=always
RestartSec=3

[Install]
WantedBy=multi-user.target

# Reload systemd and enable service
sudo systemctl daemon-reload
sudo systemctl enable myservice


sudo systemctl start myservice
```

## 4. Networking

### Network Configuration
```bash

# Test connectivity
ping google.com
ping -c 4 google.com        # Send 4 packets

# DNS resolution
nslookup google.com
dig google.com
host google.com
```

### Network Ports and Connections
```bash
# View listening ports
 
sudo apt install net-tools

netstat -tlnp
ss -tlnp                    # Modern alternative

# View all connections
netstat -tulnp
ss -tulnp

# View connections by process
netstat -tulnp | grep processname
lsof -i :80                 # What's using port 80

# Test port connectivity
telnet hostname port

```

### Network Troubleshooting
```bash
# traceroute google.com
ip link show
# Trace network path
traceroute google.com
tracepath google.com

# View network statistics
netstat -s
ss -s

# Check network configuration
cat /etc/network/interfaces
cat /etc/resolv.conf
```
## Create DN

```
 sudo vi /etc/hosts
 update the server ip 
```
### Firewall Configuration

#### UFW (Uncomplicated Firewall) - Ubuntu/Debian
```bash
# Check firewall status
sudo ufw status

# Enable/disable firewall
sudo ufw enable
sudo ufw disable

# Basic rules
sudo ufw allow ssh
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow from 192.168.1.0/24

# Deny rules
sudo ufw deny 23/tcp
sudo ufw deny from 192.168.1.100

# Delete rules
sudo ufw delete allow 80/tcp
sudo ufw delete 1  # Delete rule number 1

# Reset firewall
sudo ufw --force reset
```


```bash 



## 5. System Logs and Troubleshooting

### Log Locations
```bash
# System logs
/var/log/syslog             # General system messages
/var/log/auth.log           # Authentication messages
/var/log/kern.log           # Kernel messages
/var/log/boot.log           # Boot messages

# Application logs
/var/log/apache2/           # Apache web server
/var/log/nginx/             # Nginx web server
/var/log/mysql/             # MySQL database
/var/log/postgresql/        # PostgreSQL database
```

### Log Viewing Commands
```bash
# View logs
tail -f /var/log/syslog     # Follow log in real-time
tail -n 100 /var/log/syslog # Last 100 lines
head -n 50 /var/log/syslog  # First 50 lines

# Search logs
grep "error" /var/log/syslog
grep -i "failed" /var/log/auth.log

# Log rotation
logrotate -d /etc/logrotate.conf  # Test configuration
sudo logrotate -f /etc/logrotate.conf  # Force rotation
```



### journalctl (systemd logs)
```bash
# View system logs
journalctl
journalctl -f               # Follow logs
journalctl -n 50            # Last 50 entries

# Filter by time
journalctl --since "2024-01-01"
journalctl --since "1 hour ago"
journalctl --since "yesterday"

# Filter by service
journalctl -u servicename
journalctl -u servicename -f

# Filter by priority
journalctl -p err           # Error level and above
journalctl -p warning       # Warning level and above
```

## 6. Package Management

### APT (Debian/Ubuntu)
```bash
# Update package list
sudo apt update

# Upgrade packages
sudo apt upgrade
sudo apt full-upgrade      # May remove packages

# Install packages
sudo apt install packagename
sudo apt install package1 package2 package3

# Remove packages
sudo apt remove packagename
sudo apt purge packagename  # Remove with configuration

# Search packages
apt search keyword
apt show packagename        # Package information

# List installed packages
apt list --installed
dpkg -l                     # Alternative

# Clean up
sudo apt autoremove         # Remove unused packages
sudo apt autoclean          # Clean package cache
```

### YUM/DNF (RHEL/CentOS/Fedora)
```bash
# Update packages
sudo yum update
sudo dnf update             # Fedora/CentOS 8+

# Install packages
sudo yum install packagename
sudo dnf install packagename

# Remove packages
sudo yum remove packagename
sudo dnf remove packagename

# Search packages
yum search keyword
dnf search keyword

# List installed packages
yum list installed
dnf list installed
```

### Snap Packages
```bash
# Install snap
sudo apt install snapd

# Install snap packages
sudo snap install packagename

# List installed snaps
snap list

# Remove snap packages
sudo snap remove packagename
```


## 9. System Performance Monitoring

### CPU Monitoring
```bash
# CPU usage
top
htop
vmstat 1                   # Every 1 second
sar -u 1 5                 # 5 samples, 1 second apart

# CPU information
lscpu
cat /proc/cpuinfo
```

### Memory Monitoring
```bash
# Memory usage
free -h
cat /proc/meminfo
vmstat -s

# Memory by process
ps aux --sort=-%mem | head
top -o %MEM
```

### Disk Monitoring
```bash
# Disk usage
df -h
du -h --max-depth=1

# Disk I/O monitoring
iostat -x 1                # Extended I/O statistics every 1 second
iostat -c 1 5              # CPU statistics, 5 samples, 1 second apart
iostat -d 1                # Device statistics
iotop                      # If installed - real-time I/O monitoring

# Disk information
lsblk                      # List block devices
fdisk -l                   # List disk partitions
lsblk -f                   # Show filesystem information
```

### System Load
```bash
# Load average
uptime
w
cat /proc/loadavg

# System information
uname -a
hostnamectl
```

## 10. Hands-on Practice

### Exercise 1: User Management
1. Create a new user called `testuser`
2. Set a password for the user
3. Add the user to the `sudo` group
4. Switch to the user and test sudo access
5. Lock and unlock the account

### Exercise 2: Process Management
1. Start a long-running process (like `sleep 300`)
2. Find its PID using `ps`
3. Suspend it with `Ctrl + Z`
4. Resume it in the background
5. Kill the process

### Exercise 3: Service Management
1. Check the status of the SSH service
2. View the SSH service logs
3. Restart the SSH service
4. Check if it's enabled to start on boot

### Exercise 4: Networking
1. Check your network interfaces
2. Test connectivity to google.com
3. Check what's listening on port 22 (SSH)
4. View your routing table

### Exercise 5: Log Analysis
1. View the last 50 lines of the system log
2. Search for "error" messages in the log
3. Check the authentication log for failed login attempts
4. Use journalctl to view recent system messages

### Exercise 6: Firewall Configuration
1. Check your current firewall status
2. Allow SSH access (port 22)
3. Allow HTTP access (port 80)
4. Block a specific IP address
5. List all firewall rules




### Best Practices
- Always use `sudo` for system administration tasks
- Monitor system resources regularly
- Keep packages updated for security
- Use `journalctl` for modern log viewing
- Test service changes in non-production first
- Document user and service configurations

## 12. Homework

1. Create a user account for a new team member
2. Monitor system performance for 10 minutes
3. Set up a custom service that runs a simple script
4. Analyze system logs for any errors or warnings
5. Practice package management by installing and removing a test package
