#!/usr/bin/env bash

CONTAINER_ID=$(kubectl get pods -l "app=flame-controller" -n "flame" -o json | jq -r '.items[].status.containerStatuses[] | select(.name == "flame-controller")| .containerID' | awk '{ print substr( $0, 14 ) }')

PROCESS_ID=$(crictl inspect --output go-template --template '{{.info.pid}}' $CONTAINER_ID)

JOB_ID="62e167026a9a1d6fd8d9f6c9"

# check flame jobs
flamectl get jobs --insecure

#pidstat 1 2 -p $PROCESS_ID > logs/controller.cpu

# start flame hier_mnist job
flamectl start job $JOB_ID --insecure

pidstat 1 30 -p $PROCESS_ID > logs/controller.cpu
