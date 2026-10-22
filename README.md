# Linux Server Administration & Monitoring

A hands-on Linux infrastructure project built using Ubuntu Server, Nginx, Bash, SSH, UFW, and cron.

## Project Overview

This project demonstrates foundational Linux system administration, web server deployment, automated monitoring, and incident troubleshooting.

The environment runs on an Ubuntu Server virtual machine hosted using UTM on an Apple Silicon Mac.

## Technologies Used

- **Ubuntu Server:** Linux operating system
- **Nginx:** Web server
- **Bash:** System monitoring automation
- **SSH:** Remote server administration
- **UFW:** Firewall configuration
- **Cron:** Scheduled health checks
- **Git:** Version control

## Features

### Web Server Deployment
- Configured Nginx to host a custom HTML website.
- Tested HTTP responses using curl.
- Managed services using systemctl.

### Automated Server Monitoring
- Monitors CPU, memory, and disk usage.
- Checks whether Nginx is running.
- Performs HTTP health checks.
- Generates warnings when configured thresholds are exceeded.
- Records timestamped measurements and alerts.

### Automation
- Uses cron to execute monitoring every five minutes.
- Saves monitoring history for troubleshooting.

### Security
- Configured firewall rules for SSH and HTTP.
- Implemented SSH key authentication.

### Incident Simulation
- Simulated Nginx service outages.
- Detected failures using the monitoring script.
- Inspected service logs and restored service availability.

## Running the Monitoring Script

```bash
chmod +x monitor.sh
./monitor.sh
```

The script writes monitoring data to `monitor.log` and warnings to `alerts.log`.

## Future Improvements

- Email or webhook notifications
- Centralized logging
- Docker containerization
- Cloud deployment on AWS
- Infrastructure automation using Terraform

## What I Learned

This project helped me develop practical skills in Linux administration, Bash scripting, networking, security configuration, service monitoring, and incident troubleshooting.
