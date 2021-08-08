# **`Abstract`**
Understanding how data injection works in OpenShift, and the several metehods of injecting configuration data into an application.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Creating and Managing Secrets and Configmaps](#creating-and-managing-secrets-and-configmaps)
  - [Commands to Manipulate Configuration Maps and Secrets](#commands-to-manipulate-configuration-maps-and-secrets)
    - [ConfigMaps](#configmaps)
    - [Secrets](#secrets)
  - [Injecting Data from Secrets and Configuration Maps into Applications](#injecting-data-from-secrets-and-configuration-maps-into-applications)
  - [Changing Configuration Maps and Secrets](#changing-configuration-maps-and-secrets)
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
 $ oc create configmap config_map_name \
        --from-literal key1=value1 \
        --from-literal key2=value2
```
> *create a **`Secret`** that holds string literals.*
```zsh
$ oc create secret generic secret_name \
        --from-literal username=user1 \
        --from-literal password=mypa55w0rd
```
> *create a **`ConfigMap`** that stores the contents of a file or a directory containing a set of files.*
```zsh
$ oc create configmap config_map_name \
          --from-file /home/demo/conf.txt
```
> *create a new **`Secret`** that stores the contents of a file or a directory containing a set of files.*
```zsh
$ oc create secret generic secret_name \
            --from-file /home/demo/mysecret.txt
```
> *Example of a **`ConfigMap`** openshift resource definition.*
```yaml
apiVersion: v1
data:
  key1: value1
  key2: value2 
kind: ConfigMap
metadata:
  name: myconf
```
> *Example of a **`Secret`** openshift resource definition.*
```yaml
apiVersion: v1
data:
  username: cm9vdAo=
  password: c2VjcmV0Cg==
kind: Secret
metadata:
  name: mysecret
  type: Opaque
```
> *Alternative Syntax for **`Secret`** Resource Definitions.*
```yaml
apiVersion: v1 
stringData:
  username: user1
  password: pass1 
kind: Secret
metadata:
  name: mysecret
  type: Opaque
```

## **`Commands to Manipulate Configuration Maps and Secrets: `**

#### **`ConfigMaps`:**
> *To view the details of a **`ConfigMap`** in **`JSON`** format.*
```zsh
$ oc get configmap/myconf -o json
```
> *To delete a **`ConfigMap`**.*
```zsh
$ oc delete configmap/myconf
```
> *Edit **`ConfigMap`**.*
```zsh
$ oc edit configmap/myconf
```

> *Use the **`oc patch`** command to edit a **`ConfigMap`** resource.*
- This approach is noninteractive and is useful when you need to script the changes to a resource:

```zsh
$ oc patch configmap/myconf --patch '{"data":{"key1":"newvalue1"}}'
```
#### **`Secrets`:**
> *You can do the same manipulations for **`Secrets`** as well.*
```zsh
$ oc get secret/mysecret -o json
```
```zsh
$ oc delete secret/mysecret
```
> To edit a secret first encode your data in **`base64`** format, for example:
```zsh
 [user@host ~]$ echo 'newpassword' | base64 
 >> bmV3cGFzc3dvcmQK
```
> Use the encoded value to update the secret resource using the **`oc edit`** command.
```zsh
oc edit secret/mysecret
```
> You can also edit a secret resource using the **`oc patch`** command.
```zsh
 [user@host ~]$ oc patch secret/mysecret --patch \ 
             '{"data":{"password":"bmV3cGFzc3dvcmQK"}}'
```
## **`Injecting Data from Secrets and Configuration Maps into Applications: `**

- Configuration maps and secrets can be mounted as data volumes, or exposed as environment variables, inside an application container.
- To inject all values stored in a configuration map into environment variables for pods created from a deployment configuration, use the **`oc set env`** command.

```zsh
$ oc set env dc/mydcname \ 
    --from configmap/myconf
```
> *To mount all keys from a **`ConfigMap`** as files from a volume inside pods created from a
deployment configuration, use the oc set volume command.*
```zsh
oc set volume dc/mydcname --add  -t configmap  \
      -m /path/to/mount/volume  --name myvol --configmap-name myconf
```

## **`Changing Configuration Maps and Secrets` :** 





