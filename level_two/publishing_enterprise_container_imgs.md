# **`Abstract`**
Understand how to manage container images in registries,access the OpenShift internal registry using Linux container tools.

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Authenticating with Registries](#authenticating-with-registries)
  - [Managing Container Registries with Skopeo](#managing-container-registries-with-skopeo)
  - [Pushing and Tagging Images in a Registry Server](#pushing-and-tagging-images-in-a-registry-server)
  - [Authenticating OpenShift to Private Registries](#authenticating-openshift-to-private-registries)
  - [Allowing Access to the OpenShift Registry](#allowing-access-to-the-openshift-registry)
 
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

#### **`Authenticating OpenShift to Private Registries`:**

- OpenShift requires credentials to access container images in private registries. 
- These credentials are stored as secrets and can be provided directly to the **`oc create secret`** command.
```zsh
$ oc create secret docker-registry registrycreds \ 
             --docker-server registry.example.com \
             --docker-username youruser            \
             --docker-password yourpassword
```
- Another way of creating the secret is to use the authentication token from the **`podman login`** command.
```zsh
$ oc create secret generic registrycreds \
           --from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \ 
           --type kubernetes.io/dockerconfigjson
```
- link the secret to the **`default`** service account from your project
```zsh
$ oc secrets link default registrycreds --for pull
```
- To use the secret to access an **`S2I`** builder image, link the secret to the **`builder`** service account from your project.
```zsh
$ oc secrets link builder registrycreds
```
#### **`Allowing Access to the OpenShift Registry`**:

###### **`The Image Registry Operator`:**
- The OpenShift installer configures the internal registry to be accessible only from inside its OpenShift cluster. 
- Exposing the internal registry for external access is a simple procedure, but requires cluster administration privileges.
- The OpenShift **`Image Registry Operator`** manages the internal registry. 
- All configuration settings for the **`Image Registry`** operator are in the **`cluster`** configuration resource in the **`openshift-image-registry`** project. 
- Change the **`spec.defaultRoute`** attribute to **`true`**, and the Image Registry operator creates a route to expose the internal registry. 
- One way to perform that change uses the following **`oc patch`** command.
- The **`default-route`** route uses the **`default`** wildcard domain name for application deployed to the cluster.
```zsh
$ oc patch configs.imageregistry.operator.openshift.io/cluster \
         --patch '{"spec":{"defaultRoute":true}}' --type=merge
```
```zsh
$ oc get route -n openshift-image-registry
>> NAME               HOST/PORT 
   default-route      default-route-openshift-image-registry.domain.example.com
```
###### **`Authenticating to an Internal Registry`:**

> Use the **`oc whoami -t`** command to fetch the token.
```zsh
$ TOKEN=$(oc whoami -t)
```
> Then login to **`Podman`**.
```zsh
$ podman login -u myuser -p ${TOKEN} \
     default-route-openshift-image-registry.domain.example.com
```
> You can also use the token as the value of the **`--[src|dst]creds`** options from **`Skopeo`**.
```zsh
$ skopeo inspect --creds=myuser:${TOKEN} \
     docker://default-route-openshift-image-registry.domain.example.com/...
```
> If your OpenShift cluster is configured with a valid **`TLS certificate`** for its wildcard domain, you can use the Linux container tools to work with images inside any project you have access to.
```zsh
skopeo inspect docker://default-route-openshift-image-registry.domain.example.com/myproj/myapp
```
> If your OpenShift cluster uses the **`Certification Authority (CA)`** that the OpenShift installer generates by default, you need to access the internal registry as an insecure registry.
```zsh
$ skopeo inspect --tls-verify=false \
    docker://default-route-openshift-image-registry.domain.example.com/myproj/myapp
```

###### **`Granting Access to Images in an Internal Registry`**:

OpenShift also offers a few specialized roles for when you want to grant access only to images inside a project, and not grant access to perform other development tasks such as building and deploying applications inside the project. The most common of these roles are:
- **`registry-viewer`** and **`system:image-puller`**
  - These roles allow users to pull and inspect images from the internal registry.
- **`registry-editor`** and **`system:image-pusher`**
  - These roles allow users to push and tag images to the internal registry.
- **`The system:*`** 
  - These roles provide the minimum capabilities required to pull and push images to the internal registry. 
- The **`registry-*`** roles provide more comprehensive capabilities around registry management for organizations that want to use the internal registry as their enterprise registry. 

> The following example allows a user to pull images from the internal registry in a given project. You need to have either project or cluster-wide administrator access to use the **`oc policy command`**.

```zsh
$ oc policy add-role-to-user system:image-puller \ 
                        user_name -n project_name
```

#### **`Creating Image Streams`**
- **`Image streams`** are one of the main differentiators between OpenShift and upstream Kubernetes. Kubernetes resources reference container images directly, but OpenShift resources, such as deployment configurations and build configurations, reference image streams.
- **`Image streams`** allow OpenShift to ensure reproducible, stable deployments of containerized applications and also rollbacks of deployments to their latest known-good state.
- Image streams provide a stable, short name to reference a container image that is independent of any registry server and container runtime configuration.

> *To better visualize the relationship between image streams and image stream tags, you can explore the **`openshift`** project that is pre-created in all OpenShift clusters.*
```zsh
$ oc get is -n openshift -o name 
```
- A number of tags exist for the **`php`** image stream, and an image stream resource exists for each.
```zsh
$ oc describe is php -n openshift
```
- To create an image stream tag resource for a container image hosted on an external registry, use the **`oc import-image`** command with both the **`--confirm`** and **`--from`** options.
```zsh
$ oc import-image myimagestream[:tag] --confirm \
                  --from registry/myorg/myimage[:tag]
```
```zsh
$ oc import-image myimagestream:1.0 --confirm \ 
                   --from registry/myorg/myimage
```
- To create one image stream tag resource for each container image tag that exists in the source registryserver,add the **`--all`** option to the **`oc import-image`** command.

```zsh
$ oc import-image myimagestream --confirm --all \ 
                 --from registry/myorg/myimage
```

###### **`Using Image Streams with Private Registries`**:
- To create image streams and image stream tags that refer to a private registry, OpenShift needs an access token to that registry server.
- You provide that access token as a secret, the same way you would to deploy an application from a private registry, and you do not need to link the secret to any service account. 
- The **`oc import- image`** command searches the secrets in the current project for one that matches the registry host name.

> *Example below uses **`Podman`** to log in to a private registry, create a secret to store the
access token, and then create an image stream that points to the private registry.* 

```zsh
[user@host ~]$ podman login -u myuser registry.example.com
```
```zsh
[user@host ~]$ oc create secret generic regtoken \
             --from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \ 
             --type kubernetes.io/dockerconfigjson
```
```zsh
[user@host ~]$ oc import-image myis --confirm \
               --from registry.example.com/myorg/myimage
```

###### **`Sharing an Image Stream Between Multiple Projects`:**
- OpenShift comes with a shared project named openshift, which provides quick-start application templates and also image streams for **`S2I`** builders for popular programming languages such as **`Python`** and **`Ruby`**. 
- To build and deploy applications using an image stream that is defined in another project, you have two options:
  1. Create a **`secret`** with an access token to the private registry on each project that uses the image stream, and link that secret to each project's service accounts.
  2. Create a **`secret`** with an access token to the private registry only on the project where you create the image stream, and configure that image stream with a **`local reference policy`**. Grant rights to use the image stream to service accounts from each project that uses the image steam.

> Example below demonstrates the second option. It creates an image stream in the **`shared`**
project and uses that image stream to deploy an application in the **`myapp`** project.

```zsh
$ podman login -u myuser registry.example.com
$ oc project shared
```
```zsh
$ oc create secret generic regtoken \
    --from-file .dockerconfigjson=${XDG_RUNTIME_DIR}/containers/auth.json \ 
    --type kubernetes.io/dockerconfigjson
```
```zsh
$ oc import-image myis --confirm \
         --reference-policy local \
         --from registry.example.com/myorg/myimage
```
```zsh
$ oc policy add-role-to-group system:image-puller \ 
               system:serviceaccounts:myapp
```
```zsh
$ oc project myapp
$ oc new-app --as-deployment-config -i shared/myis
```
- The **`--reference-policy local`** option of the **`oc import-image`** command configures the image stream to cache image layers in the internal registry, so projects that reference the image stream do not need an access token to the external private registry.
- The **`system:image-puller`** role allows a service account to pull the image layers that the image stream cached in the internal registry.
- The **`system:serviceaccounts:myapp`** group includes all service accounts from the **`myapp`** project. 
- The **`oc policy`** command can refer to users and groups that do not exist yet.


