# **`Abstract`**

Understand the core concept behind Authentication & Authorization.
-  **Table of contents**:
  - [Introduction](#introduction)
  - [Authentication Operator](#authentication-operator)
  - [Identity Providers](#identity-providers)
  - [Authenticating as a Cluster Admin](#authenticating-as-as-cluster-admin)
  - [Configuring HTPasswd Identity Provider](#identity-providers)
    - [OAuth Resource](#oauth-resource)
    - [Deleting Users and Identities](#deleting-users)
  - [Assigning Admin Privileges](#assigning-admin-privileges)
  - [Role Based Access Control](#role-based-access-control)
    - [RBAC Using CLI](#rbac-using-cli)
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
[user@host ~]$ oc get nodes

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
To manage users using the **`HTPasswd`** Identity Provider, you are required to create a temporary **htpasswd** file and applying the changes to the secret stored in the **`openshift-config`** project.
> You can use the **`httpd-utils`** package, using the **`htpasswd`** utility.

Create the **`htpasswd`** file.
```zsh
[user@host ~]$ htpasswd -c -B -b /tmp/htpasswd student redhat123
```
Add or Update credentials.
```zsh
[user@host ~]$ htpasswd -b /tmp/htpasswd student redhat12345
```
Delete credentials.
```zsh
[user@host ~]$ htpasswd -D /tmp/htpasswd student
```
Create a secret that contains the **`htpasswd`** file data.
```zsh
[user@host ~]$ oc create secret generic htpasswd-secret \
            --from-file htpasswd=/tmp/htpasswd -n openshift-config
```
To extract data from the **`htpasswd-secret`**, you can use the **`oc extract`** command. The **`--confirm`** overwrites file, if it already exists.
```zsh
[user@host ~]$ oc extract secret/htpasswd-secret -n openshift-config --to /tmp/ \
                  --confirm /tmp/htpasswd
```
To update secret after adding, changing, or deleteing users you can use the **`oc set data`** command.
```zsh
[user@host ~]$ oc set data secret/htpasswd-secret  \
             --from-file htpasswd=/tmp/htpasswd -n openshift-config
```
After secret has been updated, a redeployment is triggered in the **`openshift-authentication`** namespace. To monitor a redeployment of the new **`OAuth`** pods:
```zsh
[user@host ~]$ watch oc get pods -n openshift-authentication
``` 
###### **`OAuth Resource`**:
```yaml
apiVersion: config.openshit.io/v1
kind: OAuth
metadata:
  name: cluster
spec:
  identityProviders:
    - name: my_htpasswd_provider  
      mappingMethod: claim  
      type: HTPasswd
      htpasswd:
        fileData:
          name: htpasswd-secret
```
###### **`Deleting Users and Identities`**:
If you must delete  user, it is not sufficient to delete the user from the identity provider. 
1. You must also delete the identity & user resources.
2. Remove the password from the **`htpasswd`** secret
3. Remove user from the local **`htpasswd`** file.
4. Update secret
```zsh
[user@host ~]$ htpasswd -D /tmp/htpasswd manager
```
Update secret.
```zsh
[user@host ~]$ oc set data secret/htpasswd-secret  \
                   --from-file htpasswd=/tmp/htpasswd -n openshift-config
```
Remove user resource.
```zsh
[user@host ~]$ oc delete user manager 
```

> Identity resources include the name of the provider & to delete the resource for the **`manager`** user:
```zsh
[user@host ~]$ oc get identities | grep manager
> my_htpasswd_provider:manager    my_htpasswd_provider    ....

[user@host ~]$ oc delete identity my_htpasswd_provider:manager
```
#### **`Assigning Admin Privileges`**:
```zsh
[user@host ~]$ oc adm policy add-cluster-role-to-user cluster-admin <user_name>
```
**`Role Based Access Control`**:

Role-based acesss control is a mechanism used to manage access of resources. Within OpenShift there are two types of roles that can be used; **`cluster`** and **`local`**. Users assigned the **`cluster`** role can manage the cluster OpenShift cluster, while **`local`** role gives authorization at a project level. The authorization process is managed by **roles**, **rules**, and **bindings**.
- **`Rule`**: Allowed actions for objects or groups of objects.
- **`Role`**: Set of rules for which users and groups can be associated with.
- **`Binding`**: Assignment of **`users`** or **`groups`** to a **`role`**.

> **`NOTE`**: *Cluster role bindings take precendence over local rolebindings.*

###### **`RBAC Using CLI`**:
Cluster admins can use the **`oc adm policy`** command to manage cluster and namespace roles, while Project admins can use the **`oc policy`** command to manage namespace roles.
> Add **cluster-role** to a user.

```zsh
[user@host ~]$ oc adm policy add-cluster-role-to-user <cluster-role> <username>
```
> Remove **cluster-role** from a user.

```zsh
[user@host ~]$ oc adm policy remove-cluster-role-from-user <cluster-role> <username>
```
> You can use the **`oc who-can`** command to determine what actions a user can execute on a resource; for example:

```zsh
[user@host ~]$ oc adm policy who-can delete user
```

> List cluster rolebindings

```zsh
[user@host ~]$ oc get clusterrolebindings
```
> Create group called **dev-group**.

```zsh
[user@host ~]$ oc adm groups new dev-group
```









