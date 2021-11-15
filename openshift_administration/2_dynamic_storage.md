# **`Abstract`**

Understand the concepts of persistent storage & persistent volume claim.

-  **Table of contents**:
  - [Introduction](#introduction)

###### **`Introduction`:**


Data within containers are epehemeral by default, meaning that once the lifetime of a container ends, all data is lost. In order to ensure that your data is persistent, persistent storage via **`bind mounts`** or **`volumes`** must be configured. Volumes are the preferred method of persisting data on OpenShift