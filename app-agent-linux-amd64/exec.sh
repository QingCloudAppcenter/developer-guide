#!/bin/bash
#
# Copyright (C) 2016 Yunify, Inc.
#
# Script to execute the service such as start/stop application deployed on
# QingCloud AppCenter 2.0 platform.

AGENT_PATH="/opt/qingcloud/app-agent/log"
CMD_INFO=$AGENT_PATH/cmd.info
CMD_LOG=$AGENT_PATH/cmd.log
APP_LOG=$AGENT_PATH/app.log

CMD_LINE=$(sed '/^\s*$/d' "$CMD_INFO")
[[ -z $CMD_LINE ]] && exit 0

CMD_ID=$(echo "$CMD_LINE" | cut -d ":" -f 1)
CMD=$(echo "$CMD_LINE" | cut -d ":" -f 2-)

echo "$(date +"%Y-%m-%d %H:%M:%S") $CMD_ID [executing]: $CMD" >> "$CMD_LOG" 2>&1
eval "$CMD" >> "$APP_LOG" 2>&1
if [ $? -ne 0 ]; then
    echo "$(date +"%Y-%m-%d %H:%M:%S") $CMD_ID [failed]: $CMD" >> "$CMD_LOG" 2>&1
    exit 1
fi

echo "$(date +"%Y-%m-%d %H:%M:%S") $CMD_ID [successful]: $CMD" >> "$CMD_LOG" 2>&1
exit 0
