# **`Abstract`**

This section focuses on how to identify and mitigate cluster issues that are not directly related to oeprators or application deployments.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Verifying Health of OpenShift Nodes](#verifying-health-of-openshift-nodes)
  - [Displaying Node Logs](#displaying-node-logs)
  - [Opening Shell Prompt Inside Node](#opening-shell-prompt-inside-node)
  - [Troubleshooting Container Engine](#troubleshooting-container-engine)
  - [Creating Troubleshooting Pods for Deployments](#creating-troubleshooting-pods-for-deployments)

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
> Display current CPU and Memory usage of each node.
```zsh
oc adm top nodes
```
> Display more detailed information about the node.
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
[user@host ~]$ oc adm node-logs -u crio <node_name>
```
```zsh
[user@host ~]$ oc adm node-logs -u kubelet <node_name>
```
```zsh
[user@host ~]$ oc adm node-logs <node_name>
```
##### **`Opening Shell Prompt Inside Node`:**

Administrators who manage Red Hat OpenShift Container Platform 3 & other Kubernetes distribution often open **`SSH`** sessions to thier nodes for a various reasns:
1. Inspect state of Control Plane & Container Engine.
2. Make changes to Configuration Files.
Although this can be done in Red Hat OpenShift Container Platform 4, it is not recommended. In order to open a shell prompt in your cluster's nodes, you can use the **`oc debug node`** comand. 
- That prompt comes from a specia-pupose tools container that mounts node root file system at the **`/host`** folder.
- To run local commands directly from the node in an  **`oc debug node`** session, you must start a **`chroot`** **`/host`** folder, which would allow you to inspect the local file systems of the node, status of **`systemd`** services, and perform other tasks that may require an **`SSH`**.
- Shell sessions started using the **`oc debug`** command depend on the control plane to work & relies on the same tunneling technology that allows opening a shell prompt inside a running pod.
- If your control plane is non-functional, or your node isn't in **`Ready`** state, then you cannot required on the **`oc debug node`** and will require a bastion host.

> *For example:*

```zsh
[user@host ~]$ oc debug node/node-name
...
...
sh-4.4# chroot /host
sh-4.4# systemctl is-active kubelet
```
##### **`Troubleshooting Container Engine`:**
- To get low-level information about all containers running on a node, you can use the **`crictl`** command. 
- You cannot use **`podman`** for this task as it does not have the visibility on containers that are created by **`CRI-O`**. 
- The **`oc describe node`** command provides the same information although organized by pod, as opposed to containers.
```zsh
[user@host ~]$ oc debug node/node-name
...
...
sh-4.4# chroot /host
sh-4.4# crictl ps 
```
##### **`Creating Troubleshooting Pods for Deployments`:**

- The **`oc debug`** command is very useful when it comes to examining issuees that may relate to an application container image or settings it gets from its OpenShift resources. 
- This command creates a pod based on a existing pod, **`DeploymentConfig`**, **`Deployment`**, or any other sources from the **`Workloads API`**. 
- A new pod runs an interactive shell instead of the default entry point of the container image.
- it also runs with health probes disabled, this way, you can verify environments variables, network acess to other services and permissions inside the pod.
- The **`oc debug`** command also allows you to specify settings that you do not want to clone., *i.e:* container image or even specifying a fixed user id. It is important to note that some settings might require cluster administrator privileges.

> *For example, if you would like to see if a failed deployment would work when running with root privileges.*

```zsh
[user@host ~]$ oc debug deployment/deployment-name --as-root
```
> Open shell session in side a pod.
```zsh
[user@host ~]$ oc rsh <pod-name>
```
> Copy paths to and from a pod to local machine

```zsh
[user@host ~]$ oc cp /local/path my-pod:/container/path
```
> Create **TCP** tunnel from local-port on work station to local-port on pod. This allows you to get network access to the pod wihtout exposing it through a route.

```zsh
[user@host ~]$ oc port-forward my-pod local-port:remote-port
``` 
> You can also use the **`--log-level`** option to better understand what particular invocation of the **oc** command does behind the scenes. 10 gives the most information.

```zsh
[user@host ~]$ oc get pod --log-level 10 
```




