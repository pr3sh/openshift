
# **`Abstract`**

-  **Table of contents**:
  - [Monitoring Application Health](#monitoring-application-health)
  - [Deployment Config](#deployment-config)
  	- [Deployment Triggers](#deployment-triggers)
  	- [Setting Deployment Resource Limits](#setting-deployment-resource-limits)


#### **`Monitoring Application Health`**
- Applications can become unreliable for a variety of reasons, including temporary connectivity loss, configuration errors, or application errors. 
- Developers can use **`probes`** to monitor their applications and be made aware of events that can vary from status to resource usage and errors. 
- A **`probe`** is an OpenShift action that periodically performs diagnostics on a running container. 
- **`Probes`** can be configured using either the oc command-line client, defined as part of an OpenShift template, or by using the OpenShift web console. There are currently two types of probes in OpenShift:
1. **Readiness Probe:**
	- **`Readiness`** probes determine whether or not a container is ready to serve requests. 
	- If the **`readiness`** probe returns a **`failed`** state, OpenShift removes the **`IP Address`** for the container from the endpoints of all services. 
	- Developers can use **`readiness`** probes to signal to OpenShift that even though a container is running, it should not receive any traffic from a **`proxy`**. 
	- The **`readiness`** probe is configured in the **`spec.containers.readinessprobe`** attribute of the pod configuration.
2. **Liveness Probe:**
	- **`Liveness`** probes determine whether or not an application running in a container is in a **`healthy`** state. 
	- If the **`liveness`** probe detects an **`unhealthy`** state, OpenShift **`kills`** the container and tries to redeploy it. 
	- The **`liveness`** probe is configured in the **`spec.containers.livenessprobe`** attribute of the pod configuration.

#### **`Deployment Config`**
- A **`DeploymentConfig`** defines the template for a pod and manages the deployment of new images or configuration changes whenever the attributes are changed. 
- Deployment configurations can support many different deployment patterns like: **`Full Restart`**, Customizable **`Rolling Updates`**,  **`Pre`** & **`Post-Life-Cycle Hooks`**.

A deployment configuration is declared within a DeploymentConfig attribute in a resource file, which can be in **`YAML`** or **`JSON`** format. Use the oc command to manage the deployment configuration like any other OpenShift resource. The following template shows a deployment configuration in YAML format:

```yaml
kind: "DeploymentConfig" 
apiVersion: "v1" 
metadata:
  name: "frontend" 
spec:
...
  replicas: 5
  selector:
    name: "frontend" 
  triggers:
    - type: "ConfigChange" 
    - type: "ImageChange"
      imageChangeParams:
...
  strategy:
    type: "Rolling"
...
```
- Start a Deployment. The **`latest`** option indicates that the newest version of the template must be used.
```zsh
$ oc rollout latest dc/name
```
- View history of Deployments for specific **`DeploymentConfig`**, use **`oc rollout history`** command.
```zsh
$ oc rollout history dc/name
```
- Get details about a specific deployment, append the **`--revision`** parameter.
```zsh
$ oc rollout history dc/name --revision=1
```
- To cancel a deployment.
```zsh
$ oc rollout cancel dc/name
```
- To retry failed deployment.
```zsh
$ oc rollout retry dc/name
```
- To use a previous version of the application, you can roll back the deployment.
```zsh
$ oc rollback dc/name
``` 
> *If no revision is specified with the **`--to-version`** parameter, the last successfully deployed revision is used.*

- To prevent accidentally starting a new deployment process after a rollback is complete, image change triggers are disabled as part of the rollback process. 
- You can re-enable image change triggers with the **`oc set triggers`** command.
```zsh
$ oc set triggers dc/name --auto
```
- View deployment logs.
```zsh
$ oc logs -f dc/name
```
- View logs from older failed deployments, given they haven't been pruned or deleted.
```zsh
$ oc logs --version=1 dc/name
```
- Scale the number of pods in deployment.
```zsh
$ oc scale dc/name --replicas=3
```

###### **`Deployment Triggers`:**
Deployment configurations can contain triggers, which drive the creation of new deployments in response to events, both inside and outside of OpenShift. 
- Two types of events that trigger a deployment:
  1. *Configuration change:*
  	- The **`ConfigChange`** trigger creates a new deployment whenever changes are detected to the replication controller template of the deployment configuration. 
  2. *Image change:*
    - The **`ImageChange`** trigger results in a new deployment whenever the value of an image stream tag changes.
    - If the automatic attribute is set to **`false`**, the trigger is disabled
```zsh
$ oc set triggers dc/name \
		 --from-image=myproject/origin-ruby-sample:latest \
		 -c helloworld
```
###### **`Setting Deployment Resource Limits`:**
- A deployment is completed by a pod that consumes resources (**`memory`** and **`CPU`**) on a node. 
- By default, pods consume unlimited node resources. 
	- However, if a project specifies default resource limits, then pods only consume resources up to those limits.
- You can also limit resource use by specifying resource limits as part of the deployment strategy. 
- Resource limits apply to the application pods created by the deployment, but not to deployer pods. 
    - You can use deployment resources with the Recreate, Rolling, or Custom deployment strategies.

> In the following example, resources required for the deployment are declared under the resources attribute of the deployment configuration.
```yaml
type: "Recreate" 
resources:
  limits:
    cpu: "100m" 
    memory: "256Mi
```
- **`CPU`** resource in **`CPU`** units. 100m equals 0.1 **`CPU`** units.
- **`Memory`** resource in bytes. **`256Mi`** equals 268435456 bytes (256 * 2 ^ 20).


