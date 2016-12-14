# Disk Usage Over Time - DUOT

DUOT a two part script.

1. On every run, DUOT checks the disk usage of a particular mount point and outputs it to a specified csv file as YYMMDD,diskusage (ie: 20161214,21452214). If run every day, this can be useful for tracking your usage in excel or libreCalc.

2. Approximate when your disk will be full based on your growth average. The more times this script is run, the more accurate it should become due to the fluctuations in disk usage.

## Usage

```
root@localhost:/tmp# ./diskusageV2.sh
Estimated date disk will be full: September 08 2018
```
It is recommended that this script is run daily to better calculate the growth average over time. You can put this in a cron job or run it manually. If you're running this in a cron job, consider commenting out the last "echo" in the script or redirecting ouptut to some log file.

## Setting up the application
Change the LOG and DISK variable accordingly.
```
LOG=/root/usageovertimeV2.csv           # This is where disk usage will be stored over time.
DISK=/disk/to/check                     # The mountpoint to be checked. In the form of a directory, not device
```

## Info

---

