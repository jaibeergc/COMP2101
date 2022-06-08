#!/bin/bash

# The system hostname
echo -n "Host Name: " 
hostname
echo '-----------------------------------------------------'

# The system DNS domain name if it has one

echo -n "Domain Name: "
hostname -d
echo ''
echo '-----------------------------------------------------'

# The operating system name and version, identifying the Linux distro in use
echo "Operating System Name and Version: "
hostnamectl | awk "/Operating/ {print}"
echo '-----------------------------------------------------'

# Any IP addresses the machine has that are not on the 127 network (do not include ones that start with 127)
echo -n "IP Addresses: "
hostname -I
echo '-----------------------------------------------------'

# The amount of space available in the root filesystem, displayed as a human-friendly number
echo "Root Filesystem Status: "
df -h
echo '-----------------------------------------------------'