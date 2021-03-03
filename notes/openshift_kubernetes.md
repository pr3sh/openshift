# **Kubernetes and OpenShift**

-  **Table of contents**:
	- [Kubernetes](#kubernetes)
		- [Kubernetes Key Terminology](#kubernetes)
	[Openshift](#openshift)
		- [OpenShift Key Terminology](#openshift-key-terminology)
		- [Kubernetes Resource Types](#kubernetes-resource-types)
		- [OpenShift Resource Types](#openshift-resource-types)

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

### **Kubernetes Resource Types:**

- Kubernetes has a 6 main resource types tht can be created and configured using `YAML` or `JSON` file.
- Resources can also be configured using OpenShift management tools.

	- Pods:
		- Collections of containers that shre resources, such as `IP Address` and `persistent storage` volumes.
		- Pods are the most basic unit of work for Kubernetes.
	- Services:
		- Services are defined by a single IP/Port combination that provide acces to a pool of pods.
		- By default, services connect clients to pods, in a *round-robin* fashion.
	- Replication Controllers:
		- Kubernetes resource that defines how pods re replicated into different nodes.
		- Scaling is done *horizontally*.
		- Replication controllers help provide high availability for pods and containers.
	- Persistent Volume Claims:
		- Represent a request for storage by a pod.
		- **Persistent Volume Claims** connect **Persistent Volumes** to a pod.
		- Containers typically mount the storage into the containers file system.
		- Containers are *ephemeral* by nature, **Persistent Volumes** are critical for ensuring data resilience.
	- ConfigMaps and Secrets:
		- **ConfigMaps** contian keys and values that are used by other resources.
		- **ConfigMaps** and Secrets re usually used to centralize configuration values used by several resources.
		- **Secrets** differ from **ConfigMaps** since **Secrets** are always *encoded* (not *encrypted*), and acess is generally limited.


### **OpenShift Resource Types:**

- Kubernetes has a 6 main resource types tht can be created and configured using `YAML` or `JSON` file.
- Resources can also be configured using OpenShift management tools.

	- Deployment config(`dc`):
		- Represent a set of containers included in a pod, and the deployment strategies to be used.
		- Pods are the most basic unit of work for Kubernetes.
	- Build config (`bc`):
		- Defines process to be executed in the OpenShift project.
		- Use by the Openshift *Source-toImage(S2I)* feature to build a container image from application source code store in a Git repository.
		- `bc` and `dc` work together to provide a basic, but extensible continuous integation and continuous delivery (*CI/CD*) workflows.
	- Routes:
		- Routes represent a *DNS* host name recognized by the OpenShift router as an ingress point for applications and microservices.
		- Services give you a *Static IP* and routes give you a *DNS Host IP*

- To obtain a list of all resources vailaible in a RedHat OpenShift cluster use the following:
	- `oc api-resources` or `kubectl api-resources`






