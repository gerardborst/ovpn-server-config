#!/bin/bash
set -e

save_dir=$PWD

SCRIPT_DIR=$(dirname $0)
cd ${SCRIPT_DIR}
SCRIPT_DIR=$PWD

node_exporter_version=1.1.2

#############################################
# generate openvpn keys and certs
#############################################
cd config/openvpn/certs
export EASYRSA=$PWD
rm -rf pki
mkdir pki
cp openssl-easyrsa.cnf pki/
echo yes | /usr/share/easy-rsa/easyrsa init-pki

echo "OpenVPN Development" | /usr/share/easy-rsa/easyrsa build-ca nopass
# generate certificate refocation list
/usr/share/easy-rsa/easyrsa gen-crl
# server key and certificate
/usr/share/easy-rsa/easyrsa build-server-full vpn1 nopass
export EASYRSA_CERT_EXPIRE=1
# certificates for a test client
/usr/share/easy-rsa/easyrsa build-client-full user01 nopass

cd ${SCRIPT_DIR}

#############################################
# end
#############################################

export ROOT_PASSWORD="root"
export PRIVATE_KEY_NAME="private_key"
export PRIVATE_KEY_DIRECTORY="development/.vagrant/machines/vpn1/virtualbox"

export ANSIBLE_HOST_KEY_CHECKING=False

export LDAP_BIND_PASSWORD='123456'
export MGMT_PWD=$(echo 'wachtwoord' | base64)
export VPN_TA_KEY=$(cat config/openvpn/certs/ta.key | base64)
export vpn1_key=$(cat config/openvpn/certs/pki/private/vpn1.key | base64)

INVENTORY=${SCRIPT_DIR}/openvpn-development.inventory

cd ..

echo "run playbooks..."
./run_playbook.sh vagrant ${INVENTORY} openvpn.yaml
if [ "$?" -gt 4 ]; then
    echo "ERROR in playbook run"
    exit 8
fi
        
cd ${save_dir}

# wait a few seconds
echo "wait a few seconds..."
sleep 15

sudo cp /vagrant/development/config/workplace/user01.ovpn /etc/openvpn/user01.conf
sudo sed -i "s/^#AUTOSTART=\"all\"/AUTOSTART=\"all\"/g" /etc/default/openvpn

echo "restart client and test vpn..."
sudo systemctl restart openvpn@user01
counter=0
while [ ${counter} -lt 5 ]; do
    counter=$((${counter}+1))
    curl -m 20 172.30.74.75
    if [ "$?" -eq 0 ]; then
        echo "VPN test successfull"
        exit 0
    fi
    echo "connection error..."
    echo "retry after 10 seconds..."
    sleep 10
done

echo "ERROR in test"
exit 8
