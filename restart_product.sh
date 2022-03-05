#!/usr/bin/env bash

# VARS
source ./include/vars.sh

az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "killall bash; docker kill $(docker ps -q); $start_cmd"
