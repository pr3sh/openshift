# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)




### **`Introduction`**:

Pod definitions can contain both resource **`requests`** and **`limits`**:
1. **`Resource Requests`**:
  - This denotes that a pod cannot run with less than the compute resources. 
  - OpenShift's scheduler attempts to find a node to satisfy the pod's resource requests.

2. **`Resource Limits`**:
  -  Resource limits prevent pods from consuming excessive resources from a node.

> Resource requests and limits can be containers either within a **`Deployment`** or **`DeploymentConfig`** under the **`resources: {}`** part of the container.
