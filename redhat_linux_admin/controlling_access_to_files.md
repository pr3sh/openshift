# **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding File and Directory Permissions](#understanding-file-and-directory-permissions)

## **`Introduction`:**
Files have *three* user categories to which permissions apply:
1. The file is owned by a **`user`**.
2. The file is also owned by a single **`group`**.
3. Different permissions can be set for the owning user, the owning **`group`**, and for all **`other`** users on the system that are not the user or a member of the owning **`group`**.

>  *User permissions override group permissions, which override other permissions.*

#### **`Understanding File and Directory Permissions`:**

1. **`r`** **(read)**:
  - **Effect on files**: Contents can be read.
  - **Effect on Directories**: Contents can be listed.

2. **`w`** **(write)**:
  - **Effect on files**: Contents can be changed.
  - **Effect on Directories**: Files can be created or deleted within directory.

1. **`x`** **(execute)**:
  - **Effect on files**: Can be executed as commands.
  - **Effect on Directories**: You can **`cd`** into directory, but needs **`read`** permissions to list contents.