


*Kubernetes and OpenShift*

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