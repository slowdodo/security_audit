#!/bin/bash

# This script performs a security audit on a Debian Linux system based on the OWASP guidelines
# and converts the output to an XML file for easy extraction and analysis

# Usage instructions
function usage {
    echo "Usage: $0 [OPTION]..."
    echo "Perform a security audit on a Debian Linux system"
    echo ""
    echo "  -h    display this help and exit"
    echo "  -v    verbose mode"
    echo ""
    echo "Examples:"
    echo "  $0"
    echo "  $0 -v"
}

# Parse command-line options
while getopts "hv" opt; do
    case $opt in
        h)
            usage
            exit 0
            ;;
        v)
            verbose=true
            ;;
        \?)
            usage >&2
            exit 1
            ;;
    esac
done

# Check if the user is running the script as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script as root" >&2
    exit 1
fi

# Check for any known vulnerabilities in installed packages
echo "Checking for known vulnerabilities in installed packages..."
if [ "$verbose" = true ]; then
    apt-get update && apt-get --just-print dist-upgrade | grep -P -o -e '(?<=openssl ).*(?=:)' -e '(?<=libssl ).*(?=:)'
else
    apt-get update && apt-get --just-print dist-upgrade | grep -P -o -e '(?<=openssl ).*(?=:)' -e '(?<=libssl ).*(?=:)' > /dev/null
fi

# Convert the output to XML format
echo "<vulnerabilities>" > vulnerabilities.xml
if [ -s vulnerabilities.txt ]; then
    while read vulnerability; do
        echo "  <vulnerability>$vulnerability</vulnerability>" >> vulnerabilities.xml
    done < vulnerabilities.txt
else
    echo "  <vulnerability>None</vulnerability>" >> vulnerabilities.xml
fi
echo "</vulnerabilities>" >> vulnerabilities.xml

# Check for weak passwords
echo "Checking for weak passwords..."
if egrep -q "^.*(?=.{8,})(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).*$" /etc/shadow; then
    echo "Strong password policy is enabled"
# Check for unnecessary services running
echo "Checking for unnecessary services running..."
if [ "$verbose" = true ]; then
    service --status-all | grep -P "^[^?]"
else
    service --status-all | grep -P "^[^?]" > /dev/null
fi

# Convert the output to XML format
echo "<services>" > services.xml
if [ -s services.txt ]; then
    while read service; do
        echo "  <service>$service</service>" >> services.xml
    done < services.txt
else
    echo "  <service>None</service>" >> services.xml
fi
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
if [ "$verbose" = true ]; then
    ls -alh /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd
else
    ls -alh /etc/shadow /etc/ssh/ssh_host_* /etc/gshadow /etc/passwd > /dev/null
fi

# Convert the output to XML format
echo "<sensitive_files>" > sensitive_files.xml
if [ -s sensitive_files.txt ]; then
    while read file; do
        echo "  <file>$file</file>" >> sensitive_files.xml
    done < sensitive_files.txt
else
    echo "  <file>None</file>" >> sensitive_files.xml
fi
echo "</sensitive_files>" >> sensitive_files.xml

# Merge all XML files into one
cat vulnerabilities.xml services.xml sensitive_files.xml > audit_results.xml

# Clean up temporary files
rm vulnerabilities.txt vulnerabilities.xml services.txt services.xml sensitive_files.txt
