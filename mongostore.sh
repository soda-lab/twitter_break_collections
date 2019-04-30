#!/usr/bin/env bash

# get folder, collection_name and db_name from ini file
folder=$(awk -F "=" '/Folder/ {print $2}' config.ini)
collection_name=$(awk -F "=" '/Collection-Name/ {print $2}' config.ini)
db_name=$(awk -F "=" '/DB-Name/ {print $2}' config.ini)

#read files from the folder and restore it to mongodb
for file in $folder/*; do
  echo "ready to restore file $(basename "$file")"
  mongorestore --gzip --archive=$file --db $db_name
  echo "finished file $(basename "$file")"
done
