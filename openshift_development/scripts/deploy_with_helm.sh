#!/bin/bash

# Install some dependencies.
sudo apt update && sudo apt upgrade &&  \
	sudo apt install tree && sudo apt install curl 


# Create context directory and display Tree structure.
EXPORT BUILD_DIR && tree $BUILD_DIR

# Update dependencies for the chart.
helm dependency update


# Define more environment variables
export OCP_DEV_USER
export OCP_DEV_PASS
export OCP_MASTER_API
export PROJECT_NAME
export APP_NAME
export SVC_URL

oc login -u $OCP_DEV_USER -p $OCP_DEV_PASS --server $OCP_MASTER_API && \
	oc new-project $PROJECT_NAME

# Deploy to application in RHOCP Cluster.
helm install $APP_NAME $BUILD_DIR

# Display deployments
oc get deployments && oc get pods

# Expose service and test endpoint.
oc  expose service $APP_NAME 

SVC_URL=$(oc get route -n $PROJECT_NAME $APP_NAME -o jsonpath='{.spec.host}{"\n"}')

echo testing database service endpoint....
curl $SVC_URL


