#!/bin/bash
#
# Copyright (C) 2016 Yunify Inc.
#
# Script to install packages for preparing image that is deployed on QingCloud
# AppCenter 2.0 platform.

# Return info when executing commands
run() {
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo "Error: $1" >&2
    fi
    return $status
}

AGENT_PATH="/opt/qingcloud/app-agent"

ETC_DIR="/etc"
BIN_DIR=$AGENT_PATH/bin
LOG_DIR=$AGENT_PATH/log
RUN_DIR=$AGENT_PATH/run

mkdir -p $ETC_DIR
mkdir -p $BIN_DIR
mkdir -p $LOG_DIR
mkdir -p $RUN_DIR

# Prepare confd
run install -m 755 ./bin/confd $BIN_DIR

# Prepare confd service management based on Linux distribution

os=$(run ./check-distro.sh)
if echo "$os" | grep 'ubuntu' > /dev/null; then
    run cp ./distros/ubuntu/confd /etc/init.d/
elif echo "$os" | grep 'debian' > /dev/null; then
    run cp ./distros/debian/confd /etc/init.d/
elif echo "$os" | grep 'centos' > /dev/null; then
    if echo "$os" | grep 'version_id="7"' > /dev/null; then
        run cp ./distros/centos/7/confd /etc/init.d/
    elif echo "$os" | grep '6\.' > /dev/null; then
        run cp ./distros/centos/6/confd /etc/init.d/
    else
        echo "unsupported centos version, install failed"
        exit 1
    fi
elif echo "$os" | grep 'fedora' > /dev/null; then
    run cp ./distros/fedora/confd /etc/init.d/
elif echo "$os" | grep 'opensuse' > /dev/null; then
    run cp ./distros/opensuse/confd /etc/init.d/
else
    echo "unsupported os, install failed"
    exit 1
fi

if [ $? -ne 0 ]; then
    echo "install failed"
fi

# Prepare confd daemon folders
run mkdir -p $ETC_DIR/confd/conf.d;
run mkdir -p $ETC_DIR/confd/templates

# Prepare cmd stuff
run cp ./config/cmd.info.toml $ETC_DIR/confd/conf.d/
run cp ./config/cmd.info.tmpl $ETC_DIR/confd/templates/
run touch $LOG_DIR/cmd.info
run touch $LOG_DIR/cmd.log
run cp ./exec.sh $BIN_DIR
run chmod +x $BIN_DIR/exec.sh

# Prepare logrotate conf
run cp ./config/app-agent /etc/logrotate.d/app-agent

if [ $? -eq 0 ]; then
    echo "installed successfully"
fi
