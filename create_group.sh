#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az group create -l $LOCATION -n $RESOURCE_GRP

mkdir -p $KEY_DIR
ssh-keygen -t rsa -b 4096 -C "nobody@nowhere.invalid" -q -N "" -f ${KEY_DIR}/${KEY_NAME}
