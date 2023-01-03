#!/bin/bash -l

# DOMAIN= , PASSWORD= and HOST=

cd /usr/src/app && . /usr/src/app/env.sh

IP_CACHE_FILE='/tmp/ip_cache'
DDNS_CACHE_FILE='/tmp/ddns_cache'

DATE=`date '+%Y-%m-%d %H:%M:%S %z'`

logger () {
    echo $1 $2 $3 "($DATE)"
}

old_ip=`[ -e $IP_CACHE_FILE ] && cat $IP_CACHE_FILE || echo ''`
new_ip=`wget --quiet -O - 'https://dyn.value-domain.com/cgi-bin/dyn.fcg?ip'`

if [ "$old_ip" = "$new_ip" ]; then
    logger "INFO: NO CHANGE ($new_ip)"
    exit 0
fi

url="https://dyn.value-domain.com/cgi-bin/dyn.fcg?d=$DOMAIN&p=$PASSWORD&h=$HOST"
result=0
wget --quiet -O - "$url" 2>/dev/null | tee $DDNS_CACHE_FILE | grep 'status=0' >/dev/null && result=1

if (( !$result )); then
    logger "ERROR: FAILED result:" `cat $DDNS_CACHE_FILE`
    exit 1
fi

echo $new_ip > $IP_CACHE_FILE

logger "INFO: UPDATED with new ip:$new_ip"
exit 0
