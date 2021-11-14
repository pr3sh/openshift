# **`Abstract`**

This section focuses on how to identify and mitigate cluster issues that are not directly related to oeprators or application deployments.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Verifying Health of OpenShift Nodes](#verifying-health-of-openshift-nodes)

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

