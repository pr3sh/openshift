# **`Abstract`**

## **Table of contents**:
  - [Pod Resource Limits](#pod-resource-limits)
  - [Resource Quotas](#resource-quotas)




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








