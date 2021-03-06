# AZURE CONFIG
RESOURCE_GRP="group_DEMO"
LOCATION="westeurope"
#LOCATION="southeastasia"
MAX_PRICE="0.0125"
KEY_DIR="./ssh"
KEY_NAME="talltom_key"
KEY_PATH="${KEY_DIR}/${KEY_NAME}.pub"
VM_NAME="$1"

#
# PRODUCT CONFIG
DEFAULT_PRODUCT=DDOSER
VALID_PRODUCTS=("BOMBARDIER" "DDOSER" "UASHIELD" "UASWORD" "DDOSER_SMS" "UASHIELD_SMS" "MHDDOS")
PRODUCT="${2:-$DEFAULT_PRODUCT}"  # DDOSER/BOMBARDIER ; DDOSER - default
                                  # DDOSER also installs imsamurai/ivi
# validate product
if [ -z "$(echo ${VALID_PRODUCTS[@]} | grep -w $PRODUCT)" ]; then
        echo "ERROR: unknown product: $PRODUCT"
        echo "Valid products: ${VALID_PRODUCTS[@]}"
        exit 1
fi
TAGS="Product=${PRODUCT}"

if [ "$PRODUCT" == "BOMBARDIER" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-bombardier.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
elif [ "$PRODUCT" == "DDOSER" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-ddoser.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
elif [ "$PRODUCT" == "UASHIELD" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-uashield.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
elif [ "$PRODUCT" == "UASWORD" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-uasword.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
elif [ "$PRODUCT" == "DDOSER_SMS" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-ddoser_sms.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
elif [ "$PRODUCT" == "UASHIELD_SMS" ]; then
        dependencies="install-docker.sh"
        init="cloud-init-uashield_sms.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
else
        dependencies="mhddos-deps.sh"
        init="cloud-init-mhddos.sh"
        start_cmd="bash /home/azureuser/test_workload.sh &"
fi
