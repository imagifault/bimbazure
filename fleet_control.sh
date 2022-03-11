#!/usr/bin/env bash

# VARS
source ./include/vars.sh
VM_NAME_BASE="we-demo"
VM_NUM=4
#PRODUCT="DDOSER"
LOG_PATH="./concurrent_log"
CMDS=("create_vm.sh"
        "delete_vm.sh"
        "update_product.sh"
        "restart_product.sh"
        "update_publicIP.sh")

# BEGIN FUNCTIONS
choose_product () {
  echo "Choose product: "
  for i in $(seq 0 $((${#VALID_PRODUCTS[@]}-1))); do
    echo "$i - ${VALID_PRODUCTS[$i]}"
  done
  echo "q - quit"
  echo -e "\n"
  read -p 'Product number > ' prdct_num
}


greeter () {
  echo -e "============================================================================\n
  Location:             $LOCATION
  Resource group:       $RESOURCE_GRP
  VM base name:         $VM_NAME_BASE
  Num VMs:              $VM_NUM
  Starting with:        ${VM_NAME_BASE}${vm_start}
  Ending with with:     ${VM_NAME_BASE}${vm_end}
  Product:              $PRODUCT
  Concurrent log path:  $LOG_PATH \n\n
  create_vm.sh        - creates $(($vm_end-$vm_start+1)) ($vm_start-$vm_end) VMs
  delete_vm.sh        - deletes $(($vm_end-$vm_start+1)) ($vm_start-$vm_end) VMs and associated resources
  update_product.sh   - re-execs respective cloud-init on VMs (1-$VM_NUM)
  restart_product.sh  - restarts product on VMs (1-$VM_NUM)
  update_publicIP.sh  - re-creates public IP on VMs (1-$VM_NUM) \n
============================================================================\n\n"


  for i in $(seq 0 $((${#CMDS[@]}-1))); do
    echo "$i - ${CMDS[$i]}"
  done
  echo "q - quit"
  echo -e "\n"
}
# END FUNCTIONS

while [ -z "$(echo $(seq 0 $((${#VALID_PRODUCTS[@]}-1))) | grep -w $prdct_num)" ]; do
        if [ "$prdct_num" == "q" ]; then
                echo "Quitting"
                exit 0
        fi
        choose_product
done
PRODUCT="${VALID_PRODUCTS[$prdct_num]}"

# VM start
read -p "VM index start (1 - $VM_NUM) > " vm_start
while [ -z "$(echo $(seq 1 $VM_NUM) | grep -w $vm_start)" ]; do
        if [ "$vm_start" == "q" ]; then
                echo "Quitting"
                exit 0
        fi
        read -p "VM index start (1 - $VM_NUM) > " vm_start
done

# VM end
read -p "VM index end ($vm_start - $VM_NUM) > " vm_end
while [ -z "$(echo $(seq $vm_start $VM_NUM) | grep -w $vm_end)" ]; do
        if [ "$vm_start" == "q" ]; then
                echo "Quitting"
                exit 0
        fi
        read -p "VM index start ($vm_start - $VM_NUM) > " vm_end
done

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
                    for i in $(seq $vm_start $vm_end); do
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
