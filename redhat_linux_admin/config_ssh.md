# **`Abstract`**

-  **Table of contents**:
  - [Introduction](#introduction)
  - [Example Commands](#example-commands)



##### **`Introduction`**

**`SSH protocol`** enables systems to communicate in an encrypted and secure manner,over an
insecure network.
- You can use the **`ssh`** command to create a secure connection to a remote system,**` authenticate`**
as a specific user, and get an interactive shell session on the remote system as that user.
-  You may also use the **`ssh`** command to run an individual command on the remote system without running
an interactive shell.

##### **`Example Commands`**
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
> Run the **`hostname`** command on the remotehost as the
**`user02`** without accessing the remote interactive shell.

```zsh
[user01@host ~]$ ssh user02@remotehost hostname
user02@remotehost's password: shadowman
```


Use the **`w `**command to display a list of users currently logged into the computer. This will show users are logged in using **`SSH`** from which remote locations, and what they are doing.

```zsh
[user01@host ~]$ ssh user01@remotehost
user01@remotehost's password: redhat
[user01@remotehost ~]$ w
16:13:38 up 36 min, 1 user, load average: 0.00, 0.00, 0.00

USER TTY FROM LOGIN@ IDLE JCPU PCPU WHAT
user02 pts/0 172.25.250.10 16:13 7:30 0.01s 0.01s -bash
user01 pts/1 172.25.250.10 16:24 3.00s 0.01s 0.00s w
[user02@remotehost ~]$ 
```