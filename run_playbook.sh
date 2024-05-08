#!/bin/bash
set -e

INVENTORY=
GROUPNAME=
PLAYBOOK=
INSTALL_VSTS=${INSTALL_VSTS:-"false"}
if [ -z "$1" ] || [ -z "$2" ] || [ -z "$3" ]; then
    echo "ERROR: inventory or groupname or playbook parameter not set"
    usage
    exit 8
else
    GROUPNAME="$1"
    INVENTORY="$2"
    PLAYBOOK="$3"
fi

usage() {
    echo "usage: run_playbook <Ansible groupname> <Ansible inventory> <Ansible playbook>"
}

export ANSIBLE_HOST_KEY_CHECKING=False
#export ANSIBLE_DEBUG=1

save_dir=$PWD

cd $(dirname $0)

echo "creating inventory..."

cp ${INVENTORY} inventory
sed -i "s/@@private-key-dir@@/${PRIVATE_KEY_DIRECTORY//\//\\/}/g" inventory

echo "inventory:"
echo
cat inventory

chmod 600 ${PRIVATE_KEY_DIRECTORY}/${PRIVATE_KEY_NAME}

ansible --version

echo "run playbook..."

ansible-playbook -i inventory \
        --extra-vars="groupname=${GROUPNAME} install_vsts=${INSTALL_VSTS}" \
        ${PLAYBOOK}
if [ "$?" -gt 4 ]; then
    echo "ERROR in playbook run"
    exit 8
fi
