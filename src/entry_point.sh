#!/bin/bash

if [ ! "$DOMAIN" ] || [ ! "$HOST" ] || [ ! "$PASSWORD" ]; then
  echo "You must define DOMAIN, HOST and PASSWORD!"
  exit 1
fi

DATE=`date '+%Y-%m-%d %H:%M:%S %z'`

logger () {
    echo $1 $2 $3 "($DATE)"
}

logger "INFO: update_ddns is starting..."

envsubst < /usr/src/app/crontab > /etc/crontab

crontab /etc/crontab

printenv | awk '{print "export " $1}' > /usr/src/app/env.sh
/usr/sbin/cron -f
