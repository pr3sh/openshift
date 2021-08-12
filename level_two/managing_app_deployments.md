
# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Managing Application Builds](#managing-application-builds)

- A **`DeploymentConfig`** defines the template for a pod and manages the deployment of new images or configuration changes whenever the attributes are changed. 
- Deployment configurations can support many different deployment patterns like: **`Full Restart`**, Customizable **`Rolling Updates`**,  **`Pre`** & **`Post-Life-Cycle Hooks`**.

A deployment configuration is declared within a DeploymentConfig attribute in a resource file, which can be in **`YAML`** or **`JSON`** format. Use the oc command to manage the deployment configuration like any other OpenShift resource. The following template shows a deployment configuration in YAML format:

```yaml
kind: "DeploymentConfig" apiVersion: "v1" metadata:
name: "frontend" spec:
...
  replicas: 5
  selector:
name: "frontend" triggers:
...
- type: "ConfigChange" - type: "ImageChange"
  imageChangeParams:
strategy:
type: "Rolling"
...
```
- Start a Deployment.The **`latest`** option indicates that the newest version of the template must be used.
```zsh
$ oc rollout latest dc/name
```
- View history of Deployments for specific **`DeploymentConfig`**, use **`oc rollout history`** command.
```zsh
$ oc rollout history dc/name
```
- details about a specific deployment, append the --revision parameter