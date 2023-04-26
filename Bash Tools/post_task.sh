#!/bin/bash

# Stop and disable firewalld
systemctl stop firewalld
systemctl disable firewalld
if [[ $(systemctl is-enabled firewalld) == "disabled" ]]; then
    echo "Firewalld is disabled."
else
    echo "Failed to disable firewalld."
    exit 1
fi

# Set SELinux to permissive mode
sed -i 's/^SELINUX=.*/SELINUX=permissive/g' /etc/selinux/config
if [[ $(getenforce) == "Permissive" ]]; then
    echo "SELinux is set to permissive."
else
    echo "Failed to set SELinux to permissive."
    exit 1
fi

# Configure sshd
sed -i 's/^#Port 22/Port 222/' /etc/ssh/sshd_config
sed -i 's/^#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
sed -i 's/^#UseDNS yes/UseDNS no/' /etc/ssh/sshd_config
systemctl restart sshd
echo "sshd configuration complete."

sleep 10

# Reboot the server
reboot