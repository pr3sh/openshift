# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [OpenShift Networking Model](#openshift-networking-model)
  - [Understanding Services for Pod Access](#understanding-services-for-pod-access)
  - [DNS Operator](#dns-operator)
  - [Cluster Network Operator](#cluster-network-operator)
  - [Useful Commands for Debugging Services](#useful-commands-for-debugging-services)
  - [Exposing Applications for External Access](#exposing-applications-for-external-access)
    - [Creating Routes](#creating-routes)
    - [Securing Applications with Edge Routes](#securing-applications-with-edge-routes)
    - [Securing Applications with Passthrough Routes](#securing-applications-with-passthrough-routes)
  - [Configuring Network Policies](#configuring-network-policies) 
  - [Useful OpenSSL Commands](#useful-openssl-commands)  

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

- OpenShift has many ways that allow you to expose your applications to external networks. You can expose HTTP and HTTPS traffic, TCP applications, and also non-TCP traffic. 
- Some of these methods are service types, such as **`NodePort`** or **`load balancer`**, while others use their own API resource, such as Ingress and Route.
- With routes, you can access your application with a *unique* host name that is publicly accessible. Routes rely on a router plug-in to redirect the traffic from the **`public IP`** to pods.


###### **`Creating Routes`**:

The easiest to create a route is to use the **`oc expose service`** command. You can use the **`--hostname`** option to provide a custom host name for the route.

> If you don't specify the **`--hostname`** option, OpenShift generates a host name for you with the following structure: **`<route-name>-<project-name>.<default-domain>`**.

```zsh
[user@host ~]$ oc expose service api-frontend \ 
      > --hostname api.apps.acme.com
```
###### **`Securing Applications with Edge Routes`**:

- Before creating a secure route, you need to generate a **`TLS certificate`**. 
- When creatig an edge mode, the traffic between the client and the router is encrypted, but traffic between the router and the application is not.
- The **`--key`** option requires the certificate private key & **`--cert`** option requires the
certificate that has been signed with that key.

> To create a secure edge route with a **TLS certificate**, execute:

```zsh
[user@host ~]$ oc create route edge \
> --service api-frontend --hostname api.apps.acme.com \
> --key api.key --cert api.crt  
```

###### **`Securing Applications with Passthrough Routes`**:

- Passthrough routes offer a secure alternative because the application exposes its **`TLS certificate`**.
- Traffic is encrypted between the client and the application.
- To create a passthrough route, you need a certificate and a way for your application to access it. The best way to accomplish this is by using **`OpenShift TLS secrets`**. 
  - **`Secrets`** are exposed via a mount point into the container.

1. Create secret
```zsh
[student@workstation network-ingress]$ oc create secret tls todo-certs \
> --cert certs/training.crt \
> --key certs/training.key secret/todo-certs created
```

2.  Mount secret in pod directory, for example **`/usr/local/etc/ssl/certs`**.

```zsh
[student@workstation network-ingress]$ oc set volumes deployment/app-name \
            --add --type secret --secret-name todo-certs --mount-path /usr/local/etc/ssl/certs
```

3. Create **`passthrough`** route.

```zsh
[student@workstation network-ingress]$ oc create route passthrough todo-https \
>      --service todo-https --port 8443 \
>      --hostname todo-https.apps.ocp4.example.com 
route.route.openshift.io/todo-https created
```

#### **`Configuring Network Policies`**:

- Network policies allow you create isolation policies for individual pods. 
- Network policies do not require **`administrative privileges`**, which gives developers control over the applications within their projects. 
- With **`NetworkPolicies`**, you can create *logical zones* in the Software-Defied Network that map to your organization network zones. 

> To manage network communication between two **`namespaces`**, assign a **`label`** to the namespace that needs access to another namespace. 

```zsh
[user@host ~]$ oc label namespace network-1 name=network-1
```

1. The following network policy applies to all pods with the **`label`** **`deployment="product-catalog"`** in the **`network-1`** **`namespace`**. 
2. The policy allows **`TCP`** traffic over **`port 8080`** from pods whose label is **`role="qa"`** in the **`network-2`** **`namespace`**.

```yaml 
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: network-1-policy
spec:
  podSelector:
    matchLabels:
      deployment: product-catalog
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: network-2
      podSelector:
        matchLabels:
          role: qa
    ports:
    - port: 8080
      protocol: TCP
```

> This network policy allows traffic from all the pods and ports in the **`network-1 namespace`** to all pods and ports in the **`network-2 namespace`**. 

```yaml 
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: network-2-policy
spec:
  podSelector: {}
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: network-1
```

> This network policy blocks all traffic because no ingress rules are defined. Traffic is blocked unless you also define an explicit policy that overrides this default behavior.

```yaml 
kind: NetworkPolicy
apiVersion: networking.k8s.io/v1
metadata:
  name: default-deny
spec:
  podSelector: {}
```

> If you have **`Cluster Monitoring`** or exposed routes, you need to allow **`ingress`** from them as well. This network policy allows ingress from OpenShift monitoring and Ingress Controllers:

```yaml 

apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-openshift-ingress
spec:
  podSelector: {}
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          network.openshift.io/policy-group: ingress
---
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-openshift-monitoring
spec:
  podSelector: {}
ingress:
- from:
  - namespaceSelector:
      matchLabels:
        network.openshift.io/policy-group: monitoring
```

> If the **`default`** Ingress Controller uses the **HostNetwork** endpoint publishing strategy, then the **default** namespace requires the **`network.openshift.io/policy-group=ingress`** label.


#### **`Useful OpenSSL Commands`**:


> Check hostname based on **`.pem`** certificate.

```zsh
[student@workstation home]$ openssl x509 -in  hello-secure.pem --noout -ext 'subjectAltName' 
```





