#!/bin/bash
RETRY=20
HTTPSTATUS=0
SOAP_MSG='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><m:describeRepository xmlns:m="http://fedora-commons.org/2011/07/definitions/types/"/></SOAP-ENV:Body></SOAP-ENV:Envelope>'
HOST=$1

if [ -z "$HOST" ]; then
    echo "Missing parameter for HOST. Assuming localhost"
    HOST="localhost"
fi

until [[ $RETRY -le 0 || "$HTTPSTATUS" -eq 200 ]]; do
    HTTPSTATUS=`curl -sw '\n%{http_code}' --retry 3 -ufedoraAdmin:fedoraAdmin -XPOST -d "$SOAP_MSG" http://$HOST:8080/fedora/services/accessMTOM 2>/dev/null | tail -n1`
    echo $HTTPSTATUS
    sleep 5
    let RETRY=RETRY-1
done

if [ "$HTTPSTATUS" -eq 200 ]; then
    echo "APIM alive"
    exit 0
else
    echo "APIM not alive"
    exit 6
fi

