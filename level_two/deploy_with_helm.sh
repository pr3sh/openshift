#!/bin/bash

# Install Tree.
sudo apt install tree

# Create context directory and display Tree structure.
EXPORT BUILD_DIR && tree $BUILD_DIR

# Update dependencies for the chart.
helm dependency update


# Define more environment variables
EXPORT OCP_DEV_USER
EXPORT OCP_DEV_PASS
EXPORT OCP_MASTER_API
EXPORT PROJECT_NAME
EXPORT APP_NAME

oc login -u $OCP_DEV_USER -p $OCP_DEV_PASS --server $OCP_MASTER_API && \
	oc new-project $PROJECT_NAME

# Deploy to application in RHOCP Cluster.
helm install $APP_NAME $BUILD_DIR

# Display deployments


