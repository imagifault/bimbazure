# bimbazure
Pet project for testing azure small-scale deployment and management

#### WARNING: MHDDOS product is in testing

  - update_product CAN NOT switch to MHDDOS if VM was created with other product
    consider creating new VM to install all required dependencies
  - limits/methods in include/cloud-init-mhddos.sh may not be optimal
  - bombardier is now default layer 7 method for MHDDoS (with proxies)


## UA
#### СТВОРИТИ ГРУПУ РЕСУРСІВ ТА SSH key pair
```
cd bimbazure; bash create_group.sh
```

це створить:

  - resource group (ім'я конфігурується в include/vars.sh)
  - ssh key pair (name configured in include/vars.sh)
  - скопіює пару ssh ключів в ./ssh и видасть права 0600


#### FLEET CONTROL
fleet_control.sh - create/delete vms; update/restaer product
```
cd bimbazure; bash fleet_control.sh
```
pre-requisites:

    - авторизована сессія azure cli
    - ssh key пара (public key прописаний в include/vars.sh)
    - resource group створена в ажурі і сконфігурована в include/vars.sh

```
============================================================================

  Location:             westeurope
  Resource group:       group_DEMO
  VM base name:         we-demo
  Num VMs:              4
  Starting with:        we-demo4
  Ending with with:     we-demo4
  Product:              MHDDOS
  Concurrent log path:  ./concurrent_log 


  create_vm.sh        - creates 1 (4-4) VMs
  delete_vm.sh        - deletes 1 (4-4) VMs and associated resources
  update_product.sh   - re-execs respective cloud-init on VMs (1-4)
  restart_product.sh  - restarts product on VMs (1-4)
  update_publicIP.sh  - re-creates public IP on VMs (1-4) 

============================================================================


0 - create_vm.sh
1 - delete_vm.sh
2 - update_product.sh
3 - restart_product.sh
4 - update_publicIP.sh
q - quit


CMD number > 
```


#### ВИКОНАТИ СКРИПТ
exec_script.sh - виконати баш скрипт на ВМ
```
cd bimbazure

bash exec_script.sh we-demo1 /path/to/script.sh
```

## EN
#### BEFORE CREATING VMs
bash create_group.sh

this will create:

  - resource group with name configured in include/vars.sh
  - create ssh key pair (name configured in include/vars.sh)
  - put ssh key pair under ./ssh and set proper permissions


#### FLEET CONTROL
fleet_control.sh - create/delete vms; update/restaer product

cd bimbazure; bash fleet_control.sh

pre-requisites:

    - authorized azure cli session
    - ssh key pair (public key is set in include/vars.sh)
    - resource group created in azure and configured in include/vars.sh

```
============================================================================

  Location:             westeurope
  Resource group:       group_DEMO
  VM base name:         we-demo
  Num VMs:              4
  Starting with:        we-demo4
  Ending with with:     we-demo4
  Product:              MHDDOS
  Concurrent log path:  ./concurrent_log 


  create_vm.sh        - creates 1 (4-4) VMs
  delete_vm.sh        - deletes 1 (4-4) VMs and associated resources
  update_product.sh   - re-execs respective cloud-init on VMs (1-4)
  restart_product.sh  - restarts product on VMs (1-4)
  update_publicIP.sh  - re-creates public IP on VMs (1-4) 

============================================================================


0 - create_vm.sh
1 - delete_vm.sh
2 - update_product.sh
3 - restart_product.sh
4 - update_publicIP.sh
q - quit


CMD number > 
```

#### EXECUTE BASH SCRIPT
exec_script.sh - exec bash script on VM
```
cd bimbazure

bash exec_script.sh we-demo1 /path/to/script.sh
```
