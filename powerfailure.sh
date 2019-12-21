#!/bin/bash
powercsv=~/powerfailure.csv
powerlast=/tmp/powerlast.tmp
frequency=60                  # seconds
margin=$(($frequency+($frequency/2)))
if [ ! -f "$powercsv" ]; then
  echo "timestamp,weekofyear,dayofyear,day,date,month,year,hour,minute" > "$powercsv"
fi
if [ ! -f "$powerlast" ]; then
  echo "4133980799" > "$powerlast"
fi
last=$(($(cat "$powerlast"))) # seconds since epoch
now=$(($(date +%s)))          # seconds since epoch
lastdate=$(date -d @$last)
nowdate=$(date -d @$now)
if [ $now -lt $last ]; then
  # first run ever
  echo "$now" > "$powerlast"
else
  # aim is to detect gaps greater than the run frequency.
  # echo "margin $margin frequency $frequency"
  echo "$now" > "$powerlast"
  gap=$(($now-$last))
  if [ $gap -gt $margin ]; then
    echo "$nowdate: Power interruption detected at $lastdate! $gap exceeds $margin second limit."
    weekofyear=$(date -d @$last +%V)
    dayofyear=$(date -d @$last +%j)
    day=$(date -d @$last +%a)
    date=$(date -d @$last +%d)
    month=$(date -d @$last +%m)
    year=$(date -d @$last +%y)
    hour=$(date -d @$last +%H)
    minute=$(date -d @$last +%M)
    echo "$last,$weekofyear,$dayofyear,$day,$date,$month,$year,$hour,$minute" >> "$powercsv"
  fi
fi
