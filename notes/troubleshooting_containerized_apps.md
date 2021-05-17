## **`Abstract:`**

The objective of this guide is to understand the basics of troubleshooting containerized applications.
-  **Table of contents**:
  - [Introduction](#introduction)
  - [Common Container Problems](common-container-problems)

#### **`Introduction:`**
Before diving into any source code it is quintenssential to understand the basic workflows of the application creation process. The **`S2I`** image creation process is composed of two main steps:

1. **Build:** In this step, source code is compiled and the application is packaged as a container image. The build step also pushes the image to the OpenShift registry for the deployment step. The **`BuildConfig`** OpenShift resources is the driver of this step. 

2. **`Deployment:`** This step executes after the build step only if the build step succeeded. The **`DeploymentConfig`** OpenShift resources are the driver of the deployment step.

3. The build process creates a pod named **`<application-name>-build-<number>-<string>`**. The application starts on a separate pod named as **`<application-name>-<string>`**.

> To retrieve the logs from a build configuration.
```zsh
$ oc logs bc/<application-name>
```
> To restart the build. 
```zsh
$ oc start-build <application-name>
```
> To retrieve the logs from a deployment configuration.
```zsh
$ $ oc logs dc/<application-name>
```
#### **`Common Container Problems:`** 
Some containers may require a specific user ID, whereas S2I is designed to run containers using a random user as per the default OpenShift security policy.
> The **`Dockerfile`** below creates a Nexus container where the **`USER`** instruction indicating the nexus user should be used.
```Dockerfile
FROM ubi7/ubi:7.7

RUN chown -R nexus:nexus ${NEXUS_HOME}

USER nexus
WORKDIR ${NEXUS_HOME}
```