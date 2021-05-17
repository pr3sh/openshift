# Abstract

Understanding how routes work on **OpenShift**, as well as how to expose services using routes.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Creating Routes](#creating-routes)
  - [Example](#example)

## Introduction:
- Services allow network access between pods that are contianed in na OpenShift cluster.
- Routes are what allow network access to pods form all users and applications. 
- Essentially with routes, we can be specific about which services we want "exposed", to who.
- Routes aconnect a public-facing IP address and DNS host name to an internal-facing service **IP Address**.
- By default, the router service uses *HAProxy*.
- Router pods bind to the nodes' public IPD address, and not the pots *Sofware Defined Network*.
- **NOTE:**
    - *For those are OpenShift admins, it is important o be aware that the public DNS hostnames configured for routes need to point to the public IP addressesm ubstead of the interal pod's Software Defined Network.*

Below is a minimal example of a route defined in `.json` format.

```json
{
    "apiVersion": "v1",
    "kind": "Route",
    "metadata":{
        "name": "quote-php"
    },
    "spec": {
        "host": "quoteapp.apps.example.com",
        "to": {
            "kind": "Service",
            "name": "quoteapp"

        }
    }

}
```
### Creating Routes:

Routes are create using `oc create <command>` , and a resource definition file must be provided in either **`JSON`* or **`YAML`** format.
It is important to know that when using the OpenShift CLI to create new applications that routes aren't created automatically. In order to create a route based on an existing service:

```bash
# list current services and find what you would like to expose.
$ oc get svc 

# Generate the route
$ oc expose service quotedb --name quotedbsvc

# inspect router pods.
$ oc get pods --all-namespaces -l app=router 
>> NAMESPACE                NAME                        READY       STATUS      RESTARTS        AGE
openshift-ingress       router-default-dahg         1/1         Running     1               4d
```
- Routes made using the **`oc expose`** command generation **DNS** names in this format*: 
    - {route_name}-{project_name}.{default_domain}*

- Routes are also defined int he `openshift-ingress` project by default and **`describe`** pod run:
    -  `oc decribe pod router-default-dahg`


``` text
Name:       router-default-dahg         
Namespace:  openshift-ingress
...

..output removed...
    router:
...output removed.....

..  ... Environment:
            STATS_PORT: 1936
    ...     ROUTER_SERVICE_NAMESPACE:   openshift-ingress
            DEFAULT_CERTIFICATE_DIR:    /etc/pki/tls/private
... ...     ROUTER_CANONICAL_HOSTNAME:  apps.cluster.lab.example.com

...output removed..
```

- **`ROUTER_CANONICAL_HOSTNAME`** defines the subdomain to be used in all default routes.


### Example:

- Log in and authenticate with you **OpenShift** cluster.
```bash
$ oc login -u ${DEV_USER_NAME} -p ${DEV_USER_PASS} {RHT_OCP4_MASTER_API}
>> Login successful
.....
```
- Create a new project.
```bash
$ oc new-project ${DEV_USER_NAME}-routes
```
- Create a new *Python* app, based on a *Source-to-Image* build strategy.
    - The GitHub repository with source code is called `python-helloworld`.
    - The directory is called 
```bash
$ oc new-app --as-deployment-config \
    python:3.7~https://github.com/${DEV_USER_NAME}/python_repo \
        --context-dir python-helloworld \
        --name python-helloworld
```
- Monitor the build and deoployment process/progress within the pods.
```bash
$ oc get pods -w 

NAME                                READY               STATUS                      RESTARTS                    AGE
python-helloworld-1-build           0/1                 Init:0/2                    0                           2s
python-helloworld-1-build           0/1                 PodInitializing             0                           7s
python-helloworld-1-build           1/1                 Running                     0                           0s
python-helloworld-1-deploy          0/1                 ContainerCreating           0                           0s
python-helloworld-1-build           0/1                 Completed                   0                           5m8s
```
- An alternate way of monitory build and deployment logs is to use the **`oc logs bc/<app_name>`** or  **`oc logs dc/<app_name>`** like this:
```bash
$ oc logs -f bc/python-helloworld
``` 
To review the service for this app:

```bash
$ oc describe svc/python-helloworld

Name:               python-helloworld
Namespace:          ${DEV_USER_NAME}-route
Labels:             app=python-helloworld
                    app.kubernetes.io/component=python-helloworld
                    app.kubernetes.io/instance=python-helloworld
Annotations:        openshift.io/generated-by: OpenshiftNewApp
Selector:           deploymentconfig=python-helloworld
Type:               ClusterIP
IP:                 172.34.566.145
Port:               8443-tcp    844d/TCP
TargetPort:         8443/tcp    
Endpoints:          10.10.0.34.8554
Session Affinity:   none
Events:             <none>      
```
- Now you can expose the **`python-helloworld`** service. 
```bash
$ oc expose service python-helloworld \
    --name=${DEV_USER_NAME}-xyz

>>> route.route.openshift.io/${DEV_USER_NAME}-php-helloworld exposed
```
- Inspect resource definition file of our route.
```bash
$ oc describe route python-helloworld

Name:                   ${DEV_USER_NAME}-xyz
Namespace:              ${DEV_USER_NAME}-route
Created:                20 seconds ago
Labels:                 app=python-helloworld
                        app.kubernetes.io/component=python-helloworld
                        app.kubernetes.io/instance=python-helloworld
Annotations:            openshift.io/generated-by: OpenshiftNewApp
Requested Host: python-helloworld-${DEV_USER_NAME}-route.${RHT_OCP4_WILDCARD_DOMAIN}
        exposed on the router default (hist ${RHT_OCP4_WILDCARD_DOMAIN})
Path:               <none>
TLS Termination:    <none>
IP:                 <none>
Insecrue Policy:    <none>          
Endpoint Port:      8080-tcp

Seervice:           python-helloworld
Weight:             100 (100%)
Endpoints:          172.34.566.145:8443, 172.34.566.145:8080
```
Once you're done inspecting the route resource definition, you can try to access the service from an external host, to verify if service and route are functioning as expected.

```cur
$ curl python-hellworld-${DEV_USER_NAME}-route.${RHT_OCP4_WILDCARD_DOMAIN}
```

If you made it to the end of this guide, you are awesome, and I hope you enjoyed learned something!




