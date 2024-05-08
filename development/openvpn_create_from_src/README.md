```
vagrant ssh -c '/vagrant/create_openvpn.sh 2.5.8'
git clone https://salsa.debian.org/debian/openvpn.git
cd openvpn
gbp import-orig https://swupdate.openvpn.org/community/releases/openvpn-2.5.8.tar.gz
```