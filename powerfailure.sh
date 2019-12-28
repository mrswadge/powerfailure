#!/bin/bash
powerdir=~/powerfailure
mkdir -p "$powerdir"
powercsv="$powerdir/powerfailure.csv"
powertouch="$powerdir/powerlast.touch"
frequency=60                  # seconds
margin=$(($frequency+($frequency/2)))
if [ ! -f "$powercsv" ]; then
  echo "timestamp,weekofyear,dayofyear,day,date,month,year,hour,minute" > "$powercsv"
fi
if [ ! -f "$powertouch" ]; then
  touch "$powertouch"
fi
last=$(date -r "$powertouch" +%s) # seconds since epoch
now=$(($(date +%s)))              # seconds since epoch
lastdate=$(date -d "@$last")
nowdate=$(date -d "@$now")
# echo "Last: $last, Now: $now, Last Date: $lastdate, Now Date: $nowdate"
if [ $now -lt $last ]; then
  # first run ever
  echo "$now" > "last"
  echo "Reset power last variable"
  echo "Reported: $(date)"
  echo "Last: '$last' -> $(date -d "@$last")"
  echo "Current: $now' -> $(date -d "@$now")"
else
  # aim is to detect gaps greater than the run frequency.
  # echo "margin $margin frequency $frequency"
  touch "$powertouch"
  gap=$(($now-$last))
  if [ $gap -gt $margin ]; then
    echo "Reported: $(date)"
    echo "Last: '$last' -> $(date -d "@$last")"
    echo "Current: '$now' -> $(date -d "@$now")"
    echo "$nowdate: Power interruption detected at $lastdate! $gap exceeds $margin second limit."
    weekofyear=$(date -d "@$last" +%V)
    dayofyear=$(date -d "@$last" +%j)
    day=$(date -d "@$last" +%a)
    date=$(date -d "@$last" +%d)
    month=$(date -d "@$last" +%m)
    year=$(date -d "@$last" +%y)
    hour=$(date -d "@$last" +%H)
    minute=$(date -d "@$last" +%M)
    echo "$last,$weekofyear,$dayofyear,$day,$date,$month,$year,$hour,$minute" >> "$powercsv"
  fi
fi
