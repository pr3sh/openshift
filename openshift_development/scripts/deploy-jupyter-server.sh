#!/bin/bash

#Deploy Python Jupyter Notebook + Apache Spark, to be used later as external Clients (Python & Spark).

#Define environmental variables.

export DEPLOYMENT=jupyter
export CLAIM_SIZE=5G
export CLAIM_MODE=rwo
export JUPE_MOUNT_PATH=/home/jovyan/work
export FILENAME=

oc new-app --name jupyter-server  jupyter/pyspark-notebook


#Set persistent volume
oc set volume deployment/${DEPLOYMENT}-server --add --type pvc      \
                --claim-size ${CLAIM_SIZE} --claim-mode ${CLAIM_MODE}    \
                --claim-name ${DEPLOYMENT}-volume  --mount-path ${JUPE_MOUNT_PATH}

# Escalated container privileges
oc create serviceaccount jupyter-sa  && oc adm policy add-scc-to-user anyuid -z jupyter-sa
oc set serviceaccount deployment/${DEPLOYMENT}-server jupyter-sa


#oc get pods -w

sleep 4

#Copy test scripts into pod.
POD_NAME=$(oc get pod -l deployment=jupyter-server -o custom-columns=:metadata.name) 
oc cp $PWD/start-sparksession.sh  $POD_NAME:/home/jovyan/start-sparksession.sh 
oc cp $PWD/streamData.py $POD_NAME:/home/jovyan/streamData.py
oc cp $PWD/python-client.py $POD_NAME:/home/jovyan/python-client.py

oc expose svc jupyter-server
