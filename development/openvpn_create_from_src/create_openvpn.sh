#!/bin/bash
set -ex
# https://openvpn.net/community-downloads/
# https://openvpn.net/community-resources/sig/

openvpn_version=$1
build_version=$2

apt-get update

apt-get install -y \
	libssl-dev \
	liblzo2-dev \
	libpam0g-dev \
	liblz4-dev \
	libp11-kit-dev \
	libpkcs11-helper1-dev \
	systemd \
	libsystemd-dev \
	pkg-config \
	python3-docutils \
	libcap-ng-dev \
	libnl-genl-3-dev 

wget -O security-openvpn-net.asc https://keys.openpgp.org/vks/v1/by-fingerprint/F554A3687412CFFEBDEFE0A312F5F7B42F2B01E7
gpg --import security-openvpn-net.asc

wget https://swupdate.openvpn.org/community/releases/openvpn-${openvpn_version}.tar.gz
wget https://swupdate.openvpn.org/community/releases/openvpn-${openvpn_version}.tar.gz.asc

gpg --verify openvpn-${openvpn_version}.tar.gz.asc openvpn-${openvpn_version}.tar.gz

tar -xzf openvpn-${openvpn_version}.tar.gz

cd openvpn-${openvpn_version}

export SYSTEMD_ASK_PASSWORD=/bin/systemd-ask-password 
export IFCONFIG=/sbin/ifconfig 
export ROUTE=/sbin/route 
export IPROUTE=/sbin/ip

./configure --prefix=$PWD/result/openvpn/usr --exec-prefix=$PWD/result/openvpn/usr --enable-systemd --enable-pkcs11 --enable-x509-alt-username
make
make install

cd result

rm -rf \
   openvpn/usr/share \
   openvpn/usr/include \
   openvpn/usr/lib/systemd/system/openvpn-client@.service \
   openvpn/usr/lib/openvpn/plugins/*.la \
   openvpn/usr/lib/systemd \
   openvpn/usr/lib/tmpfiles.d

tar -czf openvpn-${openvpn_version}-${build_version}.tar.gz openvpn

mv openvpn-${openvpn_version}-${build_version}.tar.gz /build/

cd /build/

rm -rf openvpn-2.5.8.tar.gz openvpn-2.5.8 openvpn-2.5.8.tar.gz.asc

chown 1000:1000 openvpn-${openvpn_version}-${build_version}.tar.gz

