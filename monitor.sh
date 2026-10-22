
#!/bin/bash

# Linux Server Health Monitoring System

PROJECT_DIR="$HOME/linux-server-project"
LOGFILE="$PROJECT_DIR/monitor.log"
ALERTFILE="$PROJECT_DIR/alerts.log"

DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Resource thresholds
CPU_LIMIT=80
MEMORY_LIMIT=80
DISK_LIMIT=80

# CPU usage, sampled over one second
CPU=$(LC_ALL=C top -bn2 -d 1 | awk '
/%Cpu\(s\)/ {
    idle=$8
}
END {
    printf "%.1f", 100-idle
}')

# Memory pressure (excluding available memory)
MEMORY=$(free | awk '
/^Mem:/ {
    printf "%.1f", ($2-$7)/$2*100
}')

# Root filesystem disk usage
DISK=$(df -P / | awk '
NR==2 {
    gsub("%","",$5)
    print $5
}')

# Check Nginx service
if systemctl is-active --quiet nginx; then
    NGINX="RUNNING"
else
    NGINX="DOWN"
fi

# Check actual website response
HTTP_CODE=$(curl -s -o /dev/null \
    -w "%{http_code}" \
    --max-time 5 \
    http://127.0.0.1/index.html)

if [ "$HTTP_CODE" = "200" ]; then
    WEBSITE="HEALTHY"
else
    WEBSITE="UNHEALTHY"
fi

# Display health report
echo "================================"
echo "SERVER HEALTH REPORT"
echo "Time: $DATE"
echo "CPU Usage: $CPU%"
echo "Memory Usage: $MEMORY%"
echo "Disk Usage: $DISK%"
echo "Nginx: $NGINX"
echo "Website: $WEBSITE (HTTP $HTTP_CODE)"
echo "================================"

# Save measurements
echo "$DATE | CPU: $CPU% | Memory: $MEMORY% | Disk: $DISK% | Nginx: $NGINX | Website: $WEBSITE" >> "$LOGFILE"

# Function for logging alerts
alert() {
    echo "WARNING: $1"
    echo "$DATE | WARNING: $1" >> "$ALERTFILE"
}

# Resource threshold checks
if awk -v a="$CPU" -v b="$CPU_LIMIT" 'BEGIN {exit !(a>b)}'; then
    alert "CPU usage above $CPU_LIMIT%"
fi

if awk -v a="$MEMORY" -v b="$MEMORY_LIMIT" 'BEGIN {exit !(a>b)}'; then
    alert "Memory usage above $MEMORY_LIMIT%"
fi

if [ "$DISK" -gt "$DISK_LIMIT" ]; then
    alert "Disk usage above $DISK_LIMIT%"
fi

# Service and website alerts
if [ "$NGINX" = "DOWN" ]; then
    alert "Nginx service is DOWN"
fi

if [ "$WEBSITE" = "UNHEALTHY" ]; then
    alert "Website health check FAILED"
fi

#!/bin/bash

# Linux Server Health Monitor

LOGFILE="$HOME/linux-server-project/monitor.log"
DATE=$(date '+%Y-%m-%d %H:%M:%S')

# Get system information
CPU=$(top -bn1 | awk '/Cpu\(s\)/ {print 100 - $8}')
MEMORY=$(free | awk '/Mem:/ {printf "%.1f", $3/$2 * 100}')
DISK=$(df / | awk 'NR==2 {gsub("%","",$5); print $5}')

# Check Nginx
if systemctl is-active --quiet nginx; then
    NGINX="RUNNING"
else
    NGINX="DOWN"
fi

# Display results
echo "=============================="
echo "SERVER HEALTH REPORT"
echo "Time: $DATE"
echo "CPU Usage: $CPU%"
echo "Memory Usage: $MEMORY%"
echo "Disk Usage: $DISK%"
echo "Nginx Status: $NGINX"
echo "=============================="

# Save results to a log file
{
    echo "Time: $DATE"
    echo "CPU: $CPU% | Memory: $MEMORY% | Disk: $DISK% | Nginx: $NGINX"
} >> "$LOGFILE"

# Generate warnings
if [ "$NGINX" = "DOWN" ]; then
    echo "WARNING: Nginx is not running!"
fi

if [ "$DISK" -gt 80 ]; then
    echo "WARNING: Disk usage is above 80%!"
fi
