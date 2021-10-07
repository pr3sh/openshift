# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Openshift Services](#openshift-services)
  - [Defining External Services](#defining-external-services)
 

#### **`Openshift Services`**:
- OpenShift services are typically comprised of a name and a selector.
- The service uses selectors to identify pods that should recieve application request sent to the service.
- OpenShift's internal DNS allows applications to discover services dynamically.
- OpenShift adds the **`svc.cluster.local`** domain suffix to the DNS resolver search path of all containers.
- Openshift also adds a **`service-name.project-name.svc.cluster.local`** host name to each service.


#### **`Defining External Services`**:

To create an internal service, use the **`oc create service externalname`** command as show below:
```shell
  oc create service externalname myservice \
      --external-name myhost.example.com

  ```
1. A typical service creates an endpoint resource.
2. If you do not use the **`--external-name`** flag, an endpoint resource **WONT** be created.
3. You can create the endpoint with a resource definition file, passed through the **`oc create -f`** command.