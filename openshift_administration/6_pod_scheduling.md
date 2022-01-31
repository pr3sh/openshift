# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [Labelling Nodes](#labelling-nodes)
  - [Labelling Machinesets](#labelling-machinesets)
  - [Pod Scheduling](#pod-scheduling)
 
##### **`Introduction`**:

OpenShift's pod scheduler is responsible for the placement of pods onto nodes. The default configuration supports the common data center concepts of **`zones`** and **`regions`** by using *node labels*, *affinity rules*, and *anti-affinity rules*.

> OpenShift's pod scheduler algorithm follows a three step process:

1. Filtering nodes.
2. Prioritizing the filtered list of nodes.
3. Selecting the best fit node.


##### **`Labelling Nodes`**:

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

##### **`Labelling Machinesets`**:

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





