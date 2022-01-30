# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [OpenShift Networking Model](#openshift-networking-model)
  - [Understanding Services for Pod Access](#understanding-services-for-pod-access)


### **`Introduction `**:

OpenShift implements a software-defined to effectively manage the network infrastructure of the cluster and user applications. This networking model that allows for easy managemet of network services through the abstraction of several networking layers. It decouples the software that handles the traffic (**`control-plane)`**, along with the underlying mechanisms that route the traffic (**`data plane`**). OpenShift's SDN aligs with *open standards*, that enable vendors to propose their solutions, centralized management, dynamic routing, and tenant isolation.

> OpenShift's **`Sofware-Defined Networking`** satisfies the following *five* requirements:
1. Managing the network traffic and network resources programmatically, so that the organization teams can decide how to expose their applications.

2. Managing communication between containers that run in the same project.

3. Managing communication between pods, *irrespective* of the project they belong to.

4. Managing network communication from a pod to a service.

5. Managing network communication from an external network to a service, or from containers to external networks.


#### **`OpenShift Networking Model`**:

- The ***`Container Network Interface (CNI)`*** an interface between the network provider
and the container execution, and is implemented as **`network plug-ins`**. 
- **`Plug-ins`** written to the specification allow various network providers to control the OpenShift cluster network.
- OpenShift's Software-Defined Network leverages CNI plug-ins to partition the usage of resources and processes on physical and virtual hosts, enabling containers inside pods to share network resources such as:
  1. Devices
  2. IP stacks
  3. Firewall Rules
  4. Routing tables. 

> Some of the commonly used CNI plug-ins used in OpenShift:

- OpenShift SDN
- OVN-Kubernetes
- Kuryr

> The OpenShift SDN network provider uses **`Open vSwitch (OVS)`** to connect pods on the same node and **`Virtual Extensible LAN (VXLAN)`** tunneling to connect nodes. 


#### **`Understanding Services for Pod Access`**:

- Services enable grouping of pods under a common access **`route`**. 
- A service acts as a **`load balancer`** in front of one or more pods, which effectively distributes client requests across member pods to provides a stable interface that enables communication with pods without tracking individual pod **`IP addresses`**.
- Pods are ephemeral by nature, therefore when they restart, they are assigned a different **`IP address`** 
- Instead of having a pod discover the **`IP address`** of another pod, services provide a unified way of of accessing pods by a , unique **`IP address`**, irrespective of where the pod may be running.
- Services rely on **`selectors (labels)`** that indicate which pods receive the traffic through the service. 
- If a pod matching these **`selectors`**, it is added to the service resource as an endpoint.
- As pods are restarted & recreated, services automatically update these endpoints. 












