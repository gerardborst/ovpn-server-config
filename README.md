# Configure OpenVPN servers

This repository is to configure the OpenVPN servers.

The configuration is done with Ansible playbooks.

## OpenVPN concentrators

### Add Extra Routes

If extra trusted routes are needed they can be added to the file `extra_routes/extra_trusted_routes.yaml`. 

### Software

#### ovpn-ldap-auth

This module is called by the OpenVPN plugin `ovpn-plugin-auth-script` to authenticate the vpn client.

#### ovpn-plugin-auth-script

This module is build in the `ovpn-plugin-auth-script` project and is a fork of the [auth-script-openvpn](https://github.com/fac/auth-script-openvpn)
 github repository.

#### node_exporter

The `node_exporter` software will be downloaded from [node_exporter on github](https://github.com/prometheus/node_exporter/releases).

If a new version is available the `node_exporter_version` should be changed.

## Common

