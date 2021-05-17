# Abstract
The primary objective of this guide is to demonstrate how deploy applications to OpenShift.
-  **Table of contents**:
  - [Introduction](#introduction)


#### **`Introduction:`**
- Generally speaking, the **`oc new-app`** command is the easiest way to build applications in **`OpenShift`** in a manner that enables effective management of your applications build and deployment's lifecyle.
- Simplistically, you pass in either a single **`URL`** argument that points to a **`Git`** repository or a container image. It accesses the URL to determine how to interpret the argument and perform either a build or a deployment.
- To ensure that your specific scenario is handle appropriately, you might want to specify some options to ascertain that **`OpenShift`** knows how the application should be built. 

```zsh
$ oc new-app --as-deployment-config \
> --docker-image=registry.access.redhat.com/rhel7-mysql57
```

```zsh
$ oc new-app --as-deployment-config \
 https://github.com/RedHatTraining/DO288/tree/master/apps/apache-httpd
```
#### **`Supported Options:`**
|         **Options**              |     **Description**                                                                                      | 
|----------------------------------|:--------------------------------------------------------------------------------------------------------:|  
| **`--as-deployment-config`**     | Configures the oc new-app to create a DeploymentConfig resource instead of a Deployment.                 | 
| **`-i`** or **`--image-stream`** | Image stream to be used as either the S2I builder image for an S2I build or to deploy a container Image. |   
| **`--strategy`**                 | **`docker`**, **`pipeline`** or **`source`**.                                                            |
| **`--code`**                     | Provides the **`URL`** to a **`Git`** repository to be used as input to an **`S2I`** build.              |
| **`--docker-image`**             | Provides the URL to a container image to be deployed.                                                    | 
> *The **oc new-app** command can optionally take the builder image stream name as an argument, either as part of the `Git` `URL`, prefixed by a tilde **`(~)`**, or using the --image-stream argument (short form: -i).*

- Deployment **`PHP`** application using the **`~`** method, from **`GitHub`** repo.
```zsh
$ oc new-app --as-deployment-config php~http://gitserver.example.com/mygitrepo
```
- Deployment **`PHP`** application using the **`-i`** for specifying the Image Stream.
```zsh
$ oc new-app --as-deployment-config -i php http://gitserver.example.com/mygitrepo
```
- Deploy a specific **`PHP`** image stream version from a **`GitHub`** source code repo.
```zsh
$ oc new-app --as-deployment-config php:7.0~http://gitserver.example.com/mygitrepo
```
#### **`Managing Applications with OpenShift:**`