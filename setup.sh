#!/bin/bash

# PROBLEMAS COM DNSMASQ
# Ao instalar o dnsmasq e tentar iniciá-lo, dará conflito com a porta 53, que já está em uso pelo systemd-resolved.
# Para resolver, é preciso seguir os passos a seguir:
#
# 1 - Desativar o systemd-resolved
# sudo systemctl disable systemd-resolved && sudo systemctl stop systemd-resolved
# 
# 2 - Remover o link simbólico resolv.conf
# sudo rm /etc/resolv.conf
# 
# 3 - Criar um novo arquivo /etc/resolv.conf com o seguinte conteúdo
# nameserver 127.0.0.1
# nameserver 8.8.8.8
#
# 4 - Editar o arquivo /etc/dnsmasq.conf, removendo o comentário nas seguintes linhas: (após já ter instalado o dnsmasq)
# port=53 //Essa linha deve ser descomentada e alterar 5353 para 53
# domain-needed
# bogus-priv
# strict-order
# expand-hosts
# listen-address=127.0.0.1
# 
# 5 - Editar o arquivo /etc/NetworkManager/NetworkManager.conf, para que ele não gere um novo /etc/resolv.conf a cada reinicialização
# Neste arquivo, adicionar dns=none na seção [main]
# 
# 6 - Reiniciar o dnsmasq com o comando:
# sudo systemctl restart dnsmasq
# 
# Acessar este link como referência: https://computingforgeeks.com/install-and-configure-dnsmasq-on-ubuntu-18-04-lts/

# global vars.
UBUNTU_VER=$(lsb_release -sr)
PHPSTORM_VER=2016.2.1
DOCKERCOMPOSE_VERSION=18.06.0-ce

# apt-get init.
sudo apt-get update --fix-missing
sudo apt-get install -y curl dnsmasq git gitg openjdk-8-jre apt-transport-https ca-certificates

# docker-apt-key
sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

# dnsmasq
echo "address=/localhost/127.0.0.1" | sudo tee /etc/dnsmasq.d/localhost.conf > /dev/null
echo "address=/docker/127.0.0.1" | sudo tee /etc/dnsmasq.d/docker.conf > /dev/null
sudo service dnsmasq restart

# add docker repo.
case $UBUNTU_VER in
   "16.04") DOCKER_REPO="deb https://apt.dockerproject.org/repo ubuntu-xenial main";;
   "15.10") DOCKER_REPO="deb https://apt.dockerproject.org/repo ubuntu-xenial main";;
   "14.04") DOCKER_REPO="deb https://apt.dockerproject.org/repo ubuntu-trusty main";;
   "12.04") DOCKER_REPO="deb https://apt.dockerproject.org/repo ubuntu-precise main";;
   *) echo "Sorry, docker repo unavailable for your Ubuntu version.";;
esac

sudo echo $DOCKER_REPO | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install linux-image-extra-$(uname -r) linux-image-extra-virtual docker-engine

sudo service docker start

# docker group
sudo groupadd docker
sudo usermod -aG docker $USER

sudo curl -L https://github.com/docker/compose/releases/download/${DOCKERCOMPOSE_VERSION}/docker-compose-`uname -s`-`uname -m` | sudo tee /usr/local/bin/docker-compose > /dev/null
sudo chmod +x /usr/local/bin/docker-compose

# PhpStorm
read -p "Install PhpStorm? " -n 1 -r
echo    # move to new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  wget https://download.jetbrains.com/webide/PhpStorm-${PHPSTORM_VER}.tar.gz
  PHPSTORM_DIR=`tar -zxvf PhpStorm-${PHPSTORM_VER}.tar.gz --directory ~/Documents| head -1 | cut -f1 -d"/"`
  rm -rf ~/Documents/${PHPSTORM_DIR}
  tar -zxvf PhpStorm-${PHPSTORM_VER}.tar.gz --directory ~/Documents
  ~/Documents/${PHPSTORM_DIR}/bin/phpstorm.sh &
 fi

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

if [ $(echo "$UBUNTU_VER  >= 15.04" | bc) -eq 1 ]
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
