# **`Abstract`**

Understand the core concept behind Authentication & Authorization.
-  **Table of contents**:
  - [Introduction](#introduction)
  - [Authentication Operator](#authentication-operator)
  - [Identity Providers](#identity-providers)
  - [Authenticating as a Cluster Admin](#authenticating-as-as-cluster-admin)
  - [Configuring HTPasswd Identity Provider](#identity-providers)
    - [OAuth Resource](oauth-resource)
#### **`Introduction`**:
OpenShift has a few primary resources that make up the core components of **authentication** and **authorization**.
- **`User`**:
  - Users represent an actor within the OpenShift Container Platform that interact with the **`API Server`**. 
  - Users can be part of **`groups`**, and can be assigned permissions either individually or via a **`group`**.
- **`Identity`**:
  - The **Identity** resource maintains a record of successful authentication attempts from a specific user & identity provider.
  - Data pertaining to the source of authentication is stored on the identity.
  - Only one user can be associated with an identity. 
- **`Service Account`**:
 - **`Service Accounts`** enable you to control API access without the need to borrow a user's credentials.
- **`Group`**:
  - Set of users.
  - Users can be assinged to multiple groups.
- **`Role`**:
  - Set of permissions that enable a user, group or service accounts.
#### **`Authentication Operator`**:
Authentication and Authorization are two distinct concepts that can often be misconstrued. Just because you can authenticate to the cluster does not mean you are authorized to do anything. 
1. The authentication security layer asssociates a user with an **`API`** request. 
2. Granted it is successful, the authorization layer then decides whether to honor or reject the **`API`** request.
3. The authorization layer uses **`RBAC`** (**`Role-Based Access Control`**) policies to determine user privileges.

OpenShift uses two methods to authenticate requests; **`OAuth Access Tokens`** & **`X.509 Client Certificates`**. If neither of these are not present in the request, then the authentication layer assings the request a **`system:anonymous`** virtual user and **`system:unauthenticated`** virtual group.
#### **`Identity Providers`**:
OpenShift can be configured with many different identity providers but below are some of the most common:
- **HTPasswd**:
- **Keystone**:
- **LDAP**
- **Github/Github Enterprise**:
- **OpenID Connect**:

> The **`OAuth`** resource needs to be updated with your chosen **`Identity Provider`** and multiple **`Identity Providers`** of the same/different kinds can be defined on the same **`OAuth`** custom resource.
#### **`Authenticating as a Cluster Admin`**:

Before any **`Identity Provider`** can be configured, you must access your cluster as an administrator. This can be done by authenticating as either **`kubeadmin`** user or **`kubeconfig`** file. Creating additional users then requires the configuration of an **`Identity Provider`**.
> *Authenticate as `kubeadmin`*.

```zsh
[user@host ~]$ export KUBECONFIG=/home/user/auth/kubeconfig
[user@host ~]$ oc et nodes

```
 *Alternatively*
```zsh
[user@host ~]$ oc --kubeconfig /home/user/auth/kubeconfig get nodes
 ```
 > After an Identity Provider has been configured, users created, and cluster-admin role has been assigned, you can remove **`kubeadmin`** user's credentials to improve cluster security.

```zsh
[user@host ~]$ oc delete secret kubeadmin -n kube-system
```
#### **`Configuring HTPasswd Identity Provider`**:

###### **`OAuth Resource`**:
```yaml
apiVersion: config.openshit.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
    - name: my_htpasswd_provider  
      mapping: Claim  
      type: HTPasswd
      htpasswd:
        fileData:
          name: htpasswd-secret
```

















