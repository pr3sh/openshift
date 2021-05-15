# Abstract
The primary objective of this guide is to demonstrate how multi-contianer applications are deployed on OpenShift, using a template.
-  **Table of contents**:
  - [Introduction](#introduction)


- Build the **`MySQL`** database image.
- To make the image available in **`OpenShift`**, you must log into **`Quay.io`**, tag, and push it.
- Build the base image for the todolist application, tag, and push it to **`Quay.io`**