# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [Labelling Nodes](#labelling-nodes)
  - [Labelling Machinesets](#labelling-machinesets)
  - [Pod Scheduling](#pod-scheduling)
    - [Config Node Selector for Project](#config-node-selector-for-project)
 
#### **`Introduction`**:

OpenShift's pod scheduler is responsible for the placement of pods onto nodes. The default configuration supports the common data center concepts of **`zones`** and **`regions`** by using *node labels*, *affinity rules*, and *anti-affinity rules*.

> OpenShift's pod scheduler algorithm follows a three step process:

1. Filtering nodes.
2. Prioritizing the filtered list of nodes.
3. Selecting the best fit node.


#### **`Labelling Nodes`**:

> In order to label nodes within an OpenShift cluster, you must be a cluster administrator. A practical example of labelling nodes to segment wordloads could be **`env=dev`** or **`env=prod`** to separate the development and production workloads. Labels chosen on nodes are arbritrary.

> Label a node with **`env=dev`**:

```zsh
[user@host ~]$ oc label node node1.us-west-1.compute.internal env=dev
```

> You can use the **`--overwrite`** option to change an existing label:

```zsh
[user@host ~]$ oc label node node1.us-west-1.compute.internal env=prod --overwrite
```

> You can remove a label by specifying the label name followed by a hyphen:

```zsh
[user@host ~]$ oc label node node1.us-west-1.compute.internal env-
```
> *Both the labels and their respective values on nodes are case-sensitive.*

> Show labels of a node.

```zsh
[user@host ~]$ oc get node node2.us-west-1.compute.internal --show-labels 
```

>  Cluster admins can also use the **`-L`** option find out the value of one or more labels. For multiple labels, you can use multiple**` -L `**options in the same command.

```zsh
[user@host ~]$ oc get node -L failure-domain.beta.kubernetes.io/region \ 
    > -L failure-domain.beta.kubernetes.io/zone -L env
```

#### **`Labelling Machinesets`**:

- If your OpenShift cluster contains machine sets, then it is advisable to add labels to the machine set configuration. 
- This ensures that new nodes generated from those machinesets will also contain the desired labels.
-  Machine sets are found in clusters using **`full-stack automation`** and in some clusters using pre-existing infrastructure that enable cloud provider integration. 
- Bare-metal clusters do not use machine sets.
- You can identify the relationship between machines and nodes by listing machines in the **`openshift-machine-api`** namespace and including the **`-o wide`** option:

```zsh
[user@host ~]$ oc get machines -n openshift-machine-api -o wide
```
```zsh
oc get machineset -n openshift-machine-api
```

> Edit **`machineset`**:

```zsh
 [user@host ~]$ oc edit machineset ocp-qz7hf-worker-us-west-1b \
           > -n openshift-machine-api
 ```

> Below is where you would need to add the **label**.

```yaml 
...output omitted...
    spec:
      metadata:
        creationTimestamp: null
        labels:
          env: dev
      providerSpec:
...output omitted...
```


#### **`Pod Scheduling`**:

- There are certain pods with the OpenShift Cluster (*i.e:* **infrastructure-related pods**) are configured to run on **`control-plane`** nodes.
- For example, the **`DNS Operator`**, **`OAuth Operator`**, and **`OpenShift API Server`**. 
- This is accomplished by using the **`Node Selector`** **`node-role.kubernetes.io/master`** in the configuration of a daemon set or a replica set.
- Users' applications might also require running on a specific set of nodes and therefore need to use node labels and node selectors to accomplish this.
- You can define a **`node selector`** in a deployment resource in order to ensure ew pods generated from that resource will have the desired **`node selector`**. 

```zsh
[user@host ~]$ oc edit deployment/myapp
```

```yaml 
...output omitted...
spec:
...output omitted...
  template:
    metadata:
      annotations:
        openshift.io/generated-by: OpenShiftNewApp
      creationTimestamp: null
      labels:
        deployment: myapp
    spec:
      nodeSelector:
        env: dev
containers:
      - image: quay.io/redhattraining/scaling:v1.0
```

> You can also use **`oc patch`** to non-interactively/programatically made the changes to the deployment:

```zsh
 [user@host ~]$ oc patch deployment/myapp --patch \
>           '{"spec":{"template":{"spec":{"nodeSelector":{"env":"dev"}}}}}'
```

##### **`Config Node Selector for Project`**:

- Cluster Administrator define node selectors when a project is created, or can add/update a node selector after a project is created. To add the node selector at project creation time execute:

```zsh
[user@host ~]$ oc adm new-project demo --node-selector "tier=1"
```

```zsh
 [user@host ~]$ oc annotate namespace demo \
>     openshift.io/node-selector="tier=2" --overwrite
```



