#!/usr/bin/env bash

# VARS
VM_NAME="$1"
RESOURCE_GRP="group_DEMO"
SCRIPT_PATH="$2"

az vm run-command invoke -g $RESOURCE_GRP -n $VM_NAME --command-id RunShellScript --scripts "$(cat $SCRIPT_PATH)"
