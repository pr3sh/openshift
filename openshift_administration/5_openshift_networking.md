# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [OpenShift Networking Model](#openshift-networking-model)


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





