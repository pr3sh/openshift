# Abstract
The primary objective of this guide is to demonstrate how deploy applications to OpenShift.
-  **Table of contents**:
  - [Introduction](#introduction)


#### **`Introduction: `**
- Generally speaking, the **`oc new-app`** command is the easiest way to build applications in **`OpenShift`** in a manner that enables effective management of your applications build and deployment's lifecyle.
- Simplistically, you pass in either a single **`URL`** argument that points to a **`Git`** repository or a container image. It accesses the URL to determine how to interpret the argument and perform either a build or a deployment.
- To ensure that your specific scenario is handle appropriately, you might want to specify some options to ascertain that **`OpenShift`** knows how the application should be built. 

To accommodate these and other scenarios, the oc new-app command provides a number of options to further specify exactly how to build the application:

```zsh
$ oc new-app --as-deployment-config \
> --docker-image=registry.access.redhat.com/rhel7-mysql57
```

  ```zsh
$ oc new-app --as-deployment-config \
 https://github.com/RedHatTraining/DO288/tree/master/apps/apache-httpd
```