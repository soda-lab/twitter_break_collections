#!/usr/bin/env bash

# get ip and port from ini file
IP=$(awk -F "=" '/IP/ {print $2}' config.ini)
Port=$(awk -F "=" '/MongoDB-Port/ {print $2}' config.ini)

# get all collections name
collections=$(mongo $IP:$(($Port))/Twitter --quiet --eval "db.getCollectionNames().join(',')" | sed 's/,/ /g')

# get current timestamp
currenttimestamp=$(date +%s000)
echo $currenttimestamp

# get current year
currentyear=$(date +'%Y')
echo $currentyear

# get current week
currentweek=$(((((($currenttimestamp-1546214400000))/604800000))+1))
echo $currentweek

array=()

# get all old collections based on year and week
for col in $collections; do
  if [[ $col == 20* ]]; then
    year=${col:0:4}
    left=${col#*_W}
    week=${left%_T*}
    if [[ $year -lt $currentyear ]]; then
      array+=($col)
    else
      if [[ $week -lt $currentweek ]]; then
        array+=($col)
      fi
    fi
  fi
done

# dump collection and drop it after
for i in ${array[@]}; do

  echo "ready to dump collection '$i'"
  #mongodump --archive=mongodb_$i.gz --gzip --host $IP --port $Port --db Twitter -c $i && mongo $IP:$(($Port))/Twitter --eval "db['$i'].drop()" && echo "collection '$i' done: already dumped and droped from database"

done
