# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Introduction](#introduction)
  - [The S2I Tool](#the-s2i-tool)
  - [Building Nginx Image](#building-nginx-image)

##### **`Introduction`**:
- The **`S2I`** build process combines application source code with an appropriate S2I builder image to produce the final application container image that is deployed to an Red Hat OpenShift Container Platform (RHOCP) cluster.
- Before deploying the **`S2I builder image`** to an RHOCP cluster, where other developers can use it for building applications, it is important to build and test the image using the s2i command-line tool. Install the **`s2i tool`** on your local machine to build and test your S2I builder images outside of an RHOCP cluster. 

> *Basics*
Create the template files required to create a new **`S2I builder image`**:

##### **`The S2I Tool`**:
```zsh
[user@host ~]$ s2i create <image-name> <directory>
```
A folder with your **`<directory>`** is created. 
```text
directory
├── Dockerfile 
├── Makefile
├── README.md
├── s2i 
│   └── bin
│       ├── assemble
│       ├── run
│       ├── save-artifacts
│       └── usage
└── test
    ├── run
    └── test-app 
        └── index.html
```

After you are done updating your **`Dockerfile`** and s2i scripts, you can build your image
```zsh
podman build -t builder_image .
```
- When the builder image is ready, you can build an application container image using the **`s2i build`** command. 
- This allows you to test the **`S2I builder image`** locally, without the need to push it to a registry server and deploy an application using the builder image to an RHOCP cluster.
```zsh
[user@host ~]$ s2i build src builder_image tag_name
```
- The **`s2i build`** command requires the use of a local **`Docker`** service because it uses the **`Docker API`** directly via the socket to build the **`S2I`** container image. 
- To provide support for environments that do not have **`Docker`** available, the s2i build command now includes the **`--as-dockerfile`** `path/to/Dockerfile` option.
- For incremental builds, be sure to create a **`save-artifacts`** script and pass the **`--incremental`** flag to the **`s2i build`** command.

##### **`Build an Nginx Image`**:




```zsh
s2i create s2i-do288-nginx s2i-do288-nginx
```
- Edit **`Dockerfile`** to include instructions to install **nginx**.

```Dockerfile
FROM registry.access.redhat.com/ubi8/ubi:8.0  

ENV X_SCLS="rh-nginx18" \
    PATH="/opt/rh/rh-nginx18/root/usr/sbin:$PATH" \
    NGINX_DOCROOT="/opt/rh/rh-nginx18/root/usr/share/nginx/html"

LABEL io.k8s.description="A Nginx S2I builder image" \ 
      io.k8s.display-name="Nginx 1.8 S2I builder image for DO288" \
      io.openshift.expose-services="8080:http" \
      io.openshift.s2i.scripts-url="image:///usr/libexec/s2i" \
      io.openshift.tags="builder,webserver,nginx,nginx18,html"

ADD nginxconf.sed /tmp/
COPY ./.s2i/bin/ /usr/libexec/s2i 

RUN yum install -y --nodocs rh-nginx18 \ 
  && yum clean all \
  && sed -i -f /tmp/nginxconf.sed /etc/opt/rh/rh-nginx18/nginx/nginx.conf \
  && chgrp -R 0 /var/opt/rh/rh-nginx18 /opt/rh/rh-nginx18 \ 
  && chmod -R g=u /var/opt/rh/rh-nginx18 /opt/rh/rh-nginx18 \ 
  && echo 'Hello from the Nginx S2I builder image' > ${NGINX_DOCROOT}/index.html

EXPOSE 8080

USER 1001

CMD ["/usr/libexec/s2i/usage"]
```
- Create **`assemble`** script.
```bash
#!/bin/bash -e

echo "---> Copying source HTML files to web server root..."
cp -Rf /tmp/src/. /opt/rh/rh-nginx18/root/usr/share/nginx/html/
```
- Create **`run`** script.
```bash
#!/bin/bash -e

exec nginx -g "daemon off;"
```
- Use **podman** to build the builder image.
```zsh
podman build -t s2i-do288-nginx .
```
- Build a test application container image.
```zsh
s2i build test/test-app s2i-do288-nginx nginx-test \
--as-docker-file /path/to/Dockerfile
```
-  Build test container image with podman
```zsh
podman build -t nginx-test /path/to/Dockerfile
```
- Test image with different  **`UID`** than the one provided in **`Dockerfile`** to ensure container image can run with Random**`UID`**.
```zsh
podman run -u 1234 -d -p 8080:8080 nginx-test
```


#### **`Making the S2I Builder Image Available to RHOCP`**
> *After you test the container locally, push the S2I builder image to an enterprise registry.*
```zsh
[user@host ~]$ skopeo copy containers-storage:localhost/s2i-do288-httpd \
docker://quay.io/${RHT_OCP4_QUAY_USER}/s2i-do288-httpd
```
- create an **`ImageStream`** for the Nginx S2I builder image
```zsh
[user@host ~]$ oc import-image s2i-do288-nginx \
--from quay.io/${RHT_OCP4_QUAY_USER}/s2i-do288-nginx \
--confirm
```