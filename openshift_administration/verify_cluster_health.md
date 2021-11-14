# **`Abstract`**

This section focuses on how to identify and mitigate cluster issues that are not directly related to oeprators or application deployments.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Verifying Health of OpenShift Nodes](#verifying-health-of-openshift-nodes)
  - [Displaying Node Logs](#displaying-node-logs)

##### **`Introduction`:**
The process of troubleshooting an OpenShift cluster relatively similar to trouble shooting application deployments, since most components in RHOCP4 are operators. 
1. You can typically identify the project where the operator resides.
2. The deployment which manages the operator application, and its pods.
3. If there needs to be modifications of that operators configuration, then you can identify the custom resource.

##### **`Verifying Health of OpenShift Nodes`**
Display each node, and their respective statuses. If a node is not in **`Ready`** state, then it means it cannot communicate with the OpenShift control plane.
```zsh
oc get nodes
```
Display current CPU and Memory usage of each node.
```zsh
oc adm top nodes
```
Display more detailed information about the node.
```zsh
oc describe node <node_name>
```
The `ClusterVersion` is a Custom Resource that contains information about the cluster, status of cluster operators, and its version. Defining a new version of the cluster instructs the `cluster-version` operatr to upgrade th cluster to that version. To retrive cluster version that is running:

```zsh
[user@host ~]$ oc get clusterversion
> NAME      VERSION      AVAILABLE    PROGRESSING   SINCE    STATUS
version     4.6.2         True         False        5d 24h    Cluster version is 4.6.2 
``` 
> You can also use the **`oc describe clusterversion`** to obtain more detailed information:

OpenShift *cluster operators* are responsible for managing the cluster's main components such as the **`API server`**, **`web console`**, **`storage`**, or **`Software Defined Network`**. You can use the **`ClusterOperator`** resource to get an overview of each operator & their respective statues.
> *For example:*

```zsh
[user@host ~]$ oc get clusteroperators

NAME                VERSION      AVAILABLE     PROGRESSING      DEGRADED   SINCE
authentication        4.6.2        True           False            False    4d3h
cloud-credential      4.6.2        True           False            False    4d4h
console               4.6.2        True           False            False    5d30m
dns                   4.6.2        True           False            False    3d34m
image-registry        4.6.2        True           False            False    5d3h
etcd                  4.6.2        True           False            False    3d1h
config-operator       4.6.2        True           False            False    2d30m
...
```

##### **`Displaying Node Logs`:**

An OpenShift node based on RHEL Linux CoreOS runs very few local services that require direct access to a node to inspect their status. Most system services run as containers with the exception of **`CRI-O Container Engine`** & **`Kubelet`** which are Systemd units. 
> *To view these logs:*

```zsh
oc adm node-logs -u crio <node_name>
```
```zsh
oc adm node-logs -u kubelet <node_name>
```
```zsh
oc adm node-logs <node_name>
```
