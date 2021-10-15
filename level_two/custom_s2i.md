# **`Abstract`**

This document goes over Helm charts.
-  **`Table of contents`**:
  - [Introduction](#introduction)

- The **`S2I`** build process combines application source code with an appropriate S2I builder image to produce the final application container image that is deployed to an Red Hat OpenShift Container Platform (RHOCP) cluster.
- Before deploying the **`S2I builder image`** to an RHOCP cluster, where other developers can use it for building applications, it is important to build and test the image using the s2i command-line tool. Install the s2i tool on your local machine to build and test your S2I builder images outside of an RHOCP cluster. 


Use the s2i create command to create the template files required to create a new S2I builder image: