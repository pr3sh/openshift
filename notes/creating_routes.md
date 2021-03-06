# Abstract

Understanding how routs work on **OpenShift**, as well as how to expose services using routes.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Describing Image Steams](#describing-image-streams)
  - [Building Applications using Source-to-Image](#building-app-s2i)
  - [Resource definitions](#resource-definitions)
  - [Notes](#notes)

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

