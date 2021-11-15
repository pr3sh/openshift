# **`Abstract`**

Understand the concepts of persistent storage & persistent volume claim.

-  **Table of contents**:
  - [Introduction](#introduction)

###### **`Introduction`:**
Data within containers are epehemeral by default, meaning that once the lifetime of a container ends, all data is lost. In order to ensure that your data is persistent, persistent storage via **`bind mounts`** or **`volumes`** must be configured. Volumes are the preferred method of persisting data on OpenShift & they are either managed manually by the cluster administrator, or dynamically through a storage class. OpenShift uses storage classes to enabled cluster administrators to provide persistent storage. Storage classes can be described as storage for the cluster and can be provisioned on-demand, dynamically.