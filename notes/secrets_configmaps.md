# **`Abstract`**
Understanding how data injection works in OpenShift, and the several metehods of injecting configuration data into an application.

-  **Table of contents**:
  - [Introduction](#introduction)
  

### **`Introduction: `**

- OpenShift provides the secret and configuration map resource types to externalize and manage configuration for applications.
- Secret resources are used to store sensitive information, such as passwords, keys, and tokens.
- There are different secret types which can be used to enforce usernames and keys in the secret object.
  - **`service-account-token`**, **`basic-auth`**, **`ssh-auth`**, **`tls and opaque`**. 
- Attributes of template resources are called **parameters**.
