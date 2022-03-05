#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az group create -l $LOCATION -n $RESOURCE_GRP
az sshkey create --name $KEY_NAME --resource-group $RESOURCE_GRP 2>./key_stderr

key_generated="$(grep -w Private key_stderr | awk -F'"' '{ print $(NF-1) }')"
if [ -n $key_generated ]; then
  mkdir $KEY_DIR
  mv ${key_generated} ${KEY_DIR}/${KEY_NAME}
  mv ${key_generated}.pub ${KEY_DIR}/${KEY_NAME}.pub
  chmod 0600 ${KEY_DIR}/*
else
  echo "ERROR: no key in output"
  cat key_stderr
fi
