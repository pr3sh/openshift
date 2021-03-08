#Abstract

The primary objective of this guide is to demonstrate how Multi-contianer applications are deployed on OpenShift, using a template.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Describing Image Steams](#describing-image-streams)
  - [Building Applications using Source-to-Image](#building-app-s2i)
  - [Configuring Persistent Storage](#resource-definitions)
  - [Notes](#notes)
  


### Introduction:
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

### Parameters:
Templates contain *parameters* which may need to be specified by the user to their configurations, but can also come with defualt arguments/values which can be overriden when processing the template.

- To specify your parameters for a given template, use the **`oc process <command>`**.
- There are two ways to find out the parameters for a given template:
	- **`oc describe template <template-name> -n openshift`** 
		*or*
	- **`oc process --parameters <template-name> -n openshift`** *(High recommended method.)*.
- When a template is processed, a set of resources are generated for the creation of the new application.
	- To process a template, use the **`oc process -f <filename>`** convention.
	- *Example:* **`oc process -o yaml -f <filename>`**.
	- You can process templates either in the `openshift` project of the your current project by using **`oc process <uploaded-template-name>`**.
- The **`oc process`** command returns the resource list to the standard output, so we can redirect that to a file using the **`>`** command.
	- *Example:* **`oc process -o yaml -f filename  > new_app.yaml`**.
- To override a parameter , you can use the **`-p`** option.
```bash
$ oc process -o yaml -f mysql.yaml \
	-p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
	-p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi > mysqlAppTemplate.yaml 
```
- Create the application from the resource definition **`YAML`** file: **`oc create -f mydwlAppTemplate.yaml`**.
- You can also process a template without saving the definition file, leveraging the **UNIX** pipe.
```bash
$ oc process -f mysql.yaml \
	-p MYSQL_USER=user -p MYSQL_PASSWORD=passw0rd  \
	-p MYSQL_DATABASE=customers -p VOLUME_CAPACITY=10Gi | oc create -f -
```
- You can use **`//`** to specify the namespace as part of the template name.
```bash
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

### Configuring Persistent Storage: 




