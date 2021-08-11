
# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Managing Application Builds](#managing-application-builds)
  
#### **`Managing Application Builds`:**



The Red Hat OpenShift Container Platform manages builds through the build configuration resource. There are two ways to create a build configuration:
Using the **`oc new-app`** command
This command can create a build configuration according to the arguments specified. For example, if a Git repository is defined, then a build configuration using the source strategy is created. Also, if a template is the argument, and the template has a build configuration defined, it creates a build configuration based on template parameters.
Using a custom build configuration
Create a custom build configuration using YAML or JSON syntax and import it to OpenShift using the oc create -f command.