#!/bin/bash
RETRY=20
HTTPSTATUS=0
SOAP_MSG='<SOAP-ENV:Envelope xmlns:SOAP-ENV="http://schemas.xmlsoap.org/soap/envelope/"><SOAP-ENV:Body><m:describeRepository xmlns:m="http://fedora-commons.org/2011/07/definitions/types/"/></SOAP-ENV:Body></SOAP-ENV:Envelope>'
HOST=$1
PORT=$2
CTX=$3
AUTH=$4

if [ -z "$HOST" ]; then
    echo "Missing parameter for HOST. Assuming localhost"
    HOST="localhost"
fi

if [ -z "$PORT" ]; then
    echo "Missing parameter for PORT. Assuming 8080"
    PORT="8080"
fi

if [ -z "$CTX" ]; then
    echo "Missing parameter for Context. Assuming fedora"
    CTX="fedora"
fi

if [ -z "$AUTH" ]; then
    echo "Missing parameter for AUTH. Assuming fedoraAdmin:fedoraAdmin"
    AUTH="fedoraAdmin:fedoraAdmin"
fi


until [[ $RETRY -le 0 || "$HTTPSTATUS" -eq 200 ]]; do
    HTTPSTATUS=`curl -sw '\n%{http_code}' --retry 3 -u"$AUTH" -XPOST -d "$SOAP_MSG" http://"$HOST":"$PORT"/"$CTX"/services/accessMTOM 2>/dev/null | tail -n1`
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

