#!/bin/bash

# 1.  Install lxd if necessary
if lxd --version | grep -q '.'; then
    echo "== lxd is already installed =="
else
    sudo DEBIAN_FRONTEND=noninteractive apt-get install -y lxd
fi

# Installing curl if not already installed
if curl --version | grep -q '.'; then
    echo "== curl is already installed =="
else
    sudo apt install curl
fi

# Creating a group with access to LXD
sudo usermod -a -G lxd jaibeer

# 2. Run lxd init –auto if no lxdbr0 exists
if ip a | grep -q 'lxdbr0'; then
    echo "== lxd instance already exists =="
else
    lxd init auto
fi

# 3. Launch a container running Ubuntu server named COMP2101-S22 if necessary
if lxc list | grep -q 'COMP2101-S22 | RUNNING'; then
    echo "== Container is already running =="
else
    lxc launch images:ubuntu/20.04 COMP2101-S22
    lxc exec COMP2101-S22 -- apt update
    lxc exec COMP2101-S22 -- apt upgrade
    echo "== Created and Upgraded the CONTAINER =="
    echo "== Installed Apache2 =="
fi
    

# 5. Install Apache2 in the container if necessary
if lxc exec COMP2101-S22 -- apache2 -v | grep -q 'Server version: Apache/2'; then
    echo "== apache2 is already installed =="
else
    lxc exec COMP2101-S22 -- apt install apache2
fi
    
IP=$(lxc list | grep COMP2101-S22 | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+")

# 6. Retrieve the default web page from the web service with curl and notify the user of success or failure
status=$(curl -s -I -X GET $IP)
if echo "$status" | grep -q 'Content-Type'; then
    echo "== Success! Server Online At http://$IP =="
else
    echo "== Error! Server Offline =="
fi

# 4. Associate the name COMP2101-S22 with the container’s IP address in /etc/hosts if necessary
if grep -q "COMP2101-S22" /etc/hosts; then
    echo "== HOST Entry exists =="
else
    echo "$IP COMP2101-S22" >> /etc/hosts
fi