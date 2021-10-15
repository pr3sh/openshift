# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Introduction](#introduction)

- The **`S2I`** build process combines application source code with an appropriate S2I builder image to produce the final application container image that is deployed to an Red Hat OpenShift Container Platform (RHOCP) cluster.
- Before deploying the **`S2I builder image`** to an RHOCP cluster, where other developers can use it for building applications, it is important to build and test the image using the s2i command-line tool. Install the **`s2i tool`** on your local machine to build and test your S2I builder images outside of an RHOCP cluster. 


> *Basics*
Create the template files required to create a new **`S2I builder image`**:

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
F- or incremental builds, be sure to create a **`save-artifacts`** script and pass the **`--incremental`** flag to the **`s2i build`** command.