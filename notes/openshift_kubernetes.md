# **Kubernetes and OpenShift**

-  **Table of contents**:
	- [Kubernetes](#kubernetes)
		- [Kubernetes Key Terminology](#kubernetes)
	[Openshift](#openshift)
		- [OpenShift Key Terminology](#openshift-key-terminology)

## **Kubernetes**

- Kubernetes is an orchestration service that simplifies the deployment, management, and scaling of containerized applications.
- Kubernetes forms a cluster of several node servers that run containers. 
- Containers are centrally managed by a set of *master* servers.
- Servers can act as both *nodes* and *server*, but there are differences in both roles for increased stability.

### **Kubernetes Key Terminology:**

- Node:
	- A server that hosts applications in a Kubernetes cluster.
- Master Node:
	- A node server that manages the `control plane` in a Kubernetes cluster.
	- Master nodes provide basic cluster service such as *APIs* or *controllers*.
- Worker Node:
	- Synonymous with `compute Node`, are responsible for executing the workloads for the cluster.
	- Pods from applications are scheduled on worker nodes.
- Resource:
	- Any kind of compoenent definitition managed by Kubernetes.
- Controller:
	- Kubernetes process that watches resources adn makes changes in attempt to change the *current state* --> *desire state*.
- Label:
	- Key-value pair that can be assigned to any Kubernetes resource.
	- *Selectors* use labels to filter eligible resources for scheduling and other operations.	
- Namespace:
	- A scope for a Kubernetes resources and processes, to create boundaries amongst independent resources.


## **OpenShift**

- *RedHat OpenShift Container Platform* is a set of modular components built ontop of Red Hat CoreOS and Kubernets.
- *RedHat OpenShift Container Plaform* comes with additional PaaS features to bolster capabilities like security, auditing, monitoring and application life-cycle management. 
- An OpenShift cluster is a Kubernetes cluster that can be managed the same way but using the managemen toold provided by OpenShift.
- Management tools on OpenShift include the `oc` command-line interface, and a web console.

### **OpenShift Key Terminology:**

- Infra Node:
	- A node server that contains infrastructure services like monitoring, logging, and external routing
- Console:
	- A user-friendly web UI that developers and administrators to interact with their OpenShift cluster.
- Project:
	- OpenShifts extension of a Kubernetes `Namespace`.
