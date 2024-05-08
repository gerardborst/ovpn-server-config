#!/bin/bash
set -ex

openvpn_version=2.5.8
build_version=1

save_dir=$PWD

SCRIPT_DIR=$(dirname $0)
cd ${SCRIPT_DIR}
SCRIPT_DIR=$PWD

docker run -ti -v $PWD:/build --rm -w /build gcc:9.5.0-buster ./create_openvpn.sh ${openvpn_version} ${build_version}

cd ${save_dir}