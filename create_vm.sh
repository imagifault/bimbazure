#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az vm create \
  --resource-group  $RESOURCE_GRP\
  --name $VM_NAME \
  --location $LOCATION \
  --eviction-policy Delete \
  --size Standard_DC1s_v2 \
  --priority Spot \
  --max-price $MAX_PRICE \
  --admin-username azureuser \
  --authentication-type ssh \
  --ssh-key-values $KEY_PATH \
  --os-disk-delete-option Delete \
  --tags $TAGS \
  --nic-delete-option Delete \
  --public-ip-address-allocation dynamic \
  --image canonical:0001-com-ubuntu-server-focal:20_04-lts-gen2:latest
#  --custom-data include/cloud-init.sh


#  --image Canonical:UbuntuServer:18.04-LTS:latest \
#  --image UbuntuLTS \

# open ssh port. We are not going to set lbs in this example
az vm open-port --resource-group $RESOURCE_GRP --name $VM_NAME --port 22

# disable boot diagnostics. Reduce cost!
#az vm boot-diagnostics disable --ids $(az vm list -g $RESOURCE_GRP --query "[].id" -o tsv)
az vm boot-diagnostics disable --resource-group $RESOURCE_GRP --name $VM_NAME

# next step seems to have failed; possibly more time?
sleep 10s
# init script 2nd try
az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$(cat ./include/$dependencies)"
az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$(cat ./include/$init)"
az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$start_cmd"
