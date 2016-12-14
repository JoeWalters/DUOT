#!/bin/bash
DISK=/mnt/common
LOG=/root/usageovertimeV2.csv
if grep -qs $DISK /proc/mounts; then
    echo "$(date +%Y%m%d),$(df $DISK | grep $DISK | awk '{print $3}')" >> $LOG
fi
