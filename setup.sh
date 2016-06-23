#!/bin/bash

# Docker

sudo apt-get update --fix-missing
sudo apt-get install -y curl dnsmasq git gitg openjdk-7-jre
echo "address=/localhost/127.0.0.1" | sudo tee /etc/dnsmasq.d/localhost.conf > /dev/null
sudo service dnsmasq restart

sudo wget -qO- https://get.docker.com/ | sh

sudo service docker start

sudo curl -L https://github.com/docker/compose/releases/download/1.7.1/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose

# NetBeans

read -p "Install NetBeans? " -n 1 -r
echo 	# move to new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  wget http://download.netbeans.org/netbeans/8.0.2/final/bundles/netbeans-8.0.2-php-linux.sh
  chmod +x netbeans-8.0.2-php-linux.sh
  ./netbeans-8.0.2-php-linux.sh
fi

# Services

mkdir ~/.conceptho
cp -R * ~/.conceptho

read -p "Ubuntu >= 15.04? " -n 1 -r
echo    # move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sudo systemctl enable docker
  sudo ln -s ~/.conceptho/workstation.service /etc/systemd/system/workstation.service
  sudo sed -i "s@{HOME}@${HOME}@g" /etc/systemd/system/workstation.service
  sudo service workstation start
else
  sudo ln -s ~/.conceptho/upstart.conf /etc/init/workstation.conf
  sudo sed -i "s@{HOME}@${HOME}@g" /etc/init/workstation.conf
  sudo start workstation
fi
