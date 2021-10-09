# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Openshift Services](#openshift-services)
  - [Defining External Services](#defining-external-services)
  - [Deploying Cloud Native Applications with JKube](#deploying-cloud-native-applications-with-JKube)
 

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
4. If you create an endpoint from a file, you can define multiple **`IP Addresses`** for the same external service that relies on OpenShift service load-balancing features.

#### **`Deploying Cloud-Native Applications with JKube`**:

Cloud-Native techonologies are those that are deisnged to build and run scalable applications in Cloud environments (Hybrid, Public, & Private Cloud). For example, **`Quarkus`** or **`JKube`** do not need **Dockerfiles** in order to create container images. Any Application that is deployed on OpenShift and deigned to use the serives provided by the platform can be classifierd as cloud-native application.


- E