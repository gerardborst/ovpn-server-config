# OpenVPN development environment.

## Get Started

### prerequisites

- virtualbox
- vagrant

### OpenVPN configuration

This is only needed if the development certificates and keys aren't available any more.

The steps are done on a Linux OS.

### Start vm's

In directory `openvpn-server-config/development` run

```shell

    vagrant up
    vagrant ssh workplace -c /vagrant/development/provision_openvpn.sh
```
### VM's

Host      | Description                        |
 -------- | ---------------------------------- |
workplace | openvpn client and ansible host    |
vpn1      | openvpn server                     |
server    | backend server with ldap and nginx |

### Test
The test is also available after the ansible playbook in vagrant.

In a valid configuration it should be possible to call the nginx from workplace with the following command:
```
    
    vagrant ssh workplace -c 'curl 172.30.74.75'
```

### build openvpn from source

```shell
   cd development/openvpn_create
   vagrant up
   vagrant ssh -c '/vagrant/development/openvpn_create/create_openvpn.sh <version>'
```

