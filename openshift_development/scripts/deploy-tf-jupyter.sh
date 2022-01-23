#!/bin/bash


#Define environmental variables.

export DEPLOYMENT=python
export CLAIM_SIZE=5G
export CLAIM_MODE=rwo


oc create secret generic client-ssl --from-file truststore.jks

oc new-app --name python-client  docker.io/tensorflow/tensorflow:1.3.0


#Set persistent volume
oc set volume deployment/${DEPLOYMENT}-client --add --type pvc      \
                --claim-size ${CLAIM_SIZE} --claim-mode ${CLAIM_MODE}    \
                --claim-name ${DEPLOYMENT}-volume  --mount-path /notebooks

# Escalated container privileges
oc create serviceaccount jupyter-sa  && oc adm policy add-scc-to-user anyuid -z jupyter-sa
oc set serviceaccount deployment/${DEPLOYMENT}-client jupyter-sa

#mount secret to pod

oc set volume deployment/${DEPLOYMENT}-client --add --type secret \
		--secret-name client-ssl --mount-path /etc/ssl/certs

sleep 10

#Copy test scripts into pod.
#POD_NAME=$(oc get pod -l deployment=jupyter-client -o custom-columns=:metadata.name) 

#oc rsh $POD_NAME pip install kafka-python


oc expose svc python-client

