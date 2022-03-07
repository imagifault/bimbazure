#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az vm delete -g $RESOURCE_GRP -n $VM_NAME --yes
az network nsg delete -g $RESOURCE_GRP -n ${VM_NAME}NSG
az network public-ip delete -g $RESOURCE_GRP -n ${VM_NAME}PublicIP
az network vnet delete -g $RESOURCE_GRP -n ${VM_NAME}VNET
