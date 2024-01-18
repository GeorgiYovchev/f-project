#!/bin/bash

# Reading username and password from environment variables
USERNAME=$1
PASSWORD=$2

# Check if the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

# Check if the user already exists
if id "$USERNAME" &>/dev/null; then
    echo "Error: User $USERNAME already exists." 1>&2
    exit 1
fi

# Creating a new user and setting the password
useradd -m -s /bin/bash "$USERNAME"
if [ $? -ne 0 ]; then
    echo "Error: Failed to create user $USERNAME." 1>&2
    exit 1
fi

echo "$USERNAME:$PASSWORD" | chpasswd
if [ $? -ne 0 ]; then
    echo "Error: Failed to set password for user $USERNAME." 1>&2
    exit 1
fi

# Granting sudo privileges
usermod -aG sudo "$USERNAME"
if [ $? -ne 0 ]; then
    echo "Error: Failed to add user $USERNAME to sudo group." 1>&2
    exit 1
fi

echo "User $USERNAME created and added to sudo group."