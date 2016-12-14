#!/bin/bash
#######################
# diskuageV2.sh
#######################
#
# Written by: Joseph Walters
# https://github.com/JoeWalters
#
#######################
#
# Calculate the date the disk will be full
# based on the rate of disk usage increases.
#
######################


LOG=/root/usageovertimeV2.csv		# This is where disk usage will be stored over time. 
DISK=/disk/to/check			# The mountpoint to be checked. In the form of a directory, not device

# if $DISK is mounted, send the date and disk usage to $LOG
if grep -qs $DISK /proc/mounts; then 
 echo "$(date +%Y%m%d),$(df $DISK | grep $DISK | awk '{print $3}')" >> $LOG
fi

# The disk analysis logs must have more than 3 entries to proceed.
if [ $(cat $LOG | wc -l) -gt 3 ]; then

 FULL=$(df $DISK | tail -1 | awk '{print $2}') # Max disk space available
 ARRAY=()
 LINES=$(cat $LOG | wc -l) # Number of entries (lines) in the $LOG file

# For each line in the $LOG file
 for i in $(seq 1 $LINES); do 
  if [ ! "$i" -eq "$LINES" ]; then 
   j=$((i+1))
   PAST=$(cut -d, -f2 $LOG | head -n $i | tail -1)
   PRESENT=$(cut -d, -f2 $LOG | head -n $j | tail -1)
   GROWTH=$(awk "BEGIN {print ($PRESENT-$PAST)/$PAST}")			# Calculate growth rate per day
   GROWTH=$(echo $GROWTH | awk '{ print sprintf("%.9f", $1); }')	# Fix the output number
   ARRAY+=($GROWTH)							# Add growth rate to an array
  fi
 done
 GROWTOTAL=$(dc <<< '[+]sa[z2!>az2!>b]sb'"${ARRAY[*]}lbxp")		# Add up daily growth rate
 MINUSLINES=$(((LINES--)))
 GROWAVG=$(awk "BEGIN {print $GROWTOTAL/$MINUSLINES}")			# Average growth average

# Loop - Adding the growth average until hitting max space.
 DAY=1
 while ( test "$PRESENT" -le "$FULL" ); do
  PRESENT=$(awk "BEGIN {print $PRESENT+($PRESENT*$GROWAVG)}")
  printf -v PRESENT "%f" "$PRESENT" 
  PRESENT=$(echo $PRESENT | awk 'BEGIN{FS=OFS="."} NF--')
  DAY=$(expr $DAY + 1)
 done

# Results below. This can be changed to output to a file or whatever.
 echo "Estimated date disk will be full: $(date --date="+$DAY days" +"%B %d %Y")"
fi
