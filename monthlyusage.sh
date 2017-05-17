#!/bin/bash

####################
# plotdiskusageGB.sh
####################
#
# Written by: Joseph Walters
# https://github.com/JoeWalters/DUOT
#
####################
#
# Output disk usage to a file (to be used monthly)
#
####################

MYSELF="$(realpath "$0")"
MYDIR="${MYSELF%/*}"

source $MYDIR/DUOT.conf

#Output current disk usage to file
echo "$(date +%Y-%m) $(df -BG | grep common | awk '{print $3}' | sed -e 's/G//g')" >> $MONTHLYLOG

exit 0
