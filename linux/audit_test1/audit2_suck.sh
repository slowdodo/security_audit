#!/bin/bash

# This script performs a security audit on a Debian Linux system based on the OWASP guidelines
# and converts the output to an XML file for easy extraction and analysis

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root"
    exit
fi

# Check for any known vulnerabilities in installed packages
echo "Checking for known vulnerabilities in installed packages..."
apt-get update && apt-get --just-print dist-upgrade | grep -P -o -e '(?<=openssl ).*(?=:)' -e '(?<=libssl ).*(?=:)' > vulnerabilities.txt

# Convert the output to XML format
echo "<vulnerabilities>" > vulnerabilities.xml
while read vulnerability; do
    echo "  <vulnerability>$vulnerability</vulnerability>" >> vulnerabilities.xml
done < vulnerabilities.txt
echo "</vulnerabilities>" >> vulnerabilities.xml

# Check for weak passwords
echo "Checking for weak passwords..."
egrep -q "^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$" /etc/shadow && echo "Strong password policy is enabled" || echo "WARNING: Weak password policy is enabled"

# Check for unnecessary services running
echo "Checking for unnecessary services running..."
service --status-all | grep -P "^[^?]" > services.txt

# Convert the output to XML format
echo "<services>" > services.xml
while read service; do
    echo "  <service>$service</service>" >> services.xml
done < services.txt
echo "</services>" >> services.xml

# Check for root login via SSH
echo "Checking for root login via SSH..."
if grep -q "PermitRootLogin yes" /etc/ssh/sshd_config; then
    echo "WARNING: Root login via SSH is enabled"
    echo "<root_ssh_login>enabled</root_ssh_login>" >> services.xml
else
    echo "Root login via SSH is disabled"
    echo "<root_ssh_login>disabled</root_ssh_login>" >> services.xml
fi

# Check for unauthorized access to sensitive files
echo "Checking for unauthorized access to sensitive files..."
chmod -R go-rwx /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd
ls -alh /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd > sensitive_files.txt

# Convert the output to XML format
echo "<sensitive_files>" > sensitive_files.xml
while read file; do
