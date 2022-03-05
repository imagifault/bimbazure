# bimbazure
Pet project for testing azure small-scale deployment and management

## include/vars.sh additional imput parameter: PRODUCT
PRODUCT="${2:-$DEFAULT_PRODUCT}"  # DDOSER/BOMBARDIER ; DDOSER - default

DDOSER also includes imsamurai/ivi

this also goes to 'Product' tag of the VM

## UA
## СТВОРИТИ ГРУПУ РЕСУРСІВ ТА SSH key pair
bash create_group.sh

це створить:

  - resource group (ім'я конфігурується в include/vars.sh)
  - ssh key pair (name configured in include/vars.sh)
  - скопіює пару ssh ключів в ./ssh и видасть права 0600


## СТВОРИТИ
create_vm.sh - на нових віртуалках виконується include/cloud-init.sh

pre-requisites:

    - авторизована сессія azure cli
    - ssh key створений в ажурі (public key завантажений і прописаний в include/vars.sh)
    - resource group створена в ажурі і сконфігурована в include/vars.sh

### 1 VM
cd bimbazure
bash create_vm.sh we-demo1 DDOSER/BOMBARDIER

### 4 VMs (розраховує на передбачуваний неймінг)
cd bimbazure
for i in $(seq 1 4); do bash create_vm.sh we-demo${i} DDOSER/BOMBARDIER; done



## ВИДАЛИТИ
delete_vm - аидаляє ВМ та асоційовані ресурси (тільки для створених через клі; створені вручну можуть мати більше компонентів)

### 1 VM
cd bimbazure
bash delete_vm.sh we-demo1

### 4 VMs (relies on naming)
cd bimbazure
for i in $(seq 1 4); do bash delete_vm.sh we-demo${i}; done

## ОНОВИТИ
update_product.sh - виконує include/cloud-init.sh на ВМ і перезапускає продукт

### 1 VM
cd bimbazure
bash update_product.sh we-demo1 DDOSER/BOMBARDIER

### 4 VMs (розраховує на передбачуваний неймінг)
cd bimbazure
for i in $(seq 1 4); do bash update_product.sh we-demo${i} DDOSER/BOMBARDIER; done


## ПЕРЕЗАПУСК
restart_product.sh - restarts product

### 1 VM
cd bimbazure
bash restart_product.sh we-demo1

### 4 VMs (розраховує на передбачуваний неймінг)
cd bimbazure
for i in $(seq 1 4); do bash restart_product.sh we-demo${i}; done


## EN
## BEFORE CREATING VMs
bash create_group.sh

this will create:

  - resource group with name configured in include/vars.sh
  - create ssh key pair (name configured in include/vars.sh)
  - put ssh key pair under ./ssh and set proper permissions

## CREATE
create_vm.sh - new VMs have include/cloud-init.sh executed on them

pre-requisites:

    - logged in azure cli
    - ssh key in azure present (public key downloaded and path configured in include/vars.sh)
    - resource group created

### 1 VM
cd bimbazure
bash create_vm.sh we-demo1 DDOSER/BOMBARDIER

### 4 VMs (relies on naming)
cd bimbazure
for i in $(seq 1 4); do bash create_vm.sh we-demo${i} DDOSER/BOMBARDIER; done



## DELETE
delete_vm - deletes azure vm and associated resources (only for created via cli; manually provisioned resources may have more components)

### 1 VM
cd bimbazure
bash delete_vm.sh we-demo1

### 4 VMs (relies on naming)
cd bimbazure
for i in $(seq 1 4); do bash delete_vm.sh we-demo${i}; done

## UPDATE
update_product.sh -re-executes include/cloud-init.sh and restarts product

### 1 VM
cd bimbazure
bash update_product.sh we-demo1 DDOSER/BOMBARDIER

### 4 VMs (relies on naming)
cd bimbazure
for i in $(seq 1 4); do bash update_product.sh we-demo${i} DDOSER/BOMBARDIER; done


## RESTART
restart_product.sh - restarts product

### 1 VM
cd bimbazure
bash restart_product.sh we-demo1

### 4 VMs (relies on naming)
cd bimbazure
for i in $(seq 1 4); do bash restart_product.sh we-demo${i}; done
