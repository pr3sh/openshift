# **`Abstract`**

Understand the concepts of persistent storage & persistent volume claim.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Deploying Dynamically Provisioned Storage](#deploying-dynamically-provisioned-storage)

###### **`Introduction`:**
Data within containers are epehemeral by default, meaning that once the lifetime of a container ends, all data is lost. In order to ensure that your data is persistent, persistent storage via **`bind mounts`** or **`volumes`** must be configured. Volumes are the preferred method of persisting data on OpenShift & they are either managed manually by the cluster administrator, or dynamically through a storage class. OpenShift uses storage classes to enabled cluster administrators to provide persistent storage. Storage classes can be described as storage for the cluster and can be provisioned on-demand, dynamically. 
- Developers on RHOCP use **`PersistentVolumeClaim`** to dynamically add **`PersistentVolume`** to their application.
- The Developer doesn't need to understand the details of the storage infrastructure.
- A **`PersistentVolumeClaim`** are project-specific & cannot be shared between projects once created.
- Developers using **`PersistentVolumeClaim`** must also specify the access mode  & size, among other options.
- **`PersistentVolume`** are accessible across the entire OpenShift cluster.


###### **`Deploying Dynamically Provisioned Storage`:**

> View available storage classes.

```zsh
[user@host ~]$ oc get storageclass
> NAME                    PROVISIONER
  nfs-storage(default)    nfs-storage-provisioner
```

To add a volume to an application, you must create a **`PersistentVolumeClaim`**, and add it to the application as a **`Volume`**. This can be done in two ways:
1. Kubernetes Manifest
2. **`oc set volumes`** command.

> The **`oc set volumes`** command can also modify a deployment to mount the **`PersistentVolumeClaim`** as a **`Volume`** within the pod. 

```zsh
[user@host ~]$ oc set volumes deployment/app-name --add --name example-storage \
    --claim-mode rwo --claim-size 15Gi --mount-path /var/lib/example-app \
    --claim-name example-storage 
```
The above command creates a **`PersistentVolumeClaim`** resource & adds it as a **`Volume`** within the pod.

> Create **`PersistenVolumeClaim`** **`API`** object:

```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: example-storage
  labels:
    app: app-name
spec:
  accessModes:
   - ReadWriteOnce
  resources:
    requests:
      storage: 15Gi
```

> There are three access mode that can be defined in OpenShift:

|         **`AccessMode`** |     **`CLI Abbreviation`**  | **`CLI Abbreviation`**                                                     |
|--------------------------|:---------------------------:|:--------------------------------------------------------------------------:| 
| **`ReadWriteMany`**      | **`RWX`**                   | Kubernetes can mount the volume as **`read-write`** on many nodes.         |
| **`ReadOnlyMany`**       | **`ROX`**                   | Kubernetes can mount the volume as **`read-only`** on many nodes.          | 
| **`ReadWriteOnce`**      | **`RWO`**                   | Kubernetes can mount the volume as **`read-write`** on only a single node. | 
