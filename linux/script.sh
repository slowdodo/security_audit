#!/bin/bash

# This script performs a security check on a Linux system.

# Check for -h option
if [ "$1" == "-h" ]; then
  echo "Usage: security_check.sh [OPTION] [IP]"
  echo "Perform a security check on a Linux system"
  echo ""
  echo "  -h  display this help and exit"
  echo "  -i  specify an IP address to replace 127.0.0.1"
  echo "example sudo bash security_check.sh -i 1.1.1.1 "
  exit
fi

# Check for -i option
if [ "$1" == "-i" ]; then
  ip=$2
else
  ip="127.0.0.1"
fi

# Check for root user
if [ $(id -u) -eq 0 ]; then
  echo "Running script as root"
else
  echo "Please run this script as root"
  exit
fi

# Check for password expiration
expired_users=$(chage -l | grep "Password expires" | grep "never" | awk -F: '{print $2}')
if [ -z "$expired_users" ]; then
  echo "All user passwords are set to expire"
else
  echo "The following users have passwords that do not expire:"
  echo "$expired_users"
fi

# Check for outdated packages
updates=$(apt list --upgradable 2>/dev/null)
if [ -z "$updates" ]; then
  echo "No package updates available"
else
  echo "The following packages have updates available:"
  echo "$updates"
fi

# Check for listening network ports
listening_ports=$(netstat -tulpn | grep -v "$ip")
if [ -z "$listening_ports" ]; then
  echo "No network ports are listening"
else
  echo "The following network ports are listening:"
  echo "$listening_ports"
fi

# sudo bash security_check.sh -i 1.1.1.1
