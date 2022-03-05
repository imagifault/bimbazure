# AZURE CONFIG
RESOURCE_GRP="group_DEMO"
LOCATION="westeurope"
MAX_PRICE="0.0125"
KEY_DIR="./ssh"
KEY_NAME="useless_key"
KEY_PATH="${KEY_DIR}/${KEY_NAME}"
TAGS="Group=TEST"
VM_NAME="$1"

# PRODUCT CONFIG
PRODUCT="DDOSER"  # DDOSER/BOMBARDIER
#PRODUCT="BOMBARDIER"  # DDOSER/BOMBARDIER
if [ "$PRODUCT" == "BOMBARDIER" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-bombardier.sh"
        start_cmd="bash /home/azureuser/test_workload.sh 1000 &"
else
        dependencies="install-docker.sh"
        init="cloud-init-ddoser.sh"
        start_cmd="bash /home/azureuser/test_workload.sh"
fi
