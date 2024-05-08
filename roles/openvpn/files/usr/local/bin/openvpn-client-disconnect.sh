#!/bin/bash
#
#  Log the disconnection of client in the audit log defined in param 1
#
usage() {
    echo
    echo "usage in openvpnv server config:"
    echo
    echo "client-disconnect /usr/local/bin/openvpn-client-disconnect.sh <audit log file> [debug]"
    echo
}

if [ ! -z "$2" ]; then
    echo 'debugging'
    set -x
    env
fi

if [ -z "$1" ]; then
    echo 'Must specify Audit Log in first parameter'
    usage
    exit 1
else
    AUDITLOG=$1
fi

timestamp=`date -u +"%Y-%m-%dT%H:%M:%SZ"`
message="${timestamp};${HOSTNAME};disconnect;${common_name};${untrusted_ip};${ifconfig_pool_remote_ip}"

echo $message >> ${AUDITLOG}
