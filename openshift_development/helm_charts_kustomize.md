
# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Introduction](#introduction)
  - [Helm Chart Structure](#helm-chart-structure)
  - [Helm Commands](#helm-commands)
  - [Chart Values](#chart-values)
  - [Templates](#templates)
  - [Customizing Deployment with Kustomize](#customizing-deployment-with-kustomize)
    - [Base Configuration](#base-configuration)
    - [Common Series](#common-series)
    - [Patches](#patches)
    - [Applying Customizations](#applying-customizations)

#### **`Introduction`:**
Helm is an open source Package Manager for Kubernetes Applications.
  - It provides a way to package, share, and manage the entire life cycle of said Kubernetes apps.
  - Helm Chart is a collection of files and templates that define a Helm application.
  - Files are distributed in Helm repositories.

#### **`Helm Chart Structure`:**

The **`helm create`** command can be used to create the files needed in the correct structure. 
> *The files created by this command are the basic ones needed for a Helm Chart, which include the minimum templates required for an application to work.*

A Helm chart consists primarily of two **`YAML`** files, and a list of templates.
- **`Chart.yaml`**: Holds the Chart definition information.
- **`values.yaml`**: Holds the values that Helm uses in the default and user-created templates.
- In addition to these two files, a Helm Chart holds several template files, these files are the basis for the Kubernetes resources that make up the application.
- The **`dependencies`** section holds a list of other Helm Charts that allow this Helm Chart to work.
The basic structure of the Chart.yaml file is:
```yaml
apiVersion: v2 
name: mychart 
description: A Helm chart for Kubernetes 
type: application 
version: 0.1.0 
appVersion: "1.0.0" 
.
.
....
dependencies: 
  - name: dependency 
    version: 1.2.3 
    repository: https://examplerepo.com/charts 
  - name: dependency
    version: 3.2.1
    repository: https://helmrepo.example.com/charts
```

#### **`Helm Commands`:**

|         **`Command`**  |     **`Description`**             | 
|------------------------|:---------------------------------:|  
| **`dependency`**       | Manage a chart's dependencies.    | 
| **`install`**          | Install a chart.                  |   
| **`list`**             | List releases installed           |
| **`pull`**             | Download chart from repository.   |
| **`rollback`**         | Rollback to previous revision.    | 
| **`search`**           | Search for keyword in charts.     | 
| **`show`**             | Display information of a chart.   |   
| **`status`**           | Display status of named release   |
| **`uninstall`**        | Uninstall a release               |
| **`upgrade`**          |Upgrade a release                  | 

##### **`Chart Values`:**
1. **`Helm`** replaces the placeholders with the actual values during the processing of the chart. 
2. You can provide these values statically by using the **`values.yaml`** file or dynamically during packaging or installation by using the **`--set`** flag of the **`Helm CLI tool`**.
3. Common practice is to provide the majority of the values by using the **`values.yaml`** file and provide dynamic values at installation time.
4. **`Helm`** takes commands executed on **`Helm CLI`** to **`Tiller`**.
  - **`Tiller `**is the server-side component of **`Helm`**.
  - **`Tiller`** turns commands into something **`Kubernets`** can understand.

> *Below is an excerpt from the contents of this file*
```yaml
...
image:
  repository: container.repo/name 1
  pullPolicy: IfNotPresent 2
  tag: "2.1" 3

...

serviceAccount:
  create: true 4
  annotations: {}
  name: "" 5

...

service:
  type: ClusterIP 6
  port: 80 
```

##### **`Templates`:**
- Helm uses templates to create at runtime the resources needed to deploy the application in the Kubernetes cluster. 
- The Helm CLI tool creates some of these templates, but you can modify them or create new ones to suit your needs.
- Helm uses the Go Template language to define the templates in the templates directory plus some other functions.
- With a section of the common **`deployment.yaml`** template file you can see the use of placeholders and conditional sections
```yaml
metadata:
  name: {{ include "mychart.fullname" . }} 1
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }} 2
  replicas: {{ .Values.replicaCount }} 3
  {{- end }} 4
  template:
    spec:
      containers:
        - name: {{ .Chart.Name }} 5
```
1. The prefix for values from the **`Chart.yaml`** file is the name of the chart
2. Output the block if the value is false
3. The prefix for values from the **`values.yaml`** file is Values
4. End the conditional block
5. The prefix for the name of the chart is **`Chart`**.

##### **`Customizing Deployments with Kustomize`:**
- **`Kustomize `** is a tool that customizes Kubernetes resources for different environments or needs.
-  **`Kustomize`** is a template free solution that helps reuse configurations and provides an easy way to patch any resource.
- The most common use case is the need to define different resources for different environments such as **`development`**, **`staging`**, and **`production`**. 
- **`Kustomize`** separates these configuration sets into two types: **`base`** and **`overlays`**.
- Base holds all configuration and resources common to all the derivatives & Overlays represent the differences from the base on a specific environment. 
- **`Kustomize`** uses directories to represent these configuration sets.

> *Example of a Kustomize layout could be*

```bash
myapp
├── base
└── overlays
  ├── production
  └── staging
```

For each configuration set Kustomize needs a **`kustomization.yaml`** file that can contain:
- Resource Files, Base configuration set to start from
- Resources that patch the base configuration
- Common resources definitions that apply to any configuration set depending on this one
- The resources section of the **`kustomization.yaml`** file is a list of files that combined, create all the resources needed for this specific environment. 

> *This file must reside in the directory of the configuration set.*

```bash
resources:
- deployment.yaml
- secrets.yaml
- service.yaml
```

##### **`Base Configuration`:**
The **`kustomization.yaml`** file of an overlay needs to point to the base configuration sets that are the starting point. For example:
```yaml
bases:
- ../../base
```
- If you follow the expected directory structure, then the relative path is the most portable solution.
- This overlay starts with the base configuration and then applies any patch defined in it.

##### **`Common Series`:**
- Kustomize allows adding new configurations in all the resources that derive from a base set.
- You can set Labels and Annotations with the commonLabels and commonAnnotations sections of a **`kustomization.yaml`** file.
- For example, if you would like to add the origin=kustomize label to the base set and all the overlays that depend on it, then you must add this to the base/**`kustomization.yaml`**:
```yaml
commonLabels:
  origin: kustomize
```

##### **`Patches`:**
- Each overlay can provide any number of modifications to the base configuration through the list of patches to apply.
- First you add the reference to the patch file in the **`kustomization.yaml`** file of the overlay:
```yaml
patches:
- replica_count.yaml
```
- And then, in the patch file provided, you need a way to identify the resource to change and the new value
```yaml
apiVersion: apps/v1
kind: Deployment 
metadata:
  name: myapp 
spec:
  replicas: 5 
```
##### **`Applying Customizations`:**
- You can use **`Kustomize`** as a standalone tool with the **`kustomize command-line`** tool,.
- Or as of Kubernetes 1.14, as part of the **`kubectl apply`** or **`oc apply`** commands. 
- These tools only need the location of the folder with the configuration set to apply.

> *Example of standalone way:*
```bash
[user@host ~]$ kustomize build myapp/base | oc apply -f -
```
> This is an example of the integration in the cluster management tools:
```bash
[user@host ~]$ oc apply -k myapp/base
```
> And an example of applying the overlay modifications:
```bash
[user@host ~]$ oc apply -k myapp/overlays/staging
```


