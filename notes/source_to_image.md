# Abstract

Understanding how source-to-image deployments work on OpenShift Contianer Platform.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Describing Image Steams](#describing-image-streams)
  - [Building Applications using Source-to-Image](#building-app-s2i)
  

### Introduction:

- Source to Image is a tool within OpenShift that makes it easy to build contianer images from an application's source code.

- This allows for developers to focus on development without needing to understand how to create a **Dockerfile**.

- *S2I* also allow for consistently rebuilding an application.

### Describing Image Streams:

OpenShift deploys new versions of user applications into pods quickly.

- Creating new applications using *source-to-image* requires a base image, called the *S2I builder image*, along with the application source code.

- Pods created using older contianer image versions are replaced by pods using new image.

- The image stream resource is a configuration that names specific container images associted with *image steam tags*.
- OpenShift builds the application against an image stream.
- The OpenShift installer populates several image streams by default, during installation, and to available image streams use `oc get is -n openshift`


### Building Apps using Source-to-Image:

```bash
$ oc new-app --as-deployment-config \
	php~http://my.git.servercome/my-app --name=myapp 
```
	1. A DeploymentConfig is created instead of a Deployment.
	2. Image stream being use is on the left of the `~`.
	3. `URL` after the tilde (`~`) indicate the location of source code.
	4. `--name` sets the application name.
	5. *S2I* can identify and process **Dockerfiles** to create images.
	6. Applications can be build from both remote and local repositories.
	7. If no image stream is specified, then `oc new-app` will attempt to identify the correct image stream to use for building the application.

- *Instead of using a `~`, you can pass the `-i` option to specify the image stream as show below:*

```bash	
$ oc new-app --as-deployment-config -i php http://services.lab.example.com/pp \
		--name=myapp


#create an application in current
```







