## **`Abstract:`**

The objective of this guide is to understand the basics of troubleshooting containerized applications.
-  **Table of contents**:
  - [Introduction](#introduction)


#### **`Introduction:`**

Before diving into any source code it is quintenssential to understand the basic workflows of the application creation process. The **`S2I`** image creation process is composed of two main steps:

1. **Build:** In this step, source code is compiled and the application is packaged as a container image. The build step also pushes the image to the OpenShift registry for the deployment step. The **`BuildConfig`** OpenShift resources is the driver of this step. 

2. **`Deployment:`** This step executes after the build step only if the build step succeeded. The **`DeploymentConfig`** OpenShift resources are the driver of the deployment step.

3. The build process creates a pod named **`<application-name>-build-<number>-<string>`**. The application starts on a separate pod named as **`<application-name>-<string>`**.