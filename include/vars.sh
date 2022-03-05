# AZURE CONFIG
RESOURCE_GRP="group_DEMO"
LOCATION="westeurope"
MAX_PRICE="0.0125"
KEY_DIR="./ssh"
KEY_NAME="useless_key"
KEY_PATH="${KEY_DIR}/${KEY_NAME}"
VM_NAME="$1"

#
# PRODUCT CONFIG
DEFAULT_PRODUCT=DDOSER
VALID_PRODUCTS="BOMBARDIER DDOSER"
PRODUCT="${2:-$DEFAULT_PRODUCT}"  # DDOSER/BOMBARDIER ; DDOSER - default
# validate product
if [ -z "$(echo $VALID_PRODUCTS | grep -w $PRODUCT)" ]; then
        echo "ERROR: unknown product: $PRODUCT"
        echo "Valid products: $VALID_PRODUCTS"
        exit 1
fi
TAGS="Product=${PRODUCT}"
BOMBARDIER_PID_PATH="/home/azureuser/n.pid"

if [ "$PRODUCT" == "BOMBARDIER" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-bombardier.sh"
        start_cmd="bash /home/azureuser/test_workload.sh 1000 &"
else
        dependencies="install-docker.sh"
        init="cloud-init-ddoser.sh"
        start_cmd="bash /home/azureuser/test_workload.sh"
fi
