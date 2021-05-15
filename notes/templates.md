# **`Abstract`**
The primary objective of this guide is to demonstrate how templates are used in OpenShift.
-  **Table of contents**:
  - [Introduction](#introduction)
  - [parameters](#parameters)
  - [Configuring Persistent Storage](#configuring-persistent-storage)

### **`Introduction: `**
- Deploying applications on OpenShift usually require the creation project resources (*i.e:* `BuildConfig`, `DeploymentConfig`, `Services`, and `Routes`).
- Template propose a much more simplified approach when it comes to the creation of resources that as needed to deploy and application successfully.
- Attributes of template resources are called **parameters**.
- An application might be made up of a front-end web application and a database server. Each of these will consist of a service and deployment configuration resource.
- They share a set of credentials, or **parameters** that enable the front-end to authenticate to the back-end.
- OpenShift installer creates an electic mix of templates, located within the *openshift* namespace.
- To list preinstalled templates, run: **`oc get templates -n openshift`**.
- To get the template definition in **`YAML`** format, run: **`oc get template <template_name> -n openshift -o yaml`**

*You can also publish new templates to the OpenShift cluster for other developers to use your template to build applications.*
- Assuming that you have a template **`YAML`** definition resource file called `checklist-template.yaml`.
- And the **`YAML`** resource definition contains the OpenShift `DeploymentConfig`,`Service`, `Secret`, `PersistentVolumeClaim`, and `Route` objects.
- You can use the **`oc create -f checklist-template.yaml`** to publish the application template.
- If you want to specify the **`Namespace`** where to publish the template: **`oc creeate -f checklist-template.yaml -n <namespace>`**.
    - By default, the template will be created under the current project.

### **`Parameters`**:
Templates contain *parameters* which may need to be specified by the user to their configurations, but can also come with defualt arguments/values which can be overriden when processing the template.

- To specify your parameters for a given template, use the **`oc process <command>`**.
- There are two ways to find out the parameters for a given template:
- **`oc describe template <template-name> -n openshift`** 
        *or*
- **`oc process --parameters <template-name> -n openshift`** *(High recommended method.)*.

 When a template is processed, a set of resources are generated for the creation of the new application.
- To process a template, use: **`oc process -f <filename>`** convention.
- *Example:* **`oc process -o yaml -f <filename>`**.
- You can process templates either in the `openshift` project of the your current project by using: **`oc process <uploaded-template-name>`**.
- The **`oc process`** command returns the resource list to the standard output, so we can redirect that to a file using the **`>`** command.
- *Example:* **`oc process -o yaml -f filename  > new_app.yaml`**.
- To override a parameter , you can use the **`-p`** option.
```zsh
$ oc process -o yaml -f mysql.yaml \
    -p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
    -p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi > mysqlAppTemplate.yaml 
```
- Create the application from the resource definition **`YAML`** file: **`oc create -f mydwlAppTemplate.yaml`**.
- You can also process a template without saving the definition file, leveraging the **UNIX** pipe.
```zsh
$ oc process -f mysql.yaml \
    -p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
    -p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi | oc create -f -
```
- You can use **`//`** to specify the namespace as part of the template name.
```zsh
$ oc process openshift//mysql-persistent \
    -p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
    -p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi | oc create -f -
```
- You can also create an application using the **`oc new-app`** command by specifying **`--template`** option upon app creation.
```bash
$ oc new-app --template=mysql-persistent \
    -p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
    -p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi | oc create -f -
```

### **`Configuring Persistent Storage: `** 

Persistent storage is quintessential when working with contianers, since containers are meant to be *Ephemeral*, it is important to persist information that may be needed afterwards.

- To add a storage resource to your cluster, the OpenShift administrator must create a `PersistentVolume` object that defines the necesarry metadata for storage.
- Ways of access to the storage, capacity, throghput and other characteristics are described by the metadata.
- To list all `PersistentVolumes` in your current namespace, run: **`oc get pv`**, you can specify the namespace as well by passing the **`-n`** option.
- To get the **`YAML`** resource definition of a given `PersistentVolume`, run: **`oc get pv <persistent_vol_name> -o yaml`**.
- To add more `PersistentVolumes`, run: **`oc create -f <persistent_vol_name.yaml>`**


### **`Requesting Persistent Volume Claims: `**

To request dedicated storage resrouces, an application requires the creation of a `PersistentVolumeClaim` resource, as shown below:
```yaml
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
    name: myappname
spec:
    accessModes:
    - ReadWriteOnce
    resources:
        requests:
            storage:200Gi
```
- **`PVC`** define the storage requirements for applications (capacaity or throughput).
- To create the **`PersistentVolumeClaim`**, you can run: **`oc create -f pvc.yaml`**.
- To view created **`PVC`**: 
```zsh
$ oc get pvc
>> NAME         STATUS      VOLUME          CAPACITY       ACCESS MODE          STORAGE CLASS             AGE
myappname       Bound       pv0001           200Gi            RWO                                         10s
```
- The output shows whether the **`PersistentVolumeClaim`** has been bound to a **`PersistentVolme`.
- To use the persistent volume in an application pod, define a volume mount for a container that references the `PersistentVolumeClaim` object as shown below:
```yaml
apiVersion: "v1"
kind: "Pod"
metadata:
  name: "myapp"
  labels:
    name: "myapp"
spec:
  containers:
    - name: "myapp"
      image: openshift/myapp
      ports:
        - containerPort: 80
          name: "http-server"
      volumeMounts:
        - mountPath: "/var/www/html"
          name: "pvol" 1
  volumes:
    - name: "pvol" 2
      persistentVolumeClaim:
        claimName: "myapp"3
```




