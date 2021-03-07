
# Abstract

Understanding how kubernetes resources are created using the `oc` command-line interface.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Describing Pod Resources](#describing-pod-resources)
  - [Understanding Services](#understanding-services)
  - [Creating new applications](#creating-new-applications)
  - [Managing OpenShift Resources](#managing-openshift-resources)
  - [Labelling Resources](#labelling-resources)

### **Introduction:**

The most common way of interacting with your RHOCP cluster is by using the **`oc`** command line like this:
**`$ oc <command>`**  
- List projects.
**`$ oc projects`**
- create project.
**`$ oc project <project_name>`**
- Log in to **OpenShift** cluster
**`$ oc login -u <your_username> -p <your_password> <cluster_url>`**
- login using access token
**`$ oc login https://[IP ADDRESSS]:[PORT] --token=<access_token>`**
- get access token after login
**`$ oc whoami -t`**
*Login using curl:*
```bash
  $ curl -k https://[IP ADDRESSS]:[PORT]/oapi/v1/projects \
     -H "Authorization: Bearer {access_token}"
  ```
### **Describing Pod Resources:**
- OpenShift needs a pod reousrce defiition to run cntiners nd create pods from a container image.
- This can be generated using the `oc new-app` command.
- Resource definitions can be provided as `JSON` or `YAML` files.
- Resources can also be created within the OpenShift Web UI.
*Example of an application server pod definition in `YAML` format:*
```yaml
apiVersion: v1
kind: Pod3
metadata:
  name: dragonfly
  labels:
    name: dragonfly
spec:
  containers:
    - resources:
        limits :
          cpu: 0.5
      image: do345/toumdae
      name: dragonfly
      ports:
        - containerPort: 80880
          name: dragonfly
      env:5
        - name: MYSQL_ENV_MYSQL_DATABASE
          value: fuits
        - name: MYSQL_ENV_MYSQL_USER
          value: ['your_username']
        - name: MYSQL_ENV_MYSQL_PASSWORD
          value: ['your_password']
```
### **Understanding Services:**
- *Services* allow contianers in one pod to open network connections to containers in another pod.
- Pods can die or be restarted, and that results in a different internal IP assignment.
- Services provide a stable IP address for other pods to use, irrespective of what node is runnig the pod after a pod restarts.
- A set of pods running behind a service is manged by a **DeploymentConfig** resource.
- `dc` resources embeds a **ReplicationController** that manages how many replicas of a pod that needs to be created in instances where a pod(s) dies down.

*Example of a minimal service definition:*

```json
{
    "kind": "Service", 
    "apiVersion": "v1",
    "metadata": {
        "name": "quotedb" 
    },
    "spec": {
        "ports": [ 
            {
                "port": 3306,
                "targetPort": 3306
            }
        ],
        "selector": {
            "name": "mysqldb" 
        }
    }
}
```

- The `oc port-forward [PORT]:[PORT]` command allow for forwarding a local port to a pod port.

- This differs from accessing a pod through a service resource.
- Services also carry out load balancing to multiple pods, whereas port-forwarding maps connection to a single pod.

### Creating new applications:

```bash
# create application based on sql image
$ oc new-app --docker-image=mysql:latest --name=mysql  \
        -e MYSQL_USER=myuser -e MYSQL_PASSWORD=password  \
        -e MYSQL_DATABASE=mydb -e MYSQL_ROOT_PASSWORD=password

# create application based on docker image
$ oc new-app --docker-image=nginx --name=nginx

# create from private Docker registry
$ oc new-app --docker-image=<my_registry> --name=<my_app>

# build new app from a git repository in a specific branch in the repository 
$ oc new-app https://github.com/openshift/ruby-hell-world.git#<brance_name> 

# build new app from a GitHub repository, in a specific directory,on a specific brance based on a PHP image.
$ oc new-app php:7.1~https://github.com/path to repository#s2i \
    --name new_php_app --context-dir=temps   
```

### Managing OpenShift Resources:

To get information about resources use the **`oc get <RESOURCE_TYPE>`** command:

- See pod informations:
**`$ oc get pods`**
- get pods along with labels 
**`$ oc get pods --show-labels`**
- Inspecting a router pod:
**`$ oc get pod --all-namespaces -l app=router`**
- check pod status:
**`$ oc get status`**
- get deployment config:
**`$ oc get dc`**
- get replication controller
**`$ oc get rc`**
- get summary of most important cluster compoenents
**`$ oc get all`**
- drill down into those resouces
**`$ oc describe <pod_name>`**
- if you have a resource you want to export in YAML or JSON format you can invoke the **`oc export`** command.
- To build a resource use **`oc create`**
- edit a resource:
**`$ oc edit`**

#delete resource
$ oc delete <RESOURCE_TYPE> name

#execute additional process in container.
$ oc exec <CONTAINER_ID>

#enter a specific pod into a bash shell
$ oc exec <pod_name> -it /bin/bash


# monitor build  and deployment logs
$ oc logs -f bc/<app_name>
$ oc logs -f dc/<app_name>


# Exmine the logs for this build, using the buid name
$ oc logs --all-contianers \
  -f php-helloworld-3-build


#review the service for an application
$ oc describe svc/<app_name>

# expose the service by creating a route with your desired name.
$ oc expose service <service_name>  --name=<desired_name>


```
  - *If you want to access the service form a host external to the cluster to verify that the service and route are working*

  ```bash
$ curl \
   <app-name>-${RHOCP_USER}-route.${RHT_OCP4_WILDCARD_DOMAIN}

>> Hello, World! php version is 7.3.11
  ```

### **Labelling Resources:**

- When working with resource within the same project, it is useful to group the resources by application, environment, or some other criteria.
- Labels are used to establish these groups by defining lbels for the resources within your project.
- labels are a part of the **metadata** section of a resources, as shown below
- Labels defined at top of template, apply to all subsequent objects below that.

```yaml
apiVerion:  v1
kind: Service
metada:

  labels:
    app: Nexus
```

```bash
# retrieve both deployment and service configurations, filtering on the app-nexus label
[localhost@user ~]$ oc get svc,dc -l app=nexus
```



