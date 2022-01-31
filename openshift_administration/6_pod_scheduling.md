# **`Abstract`**

## **Table of contents**:
  - [Introduction](#introduction)
  - [Labelling Nodes](#labelling-nodes)
 
##### **`Introduction`**:


OpenShift's pod scheduler is responsible for the placement of pods onto nodes. The default configuration supports the common data center concepts of **`zones`** and **`regions`** by using *node labels*, *affinity rules*, and *anti-affinity rules*.

> OpenShift's pod scheduler algorithm follows a three step process:

1. Filtering nodes.
2. Prioritizing the filtered list of nodes.
3. Selecting the best fit node.

> In order to label nodes within an OpenShift cluster, you must be a cluster administrator. A practical example of labelling nodes to segment wordloads could be **`env=dev`** or **`env=prod`** to separate the development and production workloads. Labels chosen on nodes are arbritrary.

> Label a node with **`env=dev`**:

```zsh
[user@host ~]$ oc label node node1.us-west-1.compute.internal env=dev
```

> You can use the **`--overwrite`** option to change an existing label:

```zsh
[user@host ~]$ oc label node node1.us-west-1.compute.internal env=prod --overwrite
```

