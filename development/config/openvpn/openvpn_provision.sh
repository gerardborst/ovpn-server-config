#!/bin/bash

cat <<EOF >/etc/hosts 
127.0.0.1   localhost vpn1 vpn1-untrusted.gerard.nl

# The following lines are desirable for IPv6 capable hosts
::1     localhost ip6-localhost ip6-loopback
ff02::1 ip6-allnodes
ff02::2 ip6-allrouters
EOF

cat <<EOF >/etc/network/interfaces.d/50-ansible.cfg
auto eth1
iface eth1 inet static
    address 192.168.56.10/24
    gateway 192.168.56.1

EOF

apt update
apt install -y openvpn resolvconf


