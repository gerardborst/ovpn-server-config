#!/bin/bash

apt-get update

apt-get install -y ca-certificates \
                   curl \
                   apt-transport-https \
                   lsb-release \
                   gnupg \
                   openvpn \
                   easy-rsa \
                   net-tools \
                   whois \
                   python3 \
                   python3-pip \
                   software-properties-common

apt-add-repository ppa:ansible/ansible
apt update

apt install -y ansible

