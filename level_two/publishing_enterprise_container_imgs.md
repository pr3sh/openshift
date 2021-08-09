# **`Abstract`**
Understand how to manage container images in registries using Linux container tools.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Authenticating with Registries](#authenticating-with-registries)
  - [Managing Container Registries with Skopeo](#managing-container-registries-with-skopeo)
  - [Pushing and Tagging Images in a Registry Server](#pushing-and-tagging-images-in-a-registry-server)

#### **`Introduction`:**

A container image registry, container registry, or registry server stores the images that you deploy as containers and provides mechanisms to pull, push, update, search, and remove container images. It uses a standard **`REST API`** defined by the Open Container Initiative **`(OCI)`**, which is based on the **Docker** Registry **`HTTP API v2`**. From the perspective of an organization that runs an OpenShift cluster, there are many kinds of container registries:

###### **`Public registries`:**
  - Registries that allow anyone to consume container images directly from the internet without any authentication.
  -  **`Docker Hub`**, **`Quay.io`**, and the **`Red Hat Registry`** are examples of public container registries.
###### **`Private registries`:**
- Registries that are available only to selected consumers and usually require authentication. 
- The Red Hat terms-based registry is an example of a private container registry.
###### **`External registries`:**
- Registries that your organization does not control. 
- They are usually managed by a cloud provider or a software vendor. 
- **`Quay.io`** is an example of an external container registry.
###### **`Enterprise registries`:**
- Registry servers that your organization manages. They are usually available only to the organization's employees and contractors.
###### **`OpenShift internal registries`**
- A registry server managed internally by an OpenShift cluster to store container images. 

> *These kinds of registries are not mutually exclusive: a registry can be, at the same time, both **public** and **private** registry. Usually a **public** registry is also an **external** registry, because your organization can access it over the internet, without authentication, and your organization does not control it. The same registry could also be a **private** registry, if you organization has a plan with the registry provider that allows you to host **private** images and your organization also has control over who else can access those private images.
**`Quay.io`** works as both a public and a private registry for some users. The same developer can use some public container images from **`Quay.io`**, and also some container images from a vendor, that requires authentication.*

#### **`Authenticating with Registries`:**

- To access a private registry, you need to authenticate. 
- **`Podman`** provides a login subcommand that generates an access token and stores it for subsequent reuse.
- If authentication is successful, **`Podman`** stores an access token in the **`/run/user/UID/containers/auth.json`** file. 
- The **`/run/user/UID`** path prefix is not fixed and comes from the **`XDG_RUNTIME_DIR`** environment variable.
- You can simultaneously log in to multiple registries with **`Podman`**. 
- Each new login either adds or updates an access token in the same file. 
- Each access token is indexed by the registry server FQDN (*Fully Qualified Domain Name*).

> *Authenticate to **`quay.io`** registry.*
```zsh
[user@host ~]$ podman login quay.io Username: developer1
Password: MyS3cret!
>> Login Succeeded!
```
> *Log out of a registry*
```zsh
 [user@host ~]$ podman logout quay.io
>> Remove login credentials for registry.redhat.io
```
> *If you want to log out of all registries, discarding all access tokens that were stored for reuse, use the **`--all`** option.*
```zsh
 [user@host ~]$ podman logout --all
>> Remove login credentials for all registries
```
- **`Skopeo`** and **`Buildah`** can also use the authentication tokens stored by **`Podman`**, but they cannot present an interactive password prompt.
- Podman requires TLS and verification of the remote certificate by default.
-  If your registry server is not configured to use **`TLS`**, or is configured to use a self-signed **`TLS certificate`** or a **`TLS certificate`** signed by an unknown CA, you can add the **`--tls-verify=false`** option to the login and pull subcommands.


#### **`Managing Container Registries with Skopeo`:**

- Red Hat supports the **`skopeo`** command to manage images in a container image registry. 
- **`Skopeo`** does not use a container engine so it is more efficient than using the **`tag`**, **`pull`**, and **`push`** subcommands from **`Podman`**.
- **`Skopeo`** also provides additional capabilities not found in **`Podman`**, such as signing and deleting
container images from a registry server.

> *The **`skopeo`** command takes a subcommand, options, and arguments:*
**`[user@host ~]$ skopeo subcommand [options] location...`**

###### **`Main Subcommands`:**

- **`copy`:** Copy images from one location to another.
- **`delete `** Delete images from aregistry.
- **`inspect`** View metadata about an image.

###### **`Main Options`:**

- **`--creds`** ***`username:password`***
  - To provide login credentials or an authentication token to the registry.
- **`--[src-|dest-]tls-verify=false`**
  - Disables TLS certificate verification.

> For authentication to private registries, **`Skopeo`** can also use the same **`auth.json`** file created by the **`podman `**login command. Alternatively,you can pass your credentials on the command line, as shown below.

```zsh
$ skopeo inspect --creds developer1:MyS3cret! \
    docker://registry.redhat.io/rhscl/postgresql-96-rhel7
```
> **`WARNING!!!!`**Although you can provide credentials to command line tools, this creates an entry in your command history along with other security concerns. Use techniques to avoid passing plain text credentials to commands.

```zsh
$ read -p "PASSWORD: " -s password
PASSWORD:
```
```zsh
$ skopeo inspect --creds developer1:$password  \
    docker://registry.redhat.io/rhscl/postgresql-96-rhel7
```
Skopeo uses **`URIs`** to represent container image locations and **`URI`** schemas to represent container image formats and registry **`APIs`**. The following list shows the most common **`URI`** schemas:
- **`oci`**: Denotes container images stored in a local, OCI-formatted folder
- **`docker`**: Denotes remote container images stored in a registry server.
- **`containers-storage`**: Denotes container images stored in the local container engine cache.

#### **`Pushing and Tagging Images in a Registry Server`:**
The **`copy`** subcommand from Skopeo can copy container images directly between registries, without saving the image layers in the local container storage. It can also copy container images from the local container engine to a registry server and tag these images in a single operation.

> *To copy a container image named **`myimage`** from the local container engine to an insecure, public registry at **`registry.example.com`** under the **`myorg`** organization or user account.*
```zsh
$ skopeo copy --dest-tls-verify=false \ 
            containers-storage:myimage \
            docker://registry.example.com/myorg/myimage
```
> Copy a container image from the **`/home/user/myimage`** OCI-formatted folder to the insecure, public registry.
```zsh
$ skopeo copy --dest-tls-verify=false  \ 
                 oci:/home/user/myimage \
                 docker://registry.example.com/myorg/myimage
```
- When copying container images between private registries, you can either authenticate to both registries using **`Podman`** before invoking the **`copy`** subcommand.
- You can also use the **`--src-creds`** and **`--dest-creds`** options to specify the authentication credentials, as shown below.
```zsh
$ skopeo copy  --src-creds=testuser:testpassword  \ 
               --dest-creds=testuser1:testpassword \
       docker://srcregistry.domain.com/org1/private \
       docker://dstegistry.domain2.com/org2/private
```
> The **`Skopeo`** **`copy`** command can also tag images in remote repositories.
```zsh
$ skopeo copy docker://registry.example.com/myorg/myimage:1.0 \ 
            docker://registry.example.com/myorg/myimage:latest
```
> Delete image from a registry. This command can optionally take the **`--creds`** and **`--tls-verify=false`** options as well.
```zsh
$ skopeo delete docker://registry.example.com/myorg/myimage
```
> **`WARNING!!!!`** Arguments to the **`skopeo`** command are always complete image names. The following example is an invalid command because it provides only the registry server name as the destination argument.

```zsh
$ skopeo copy oci:myimage   \ 
         docker://registry.example.com/
```







