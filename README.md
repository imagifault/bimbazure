# bimbazure
Pet project for testing azure small-scale deployment and management

#### include/vars.sh additional imput parameter: PRODUCT
PRODUCT="${2:-$DEFAULT_PRODUCT}"  # DDOSER/BOMBARDIER ; DDOSER - default


this also goes to 'Product' tag of the VM


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

  VM base name:         we-demo
  Num VMs:              4
  Product:              DDOSER
  Concurrent log path:  ./concurrent_log 


  create_vm.sh        - creates 4 (1-4) VMs with default product
  delete_vm.sh        - deletes 4 (1-4) VMs and associated resources
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

  VM base name:         we-demo
  Num VMs:              4
  Product:              DDOSER
  Concurrent log path:  ./concurrent_log 


  create_vm.sh        - creates 4 (1-4) VMs with default product
  delete_vm.sh        - deletes 4 (1-4) VMs and associated resources
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
