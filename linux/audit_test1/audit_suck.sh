#!/bin/bash

# This script performs a security audit on a Debian Linux system based on the OWASP guidelines
# and generates the output as an XML file

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit
fi

# Create the XML file
echo "<security_audit>" > audit.xml

# Check for any known vulnerabilities in installed packages
echo "Checking for known vulnerabilities in installed packages..."
apt-get update && apt-get --just-print dist-upgrade | grep -P -o -e '(?<=openssl ).*(?=:)' -e '(?<=libssl ).*(?=:)' | awk '{print "<vulnerability>" $0 "</vulnerability>"}' >> audit.xml

# Check for weak passwords
echo "Checking for weak passwords..."
egrep -q "^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$" /etc/shadow && echo "<password_policy>Strong password policy is enabled</password_policy>" >> audit.xml || echo "<password_policy>WARNING: Weak password policy is enabled</password_policy>" >> audit.xml

# Check for unnecessary services running
echo "Checking for unnecessary services running..."
service --status-all | grep -P "^[^?]" | awk '{print "<service>" $0 "</service>"}' >> audit.xml

# Check for root login via SSH
echo "Checking for root login via SSH..."
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "<ssh_root_login>WARNING: Root login via SSH is enabled</ssh_root_login>" >> audit.xml
else
    echo "<ssh_root_login>Root login via SSH is disabled</ssh_root_login>" >> audit.xml
fi

# Check for unauthorized access to sensitive files
echo "Checking for unauthorized access to sensitive files..."
chmod -R go-rwx /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd
ls -alh /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd | awk '{print "<file_permission>" $0 "</file_permission>"}' >> audit.xml

# Close the XML file
echo "</security_audit>" >> audit.xml