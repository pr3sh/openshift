# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Openshift Services](#openshift-services)
  - [Defining External Services](#defining-external-services)
 

#### **`Openshift Services`**:
- OpenShift services are typically comprised of a name and a selector.
- The service uses selectors to identify pods that should recieve application request sent to the service.



#### **`Defining External Services`**:

  ```shell
  oc create service externalname myservice \
      --external-name myhost.example.com

  ```