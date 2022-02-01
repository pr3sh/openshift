# **`Abstract`**

## **Table of contents**:
  - [Pod Resource Limits](#pod-resource-limits)
  - [Resource Quotas](#resource-quotas)
    - [Example Resources A Quota Can Restrict](#example-resources-a-quota-can-restrict)
    - [Creating Project Quotas](#creating-project-quotas)
    - [Limit Ranges](#limit-ranges)
    - [Creating Quotas for Multiple Projects](#creating-quotas-for-multiple-projects)
  - [Modifying Default Project Template](#modifying-default-project-template)

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


##### **`Creating Project Quotas`**:

> Create resource quota programmatically.

```zsh
[user@host ~]$ oc create quota dev-quota --hard services=10,cpu=1300,memory=1.5Gi
```

> List available quotas 

```zsh
[user@host ~]$ oc get resourcequota
```

> Displays *cumulative* limits for all **`ResourceQuota`** resources in the project.

```zsh
[user@host ~]$ oc describe quota
```

> Delete quota

```zsh
[user@host ~]$ oc delete resourcequota <quota-name>
```

##### **`Limit Ranges`**:

- **`LimitRange`** resources, allow the declaration of the **`default`**, **`minimum`**, and **`maximum`** values for compute resource requests, and the limits for a single pod or container defined inside the project. 
- A resource request or limit for a pod is the *sum* of its containers.
- The difference between a limit ranges and a resource quotas are that a limit ranges define the valid ranges and default values for a single pod, while resource quotas define only *top* values for the sum of all pods in a project. 
- **`LimitRange`** resources can also define default, min, and max values for the **`storage`** capacity requested by an **`image`**, **`image stream`**, or **`persistent volume claim`**. 
- If a resource that is added to a project does not provide a compute resource request, it is assigned the default value provided by the **`LimitRange`** for the project.
- If a new resource provides compute resource requests or limits that are smaller than the minimum specified by the project limit ranges, then the resource is not created. 
- Similarly, if a new resource provides compute resource requests or limits that are higher than the maximum specified by the project limit ranges, then the resource is not created.


```yaml 
apiVersion: "v1"
kind: "LimitRange"
metadata:
  name: "dev-limits"
spec:
  limits:
    - type: "Pod"
      max:
        cpu: "500m"
        memory: "750Mi"
      min:
        cpu: "10m"
        memory: "5Mi"
    - type: "Container"
      max:
        cpu: "500m"
        memory: "750Mi"
      min:
        cpu: "10m"
        memory: "5Mi"
      default:
        cpu: "100m"
        memory: "100Mi"
      defaultRequest:
        cpu: "20m"
        memory: "20Mi"
    - type: openshift.io/Image
      max:
        storage: 1Gi
    - type: openshift.io/ImageStream
      max:
        openshift.io/image-tags: 10
        openshift.io/images: 20
    - type: "PersistentVolumeClaim"
      min:
        storage: "1Gi"
      max:
        storage: "50Gi"
```

> Get more info on the **`dev-limits`**  limit range object.

```zsh
[user@host ~]$ oc describe limitrange dev-limits
```

##### **`Creating Quotas for Multiple Projects`**:


```zsh
[user@host ~]$ oc create clusterquota user-qa \
> --project-annotation-selector openshift.io/requester=qa \
> --hard pods=12,secrets=20
```

```zsh
[user@host ~]$ oc create clusterquota env-qa \
> --project-label-selector environment=qa \
> --hard pods=10,services=5
```

#### **`Modifying Default Project Template`**:


```zsh
 [user@host ~]$ oc adm create-bootstrap-project-template \
         > -o yaml > /tmp/project-template.yaml
```



