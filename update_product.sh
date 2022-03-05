#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$(cat ./include/$init)"
#az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "killall bash; docker kill $(docker ps -q)"
az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "if [ -f /home/azureuser/n.pid ]; then kill \$(cat /home/azureuser/n.pid); rm /home/azureuser/n.pid; fi"
az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$start_cmd"
az vm update \
    --resource-group $RESOURCE_GRP \
    --name $VM_NAME \
    --set tags.Product=$PRODUCT
