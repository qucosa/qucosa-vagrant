#!/bin/bash
RETRY=20
HTTPSTATUS=0
HOST=$1
STATUS=$2

if [ -z "$HOST" ]; then
    echo "Missing parameter for HOST. Assuming localhost..."
    HOST="localhost"
fi

if [ -z "$STATUS" ]; then
    echo "Missing parameter for STATUS. Assuming yellow..."
    STATUS="yellow"
fi

until [[ $RETRY -le 0 || "$HTTPSTATUS" -eq 200 ]]; do
    HTTPSTATUS=`curl -sw '\n%{http_code}' --retry 3 "http://$HOST:9200/_cluster/health?wait_for_status=$STATUS&timeout=5m" 2>/dev/null | tail -n1`
    sleep 5
    let RETRY=RETRY-1
done

if [ "$HTTPSTATUS" -eq 200 ]; then
    exit 0
else
    exit 6
fi

