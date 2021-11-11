
# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Managing Application Builds](#managing-application-builds)
  	- [Manging Builds From CLI](#managing-builds-from-CLI)
  - [Triggering Builds](#triggering-builds)
  
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
> *Failed builds include builds with a status of **`failed`**, **`canceled`**, or **`error`**.*
**`oc adm prune` [FLAGS]**
- **Available Options:**
  - **`auth`**: Remove references to the specified roles, clusterroles, users, and groups.
  - **`builds`**: Remove old completed and failed builds.
  - **`deployments`**: Remove old completed and failed deployments.
  - **`groups`**: Remove old OpenShift groups referencing missing records on an external provider.
  - **`images`**: Remove unreferenced images. 

###### **`Log Verbosity`**

To configure build log verbosity.

Edit the build configuration resource, and add the **`BUILD_LOGLEVEL`** environment variable as part of the source strategy or Docker strategy to configure a specific log level:

```zsh
$ oc set env bc/name BUILD_LOGLEVEL="4"
```
- The value must be a number between **zero** and **five**. 
- Zero is the default value and displays fewer logs than five. 
- When you increase the number, the verbosity of logging messages is greater, and the logs contain more details.

#### **`Triggering Builds`:**

In OpenShift you can define build triggers to allow the platform to start new builds automatically based on certain events. You can use these build triggers to keep your application containers updated with any new container images or code changes that affect your application. OpenShift defines two kinds of build triggers:
1. **`Image change triggers`:**
- An image change trigger rebuilds an application container image to incorporate changes made by its parent image.
2. **`Webhook triggers`:**
- OpenShift webhook triggers are **`HTTP API`** endpoints that start a new build. 
    - Use a webhook to integrate OpenShift with your Version Control System (VCS), such as Github or BitBucket, to trigger new builds on code changes.

> *If the image is from an external registry, you must periodically run the **`oc import-image`** command to verify whether the container image changed in the registry server in order to stay up-to-date.*
- The **`oc new-app`** command automatically creates image change triggers for applications using either the source or Docker build strategies.
- Add an image change trigger to a build configuration.
```zsh
$ oc set triggers bc/name --from-image=project/image:tag
```
- A single build configuration cannot include multiple image change triggers.
- To remove an image change trigger from a build configuration, use the **`oc set triggers`** command with the **`--remove`** option.
```zsh
$ oc set triggers bc/name --from-image=project/image:tag --remove
```

###### **`Starting New Builds with Webhook Triggers`:**

Red Hat OpenShift Container Platform provides specialized webhook types that support **`API`** endpoints compatible with the following **`VCS`** services:
- **`GitLab`** , **`GitHub`** , and **`Bitbucket`**
- Red Hat OpenShift Container Platform also provides a generic webhook type that takes a payload defined by OpenShift. A generic webhook can be used by any software to start an OpenShift build.
- The **`oc new-app`** command creates a generic and a Git webhook. 
	- To add other types of webhook to a build configuration, use the **`oc set triggers`** command. 
	- *For example*, to add a **`GitLab`** webhook to a build configuration:
	- **`oc set triggers bc/name --from-gitlab`**
	- To remove an existing webhook from a build configuration, use the oc set triggers command with the **`--remove`** option
	- *For Example* **`oc set triggers bc/name --from-gitlab --remove`**
	- The **`oc set triggers bc`** command also supports **`--from-github`** and **`--from-bitbucket`**


- Start a new build manually, using the generic webhook for the build configuration.
1. Get the generic webhook **`URL`**

```zsh
oc describe bc <name>
```
2. Get the secret for the webhook.
  ```zsh
SECRET = $(oc get bc <name> -o jsonpath='{.spec.triggers[*].generic.secret}{"\n"}')
  ```
3. Make **`POST`** request:
```zsh
curl -X POST -k \
${RHT_OCP4_MASTER_API}\
/apis/build.openshift.io/v1/namespaces/${RHT_OCP4_DEV_USER}-build-app\
/buildconfigs/<name>/webhooks/$SECRET/generic
```


#### **`Post Commit Hooks`:**

There are two types of post-commit build hooks you can configure:
1. **`Command: `**
  - A command is executed using the **`exec`** system call. 
  - Create a command post-commit build hook using the **`--command`** option as shown below.
  ```zsh
  $ oc set build-hook bc/name --post-commit \ 
  		 --command -- bundle exec rake test --verbose
  ```
2. **`Shell Script: `**
  - Runs a build hook with the **`/bin/sh -ic`** command. 
  - This is more convenient since it has all the features provided by a shell, such as argument expansion, redirection, and so on. 
  - It only works if the base image has the **`sh`** shell. 
  - To create a shell script **`post-commit`** build hook using the **`--script`** as shown below.
  ```zsh
  $ oc set build-hook bc/name --post-commit \ 
  		 --script="curl http://api.com/user/${USER}"
  ```






