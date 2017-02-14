#!/bin/bash
#######################
# diskuage.sh
#######################
#
# Written by: Joseph Walters
# https://github.com/JoeWalters/DUOT
#
#######################
#
# Append date,disk usage to CSV file for later analysis
#
######################

MYSELF="$(realpath "$0")"
MYDIR="${MYSELF%/*}"

source $MYDIR/DUOT.conf


if grep -qs $DISK /proc/mounts; then
    echo "$(date +%Y%m%d),$(df $DISK | grep $DISK | awk '{print $3}')" >> $LOG
fi
