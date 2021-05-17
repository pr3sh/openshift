# Abstract
The primary objective of this guide is to demonstrate how deploy applications to OpenShift.
-  **Table of contents**:
  - [Introduction](#introduction)


#### **`Introduction: `**
- Generally speaking, the **`oc new-app`** command is the easiest way to build applications in OpenShift in a manner that enables effective management of your applications build and deployment's lifecyle.
- In its simplest form, a single URL argument that points to either a Git repository or a container image. It accesses the URL to determine how to interpret the argument and perform either a build or a deployment.

```zsh
$ oc new-app --as-deployment-config \
> --docker-image=registry.access.redhat.com/rhel7-mysql57
```

  ```zsh
$ oc new-app --as-deployment-config \
 https://github.com/RedHatTraining/DO288/tree/master/apps/apache-httpd
```