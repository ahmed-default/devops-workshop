# Day 4: Advanced Topics



## 1. Shell Scripting Fundamentals

### What is Shell Scripting?
- **Shell Script**: A program written in shell language
- **Automation**: Reduce repetitive tasks
- **Batch Processing**: Execute multiple commands
- **System Administration**: Automate maintenance tasks

### Basic Script Structure
```bash
#!/bin/bash
# This is a comment
# Script description

# Variables
VARIABLE_NAME="value"
USER_NAME=$(whoami)
CURRENT_DATE=$(date)

# Commands
echo "Hello, $USER_NAME!"
echo "Today is: $CURRENT_DATE"
```

```python
#!/usr/bin/env python3

print("hello")
```
### Variables and Data Types
```bash
# String variables
NAME="John Doe"
MESSAGE='Hello World'

# Numeric variables
COUNT=10
PRICE=99.99

# boolean
ISTRUE=true
ISFALSE=false

# Environment variables
echo $HOME
echo $PATH
echo $USER

# 
# Command substitution
CURRENT_TIME=$(date)
FILE_COUNT=$(ls -1 | wc -l)
```

### Input and Output
```bash
# Read user input
echo "Enter your name:"
read USER_NAME
echo "Hello, $USER_NAME!"

# Read with prompt
read -p "Enter your age: " AGE
echo "You are $AGE years old."

# Read password (hidden)
read -s -p "Enter password: " PASSWORD
echo

# Output formatting
printf "Name: %s, Age: %d\n" "$NAME" "$AGE"
```

### Conditional Statements
```bash
# If-else statements
NAME="hossam"
AGE=20

if [ $AGE -ge 18 ]; then
    
    echo "your age is $AGE"
    
fi 

# String comparison
if [ "$NAME" = "hossam" ]; then
    echo "Hello hos!"
fi

# File tests
if [ -f "filename.txt" ]; then
    echo "File exists"
fi

if [ -d /bin ]; then
    echo "Directory exists"
fi


# Multiple conditions
if [ $AGE -ge 18 ] && [ $AGE -le 65 ]; then
    echo "Working age"
fi

# Multiple conditions
if [ -f /bin/git ] || [ -f /usr/bin/git ]; then
    echo "Working age"
fi
```

### Single Bracket `[ ]` Examples

```bash
# String comparison, POSIX style
name="hossam"
if [ "$name" = "hossam" ]; then
    echo "Hello, Hossam"
fi

# File existence (POSIX, compatible with sh)
if [ -f "/etc/passwd" ]; then
    echo "Password file exists"
fi

# Numeric comparison (must quote variables)
age=21
if [ "$age" -ge 18 ]; then
    echo "Adult"
fi
```
- All operators and variables must be spaced and quoted properly for safety

### Double Bracket `[[ ]]` Examples

```bash
# String comparison with pattern matching
name="hossam"
if [[ $name == h* ]]; then
    echo "Name starts with h"
fi

# Logical AND/OR in a single condition
str1="abc123"
str2="123abc"
pat="[abc]+[123]+-*"
if [[ $str1 =~ $pat && $str2 =~ $pat ]]; then
    echo "Both strings match pattern"
fi

# Check if string contains substring (no quoting needed!)
dirstoname=$(cat  /etc/*os*)

if [[  $dirstoname == *Ubuntu* ]]; then
    sudo apt install git -y
else
  sudo yum install git -y
fi

# Numeric comparisons (also works as above, more flexible with arithmetic operations)
number1=5
number2=15
if [[ $number1 -lt $number2 ]]; then
    echo "$number1 is less than $number2"
fi
```
- Double brackets allow logical operations, regex (with `=~`), and pattern matching, plus don't require quoting variables as `[ ]` does[2][3][4].


### Loops
```bash
# For loop
for i in {1..5}; do
    echo "Number: $i"
done

# For loop with files
for file in *dummy*; do
    echo "Processing: $file"
done

# While loop
COUNT=1
while [ $COUNT -le 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done

# Until loop
COUNT=1
until [ $COUNT -gt 5 ]; do
    echo "Count: $COUNT"
    COUNT=$((COUNT + 1))
done
```

### Functions
```bash
# Function definition
function greet() {
    local name=$1
    echo "Hello, $name!"
}

# Function call
greet "Alice"

# Function with return value
function add() {
    local a=$1
    local b=$2
    return $((a + b))
}

add 5 3
echo "Result: $?"
```

### Error Handling
```bash
# Exit on error
set -e

# Check command success
if cd nksx ; then
    echo "Command succeeded"
else
    echo "Command failed"
    exit 1
fi

# Trap errors
trap 'echo "Error occurred on line $LINENO"' ERR
```

## 2. Advanced System Monitoring

### System Resource Monitoring
```bash
# CPU monitoring script
#!/bin/bash
echo "=== CPU Information ==="
echo "CPU Usage: $(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1)%"
echo "Load Average: $(uptime | awk -F'load average:' '{print $2}')"
echo "CPU Cores: $(nproc)"

# Memory monitoring script
#!/bin/bash
echo "=== Memory Information ==="
free -h
echo "Memory Usage: $(free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')"

# Disk monitoring script
#!/bin/bash
echo "=== Disk Information ==="
df -h
echo "Disk Usage: $(df / | tail -1 | awk '{print $5}')"
```

### Log Monitoring and Analysis
```bash
# Log analysis script
#!/bin/bash
LOG_FILE="/var/log/syslog"
ERROR_COUNT=$(grep -c "ERROR" "$LOG_FILE")
WARNING_COUNT=$(grep -c "WARNING" "$LOG_FILE")

echo "=== Log Analysis ==="
echo "Errors: $ERROR_COUNT"
echo "Warnings: $WARNING_COUNT"

# Real-time log monitoring
tail -f /var/log/syslog | grep  "ERROR\|WARNING"
```

### Performance Monitoring
```bash
# System performance script
#!/bin/bash
echo "=== System Performance ==="
echo "Uptime: $(uptime -p)"
echo "Users logged in: $(who | wc -l)"
echo "Processes: $(ps aux | wc -l)"
echo "Memory usage: $(free | grep Mem | awk '{printf("%.2f%%", $3/$2 * 100.0)}')"
echo "Disk usage: $(df / | tail -1 | awk '{print $5}')"
```

## 3. System Troubleshooting

### Common Issues and Solutions

#### High CPU Usage
```bash
# Find CPU-intensive processes
top -o %CPU
ps aux --sort=-%cpu | head -10

# Kill problematic processes
kill -9 PID

# Check for runaway processes
ps aux | grep -v grep | grep process_name
```

#### High Memory Usage
```bash
# Check memory usage
free -h
ps aux --sort=-%mem | head -10

# Check for memory leaks
cat /proc/meminfo
vmstat 1 5

# Clear cache (if safe)
sync && echo 3 > /proc/sys/vm/drop_caches
```

#### Disk Space Issues
```bash
# Find large files
find / -type f -size +100M 2>/dev/null
du -h --max-depth=1 / | sort -hr

# Clean up logs
sudo journalctl --vacuum-time=7d
sudo find /var/log -name "*.log" -mtime +30 -delete

# Remove old packages
sudo apt autoremove
sudo apt autoclean
```

#### Network Issues
```bash
# Check network connectivity
ping -c 4 8.8.8.8
nslookup google.com

# Check network configuration
ip addr show
ip route show

# Restart network services
sudo systemctl restart networking
sudo systemctl restart NetworkManager
```

### System Health Check Script
```bash
#!/bin/bash
# System health check script

echo "=== System Health Check ==="
echo "Date: $(date)"
echo

# Check disk space
echo "Disk Space:"
df -h | grep -E '^/dev/'
echo

# Check memory
echo "Memory Usage:"
free -h
echo

# Check load average
echo "Load Average:"
uptime
echo

# Check services
echo "Critical Services:"
systemctl is-active ssh
systemctl is-active networking
echo

# Check logs for errors
echo "Recent Errors:"
journalctl --since "1 hour ago" -p err --no-pager | tail -5
```

## 4. Backup and Recovery

### File Backup Strategies
```bash
# Simple backup script
#!/bin/bash
BACKUP_DIR="/backup"
SOURCE_DIR="/home/user"
DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_FILE="backup_$DATE.tar.gz"

# Create backup
tar -czf "$BACKUP_DIR/$BACKUP_FILE" "$SOURCE_DIR"

# Verify backup
if [ $? -eq 0 ]; then
    echo "Backup completed successfully: $BACKUP_FILE"
else
    echo "Backup failed!"
    exit 1
fi
```

### Incremental Backups
```bash
# Incremental backup script
#!/bin/bash
BACKUP_DIR="/backup"
SOURCE_DIR="/home/user"
DATE=$(date +%Y%m%d_%H%M%S)

# Full backup (weekly)
if [ $(date +%u) -eq 1 ]; then
    tar -czf "$BACKUP_DIR/full_backup_$DATE.tar.gz" "$SOURCE_DIR"
else
    # Incremental backup (daily)
    tar -czf "$BACKUP_DIR/inc_backup_$DATE.tar.gz" \
        --newer-mtime="1 day ago" "$SOURCE_DIR"
fi
```

### Database Backup
```bash
# MySQL backup script
#!/bin/bash
BACKUP_DIR="/backup/mysql"
DATE=$(date +%Y%m%d_%H%M%S)
DB_NAME="mydatabase"

# Create backup
mysqldump -u root -p"$MYSQL_PASSWORD" "$DB_NAME" > "$BACKUP_DIR/${DB_NAME}_$DATE.sql"

# Compress backup
gzip "$BACKUP_DIR/${DB_NAME}_$DATE.sql"
```

### Recovery Procedures
```bash
# File recovery script
#!/bin/bash
BACKUP_FILE="$1"
RESTORE_DIR="$2"

if [ -z "$BACKUP_FILE" ] || [ -z "$RESTORE_DIR" ]; then
    echo "Usage: $0 <backup_file> <restore_directory>"
    exit 1
fi

# Extract backup
tar -xzf "$BACKUP_FILE" -C "$RESTORE_DIR"

if [ $? -eq 0 ]; then
    echo "Recovery completed successfully"
else
    echo "Recovery failed!"
    exit 1
fi
```



## 6. Task Scheduling with Cron

### Understanding Cron
- **Cron**: Time-based job scheduler
- **Crontab**: File containing scheduled jobs
- **Cron Jobs**: Commands executed at specified times

### Cron Syntax
```
* * * * * command
│ │ │ │ │
│ │ │ │ └── Day of week (0-7, Sunday = 0 or 7)
│ │ │ └──── Month (1-12)
│ │ └────── Day of month (1-31)
│ └──────── Hour (0-23)
└────────── Minute (0-59)
```

### Cron Examples
```bash
# Every minute
* * * * * /path/to/script.sh

# Every hour
0 * * * * /path/to/script.sh

# Every day at 2 AM
0 2 * * * /path/to/script.sh

# Every Monday at 9 AM
0 9 * * 1 /path/to/script.sh

# Every 15 minutes
*/15 * * * * /path/to/script.sh

# Every weekday at 6 PM
0 18 * * 1-5 /path/to/script.sh
```

### Managing Cron Jobs
```bash
# Edit crontab
crontab -e

# List crontab
crontab -l

# Remove crontab
crontab -r

# Edit another user's crontab
sudo crontab -e -u username
```

### System-wide Cron
```bash
# System crontab
sudo nano /etc/crontab

# Cron directories
/etc/cron.daily/
/etc/cron.weekly/
/etc/cron.monthly/
/etc/cron.hourly/
```


```bash 
#!/bin/bash

TOKEN="your_bot_token"
CHAT_ID="your_chat_id"

# Assume this grabs the last line of your server_monitor.log
MESSAGE=$(tail -n 1 /var/log/server_monitor.log)

curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
     -d "chat_id=$CHAT_ID" \
     -d "text=$MESSAGE"
```
## 7. Hands-on Practice

### Exercise 1: Shell Scripting
Create a script that:
1. Asks for a directory path
2. Creates a backup of that directory
3. Compresses the backup
4. Shows the backup size
5. Sends an email notification (simulate with echo)

### Exercise 2: System Monitoring
Create a monitoring script that:
1. Checks disk space and alerts if > 80%
2. Checks memory usage and alerts if > 90%
3. Checks CPU load and alerts if > 5.0
4. Logs all alerts to a file
5. Runs every 5 minutes via cron

### Exercise 3: Backup Automation
Create a backup system that:
1. Performs daily incremental backups
2. Performs weekly full backups
3. Keeps backups for 30 days
4. Sends backup status reports
5. Handles backup failures gracefully


### Exercise 5: Troubleshooting
Practice troubleshooting:
1. Simulate high CPU usage
2. Fill up disk space
3. Create network issues
4. Use your scripts to diagnose
5. Implement solutions


## 9. Homework

1. Create a comprehensive system monitoring script
2. Implement automated backup procedures
3. Set up security monitoring and alerts
4. Create troubleshooting procedures for common issues
5. Document all your scripts and procedures


