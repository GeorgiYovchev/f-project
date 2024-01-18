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

# Update and upgrade packages
echo "Updating and upgrading system packages..."
apt-get update && apt-get upgrade -y

# Install Docker
echo "Installing Docker..."
apt-get install -y docker.io
systemctl start docker
systemctl enable docker

# Install Kubernetes tools (Example with Minikube and kubectl)
echo "Installing Kubernetes tools..."
curl -Lo kubectl https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl
chmod +x kubectl
mv kubectl /usr/local/bin/

curl -Lo minikube https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
chmod +x minikube
mv minikube /usr/local/bin/

# Clone the application repository
echo "Cloning application repository..."
git clone https://github.com/your-username/your-python-app-repo.git
cd your-python-app-repo

# Install Python and dependencies
echo "Setting up Python environment..."
apt-get install -y python3 python3-pip
pip3 install -r requirements.txt

# Configure Firewall (Optional)
# ufw allow 5000  # Example for allowing traffic on port 5000

# Run any additional system configuration commands for your application

echo "VM setup complete. Docker and Kubernetes installed, application repository cloned."