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
- The OpenShift installer populates several image streams by default, during installation, and to available image streams use **`oc get is -n openshift`**


### Building Applications using Source-to-Image:

```bash
$ oc new-app --as-deployment-config \
	php~http://my.git.servercome/my-app --name=myapp 
```
- A **DeploymentConfig** is created instead of a **Deployment**.

- Image stream being use is on the left of the **`~`**.

- **`URL`** after the tilde (**`~`**) indicate the location of source code.

- **`--name`** sets the application name.
	
- *S2I* can identify and process **Dockerfiles** to create images.

- Applications can be build from both remote and local repositories.
	
- If no image stream is specified, then `oc new-app` will attempt to identify the correct image stream to use for building the application.

- *Instead of using a **`~`**, you can pass the **`-i`** option to specify the image stream as show below:*

```bash	
$ oc new-app --as-deployment-config -i php http://services.lab.example.com/pp \
		--name=myapp


#create an application in current directory
$ oc new-app --as-deployment-config .

#Create an application using a remote Git repository and a context subdirectory
$ oc new-app --as-deployment-config \
	http:/github.com/openshift/sti-ruby.git \
	--context-dir=2.0/test/puma-test-test-app
```
- It is also possible to create the application from a Git repository, specifying the branch.
- In this case, the branch we are using is called *beta4*.

```bash
  oc new-pp --as-deployment-config \
	https://github.com/openshift/ruby-hello-world#beta4	

# Create a JSON resource definition file by using the -o parameter
$ oc -o json new-app --as-deployment-config \
	php~https://services.lab.example.com/app \
	--name=myapp > s2i.json
```

The `JSON` definition file creates  list of resources, and the first is the image stream.

```json
{
    "kind": "ImageStream", 
    "apiVersion": "image.openshift.io/v1",
    "metadata": {
        "name": "myapp", 
        "creationTimestamp": null,
        "labels": {
                    "app": "myapp"
                },
                "annotations": {
                    "openshift.io/generated-by": "OpenShiftNewApp"
                }
    },
    "spec": {
        "lookupPolicy": {
            "local": false
        }
    },
    "status": {
        "dockerImageRepository": ""
    }
}
.....
```

- kind:
    - Defines resource type of image stream.
- name:
    - **`my-app`** is the name of the image stream.

The **BuildConfig** is responsible for defining input parameters and triggers that are executed o transform the source code into a runnable image.

```json


```







