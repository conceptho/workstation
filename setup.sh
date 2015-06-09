#!/bin/sh

sudo apt-get update --fix-missing
sudo apt-get install -y curl dnsmasq git gitg openjdk-7-jre
echo "address=/localhost/127.0.0.1" | sudo tee /etc/dnsmasq.d/localhost.conf > /dev/null
sudo service dnsmasq restart 

sudo wget -qO- https://get.docker.com/ | sh

sudo service docker start

sudo curl -L https://github.com/docker/compose/releases/download/1.2.0/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose

wget http://download.netbeans.org/netbeans/8.0.2/final/bundles/netbeans-8.0.2-php-linux.sh
chmod +x netbeans-8.0.2-php-linux.sh
./netbeans-8.0.2-php-linux.sh

mkdir ~/.conceptho

cp -R * ~/.conceptho
sudo ln -s ~/.conceptho/upstart.conf /etc/init/workstation.conf
sudo sed -i --follow-symlinks "s@{HOME}@${HOME}@g" /etc/init/workstation.conf
sudo start workstation
