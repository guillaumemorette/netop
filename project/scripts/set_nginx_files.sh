#!/bin/bash
# Store Nginx files in a share

export AZURE_STORAGE_ACCOUNT=$1
export AZURE_STORAGE_ACCESS_KEY=$2

az storage file upload --share-name $3 --source ssl.key
az storage file upload --share-name $3 --source ssl.crt
az storage file upload --share-name $3 --source nginx.conf
