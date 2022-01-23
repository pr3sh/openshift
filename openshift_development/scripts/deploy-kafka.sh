#!/bin/bash


#Considerations for Deployment:
## Persistent Storage for low latency networking & storage.
## High availability for Kafka Brokers.
## Data Protection & fault-tolerance via replication.
## Data Security: 
##   - Data in-flight via SSL & TLS.
##   - Authentication & Authorizations (Role-Based Access Control).
## Operator Packaging
## Monitoring, Health Check & Logging

export NAMESPACE=$1
export KAFKA_MOUNT_PATH=/bitnami/kafka
export ZOOKEEPER_MOUNT_PATH=/bitnami/zookeeper
export CLAIM_MODE=rwo
export CLAIM_SIZE=5Gi


oc new-project $NAMESPACE

#Deploy Zookeeper Server 
oc new-app --name zookeeper-server bitnami/zookeeper:latest \
		-e ALLOW_ANONYMOUS_LOGIN=yes


#Deploy Apache Kafka Server first node
oc new-app --name kafka-server bitnami/kafka:latest \
                -e ALLOW_PLAINTEXT_LISTENER=yes  \
                -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181  \
                -e KAFKA_CFG_LISTENERS=CLIENT://:9092,EXTERNAL://:9093   \
                -e KAFKA_CFG_ADVERTISED_LISTENERS=CLIENT://kafka-server:9092,EXTERNAL://localhost:9093  \
                -e KAFKA_CFG_INTER_BROKER_LISTENER_NAME=CLIENT   \
                -e KAFKA_CFG_LISTENER_SECURITY_PROTOCOL_MAP=CLIENT:PLAINTEXT,EXTERNAL:PLAINTEXT
		bitnami/kafa:latest 


#Deploy second node
#oc new-app --name kafka0-server bitnami/kafka:latest \
#                -e ALLOW_PLAINTEXT_LISTENER=yes -e KAFKA_CFG_ZOOKEEPER_CONNECT=zookeeper-server:2181
#                bitnami/kafa:latest

echo "...Preparing to deploy Persistent volumes.."
sleep 2

# Set persistent volumes in both Zookeeper & Apache Kafka deployments.
for DEPLOYMENT in kafka zookeeper 
do 
	oc set volume deployment/${DEPLOYMENT}-server --add --type pvc   \
		--claim-size ${CLAIM_SIZE} --claim-mode ${CLAIM_MODE} \
		--claim-name ${DEPLOYMENT}-volume  --mount-path /bitnami/${DEPLOYMENT}
done




