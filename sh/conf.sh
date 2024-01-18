#!/bin/bash

# Reading username and password from arguments
USERNAME="$1"
PASSWORD="$2"

# Function to exit in case of error
exit_on_error() {
    echo "Error: $1" 1>&2
    exit 1
}

# Check if the script is run as root
[ "$(id -u)" -eq 0 ] || exit_on_error "This script must be run as root"

# Check if the user already exists
if id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME already exists. Checking for necessary adjustments."

    # Add user to the sudo group if not already in it
    if ! groups "$USERNAME" | grep -q '\bsudo\b'; then
        usermod -aG sudo "$USERNAME" || exit_on_error "Failed to add user $USERNAME to sudo group"
        echo "User $USERNAME added to sudo group."
    fi

    # Update the user's password
    echo "$USERNAME:$PASSWORD" | chpasswd || exit_on_error "Failed to update password for user $USERNAME"
    echo "Password for user $USERNAME updated successfully."
else
    # Creating a new user and setting the password
    useradd -m -s /bin/bash "$USERNAME" || exit_on_error "Failed to create user $USERNAME"
    echo "$USERNAME:$PASSWORD" | chpasswd || exit_on_error "Failed to set password for user $USERNAME"
    usermod -aG sudo "$USERNAME" || exit_on_error "Failed to add user $USERNAME to sudo group"
    echo "User $USERNAME created and added to sudo group."
fi

swapoff -a
sudo sed -i '/ swap / s/^/#/' /etc/fstab

# Changing the hostname

#if [ "$(hostname)" != "master-node" ]; then
#    sudo hostnamectl set-hostname "master-node"
#    exec bash
#fi

# Update hosts

if ! grep -q "10.0.0.2 the-server" /etc/hosts; then
    echo "10.0.0.2 the-server" | sudo tee -a /etc/hosts
fi

# Load kernel modules

cat << EOF | sudo tee /etc/modules-load.d/k8s.conf
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter

# Sysctl configuration

cat << EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-iptables  = 1
net.bridge.bridge-nf-call-ip6tables = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system

apt-get update
apt-get install -y apt-transport-https ca-certificates curl