
# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Managing Application Builds](#managing-application-builds)
  
#### **`Managing Application Builds`:**


The build configuration resource manages build on Red Hat OpenShift, and there are primarily two ways to create a **`BuildConfig`**:
1. Using the **`oc new-app`** command
 	- This command can create a build configuration according to the arguments specified. 
2. Create a custom build configuration using **`YAML`** or **`JSON`** syntax and import it to OpenShift using the **`oc create -f`** command.

###### **`Manging Builds From CLI`:**


> Start a new build.The build configuration resource name is the only required argument to start a new build
**`oc start-build`***name*
- Succesfull builds create an image outputted in the **`ImageStreamTag`**.