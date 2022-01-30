# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [OpenShift Networking Model](#openshift-networking-model)
  - [Understanding Services for Pod Access](#understanding-services-for-pod-access)
  - [DNS Operator](#dns-operator)
  - [Cluster Network Operator](#cluster-network-operator)
  - [Useful Commands for Debugging Services](#useful-commands-for-debugging-services)
  - [Exposing Applications for External Access](#exposing-applications-for-external-access)


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

> Example **`YAML`** definition of a service for an application

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    app: wordpress
  name: wordpress
  namespace: test
spec:
  clusterIP: 10.217.4.137
  clusterIPs:
  - 10.217.4.137
  internalTrafficPolicy: Cluster
  ipFamilies:
  - IPv4
  ipFamilyPolicy: SingleStack
  ports:
  - name: 80-tcp
    port: 80
    protocol: TCP
    targetPort: 80
  selector:
    deployment: wordpress
  sessionAffinity: None
  type: ClusterIP
status:
  loadBalancer: {}
```

#### **`DNS Operator`**:

1. The **`DNS operator`** deploys and runs a DNS server managed by **`CoreDNS`**, which is a lightweight **`DNS Server`** written in **`GoLang`**. 
2. It provides DNS name resolution between pods, enabling services to discover their endpoints.
- Every a new application is created, OpenShift configures the pods so that they contact the **`CoreDNS`**service IP for DNS resolution.
3. The **`DNS Operator`** is responsible for creating a default cluster DNS name(*i.e* **`cluster.local`**).
4. Assigning DNS names to services that you define 

> To review the configuration of the **`DNS operator`**, execute:

```zsh
[user@demo ~]$ oc describe dns.operator/default
````

#### **`Cluster Network Operator`**:

OpenShift uses the **`Cluster Network Operator`** for managing the **`Sofware-Defined Network`**. AS as administrative user, run the following oc get command view the **`SDN`** configuration:

```zsh
[user@demo ~]$ oc get network/cluster -o yaml
```

```yaml
kind: Network
metadata:
  generation: 2
  name: cluster
spec:
  clusterNetwork:
  - cidr: 10.217.0.0/22
    hostPrefix: 23
  externalIP:
    policy: {}
  networkType: OpenShiftSDN
  serviceNetwork:
  - 10.217.4.0/23
status:
  clusterNetwork:
  - cidr: 10.217.0.0/22
    hostPrefix: 23
  clusterNetworkMTU: 1400
  networkType: OpenShiftSDN
  serviceNetwork:
  - 10.217.4.0/23
```

#### **`Useful Commands for Debugging Services`**:

> Get **`IP Addresss`** of Pod.

```zsh
[student@workstation network-sdn]$ oc get service/frontend \ 
      > -o jsonpath="{.spec.clusterIP}{'\n'}"
172.30.23.147
```

> Create troubleshooting container based on the mysql deployment. You must override the container image because the MySQL Server image does not provide the curl command.

```zsh
[student@workstation network-sdn]$ oc debug -t deployment/mysql \
  > --image registry.access.redhat.com/ubi8/ubi:8.4
Starting pod/mysql-debug ...
Pod IP: 10.131.0.146
If you don't see a command prompt, try pressing enter.
sh-4.4$
```

> Try hitting **`frontend`** application, from **`MySQL`** backend.

```zsh
sh-4.4$ curl -m 10 -v http://172.30.23.147:8080 
* Rebuilt URL to: http://172.30.23.147:8080/
* Trying 172.30.23.147...
* TCP_NODELAY set
* Connection timed out after 10000 milliseconds
* Closing connection 0
curl: (28) Connection timed out after 10000 milliseconds
```

#### **`Exposing Applications for External Access`**:











