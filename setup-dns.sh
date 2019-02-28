#!/bin/bash

# apt-get init.
sudo apt-get update --fix-missing
sudo apt-get install -y curl dnsmasq ca-certificates

# dnsmasq
echo "address=/localhost/127.0.0.1" | sudo tee /etc/dnsmasq.d/localhost.conf > /dev/null
echo "address=/docker/127.0.0.1" | sudo tee /etc/dnsmasq.d/docker.conf > /dev/null
sudo service dnsmasq restart

# docker group
sudo groupadd docker
sudo usermod -aG docker $USER

# Services
mkdir ~/.conceptho
cp -R * ~/.conceptho

sudo systemctl enable docker
sudo ln -s ~/.conceptho/workstation.service /etc/systemd/system/workstation.service
sudo sed -i "s@{HOME}@${HOME}@g" /etc/systemd/system/workstation.service
sudo docker network create general
sudo service workstation start