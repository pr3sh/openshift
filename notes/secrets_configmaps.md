# **`Abstract`**
Understanding how data injection works in OpenShift, and the several metehods of injecting configuration data into an application.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Creating and Managing Secrets and Configmaps](#creating-and-managing-secrets-and-configmaps)
  

### **`Introduction: `**
- OpenShift provides the secret and configuration map resource types to externalize and manage configuration for applications.
- Secret resources are used to store sensitive information, such as passwords, keys, and tokens.
- There are different secret types which can be used to enforce usernames and keys in the secret object.
  - **`service-account-token`**, **`basic-auth`**, **`ssh-auth`**, **`tls and opaque`**.
- Configuration map resources are similar to secret resources, but they store nonsensitive data. A configuration map resource can be used to store fine-grained information, such as individual properties, or coarse-grained information, such as entire configuration files and **`JSON`** data. 
- Data is stored inside a secret resource using **`base64`** encoding. When data from a secret is injected into a container, the data is decoded and either mounted as a file, or injected as environment variables inside the container.

### **`Creating and Managing Secrets and Configmaps: `**

You can use the **`oc create`** command to create secrets and configmaps.

> *create a **`ConfigMap`** that holds string literals.*
```zsh
 oc create configmap config_map_name \
        --from-literal key1=value1 \
        --from-literal key2=value2
```
> *create a **`Secret`** that holds string literals.*
```zsh
oc create secret generic secret_name \
        --from-literal username=user1 \
        --from-literal password=mypa55w0rd
```
> *create a **`ConfigMap`** that stores the contents of a file or a directory containing a set of files.*
```zsh
oc create configmap config_map_name \
          --from-file /home/demo/conf.txt
```
>create a new **`Secret`** that stores the contents of a file or a directory containing a set of files
```zsh
oc create secret generic secret_name \
            --from-file /home/demo/mysecret.txt
```