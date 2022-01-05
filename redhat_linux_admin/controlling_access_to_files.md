# **Table of contents**:
  - [Introduction](#introduction)
  - [Understanding File and Directory Permissions](#understanding-file-and-directory-permissions)
  - [Changing File and Directory Permissions](#changing-file-and-directory-permissions)
    - [Chmod Examples](#chmod-examples)
    - [Changing Permissions with the Numeric Method](#changing-permissions-with-numeric-method)
  - [Changing File and Directory Ownership](#changing-file-and-directory-ownership)

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

3. **`x`** **(execute)**:
  - **Effect on files**: Can be executed as commands.
  - **Effect on Directories**: You can **`cd`** into directory, but needs **`read`** permissions to list contents.

> View the detailed file info using **`-l`**.

```zsh
[user@host ~]$ ls -l test
-rw-rw-r--. 1 student student 0 Feb 8 17:36 test
```

> Use **`-d`** to view the detailed file info of a directory (*not its contents*).

```zsh
[user@host ~]$ ls -l test
-rw-rw-r--. 1 student student 0 Feb 8 17:36 test
```

> The first symbol from the returned result lets us know the following.

- **`-`**  *regular file*
- **`d`** *directory*
- **`l`**  *soft link*
- Other characters represent hardware devices ( *i.e* **`b`** and **`c`**) 
- The next nine characters are the file permissions.

#### **`Changing File and Directory Permissions`**:

**`chmod <WhoWhatWhich> file|directory`**

- **Who**: **`u`**, **`g`**, **`o`**, **`a`** 
- **What**: **`+`**, **`-`**, **`=`** 
- **Which**: **`r`**, **`w`**, **`x`** 

> Use **`+`** or **`-`** to *add* or *remove* permissions. Use **`=`** to replace the entire set for a group of permissions.
> Using a capital **`X`** as the *permission flag* will add **execute** permission *only if* the file is a directory or already has execute set for **`user`**, **`group`**, or **`other`**.

###### **`Chmod Examples`**:

> Remove **`read`** and **`write`** permissions from **`file`**.

```zsh
[user@host ~]$ chmod go-rw file1
```

> Add **`execute`** permissions to **`file2`**.

```zsh
[user@host ~]$ chmod a+x file2
```

###### **`Changing Permissions with the Numeric Method`**:

To change permissiosn using numeric method execute **`chmod xxx file|directory`**.
- Each digit represents permissions for an access level(in 3-digit octal): **`user`**, **`group`**, **`other`**.
- The digit is calculated by adding together numbers for each permission you want to add.

> *Number Representations:*
 - **`4`** *read*
 - **`2`** *write*
 - **`1`** *execute*


 > Give **`rwx`** permissions to user, **`r-x`** to group, and **`---`** to others

 ```zsh
[user@host ~]$ chmod 750 testdir
 ```

###### **`Changing File and Directory Ownership`**:

- Only **`root`** can change the user that owns a file. 
- Group ownerships can be set by **`root`** or by the file's owner. 
- **`root`** can grant file ownership to any **`group`**, but regular users can make a **`group`** the owner of a file. only if they are a member of that group.

> *To change file ownership use chown:*
  - **`chown [-fhnv] [-R [-H | -L | -P]] owner[:group] file ...`**
  - **`chown [-fhnv] [-R [-H | -L | -P]] :group file ...`**







