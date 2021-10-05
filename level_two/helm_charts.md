
# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Introduction](#introduction)
  - [Helm Chart Structure](#helm-chart-structure)
  - [Helm Commands](#helm-commands)
  - [Chart Values](#chart-values)

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
.
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
