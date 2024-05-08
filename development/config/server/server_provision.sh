#!/bin/bash

apt-get -y update
apt-get install -y docker.io docker-compose net-tools

usermod -aG docker vagrant

docker-compose -f /vagrant/development/config/server/docker-compose.yaml up -d

cp /vagrant/development/config/server/interfaces /etc/network/interfaces

echo "restarting server..."
shutdown -r now
