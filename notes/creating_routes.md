# Abstract

Understanding how routs work on **OpenShift**, as well as how to expose services using routes.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Creating Routes](#creating-routes)

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
>> NAMESPACE 				NAME 						READY 		STATUS 		RESTARTS 		AGE
openshift-ingress		router-default-dahg			1/1			Running		1				4d
```
- Routes made using the **`oc expose`** command generation **DNS** names in this format*: 
	- {route_name}-{project_name}.{default_domain}*

- Routes are also defined int he `openshift-ingress` project by default and **`describe`** pod run:
	-  `oc decribe pod router-default-dahg`


``` yaml
Name:		router-default-dahg	 		
Namespace:	openshift-ingress
.......
...output removed...

.............
	router:
.......output removed.....

		Environment:
			STATS_PORT:	1936
			ROUTER_SERVICE_NAMESPACE: 	openshift-ingress
			DEFAULT_CERTIFICATE_DIR: 	/etc/pki/tls/private
			ROUTER_CANONICAL_HOSTNAME:	apps.cluster.lab.example.com
.........
.......
```

**`ROUTER_CANONICAL_HOSTNAME`** defines the subdomain to be used in all default routes/





