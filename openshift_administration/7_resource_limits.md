# **`Abstract`**

## **Table of contents**:
  - [Pod Resource Limits](#pod-resource-limits)
  - [Resource Quotas](#resource-quotas)
    - [Example Resources A Quota Can Restrict](#example-resources-a-quota-can-restrict)

### **`Pod Resource Limits`**:

Pod definitions can contain both resource **`requests`** and **`limits`**:
1. **`Resource Requests`**:
  - This denotes that a pod cannot run with less than the compute resources. 
  - OpenShift's scheduler attempts to find a node to satisfy the pod's resource requests.

2. **`Resource Limits`**:
  -  Resource limits prevent pods from consuming excessive resources from a node.

> Resource requests and limits can be containers either within a **`Deployment`** or **`DeploymentConfig`** under the **`resources: {}`** part of the container.

```yaml 
...output omitted...
    spec:
      containers:
      - image: quay.io/redhattraining/hello-world-nginx:v1.0
        name: hello-world-nginx
        resources:
          requests:
            cpu: "10m"
            memory: 20Mi
          limits:
            cpu: "80m"
            memory: 100Mi
```
> You can also use the **`oc set resources`** command to set those resource requests and limits without having to edit the deployment **`YAML`** file.

```zsh
 [user@host ~]$ oc set resources deployment hello-world-nginx \
             --requests cpu=10m,memory=20Mi --limits cpu=80m,memory=100Mi
```

> View **`resource`** requests and limits for an individual node

```zsh
[user@host ~]$ oc describe node node1.us-west-1.compute.internal
```

> View actual usage

```zsh
[user@host ~]$ oc adm top nodes -l node-role.kubernetes.io/worker
```

### **`Resource Quotas`**:

OpenShift leverages quotas to track and limit the use of **`Object Counts`** and **`Compute Resources`**
1. **`Object Counts`**:
  - Object counts represent Kubernetes Resources such as **`pods`**, **`services`**, **`replicationControllers`**, **`routes`**, etc..

2. **`Compute Resources`**:
  - Compute Resources reference physical or virtual hardware resources, like **`CPU`**, **`memory`**, and **`storage capacity`**.

> OpenShift uses the **`ResourceQuota`** or **`quota`** resource to manage quota and compute resources in the cluster.


#### **`Example Resources A Quota Can Restrict`:**

|         **`Resource`**           |     **`Description`**                                           | 
|----------------------------------|:---------------------------------------------------------------:|  
| **`pods`**                       | Total number of pods.                                           | 
| **`replicationcontrollers`**     | Total number of replication controllers.                        |   
| **`services`**                   | Total number of services.                                       |
| **`secrets`**                    | Total number of secrets.                                        |
| **`persistentvolumeclaims`**     | Total number of persistent volume claims.                       | 
| **`cpu (requests.cpu)`**         | Total CPU use across all containers.                            | 
| **`memory (requests.memory)`**   | Total memory use across all containers.                         |   
| **`storage (requests.storage)`** | Total storage requests by containers across all persistent volume claims.   |













