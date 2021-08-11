
# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Managing Application Builds](#managing-application-builds)
  	- [Manging Builds From CLI](#managing-builds-from-CLI)
  
#### **`Managing Application Builds`:**


The build configuration resource manages build on Red Hat OpenShift, and there are primarily two ways to create a **`BuildConfig`**:
1. Using the **`oc new-app`** command
 	- This command can create a build configuration according to the arguments specified. 
2. Create a custom build configuration using **`YAML`** or **`JSON`** syntax and import it to OpenShift using the **`oc create -f`** command.

###### **`Manging Builds From CLI`:**
> Start a new build.The build configuration resource name is the only required argument to start a new build:

```zsh
$ oc start-build name
```
- Succesfull builds create an image outputted in the **`ImageStreamTag`**.
> cancel build
```zsh
$ oc cancel-build name
```
- It is only possible to cancel builds that are in **`Running`** or **`Pending`** state.
- Cancelling builds means the build pod is terminated.
> Delete **`BuildConfig`**.
```zsh
$ oc delete bc/name
```
- Generally, you delete a build configuration when you need to import a new one from a file.
> Delete **`Build`** to reclaim the space used by the
build..
```zsh
$ oc delete build/name-1
```
-  A build configuration can have multiple builds.

To show the build logs, use **`oc logs`** command.
- You can check if your application is building correctly. 
- It is not possible to check logs from deleted or pruned builds. 
There are two ways to display a build log:
1. *From the most recent build.*
 - **`oc logs -f bc/name`**
 - The **`-f`** option follows the log until you terminate the command with **`Ctrl+C`**.
2. *From a specific build.*
 - **`oc logs build/name-1`**

###### **`Pruning Builds`:**

By default, builds that have completed are persisted indefinitely. You can limit the number of previous builds that are retained using the **`successfulBuildsHistoryLimit`** and **failedBuildsHistoryLimit** attributes, as shown in the following **YAML** snippet of a **`BuildConfig`**:

```yaml
apiVersion: "v1" 
kind: "BuildConfig" 
metadata:
	name: "sample-build"
 spec:
 	successfulBuildsHistoryLimit: 2
  	failedBuildsHistoryLimit: 2
```











