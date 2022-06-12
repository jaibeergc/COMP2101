#!/bin/bash

# Title
echo "============================"
echo "Report for my VM"
echo "============================"
# Information Starts from here

# F
fqdn=$(hostname --fqdn)
echo "FQDN: $fqdn"

# Operating System name and version
osnv=$(uname -om)
echo "Operating System name and version: $osnv"

# IP Address
ipaddr=$(hostname -I)
echo "IP Address: $ipaddr"

# Root Filesystem Free Space
rffs=$(df / -h | grep sda | awk '{print $4}')
echo "Root Filesystem Free Space: $rffs"

# Information Ends here
echo "============================"