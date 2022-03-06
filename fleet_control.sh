#!/usr/bin/env bash

# VARS
VM_NAME_BASE="we-demo"
VM_NUM=4
PRODUCT="DDOSER"
LOG_PATH="./concurrent_log"
CMDS=("create_vm.sh"
        "delete_vm.sh"
        "update_product.sh"
        "restart_product.sh")

# BEGIN FUNCTIONS
greeter () {
  echo -e "============================================================================\n
  VM base name:         $VM_NAME_BASE
  Num VMs:              $VM_NUM
  Product:              $PRODUCT
  Concurrent log path:  $LOG_PATH \n\n
  create_vm.sh        - creates $VM_NUM (1-$VM_NUM) VMs with default product \n
  delete_vm.sh        - deletes $VM_NUM (1-$VM_NUM) VMs and associated resources \n
  update_product.sh   - re-execs respective cloud-init on VMs (1-$VM_NUM) \n
  restart_product.sh  - restarts product on VMs (1-$VM_NUM) \n
============================================================================\n\n"


  for i in $(seq 0 $((${#CMDS[@]}-1))); do
    echo "$i - ${CMDS[$i]}"
  done
  echo "q - quit"
  echo -e "\n"
}
# END FUNCTIONS

while :; do
  clear
  greeter
  read -p 'CMD number > ' cmd_num

  case $cmd_num in
          [0-9])
                  if [ $cmd_num -ge ${#CMDS[@]} ] || [ $cmd_num -lt 0 ]; then
                    echo "ERROR: numbers from 0 to $((${#CMDS[@]}-1))"
                    read -p '> '
                  else
                    for i in $(seq 1 $VM_NUM); do
                      mkdir -p $LOG_PATH
                      echo "======================================================" | tee ${LOG_PATH}/${VM_NAME_BASE}${i}_log
                      echo "COMMAND: bash ./${CMDS[$cmd_num]} ${VM_NAME_BASE}${i}" | tee -a ${LOG_PATH}/${VM_NAME_BASE}${i}_log
                      echo "LOG: ${LOG_PATH}/${VM_NAME_BASE}${i}_log"
                      echo "======================================================" | tee -a ${LOG_PATH}/${VM_NAME_BASE}${i}_log
                      bash ./${CMDS[$cmd_num]} ${VM_NAME_BASE}${i} $PRODUCT 2>&1 >> ${LOG_PATH}/${VM_NAME_BASE}${i}_log &
                    done
                    exit 0
                  fi
                  ;;
          q)
                  echo "Quitting"
                  exit 0
                  ;;
          *)
                  echo "ERROR: unrecognized input: $cmd_num"
                  read -p '> '
                  ;;
  esac
done
