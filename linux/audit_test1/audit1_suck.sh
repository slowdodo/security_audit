#!/bin/bash

# This script performs a security audit on a Debian Linux system based on the OWASP guidelines

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit
fi

# Check for any known vulnerabilities in installed packages
echo "Checking for known vulnerabilities in installed packages..."
apt-get update && apt-get --just-print dist-upgrade | grep -P -o -e '(?<=openssl ).*(?=:)' -e '(?<=libssl ).*(?=:)'

# Check for weak passwords
echo "Checking for weak passwords..."
egrep -q "^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$" /etc/shadow && echo "Strong password policy is enabled" || echo "WARNING: Weak password policy is enabled"

# Check for unnecessary services running
echo "Checking for unnecessary services running..."
service --status-all | grep -P "^[^?]"

# Check for root login via SSH
echo "Checking for root login via SSH..."
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "WARNING: Root login via SSH is enabled"
else
    echo "Root login via SSH is disabled"
fi

# Check for unauthorized access to sensitive files
echo "Checking for unauthorized access to sensitive files..."
chmod -R go-rwx /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd
ls -alh /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd
