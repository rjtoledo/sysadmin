#!/bin/bash
#this script is created to automate task in centos7

#Load Bond Modules
modprobe --first-time bonding

# Prompt the user for the bond interface IP address, netmask, gateway, and DNS
read -p "Enter the IP address for bond0: " ipaddr
read -p "Enter the netmask for bond0: " netmask
read -p "Enter the gateway for bond0: " gateway
read -p "Enter the primary DNS server for bond0: " dns1

# Prompt the user for the first and second slave interfaces
read -p "Enter the first slave interface (e.g. eth0): " slave1
read -p "Enter the second slave interface (e.g. eth1): " slave2

# Create the ifcfg-bond0 file with the specified configuration
cat <<EOF > /etc/sysconfig/network-scripts/ifcfg-bond0
DEVICE=bond0
NAME=bond0
TYPE=bond
BONDING_MASTER=yes
IPADDR=$ipaddr
NETMASK=$netmask
GATEWAY=$gateway
DNS1=$dns1
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=1 miimon=100"
EOF

# Update the ifcfg files for the slave interfaces
for slave in "$slave1" "$slave2"; do
    ifcfg_file="/etc/sysconfig/network-scripts/ifcfg-$slave"
    if [ -f "$ifcfg_file" ]; then
        # Backup existing file
        cp "$ifcfg_file" "${ifcfg_file}.bak"
        # Set BOOTPROTO and ONBOOT values
        sed -i 's/^BOOTPROTO=.*/BOOTPROTO=none/' "$ifcfg_file"
        sed -i 's/^ONBOOT=.*/ONBOOT=yes/' "$ifcfg_file"
        # Set other parameters
        cat <<EOF >> "$ifcfg_file"
MASTER=bond0
SLAVE=yes
EOF
    fi
done

# Reload the NetworkManager configuration
nmcli con reload

# Restart the network service
service network restart
