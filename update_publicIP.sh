#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az network nic ip-config update \
  --name ipconfig${VM_NAME} \
  --nic-name ${VM_NAME}VMNic \
  --resource-group $RESOURCE_GRP \
  --remove publicIpAddress

az network public-ip delete -g $RESOURCE_GRP -n ${VM_NAME}PublicIP

az network public-ip create -g $RESOURCE_GRP -n ${VM_NAME}PublicIP --allocation-method Dynamic

az network nic ip-config update \
  --name ipconfig${VM_NAME} \
  --nic-name ${VM_NAME}VMNic \
  --resource-group $RESOURCE_GRP \
  --public-ip-address ${VM_NAME}PublicIP
