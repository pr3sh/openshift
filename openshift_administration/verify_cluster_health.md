# **`Abstract`**

This section focuses on how to identify and mitigate cluster issues that are not directly related to oeprators or application deployments.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Authenticating with Registries](#authenticating-with-registries)
  - [Managing Container Registries with Skopeo](#managing-container-registries-with-skopeo)
  - [Pushing and Tagging Images in a Registry Server](#pushing-and-tagging-images-in-a-registry-server)
  - [Authenticating OpenShift to Private Registries](#authenticating-openshift-to-private-registries)
  - [Allowing Access to the OpenShift Registry](#allowing-access-to-the-openshift-registry)



#### **`Introduction`:**
The process of troubleshooting an OpenShift cluster relatively similar to trouble shooting application deployments, since most components in RHOCP4 are operators. 
1. You can typically identify the project where the operator resides.
2. The deployment which manages the operator application, and its pods.
3. If there needs to be modifications of that operators configuration, then you can identify the custom resource