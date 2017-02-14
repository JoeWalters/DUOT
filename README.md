# Disk Usage Over Time - DUOT

This is a two part script.

1. diskusage.sh checks the disk usage of a particular mount point and outputs it to a specified csv file as YYMMDD,diskusage (ie: 20161214,21452214). If run every day, this can be useful for tracking your usage in excel or libreCalc in a pretty graph. This script should be run as frequently as possible. Preferably, diskusage.sh would be run daily in a cron. The more times this script is run, the more accurate it should become due to the fluctuations in disk usage.

2. estimatefull.sh approximates when your disk will be full based on your growth average (Which is generated using the csv file).

## Usage

```
root@localhost:/tmp# ./estimatefull.sh
Estimated date disk will be full: September 08 2018
```
It is recommended that the estimatefull.sh script is run daily to better calculate the growth average over time. You can put this in a cron job or run it manually.

## Setting up the application
Change the LOG and DISK variable accordingly in DUOT.conf
```
LOG=/root/usageovertimeV2.csv           # This is where disk usage will be stored over time.
DISK=/disk/to/check                     # The mountpoint to be checked. In the form of a directory, not device
```

## Info

---

