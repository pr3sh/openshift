# Abstract

Understanding how source-to-image deployments work on OpenShift Contianer Platform.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Describing Image Steams](#describing-image-streams)
  - [Building Applications using Source-to-Image](#building-app-s2i)
  - [Resource definitions](#resource-definitions)
  - [Notes](#notes)
  

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

```zsh 
$ oc new-app --as-deployment-config -i php http://services.lab.example.com/pp \
        --name=myapp
```

#create an application in current directory
```
$ oc new-app --as-deployment-config .
```

#Create an application using a remote Git repository and a context subdirectory
``` bash
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
### Resource Definitions

The `JSON` definition file creates  list of resources, and the first is the image stream.

```json
{
    "kind": "ImageStream", 
    "apiVersion": "image.openshift.io/v1",
    "metadata": {
        "name": "myapp", 1
        "creationTimestamp": null,
        "labels": {
                    "app": "myapp" 2
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
1. *kind* defines resource type of image stream.
2. *name* is the  **`my-app`** is the name of the image stream.

The **BuildConfig** is responsible for defining input parameters and triggers that are executed o transform the source code into a runnable image.

```json
...output omitted...
{
    "kind": "BuildConfig", 1
    "apiVersion": "build.openshift.io/v1",
    "metadata": {
        "name": "myapp", 2
        "creationTimestamp": null,
        "labels": {
            "app": "myapp"
        },
        "annotations": {
            "openshift.io/generated-by": "OpenShiftNewApp"
        }
    },
    "spec": {
        "triggers": [
            {
                "type": "GitHub",
                "github": {
                    "secret": "S5_4BZpPabM6KrIuPBvI"
                }
            },
            {
                "type": "Generic",
                "generic": {
                    "secret": "3q8K8JNDoRzhjoz1KgMz"
                }
            },
            {
                "type": "ConfigChange"
            },
            {
                "type": "ImageChange",
                "imageChange": {}
            }
        ],
        "source": {
            "type": "Git",
            "git": {
                "uri": "http://services.lab.example.com/app" 3
            }
        },
        "strategy": {
            "type": "Source", 4
            "sourceStrategy": {
                "from": {
                    "kind": "ImageStreamTag",
                    "namespace": "openshift",
                    "name": "php:7.3" 5
                }
            }
        },
        "output": {
            "to": {
                "kind": "ImageStreamTag",
                "name": "myapp:latest" 6
            }
        },
        "resources": {},
        "postCommit": {},
        "nodeSelector": null
    },
    "status": {
        "lastVersion": 0
    }
},
...output omitted...

```
1. Resource type **BuildConfig**.
2. Name of **BuildConfig** is **`my-app`**.
3. Define source code Git Repo.
4. Define strategy, in this case we are using *source-to-image*.
5. Defines the builder image as **`php:7.3`** image stream.
6. Name the output image steam **`my-app:latest`**.


```json
.............
{
    "kind": "DeploymentConfig", 1
    "apiVersion": "apps.openshift.io/v1",
    "metadata": {
        "name": "myapp", 2
        "creationTimestamp": null,
        "labels": {
            "app": "myapp"
        },
        "annotations": {
            "openshift.io/generated-by": "OpenShiftNewApp"
        }
    },
    "spec": {
        "strategy": {
            "resources": {}
        },
        "triggers": [
            {
                "type": "ConfigChange" 3
            },
            {
                "type": "ImageChange", 4
                "imageChangeParams": {
                    "automatic": true,
                    "containerNames": [
                        "myapp"
                    ],
                    "from": {
                        "kind": "ImageStreamTag",
                        "name": "myapp:latest"
                    }
                }
            }
        ],
        "replicas": 1,
        "test": false,
        "selector": {
            "app": "myapp",
            "deploymentconfig": "myapp"
        },
        "template": {
            "metadata": {
                "creationTimestamp": null,
                "labels": {
                    "app": "myapp",
                    "deploymentconfig": "myapp"
                },
                "annotations": {
                    "openshift.io/generated-by": "OpenShiftNewApp"
                }
            },
            "spec": {
                "containers": [
                    {
                        "name": "myapp",
                        "image": "myapp:latest", 5
                        "ports": [ 6
                            {
                                "containerPort": 8080,
                                "protocol": "TCP"
                            },
                            {
                                "containerPort": 8443,
                                "protocol": "TCP"
                            }
                        ],
                        "resources": {}
                    }
                ]
            }
        }
    },
    "status": {
        "latestVersion": 0,
        "observedGeneration": 0,
        "replicas": 0,
        "updatedReplicas": 0,
        "availableReplicas": 0,
        "unavailableReplicas": 0
    }
},
...output omitted...
```

1. Resource type **DeploymentConfig**.
2. Name of **DeploymentConfig** is **`my-app`**.
3. A configurate change triggers a new deployment to be created any time the replication controller template changes.
4. An image change trigger causes the creation of a new deployment each time a new version of the **myapp:latest** image is available in the repo.
5. Defines container image to deploy **`my-app:latest`**.
6. Specifies the container ports.

The last resource is the service which you can find details in my other repo file `creating_kubernetes_resouces.md` in the `/notes` directory.

- It is important to note that routes are not creted when you invoke **`oc new-app`**, but you can create the route after the appliction is created.

*Useful commands:*
```bash
# see a list of application builds
$ oc get builds

# view build logs
$ oc logs build/myapp-1

#Trigger a new build with oc start-build
$ oc get buildconfig
>> NAME     TYPE        FROM        LATEST
myapp         Source    Git             1

$ oc start-build myapp
>> build "myapp-2" started

#find url associated with a newly named route
$ oc get route -o jsonpath='{..spec.host}{"\n"}'
```

### Notes:

Builds and Deployment configurations are somewhat intertwined as the **BuildCOnfig** pod is responsible for creating the images in the *OpenShift* cluster and pushing htem to the internal contianer registry. Any update to content will generally require a new build to ensure the image is updated.

**DeploymentConfig** pod is responsible for deploying pods to OpenShift cluster. This results in creation of pods with the images deployed to the internal registry.

**BuildConfig** and **DeploymentConfig** do not interact at all, directly.








