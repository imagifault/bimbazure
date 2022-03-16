echo '#!/usr/bin/env bash


# BEGIN VARS
TIME_EACH="3600"  # duration for each run in seconds
PID_PATH="/home/azureuser/n.pid"
LOG_DIR="/home/azureuser/log"
LOG_PATH="$LOG_DIR/nukem.log"  # nukem run log path
LOG_RETENTION=10            # how many logs to keep
BACKUP_SUFFIX=$(date +"%F_%H%M") # log retention suffix


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

# kill stale containers
kill_stale() {
    echo -e "$(date +"%F %H:%M") INFO: LOGGING STALE CONTAINERS" | tee -a $LOG_PATH
    stale_containers="$(docker ps -q)"
    if [ "$stale_containers" != "" ]; then
        echo "STALE CONTAINERS: $(echo $stale_containers | wc -l)"
        for c in $(docker ps -q); do
                id_to_image="$(docker ps --format "{{.ID}}: {{.Image}}" | grep $c)"
                echo -e "\n==== CLENAUP STALE $id_to_image ===="
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
run=1

while :; do
    rotate_file "${LOG_PATH}" $LOG_RETENTION "logs"
    echo -e "==== START $(date +"%F %H:%M") ====\n" | tee -a $LOG_PATH
    echo -e "$(date +"%F %H:%M") DEBUG: TIME_EACH=${TIME_EACH}s" | tee -a $LOG_PATH
    echo -e "$(date +"%F %H:%M") INFO: BEGIN RUN $run" | tee -a $LOG_PATH
    docker run -d --rm ghcr.io/opengs/uashield:master 512 true | tee -a $LOG_PATH
    docker run -d --rm imsamurai/ivi | tee -a $LOG_PATH
    docker run -d --rm geph/sms-bomber | tee -a $LOG_PATH
    docker run -d --rm imsamurai/callmeback | tee -a $LOG_PATH
    docker run -d --rm imsamurai/jerdesh | tee -a $LOG_PATH
    sleep ${TIME_EACH}s
    kill_stale
    echo -e "$(date +"%F %H:%M") INFO: END RUN $run" | tee -a $LOG_PATH
    run=$(($run+1))
done' > /home/azureuser/test_workload.sh

chmod +x /home/azureuser/test_workload.sh
