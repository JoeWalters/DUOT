#!/bin/bash
USAGEFILE="/root/usageovertimeV2.csv"
DISK=/disk/to/check

FULL=$(df $DISK | tail -1 | awk '{print $2}')
ARRAY=()
LINES=$(cat $USAGEFILE | wc -l)

for i in $(seq 1 $LINES); do 
 if [ ! "$i" -eq "$LINES" ]; then 
  j=$((i+1))
  PAST=$(cut -d, -f2 $USAGEFILE | head -n $i | tail -1)
  PRESENT=$(cut -d, -f2 $USAGEFILE | head -n $j | tail -1)
  GROWTH=$(awk "BEGIN {print ($PRESENT-$PAST)/$PAST}")
  GROWTH=$(echo $GROWTH | awk '{ print sprintf("%.9f", $1); }')
  ARRAY+=($GROWTH)
 fi
done
GROWTOTAL=$(dc <<< '[+]sa[z2!>az2!>b]sb'"${ARRAY[*]}lbxp")
MINUSLINES=$(((LINES--)))
GROWAVG=$(awk "BEGIN {print $GROWTOTAL/$MINUSLINES}")

DAY=1
while ( test "$PRESENT" -le "$FULL" ); do
 PRESENT=$(awk "BEGIN {print $PRESENT+($PRESENT*$GROWAVG)}")
# PRESENT=$(echo $NEW | awk '{ print sprintf("%.9f", $1); }' | awk 'BEGIN{FS=OFS="."} NF--')
 printf -v PRESENT "%f" "$PRESENT" 
 PRESENT=$(echo $PRESENT | awk 'BEGIN{FS=OFS="."} NF--')
 DAY=$(expr $DAY + 1)
done

echo "Estimated date disk will be full: $(date --date="+$DAY days" +"%B %d %Y")"

