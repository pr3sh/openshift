# **`Abstract`**

-  **Table of contents**:
  - [Introduction](#introduction)



##### **`Introduction`**

**`SSH protocol`** enables systems to communicate in an encrypted and secure manner,over an
insecure network.
- You can use the **`ssh`** command to create a secure connection to a remote system,**` authenticate`**
as a specific user, and get an interactive shell session on the remote system as that user.
-  You may also use the **`ssh`** command to run an individual command on the remote system without running
an interactive shell.

> Log into remote server as the current local user (**`user01`**). You'll be prompted to enter that user's password.

```zsh
[user01@host ~]$ ssh remotehost
> user01@remotehost's password: redhat
```

> Log into remote server as **`user02`**.
```zsh
[user01@host ~]$ ssh user02@remotehost
> user02@remotehost's password: shadowman
```