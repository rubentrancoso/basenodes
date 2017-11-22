#!/bin/bash
. scripts/lib/common.sh

IMAGENAME="doteva.com/basenodes"

# if theres a proxy in the enviroment pass it to npm inside Dockerfile
if [ -n "$HTTP_PROXY" ]
then
    proxy=`rebuildurl "$HTTP_PROXY"`
    docker build \
        --build-arg HTTP_PROXY=${proxy} \
        --build-arg HTTPS_PROXY=${proxy} \
        --build-arg http_proxy=${proxyy} \
        --build-arg https_proxy=${proxy} \
        -t ${IMAGENAME} \
        .
else
    docker build \
        -t ${IMAGENAME} \
        .
fi

