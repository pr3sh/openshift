## **`Abstract:`**

The objective of this guide is to understand the basics of troubleshooting containerized applications.
-  **Table of contents**:
  - [Introduction](#introduction)


#### **`Introduction:`**

Before diving into any source code it is quintenssential to understand the basic workflows of the application creation process. The **`S2I`** image creation process is composed of two main steps:
	1. **Build:** In this step, source code is compiled and the application is packaged as a container image. The build step also pushes the image to the OpenShift registry for the deployment step. The **`BuildConfig`** OpenShift resources is the driver of this step. 

Deployment step: Responsible for starting a pod and making the application available for OpenShift. This step executes after the build step, but only if the build step succeeded. The DeploymentConfig (DC) OpenShift resources drive the deployment step.

For the S2I process, each application uses its own BuildConfig and DeploymentConfig objects, the name of which matches the application name. The deployment process aborts if the build fails.

The S2I process starts each step in a separate pod. The build process creates a pod named <application-name>-build-<number>-<string>. For each build attempt, the entire build step executes and saves a log. Upon a successful build, the application starts on a separate pod named as <application-name>-<string>.