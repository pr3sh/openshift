#Abstract

The primary objective of this guide is to demonstrate how Multi-contianer applications are deployed on OpenShift, using a template.



## Introduction:
- Deploying applications on OpenShift usually require the creation project resources (*i.e:* `BuildConfig`, `DeploymentConfig`, `Services`, and `Routes`).
- Template propose a much more simplified approach when it comes to the creation of resources that as needed to deploy and application successfully.
- Attributes of template resources are called **parameters**.
- An application might be made up of a front-end web application and a database server. Each of these will consist of a service and deployment configuration resource.
- They share a set of credentials, or **parameters** that enable the front-end to authenticate to the back-end.
- OpenShift installer creates an electic mix of templates, located within the *openshift* namespace.
- To list preinstalled templates, run: **`oc get templates -n openshift`**.
- To get the template definition in **`YAML`** format, run: `**`oc get template <template_name> -n openshift -o yaml`**` 


```json
{"hi":2,}
```