#!/bin/bash

# This is all I need to run Debian 10 server with
# Docker, Docker Compose and a minimum set of tools for my production servers

# I encourage you to follow these recommendations for Docker:
# - Prefer minimalist official base images
# - Use official, purpose-built images (Also, See [Security Best Practices for Docker Images](https://www.wintellect.com/security-best-practices-for-docker-images/?ref=hackernoon.com))
# - Use tags to reference specific image versions
# - Use multi-stage builds
# - Persist data outside of a container, better with [Volumes](https://docs.docker.com/storage/volumes/)
# - Try to not use a root user whenever possible
# - Leverage Docker enterprise features for additional protection
# - Use Docker compose to use as Infrastructure As Code and keep track using tags

# Define functions
function err() {
  echo -e "\e[01;31m$1\e[0m" >&2
}

# Check something before starting
if [ "$EUID" -ne 0 ]
then
  err "Please run this script as root"
  exit 1
fi

if ! [[ -t 0 ]]; then
  err "This script is interactive, please run: bash <(wget -qO- https://raw.githubusercontent.com/demartis/server-side-scripts/master/fresh-install/debian-docker/start-here.sh)" >&2
  exit 1
fi

echo ""
if [[ $(lsb_release -s -i) == 'Debian' ]];
then
  echo "Found: $(lsb_release -s -d)";
else
  err "Nothing done. Only Debian is supported"
  exit;
fi

echo ""
echo "This script will:"
echo ""
echo "- update all apt packages"
echo "- install latest release of Docker"
echo "- install latest release of Docker Compose"
echo "- run and start on boot Docker engine"
echo ""

read -r -p "Are you sure to proceed? [y/N] " response
case "$response" in
    [yY][eE][sS]|[yY])
        echo ""
        echo "Starting..."
        echo ""
        ;;
    *)
        echo ""
        err "Nothing executed. Bye bye"
        echo ""
        exit
        ;;
esac


# Configure Debian
apt-get -y update --fix-missing
apt-get -y upgrade && ACCEPT_EULA=Y
apt-get -y install --fix-missing \
  nano \
  htop \
  wget \
  git \
  sudo

# Install Docker
# (source: https://docs.docker.com/engine/install/debian/)
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/debian/gpg | sudo apt-key add -

sudo apt-key fingerprint 0EBFCD88

sudo add-apt-repository -y \
   "deb [arch=amd64] https://download.docker.com/linux/debian \
   $(lsb_release -cs) \
   stable"

sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Install Docker Compose
# (source: https://docs.docker.com/compose/install/)
sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sudo systemctl start docker
sudo systemctl enable docker

sudo groupadd docker

# Clean up and free disk space
apt-get -y -q autoremove --purge

# Everything's done!
echo ""
echo "Done"
echo "Installed Docker version $(docker --version)"
echo "Installed Docker Compose version $(docker-compose --version)"
echo ""
echo "Thanks for using this script."
echo "Please contact me if any errors/suggestions: riccardodemartis@hotmail.com"
echo ""
