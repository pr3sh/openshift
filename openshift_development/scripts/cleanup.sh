#!/bin/bash 

echo "..Cleaning all resources.."
for name in kafka zookeeper jupyter mysql
do
	oc delete all -l app=$name-server &&      \
	oc delete pvc $name-volume
done

echo "..Deleting jupyter service account.."
oc delete serviceaccount jupyter-sa
oc delete secret mysql
sleep 3
oc get pods
exit
